/**
 * =========================================================================
 * GOOGLE APPS SCRIPT CHO HỆ THỐNG STUDIO TUẤN HOA (0388.520.391)
 * =========================================================================
 * Hướng dẫn cài đặt cực nhanh trong 1 phút:
 * 1. Mở file Google Sheets quản lý ảnh của bạn (hoặc tạo Google Sheets mới).
 * 2. Trên thanh menu, chọn: Tiện ích mở rộng (Extensions) -> Apps Script.
 * 3. Xóa hết code cũ (nếu có) và DÁN TOÀN BỘ file code này vào.
 * 4. Bấm "Lưu" (biểu tượng đĩa mềm hoặc Ctrl+S).
 * 5. Bấm nút "Triển khai" (Deploy) -> "Tùy chọn triển khai mới" (New deployment).
 *    - Chọn loại: "Ứng dụng web" (Web app).
 *    - Mô tả: "Studio Tuấn Hoa API v2".
 *    - Thực thi dưới dạng: "Tôi" (Me).
 *    - Ai có quyền truy cập: "Bất kỳ ai" (Anyone) -> RẤT QUAN TRỌNG!
 * 6. Bấm "Triển khai" -> Cấp quyền truy cập nếu Google hỏi -> Copy link Web App (.exec).
 * 7. Dán link Web App đó vào ô Cài đặt trong trang Quản trị Admin.
 * =========================================================================
 */

// Tên các Sheet dữ liệu
const SHEET_ORDERS = "Don_Chot_Anh";
const SHEET_ALBUMS = "Danh_Sach_Album";

function doGet(e) {
  return handleRequest(e, "GET");
}

function doPost(e) {
  return handleRequest(e, "POST");
}

function handleRequest(e, method) {
  const lock = LockService.getScriptLock();
  try {
    lock.waitLock(15000);
  } catch (err) {
    return jsonResponse({ status: "error", message: "Hệ thống bận, vui lòng thử lại sau vài giây!" });
  }

  try {
    const action = (e && e.parameter && e.parameter.action) ? e.parameter.action : "";
    let payload = {};

    if (e && e.postData && e.postData.contents) {
      try {
        payload = JSON.parse(e.postData.contents);
      } catch (err) {
        payload = e.parameter || {};
      }
    } else if (e && e.parameter && e.parameter.payload) {
      try {
        payload = JSON.parse(e.parameter.payload);
      } catch (err) {
        payload = e.parameter;
      }
    } else if (e && e.parameter) {
      payload = e.parameter;
    }

    const ss = SpreadsheetApp.getActiveSpreadsheet();

    // -------------------------------------------------------------
    // 1. LẤY DANH SÁCH ĐƠN CHỐT ẢNH CỦA KHÁCH
    // -------------------------------------------------------------
    if (action === "get_orders") {
      const sheet = getOrCreateOrdersSheet(ss);
      const data = sheet.getDataRange().getValues();
      if (data.length <= 1) {
        return jsonResponse([]);
      }

      const headers = data[0];
      const orders = [];
      for (let i = 1; i < data.length; i++) {
        const row = data[i];
        if (!row[0] && !row[1] && !row[2]) continue;

        let notesObj = {};
        try {
          if (row[7]) notesObj = JSON.parse(row[7]);
        } catch (ex) {
          notesObj = row[7] || "";
        }

        orders.push({
          rowIndex: i + 1,
          orderId: row[0] || ("ORD-" + (i)),
          time: row[1] || "",
          clientName: row[2] || "Khách hàng",
          clientPhone: row[3] || "",
          folderId: row[4] || "",
          selectedCount: row[5] || 0,
          orString: row[6] || "",
          notes: notesObj,
          generalNote: row[8] || "",
          status: row[9] || "Mới nhận"
        });
      }
      // Đơn mới nhất lên đầu
      orders.reverse();
      return jsonResponse(orders);
    }

    // -------------------------------------------------------------
    // 2. LƯU ĐƠN CHỐT ẢNH MỚI (TỪ WEB KHÁCH GỬI VỀ)
    // -------------------------------------------------------------
    if (action === "save_order") {
      const sheet = getOrCreateOrdersSheet(ss);
      const now = new Date();
      const timeStr = Utilities.formatDate(now, "GMT+7", "dd/MM/yyyy HH:mm:ss");
      const orderId = "ORD-" + Utilities.formatDate(now, "GMT+7", "yyMMdd-HHmmss");

      const clientName = payload.clientName || payload.name || "Khách lẻ";
      const clientPhone = payload.clientPhone || payload.phone || "";
      const folderId = payload.folderId || "";
      const selectedCount = payload.selectedCount || 0;
      const orString = payload.orString || "";
      const notesJson = typeof payload.notes === "object" ? JSON.stringify(payload.notes) : (payload.notes || "");
      const generalNote = payload.generalNote || "";
      const status = "Mới nhận";

      sheet.appendRow([
        orderId,
        timeStr,
        clientName,
        "'" + clientPhone,
        folderId,
        selectedCount,
        orString,
        notesJson,
        generalNote,
        status
      ]);

      return jsonResponse({
        status: "success",
        message: "Lưu đơn chốt ảnh thành công!",
        orderId: orderId,
        time: timeStr
      });
    }

    // -------------------------------------------------------------
    // 3. CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG (MỚI NHẬN -> ĐANG SỬA -> HOÀN THÀNH)
    // -------------------------------------------------------------
    if (action === "update_order_status") {
      const sheet = getOrCreateOrdersSheet(ss);
      const rowIndex = parseInt(payload.rowIndex || e.parameter.rowIndex, 10);
      const newStatus = payload.status || e.parameter.status || "Đang sửa";

      if (rowIndex && rowIndex > 1 && rowIndex <= sheet.getLastRow()) {
        sheet.getRange(rowIndex, 10).setValue(newStatus);
        return jsonResponse({ status: "success", message: "Đã cập nhật trạng thái đơn!" });
      }
      return jsonResponse({ status: "error", message: "Không tìm thấy hàng cần sửa!" });
    }

    // -------------------------------------------------------------
    // 4. LẤY DỮ LIỆU ALBUM (TƯƠNG THÍCH HOÀN TOÀN GETADMINDATA CŨ)
    // -------------------------------------------------------------
    if (action === "getAdminData" || action === "get_albums") {
      const sheet = getOrCreateAlbumsSheet(ss);
      const data = sheet.getDataRange().getValues();
      if (data.length <= 1) {
        return jsonResponse([]);
      }

      const albums = [];
      for (let i = 1; i < data.length; i++) {
        const row = data[i];
        if (!row[0] && !row[1] && !row[2]) continue;

        albums.push({
          rowIndex: i + 1,
          time: row[0] || "",
          id: row[1] || "",
          name: row[2] || "Album mới",
          thumb: row[3] || "",
          qty: row[4] || 0,
          coverIndex: row[5] || 0,
          clientPhone: row[6] || "",
          note: row[7] || ""
        });
      }
      albums.reverse();
      return jsonResponse(albums);
    }

    // -------------------------------------------------------------
    // 5. TẠO ALBUM MỚI (LƯU VÀO GOOGLE SHEET)
    // -------------------------------------------------------------
    if (action === "create_album") {
      const sheet = getOrCreateAlbumsSheet(ss);
      const now = new Date();
      const timeStr = Utilities.formatDate(now, "GMT+7", "yyyy-MM-dd'T'HH:mm:ss.000'Z'");

      const id = payload.id || payload.folderId || "";
      const name = payload.name || payload.albumName || "Album mới";
      const thumb = payload.thumb || "";
      const qty = payload.qty || 0;
      const clientPhone = payload.clientPhone || payload.phone || "";
      const note = payload.note || "";

      sheet.appendRow([
        timeStr,
        id,
        name,
        thumb,
        qty,
        qty * 10000,
        "'" + clientPhone,
        note
      ]);

      return jsonResponse({
        status: "success",
        message: "Tạo album mới thành công!",
        id: id,
        name: name
      });
    }

    // -------------------------------------------------------------
    // 6. CẬP NHẬT ALBUM (TƯƠNG THÍCH CODE CŨ CỦA BẠN)
    // -------------------------------------------------------------
    if (action === "updateAlbum") {
      const sheet = getOrCreateAlbumsSheet(ss);
      const rowIndex = parseInt(payload.rowIndex || e.parameter.rowIndex, 10);
      const newName = payload.name || e.parameter.name || "";
      const newThumb = payload.thumb || e.parameter.thumb || "";

      if (rowIndex && rowIndex > 1 && rowIndex <= sheet.getLastRow()) {
        if (newName) sheet.getRange(rowIndex, 3).setValue(newName);
        if (newThumb) sheet.getRange(rowIndex, 4).setValue(newThumb);
        return jsonResponse({ status: "success", message: "Đã cập nhật album!" });
      }
      return jsonResponse({ status: "error", message: "Không tìm thấy hàng cần sửa!" });
    }

    // -------------------------------------------------------------
    // 7. XÓA ALBUM
    // -------------------------------------------------------------
    if (action === "deleteAlbum") {
      const sheet = getOrCreateAlbumsSheet(ss);
      const rowIndex = parseInt(payload.rowIndex || e.parameter.rowIndex, 10);
      if (rowIndex && rowIndex > 1 && rowIndex <= sheet.getLastRow()) {
        sheet.deleteRow(rowIndex);
        return jsonResponse({ status: "success", message: "Đã xóa album!" });
      }
      return jsonResponse({ status: "error", message: "Không tìm thấy hàng cần xóa!" });
    }

    // Nếu không khớp action nào
    return jsonResponse({ status: "ready", message: "Google Apps Script Studio Tuấn Hoa đang hoạt động tốt!" });

  } catch (error) {
    return jsonResponse({ status: "error", message: error.toString() });
  } finally {
    lock.releaseLock();
  }
}

// Hàm hỗ trợ tạo Sheet Đơn Chốt Ảnh nếu chưa có
function getOrCreateOrdersSheet(ss) {
  let sheet = ss.getSheetByName(SHEET_ORDERS);
  if (!sheet) {
    sheet = ss.insertSheet(SHEET_ORDERS);
    const headers = [
      "Mã Đơn",
      "Thời Gian Chốt",
      "Tên Khách Hàng",
      "Số Điện Thoại / Zalo",
      "Folder Drive ID",
      "Số Lượng Ảnh",
      "Mã Tìm Kiếm OR (Windows)",
      "Chi Tiết Ghi Chú Từng Ảnh (JSON)",
      "Dặn Dò Chung",
      "Trạng Thái"
    ];
    sheet.appendRow(headers);
    sheet.getRange(1, 1, 1, headers.length).setFontWeight("bold").setBackground("#1e293b").setFontColor("#38bdf8");
    sheet.setFrozenRows(1);
  }
  return sheet;
}

// Hàm hỗ trợ tạo Sheet Album nếu chưa có
function getOrCreateAlbumsSheet(ss) {
  let sheet = ss.getSheetByName(SHEET_ALBUMS);
  if (!sheet) {
    // Nếu có sheet mặc định (thường là Sheet1 hoặc Trang tính1 có dữ liệu cũ)
    const allSheets = ss.getSheets();
    if (allSheets.length > 0 && allSheets[0].getName() !== SHEET_ORDERS) {
      sheet = allSheets[0];
    } else {
      sheet = ss.insertSheet(SHEET_ALBUMS);
      const headers = ["Thời Gian", "Folder ID", "Tên Album", "Ảnh Bìa", "Số Lượng Ảnh", "Cover Index", "SĐT Khách", "Ghi Chú"];
      sheet.appendRow(headers);
      sheet.getRange(1, 1, 1, headers.length).setFontWeight("bold").setBackground("#1e293b").setFontColor("#38bdf8");
      sheet.setFrozenRows(1);
    }
  }
  return sheet;
}

// Trả về JSON chuẩn kèm CORS Header
function jsonResponse(data) {
  return ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);
}
