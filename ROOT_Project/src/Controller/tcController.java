package Controller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.CookieHandler;
import java.net.CookieManager;
import java.net.CookiePolicy;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.Deflater;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "tcController", urlPatterns = {"/tcController"})
public class tcController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    static {
        try {
            // Tự động duy trì cookie qua các chuyển hướng 302 của Google Apps Script
            CookieHandler.setDefault(new CookieManager(null, CookiePolicy.ACCEPT_ALL));
        } catch (Exception ignored) {}
    }

    // Bộ nhớ đệm album siêu tốc trong RAM (TTL 10 phút) giúp xem thử & mở album tức thì, chống quá tải Google Drive
    private static class CacheEntry {
        final List<ImageModel> images;
        final long timestamp;
        CacheEntry(List<ImageModel> images) {
            this.images = new ArrayList<>(images);
            this.timestamp = System.currentTimeMillis();
        }
        boolean isValid() {
            return (System.currentTimeMillis() - timestamp) < (10 * 60 * 1000L); // 10 phút
        }
    }
    private static final ConcurrentHashMap<String, CacheEntry> ALBUM_CACHE = new ConcurrentHashMap<>();

    // Thread pool dùng chung cho các tác vụ ghi log ngầm (chống cạn kiệt thread máy chủ)
    private static final ExecutorService LOG_EXECUTOR = Executors.newFixedThreadPool(2);

    // Link Google Apps Script quét ảnh từ Google Drive
    private static final String LINK_SCAN_DRIVE = "https://script.google.com/macros/s/AKfycbzk9-pwLjJhNLD1y3ass22-UG9bWwdVleUh95SS2tiFMG_LUZ2NjJUOZ2snVbMM6Glc/exec";
    
    // Link Google Apps Script ghi log admin & album studio (30 albums)
    private static final String LINK_ADMIN_API = "https://script.google.com/macros/s/AKfycbziBHUHWExJRpDh4Y_SSPNtMjl9NPaM80nql9nRwakg3TViR4dXy4EeCD9GS_9nkV1m/exec";

    // Kích thước buffer đọc ghi dữ liệu tối ưu (64 KB)
    private static final int BUFFER_SIZE = 65536;

    /**
     * Model đại diện cho một bức ảnh với các phiên bản kích thước tối ưu
     */
    public static class ImageModel {
        public String name;
        public String link;        // Link ảnh gốc (dùng để tải)
        public String thumbLink;   // Link thumbnail nhỏ siêu nhẹ (dùng cho lưới danh sách ảnh)
        public String hdLink;      // Link ảnh chất lượng cao (dùng cho modal xem phóng to)

        public ImageModel(String name, String link) {
            this.name = name;
            this.link = link;
            this.thumbLink = toThumbnailLink(link);
            this.hdLink = toHdLink(link);
        }

        private static String toThumbnailLink(String url) {
            if (url == null || url.isEmpty()) return "";
            // Sử dụng =s600 (giữ nguyên 100% tỷ lệ gốc, KHÔNG dùng cờ crop '-c' để tránh bị xén ảnh khi xem trước)
            if (url.contains("=w") || url.contains("=s") || url.contains("=h")) {
                return url.replaceAll("=(w|s|h)[0-9]+[^&]*", "=s600");
            }
            if (url.contains("googleusercontent.com")) {
                return url + "=s600";
            }
            return url;
        }

        private static String toHdLink(String url) {
            if (url == null || url.isEmpty()) return "";
            // =s1600: Chất lượng cao sắc nét chuẩn Retina/1080p, giữ 100% tỷ lệ gốc, tải nhanh gấp 5 lần =w2048
            if (url.contains("=w") || url.contains("=s") || url.contains("=h")) {
                return url.replaceAll("=(w|s|h)[0-9]+[^&]*", "=s1600");
            }
            if (url.contains("googleusercontent.com")) {
                return url + "=s1600";
            }
            return url;
        }
    }

    /**
     * Model đại diện cho một đơn chốt ảnh của khách hàng (lưu trữ trung tâm trên máy chủ)
     */
    public static class OrderRecord {
        public String orderId;
        public String folderId;
        public String clientName;
        public String clientPhone;
        public String generalNote;
        public int selectedCount;
        public String orString;
        public String notesJson;
        public String status;
        public String time;
        public String submittedAt;

        public OrderRecord() {}

        public OrderRecord(String orderId, String folderId, String clientName, String clientPhone,
                           String generalNote, int selectedCount, String orString, String notesJson,
                           String status, String time, String submittedAt) {
            this.orderId = orderId;
            this.folderId = folderId;
            this.clientName = clientName;
            this.clientPhone = clientPhone;
            this.generalNote = generalNote;
            this.selectedCount = selectedCount;
            this.orString = orString;
            this.notesJson = notesJson;
            this.status = status;
            this.time = time;
            this.submittedAt = submittedAt;
        }

        public String toJson(int rowIndex) {
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"rowIndex\":").append(rowIndex).append(",");
            sb.append("\"orderId\":").append(escapeJson(orderId)).append(",");
            sb.append("\"folderId\":").append(escapeJson(folderId)).append(",");
            sb.append("\"clientName\":").append(escapeJson(clientName)).append(",");
            sb.append("\"clientPhone\":").append(escapeJson(clientPhone)).append(",");
            sb.append("\"generalNote\":").append(escapeJson(generalNote)).append(",");
            sb.append("\"selectedCount\":").append(selectedCount).append(",");
            sb.append("\"orString\":").append(escapeJson(orString)).append(",");
            sb.append("\"notes\":").append(notesJson != null && !notesJson.trim().isEmpty() ? notesJson : "{}").append(",");
            sb.append("\"status\":").append(escapeJson(status != null ? status : "Mới nhận")).append(",");
            sb.append("\"time\":").append(escapeJson(time)).append(",");
            sb.append("\"submittedAt\":").append(escapeJson(submittedAt));
            sb.append("}");
            return sb.toString();
        }
    }

    private static final List<OrderRecord> ORDER_STORE = new CopyOnWriteArrayList<>();
    private static volatile boolean ordersInitialized = false;

    private static synchronized void ensureOrdersLoaded(HttpServletRequest req) {
        if (ordersInitialized) return;
        File file = getOrdersFile(req);
        if (file != null && file.exists() && file.length() > 0) {
            loadOrdersFromFile(file);
        }
        if (ORDER_STORE.isEmpty() && req != null && req.getServletContext() != null) {
            try (InputStream is = req.getServletContext().getResourceAsStream("/WEB-INF/orders.json")) {
                if (is != null) {
                    loadOrdersFromStream(is);
                }
            } catch (Exception ignored) {}
        }
        if (file != null) {
            saveOrdersToFile(file);
        }
        ordersInitialized = true;
    }

    private static File getOrdersFile(HttpServletRequest req) {
        try {
            if (req != null && req.getServletContext() != null) {
                String path = req.getServletContext().getRealPath("/WEB-INF/orders.json");
                if (path != null) {
                    File f = new File(path);
                    if (f.getParentFile() != null && f.getParentFile().exists()) {
                        return f;
                    }
                }
            }
        } catch (Exception ignored) {}
        return new File(System.getProperty("java.io.tmpdir"), "studio_orders.json");
    }

    private static synchronized void saveOrdersToFile(File file) {
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(file), StandardCharsets.UTF_8)) {
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < ORDER_STORE.size(); i++) {
                if (i > 0) sb.append(",");
                sb.append(ORDER_STORE.get(i).toJson(i + 1));
            }
            sb.append("]");
            writer.write(sb.toString());
        } catch (Exception e) {
            System.err.println("Lỗi lưu orders.json: " + e.getMessage());
        }
    }

    private static synchronized void loadOrdersFromFile(File file) {
        try (InputStream is = new FileInputStream(file)) {
            loadOrdersFromStream(is);
        } catch (Exception e) {
            System.err.println("Lỗi đọc orders.json: " + e.getMessage());
        }
    }

    private static synchronized void loadOrdersFromStream(InputStream is) {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            parseOrdersJsonString(sb.toString().trim());
        } catch (Exception e) {
            System.err.println("Lỗi đọc orders stream: " + e.getMessage());
        }
    }

    private static void parseOrdersJsonString(String json) {
        if (json.startsWith("[") && json.endsWith("]")) {
            ORDER_STORE.clear();
            int depth = 0;
            int start = -1;
            boolean inString = false;
            for (int i = 0; i < json.length(); i++) {
                char c = json.charAt(i);
                if (c == '"' && (i == 0 || json.charAt(i - 1) != '\\')) {
                    inString = !inString;
                }
                if (!inString) {
                    if (c == '{') {
                        if (depth == 0) start = i;
                        depth++;
                    } else if (c == '}') {
                        depth--;
                        if (depth == 0 && start != -1) {
                            String obj = json.substring(start, i + 1);
                            OrderRecord rec = parseOrderJson(obj);
                            if (rec != null) ORDER_STORE.add(rec);
                            start = -1;
                        }
                    }
                }
            }
        }
    }

    public static OrderRecord parseOrderJson(String json) {
        if (json == null || json.trim().isEmpty()) return null;
        OrderRecord r = new OrderRecord();
        r.orderId = extractJsonField(json, "orderId");
        r.folderId = extractJsonField(json, "folderId");
        r.clientName = extractJsonField(json, "clientName");
        r.clientPhone = extractJsonField(json, "clientPhone");
        r.generalNote = extractJsonField(json, "generalNote");
        r.selectedCount = extractJsonInt(json, "selectedCount", 0);
        r.orString = extractJsonField(json, "orString");
        r.notesJson = extractJsonObjectField(json, "notes");
        r.status = extractJsonField(json, "status");
        if (r.status.isEmpty()) r.status = "Mới nhận";
        r.time = extractJsonField(json, "time");
        r.submittedAt = extractJsonField(json, "submittedAt");
        if (r.time.isEmpty() && !r.submittedAt.isEmpty()) {
            r.time = r.submittedAt;
        }
        return r;
    }

    public static String extractJsonField(String json, String field) {
        Pattern p = Pattern.compile("\"" + Pattern.quote(field) + "\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"");
        Matcher m = p.matcher(json);
        if (m.find()) return unescapeJson(m.group(1));
        return "";
    }

    public static int extractJsonInt(String json, String field, int defaultVal) {
        Pattern p = Pattern.compile("\"" + Pattern.quote(field) + "\"\\s*:\\s*([0-9]+)");
        Matcher m = p.matcher(json);
        if (m.find()) {
            try { return Integer.parseInt(m.group(1)); } catch (Exception ignored) {}
        }
        return defaultVal;
    }

    private static String extractJsonObjectField(String json, String field) {
        int idx = json.indexOf("\"" + field + "\"");
        if (idx == -1) return "{}";
        int colon = json.indexOf(':', idx);
        if (colon == -1) return "{}";
        int brace = json.indexOf('{', colon);
        if (brace == -1) return "{}";
        int depth = 0;
        boolean inString = false;
        for (int i = brace; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == '"' && (i == 0 || json.charAt(i - 1) != '\\')) {
                inString = !inString;
            }
            if (!inString) {
                if (c == '{') depth++;
                else if (c == '}') {
                    depth--;
                    if (depth == 0) return json.substring(brace, i + 1);
                }
            }
        }
        return "{}";
    }

    private static String escapeJson(String s) {
        if (s == null) return "\"\"";
        StringBuilder sb = new StringBuilder("\"");
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < ' ') {
                        String t = "000" + Integer.toHexString(c);
                        sb.append("\\u").append(t.substring(t.length() - 4));
                    } else {
                        sb.append(c);
                    }
            }
        }
        sb.append("\"");
        return sb.toString();
    }

    private static String escapeJsonInner(String s) {
        if (s == null) return "";
        String escaped = escapeJson(s);
        if (escaped.length() >= 2 && escaped.startsWith("\"") && escaped.endsWith("\"")) {
            return escaped.substring(1, escaped.length() - 1);
        }
        return escaped;
    }

    private static String unescapeJson(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '\\' && i + 1 < s.length()) {
                char next = s.charAt(i + 1);
                if (next == '"') { sb.append('"'); i++; }
                else if (next == '\\') { sb.append('\\'); i++; }
                else if (next == '/') { sb.append('/'); i++; }
                else if (next == 'b') { sb.append('\b'); i++; }
                else if (next == 'f') { sb.append('\f'); i++; }
                else if (next == 'n') { sb.append('\n'); i++; }
                else if (next == 'r') { sb.append('\r'); i++; }
                else if (next == 't') { sb.append('\t'); i++; }
                else if (next == 'u' && i + 5 < s.length()) {
                    try {
                        int code = Integer.parseInt(s.substring(i + 2, i + 6), 16);
                        sb.append((char) code);
                        i += 5;
                    } catch (Exception e) {
                        sb.append(c);
                    }
                } else {
                    sb.append(c);
                }
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }

    private static String readRequestBody(HttpServletRequest request) {
        try {
            request.setCharacterEncoding("UTF-8");
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            String body = sb.toString().trim();
            if (body.isEmpty()) {
                body = request.getParameter("orderData");
            }
            return body != null ? body : "";
        } catch (Exception e) {
            return "";
        }
    }

    private static final List<String> CUSTOM_ALBUMS = new CopyOnWriteArrayList<>();
    private static volatile boolean albumsInitialized = false;

    private static synchronized void ensureAlbumsLoaded(HttpServletRequest req) {
        if (albumsInitialized) return;
        File file = getAlbumsFile(req);
        if (file != null && file.exists() && file.length() > 0) {
            loadAlbumsFromFile(file);
        }
        if (CUSTOM_ALBUMS.isEmpty() && req != null && req.getServletContext() != null) {
            try (InputStream is = req.getServletContext().getResourceAsStream("/WEB-INF/albums.json")) {
                if (is != null) {
                    loadAlbumsFromStream(is);
                }
            } catch (Exception ignored) {}
        }
        if (file != null && !CUSTOM_ALBUMS.isEmpty()) {
            saveAlbumsToFile(file);
        }
        albumsInitialized = true;
    }

    private static File getAlbumsFile(HttpServletRequest req) {
        try {
            if (req != null && req.getServletContext() != null) {
                String path = req.getServletContext().getRealPath("/WEB-INF/albums.json");
                if (path != null) {
                    File f = new File(path);
                    if (f.getParentFile() != null && f.getParentFile().exists()) {
                        return f;
                    }
                }
            }
        } catch (Exception ignored) {}
        return new File(System.getProperty("java.io.tmpdir"), "studio_albums.json");
    }

    private static synchronized void saveAlbumsToFile(File file) {
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(file), StandardCharsets.UTF_8)) {
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < CUSTOM_ALBUMS.size(); i++) {
                if (i > 0) sb.append(",");
                sb.append(CUSTOM_ALBUMS.get(i));
            }
            sb.append("]");
            writer.write(sb.toString());
        } catch (Exception e) {
            System.err.println("Lỗi lưu albums.json: " + e.getMessage());
        }
    }

    private static synchronized void loadAlbumsFromFile(File file) {
        try (InputStream is = new FileInputStream(file)) {
            loadAlbumsFromStream(is);
        } catch (Exception e) {
            System.err.println("Lỗi đọc albums.json: " + e.getMessage());
        }
    }

    private static synchronized void loadAlbumsFromStream(InputStream is) {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            parseAlbumsJsonString(sb.toString().trim());
        } catch (Exception e) {
            System.err.println("Lỗi đọc albums stream: " + e.getMessage());
        }
    }

    private static void parseAlbumsJsonString(String json) {
        if (json.startsWith("[") && json.endsWith("]")) {
            CUSTOM_ALBUMS.clear();
            int depth = 0;
            int start = -1;
            boolean inString = false;
            for (int i = 0; i < json.length(); i++) {
                char c = json.charAt(i);
                if (c == '"' && (i == 0 || json.charAt(i - 1) != '\\')) {
                    inString = !inString;
                }
                if (!inString) {
                    if (c == '{') {
                        if (depth == 0) start = i;
                        depth++;
                    } else if (c == '}') {
                        depth--;
                        if (depth == 0 && start != -1) {
                            CUSTOM_ALBUMS.add(json.substring(start, i + 1));
                            start = -1;
                        }
                    }
                }
            }
        }
    }

    /**
     * Hỗ trợ cả phương thức POST (khắc phục lỗi 405 Method Not Allowed khi gửi form)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String txtLink = request.getParameter("txtLink");     // Link thư mục Google Drive hoặc ID
        if (txtLink == null || txtLink.trim().isEmpty()) {
            txtLink = request.getParameter("id");             // Hỗ trợ rút gọn: ?id=...
        }
        String txtFilter = request.getParameter("txtFilter"); // Bộ lọc tên/mã ảnh
        String action = request.getParameter("action");       // Hành động
        // --- 0. QUẢN LÝ ĐƠN CHỐT ẢNH TRUNG TÂM (SERVER-SIDE CENTRAL STORAGE) ---
        if ("getOrders".equals(action)) {
            ensureOrdersLoaded(request);
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < ORDER_STORE.size(); i++) {
                if (i > 0) sb.append(",");
                sb.append(ORDER_STORE.get(i).toJson(i + 1));
            }
            sb.append("]");
            response.setContentType("application/json; charset=UTF-8");
            response.setHeader("Access-Control-Allow-Origin", "*");
            response.getWriter().write(sb.toString());
            return;
        }

        if ("saveOrder".equals(action)) {
            ensureOrdersLoaded(request);
            String body = readRequestBody(request);
            OrderRecord order = parseOrderJson(body);
            if (order != null) {
                int existingIdx = -1;
                for (int i = 0; i < ORDER_STORE.size(); i++) {
                    OrderRecord o = ORDER_STORE.get(i);
                    if ((order.orderId != null && !order.orderId.isEmpty() && order.orderId.equals(o.orderId)) ||
                        (order.folderId != null && !order.folderId.isEmpty() && order.folderId.equals(o.folderId) &&
                         order.clientPhone != null && !order.clientPhone.isEmpty() && order.clientPhone.equals(o.clientPhone))) {
                        existingIdx = i;
                        break;
                    }
                }
                if (existingIdx != -1) {
                    ORDER_STORE.set(existingIdx, order);
                } else {
                    ORDER_STORE.add(0, order);
                }
                File file = getOrdersFile(request);
                if (file != null) saveOrdersToFile(file);
            }
            response.setContentType("application/json; charset=UTF-8");
            response.setHeader("Access-Control-Allow-Origin", "*");
            response.getWriter().write("{\"status\":\"success\",\"orderId\":\"" + (order != null ? order.orderId : "") + "\"}");
            return;
        }

        if ("updateOrderStatus".equals(action)) {
            ensureOrdersLoaded(request);
            String orderId = request.getParameter("orderId");
            String newStatus = request.getParameter("status");
            int rowIndex = -1;
            try { rowIndex = Integer.parseInt(request.getParameter("rowIndex")); } catch (Exception ignored) {}

            boolean found = false;
            for (int i = 0; i < ORDER_STORE.size(); i++) {
                OrderRecord o = ORDER_STORE.get(i);
                if ((orderId != null && !orderId.isEmpty() && orderId.equals(o.orderId)) || (rowIndex == i + 1)) {
                    o.status = newStatus;
                    found = true;
                    break;
                }
            }
            if (found) {
                File file = getOrdersFile(request);
                if (file != null) saveOrdersToFile(file);
            }
            response.setContentType("application/json; charset=UTF-8");
            response.setHeader("Access-Control-Allow-Origin", "*");
            response.getWriter().write("{\"status\":\"success\"}");
            return;
        }

        if ("deleteOrder".equals(action)) {
            ensureOrdersLoaded(request);
            String orderId = request.getParameter("orderId");
            int rowIndex = -1;
            try { rowIndex = Integer.parseInt(request.getParameter("rowIndex")); } catch (Exception ignored) {}

            int removeIdx = -1;
            for (int i = 0; i < ORDER_STORE.size(); i++) {
                OrderRecord o = ORDER_STORE.get(i);
                if ((orderId != null && !orderId.isEmpty() && orderId.equals(o.orderId)) || (rowIndex == i + 1)) {
                    removeIdx = i;
                    break;
                }
            }
            if (removeIdx != -1) {
                ORDER_STORE.remove(removeIdx);
                File file = getOrdersFile(request);
                if (file != null) saveOrdersToFile(file);
            }
            response.setContentType("application/json; charset=UTF-8");
            response.setHeader("Access-Control-Allow-Origin", "*");
            response.getWriter().write("{\"status\":\"success\"}");
            return;
        }

        if ("clearAllOrders".equals(action)) {
            ensureOrdersLoaded(request);
            ORDER_STORE.clear();
            File file = getOrdersFile(request);
            if (file != null) saveOrdersToFile(file);
            response.setContentType("application/json; charset=UTF-8");
            response.setHeader("Access-Control-Allow-Origin", "*");
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Đã xóa toàn bộ đơn hàng!\"}");
            return;
        }

        // --- 0.1 QUẢN LÝ KHO ALBUM TRUNG TÂM (SERVER-SIDE ALBUM STORE) ---
        if ("getAlbums".equals(action)) {
            ensureAlbumsLoaded(request);
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < CUSTOM_ALBUMS.size(); i++) {
                if (i > 0) sb.append(",");
                sb.append(CUSTOM_ALBUMS.get(i));
            }
            sb.append("]");
            response.setContentType("application/json; charset=UTF-8");
            response.setHeader("Access-Control-Allow-Origin", "*");
            response.getWriter().write(sb.toString());
            return;
        }

        if ("saveAlbum".equals(action)) {
            ensureAlbumsLoaded(request);
            String body = readRequestBody(request);
            if (body != null && !body.trim().isEmpty() && body.trim().startsWith("{")) {
                String albumJson = body.trim();
                String albumId = extractJsonField(albumJson, "id");
                String folderId = extractJsonField(albumJson, "folderId");
                String targetId = (albumId != null && !albumId.isEmpty()) ? albumId : folderId;
                if (targetId != null) {
                    String cleanId = this.getDriveId(targetId);
                    if (cleanId != null && !cleanId.isEmpty()) targetId = cleanId;
                }

                String albumName = extractJsonField(albumJson, "name");
                String clientPhone = extractJsonField(albumJson, "clientPhone");
                String albumNote = extractJsonField(albumJson, "note");
                String albumThumb = extractJsonField(albumJson, "thumb");
                int albumQty = extractJsonInt(albumJson, "qty", 0);
                String albumTime = extractJsonField(albumJson, "time");
                if (albumTime == null || albumTime.isEmpty()) {
                    albumTime = java.time.Instant.now().toString();
                }

                // Tự động quét bổ sung ảnh đại diện & số lượng ảnh nếu thiếu
                if (targetId != null && !targetId.isEmpty() && (albumThumb.isEmpty() || albumQty <= 0)) {
                    try {
                        List<ImageModel> imgs = this.callGoogleScriptWithRetry(LINK_SCAN_DRIVE, targetId, 2);
                        if (!imgs.isEmpty()) {
                            if (albumThumb.isEmpty()) {
                                albumThumb = imgs.get(0).thumbLink;
                            }
                            if (albumQty <= 0) {
                                albumQty = imgs.size();
                            }
                        }
                    } catch (Exception ignored) {}
                }

                albumJson = "{\"id\":\"" + escapeJsonInner(targetId) + "\",\"name\":\"" + escapeJsonInner(albumName) + "\",\"clientPhone\":\"" + escapeJsonInner(clientPhone) + "\",\"note\":\"" + escapeJsonInner(albumNote) + "\",\"thumb\":\"" + escapeJsonInner(albumThumb) + "\",\"qty\":" + albumQty + ",\"time\":\"" + escapeJsonInner(albumTime) + "\"}";

                int existingIdx = -1;
                for (int i = 0; i < CUSTOM_ALBUMS.size(); i++) {
                    String existing = CUSTOM_ALBUMS.get(i);
                    String exId = extractJsonField(existing, "id");
                    String exFid = extractJsonField(existing, "folderId");
                    if ((targetId != null && !targetId.isEmpty() && (targetId.equals(exId) || targetId.equals(exFid)))) {
                        existingIdx = i;
                        break;
                    }
                }
                if (existingIdx != -1) {
                    CUSTOM_ALBUMS.set(existingIdx, albumJson);
                } else {
                    CUSTOM_ALBUMS.add(0, albumJson);
                }
                File file = getAlbumsFile(request);
                if (file != null) saveAlbumsToFile(file);
            }
            response.setContentType("application/json; charset=UTF-8");
            response.setHeader("Access-Control-Allow-Origin", "*");
            response.getWriter().write("{\"status\":\"success\"}");
            return;
        }

        // --- 0.2 QUÉT THÔNG TIN ALBUM (SỐ LƯỢNG ẢNH & ẢNH ĐẠI DIỆN TỪ GOOGLE DRIVE) ---
        if ("scanAlbum".equals(action)) {
            String fId = request.getParameter("id");
            if (fId == null || fId.trim().isEmpty()) {
                fId = request.getParameter("txtLink");
            }
            if (fId != null) {
                fId = this.getDriveId(fId);
            }
            if (fId == null || fId.trim().isEmpty()) {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Thiếu Folder ID\"}");
                return;
            }
            List<ImageModel> imgs = this.callGoogleScriptWithRetry(LINK_SCAN_DRIVE, fId, 2);
            int qty = imgs.size();
            String thumb = "";
            if (!imgs.isEmpty()) {
                thumb = imgs.get(0).thumbLink;
            }
            response.setContentType("application/json; charset=UTF-8");
            response.setHeader("Access-Control-Allow-Origin", "*");
            response.getWriter().write("{\"status\":\"success\",\"id\":\"" + escapeJsonInner(fId) + "\",\"qty\":" + qty + ",\"thumb\":\"" + escapeJsonInner(thumb) + "\"}");
            return;
        }

        if ("deleteAlbum".equals(action)) {
            ensureAlbumsLoaded(request);
            String albumId = request.getParameter("id");
            String folderId = request.getParameter("folderId");
            int removeIdx = -1;
            for (int i = 0; i < CUSTOM_ALBUMS.size(); i++) {
                String existing = CUSTOM_ALBUMS.get(i);
                String exId = extractJsonField(existing, "id");
                String exFid = extractJsonField(existing, "folderId");
                if ((albumId != null && !albumId.isEmpty() && albumId.equals(exId)) ||
                    (folderId != null && !folderId.isEmpty() && folderId.equals(exFid))) {
                    removeIdx = i;
                    break;
                }
            }
            if (removeIdx != -1) {
                CUSTOM_ALBUMS.remove(removeIdx);
                File file = getAlbumsFile(request);
                if (file != null) saveAlbumsToFile(file);
            }
            response.setContentType("application/json; charset=UTF-8");
            response.setHeader("Access-Control-Allow-Origin", "*");
            response.getWriter().write("{\"status\":\"success\"}");
            return;
        }

        // 1. Rút gọn link chia sẻ (Ưu tiên TinyURL 301 direct, dự phòng is.gd)
        if ("shorten".equals(action)) {
            String longUrl = request.getParameter("longUrl");
            String shortUrl = this.getShortUrl(longUrl);
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(shortUrl);
            return;
        }

        // 2. Tải 1 ảnh duy nhất (giống tải riêng từng tấm trên Google Drive)
        if ("downloadOne".equals(action)) {
            String imgUrl = request.getParameter("url");
            String imgName = request.getParameter("name");
            this.downloadSingleFile(response, imgUrl, imgName);
            return;
        }

        // 3. Tải các ảnh đã chọn (cơ chế Google Drive: 1 ảnh -> tải trực tiếp; nhiều ảnh -> nén ZIP)
        String dataString;
        if ("downloadSelected".equals(action) && (dataString = request.getParameter("selectedData")) != null && !dataString.isEmpty()) {
            List<ImageModel> selectedList = this.parseSelectedData(dataString);
            if (selectedList.size() == 1) {
                // Tải trực tiếp 1 tấm, không nén zip
                ImageModel img = selectedList.get(0);
                this.downloadSingleFile(response, img.link, img.name);
            } else if (selectedList.size() > 1) {
                // Tối ưu gom nhiều ảnh vào ZIP
                this.downloadZip(response, selectedList);
            }
            return;
        }

        // 4. Lấy folder ID từ link người dùng nhập
        String folderId = null;
        if (txtLink != null && !txtLink.trim().isEmpty()) {
            folderId = this.getDriveId(txtLink);
            if (folderId == null) {
                folderId = txtLink.trim();
            }
        }

        // 5. Quét danh sách ảnh qua Google Apps Script (tối ưu hóa bộ đệm RAM & tự động thử lại)
        List<ImageModel> allImages = new ArrayList<>();
        if (folderId != null && !folderId.isEmpty()) {
            boolean refresh = "true".equalsIgnoreCase(request.getParameter("refresh"));
            CacheEntry cached = refresh ? null : ALBUM_CACHE.get(folderId);
            if (cached != null && cached.isValid() && !cached.images.isEmpty()) {
                allImages = new ArrayList<>(cached.images);
            } else {
                allImages = this.callGoogleScriptWithRetry(LINK_SCAN_DRIVE, folderId, 3);
                if (!allImages.isEmpty()) {
                    ALBUM_CACHE.put(folderId, new CacheEntry(allImages));
                }
            }
        }

        // 6. Lọc ảnh theo từ khóa / số thứ tự
        List<ImageModel> filteredImages = new ArrayList<>();
        if (txtFilter != null && !txtFilter.trim().isEmpty()) {
            String[] numbers = txtFilter.trim().split("[^a-zA-Z0-9]+");
            for (ImageModel imageModel : allImages) {
                String fileNameUpper = imageModel.name.toUpperCase();
                for (String num : numbers) {
                    if (!num.isEmpty() && fileNameUpper.contains(num.toUpperCase())) {
                        filteredImages.add(imageModel);
                        break;
                    }
                }
            }
        } else {
            filteredImages = allImages;
        }

        // 7. Tải toàn bộ ảnh đã lọc dạng file .zip
        if ("download".equals(action) && !filteredImages.isEmpty()) {
            if (filteredImages.size() == 1) {
                ImageModel single = filteredImages.get(0);
                this.downloadSingleFile(response, single.link, single.name);
            } else {
                this.downloadZip(response, filteredImages);
            }
            return;
        }

        // 8. Chuyển tiếp kết quả về trang tc.jsp để hiển thị
        ensureAlbumsLoaded(request);
        request.setAttribute("studioAlbums", CUSTOM_ALBUMS);
        request.setAttribute("dsAnh", filteredImages);
        request.setAttribute("currentId", folderId);
        request.setAttribute("currentFilter", txtFilter);
        request.getRequestDispatcher("tc.jsp").forward(request, response);
    }

    /**
     * Tách dữ liệu ảnh đã chọn gửi lên từ frontend
     */
    private List<ImageModel> parseSelectedData(String dataString) {
        List<ImageModel> list = new ArrayList<>();
        String[] rows = dataString.split("###ROW###");
        for (String row : rows) {
            String[] parts = row.split("###SEP###");
            if (parts.length >= 2) {
                list.add(new ImageModel(parts[0], parts[1]));
            }
        }
        return list;
    }

    /**
     * Gọi Google Apps Script tự động thử lại tối đa maxAttempts lần (khắc phục triệt để hiện tượng cold-start hoặc rớt kết nối)
     */
    private List<ImageModel> callGoogleScriptWithRetry(String scriptUrl, String id, int maxAttempts) {
        List<ImageModel> list = new ArrayList<>();
        for (int attempt = 1; attempt <= maxAttempts; attempt++) {
            list = this.callGoogleScript(scriptUrl, id);
            if (!list.isEmpty()) {
                return list;
            }
            if (attempt < maxAttempts) {
                try {
                    Thread.sleep(700L * attempt);
                } catch (InterruptedException ignored) {}
            }
        }
        return list;
    }

    /**
     * Gọi Google Apps Script để lấy danh sách ảnh trong thư mục Google Drive
     */
    private List<ImageModel> callGoogleScript(String scriptUrl, String id) {
        List<ImageModel> list = new ArrayList<>();
        HttpURLConnection conn = null;
        try {
            String finalUrl = scriptUrl + "?id=" + URLEncoder.encode(id, StandardCharsets.UTF_8.name());
            URL url = new URL(finalUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setInstanceFollowRedirects(true);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(90000); // Đảm bảo thư mục lớn không bị ngắt quãng
            conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0");

            // Xử lý chuyển hướng của Google Apps Script (tối đa 5 lần)
            int redirectCount = 0;
            int status = conn.getResponseCode();
            while (status >= 300 && status < 400 && redirectCount < 5) {
                String location = conn.getHeaderField("Location");
                if (location == null || location.isEmpty()) break;
                conn.disconnect();
                url = new URL(url, location);
                conn = (HttpURLConnection) url.openConnection();
                conn.setInstanceFollowRedirects(true);
                conn.setConnectTimeout(15000);
                conn.setReadTimeout(90000);
                conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0");
                status = conn.getResponseCode();
                redirectCount++;
            }

            InputStream stream = (status >= 400) ? conn.getErrorStream() : conn.getInputStream();
            if (stream == null) return list;

            BufferedReader in = new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8));
            StringBuilder content = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                content.append(line);
            }
            in.close();

            if (status >= 400) {
                System.err.println("Google Apps Script trả mã lỗi HTTP: " + status + " - " + content.toString());
                return list;
            }

            String json = content.toString().trim();
            if (json.isEmpty() || json.startsWith("<!DOCTYPE") || json.startsWith("<html")) {
                // Nhận về trang HTML trung gian hoặc lỗi xác thực tạm thời
                return list;
            }

            Pattern pObject = Pattern.compile("\\{([^}]*)\\}");
            Matcher mObject = pObject.matcher(json);
            while (mObject.find()) {
                String objContent = mObject.group(1);
                String name = "NoName";
                String link = "";
                Matcher mName = Pattern.compile("\"ten\"\\s*:\\s*\"([^\"]+)\"").matcher(objContent);
                if (mName.find()) {
                    name = mName.group(1);
                }
                Matcher mLink = Pattern.compile("\"link\"\\s*:\\s*\"([^\"]+)\"").matcher(objContent);
                if (mLink.find()) {
                    link = mLink.group(1);
                }
                name = this.unescapeJavaString(name);
                if (!link.isEmpty()) {
                    list.add(new ImageModel(name, link));
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi gọi Google Apps Script cho ID: " + id + " - " + e.getMessage());
        } finally {
            if (conn != null) {
                try { conn.disconnect(); } catch (Exception ignored) {}
            }
        }
        return list;
    }

    /**
     * Tải trực tiếp 1 file ảnh về trình duyệt (giống Google Drive khi chọn 1 ảnh)
     */
    private void downloadSingleFile(HttpServletResponse response, String fileUrl, String fileName) {
        try {
            if (fileName == null || fileName.trim().isEmpty()) {
                fileName = "image.jpg";
            }
            if (!fileName.contains(".")) {
                fileName += ".jpg";
            }

            String hqUrl = this.convertToOriginalLink(fileUrl);
            if (!isValidDownloadUrl(hqUrl)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid download URL");
                return;
            }

            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.name()).replaceAll("\\+", "%20");
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"; filename*=UTF-8''" + encodedFileName);
            
            URL url = new URL(hqUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setInstanceFollowRedirects(true);
            conn.setConnectTimeout(8000);
            conn.setReadTimeout(30000);
            
            try (BufferedInputStream is = new BufferedInputStream(conn.getInputStream(), BUFFER_SIZE)) {
                int bytesRead;
                byte[] buffer = new byte[BUFFER_SIZE];
                while ((bytesRead = is.read(buffer)) != -1) {
                    response.getOutputStream().write(buffer, 0, bytesRead);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Gom nhiều ảnh vào 1 file ZIP và stream trực tiếp về trình duyệt với tốc độ cao
     */
    private void downloadZip(HttpServletResponse response, List<ImageModel> images) {
        response.setContentType("application/zip");
        String zipName = "Images_" + System.currentTimeMillis() + ".zip";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + zipName + "\"");
        
        Set<String> entryNames = new HashSet<>();
        try (ZipOutputStream zos = new ZipOutputStream(response.getOutputStream(), StandardCharsets.UTF_8)) {
            // Nén tốc độ cao nhất (JPEG đã nén sẵn, không tốn CPU server)
            zos.setLevel(Deflater.BEST_SPEED);
            byte[] buffer = new byte[BUFFER_SIZE];

            for (ImageModel img : images) {
                try {
                    String entryName = img.name != null ? img.name.trim() : "photo.jpg";
                    if (entryName.isEmpty()) entryName = "photo.jpg";
                    // Khử ký tự cấm của hệ điều hành Windows: \ / : * ? " < > |
                    entryName = entryName.replaceAll("[:\\\\/*?|<>\"]", "_").trim();
                    if (entryName.isEmpty()) entryName = "photo.jpg";
                    if (!entryName.contains(".")) entryName += ".jpg";

                    // Tránh lỗi trùng tên file trong cùng file zip
                    String finalEntryName = entryName;
                    int counter = 1;
                    while (entryNames.contains(finalEntryName.toLowerCase())) {
                        int dotIdx = entryName.lastIndexOf('.');
                        if (dotIdx > 0) {
                            finalEntryName = entryName.substring(0, dotIdx) + " (" + counter + ")" + entryName.substring(dotIdx);
                        } else {
                            finalEntryName = entryName + " (" + counter + ")";
                        }
                        counter++;
                    }
                    entryNames.add(finalEntryName.toLowerCase());

                    String hqUrl = this.convertToOriginalLink(img.link);
                    if (isValidDownloadUrl(hqUrl)) {
                        URL url = new URL(hqUrl);
                        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                        conn.setInstanceFollowRedirects(true);
                        conn.setConnectTimeout(8000);
                        conn.setReadTimeout(30000);
                        
                        // Chỉ tạo entry khi kết nối thành công (tránh lỗi file ZIP bị hỏng khi có ảnh lỗi)
                        if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                            ZipEntry zipEntry = new ZipEntry(finalEntryName);
                            zos.putNextEntry(zipEntry);
                            
                            try (BufferedInputStream is = new BufferedInputStream(conn.getInputStream(), BUFFER_SIZE)) {
                                int bytesRead;
                                while ((bytesRead = is.read(buffer)) != -1) {
                                    zos.write(buffer, 0, bytesRead);
                                }
                            }
                            zos.closeEntry();
                        } else {
                            System.err.println("Không thể tải ảnh " + img.name + ", HTTP code: " + conn.getResponseCode());
                        }
                        try { conn.disconnect(); } catch (Exception ignored) {}
                    }
                } catch (Exception e) {
                    System.err.println("Lỗi nén ảnh vào zip: " + img.name + " - " + e.getMessage());
                    try { zos.closeEntry(); } catch (Exception ignored) {}
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Kiểm tra URL an toàn trước khi kết nối (chống SSRF vào mạng nội bộ)
     */
    private boolean isValidDownloadUrl(String url) {
        if (url == null || url.trim().isEmpty()) return false;
        String lower = url.toLowerCase().trim();
        if (!lower.startsWith("http://") && !lower.startsWith("https://")) return false;
        // Chặn các địa chỉ nội bộ, loopback và metadata cloud
        if (lower.contains("localhost") || lower.contains("127.0.0.1") || lower.contains("0.0.0.0")
                || lower.contains("169.254.") || lower.contains("10.") || lower.contains("192.168.")
                || lower.contains("::1")) {
            return false;
        }
        return true;
    }

    /**
     * Chuyển link thumbnail thành link ảnh chất lượng gốc (=d)
     */
    private String convertToOriginalLink(String url) {
        if (url == null) {
            return "";
        }
        if (url.contains("=w") || url.contains("=s") || url.contains("=h")) {
            return url.replaceAll("=(w|s|h)[0-9]+[^&]*", "=d");
        }
        if (url.contains("googleusercontent.com") && !url.contains("=d")) {
            return url + "=d";
        }
        return url;
    }

    /**
     * Giải mã các ký tự thoát Unicode trong chuỗi JSON tiếng Việt
     */
    private String unescapeJavaString(String st) {
        if (st == null) {
            return null;
        }
        StringBuilder sb = new StringBuilder(st.length());
        for (int i = 0; i < st.length(); i++) {
            char ch = st.charAt(i);
            if (ch == '\\') {
                char nextChar = (i == st.length() - 1) ? '\\' : st.charAt(i + 1);
                if (nextChar >= '0' && nextChar <= '7') {
                    String code = "" + nextChar;
                    i++;
                    if ((i < st.length() - 1) && st.charAt(i + 1) >= '0' && st.charAt(i + 1) <= '7') {
                        code += st.charAt(i + 1);
                        i++;
                        if ((i < st.length() - 1) && st.charAt(i + 1) >= '0' && st.charAt(i + 1) <= '7') {
                            code += st.charAt(i + 1);
                            i++;
                        }
                    }
                    sb.append((char) Integer.parseInt(code, 8));
                    continue;
                }
                switch (nextChar) {
                    case '\\': ch = '\\'; break;
                    case 'b': ch = '\b'; break;
                    case 'f': ch = '\f'; break;
                    case 'n': ch = '\n'; break;
                    case 'r': ch = '\r'; break;
                    case 't': ch = '\t'; break;
                    case '\"': ch = '\"'; break;
                    case '\'': ch = '\''; break;
                    case 'u': {
                        if (i >= st.length() - 5) {
                            ch = 'u';
                            break;
                        }
                        try {
                            int code = Integer.parseInt("" + st.charAt(i + 2) + st.charAt(i + 3) + st.charAt(i + 4) + st.charAt(i + 5), 16);
                            sb.append(Character.toChars(code));
                            i += 5;
                            continue;
                        } catch (Exception ex) {
                            ch = 'u';
                            break;
                        }
                    }
                    default:
                        break;
                }
                i++;
            }
            sb.append(ch);
        }
        return sb.toString();
    }

    /**
     * Trích xuất ID thư mục từ link Google Drive (hỗ trợ mọi định dạng link Drive, link rút gọn, markdown, query params)
     */
    private String getDriveId(String url) {
        if (url == null) return null;
        url = url.trim();

        // 1. Nếu có dạng markdown [Tên](https://drive.google.com/...)
        Matcher mMd = Pattern.compile("\\((https?://[^\\s\\)]+)\\)").matcher(url);
        if (mMd.find()) {
            url = mMd.group(1);
        }

        // 2. Trích xuất ID qua các mẫu phổ biến của Google Drive:
        // - folders/ID
        // - id=ID hoặc &id=ID
        // - /d/ID
        Matcher m = Pattern.compile("folders/([a-zA-Z0-9_-]+)|[?&]id=([a-zA-Z0-9_-]+)|/d/([a-zA-Z0-9_-]+)").matcher(url);
        if (m.find()) {
            for (int i = 1; i <= m.groupCount(); i++) {
                if (m.group(i) != null && !m.group(i).isEmpty()) {
                    return m.group(i);
                }
            }
        }

        // 3. Nếu là chuỗi ID Google Drive độc lập (độ dài thông thường 25 đến 50 ký tự a-zA-Z0-9_-)
        Matcher mDirectId = Pattern.compile("([a-zA-Z0-9_-]{25,50})").matcher(url);
        if (mDirectId.find()) {
            return mDirectId.group(1);
        }

        return url;
    }

    /**
     * Tạo link rút gọn: Ưu tiên is.gd (chuyển hướng 301 trực tiếp không qua trang trung gian),
     * dự phòng TinyURL, nếu lỗi trả về chính link gốc.
     */
    private String getShortUrl(String longUrl) {
        if (longUrl == null || longUrl.trim().isEmpty()) return "";
        try {
            if (longUrl.contains("localhost") || longUrl.contains("192.168.") || longUrl.contains("127.0.0.1")) {
                longUrl = longUrl.replaceAll("https?://[^/]+", "https://web-lay-anh.onrender.com");
            }
            String encodedUrl = URLEncoder.encode(longUrl, StandardCharsets.UTF_8.name());

            // 1. is.gd: Chuyển hướng 301 trực tiếp, không trang trung gian
            try {
                String isGdApi = "https://is.gd/create.php?format=simple&url=" + encodedUrl;
                String isGdUrl = fetchUrlContent(isGdApi);
                if (isGdUrl != null && !isGdUrl.toLowerCase().contains("error") && isGdUrl.startsWith("http")) {
                    return isGdUrl;
                }
            } catch (Exception ignored) {}

            // 2. Dự phòng TinyURL
            try {
                String tinyUrlApi = "https://tinyurl.com/api-create.php?url=" + encodedUrl;
                String shortUrl = fetchUrlContent(tinyUrlApi);
                if (shortUrl != null && !shortUrl.toLowerCase().contains("error") && shortUrl.startsWith("http")) {
                    return shortUrl;
                }
            } catch (Exception ignored) {}

            return longUrl;
        } catch (Exception e) {
            return longUrl;
        }
    }

    private String fetchUrlContent(String apiUrl) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(apiUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(4000);
            conn.setReadTimeout(4000);
            conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)");
            if (conn.getResponseCode() == 200) {
                try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = in.readLine()) != null) {
                        sb.append(line.trim());
                    }
                    return sb.toString();
                }
            }
        } catch (Exception ignored) {
        } finally {
            if (conn != null) {
                try { conn.disconnect(); } catch (Exception ignored) {}
            }
        }
        return null;
    }
}
