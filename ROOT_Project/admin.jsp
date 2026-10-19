<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <title>Studio Tuấn Hoa - Quản Trị Hệ Thống (visionOS)</title>
    
    <!-- Bootstrap 5 & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <!-- Google Fonts: Outfit & Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --apple-blue: #0ea5e9;
            --apple-blue-glow: rgba(14, 165, 233, 0.4);
            --apple-green: #10b981;
            --apple-yellow: #f59e0b;
            --apple-red: #ef4444;
            --apple-purple: #8b5cf6;
            
            --glass-bg: rgba(17, 24, 39, 0.65);
            --glass-card: rgba(30, 41, 59, 0.5);
            --glass-card-hover: rgba(30, 41, 59, 0.75);
            --glass-border: rgba(255, 255, 255, 0.08);
            --glass-border-light: rgba(255, 255, 255, 0.16);
            --glass-blur: blur(30px) saturate(180%);
            
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
        }

        * {
            box-sizing: border-box;
            -webkit-tap-highlight-color: transparent;
        }

        body {
            margin: 0;
            padding: 0;
            background-color: #0b0f17;
            color: var(--text-primary);
            font-family: 'Plus Jakarta Sans', -apple-system, sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        /* --- AMBIENT MESH BACKGROUND --- */
        .ambient-bg {
            position: fixed;
            inset: 0;
            z-index: -1;
            overflow: hidden;
            background: #0b0f17;
        }
        .ambient-orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(100px);
            opacity: 0.45;
            animation: floatOrb 22s infinite alternate ease-in-out;
            pointer-events: none;
        }
        .orb-1 { width: 55vw; height: 55vw; background: #3b82f6; top: -15%; left: -10%; }
        .orb-2 { width: 45vw; height: 45vw; background: #8b5cf6; bottom: -10%; right: -5%; animation-delay: -6s; }
        .orb-3 { width: 40vw; height: 40vw; background: #06b6d4; top: 35%; left: 35%; animation-delay: -12s; opacity: 0.3; }

        @keyframes floatOrb {
            0% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(4%, 8%) scale(1.08); }
            100% { transform: translate(-4%, -6%) scale(0.94); }
        }

        /* --- GLASS PANEL & CARDS --- */
        .glass-panel {
            background: var(--glass-bg);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-top: 1px solid var(--glass-border-light);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }

        .glass-card {
            background: var(--glass-card);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-top: 1px solid var(--glass-border-light);
            border-radius: 20px;
            padding: 20px;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .glass-card:hover {
            background: var(--glass-card-hover);
            border-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.35);
        }

        /* --- NAVIGATION TABS --- */
        .admin-nav {
            display: flex;
            gap: 8px;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(20px);
            padding: 6px;
            border-radius: 18px;
            border: 1px solid var(--glass-border);
            overflow-x: auto;
            scrollbar-width: none;
        }
        .admin-nav::-webkit-scrollbar { display: none; }

        .nav-btn {
            background: transparent;
            border: none;
            color: var(--text-secondary);
            font-size: 0.92rem;
            font-weight: 600;
            padding: 10px 18px;
            border-radius: 12px;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.25s ease;
        }

        .nav-btn:hover {
            color: #fff;
            background: rgba(255, 255, 255, 0.05);
        }

        .nav-btn.active {
            color: #fff;
            background: rgba(14, 165, 233, 0.2);
            border: 1px solid rgba(14, 165, 233, 0.4);
            box-shadow: 0 4px 15px rgba(14, 165, 233, 0.25);
        }

        .nav-badge {
            background: var(--apple-blue);
            color: #fff;
            font-size: 0.72rem;
            padding: 2px 7px;
            border-radius: 20px;
            font-weight: 700;
        }

        /* --- STAT CARDS --- */
        .stat-widget {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px;
            border-radius: 18px;
            background: rgba(30, 41, 59, 0.45);
            border: 1px solid var(--glass-border);
        }
        .stat-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        .stat-val {
            font-size: 1.85rem;
            font-weight: 700;
            font-family: 'Outfit', sans-serif;
            line-height: 1.1;
        }
        .stat-lbl {
            font-size: 0.8rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        /* --- BUTTONS --- */
        .btn-apple {
            background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
            border: none;
            color: #fff;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.25s ease;
            box-shadow: 0 4px 15px rgba(14, 165, 233, 0.3);
            text-decoration: none;
        }
        .btn-apple:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(14, 165, 233, 0.5);
            color: #fff;
        }

        .btn-glass-sm {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: #f1f5f9;
            font-size: 0.82rem;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 10px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-glass-sm:hover {
            background: rgba(255, 255, 255, 0.16);
            color: #fff;
            border-color: rgba(255, 255, 255, 0.25);
            transform: translateY(-1px);
        }

        .btn-copy-or {
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.35);
            color: #34d399;
        }
        .btn-copy-or:hover {
            background: rgba(16, 185, 129, 0.3);
            color: #6ee7b7;
        }

        /* --- INPUTS --- */
        .glass-input {
            background: rgba(15, 23, 42, 0.6) !important;
            border: 1px solid rgba(255, 255, 255, 0.12) !important;
            color: #f8fafc !important;
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.95rem;
            transition: all 0.25s;
        }
        .glass-input:focus {
            border-color: var(--apple-blue) !important;
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
            background: rgba(15, 23, 42, 0.8) !important;
        }
        .glass-input::placeholder { color: var(--text-muted); }

        /* --- STATUS BADGES --- */
        .status-badge {
            font-size: 0.76rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .status-new {
            background: rgba(245, 158, 11, 0.18);
            border: 1px solid rgba(245, 158, 11, 0.4);
            color: #fbbf24;
        }
        .status-processing {
            background: rgba(14, 165, 233, 0.18);
            border: 1px solid rgba(14, 165, 233, 0.4);
            color: #38bdf8;
        }
        .status-done {
            background: rgba(16, 185, 129, 0.18);
            border: 1px solid rgba(16, 185, 129, 0.4);
            color: #34d399;
        }

        /* --- DYNAMIC ISLAND TOAST --- */
        .dynamic-island {
            position: fixed;
            top: -100px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(15, 23, 42, 0.92);
            backdrop-filter: blur(25px);
            color: white;
            padding: 12px 24px;
            border-radius: 30px;
            font-size: 0.92rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.6), inset 0 0 0 1px rgba(255, 255, 255, 0.15);
            z-index: 100000;
            opacity: 0;
            transition: top 0.4s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.3s ease;
            pointer-events: none;
        }
        .dynamic-island.show { 
            top: 20px; 
            opacity: 1; 
        }

        /* --- MODAL POPUPS --- */
        .custom-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.75);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            z-index: 9999;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .custom-overlay.active {
            display: flex;
            opacity: 1;
        }

        .modal-box {
            background: rgba(17, 24, 39, 0.85);
            backdrop-filter: blur(30px);
            border: 1px solid var(--glass-border-light);
            border-radius: 24px;
            padding: 28px;
            width: 100%;
            max-width: 580px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.7);
            transform: scale(0.95);
            transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            max-height: 90vh;
            overflow-y: auto;
        }
        .custom-overlay.active .modal-box { transform: scale(1); }

        /* Table & Lists */
        .table-custom {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px;
        }
        .table-custom tr {
            background: rgba(30, 41, 59, 0.4);
            border-radius: 14px;
            transition: background 0.2s;
        }
        .table-custom tr:hover {
            background: rgba(30, 41, 59, 0.75);
        }
        .table-custom td {
            padding: 14px 16px;
            vertical-align: middle;
            border: none;
        }
        .table-custom td:first-child { border-top-left-radius: 14px; border-bottom-left-radius: 14px; }
        .table-custom td:last-child { border-top-right-radius: 14px; border-bottom-right-radius: 14px; }

        .or-preview-box {
            font-family: 'Courier New', monospace;
            background: rgba(0, 0, 0, 0.4);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #38bdf8;
            padding: 8px 12px;
            border-radius: 10px;
            font-size: 0.8rem;
            max-width: 280px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        /* --- RESPONSIVE CHUẨN MỌI THIẾT BỊ (MOBILE, TABLET, DESKTOP) --- */
        html, body {
            width: 100%;
            max-width: 100vw;
            overflow-x: hidden;
            position: relative;
        }

        .modal-box {
            max-width: min(580px, calc(100vw - 24px)) !important;
            word-break: break-word;
            overflow-wrap: anywhere;
        }

        .dynamic-island {
            max-width: min(460px, calc(100vw - 32px));
        }

        .inline-note-pill {
            background: rgba(245, 158, 11, 0.12);
            border: 1px solid rgba(245, 158, 11, 0.3);
            color: #fcd34d;
            border-radius: 8px;
            padding: 4px 8px;
            font-size: 0.76rem;
            cursor: pointer;
            transition: all 0.2s;
            max-width: 280px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .inline-note-pill:hover {
            background: rgba(245, 158, 11, 0.25);
            color: #fff;
        }

        /* Nút Xem Ảnh Khách Đã Chọn Trong Kho Album (Rõ nét, tương phản cao, đều chiều cao) */
        .btn-album-customer-picks {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            height: 40px;
            padding: 0 12px;
            margin-bottom: 12px;
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.22) 0%, rgba(5, 150, 105, 0.3) 100%);
            border: 1px solid rgba(52, 211, 153, 0.5);
            border-radius: 12px;
            color: #ffffff !important;
            text-decoration: none !important;
            font-size: 0.82rem;
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.2);
        }
        .btn-album-customer-picks:hover {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.38) 0%, rgba(5, 150, 105, 0.45) 100%);
            border-color: rgba(52, 211, 153, 0.85);
            color: #ffffff !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
        }
        .btn-album-customer-picks .picks-count-pill {
            background: #10b981;
            color: #ffffff;
            font-size: 0.72rem;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 20px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
        }
        .btn-album-customer-picks .picks-arrow {
            transition: transform 0.2s;
        }
        .btn-album-customer-picks:hover .picks-arrow {
            transform: translateX(4px);
        }

        .album-no-picks-box {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            width: 100%;
            height: 40px;
            margin-bottom: 12px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px dashed rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: var(--text-muted);
            font-size: 0.78rem;
        }

        .order-mobile-card {
            background: rgba(30, 41, 59, 0.55);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid var(--glass-border);
            border-top: 1px solid var(--glass-border-light);
            border-radius: 18px;
            padding: 16px;
            margin-bottom: 14px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.35);
            transition: all 0.2s ease;
        }
        .order-mobile-card:hover {
            background: rgba(30, 41, 59, 0.75);
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .container {
                padding-left: 12px !important;
                padding-right: 12px !important;
            }
            .admin-nav {
                padding: 4px;
                gap: 4px;
                border-radius: 14px;
                -webkit-overflow-scrolling: touch;
            }
            .nav-btn {
                padding: 7px 11px;
                font-size: 0.8rem;
            }
            .stat-widget {
                padding: 12px;
                gap: 10px;
                border-radius: 14px;
            }
            .stat-icon {
                width: 40px;
                height: 40px;
                font-size: 18px;
                border-radius: 10px;
            }
            .stat-val {
                font-size: 1.35rem;
            }
            .stat-lbl {
                font-size: 0.68rem;
            }
            .orders-table-wrapper {
                display: none !important;
            }
            .orders-cards-wrapper {
                display: block !important;
            }
            .modal-box {
                padding: 18px;
                border-radius: 18px;
            }
        }

        @media (min-width: 769px) {
            .orders-table-wrapper {
                display: block !important;
            }
            .orders-cards-wrapper {
                display: none !important;
            }
        }
    </style>
</head>
<body>

    <!-- Ambient Mesh Background -->
    <div class="ambient-bg">
        <div class="ambient-orb orb-1"></div>
        <div class="ambient-orb orb-2"></div>
        <div class="ambient-orb orb-3"></div>
    </div>

    <!-- Dynamic Island Toast -->
    <div id="toast" class="dynamic-island">
        <i class="bi bi-check-circle-fill text-info" id="toastIcon"></i>
        <span id="toastMsg">Thành công</span>
    </div>

    <!-- ==================================================== -->
    <!-- MÀN HÌNH KHÓA BẢO MẬT (PIN UNLOCK) -->
    <!-- ==================================================== -->
    <div id="pinOverlay" class="custom-overlay active">
        <div class="modal-box text-center" style="max-width: 400px;">
            <div class="mb-3">
                <div class="mx-auto d-inline-flex p-3 rounded-circle" style="background: rgba(14, 165, 233, 0.15); border: 1px solid rgba(14, 165, 233, 0.3);">
                    <i class="bi bi-shield-lock-fill" style="font-size: 38px; color: var(--apple-blue);"></i>
                </div>
            </div>
            <h4 class="fw-bold mb-1">Studio Tuấn Hoa</h4>
            <p class="text-secondary small mb-4">Nhập mã PIN để truy cập trang quản trị</p>

            <div class="mb-3 position-relative">
                <input type="password" id="pinInput" class="form-control glass-input text-center fw-bold fs-4 pe-5" placeholder="Nhập SĐT quản trị..." style="letter-spacing: 2px;" onkeyup="if(event.key==='Enter') checkPin()">
                <button type="button" class="btn btn-link text-secondary position-absolute end-0 top-50 translate-middle-y me-2 text-decoration-none" onclick="toggleMainPinView()" title="Hiện/Ẩn mật khẩu">
                    <i class="bi bi-eye" id="mainPinEye"></i>
                </button>
            </div>
            
            <button class="btn-apple w-100 justify-content-center py-2 fs-6 mb-2" onclick="checkPin()">
                <i class="bi bi-unlock-fill"></i> Mở khóa
            </button>
            <div id="pinError" class="text-danger small fw-semibold mt-2" style="display: none;">
                Mã PIN không chính xác!
            </div>
            <div class="text-secondary small mt-3">
                <i class="bi bi-shield-lock me-1"></i> Hệ thống bảo mật Studio Tuấn Hoa
            </div>
        </div>
    </div>

    <!-- ==================================================== -->
    <!-- GIAO DIỆN CHÍNH ADMIN (SAU KHI MỞ KHÓA) -->
    <!-- ==================================================== -->
    <div id="adminApp" style="display: none;">
        <div class="container py-4" style="max-width: 1240px;">
            
            <!-- Top Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2">
                        <h2 class="fw-bold mb-0" style="font-family: 'Outfit', sans-serif;">Studio Tuấn Hoa</h2>
                        <span class="badge rounded-pill bg-primary bg-opacity-25 text-info border border-info border-opacity-30 px-3 py-1">Admin Panel</span>
                    </div>
                    <p class="text-secondary small mb-0 mt-1">
                        <i class="bi bi-telephone-fill me-1 text-info"></i> Hotline / Zalo: <strong>0388.520.391</strong>
                        <span class="mx-2">•</span>
                        <span id="syncStatus" class="text-success"><i class="bi bi-cloud-check-fill me-1"></i> Sẵn sàng</span>
                    </p>
                </div>

                <div class="d-flex align-items-center gap-2">
                    <button class="btn-glass-sm" onclick="refreshCurrentTab()" title="Làm mới dữ liệu">
                        <i class="bi bi-arrow-clockwise"></i> Làm mới
                    </button>
                    <a href="/tcController" target="_blank" class="btn-glass-sm" title="Mở trang xem ảnh của khách">
                        <i class="bi bi-box-arrow-up-right"></i> Web Khách
                    </a>
                    <button class="btn-glass-sm text-danger" onclick="logoutAdmin()" title="Đăng xuất">
                        <i class="bi bi-power"></i>
                    </button>
                </div>
            </div>

            <!-- Navigation Tabs -->
            <div class="admin-nav mb-4">
                <button class="nav-btn active" id="tabBtnOrders" onclick="switchTab('orders')">
                    <i class="bi bi-bag-check-fill"></i> Đơn Chốt Ảnh
                    <span class="nav-badge" id="badgeOrderCount">0</span>
                </button>
                <button class="nav-btn" id="tabBtnCreate" onclick="switchTab('create')">
                    <i class="bi bi-plus-circle-fill"></i> ➕ Tạo Album Mới
                </button>
                <button class="nav-btn" id="tabBtnAlbums" onclick="switchTab('albums')">
                    <i class="bi bi-images"></i> 📁 Kho Album
                    <span class="nav-badge" style="background: rgba(255,255,255,0.2);" id="badgeAlbumCount">0</span>
                </button>
                <button class="nav-btn" id="tabBtnSettings" onclick="switchTab('settings')">
                    <i class="bi bi-gear-fill"></i> Cài Đặt
                </button>
            </div>

            <!-- ==================================================== -->
            <!-- TAB 1: QUẢN LÝ ĐƠN CHỐT ẢNH (ORDERS) -->
            <!-- ==================================================== -->
            <div id="tabOrders" class="tab-content">
                <!-- Thống kê nhanh -->
                <div class="row g-3 mb-4">
                    <div class="col-6 col-md-3">
                        <div class="stat-widget">
                            <div class="stat-icon" style="background: rgba(14, 165, 233, 0.15); color: #38bdf8;">
                                <i class="bi bi-receipt"></i>
                            </div>
                            <div>
                                <div class="stat-val" id="statTotalOrders">0</div>
                                <div class="stat-lbl">Tổng đơn</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="stat-widget">
                            <div class="stat-icon" style="background: rgba(245, 158, 11, 0.15); color: #fbbf24;">
                                <i class="bi bi-hourglass-split"></i>
                            </div>
                            <div>
                                <div class="stat-val" id="statNewOrders">0</div>
                                <div class="stat-lbl">Mới nhận</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="stat-widget">
                            <div class="stat-icon" style="background: rgba(139, 92, 246, 0.15); color: #c084fc;">
                                <i class="bi bi-brush-fill"></i>
                            </div>
                            <div>
                                <div class="stat-val" id="statProcessingOrders">0</div>
                                <div class="stat-lbl">Đang sửa</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="stat-widget">
                            <div class="stat-icon" style="background: rgba(16, 185, 129, 0.15); color: #34d399;">
                                <i class="bi bi-check-all"></i>
                            </div>
                            <div>
                                <div class="stat-val" id="statDoneOrders">0</div>
                                <div class="stat-lbl">Hoàn thành</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thanh tìm kiếm & lọc -->
                <div class="glass-card mb-4 p-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-transparent border-0 text-secondary"><i class="bi bi-search"></i></span>
                                <input type="text" id="orderSearchInput" class="form-control glass-input" placeholder="Tìm kiếm theo Tên khách hàng, SĐT, Mã đơn..." oninput="filterOrders()">
                            </div>
                        </div>
                        <div class="col-md-6 d-flex justify-content-md-end gap-2 flex-wrap">
                            <select id="orderStatusFilter" class="form-select glass-input w-auto" onchange="filterOrders()">
                                <option value="all">Tất cả trạng thái</option>
                                <option value="Mới nhận">Mới nhận</option>
                                <option value="Đang sửa">Đang sửa</option>
                                <option value="Hoàn thành">Hoàn thành</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Danh sách đơn hàng Desktop (Table View) -->
                <div class="orders-table-wrapper glass-card p-0 overflow-hidden mb-3">
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr style="background: transparent;">
                                    <th class="ps-4 text-secondary small text-uppercase fw-bold">Khách hàng &amp; Ghi chú</th>
                                    <th class="text-secondary small text-uppercase fw-bold">Thời gian</th>
                                    <th class="text-center text-secondary small text-uppercase fw-bold">Số ảnh</th>
                                    <th class="text-secondary small text-uppercase fw-bold">Mã OR (Windows Explorer)</th>
                                    <th class="text-center text-secondary small text-uppercase fw-bold">Trạng thái</th>
                                    <th class="text-end pe-4 text-secondary small text-uppercase fw-bold">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="ordersTableBody">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-secondary">
                                        <div class="spinner-border text-info spinner-border-sm me-2"></div> Đang tải danh sách đơn...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Danh sách đơn hàng Mobile ("Box lại thông tin" - Glass Cards View) -->
                <div id="ordersCardsContainer" class="orders-cards-wrapper mb-4">
                    <div class="text-center py-4 text-secondary">
                        <div class="spinner-border text-info spinner-border-sm me-2"></div> Đang tải danh sách đơn...
                    </div>
                </div>
            </div>

            <!-- ==================================================== -->
            <!-- TAB 2: TẠO ALBUM GỬI KHÁCH (ALBUM CREATOR) -->
            <!-- ==================================================== -->
            <div id="tabCreate" class="tab-content" style="display: none;">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="glass-panel p-4 p-md-5">
                            <div class="text-center mb-4">
                                <div class="d-inline-flex p-3 rounded-circle mb-2" style="background: rgba(14, 165, 233, 0.15); border: 1px solid rgba(14, 165, 233, 0.3);">
                                    <i class="bi bi-cloud-plus-fill" style="font-size: 32px; color: var(--apple-blue);"></i>
                                </div>
                                <h3 class="fw-bold mb-1">Tạo Album Mới Gửi Khách</h3>
                                <p class="text-secondary small">Dán link Google Drive của khách để tạo link xem ảnh và chọn ảnh siêu tốc</p>
                            </div>

                            <form id="createAlbumForm" onsubmit="event.preventDefault(); handleCreateAlbum();">
                                <div class="mb-3">
                                    <label class="form-label text-white small fw-bold">1. Link Thư Mục Google Drive (hoặc Folder ID) <span class="text-danger">*</span></label>
                                    <input type="text" id="newAlbumDriveLink" class="form-control glass-input" placeholder="Ví dụ: https://drive.google.com/drive/folders/17D7MuUFZeOcjD41C13LGsQDoJR6zPFj8?usp=sharing" required>
                                    <div class="form-text text-secondary small">Hệ thống sẽ tự động bóc tách ID sạch từ mọi dạng link Google Drive.</div>
                                </div>

                                <div class="row g-3 mb-3">
                                    <div class="col-md-7">
                                        <label class="form-label text-white small fw-bold">2. Tên Album / Tên Khách Hàng <span class="text-danger">*</span></label>
                                        <input type="text" id="newAlbumName" class="form-control glass-input" placeholder="Ví dụ: Mai Lan - Kỷ yếu Hoàng Diệu" required>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="form-label text-white small fw-bold">3. Số Điện Thoại / Zalo của Khách</label>
                                        <input type="text" id="newAlbumClientPhone" class="form-control glass-input" placeholder="0987xxxxxx (Tùy chọn)">
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label text-white small fw-bold">4. Dặn Dò / Ghi Chú cho Album</label>
                                    <input type="text" id="newAlbumNote" class="form-control glass-input" placeholder="Ví dụ: Khách chọn tối đa 20 tấm để photoshop...">
                                </div>

                                <button type="submit" class="btn-apple w-100 justify-content-center py-3 fs-6" id="btnSubmitCreateAlbum">
                                    <i class="bi bi-lightning-charge-fill"></i> Tạo Link Chọn Ảnh Gửi Khách
                                </button>
                            </form>

                            <!-- Kết quả tạo album -->
                            <div id="createResultBox" class="mt-4 p-4 rounded-4" style="display: none; background: rgba(15, 23, 42, 0.8); border: 1px solid rgba(14, 165, 233, 0.4);">
                                <h5 class="text-info fw-bold mb-3"><i class="bi bi-check-circle-fill me-2"></i> Đã Tạo Album Thành Công!</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label text-secondary small mb-1">Link xem ảnh sạch:</label>
                                    <div class="input-group">
                                        <input type="text" id="resCleanUrl" class="form-control glass-input" readonly>
                                        <button class="btn btn-outline-info" onclick="copyResultLink('resCleanUrl')"><i class="bi bi-clipboard"></i> Copy</button>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-secondary small mb-1">Link rút gọn (TinyURL):</label>
                                    <div class="input-group">
                                        <input type="text" id="resShortUrl" class="form-control glass-input" readonly>
                                        <button class="btn btn-outline-info" onclick="copyResultLink('resShortUrl')"><i class="bi bi-clipboard"></i> Copy</button>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-secondary small mb-1">Tin nhắn soạn sẵn gửi Zalo cho khách:</label>
                                    <textarea id="resZaloMessage" class="form-control glass-input" rows="5" readonly></textarea>
                                </div>

                                <div class="d-flex gap-2">
                                    <button class="btn-apple flex-grow-1 justify-content-center py-2" onclick="copyZaloTemplate()">
                                        <i class="bi bi-chat-dots-fill"></i> Copy Tin Nhắn &amp; Mở Zalo
                                    </button>
                                    <a id="btnPreviewNewAlbum" href="#" target="_blank" class="btn-glass-sm py-2 px-3 text-nowrap">
                                        <i class="bi bi-box-arrow-up-right"></i> Xem Thử
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ==================================================== -->
            <!-- TAB 3: QUẢN LÝ KHO ALBUM (ALBUMS) -->
            <!-- ==================================================== -->
            <div id="tabAlbums" class="tab-content" style="display: none;">
                <div class="glass-card mb-4 p-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-8">
                            <div class="input-group">
                                <span class="input-group-text bg-transparent border-0 text-secondary"><i class="bi bi-search"></i></span>
                                <input type="text" id="albumSearchInput" class="form-control glass-input" placeholder="Tìm kiếm tên album, ID..." oninput="filterAlbums()">
                            </div>
                        </div>
                        <div class="col-md-4 text-md-end">
                            <button class="btn-apple" onclick="openAlbumCreateModal()">
                                <i class="bi bi-plus-lg"></i> Thêm Album Mới
                            </button>
                        </div>
                    </div>
                </div>

                <div id="albumsGrid" class="row g-4">
                    <div class="col-12 text-center py-5 text-secondary">
                        <div class="spinner-border text-info spinner-border-sm me-2"></div> Đang tải kho album...
                    </div>
                </div>
            </div>

            <!-- ==================================================== -->
            <!-- TAB 4: CÀI ĐẶT HỆ THỐNG (SETTINGS) -->
            <!-- ==================================================== -->
            <div id="tabSettings" class="tab-content" style="display: none;">
                <div class="row justify-content-center">
                    <div class="col-lg-7">
                        <div class="glass-panel p-4">
                            <h4 class="fw-bold mb-4"><i class="bi bi-sliders me-2 text-info"></i> Cài Đặt Hệ Thống</h4>

                            <div class="mb-4">
                                <label class="form-label text-white small fw-bold">1. Đường Dẫn Google Apps Script Web App</label>
                                <input type="text" id="cfgScriptUrl" class="form-control glass-input" placeholder="https://script.google.com/macros/s/.../exec">
                                <div class="form-text text-secondary small">Cầu nối nhận đơn và lưu album vào Google Sheets của bạn.</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label text-white small fw-bold">2. Mã PIN Quản Trị Viên (Mở Khóa)</label>
                                <div class="input-group">
                                    <input type="password" id="cfgAdminPin" class="form-control glass-input" placeholder="••••" maxlength="10">
                                    <button class="btn btn-outline-secondary" type="button" onclick="togglePinView()">
                                        <i class="bi bi-eye" id="pinEyeIcon"></i>
                                    </button>
                                </div>
                                <div class="form-text text-secondary small">Mã PIN dùng để bảo vệ trang Admin trên máy tính/điện thoại của bạn.</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label text-white small fw-bold">3. Số Điện Thoại Zalo Studio</label>
                                <input type="text" id="cfgStudioPhone" class="form-control glass-input" value="0388520391">
                            </div>

                            <button class="btn-apple py-2 px-4" onclick="saveSettings()">
                                <i class="bi bi-save-fill"></i> Lưu Cấu Hình
                            </button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- ==================================================== -->
    <!-- MODAL CHI TIẾT ĐƠN HÀNG & GHI CHÚ TỪNG ẢNH -->
    <!-- ==================================================== -->
    <div id="orderDetailModal" class="custom-overlay" onclick="closeOrderDetailModal(event)">
        <div class="modal-box" onclick="event.stopPropagation()">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0 text-info"><i class="bi bi-card-checklist me-2"></i> Chi Tiết Đơn Chọn Ảnh</h5>
                <button class="btn-close btn-close-white" onclick="closeOrderDetailModal()"></button>
            </div>

            <div class="p-3 rounded-3 mb-3" style="background: rgba(15, 23, 42, 0.6); border: 1px solid var(--glass-border);">
                <div class="row g-2">
                    <div class="col-6"><strong>Khách hàng:</strong> <span id="detailClientName" class="text-white">-</span></div>
                    <div class="col-6"><strong>SĐT / Zalo:</strong> <span id="detailClientPhone" class="text-info">-</span></div>
                    <div class="col-6"><strong>Thời gian:</strong> <span id="detailTime" class="text-secondary">-</span></div>
                    <div class="col-6"><strong>Tổng ảnh chọn:</strong> <span id="detailCount" class="badge bg-primary">-</span></div>
                    <div class="col-12 mt-2" id="detailGeneralNoteWrap" style="display: none;">
                        <strong>Dặn dò chung:</strong> <span id="detailGeneralNote" class="text-warning fst-italic">-</span>
                    </div>
                </div>
            </div>

            <!-- Mã OR Explorer -->
            <div class="mb-3">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <label class="form-label text-secondary small mb-0 fw-bold">Mã Windows Explorer (Cú pháp OR):</label>
                    <button class="btn btn-link btn-sm text-info p-0 text-decoration-none" onclick="copyDetailOrCode()">
                        <i class="bi bi-clipboard me-1"></i> Copy mã
                    </button>
                </div>
                <div class="p-2 rounded bg-black bg-opacity-40 border border-secondary border-opacity-25" style="font-family: monospace; font-size: 0.8rem; color: #38bdf8; max-height: 80px; overflow-y: auto;" id="detailOrString">
                    -
                </div>
            </div>

            <!-- Danh sách ghi chú từng ảnh -->
            <div class="mb-3">
                <label class="form-label text-secondary small fw-bold mb-1">Ghi chú chi tiết từng tấm ảnh:</label>
                <div id="detailNotesList" style="max-height: 220px; overflow-y: auto;" class="d-flex flex-column gap-2">
                    <!-- Notes rendered here -->
                </div>
            </div>

            <div class="d-flex gap-2 mt-4 flex-wrap">
                <a id="btnDetailOpenWeb" href="#" target="_blank" class="btn-glass-sm flex-grow-1 justify-content-center py-2">
                    <i class="bi bi-images me-1"></i> Xem Ảnh Trên Web
                </a>
                <button class="btn-apple py-2 px-3" onclick="copyDetailOrCode()">
                    <i class="bi bi-clipboard-check me-1"></i> Copy Mã OR
                </button>
                <button class="btn-glass-sm py-2 px-3 text-warning" onclick="editCurrentDetailOrder()">
                    <i class="bi bi-pencil me-1"></i> Sửa
                </button>
                <button class="btn-glass-sm py-2 px-3 text-danger" onclick="deleteCurrentDetailOrder()">
                    <i class="bi bi-trash me-1"></i> Xóa
                </button>
            </div>
        </div>
    </div>

    <!-- Modal Sửa Đơn Hàng -->
    <div id="orderEditModal" class="custom-overlay" onclick="closeOrderEditModal(event)">
        <div class="modal-box" onclick="event.stopPropagation()">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0 text-warning"><i class="bi bi-pencil-square me-2"></i> Chỉnh Sửa Đơn Chọn Ảnh</h5>
                <button class="btn-close btn-close-white" onclick="closeOrderEditModal()"></button>
            </div>
            <input type="hidden" id="editOrderIndex">
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Tên khách hàng:</label>
                <input type="text" id="editClientName" class="form-control glass-input">
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Số điện thoại / Zalo:</label>
                <input type="tel" id="editClientPhone" class="form-control glass-input">
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Trạng thái đơn hàng:</label>
                <select id="editOrderStatus" class="form-select glass-input">
                    <option value="Mới nhận">🟡 Mới nhận</option>
                    <option value="Đang sửa">🔵 Đang sửa</option>
                    <option value="Hoàn thành">🟢 Hoàn thành</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Dặn dò / Ghi chú chung:</label>
                <textarea id="editGeneralNote" class="form-control glass-input" rows="3"></textarea>
            </div>
            <div class="d-flex gap-2 mt-4">
                <button type="button" class="btn btn-secondary flex-grow-1" onclick="closeOrderEditModal()">Hủy</button>
                <button type="button" class="btn-apple flex-grow-1 justify-content-center" onclick="saveOrderEdit()">
                    <i class="bi bi-check2-circle me-1"></i> Lưu Thay Đổi
                </button>
            </div>
        </div>
    </div>

    <!-- Modal Thêm Album Nhanh -->
    <div id="albumCreateModal" class="custom-overlay" onclick="closeAlbumCreateModal(event)">
        <div class="modal-box" onclick="event.stopPropagation()">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0 text-success"><i class="bi bi-folder-plus me-2"></i> Thêm Album Mới Vào Kho</h5>
                <button class="btn-close btn-close-white" onclick="closeAlbumCreateModal()"></button>
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Link thư mục hoặc ID Google Drive <span class="text-danger">*</span>:</label>
                <input type="text" id="quickAlbumDriveLink" class="form-control glass-input" placeholder="Dán link hoặc ID Google Drive...">
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Tên Album / Tên Khách Hàng <span class="text-danger">*</span>:</label>
                <input type="text" id="quickAlbumName" class="form-control glass-input" placeholder="VD: Ảnh Cưới Tuấn & Hoa">
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Số điện thoại / Zalo khách (Tùy chọn):</label>
                <input type="tel" id="quickAlbumPhone" class="form-control glass-input" placeholder="Để gửi tin nhắn Zalo...">
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Ghi chú cho album (Tùy chọn):</label>
                <input type="text" id="quickAlbumNote" class="form-control glass-input" placeholder="VD: Gói VIP 50 ảnh, trả trước thứ 7...">
            </div>
            <div class="d-flex gap-2 mt-4">
                <button type="button" class="btn btn-secondary flex-grow-1" onclick="closeAlbumCreateModal()">Hủy</button>
                <button type="button" id="btnQuickSubmitAlbum" class="btn-apple flex-grow-1 justify-content-center" onclick="handleQuickCreateAlbum()">
                    <i class="bi bi-plus-circle me-1"></i> Tạo Album Ngay
                </button>
            </div>
        </div>
    </div>

    <!-- Modal Sửa Album -->
    <div id="albumEditModal" class="custom-overlay" onclick="closeAlbumEditModal(event)">
        <div class="modal-box" onclick="event.stopPropagation()">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0 text-warning"><i class="bi bi-pencil-square me-2"></i> Chỉnh Sửa Thông Tin Album</h5>
                <button class="btn-close btn-close-white" onclick="closeAlbumEditModal()"></button>
            </div>
            <input type="hidden" id="editAlbumIndex">
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Tên Album:</label>
                <input type="text" id="editAlbumName" class="form-control glass-input" placeholder="Tên album...">
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Google Drive Folder ID:</label>
                <input type="text" id="editAlbumFolderId" class="form-control glass-input" placeholder="ID thư mục Drive...">
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Số điện thoại / Zalo khách hàng:</label>
                <input type="tel" id="editAlbumPhone" class="form-control glass-input" placeholder="0388...">
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Ghi chú album:</label>
                <input type="text" id="editAlbumNote" class="form-control glass-input" placeholder="Ghi chú album...">
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary small mb-1">Link ảnh đại diện (Thumbnail URL - tùy chọn):</label>
                <input type="text" id="editAlbumThumb" class="form-control glass-input" placeholder="https://...">
            </div>
            <div class="d-flex gap-2 mt-4">
                <button type="button" class="btn btn-secondary flex-grow-1" onclick="closeAlbumEditModal()">Hủy</button>
                <button type="button" class="btn-apple flex-grow-1 justify-content-center" onclick="saveAlbumEdit()">
                    <i class="bi bi-check2-circle me-1"></i> Lưu Thay Đổi
                </button>
            </div>
        </div>
    </div>

    <!-- ==================================================== -->
    <!-- SCRIPTS -->
    <!-- ==================================================== -->
    <script>
        // --- CẤU HÌNH MẶC ĐỊNH ---
        const DEFAULT_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbxd8IxMapCIxdAGCZdz2Lsr9aIJYMcdmFI7Tl1eXJbMpmr-qHd8Tn3es2Gj-5zXxInr/exec";
        const BACKUP_ALBUMS_URL = "https://script.google.com/macros/s/AKfycbxd8IxMapCIxdAGCZdz2Lsr9aIJYMcdmFI7Tl1eXJbMpmr-qHd8Tn3es2Gj-5zXxInr/exec";
        const DEFAULT_PIN = "0388520391";
        const DEFAULT_PHONE = "0388520391";

        let SCRIPT_URL = localStorage.getItem("studio_script_url") || DEFAULT_SCRIPT_URL;
        let storedPin = localStorage.getItem("studio_admin_pin");
        let ADMIN_PIN = (storedPin && storedPin !== "1234") ? storedPin : DEFAULT_PIN;
        let STUDIO_PHONE = localStorage.getItem("studio_phone") || DEFAULT_PHONE;

        let allOrders = [];
        let allAlbums = [];
        let currentDetailOrder = null;

        // Tải ngay từ LocalStorage để hiển thị tức thì (0ms), không để người dùng chờ
        try {
            const cachedAlb = localStorage.getItem("cached_albums_list");
            if (cachedAlb) allAlbums = JSON.parse(cachedAlb);
            const cachedOrd = localStorage.getItem("cached_orders_list");
            if (cachedOrd) allOrders = JSON.parse(cachedOrd);
        } catch (e) {}

        // Khởi động
        document.addEventListener("DOMContentLoaded", function () {
            if (sessionStorage.getItem("admin_unlocked") === "true") {
                unlockAdmin();
            } else {
                document.getElementById("pinInput").focus();
            }
        });

        // ====================================================
        // PIN SECURITY
        // ====================================================
        function toggleMainPinView() {
            const pin = document.getElementById("pinInput");
            const eye = document.getElementById("mainPinEye");
            if (!pin) return;
            if (pin.type === "password") {
                pin.type = "text";
                if (eye) eye.className = "bi bi-eye-slash";
            } else {
                pin.type = "password";
                if (eye) eye.className = "bi bi-eye";
            }
        }

        function checkPin() {
            const raw = document.getElementById("pinInput").value;
            const input = (raw || "").trim().replace(/[\s.-]/g, "");
            const err = document.getElementById("pinError");

            // Danh sách các mật khẩu hợp lệ (SĐT Tuấn Hoa)
            const validPins = [
                ADMIN_PIN,
                "0388520391",
                "388520391"
            ].map(p => String(p || "").trim().replace(/[\s.-]/g, "").toLowerCase());

            const isValid = input.length > 0 && validPins.some(p => p && (p === input.toLowerCase()));

            if (isValid) {
                if (err) err.style.display = "none";
                sessionStorage.setItem("admin_unlocked", "true");
                unlockAdmin();
            } else {
                if (err) {
                    err.style.display = "block";
                    err.innerText = "Mã PIN không chính xác! Vui lòng nhập đúng SĐT quản trị.";
                }
                const inputEl = document.getElementById("pinInput");
                if (inputEl) inputEl.focus();
            }
        }

        function unlockAdmin() {
            try {
                const overlay = document.getElementById("pinOverlay");
                if (overlay) {
                    overlay.classList.remove("active");
                    overlay.style.display = "none";
                }
                const app = document.getElementById("adminApp");
                if (app) {
                    app.style.display = "block";
                }
            } catch (e) {
                console.warn("Lỗi UI unlock:", e);
            }

            try {
                loadSettingsToInputs();
            } catch (e) {
                console.warn("Lỗi load settings:", e);
            }

            // Hiển thị tức thì từ bộ nhớ đệm (0ms, không bắt người dùng đợi)
            updateDashboardCounters();
            renderOrders();
            renderAlbums();

            try {
                loadAllData();
            } catch (e) {
                console.warn("Lỗi load data:", e);
            }
        }

        function logoutAdmin() {
            sessionStorage.removeItem("admin_unlocked");
            window.location.reload();
        }

        // ====================================================
        // TAB NAVIGATION
        // ====================================================
        function switchTab(tabName) {
            const tabs = ["orders", "create", "albums", "settings"];
            tabs.forEach(t => {
                const el = document.getElementById("tab" + capitalize(t));
                const btn = document.getElementById("tabBtn" + capitalize(t));
                if (el) el.style.display = (t === tabName) ? "block" : "none";
                if (btn) {
                    if (t === tabName) btn.classList.add("active");
                    else btn.classList.remove("active");
                }
            });

            if (tabName === "orders") renderOrders();
            if (tabName === "albums") renderAlbums();
        }

        function capitalize(s) {
            return s.charAt(0).toUpperCase() + s.slice(1);
        }

        function refreshCurrentTab() {
            showToast("Đang đồng bộ dữ liệu...");
            loadAllData();
        }

        // ====================================================
        // DATA SYNC ENGINE (GOOGLE APPS SCRIPT)
        // ====================================================
        async function loadAllData() {
            setSyncStatus("syncing");

            const fetchWithTimeout = (url, timeoutMs = 8000) => {
                const controller = new AbortController();
                const timer = setTimeout(() => controller.abort(), timeoutMs);
                return fetch(url, { signal: controller.signal })
                    .finally(() => clearTimeout(timer));
            };
            
            // Tải song song cả Đơn Chốt Ảnh & Kho Album bằng Promise.allSettled (tốc độ cao, không phụ thuộc Google Sheets)
            const taskOrders = (async () => {
                let ordersLoaded = false;
                // 1. Ưu tiên tải từ Máy Chủ Trung Tâm (Central Java Server - Hoạt động trên mọi thiết bị, InPrivate & Facebook)
                try {
                    const serverRes = await fetchWithTimeout("tcController?action=getOrders", 5000);
                    if (serverRes.ok) {
                        const serverOrders = await serverRes.json();
                        if (Array.isArray(serverOrders) && serverOrders.length > 0) {
                            allOrders = serverOrders;
                            ordersLoaded = true;
                            try { localStorage.setItem("cached_orders_list", JSON.stringify(serverOrders)); } catch (e) {}
                        }
                    }
                } catch (e) {
                    console.warn("Lỗi tải đơn từ máy chủ trung tâm:", e);
                }

                // 2. Thử tải thêm từ Google Apps Script (nếu có cấu hình) để hợp nhất dữ liệu
                if (SCRIPT_URL) {
                    try {
                        const sheetRes = await fetchWithTimeout(SCRIPT_URL + "?action=get_orders", 5000);
                        if (sheetRes.ok) {
                            const sheetOrders = await sheetRes.json();
                            if (Array.isArray(sheetOrders) && sheetOrders.length > 0) {
                                if (!ordersLoaded) {
                                    allOrders = sheetOrders;
                                    ordersLoaded = true;
                                } else {
                                    const existingIds = new Set(allOrders.map(o => o.orderId || o.time));
                                    sheetOrders.forEach(so => {
                                        if (!existingIds.has(so.orderId || so.time)) {
                                            allOrders.push(so);
                                        }
                                    });
                                }
                                try { localStorage.setItem("cached_orders_list", JSON.stringify(allOrders)); } catch (e) {}
                            }
                        }
                    } catch (e) {
                        // Google Apps Script chưa cài get_orders, bỏ qua an toàn
                    }
                }

                // 3. Nếu chưa tải được đơn nào từ server/sheet, fallback đọc từ localStorage của trình duyệt
                if (!ordersLoaded && allOrders.length === 0) {
                    loadLocalOrdersFallback();
                }
            })();

            const taskAlbums = (async () => {
                let albumsLoaded = false;
                // 1. Tải từ Máy Chủ Java Trung Tâm (Central Server)
                try {
                    const srvAlbRes = await fetchWithTimeout("tcController?action=getAlbums", 5000);
                    if (srvAlbRes.ok) {
                        const srvAlbums = await srvAlbRes.json();
                        if (Array.isArray(srvAlbums) && srvAlbums.length > 0) {
                            allAlbums = srvAlbums;
                            albumsLoaded = true;
                            try { localStorage.setItem("cached_albums_list", JSON.stringify(srvAlbums)); } catch (e) {}
                        }
                    }
                } catch (e) {
                    console.warn("Lỗi tải album từ server trung tâm:", e);
                }

                // 2. Tải thêm từ Google Apps Script (nếu có) để hợp nhất dữ liệu
                try {
                    const scriptRes = await fetchWithTimeout(SCRIPT_URL + "?action=getAdminData", 5000)
                        .catch(() => fetchWithTimeout(BACKUP_ALBUMS_URL + "?action=getAdminData", 5000));
                    if (scriptRes && scriptRes.ok) {
                        const data = await scriptRes.json();
                        if (Array.isArray(data) && data.length > 0) {
                            if (!albumsLoaded) {
                                allAlbums = data;
                            } else {
                                const exIds = new Set(allAlbums.map(a => a.id));
                                data.forEach(d => {
                                    if (d && d.id && !exIds.has(d.id)) {
                                        allAlbums.push(d);
                                        exIds.add(d.id);
                                    }
                                });
                            }
                            try { localStorage.setItem("cached_albums_list", JSON.stringify(allAlbums)); } catch (e) {}
                        }
                    }
                } catch (err) {
                    console.warn("Lỗi tải album từ Apps Script:", err);
                }
            })();

            await Promise.allSettled([taskOrders, taskAlbums]);

            setSyncStatus("ready");
            updateDashboardCounters();
            renderOrders();
            renderAlbums();
            // Tự động quét và vá các album bị thiếu ảnh bìa hoặc thiếu số lượng ảnh
            setTimeout(autoHealMissingAlbums, 1200);
        }

        function loadLocalOrdersFallback() {
            // Kiểm tra toàn bộ các đơn từng được chốt trên trình duyệt này
            allOrders = [];
            const seenTimeMap = new Map();
            for (let i = 0; i < localStorage.length; i++) {
                const key = localStorage.key(i);
                if (key && (key.startsWith("order_sub_") || key.startsWith("latest_submitted_order_"))) {
                    try {
                        const item = JSON.parse(localStorage.getItem(key));
                        if (item && item.submittedAt) {
                            if (!seenTimeMap.has(item.submittedAt)) {
                                seenTimeMap.set(item.submittedAt, {
                                    orderId: item.orderId || ("ORD-" + (item.folderId || "").substring(0, 4) + "-" + Math.floor(Math.random() * 900 + 100)),
                                    time: item.submittedAt ? new Date(item.submittedAt).toLocaleString("vi-VN") : "Gần đây",
                                    clientName: item.clientName || "Khách hàng",
                                    clientPhone: item.clientPhone || "",
                                    folderId: item.folderId || "",
                                    selectedCount: item.selectedCount || 0,
                                    orString: item.orString || "",
                                    notes: item.notes || {},
                                    generalNote: item.generalNote || "",
                                    status: item.status || "Mới nhận",
                                    rawTime: new Date(item.submittedAt).getTime()
                                });
                            }
                        }
                    } catch (e) {}
                }
            }
            allOrders = Array.from(seenTimeMap.values()).sort((a, b) => (b.rawTime || 0) - (a.rawTime || 0));
        }

        function setSyncStatus(state) {
            const el = document.getElementById("syncStatus");
            if (!el) return;
            if (state === "syncing") {
                el.className = "text-warning";
                el.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Đang đồng bộ...';
            } else {
                el.className = "text-success";
                el.innerHTML = '<i class="bi bi-cloud-check-fill me-1"></i> Đã kết nối';
            }
        }

        function updateDashboardCounters() {
            const total = allOrders.length;
            const newCount = allOrders.filter(o => String(o.status || "").toLowerCase().includes("mới")).length;
            const procCount = allOrders.filter(o => String(o.status || "").toLowerCase().includes("sửa")).length;
            const doneCount = allOrders.filter(o => String(o.status || "").toLowerCase().includes("hoàn") || String(o.status || "").toLowerCase().includes("xong")).length;

            document.getElementById("statTotalOrders").innerText = total;
            document.getElementById("statNewOrders").innerText = newCount;
            document.getElementById("statProcessingOrders").innerText = procCount;
            document.getElementById("statDoneOrders").innerText = doneCount;

            document.getElementById("badgeOrderCount").innerText = total;
            document.getElementById("badgeAlbumCount").innerText = allAlbums.length;
        }

        // ====================================================
        // RENDER ORDERS TAB (HỖ TRỢ CẢ DESKTOP & MOBILE GLASS CARDS)
        // ====================================================
        function renderOrders() {
            const tbody = document.getElementById("ordersTableBody");
            const mobileContainer = document.getElementById("ordersCardsContainer");
            const filterText = (document.getElementById("orderSearchInput").value || "").toLowerCase().trim();
            const filterStatus = document.getElementById("orderStatusFilter").value;

            let filtered = allOrders.filter(order => {
                if (!order) return false;
                const matchText = String(order.clientName || "").toLowerCase().includes(filterText) ||
                                  String(order.clientPhone || "").toLowerCase().includes(filterText) ||
                                  String(order.orderId || "").toLowerCase().includes(filterText) ||
                                  String(order.orString || "").toLowerCase().includes(filterText) ||
                                  String(order.generalNote || "").toLowerCase().includes(filterText);
                
                let matchStatus = true;
                if (filterStatus !== "all") {
                    matchStatus = String(order.status || "") === filterStatus;
                }
                return matchText && matchStatus;
            });

            const emptyDesktopHtml = `<tr><td colspan="6" class="text-center py-5 text-secondary">
                <i class="bi bi-inbox" style="font-size: 36px; opacity: 0.4;"></i>
                <p class="mt-2 mb-0">Chưa có đơn chọn ảnh nào phù hợp.</p>
            </td></tr>`;

            const emptyMobileHtml = `<div class="text-center py-5 text-secondary glass-card">
                <i class="bi bi-inbox" style="font-size: 36px; opacity: 0.4;"></i>
                <p class="mt-2 mb-0">Chưa có đơn chọn ảnh nào phù hợp.</p>
            </div>`;

            if (filtered.length === 0) {
                if (tbody) tbody.innerHTML = emptyDesktopHtml;
                if (mobileContainer) mobileContainer.innerHTML = emptyMobileHtml;
                return;
            }

            if (tbody) tbody.innerHTML = "";
            if (mobileContainer) mobileContainer.innerHTML = "";

            filtered.forEach((order, index) => {
                let statusBadge = `<span class="status-badge status-new"><i class="bi bi-circle-fill" style="font-size: 6px;"></i> Mới nhận</span>`;
                const orderStatusStr = String(order.status || "").toLowerCase();
                if (orderStatusStr.includes("sửa")) {
                    statusBadge = `<span class="status-badge status-processing"><i class="bi bi-circle-fill" style="font-size: 6px;"></i> Đang sửa</span>`;
                } else if (orderStatusStr.includes("hoàn") || orderStatusStr.includes("xong")) {
                    statusBadge = `<span class="status-badge status-done"><i class="bi bi-check-circle-fill"></i> Hoàn thành</span>`;
                }

                const orCodeDisplay = order.orString ? String(order.orString) : "Chưa có mã OR";
                const phoneDisplay = order.clientPhone ? `<a href="https://zalo.me/${order.clientPhone}" target="_blank" class="text-info text-decoration-none"><i class="bi bi-chat-dots-fill me-1"></i>${order.clientPhone}</a>` : `<span class="text-secondary">-</span>`;

                // Tổng hợp ghi chú chung & ghi chú từng ảnh để xem ngay trong admin
                let inlineNotesSummary = "";
                if (order.generalNote && order.generalNote.trim()) {
                    inlineNotesSummary = "Dặn dò: " + order.generalNote.trim();
                }
                let notesMap = order.notes || {};
                if (typeof notesMap === "string") {
                    try { notesMap = JSON.parse(notesMap); } catch (e) { notesMap = {}; }
                }
                const pKeys = Object.keys(notesMap);
                if (pKeys.length > 0) {
                    const pNotes = pKeys.map(k => k + ": " + notesMap[k]).join(" • ");
                    inlineNotesSummary = inlineNotesSummary ? (inlineNotesSummary + " | 📸 " + pNotes) : ("📸 " + pNotes);
                }

                // 1. RENDER DESKTOP TABLE ROW
                if (tbody) {
                    const tr = document.createElement("tr");
                    tr.innerHTML = `
                        <td class="ps-4">
                            <div class="fw-bold text-white fs-6">${escapeHtml(order.clientName || 'Khách hàng')}</div>
                            <div class="small">${phoneDisplay}</div>
                            <div class="text-secondary" style="font-size: 0.72rem; font-family: monospace;">#${order.orderId || (index + 1)}</div>
                            ${inlineNotesSummary ? `
                                <div class="inline-note-pill mt-1" onclick="openOrderDetailModal(${index})" title="${escapeAttr(inlineNotesSummary)}">
                                    <i class="bi bi-chat-left-text-fill flex-shrink-0"></i>
                                    <span class="text-truncate">${escapeHtml(inlineNotesSummary)}</span>
                                </div>
                            ` : ''}
                        </td>
                        <td class="text-secondary small text-nowrap">${order.time || '-'}</td>
                        <td class="text-center">
                            <span class="badge rounded-pill bg-info bg-opacity-20 text-info border border-info border-opacity-30 px-3 py-1 fw-bold">
                                ${order.selectedCount || 0} ảnh
                            </span>
                        </td>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                <div class="or-preview-box" title="${escapeAttr(orCodeDisplay)}">${escapeHtml(orCodeDisplay)}</div>
                                <button class="btn-glass-sm btn-copy-or" onclick="copyOrCode('${escapeAttr(order.orString)}')">
                                    <i class="bi bi-clipboard"></i> Copy
                                </button>
                            </div>
                        </td>
                        <td class="text-center">
                            <div class="dropdown">
                                <button class="btn p-0 border-0 dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    ${statusBadge}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-dark">
                                    <li><a class="dropdown-item" href="#" onclick="updateStatus(${order.rowIndex || 0}, 'Mới nhận')">🟡 Mới nhận</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="updateStatus(${order.rowIndex || 0}, 'Đang sửa')">🔵 Đang sửa</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="updateStatus(${order.rowIndex || 0}, 'Hoàn thành')">🟢 Hoàn thành</a></li>
                                </ul>
                            </div>
                        </td>
                        <td class="text-end pe-4">
                            <div class="d-inline-flex gap-2">
                                <button class="btn-glass-sm" onclick="openOrderDetailModal(${index})" title="Xem chi tiết đơn & ghi chú">
                                    <i class="bi bi-eye"></i> Xem ghi chú
                                </button>
                                <a href="/tcController?txtLink=${encodeURIComponent(order.folderId)}&picks=${encodeURIComponent(getPhotoNamesFromOr(order.orString))}&action=view" target="_blank" class="btn-glass-sm" title="Mở album xem ảnh đã chọn">
                                    <i class="bi bi-box-arrow-up-right"></i>
                                </a>
                                <button class="btn-glass-sm text-warning" onclick="openEditOrderModal(${index})" title="Sửa thông tin đơn">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn-glass-sm text-danger" onclick="deleteOrder(${index})" title="Xóa đơn hàng">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </td>
                    `;
                    tbody.appendChild(tr);
                }

                // 2. RENDER MOBILE BOXED CARD ("Box lại thông tin" - Tối ưu mọi màn hình điện thoại)
                if (mobileContainer) {
                    const card = document.createElement("div");
                    card.className = "order-mobile-card";
                    card.innerHTML = `
                        <!-- Card Top Bar: Order ID, Time & Status Dropdown -->
                        <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom border-light border-opacity-10">
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge bg-secondary bg-opacity-40 text-light font-monospace" style="font-size: 0.75rem;">#${order.orderId || (index + 1)}</span>
                                <span class="text-secondary small" style="font-size: 0.75rem;"><i class="bi bi-clock me-1"></i>${order.time || '-'}</span>
                            </div>
                            <div class="dropdown">
                                <button class="btn p-0 border-0 dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    ${statusBadge}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end">
                                    <li><a class="dropdown-item" href="#" onclick="updateStatus(${order.rowIndex || 0}, 'Mới nhận')">🟡 Mới nhận</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="updateStatus(${order.rowIndex || 0}, 'Đang sửa')">🔵 Đang sửa</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="updateStatus(${order.rowIndex || 0}, 'Hoàn thành')">🟢 Hoàn thành</a></li>
                                </ul>
                            </div>
                        </div>

                        <!-- Client Info & Pick Count -->
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                                <h6 class="fw-bold text-white mb-0 fs-6">${escapeHtml(order.clientName || 'Khách hàng')}</h6>
                                <div class="small mt-1">${phoneDisplay}</div>
                            </div>
                            <span class="badge rounded-pill bg-info bg-opacity-20 text-info border border-info border-opacity-30 px-3 py-1 fw-bold fs-6">
                                ${order.selectedCount || 0} ảnh
                            </span>
                        </div>

                        <!-- Ghi chú hiển thị luôn trong card -->
                        ${inlineNotesSummary ? `
                            <div class="p-2 mb-2 rounded" style="background: rgba(245, 158, 11, 0.1); border: 1px solid rgba(245, 158, 11, 0.25); cursor: pointer;" onclick="openOrderDetailModal(${index})" title="${escapeAttr(inlineNotesSummary)}">
                                <div class="text-warning small fw-bold mb-1 d-flex align-items-center gap-1">
                                    <i class="bi bi-chat-left-text-fill"></i> Ghi chú của khách:
                                </div>
                                <div class="text-warning small text-truncate fst-italic">
                                    ${escapeHtml(inlineNotesSummary)}
                                </div>
                            </div>
                        ` : ''}

                        <!-- Explorer OR Code Box -->
                        <div class="p-2 rounded bg-black bg-opacity-40 border border-secondary border-opacity-20 d-flex justify-content-between align-items-center mb-3">
                            <div class="text-truncate text-info small font-monospace me-2" style="max-width: calc(100% - 85px);" title="${escapeAttr(orCodeDisplay)}">
                                ${escapeHtml(orCodeDisplay)}
                            </div>
                            <button class="btn btn-sm btn-outline-info py-1 px-2 text-nowrap flex-shrink-0" onclick="copyOrCode('${escapeAttr(order.orString)}')">
                                <i class="bi bi-clipboard me-1"></i> Copy
                            </button>
                        </div>

                        <!-- Action Buttons Grid (4 nút gọn gàng không tràn màn hình) -->
                        <div class="row g-2">
                            <div class="col-6">
                                <button class="btn-glass-sm w-100 justify-content-center py-2" onclick="openOrderDetailModal(${index})">
                                    <i class="bi bi-eye text-info"></i> Xem ghi chú
                                </button>
                            </div>
                            <div class="col-6">
                                <a href="/tcController?txtLink=${encodeURIComponent(order.folderId)}&picks=${encodeURIComponent(getPhotoNamesFromOr(order.orString))}&action=view" target="_blank" class="btn-glass-sm w-100 justify-content-center py-2 text-decoration-none">
                                    <i class="bi bi-box-arrow-up-right text-success"></i> Xem ảnh chọn
                                </a>
                            </div>
                            <div class="col-6">
                                <button class="btn-glass-sm w-100 justify-content-center py-2 text-warning" onclick="openEditOrderModal(${index})">
                                    <i class="bi bi-pencil"></i> Sửa đơn
                                </button>
                            </div>
                            <div class="col-6">
                                <button class="btn-glass-sm w-100 justify-content-center py-2 text-danger" onclick="deleteOrder(${index})">
                                    <i class="bi bi-trash"></i> Xóa đơn
                                </button>
                            </div>
                        </div>
                    `;
                    mobileContainer.appendChild(card);
                }
            });
        }

        function filterOrders() {
            renderOrders();
        }

        function getPhotoNamesFromOr(orStr) {
            if (!orStr) return "";
            return String(orStr).split(/\s+or\s+/i).map(s => s.trim()).filter(Boolean).join(",");
        }

        async function copyOrCode(code) {
            if (!code || code === "undefined") {
                showToast("Không có mã tìm kiếm để copy!", "warning");
                return;
            }
            try {
                await navigator.clipboard.writeText(code);
                showToast("✅ Đã copy mã OR Windows Explorer!");
            } catch (e) {
                prompt("Copy mã tìm kiếm:", code);
            }
        }

        async function updateStatus(rowIndex, newStatus) {
            const order = (rowIndex > 0 && rowIndex <= allOrders.length) ? allOrders[rowIndex - 1] : null;
            const orderId = order ? (order.orderId || "") : "";
            showToast("Đang cập nhật trạng thái...");

            // Cập nhật lên máy chủ trung tâm (Server-side Central Storage)
            fetch("tcController?action=updateOrderStatus&orderId=" + encodeURIComponent(orderId) + "&rowIndex=" + rowIndex + "&status=" + encodeURIComponent(newStatus))
                .catch(err => console.warn("Lỗi sync status lên server:", err));

            // Cập nhật dự phòng lên Google Sheets nếu có
            if (order && order.rowIndex && SCRIPT_URL) {
                try {
                    fetch(SCRIPT_URL + "?action=update_order_status&rowIndex=" + order.rowIndex + "&status=" + encodeURIComponent(newStatus), { mode: 'no-cors' });
                } catch (e) {}
            }

            if (order) order.status = newStatus;
            try { localStorage.setItem("cached_orders_list", JSON.stringify(allOrders)); } catch (e) {}
            renderOrders();
            updateDashboardCounters();
            showToast("✅ Đã cập nhật: " + newStatus);
        }

        // ====================================================
        // ORDER DETAIL MODAL
        // ====================================================
        function openOrderDetailModal(index) {
            const order = allOrders[index];
            if (!order) return;
            currentDetailOrder = order;

            document.getElementById("detailClientName").innerText = order.clientName || "-";
            document.getElementById("detailClientPhone").innerText = order.clientPhone || "Chưa có";
            document.getElementById("detailTime").innerText = order.time || "-";
            document.getElementById("detailCount").innerText = (order.selectedCount || 0) + " ảnh đã chọn";
            document.getElementById("detailOrString").innerText = order.orString || "Chưa có mã OR";

            const genWrap = document.getElementById("detailGeneralNoteWrap");
            if (order.generalNote && order.generalNote.trim()) {
                genWrap.style.display = "block";
                document.getElementById("detailGeneralNote").innerText = order.generalNote;
            } else {
                genWrap.style.display = "none";
            }

            const notesList = document.getElementById("detailNotesList");
            notesList.innerHTML = "";

            let notesMap = order.notes || {};
            if (typeof notesMap === "string") {
                try { notesMap = JSON.parse(notesMap); } catch (e) { notesMap = {}; }
            }

            const noteKeys = Object.keys(notesMap);
            if (noteKeys.length === 0) {
                notesList.innerHTML = `<div class="p-3 text-center text-secondary small rounded" style="background: rgba(0,0,0,0.2);">Khách không để lại ghi chú riêng cho từng tấm ảnh nào.</div>`;
            } else {
                noteKeys.forEach(key => {
                    const item = document.createElement("div");
                    item.className = "p-2 px-3 rounded d-flex justify-content-between align-items-center";
                    item.style.background = "rgba(15, 23, 42, 0.7)";
                    item.style.border = "1px solid rgba(255,255,255,0.06)";
                    item.innerHTML = `
                        <div class="fw-semibold text-white small" style="font-family: monospace;">📸 ${key}</div>
                        <div class="text-warning small fst-italic text-end">${notesMap[key]}</div>
                    `;
                    notesList.appendChild(item);
                });
            }

            const openWebBtn = document.getElementById("btnDetailOpenWeb");
            openWebBtn.href = "/tcController?txtLink=" + encodeURIComponent(order.folderId) + "&picks=" + encodeURIComponent(getPhotoNamesFromOr(order.orString)) + "&action=view";

            document.getElementById("orderDetailModal").classList.add("active");
        }

        function closeOrderDetailModal(e) {
            if (e && e.target && e.target.id !== "orderDetailModal" && !e.target.closest(".btn-close")) return;
            document.getElementById("orderDetailModal").classList.remove("active");
        }

        function copyDetailOrCode() {
            if (currentDetailOrder && currentDetailOrder.orString) {
                copyOrCode(currentDetailOrder.orString);
            }
        }

        function deleteOrder(index) {
            const order = allOrders[index];
            if (!order) return;
            if (!confirm(`Bạn có chắc chắn muốn XÓA đơn chọn ảnh của "${order.clientName || 'khách'}" không?`)) {
                return;
            }

            // Xóa trên máy chủ trung tâm (Server-side Central Storage)
            fetch("tcController?action=deleteOrder&orderId=" + encodeURIComponent(order.orderId || "") + "&rowIndex=" + (index + 1))
                .catch(err => console.warn("Lỗi xóa đơn trên server:", err));

            // Xóa local
            try {
                if (order.folderId) {
                    localStorage.removeItem("latest_submitted_order_" + order.folderId);
                }
            } catch (e) {}

            // Xóa Google Sheets nếu có
            if (order.rowIndex && SCRIPT_URL) {
                try {
                    fetch(SCRIPT_URL + "?action=delete_order&rowIndex=" + order.rowIndex, { mode: 'no-cors' });
                } catch (e) {}
            }

            allOrders.splice(index, 1);
            try { localStorage.setItem("cached_orders_list", JSON.stringify(allOrders)); } catch (e) {}
            renderOrders();
            updateDashboardCounters();
            showToast("🗑 Đã xóa đơn hàng thành công!");
        }

        function deleteCurrentDetailOrder() {
            if (!currentDetailOrder) return;
            const idx = allOrders.indexOf(currentDetailOrder);
            if (idx !== -1) {
                closeOrderDetailModal();
                deleteOrder(idx);
            }
        }

        function editCurrentDetailOrder() {
            if (!currentDetailOrder) return;
            const idx = allOrders.indexOf(currentDetailOrder);
            if (idx !== -1) {
                closeOrderDetailModal();
                openEditOrderModal(idx);
            }
        }

        function openEditOrderModal(index) {
            const order = allOrders[index];
            if (!order) return;
            document.getElementById("editOrderIndex").value = index;
            document.getElementById("editClientName").value = order.clientName || "";
            document.getElementById("editClientPhone").value = order.clientPhone || "";
            document.getElementById("editOrderStatus").value = order.status || "Mới nhận";
            document.getElementById("editGeneralNote").value = order.generalNote || "";
            document.getElementById("orderEditModal").classList.add("active");
        }

        function closeOrderEditModal(e) {
            if (e && e.target && e.target.id !== "orderEditModal" && !e.target.closest(".btn-close") && !e.target.closest(".btn-secondary")) return;
            document.getElementById("orderEditModal").classList.remove("active");
        }

        function saveOrderEdit() {
            const index = parseInt(document.getElementById("editOrderIndex").value, 10);
            const order = allOrders[index];
            if (!order) return;

            const newName = document.getElementById("editClientName").value.trim();
            const newPhone = document.getElementById("editClientPhone").value.trim();
            const newStatus = document.getElementById("editOrderStatus").value;
            const newNote = document.getElementById("editGeneralNote").value.trim();

            order.clientName = newName;
            order.clientPhone = newPhone;
            order.status = newStatus;
            order.generalNote = newNote;

            // Cập nhật local
            try {
                if (order.folderId) {
                    const raw = localStorage.getItem("latest_submitted_order_" + order.folderId);
                    if (raw) {
                        const parsed = JSON.parse(raw);
                        parsed.clientName = newName;
                        parsed.clientPhone = newPhone;
                        parsed.generalNote = newNote;
                        localStorage.setItem("latest_submitted_order_" + order.folderId, JSON.stringify(parsed));
                    }
                }
            } catch (e) {}

            // Cập nhật Google Sheets
            if (order.rowIndex && SCRIPT_URL) {
                try {
                    fetch(SCRIPT_URL + "?action=update_order&rowIndex=" + order.rowIndex + "&name=" + encodeURIComponent(newName) + "&phone=" + encodeURIComponent(newPhone) + "&status=" + encodeURIComponent(newStatus) + "&note=" + encodeURIComponent(newNote), { mode: 'no-cors' });
                } catch (e) {}
            }

            closeOrderEditModal();
            renderOrders();
            updateDashboardCounters();
            showToast("✅ Đã cập nhật thông tin đơn hàng!");
        }

        // ====================================================
        // TAB 2: TẠO ALBUM MỚI (ALBUM CREATOR)
        // ====================================================
        function extractDriveFolderId(input) {
            if (!input) return "";
            input = input.trim();
            // Nếu là URL Drive: https://drive.google.com/drive/folders/ID...
            const matchFolders = input.match(/\/folders\/([a-zA-Z0-9_-]+)/);
            if (matchFolders && matchFolders[1]) return matchFolders[1];

            // Nếu là link id=...
            const matchIdParam = input.match(/[?&]id=([a-zA-Z0-9_-]+)/);
            if (matchIdParam && matchIdParam[1]) return matchIdParam[1];

            // Nếu chỉ dán mã ID thuần
            if (/^[a-zA-Z0-9_-]{20,}$/.test(input)) return input;

            return input;
        }

        const LINK_SCAN_DRIVE = "https://script.google.com/macros/s/AKfycbzk9-pwLjJhNLD1y3ass22-UG9bWwdVleUh95SS2tiFMG_LUZ2NjJUOZ2snVbMM6Glc/exec";

        // Hàm quét số lượng ảnh & ảnh đại diện từ Google Drive
        async function scanFolderInfo(folderId) {
            if (!folderId) return { qty: 0, thumb: "" };

            // 1. Quét qua backend tcController (tận dụng cache server, không bị CORS)
            try {
                const srvRes = await fetch("tcController?action=scanAlbum&id=" + encodeURIComponent(folderId));
                if (srvRes.ok) {
                    const data = await srvRes.json();
                    if (data && (data.qty > 0 || data.thumb)) {
                        return { qty: data.qty || 0, thumb: data.thumb || "" };
                    }
                }
            } catch (e) {
                console.warn("Lỗi scan qua tcController:", e);
            }

            // 2. Dự phòng gọi trực tiếp Google Apps Script quét Drive
            try {
                const scriptRes = await fetch(LINK_SCAN_DRIVE + "?id=" + encodeURIComponent(folderId));
                if (scriptRes.ok) {
                    const images = await scriptRes.json();
                    if (Array.isArray(images) && images.length > 0) {
                        let thumbUrl = images[0].link || "";
                        if (thumbUrl.includes("googleusercontent.com") || thumbUrl.includes("drive.google.com")) {
                            thumbUrl = thumbUrl.replace(/=(w|s|h)[0-9]+[^&]*/, "=s600");
                            if (!thumbUrl.includes("=s600") && !thumbUrl.includes("&sz=s600")) {
                                thumbUrl = thumbUrl.replace(/&sz=[^&]+/, "") + "&sz=s600";
                            }
                        }
                        return { qty: images.length, thumb: thumbUrl };
                    }
                }
            } catch (err) {
                console.warn("Lỗi scan trực tiếp qua Google Apps Script:", err);
            }

            return { qty: 0, thumb: "" };
        }

        // Tự động kiểm tra và vá lại các album bị thiếu ảnh bìa hoặc thiếu số lượng ảnh
        let isAutoHealing = false;
        async function autoHealMissingAlbums() {
            if (isAutoHealing) return;
            isAutoHealing = true;
            try {
                const needHeal = allAlbums.filter(a => a && a.id && (!a.qty || a.qty === 0 || !a.thumb));
                if (needHeal.length === 0) return;

                let updatedAny = false;
                for (const alb of needHeal) {
                    try {
                        const info = await scanFolderInfo(alb.id);
                        if (info && (info.qty > 0 || info.thumb)) {
                            let changed = false;
                            if ((!alb.qty || alb.qty === 0) && info.qty > 0) {
                                alb.qty = info.qty;
                                changed = true;
                            }
                            if (!alb.thumb && info.thumb) {
                                alb.thumb = info.thumb;
                                changed = true;
                            }
                            if (changed) {
                                updatedAny = true;
                                fetch("tcController?action=saveAlbum", {
                                    method: "POST",
                                    headers: { "Content-Type": "application/json; charset=UTF-8" },
                                    body: JSON.stringify(alb)
                                }).catch(() => {});
                            }
                        }
                    } catch (e) {}
                }
                if (updatedAny) {
                    try { localStorage.setItem("cached_albums_list", JSON.stringify(allAlbums)); } catch (e) {}
                    renderAlbums();
                }
            } finally {
                isAutoHealing = false;
            }
        }

        async function handleCreateAlbum() {
            const driveInput = document.getElementById("newAlbumDriveLink").value.trim();
            const albumName = document.getElementById("newAlbumName").value.trim();
            const clientPhone = document.getElementById("newAlbumClientPhone").value.trim();
            const albumNote = document.getElementById("newAlbumNote").value.trim();
            const btn = document.getElementById("btnSubmitCreateAlbum");

            const folderId = extractDriveFolderId(driveInput);
            if (!folderId) {
                showToast("Vui lòng điền link Drive hợp lệ!", "warning");
                return;
            }

            const origText = btn.innerHTML;
            btn.innerHTML = `<span class="spinner-border spinner-border-sm me-2"></span> Đang quét ảnh & tạo album...`;
            btn.disabled = true;

            // Xây dựng link trực tiếp sạch gọn
            let host = window.location.origin;
            if (host.includes("localhost") || host.includes("127.0.0.1")) {
                host = "https://web-lay-anh.onrender.com";
            }
            const cleanUrl = host + "/?id=" + encodeURIComponent(folderId);

            // Rút gọn link (ưu tiên is.gd)
            let shortUrl = cleanUrl;
            try {
                const apiRes = await fetch("/tcController?action=shorten&longUrl=" + encodeURIComponent(cleanUrl));
                if (apiRes.ok) {
                    const text = (await apiRes.text()).trim();
                    if (text.startsWith("http") && !text.toLowerCase().includes("error")) shortUrl = text;
                }
            } catch (e) {}

            // Tự động quét số lượng ảnh & ảnh đại diện
            let autoThumb = "";
            let autoQty = 0;
            try {
                const scanInfo = await scanFolderInfo(folderId);
                if (scanInfo) {
                    autoThumb = scanInfo.thumb || "";
                    autoQty = scanInfo.qty || 0;
                }
            } catch (e) {
                console.warn("Lỗi quét ảnh:", e);
            }

            // 1. LƯU NGAY VÀO KHO ALBUM TRÊN CẢ BROWSER & SERVER TRUNG TÂM
            const newAlbumObj = {
                id: folderId,
                name: albumName,
                clientPhone: clientPhone,
                note: albumNote,
                thumb: autoThumb,
                qty: autoQty,
                time: new Date().toISOString()
            };

            const exIdx = allAlbums.findIndex(a => a.id === folderId);
            if (exIdx !== -1) {
                allAlbums[exIdx] = newAlbumObj;
            } else {
                allAlbums.unshift(newAlbumObj);
            }
            try { localStorage.setItem("cached_albums_list", JSON.stringify(allAlbums)); } catch (e) {}
            updateDashboardCounters();
            renderAlbums();

            // Lưu lên máy chủ Java trung tâm
            fetch("tcController?action=saveAlbum", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify(newAlbumObj)
            }).catch(e => console.warn("Lỗi lưu album lên server:", e));

            // Lưu album vào Google Sheet (tương thích API)
            try {
                fetch(SCRIPT_URL + "?action=create_album&id=" + encodeURIComponent(folderId) + "&name=" + encodeURIComponent(albumName) + "&phone=" + encodeURIComponent(clientPhone) + "&note=" + encodeURIComponent(albumNote) + "&thumb=" + encodeURIComponent(autoThumb) + "&qty=" + autoQty, { mode: 'no-cors' });
            } catch (e) {}

            // Soạn tin nhắn Zalo mẫu cực kỳ chuyên nghiệp
            const zaloMsg = `Chào bạn ${albumName || 'nhé'}! Studio Tuấn Hoa gửi bạn link xem và chọn ảnh nè:
📸 Link xem và chọn ảnh: ${shortUrl}

💡 Hướng dẫn chọn ảnh siêu tiện:
1. Bạn bấm vào ảnh để xem to nét căng và zoom chi tiết.
2. Bấm chọn những ảnh bạn ưng ý nhất.
3. Nếu tấm nào cần ghi chú (VD: bóp eo, xóa người, làm sáng), bạn gõ ngay vào ô ghi chú dưới ảnh nhé.
4. Chọn xong bấm "Chốt danh sách" gửi lại cho Studio là xong nha!`;

            // Hiển thị kết quả
            document.getElementById("resCleanUrl").value = cleanUrl;
            document.getElementById("resShortUrl").value = shortUrl;
            document.getElementById("resZaloMessage").value = zaloMsg;
            document.getElementById("btnPreviewNewAlbum").href = cleanUrl;

            document.getElementById("createResultBox").style.display = "block";
            btn.innerHTML = origText;
            btn.disabled = false;

            showToast("🎉 Đã tạo và thêm album vào Kho Album thành công!");
            document.getElementById("createResultBox").scrollIntoView({ behavior: "smooth" });
        }

        async function copyResultLink(inputId) {
            const input = document.getElementById(inputId);
            if (input && input.value) {
                try {
                    await navigator.clipboard.writeText(input.value);
                    showToast("✅ Đã sao chép liên kết!");
                } catch (e) {
                    prompt("Sao chép link:", input.value);
                }
            }
        }

        async function copyZaloTemplate() {
            const msg = document.getElementById("resZaloMessage").value;
            const phone = document.getElementById("newAlbumClientPhone").value.trim();
            try {
                await navigator.clipboard.writeText(msg);
                showToast("✅ Đã copy tin nhắn Zalo!");
                if (phone) {
                    window.open("https://zalo.me/" + phone, "_blank");
                }
            } catch (e) {
                prompt("Sao chép tin nhắn:", msg);
            }
        }

        // ====================================================
        // ====================================================
        // TAB 3: QUẢN LÝ KHO ALBUM (ALBUMS) - THÊM, SỬA, XÓA & XEM ẢNH KHÁCH CHỌN
        // ====================================================
        function renderAlbums() {
            const grid = document.getElementById("albumsGrid");
            const filterText = (document.getElementById("albumSearchInput").value || "").toLowerCase().trim();

            let filtered = allAlbums.filter(a => {
                if (!a) return false;
                const name = String(a.name || "").toLowerCase();
                const id = String(a.id || "").toLowerCase();
                const phone = String(a.clientPhone || "").toLowerCase();
                const note = String(a.note || "").toLowerCase();
                return name.includes(filterText) ||
                       id.includes(filterText) ||
                       phone.includes(filterText) ||
                       note.includes(filterText);
            });

            if (filtered.length === 0) {
                grid.innerHTML = `<div class="col-12 text-center py-5 text-secondary">
                    <i class="bi bi-images" style="font-size: 36px; opacity: 0.4;"></i>
                    <p class="mt-2 mb-0">Chưa có album nào.</p>
                </div>`;
                return;
            }

            grid.innerHTML = "";
            filtered.forEach(album => {
                try {
                    const col = document.createElement("div");
                    col.className = "col-12 col-sm-6 col-lg-4 col-xl-3";

                    let host = window.location.origin;
                    if (host.includes("localhost") || host.includes("127.0.0.1")) host = "https://web-lay-anh.onrender.com";
                    const albumId = String(album.id || "");
                    const albumName = String(album.name !== undefined && album.name !== null ? album.name : "Album mới");
                    const cleanUrl = host + "/?id=" + encodeURIComponent(albumId);

                    const thumbSrc = album.thumb || "https://placehold.co/400x300/1e293b/38bdf8?text=Tuấn+Hoa+Photo";
                    const albumIndex = allAlbums.indexOf(album);

                    // Tìm kiếm khách đã chốt đơn cho album này
                    const aNameLower = albumName.toLowerCase().trim();
                    const matchingOrders = allOrders.filter(o => {
                        if (!o) return false;
                        const cleanAlbumId = String(albumId || "").trim();
                        const cleanOrderId = String(o.folderId || "").trim();
                        if (cleanAlbumId && cleanOrderId) {
                            if (cleanAlbumId === cleanOrderId) return true;
                            if (cleanAlbumId.length >= 15 && cleanOrderId.length >= 15 && (cleanAlbumId.includes(cleanOrderId) || cleanOrderId.includes(cleanAlbumId))) return true;
                        }
                        const oClientName = String(o.clientName || "").trim().toLowerCase();
                        if (aNameLower.length >= 3 && oClientName.length >= 3 && !oClientName.startsWith("khách")) {
                            if (aNameLower === oClientName) return true;
                        }
                        return false;
                    });

                    let totalClientPicks = 0;
                    let pickList = [];
                    matchingOrders.forEach(mo => {
                        totalClientPicks += (mo.selectedCount || 0);
                        const p = getPhotoNamesFromOr(mo.orString);
                        if (p) pickList.push(p);
                    });
                    const combinedPicks = pickList.join(",");

                    col.innerHTML = `
                        <div class="glass-card h-100 d-flex flex-column">
                            <div class="rounded-3 overflow-hidden mb-3 position-relative" style="height: 180px; background: rgba(0,0,0,0.3);">
                                <img src="${thumbSrc}" class="w-100 h-100 object-fit-cover" onerror="this.src='https://placehold.co/400x300/1e293b/38bdf8?text=Tuấn+Hoa+Photo'">
                                <span class="badge position-absolute top-0 end-0 m-2 bg-black bg-opacity-60 text-white border border-white border-opacity-20">
                                    ${album.qty || 0} ảnh
                                </span>
                            </div>
                            <h6 class="fw-bold text-white text-truncate mb-1" title="${escapeAttr(albumName)}">${escapeHtml(albumName)}</h6>
                            <div class="text-secondary small mb-1" style="font-family: monospace; font-size: 0.75rem;">ID: ${albumId || '-'}</div>
                            ${album.clientPhone ? `<div class="text-info small mb-1"><i class="bi bi-telephone-fill me-1"></i>${album.clientPhone}</div>` : ''}
                            ${album.note ? `<div class="text-secondary small mb-2 text-truncate fst-italic" title="${escapeAttr(String(album.note))}">📝 ${escapeHtml(String(album.note))}</div>` : '<div class="mb-2"></div>'}

                            ${totalClientPicks > 0 ? `
                                <a href="/tcController?txtLink=${encodeURIComponent(albumId)}&picks=${encodeURIComponent(combinedPicks)}&action=view" target="_blank" class="btn-album-customer-picks" title="Xem ${totalClientPicks} ảnh khách đã chốt cho album này">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="picks-count-pill"><i class="bi bi-check-lg"></i> ${totalClientPicks}</span>
                                        <span class="text-white fw-bold">Khách đã chốt</span>
                                    </div>
                                    <div class="d-flex align-items-center gap-1 text-white-50" style="font-size: 0.76rem;">
                                        <span>Xem ảnh</span>
                                        <i class="bi bi-arrow-right-short picks-arrow text-white fs-5"></i>
                                    </div>
                                </a>
                            ` : `
                                <div class="album-no-picks-box">
                                    <i class="bi bi-hourglass-split me-1 text-secondary"></i>
                                    <span>Chưa có ảnh khách chọn</span>
                                </div>
                            `}

                            <div class="mt-auto d-flex gap-2 flex-wrap">
                                <a href="${cleanUrl}" target="_blank" class="btn-glass-sm flex-grow-1 justify-content-center text-decoration-none" title="Xem thử album gốc">
                                    <i class="bi bi-eye"></i> Mở album
                                </a>
                                <button class="btn-glass-sm" onclick="copyOrCode('${cleanUrl}')" title="Copy Link Album">
                                    <i class="bi bi-link-45deg"></i>
                                </button>
                                <button class="btn-glass-sm text-warning" onclick="openEditAlbumModal(${albumIndex})" title="Sửa album">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn-glass-sm text-danger" onclick="deleteAlbum(${albumIndex})" title="Xóa album">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                    `;
                    grid.appendChild(col);
                } catch (albumRenderErr) {
                    console.error("Lỗi khi render thẻ album:", album, albumRenderErr);
                }
            });
        }

        function filterAlbums() {
            renderAlbums();
        }

        // ====================================================
        // THAO TÁC KHO ALBUM: THÊM, SỬA, XÓA
        // ====================================================
        function openAlbumCreateModal() {
            document.getElementById("quickAlbumDriveLink").value = "";
            document.getElementById("quickAlbumName").value = "";
            document.getElementById("quickAlbumPhone").value = "";
            document.getElementById("quickAlbumNote").value = "";
            document.getElementById("albumCreateModal").classList.add("active");
            document.getElementById("quickAlbumDriveLink").focus();
        }

        function closeAlbumCreateModal(e) {
            if (e && e.target && e.target.id !== "albumCreateModal" && !e.target.closest(".btn-close") && !e.target.closest(".btn-secondary")) return;
            document.getElementById("albumCreateModal").classList.remove("active");
        }

        async function handleQuickCreateAlbum() {
            const driveInput = document.getElementById("quickAlbumDriveLink").value.trim();
            const albumName = document.getElementById("quickAlbumName").value.trim();
            const phone = document.getElementById("quickAlbumPhone").value.trim();
            const note = document.getElementById("quickAlbumNote").value.trim();
            const btn = document.getElementById("btnQuickSubmitAlbum");

            const folderId = extractDriveFolderId(driveInput);
            if (!folderId) {
                showToast("Vui lòng điền link Drive hoặc Folder ID hợp lệ!", "warning");
                document.getElementById("quickAlbumDriveLink").focus();
                return;
            }
            if (!albumName) {
                showToast("Vui lòng nhập Tên Album!", "warning");
                document.getElementById("quickAlbumName").focus();
                return;
            }

            const origBtn = btn.innerHTML;
            btn.innerHTML = `<span class="spinner-border spinner-border-sm me-1"></span> Đang quét ảnh...`;
            btn.disabled = true;

            // Tự động quét số lượng ảnh & ảnh đại diện
            let autoThumb = "";
            let autoQty = 0;
            try {
                const scanInfo = await scanFolderInfo(folderId);
                if (scanInfo) {
                    autoThumb = scanInfo.thumb || "";
                    autoQty = scanInfo.qty || 0;
                }
            } catch (e) {
                console.warn("Lỗi quét nhanh thông tin album:", e);
            }

            const newAlbum = {
                id: folderId,
                name: albumName,
                clientPhone: phone,
                note: note,
                thumb: autoThumb,
                qty: autoQty,
                time: new Date().toISOString()
            };

            allAlbums.unshift(newAlbum);
            try {
                localStorage.setItem("cached_albums_list", JSON.stringify(allAlbums));
            } catch (e) {}

            renderAlbums();
            updateDashboardCounters();

            // Lưu lên máy chủ Java trung tâm
            fetch("tcController?action=saveAlbum", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify(newAlbum)
            }).catch(e => console.warn("Lỗi lưu album lên server:", e));

            // Đồng bộ lên Google Sheets
            if (SCRIPT_URL) {
                try {
                    fetch(SCRIPT_URL + "?action=create_album&id=" + encodeURIComponent(folderId) + "&name=" + encodeURIComponent(albumName) + "&phone=" + encodeURIComponent(phone) + "&note=" + encodeURIComponent(note) + "&thumb=" + encodeURIComponent(autoThumb) + "&qty=" + autoQty, { mode: 'no-cors' });
                } catch (e) {}
            }

            btn.innerHTML = origBtn;
            btn.disabled = false;
            closeAlbumCreateModal();
            showToast("🎉 Đã thêm album mới vào kho thành công!");
        }

        function openEditAlbumModal(index) {
            const album = allAlbums[index];
            if (!album) return;
            document.getElementById("editAlbumIndex").value = index;
            document.getElementById("editAlbumName").value = (album.name !== undefined && album.name !== null) ? album.name : "";
            document.getElementById("editAlbumFolderId").value = album.id || "";
            document.getElementById("editAlbumPhone").value = album.clientPhone || "";
            document.getElementById("editAlbumNote").value = album.note || "";
            document.getElementById("editAlbumThumb").value = album.thumb || "";
            document.getElementById("albumEditModal").classList.add("active");
        }

        function closeAlbumEditModal(e) {
            if (e && e.target && e.target.id !== "albumEditModal" && !e.target.closest(".btn-close") && !e.target.closest(".btn-secondary")) return;
            document.getElementById("albumEditModal").classList.remove("active");
        }

        async function saveAlbumEdit() {
            const index = parseInt(document.getElementById("editAlbumIndex").value, 10);
            const album = allAlbums[index];
            if (!album) return;

            const newName = document.getElementById("editAlbumName").value.trim();
            const newId = extractDriveFolderId(document.getElementById("editAlbumFolderId").value.trim());
            const newPhone = document.getElementById("editAlbumPhone").value.trim();
            const newNote = document.getElementById("editAlbumNote").value.trim();
            const newThumb = document.getElementById("editAlbumThumb").value.trim();

            if (!newName) {
                showToast("Tên album không được để trống!", "warning");
                return;
            }
            if (!newId) {
                showToast("Folder ID không được để trống!", "warning");
                return;
            }

            album.name = newName;
            album.id = newId;
            album.clientPhone = newPhone;
            album.note = newNote;
            if (newThumb) album.thumb = newThumb;

            try {
                localStorage.setItem("cached_albums_list", JSON.stringify(allAlbums));
            } catch (e) {}

            renderAlbums();

            // Gửi cập nhật về Google Sheets
            if (album.rowIndex && SCRIPT_URL) {
                try {
                    fetch(SCRIPT_URL + "?action=updateAlbum&rowIndex=" + album.rowIndex + "&name=" + encodeURIComponent(newName) + "&id=" + encodeURIComponent(newId) + "&phone=" + encodeURIComponent(newPhone) + "&note=" + encodeURIComponent(newNote) + "&thumb=" + encodeURIComponent(newThumb), { mode: 'no-cors' });
                } catch (e) {}
            }

            closeAlbumEditModal();
            showToast("✅ Đã lưu thay đổi album thành công!");
        }

        function deleteAlbum(index) {
            const album = allAlbums[index];
            if (!album) return;
            if (!confirm(`Bạn có chắc chắn muốn XÓA album "${album.name || 'này'}" khỏi kho không?`)) {
                return;
            }

            // Xóa trên máy chủ Java trung tâm
            fetch("tcController?action=deleteAlbum&id=" + encodeURIComponent(album.id || "") + "&folderId=" + encodeURIComponent(album.id || ""))
                .catch(err => console.warn("Lỗi xóa album trên server:", err));

            if (album.rowIndex && SCRIPT_URL) {
                try {
                    fetch(SCRIPT_URL + "?action=deleteAlbum&rowIndex=" + album.rowIndex, { mode: 'no-cors' });
                } catch (e) {}
            }

            allAlbums.splice(index, 1);
            try {
                localStorage.setItem("cached_albums_list", JSON.stringify(allAlbums));
            } catch (e) {}

            renderAlbums();
            updateDashboardCounters();
            showToast("🗑 Đã xóa album khỏi kho thành công!");
        }

        // ====================================================
        // TAB 4: CÀI ĐẶT
        // ====================================================
        function loadSettingsToInputs() {
            document.getElementById("cfgScriptUrl").value = SCRIPT_URL;
            document.getElementById("cfgAdminPin").value = ADMIN_PIN;
            document.getElementById("cfgStudioPhone").value = STUDIO_PHONE;
        }

        function saveSettings() {
            const scriptUrl = document.getElementById("cfgScriptUrl").value.trim();
            const pin = document.getElementById("cfgAdminPin").value.trim();
            const phone = document.getElementById("cfgStudioPhone").value.trim();

            if (scriptUrl) {
                SCRIPT_URL = scriptUrl;
                localStorage.setItem("studio_script_url", scriptUrl);
            }
            if (pin) {
                ADMIN_PIN = pin;
                localStorage.setItem("studio_admin_pin", pin);
            }
            if (phone) {
                STUDIO_PHONE = phone;
                localStorage.setItem("studio_phone", phone);
            }

            showToast("✅ Đã lưu cấu hình cài đặt!");
            loadAllData();
        }

        function togglePinView() {
            const pinInput = document.getElementById("cfgAdminPin");
            const icon = document.getElementById("pinEyeIcon");
            if (pinInput.type === "password") {
                pinInput.type = "text";
                icon.className = "bi bi-eye-slash";
            } else {
                pinInput.type = "password";
                icon.className = "bi bi-eye";
            }
        }

        // ====================================================
        // TIỆN ÍCH DYNAMIC ISLAND TOAST & HELPERS
        // ====================================================
        let toastTimer = null;
        function showToast(msg, type) {
            const toast = document.getElementById("toast");
            const msgEl = document.getElementById("toastMsg");
            const icon = document.getElementById("toastIcon");

            if (!toast || !msgEl) return;
            msgEl.innerText = msg;

            if (type === "warning") {
                icon.className = "bi bi-exclamation-triangle-fill text-warning";
            } else if (type === "danger") {
                icon.className = "bi bi-x-circle-fill text-danger";
            } else {
                icon.className = "bi bi-check-circle-fill text-info";
            }

            toast.classList.add("show");
            if (toastTimer) clearTimeout(toastTimer);
            toastTimer = setTimeout(() => {
                toast.classList.remove("show");
            }, 2200);
        }

        function escapeAttr(str) {
            if (!str && str !== 0) return "";
            return String(str).replace(/"/g, '&quot;').replace(/'/g, '&#39;');
        }

        function escapeHtml(str) {
            if (!str && str !== 0) return "";
            return String(str)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }
    </script>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
