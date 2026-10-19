# DỰ ÁN ROOT_Project (Web Lấy Ảnh Tự Động)

Dự án Java Web (JSP / Servlet) tách riêng và nâng cấp toàn diện từ `lay_anh/ROOT`, phục vụ việc chỉnh sửa giao diện và logic chức năng.

---

## 📁 Cấu Trúc Thư Mục

```text
ROOT_Project/
├── src/
│   └── Controller/
│       └── tcController.java      # Mã nguồn Java gốc xử lý toàn bộ logic (hỗ trợ doGet & doPost, stream ZIP 64KB)
├── index.jsp                      # File điều hướng ban đầu -> chuyển tiếp sang tcController
├── tc.jsp                         # Giao diện chính: Pinch-to-zoom kiểu Google Drive, bộ lọc không dấu, tải ảnh
├── tuan.jpg                       # Logo đã tối ưu siêu nhẹ (4.6 KB thay vì 10 MB)
├── WEB-INF/
│   ├── web.xml                    # Cấu hình Web Servlet Descriptor 4.0
│   ├── classes/
│   │   └── Controller/
│   │       ├── tcController.class             # Bytecode đã biên dịch
│   │       └── tcController$ImageModel.class  # Model ảnh (thumb, hd, link gốc)
│   └── lib/
│       └── servlet-api.jar        # Thư viện Servlet API dùng để biên dịch lại mã nguồn
├── META-INF/
│   └── MANIFEST.MF
├── build.bat                      # Script 1-click tự động biên dịch src -> WEB-INF/classes
├── package_war.bat                # Script 1-click đóng gói toàn bộ thành ROOT.war (~290 KB)
└── README.md                      # Tài liệu hướng dẫn
```

---

## 🚀 Các Tính Năng Nâng Cấp Mới (Google Drive Style)

### 1. Xem Ảnh & Phóng To Thu Nhỏ (Interactive Photo Viewer):
- **Phóng to / Thu nhỏ bằng 2 ngón tay (Pinch-to-zoom)**: Hỗ trợ mượt mà trên điện thoại cảm ứng và tablet.
- **Kéo rê ảnh khi zoom (Pan & Drag)**: Dùng 1 ngón tay hoặc chuột kéo ảnh để soi chi tiết từng góc ảnh khi phóng to.
- **Con lăn chuột (Mouse Wheel)**: Lăn chuột lên để phóng to vào vị trí con trỏ chuột, lăn xuống để thu nhỏ.
- **Nhấp đúp (Double-tap / Double-click)**: Nhấp đúp để phóng to nhanh 2.5x, nhấp đúp lần nữa để đưa về vừa màn hình.
- **Thanh công cụ**: Có nút `+`, `-`, nút hiển thị tỷ lệ `%` và nút reset nhanh `100%`.
- **Phím tắt máy tính**: `+`, `-`, phím `0` (reset), `Phím cách` (chọn ảnh), `Mũi tên Trái/Phải` (chuyển ảnh), `Esc` (đóng).

### 2. Cơ Chế Tải Ảnh Thông Minh (Smart Download):
- **Chọn 1 ảnh**: Nút chuyển thành *"Tải 1 ảnh (Trực tiếp)"* -> Tải ngay file ảnh gốc, không mất công nén ZIP hay giải nén.
- **Chọn nhiều ảnh (> 1)**: Nút chuyển thành *"Tải X ảnh (Nén ZIP)"* -> Nén tốc độ cao (Deflater BEST_SPEED, buffer 64KB) và stream trực tiếp về máy.
- **Tải nhanh trên từng ảnh**: Có nút tải nhanh ngay trên góc từng thẻ ảnh khi rê chuột qua.
- **Đã khắc phục lỗi `HTTP 405 Method Not Allowed`**: Bổ sung `doPost` trong Servlet, tương thích hoàn toàn với form gửi dữ liệu.

### 3. Tối Ưu Tốc Độ Tải Ảnh (Ultra-fast Loading):
- **Lưới ảnh**: 6 ảnh đầu tiên dùng `fetchpriority="high"`, các ảnh sau dùng `loading="lazy"` + `decoding="async"`.
- **Thumbnail nhẹ**: Lưới card dùng link thumbnail kích thước 400px (chỉ ~25KB mỗi ảnh), giúp tải 100 ảnh trong tích tắc.
- **Modal Progressive Load**: Mở modal là hiển thị ngay thumbnail từ bộ nhớ đệm (0ms), sau đó tự động nâng cấp lên bản HD siêu nét mà không bị giật lag.
- **Logo siêu nhẹ**: File `tuan.jpg` giảm từ 10 MB xuống 4.6 KB.

---

## 🛠 Hướng Dẫn Thao Tác

1. **Sửa giao diện**: Mở file [tc.jsp](file:///f:/web_lấy%20ảnh%20link/ROOT_Project/tc.jsp) và lưu lại (không cần biên dịch lại).
2. **Sửa code Java**: Mở file [tcController.java](file:///f:/web_lấy%20ảnh%20link/ROOT_Project/src/Controller/tcController.java), sau đó nhấp đúp vào [build.bat](file:///f:/web_lấy%20ảnh%20link/ROOT_Project/build.bat) để biên dịch.
3. **Đóng gói WAR**: Nhấp đúp vào [package_war.bat](file:///f:/web_lấy%20ảnh%20link/ROOT_Project/package_war.bat) để tạo file `ROOT.war` sẵn sàng deploy lên máy chủ/Docker.
