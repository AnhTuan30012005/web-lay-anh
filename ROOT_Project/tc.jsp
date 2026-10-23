<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.util.ArrayList" %>
            <%@ page import="java.net.URLEncoder" %>
            <%@ page import="Controller.tcController.ImageModel" %>

                <%! public String escapeHtml(String input) { if (input==null) return "" ; return
                    input.replace("&", "&amp;" ) .replace("<", "&lt;" ) .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
                    }

                    public String escapeJs(String input) {
                    if (input == null) return "";
                    return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("'", "\\'")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
                    }
                    %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport"
                            content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes, viewport-fit=cover">
                        <meta name="referrer" content="no-referrer">

                        <title>Get Ảnh Google Drive - Tuan Hoa</title>
                        <link rel="icon" type="image/jpeg" href="tuan.jpg">

                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
                        <link
                            href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                            rel="stylesheet">

                        <style>
                            :root {
                                --glass-bg: rgba(255, 255, 255, 0.07);
                                --glass-border: 1px solid rgba(255, 255, 255, 0.15);
                                --glass-shadow: 0 12px 35px 0 rgba(0, 0, 0, 0.45);
                                --text-main: #f1f5f9;
                                --brand-color: #0ea5e9;
                                --brand-hover: #38bdf8;
                                --accent-green: #10b981;
                            }

                            * {
                                box-sizing: border-box;
                            }

                            body {
                                background: radial-gradient(circle at 15% 15%, rgb(17, 24, 39) 0%, rgb(10, 15, 29) 100%);
                                color: var(--text-main);
                                font-family: 'Poppins', sans-serif;
                                min-height: 100vh;
                                padding-bottom: 140px;
                                margin: 0;
                                overflow-x: hidden;
                                -webkit-font-smoothing: antialiased;
                            }

                            /* Navbar */
                            .navbar-glass {
                                background: rgba(15, 23, 42, 0.88) !important;
                                backdrop-filter: blur(16px);
                                -webkit-backdrop-filter: blur(16px);
                                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                                padding: 12px 0;
                                transition: all 0.3s ease;
                            }

                            .nav-logo {
                                width: 38px;
                                height: 38px;
                                object-fit: cover;
                                border-radius: 50%;
                                border: 2px solid rgba(14, 165, 233, 0.6);
                                box-shadow: 0 0 12px rgba(14, 165, 233, 0.4);
                            }

                            /* Glass Panels */
                            .glass-panel {
                                background: var(--glass-bg);
                                backdrop-filter: blur(20px);
                                -webkit-backdrop-filter: blur(20px);
                                border: var(--glass-border);
                                border-radius: 18px;
                                box-shadow: var(--glass-shadow);
                                padding: 24px;
                                transition: all 0.3s ease;
                            }

                            .glass-input {
                                background: rgba(15, 23, 42, 0.6) !important;
                                border: 1px solid rgba(255, 255, 255, 0.14) !important;
                                color: white !important;
                                border-radius: 12px;
                                padding: 12px 16px;
                                transition: all 0.25s ease;
                            }

                            .glass-input:focus {
                                background: rgba(15, 23, 42, 0.85) !important;
                                border-color: var(--brand-color) !important;
                                box-shadow: 0 0 16px rgba(14, 165, 233, 0.35);
                            }

                            .glass-input::placeholder {
                                color: rgba(255, 255, 255, 0.4);
                            }

                            /* Modern Buttons */
                            .btn-neo {
                                border: none;
                                border-radius: 12px;
                                padding: 11px 22px;
                                font-weight: 600;
                                transition: all 0.25s ease;
                                letter-spacing: 0.3px;
                                display: inline-flex;
                                align-items: center;
                                justify-content: center;
                            }

                            .btn-primary-glow {
                                background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
                                color: white;
                                box-shadow: 0 4px 15px rgba(14, 165, 233, 0.35);
                            }

                            .btn-primary-glow:hover {
                                background: linear-gradient(135deg, #38bdf8 0%, #1d4ed8 100%);
                                box-shadow: 0 6px 20px rgba(14, 165, 233, 0.55);
                                transform: translateY(-1px);
                                color: white;
                            }

                            .btn-success-glow {
                                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                                color: white;
                                box-shadow: 0 4px 15px rgba(16, 185, 129, 0.35);
                            }

                            .btn-success-glow:hover {
                                background: linear-gradient(135deg, #34d399 0%, #047857 100%);
                                box-shadow: 0 6px 20px rgba(16, 185, 129, 0.55);
                                transform: translateY(-1px);
                                color: white;
                            }

                            /* Photo Cards */
                            .photo-card {
                                background: #1e293b;
                                border: 2px solid transparent;
                                border-radius: 14px;
                                overflow: hidden;
                                position: relative;
                                cursor: pointer;
                                aspect-ratio: 3/4;
                                transition: transform 0.22s ease, border-color 0.22s ease, box-shadow 0.22s ease;
                                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
                                will-change: transform;
                            }

                            .photo-card:hover {
                                transform: translateY(-4px) scale(1.01);
                                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.5);
                            }

                            .photo-card.selected {
                                border-color: var(--brand-color);
                                box-shadow: 0 0 18px rgba(14, 165, 233, 0.6);
                            }

                            /* Checkbox & Quick Download Buttons on Card */
                            .btn-select-item {
                                position: absolute;
                                top: 10px;
                                right: 10px;
                                width: 32px;
                                height: 32px;
                                border-radius: 50%;
                                background: rgba(0, 0, 0, 0.55);
                                border: 2px solid rgba(255, 255, 255, 0.7);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                z-index: 20;
                                transition: all 0.2s ease;
                                color: transparent;
                                cursor: pointer;
                                backdrop-filter: blur(4px);
                            }

                            .btn-select-item:hover {
                                transform: scale(1.1);
                                border-color: #fff;
                            }

                            .photo-card.selected .btn-select-item {
                                background: var(--brand-color);
                                border-color: var(--brand-color);
                                color: white;
                                box-shadow: 0 0 10px rgba(14, 165, 233, 0.8);
                            }

                            .btn-quick-dl {
                                position: absolute;
                                top: 10px;
                                left: 10px;
                                width: 32px;
                                height: 32px;
                                border-radius: 50%;
                                background: rgba(0, 0, 0, 0.55);
                                border: 1px solid rgba(255, 255, 255, 0.3);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                z-index: 20;
                                transition: all 0.2s ease;
                                color: white;
                                cursor: pointer;
                                opacity: 0;
                                backdrop-filter: blur(4px);
                            }

                            .photo-card:hover .btn-quick-dl {
                                opacity: 1;
                            }

                            .btn-quick-dl:hover {
                                background: var(--brand-color);
                                transform: scale(1.1);
                                color: white;
                            }

                            /* Skeleton & Image Loading */
                            @keyframes shimmer {
                                0% {
                                    background-position: -800px 0;
                                }

                                100% {
                                    background-position: 800px 0;
                                }
                            }

                            .skeleton-loader {
                                position: absolute;
                                top: 0;
                                left: 0;
                                width: 100%;
                                height: 100%;
                                background: linear-gradient(to right, #1e293b 8%, #334155 24%, #1e293b 40%);
                                background-size: 800px 100%;
                                animation: shimmer 1.8s infinite linear;
                                z-index: 5;
                            }

                            .gallery-img {
                                width: 100%;
                                height: 100%;
                                object-fit: cover;
                                opacity: 0;
                                transition: opacity 0.35s ease-in-out;
                                position: absolute;
                                top: 0;
                                left: 0;
                                z-index: 6;
                            }

                            .gallery-img.loaded {
                                opacity: 1;
                            }

                            .file-name {
                                position: absolute;
                                bottom: 0;
                                left: 0;
                                right: 0;
                                background: linear-gradient(to top, rgba(0, 0, 0, 0.85) 0%, rgba(0, 0, 0, 0.4) 70%, transparent 100%);
                                backdrop-filter: blur(3px);
                                padding: 10px 8px 6px;
                                font-size: 0.76rem;
                                text-align: center;
                                color: #e2e8f0;
                                z-index: 20;
                                pointer-events: none;
                                white-space: nowrap;
                                overflow: hidden;
                                text-overflow: ellipsis;
                            }

                            /* Floating Download Bar */
                            .floating-bar {
                                position: fixed;
                                bottom: 25px;
                                left: 50%;
                                transform: translateX(-50%) translateY(160px);
                                background: rgba(15, 23, 42, 0.94);
                                backdrop-filter: blur(24px);
                                -webkit-backdrop-filter: blur(24px);
                                border: 1px solid rgba(255, 255, 255, 0.22);
                                padding: 10px 24px;
                                border-radius: 60px;
                                display: flex;
                                align-items: center;
                                gap: 18px;
                                box-shadow: 0 14px 45px rgba(0, 0, 0, 0.65);
                                transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1);
                                z-index: 1000;
                            }

                            .floating-bar.active {
                                transform: translateX(-50%) translateY(0);
                            }

                            /* ==================================================== */
                            /* GOOGLE DRIVE STYLE IMAGE VIEWER / MODAL */
                            /* ==================================================== */
                            .image-modal {
                                display: none;
                                position: fixed;
                                z-index: 9999;
                                left: 0;
                                top: 0;
                                width: 100%;
                                height: 100%;
                                background-color: rgba(5, 8, 16, 0.97);
                                backdrop-filter: blur(18px);
                                -webkit-backdrop-filter: blur(18px);
                                opacity: 0;
                                transition: opacity 0.25s ease-out;
                                user-select: none;
                                -webkit-user-select: none;
                                overflow: hidden;
                            }

                            .image-modal.show {
                                display: flex;
                                flex-direction: column;
                                opacity: 1;
                            }

                            /* Top Bar of Viewer (Tối giản phong cách Apple Photos) */
                            .modal-top-bar {
                                position: absolute;
                                top: 0;
                                left: 0;
                                right: 0;
                                height: 56px;
                                padding: 0 20px;
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                                background: linear-gradient(to bottom, rgba(15, 23, 42, 0.85) 0%, rgba(15, 23, 42, 0.25) 75%, transparent 100%);
                                backdrop-filter: blur(8px);
                                -webkit-backdrop-filter: blur(8px);
                                border-bottom: 1px solid rgba(255, 255, 255, 0.08);
                                z-index: 10005;
                                transition: opacity 0.3s cubic-bezier(0.16, 1, 0.3, 1), transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
                            }

                            .modal-title-info {
                                display: flex;
                                align-items: center;
                                gap: 10px;
                                overflow: hidden;
                            }

                            .modal-img-counter {
                                background: rgba(14, 165, 233, 0.2);
                                color: #38bdf8;
                                border: 1px solid rgba(14, 165, 233, 0.4);
                                padding: 3px 10px;
                                border-radius: 20px;
                                font-size: 0.8rem;
                                font-weight: 600;
                                white-space: nowrap;
                            }

                            .modal-img-name {
                                font-size: 0.95rem;
                                font-weight: 500;
                                color: #fff;
                                max-width: 340px;
                                overflow: hidden;
                                text-overflow: ellipsis;
                                white-space: nowrap;
                            }

                            .modal-top-actions {
                                display: flex;
                                align-items: center;
                            }

                            .btn-tool {
                                background: rgba(255, 255, 255, 0.1);
                                border: 1px solid rgba(255, 255, 255, 0.15);
                                color: #fff;
                                width: 38px;
                                height: 38px;
                                border-radius: 50%;
                                display: inline-flex;
                                align-items: center;
                                justify-content: center;
                                font-size: 1.05rem;
                                cursor: pointer;
                                transition: all 0.2s ease;
                            }

                            .btn-tool:hover {
                                background: rgba(255, 255, 255, 0.25);
                                color: #38bdf8;
                                transform: scale(1.05);
                            }

                            /* Center Canvas / Touch Container (Toàn màn hình) */
                            .modal-stage {
                                width: 100%;
                                height: 100%;
                                position: relative;
                                overflow: hidden;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                touch-action: none;
                                cursor: default;
                            }

                            .modal-content-img {
                                max-width: 96%;
                                max-height: 94%;
                                object-fit: contain;
                                border-radius: 6px;
                                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.85);
                                transform-origin: center center;
                                will-change: transform;
                                transition: transform 0.05s ease-out;
                                pointer-events: auto;
                            }

                            /* Navigation Arrows */
                            .modal-nav-btn {
                                position: absolute;
                                top: 50%;
                                transform: translateY(-50%);
                                width: 52px;
                                height: 52px;
                                border-radius: 50%;
                                background: rgba(15, 23, 42, 0.65);
                                border: 1px solid rgba(255, 255, 255, 0.15);
                                backdrop-filter: blur(8px);
                                color: white;
                                font-size: 1.6rem;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                cursor: pointer;
                                z-index: 10002;
                                transition: all 0.2s ease;
                            }

                            .modal-nav-btn:hover {
                                background: var(--brand-color);
                                color: white;
                                transform: translateY(-50%) scale(1.1);
                            }

                            .nav-prev {
                                left: 20px;
                            }

                            .nav-next {
                                right: 20px;
                            }

                            /* Bottom Floating Bar in Modal (Chứa ô ghi chú và nút Chọn / Tải) */
                            .modal-bottom-bar {
                                position: absolute;
                                bottom: 20px;
                                left: 50%;
                                transform: translateX(-50%);
                                display: flex;
                                flex-direction: column;
                                align-items: center;
                                justify-content: center;
                                gap: 8px;
                                background: rgba(15, 23, 42, 0.88);
                                backdrop-filter: blur(20px);
                                -webkit-backdrop-filter: blur(20px);
                                border: 1px solid rgba(255, 255, 255, 0.16);
                                border-radius: 20px;
                                padding: 10px 14px;
                                box-shadow: 0 12px 35px rgba(0, 0, 0, 0.65);
                                z-index: 10005;
                                width: min(92vw, 440px);
                                transition: opacity 0.3s cubic-bezier(0.16, 1, 0.3, 1), transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
                            }

                            .modal-note-box {
                                width: 100%;
                                display: flex;
                                align-items: center;
                                background: rgba(255, 255, 255, 0.08);
                                border: 1px solid rgba(255, 255, 255, 0.14);
                                border-radius: 12px;
                                padding: 5px 12px;
                                transition: all 0.2s ease;
                            }

                            .modal-note-box:focus-within {
                                background: rgba(255, 255, 255, 0.14);
                                border-color: #38bdf8;
                                box-shadow: 0 0 12px rgba(56, 189, 248, 0.25);
                            }

                            .modal-note-input {
                                flex-grow: 1;
                                background: transparent;
                                border: none;
                                outline: none;
                                color: #fff;
                                font-size: 0.86rem;
                                padding: 4px 0;
                            }

                            .modal-note-input::placeholder {
                                color: rgba(255, 255, 255, 0.45);
                                font-size: 0.82rem;
                            }

                            .btn-clear-note {
                                background: transparent;
                                border: none;
                                color: rgba(255, 255, 255, 0.45);
                                cursor: pointer;
                                padding: 0 4px;
                                font-size: 0.95rem;
                                transition: color 0.2s;
                            }

                            .btn-clear-note:hover {
                                color: #f87171;
                            }

                            .modal-bottom-bar .btn-neo {
                                padding: 6px 16px;
                                font-size: 0.85rem;
                                border-radius: 30px;
                                letter-spacing: 0.2px;
                            }

                            /* Badge hiển thị trên card ảnh có ghi chú */
                            .badge-card-note {
                                position: absolute;
                                bottom: 34px;
                                left: 10px;
                                background: rgba(14, 165, 233, 0.92);
                                color: white;
                                font-size: 0.72rem;
                                font-weight: 500;
                                padding: 2px 7px;
                                border-radius: 10px;
                                backdrop-filter: blur(4px);
                                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.4);
                                z-index: 5;
                                pointer-events: none;
                                display: inline-flex;
                                align-items: center;
                                gap: 4px;
                            }

                            /* Custom Order Modal Backdrop */
                            .custom-modal-backdrop {
                                display: none;
                                position: fixed;
                                top: 0;
                                left: 0;
                                width: 100vw;
                                height: 100vh;
                                background: rgba(0, 0, 0, 0.82);
                                backdrop-filter: blur(12px);
                                -webkit-backdrop-filter: blur(12px);
                                z-index: 10010;
                                align-items: center;
                                justify-content: center;
                                padding: 16px;
                                opacity: 0;
                                transition: opacity 0.25s ease;
                            }

                            .custom-modal-backdrop.show {
                                display: flex;
                                opacity: 1;
                            }

                            .custom-modal-box {
                                background: rgba(15, 23, 42, 0.96) !important;
                                border: 1px solid rgba(255, 255, 255, 0.18) !important;
                                border-radius: 24px !important;
                                width: 100%;
                                max-width: 500px;
                                max-height: 90vh;
                                overflow-y: auto;
                                padding: 24px !important;
                                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.85);
                                transform: scale(0.92);
                                transition: transform 0.25s cubic-bezier(0.16, 1, 0.3, 1);
                            }

                            .custom-modal-backdrop.show .custom-modal-box {
                                transform: scale(1);
                            }

                            /* Chế độ Chìm đắm (Immersive Mode: Chạm để ẩn toàn bộ thanh công cụ) */
                            .image-modal.ui-hidden .modal-top-bar {
                                opacity: 0;
                                transform: translateY(-100%);
                                pointer-events: none;
                            }

                            .image-modal.ui-hidden .modal-bottom-bar {
                                opacity: 0;
                                transform: translateX(-50%) translateY(40px);
                                pointer-events: none;
                            }

                            .image-modal.ui-hidden .modal-nav-btn {
                                opacity: 0;
                                pointer-events: none;
                            }

                            /* ==================================================== */
                            /* SIÊU TỐI ƯU GIAO DIỆN DI ĐỘNG (MOBILE COMPACT & CLEAN) */
                            /* ==================================================== */
                            @media (max-width: 768px) {
                                /* 1. Header Navigation siêu mỏng gọn */
                                .navbar-glass {
                                    padding: 6px 12px !important;
                                }
                                .nav-logo {
                                    width: 32px !important;
                                    height: 32px !important;
                                    margin-right: 8px !important;
                                }
                                .navbar-brand .lh-1 {
                                    font-size: 0.95rem !important;
                                }
                                .container[style*="margin-top"] {
                                    margin-top: 62px !important;
                                    padding-left: 8px !important;
                                    padding-right: 8px !important;
                                }

                                /* 2. Khung Tìm Kiếm / Lọc siêu gọn gàng */
                                .search-panel-box {
                                    padding: 8px 10px !important;
                                    margin-bottom: 8px !important;
                                    border-radius: 14px !important;
                                }
                                .search-panel-box .glass-input {
                                    padding: 7px 12px !important;
                                    font-size: 0.85rem !important;
                                }
                                .search-panel-box .btn-neo {
                                    padding: 7px 14px !important;
                                    font-size: 0.85rem !important;
                                }

                                /* 3. Thanh Thao Tác Dạng Cuộn Ngang (Action Chips Strip) */
                                .action-stat-bar {
                                    padding: 6px 8px !important;
                                    margin-bottom: 8px !important;
                                    border-radius: 12px !important;
                                    display: flex !important;
                                    flex-wrap: nowrap !important;
                                    overflow-x: auto !important;
                                    -webkit-overflow-scrolling: touch;
                                    scrollbar-width: none !important;
                                    gap: 6px !important;
                                }
                                .action-stat-bar::-webkit-scrollbar {
                                    display: none !important;
                                }
                                .action-stat-bar .btn, .action-stat-bar .badge {
                                    flex-shrink: 0 !important;
                                    font-size: 0.76rem !important;
                                    padding: 5px 10px !important;
                                    white-space: nowrap !important;
                                }

                                /* 4. Banner Thông Báo Ảnh Đã Chọn */
                                #picksBanner {
                                    padding: 8px 10px !important;
                                    margin-bottom: 8px !important;
                                    border-radius: 12px !important;
                                }
                                #picksBanner .fs-6 {
                                    font-size: 0.82rem !important;
                                }
                                #picksBanner .picks-banner-desc {
                                    display: none !important;
                                }
                                #picksBanner .rounded-circle {
                                    width: 30px !important;
                                    height: 30px !important;
                                    font-size: 14px !important;
                                }
                                #picksBanner .btn {
                                    padding: 4px 10px !important;
                                    font-size: 0.75rem !important;
                                }

                                /* 5. Lưới Ảnh Tinh Gọn (Instagram / Apple Photos Grid) */
                                #galleryContainer {
                                    --bs-gutter-x: 6px !important;
                                    --bs-gutter-y: 6px !important;
                                }
                                .photo-card {
                                    border-radius: 10px !important;
                                }
                                .photo-card:hover {
                                    transform: none !important;
                                }
                                .btn-select-item {
                                    width: 30px !important;
                                    height: 30px !important;
                                    top: 6px !important;
                                    right: 6px !important;
                                    font-size: 0.95rem !important;
                                }
                                .btn-quick-dl {
                                    width: 26px !important;
                                    height: 26px !important;
                                    top: 6px !important;
                                    left: 6px !important;
                                    font-size: 0.8rem !important;
                                    opacity: 0.85 !important;
                                    background: rgba(0, 0, 0, 0.65) !important;
                                }
                                .badge-card-note {
                                    bottom: 24px !important;
                                    left: 6px !important;
                                    font-size: 0.62rem !important;
                                    padding: 1px 5px !important;
                                    border-radius: 6px !important;
                                }
                                .file-name {
                                    padding: 4px 6px 3px !important;
                                    font-size: 0.68rem !important;
                                }

                                /* 6. Thanh Dock Dưới Đáy Màn Hình (Apple Glass Bottom Dock) */
                                .floating-bar {
                                    width: calc(100% - 16px) !important;
                                    max-width: min(520px, calc(100vw - 16px)) !important;
                                    box-sizing: border-box !important;
                                    bottom: max(10px, env(safe-area-inset-bottom, 10px)) !important;
                                    padding: 6px 12px !important;
                                    border-radius: 24px !important;
                                    gap: 6px !important;
                                    justify-content: space-between !important;
                                    flex-wrap: nowrap !important;
                                    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.75) !important;
                                }
                                .floating-bar .selected-info {
                                    font-size: 0.82rem !important;
                                    white-space: nowrap !important;
                                    display: flex !important;
                                    align-items: center !important;
                                    gap: 3px !important;
                                }
                                .floating-bar .btn-group-actions {
                                    display: flex !important;
                                    align-items: center !important;
                                    gap: 6px !important;
                                    flex-shrink: 0 !important;
                                    border-left: none !important;
                                    padding-left: 0 !important;
                                    margin-left: 0 !important;
                                }
                                .floating-bar .btn-chot-order {
                                    padding: 7px 14px !important;
                                    font-size: 0.82rem !important;
                                    font-weight: 700 !important;
                                    border-radius: 20px !important;
                                }
                                .floating-bar .btn-icon-mobile {
                                    width: 34px !important;
                                    height: 34px !important;
                                    padding: 0 !important;
                                    display: inline-flex !important;
                                    align-items: center !important;
                                    justify-content: center !important;
                                    border-radius: 50% !important;
                                    font-size: 0.9rem !important;
                                }
                                .floating-bar .btn-icon-mobile span {
                                    display: none !important;
                                }

                                /* 7. Modal Xem Ảnh Căng Nét */
                                .modal-top-bar {
                                    height: 48px !important;
                                    padding: 0 12px !important;
                                }
                                .modal-img-counter {
                                    padding: 2px 7px !important;
                                    font-size: 0.72rem !important;
                                }
                                .modal-img-name {
                                    max-width: 140px !important;
                                    font-size: 0.78rem !important;
                                }
                                .modal-nav-btn {
                                    width: 36px !important;
                                    height: 36px !important;
                                    font-size: 1rem !important;
                                    opacity: 0.65 !important;
                                }
                                .modal-bottom-bar {
                                    width: min(94vw, 400px) !important;
                                    bottom: max(8px, env(safe-area-inset-bottom, 8px)) !important;
                                    padding: 6px 10px !important;
                                    border-radius: 16px !important;
                                    gap: 6px !important;
                                }
                                .modal-note-box {
                                    padding: 4px 8px !important;
                                }
                                .modal-note-input {
                                    font-size: 0.8rem !important;
                                }
                                .modal-bottom-bar .btn-neo {
                                    padding: 5px 12px !important;
                                    font-size: 0.8rem !important;
                                }

                                /* 8. Modal Xác Nhận Gửi Đơn */
                                .custom-modal-backdrop {
                                    padding: 8px !important;
                                }
                                .custom-modal-box {
                                    padding: 16px !important;
                                    border-radius: 18px !important;
                                }
                                .custom-modal-box .form-control {
                                    font-size: 16px !important;
                                }
                            }
                        </style>
                    </head>

                    <body>

                        <!-- Header Navigation -->
                        <nav class="navbar navbar-dark navbar-glass mb-4 fixed-top">
                            <div class="container d-flex justify-content-between align-items-center">
                                <a class="navbar-brand d-flex align-items-center" href="tcController">
                                    <img src="tuan.jpg" alt="Logo" class="nav-logo me-2" width="34" height="34">
                                    <div>
                                        <div class="fw-bold text-white lh-1">Tuan Hoa Photo</div>
                                        <small class="text-white-50 d-none d-sm-block" style="font-size: 0.72rem;">Hệ thống lọc & tải ảnh Google Drive</small>
                                    </div>
                                </a>

                                <a href="https://zalo.me/0388520391" target="_blank"
                                    class="btn btn-sm btn-outline-info rounded-pill px-3 py-1 glass-input border-0 d-flex align-items-center" title="Liên hệ Studio Tuấn Hoa">
                                    <i class="bi bi-telephone-fill me-1 text-info"></i>
                                    <span class="small fw-semibold">0388.520.391</span>
                                </a>
                            </div>
                        </nav>

                        <!-- Main Workspace Container -->
                        <div class="container" style="margin-top: 85px;">

                            <!-- Search & Filter Panel -->
                            <div class="glass-panel mb-3 search-panel-box">
                                <% String curId=(String) request.getAttribute("currentId"); if(curId==null) curId="" ;
                                    String curFilter=(String) request.getAttribute("currentFilter"); if(curFilter==null)
                                    curFilter="" ; 
                                    boolean hasCurrentAlbum = !curId.trim().isEmpty();
                                %>
                                    <form action="tcController" method="get" id="searchForm">
                                        <% if (hasCurrentAlbum) { %>
                                            <!-- Khi đã có album: thanh tìm kiếm tức thì 100% chiều ngang siêu gọn chuẩn iOS Photos -->
                                            <div class="input-group w-100">
                                                <span class="input-group-text glass-input border-end-0 py-2"><i class="bi bi-funnel text-warning"></i></span>
                                                <input type="text" name="txtFilter" id="txtFilterInput"
                                                    class="form-control glass-input border-start-0 border-end-0 py-2"
                                                    placeholder="Tìm tên ảnh hoặc số (vd: 001, cưới, DSC)..."
                                                    value="<%= escapeHtml(curFilter) %>">
                                                <button type="button" class="btn btn-outline-secondary glass-input border-start-0 text-white-50" 
                                                    id="btnClearFilter" style="display:none;" onclick="clearFilterText()" title="Xóa bộ lọc">
                                                    <i class="bi bi-x-circle-fill"></i>
                                                </button>
                                            </div>
                                        <% } else { %>
                                            <!-- Khi chưa có album: hiển thị form nhập link Drive -->
                                            <div class="row g-2 align-items-end">
                                                <div class="col-lg-8 col-md-7">
                                                    <label class="form-label text-white-50 small fw-medium mb-1">ID Thư Mục Hoặc Đường Link Google Drive</label>
                                                    <div class="input-group">
                                                        <span class="input-group-text glass-input border-end-0"><i class="bi bi-folder2-open text-info"></i></span>
                                                        <input type="text" name="txtLink" id="txtLinkInput"
                                                            class="form-control glass-input border-start-0"
                                                            placeholder="Dán link thư mục Google Drive tại đây..."
                                                            value="<%= escapeHtml(curId) %>">
                                                    </div>
                                                </div>
                                                <div class="col-lg-4 col-md-5">
                                                    <button type="submit" name="action" value="view"
                                                        class="btn btn-neo btn-primary-glow w-100">
                                                        <i class="bi bi-search me-2"></i>Mở Album Ảnh
                                                    </button>
                                                </div>
                                            </div>
                                        <% } %>
                                        <% if (request.getParameter("picks") != null && !request.getParameter("picks").trim().isEmpty()) { %>
                                            <input type="hidden" name="picks" value="<%= escapeHtml(request.getParameter("picks")) %>">
                                        <% } %>
                                    </form>
                            </div>

                            <% List<ImageModel> list = (List<ImageModel>) request.getAttribute("dsAnh");
                                    if (list == null) list = new ArrayList<>();

                                        if (!list.isEmpty()) {
                                        %>
                                        <!-- Global Data Object for Frontend Logic -->
                                        <script>
                                            var allImagesData = [
                    <% for (int i = 0; i < list.size(); i++) { 
                        ImageModel img = list.get(i); 
                    %>
                                                    {
                                                        index: <%= i %>,
                                                    name: "<%= escapeJs(img.name) %>",
                                                        link: "<%= escapeJs(img.link) %>",
                                                            thumbLink: "<%= escapeJs(img.thumbLink) %>",
                                                                hdLink: "<%= escapeJs(img.hdLink) %>",
                                                                    cardId: "card-<%= i %>"
                                            }<%= (i < list.size() - 1) ? "," : "" %>
                    <% } %>
                ];
                                        </script>

                                        <!-- Action & Stat Bar (Dạng Chips cuộn ngang mượt mà trên mobile) -->
                                        <div class="glass-panel p-2 mb-3 action-stat-bar">
                                            <span class="badge bg-info bg-opacity-10 border border-info border-opacity-25 text-info rounded-pill px-3 py-2 d-flex align-items-center">
                                                <i class="bi bi-images me-1"></i><b id="totalImgBadge"><%= list.size() %></b>&nbsp;ảnh
                                            </span>
                                            <button class="btn btn-sm btn-outline-light rounded-pill px-3" onclick="toggleSelectAll()">
                                                <i class="bi bi-check-all me-1"></i> Chọn tất cả
                                            </button>
                                            <button id="btnShowSelected" class="btn btn-sm btn-outline-info rounded-pill px-3" onclick="toggleShowSelectedOnly()">
                                                <i class="bi bi-funnel me-1"></i> Xem ảnh đã chọn
                                            </button>
                                            <button id="btnShare" class="btn btn-sm btn-outline-warning rounded-pill px-3" onclick="shortenAndCopyLink()">
                                                <i class="bi bi-share-fill me-1"></i> Chia sẻ link
                                            </button>
                                            <form action="tcController" method="get" class="d-inline m-0">
                                                <input type="hidden" name="txtLink" value="<%= escapeHtml(curId) %>">
                                                <input type="hidden" name="txtFilter" value="<%= escapeHtml(curFilter) %>">
                                                <button type="submit" name="action" value="download" class="btn btn-neo btn-success-glow btn-sm px-3 text-nowrap">
                                                    <i class="bi bi-cloud-arrow-down-fill me-1"></i> Tải Full ZIP
                                                </button>
                                            </form>
                                        </div>

                                        <!-- Banner thông báo khi mở link xem ảnh đã chọn (?picks=...) -->
                                        <div id="picksBanner" class="glass-panel p-2 mb-3 align-items-center justify-content-between gap-2 border border-info border-opacity-40" style="display: none; background: rgba(14, 165, 233, 0.12); border-radius: 12px;">
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; background: rgba(56, 189, 248, 0.2); color: #38bdf8; font-size: 16px; flex-shrink: 0;">
                                                    <i class="bi bi-bookmark-check-fill"></i>
                                                </div>
                                                <div>
                                                    <div class="text-white fw-bold fs-6">Đang xem <span id="picksBannerCount" class="text-info fw-bolder">0</span> ảnh đã chọn</div>
                                                    <div class="text-white-50 small picks-banner-desc">Bấm ảnh để bỏ/thêm rồi bấm "Chốt danh sách" cập nhật lại.</div>
                                                </div>
                                            </div>
                                            <div class="d-flex gap-2 ms-auto flex-shrink-0">
                                                <button type="button" class="btn btn-sm btn-outline-light rounded-pill px-2 py-1" onclick="showAllPhotosFromBanner()" id="btnBannerShowAll" title="Xem tất cả">
                                                    <i class="bi bi-grid-fill me-1"></i> Tất cả
                                                </button>
                                                <button type="button" class="btn btn-sm btn-neo btn-success-glow rounded-pill px-3 py-1" onclick="openOrderModal()">
                                                    <i class="bi bi-pencil-square me-1"></i> Chốt lại
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Optimized Photo Grid -->
                                        <div class="row g-2 g-md-3" id="galleryContainer">
                                            <!-- Trạng thái không tìm thấy kết quả khi lọc -->
                                            <div id="noSearchResultMsg" class="col-12 py-5 text-center" style="display: none;">
                                                <div class="glass-panel p-4 d-inline-block">
                                                    <i class="bi bi-search text-warning fs-1 mb-2 d-block"></i>
                                                    <h5 class="text-white">Không tìm thấy ảnh phù hợp</h5>
                                                    <p class="text-white-50 small mb-0">Thử tìm bằng từ khóa hoặc mã số khác.</p>
                                                </div>
                                            </div>
                                            <% for (int i=0; i < list.size(); i++) { 
                                                ImageModel img = list.get(i); 
                                                boolean isAboveFold = (i < 6); 
                                            %>
                                                <div class="col-6 col-md-4 col-lg-2">
                                                    <div class="photo-card" id="card-<%= i %>"
                                                        data-name="<%= escapeHtml(img.name) %>"
                                                        data-link="<%= escapeHtml(img.link) %>"
                                                        data-thumb="<%= escapeHtml(img.thumbLink) %>"
                                                        data-hd="<%= escapeHtml(img.hdLink) %>"
                                                        onclick="openModalByIndex(<%= i %>)">

                                                        <div class="skeleton-loader" id="skel-<%= i %>"></div>

                                                        <!-- Checkbox nút tròn -->
                                                        <div class="btn-select-item"
                                                            onclick="toggleItemClick(event, this)" title="Chọn ảnh này">
                                                            <i class="bi bi-check-lg fw-bold"></i>
                                                        </div>

                                                        <!-- Nút tải nhanh 1 tấm trên card -->
                                                        <div class="btn-quick-dl"
                                                            onclick="quickDownloadSingle(event, <%= i %>)"
                                                            title="Tải nhanh ảnh này">
                                                            <i class="bi bi-download"></i>
                                                        </div>

                                                        <!-- Huy hiệu báo ảnh có ghi chú -->
                                                        <div class="badge-card-note" id="card-note-badge-<%= i %>" style="display: none;" title="Ảnh có ghi chú">
                                                            <i class="bi bi-chat-left-dots-fill"></i> Ghi chú
                                                        </div>

                                                        <!-- Thẻ ảnh tối ưu thumbnail nhẹ + lazy load + tự động thử lại khi lỗi -->
                                                        <img src="<%= img.thumbLink %>" class="gallery-img"
                                                            <%= isAboveFold ? "fetchpriority=\"high\"" : "loading=\"lazy\" decoding=\"async\"" %>
                                                            alt="<%= escapeHtml(img.name) %>"
                                                            onload="this.classList.add('loaded'); document.getElementById('skel-<%= i %>').style.display='none';"
                                                            onerror="handleThumbError(this)">

                                                        <div class="file-name">
                                                            <%= escapeHtml(img.name) %>
                                                        </div>
                                                    </div>
                                                </div>
                                            <% } %>
                                        </div>

                                        <!-- Floating Action Bar (Apple-style Glass Bottom Dock) -->
                                        <div class="floating-bar" id="floatingBar">
                                            <div class="selected-info text-white d-flex align-items-center">
                                                <span class="d-none d-sm-inline">Đã chọn:</span>
                                                <span class="badge bg-info text-dark rounded-pill px-2 py-1 fw-bold fs-6 ms-1 me-1" id="selectedCount">0</span>
                                                <span class="small text-white-50">ảnh</span>
                                                <button type="button" class="btn btn-link text-white-50 p-0 ms-2 text-decoration-none" onclick="clearSelection()" title="Bỏ chọn tất cả">
                                                    <i class="bi bi-x-circle-fill" style="font-size: 1rem;"></i>
                                                </button>
                                            </div>
                                            
                                            <div class="btn-group-actions">
                                                <button type="button" class="btn btn-sm btn-outline-warning btn-icon-mobile" onclick="copyOrSearchString()" title="Sao chép cú pháp Windows Explorer (OR)">
                                                    <i class="bi bi-clipboard-check"></i>
                                                    <span class="ms-1 d-none d-md-inline">Copy mã OR</span>
                                                </button>

                                                <form action="tcController" method="post" id="downloadSelectedForm" class="d-inline m-0">
                                                    <input type="hidden" name="action" value="downloadSelected">
                                                    <input type="hidden" name="selectedData" id="hiddenDataInput">
                                                    <input type="hidden" name="folderIdForLog" value="<%= escapeHtml(curId) %>">
                                                    <button type="button" id="btnSubmitDownload" onclick="submitDownloadSelected()" class="btn btn-neo btn-primary-glow btn-icon-mobile" title="Tải các ảnh đã chọn">
                                                        <i id="dlBtnIcon" class="bi bi-download"></i>
                                                        <span id="dlBtnText" class="ms-1 d-none d-md-inline">Tải Đã Chọn</span>
                                                    </button>
                                                </form>

                                                <button type="button" class="btn btn-neo btn-success-glow btn-chot-order text-nowrap" onclick="openOrderModal()">
                                                    <i class="bi bi-check2-circle me-1"></i> Chốt danh sách
                                                </button>
                                            </div>
                                        </div>

                                        <% } else if (hasCurrentAlbum) { %>
                                            <!-- Not Found State / Hỗ trợ thử lại tự động khi ID hợp lệ nhưng Drive chưa trả về ảnh -->
                                            <div class="glass-panel text-center py-5">
                                                <div class="mb-3">
                                                    <i class="bi bi-cloud-arrow-down-fill text-info" style="font-size: 52px; opacity: 0.85;"></i>
                                                </div>
                                                <h5 class="mt-2 text-white fw-bold">Chưa tải được danh sách ảnh từ Google Drive</h5>
                                                <p class="text-white-50 mx-auto mb-4" style="max-width: 520px; font-size: 0.95rem;">
                                                    Hệ thống Google Drive có thể phản hồi chậm hoặc đang khởi động. Vui lòng bấm nút <b>"Tải lại album ngay"</b> bên dưới để hệ thống quét lại trực tiếp!
                                                </p>
                                                <div class="d-inline-flex flex-wrap justify-content-center gap-3">
                                                    <a href="tcController?txtLink=<%= escapeHtml(curId) %>&action=view&refresh=true<%= (request.getParameter("picks") != null && !request.getParameter("picks").trim().isEmpty()) ? "&picks=" + URLEncoder.encode(request.getParameter("picks"), "UTF-8") : "" %>" class="btn btn-neo btn-primary-glow px-4 py-2">
                                                        <i class="bi bi-arrow-clockwise me-2"></i> Tải lại album ngay
                                                    </a>
                                                    <a href="index.jsp" class="btn btn-neo btn-outline-light px-4 py-2">
                                                        <i class="bi bi-house me-2"></i> Về trang chủ
                                                    </a>
                                                </div>
                                            </div>
                                        <% } else { %>
                                            <!-- Khi chưa mở album: Hướng dẫn sử dụng bảo mật & tinh gọn, không phô bày kho ảnh khách hàng -->
                                            <div class="glass-panel text-center py-5 px-3 mt-4" style="border-radius: 20px;">
                                                <div class="mb-3">
                                                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle" style="width: 60px; height: 60px; background: rgba(14, 165, 233, 0.15); color: #38bdf8;">
                                                        <i class="bi bi-cloud-check-fill" style="font-size: 28px;"></i>
                                                    </div>
                                                </div>
                                                <h5 class="text-white fw-bold mb-2">Hệ thống Lọc & Tải Ảnh Studio Tuấn Hoa</h5>
                                                <p class="text-white-50 mx-auto mb-4" style="max-width: 520px; font-size: 0.95rem;">
                                                    Vui lòng dán <b>đường link thư mục Google Drive</b> mà Studio đã cung cấp cho bạn vào ô tìm kiếm bên trên và bấm <b>"Mở Album Ảnh"</b> để xem và chọn ảnh.
                                                </p>
                                                <div class="row g-3 justify-content-center mx-auto" style="max-width: 680px;">
                                                    <div class="col-12 col-md-4">
                                                        <div class="p-3 h-100 rounded-3 text-start" style="background: rgba(255, 255, 255, 0.04); border: 1px solid rgba(255, 255, 255, 0.08);">
                                                            <div class="text-info fw-bold mb-1"><i class="bi bi-link-45deg me-1"></i> 1. Dán Link</div>
                                                            <div class="text-white-50 small">Dán link thư mục Google Drive ảnh do Studio gửi.</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-md-4">
                                                        <div class="p-3 h-100 rounded-3 text-start" style="background: rgba(255, 255, 255, 0.04); border: 1px solid rgba(255, 255, 255, 0.08);">
                                                            <div class="text-warning fw-bold mb-1"><i class="bi bi-check2-circle me-1"></i> 2. Chọn Ảnh</div>
                                                            <div class="text-white-50 small">Tích chọn các tấm ảnh ưng ý và ghi chú dặn dò.</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-md-4">
                                                        <div class="p-3 h-100 rounded-3 text-start" style="background: rgba(255, 255, 255, 0.04); border: 1px solid rgba(255, 255, 255, 0.08);">
                                                            <div class="text-success fw-bold mb-1"><i class="bi bi-send-check me-1"></i> 3. Chốt Đơn</div>
                                                            <div class="text-white-50 small">Bấm chốt danh sách để gửi Studio chỉnh sửa ngay.</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        <% } %>

                        </div>

                        <!-- ==================================================== -->
                        <!-- GOOGLE DRIVE STYLE INTERACTIVE VIEWER (PINCH TO ZOOM) -->
                        <!-- ==================================================== -->
                        <div id="imgModal" class="image-modal">

                            <!-- Top Toolbar (Tối giản: Chỉ giữ đếm ảnh, tên và nút X đóng) -->
                            <div class="modal-top-bar">
                                <div class="modal-title-info">
                                    <span class="modal-img-counter" id="modalCounter">1 / 1</span>
                                    <span class="modal-img-name" id="modalImgName">Tên ảnh.jpg</span>
                                </div>

                                <div class="modal-top-actions">
                                    <!-- Đóng -->
                                    <button class="btn-tool" onclick="closeModal()" title="Đóng (Esc)">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- Center Stage with Zoom & Pan Area -->
                            <div class="modal-stage" id="modalTouchArea">
                                <div class="modal-nav-btn nav-prev" onclick="showPreviousImage(event)"
                                    title="Ảnh trước (Mũi tên trái)">
                                    <i class="bi bi-chevron-left"></i>
                                </div>
                                <div class="modal-nav-btn nav-next" onclick="showNextImage(event)"
                                    title="Ảnh sau (Mũi tên phải)">
                                    <i class="bi bi-chevron-right"></i>
                                </div>

                                <!-- Image Target with Hardware Accelerated Transform -->
                                <img class="modal-content-img" id="modalImgEl" alt="Preview Image">
                            </div>

                            <!-- Bottom Floating Actions & Ghi chú ảnh -->
                            <div class="modal-bottom-bar" onclick="event.stopPropagation()">
                                <div class="modal-note-box">
                                    <i class="bi bi-chat-left-dots text-info me-2"></i>
                                    <input type="text" id="modalPhotoNoteInput" class="modal-note-input"
                                        placeholder="Ghi chú cho ảnh này (vd: xóa rác, ảnh cổng, bóp eo...)"
                                        oninput="handlePhotoNoteInput(this.value)">
                                    <button type="button" class="btn-clear-note" id="btnClearPhotoNote"
                                        onclick="clearCurrentPhotoNote()" title="Xóa ghi chú" style="display:none;">
                                        <i class="bi bi-x-circle-fill"></i>
                                    </button>
                                </div>
                                <div class="d-flex align-items-center justify-content-center gap-2 w-100">
                                    <button id="modalCheckBtn" class="btn btn-neo btn-outline-light flex-grow-1"
                                        onclick="toggleModalSelection()">
                                        <i class="bi bi-circle me-1"></i> Chọn
                                    </button>
                                    <button class="btn btn-neo btn-primary-glow flex-grow-1" onclick="downloadCurrentModalPhoto()">
                                        <i class="bi bi-download me-1"></i> Tải xuống
                                    </button>
                                </div>
                            </div>

                        </div>

                        <!-- Modal Chốt danh sách ảnh (Popup xác nhận gửi) -->
                        <div id="orderModal" class="custom-modal-backdrop" onclick="closeOrderModal(event)">
                            <div class="custom-modal-box glass-panel" onclick="event.stopPropagation()">
                                <div class="d-flex justify-content-between align-items-center pb-3 border-bottom border-white border-opacity-10 mb-3">
                                    <h5 class="m-0 text-white d-flex align-items-center gap-2 fs-5">
                                        <i class="bi bi-check2-circle text-success fs-4"></i>
                                        <span id="orderModalTitle">Chốt danh sách ảnh chọn</span>
                                    </h5>
                                    <button type="button" class="btn-tool" style="width:32px; height:32px;" onclick="closeOrderModal()">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </div>

                                <!-- Thống kê nhanh -->
                                <div class="glass-panel p-3 mb-3 border-0" style="background: rgba(255, 255, 255, 0.05); border-radius: 12px;">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="text-white-50 small">Tổng số ảnh đã chọn:</span>
                                        <span class="badge bg-info text-dark fw-bold px-3 py-1 fs-6" id="modalSelectedCountBadge">0 ảnh</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="text-white-50 small">Số ảnh có kèm ghi chú:</span>
                                        <span class="text-info fw-semibold small" id="modalNotedCountBadge">0 ảnh</span>
                                    </div>
                                </div>

                                <!-- Form thông tin khách hàng -->
                                <div class="mb-3">
                                    <label class="form-label text-white-50 small fw-medium">Họ và tên của bạn <span class="text-danger">*</span></label>
                                    <input type="text" id="orderClientName" class="form-control glass-input" placeholder="Ví dụ: Chị Lan Anh, Anh Tuấn...">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-white-50 small fw-medium">Số điện thoại / Zalo <span class="text-danger">*</span></label>
                                    <input type="tel" id="orderClientPhone" class="form-control glass-input" placeholder="Để Studio liên hệ khi làm xong ảnh...">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-white-50 small fw-medium">Dặn dò chung cho toàn bộ Album (Tùy chọn)</label>
                                    <textarea id="orderGeneralNote" class="form-control glass-input" rows="2" placeholder="Ví dụ: Chỉnh màu phong cách tự nhiên, gửi ảnh trước thứ 7..."></textarea>
                                </div>

                                <!-- Khung mã tìm kiếm OR -->
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <label class="form-label text-white-50 small mb-0">Mã tìm kiếm danh sách ảnh (Chuẩn Windows):</label>
                                        <button type="button" class="btn btn-link btn-sm text-info p-0 text-decoration-none" onclick="copyModalOrString()">
                                            <i class="bi bi-clipboard me-1"></i> Sao chép mã
                                        </button>
                                    </div>
                                    <div class="p-2 rounded bg-black bg-opacity-40 border border-secondary border-opacity-25" style="font-family: monospace; font-size: 0.8rem; color: #38bdf8; max-height: 70px; overflow-y: auto;" id="modalOrCodePreview">
                                        vlam_001 OR vlam_002
                                    </div>
                                </div>

                                <div class="pt-2 d-flex flex-column gap-2">
                                    <button type="button" id="btnConfirmOrderSubmit" class="btn btn-neo btn-success-glow w-100 py-2 fs-6 fw-semibold" onclick="submitOrderConfirmation()">
                                        <i class="bi bi-send-fill me-2"></i> Xác nhận chốt &amp; Gửi cho Studio
                                    </button>
                                    <button type="button" id="btnConfirmZaloSubmit" class="btn btn-sm btn-outline-info w-100 py-2" onclick="sendOrderViaZalo()">
                                        <i class="bi bi-chat-dots-fill me-2"></i> Gửi qua Zalo cho Studio (0388.520.391)
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- ==================================================== -->
                        <!-- SCRIPTS -->
                        <!-- ==================================================== -->
                        <script>
                            // --- CẤU HÌNH & TRẠNG THÁI ---
                            const FOLDER_ID = "<%= escapeJs(curId) %>";
                            const STORAGE_KEY = "selected_photos_" + FOLDER_ID;
                            const NOTES_STORAGE_KEY = "photo_notes_" + FOLDER_ID;
                            const STUDIO_ZALO_PHONE = "0388520391";
                            const STUDIO_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbziBHUHWExJRpDh4Y_SSPNtMjl9NPaM80nql9nRwakg3TViR4dXy4EeCD9GS_9nkV1m/exec";

                            let selectedItems = new Set();
                            let photoNotes = {};
                            let currentImageIndex = 0;
                            let isShowingSelectedOnly = false;

                            // --- QUẢN LÝ GHI CHÚ ẢNH (PHOTO NOTES) ---
                            function loadNotesFromStorage() {
                                try {
                                    const saved = localStorage.getItem(NOTES_STORAGE_KEY);
                                    if (saved) {
                                        photoNotes = JSON.parse(saved) || {};
                                    }
                                } catch (e) {
                                    photoNotes = {};
                                }
                                updateAllCardNoteBadges();
                            }

                            function saveNotesToStorage() {
                                try {
                                    if (Object.keys(photoNotes).length === 0) {
                                        localStorage.removeItem(NOTES_STORAGE_KEY);
                                    } else {
                                        localStorage.setItem(NOTES_STORAGE_KEY, JSON.stringify(photoNotes));
                                    }
                                } catch (e) {}
                                updateAllCardNoteBadges();
                            }

                            function updateAllCardNoteBadges() {
                                if (typeof allImagesData === 'undefined') return;
                                allImagesData.forEach((img, idx) => {
                                    const badge = document.getElementById("card-note-badge-" + idx);
                                    if (badge) {
                                        const hasNote = photoNotes[img.name] && photoNotes[img.name].trim().length > 0;
                                        badge.style.display = hasNote ? "inline-flex" : "none";
                                    }
                                });
                            }

                            // --- ZOOM & PAN ENGINE (CHUẨN GOOGLE DRIVE) ---
                            let scale = 1;
                            let minScale = 1;
                            let maxScale = 5;
                            let posX = 0;
                            let posY = 0;
                            let isDragging = false;
                            let startX = 0;
                            let startY = 0;
                            let initialDistance = 0;
                            let initialScale = 1;
                            let isPinching = false;
                            let touchStartX = 0;
                            let touchStartY = 0;
                            let lastTapTime = 0;

                            const modalStage = document.getElementById('modalTouchArea');
                            const modalImg = document.getElementById('modalImgEl');
                            const zoomBadge = document.getElementById('zoomBadge');

                            document.addEventListener("DOMContentLoaded", function () {
                                loadSelectionFromStorage();
                                loadNotesFromStorage();

                                // Đọc danh sách ảnh được chia sẻ qua URL (?picks=...)
                                const urlParams = new URLSearchParams(window.location.search);
                                const picks = urlParams.get('picks');
                                if (picks && typeof allImagesData !== 'undefined') {
                                    // Xóa lựa chọn cũ trên máy để hiển thị chuẩn xác 100% danh sách ảnh từ link này
                                    selectedItems.clear();
                                    document.querySelectorAll('.photo-card.selected').forEach(c => c.classList.remove('selected'));

                                    function cleanPhotoName(n) {
                                        if (!n && n !== 0) return '';
                                        return decodeURIComponent(String(n)).trim().toLowerCase().replace(/\.[a-zA-Z0-9]{2,5}$/, '');
                                    }
                                    const rawTokens = picks.split(/[,;\s]+|(?:\s+or\s+)/i).map(p => p.trim()).filter(Boolean);
                                    const pickedCleanSet = new Set(rawTokens.map(p => cleanPhotoName(p)).filter(Boolean));
                                    const pickedRawSet = new Set(rawTokens.map(p => decodeURIComponent(String(p)).trim().toLowerCase()).filter(Boolean));
                                    
                                    let matchCount = 0;
                                    allImagesData.forEach(imgData => {
                                        const raw = String(imgData.name || '').trim().toLowerCase();
                                        const clean = cleanPhotoName(imgData.name);
                                        if (pickedCleanSet.has(clean) || pickedRawSet.has(raw)) {
                                            const card = document.getElementById(imgData.cardId);
                                            if (card) {
                                                selectCard(card);
                                                matchCount++;
                                            }
                                        }
                                    });

                                    if (matchCount > 0) {
                                        const banner = document.getElementById('picksBanner');
                                        if (banner) {
                                            banner.style.display = 'flex';
                                            const countBadge = document.getElementById('picksBannerCount');
                                            if (countBadge) countBadge.innerText = matchCount;
                                        }
                                        // Tự động chuyển sang chế độ xem riêng các ảnh đã chọn
                                        setTimeout(() => {
                                            if (!isShowingSelectedOnly) {
                                                toggleShowSelectedOnly();
                                            }
                                        }, 100);
                                    }
                                }

                                updateFloatingBar();
                                initZoomAndGestures();
                                initKeyboardShortcuts();
                                initClientSideSearch();

                                // Tự động làm gọn thanh địa chỉ trên trình duyệt thành link sạch https://.../?id=...
                                if (FOLDER_ID && window.history && window.history.replaceState) {
                                    try {
                                        let cleanPath = window.location.pathname.replace(/\/tcController\/?$/, '/');
                                        if (cleanPath === '') cleanPath = '/';
                                        let newSearch = '?id=' + encodeURIComponent(FOLDER_ID);
                                        if (picks) newSearch += '&picks=' + encodeURIComponent(picks);
                                        window.history.replaceState(null, '', cleanPath + newSearch);
                                    } catch (e) {
                                        console.warn("Lỗi cập nhật URL", e);
                                    }
                                }
                            });

                            // ====================================================
                            // CÁC HÀM XỬ LÝ ZOOM & GESTURE (PINCH-TO-ZOOM / PAN / WHEEL)
                            // ====================================================
                            function initZoomAndGestures() {
                                if (!modalStage || !modalImg) return;

                                // 1. Phóng to thu nhỏ bằng con lăn chuột (Mouse Wheel)
                                modalStage.addEventListener('wheel', function (e) {
                                    if (!document.getElementById("imgModal").classList.contains("show")) return;
                                    e.preventDefault();

                                    const rect = modalImg.getBoundingClientRect();
                                    const mouseX = e.clientX - (rect.left + rect.width / 2);
                                    const mouseY = e.clientY - (rect.top + rect.height / 2);

                                    const zoomFactor = e.deltaY < 0 ? 1.2 : 0.833;
                                    let newScale = scale * zoomFactor;
                                    newScale = Math.min(Math.max(newScale, minScale), maxScale);

                                    if (newScale !== scale) {
                                        if (newScale <= 1.05) {
                                            resetZoom();
                                        } else {
                                            // Zoom tương đối theo vị trí con trỏ chuột
                                            posX = posX - (mouseX / scale) * (newScale - scale);
                                            posY = posY - (mouseY / scale) * (newScale - scale);
                                            scale = newScale;
                                            clampPosition();
                                            applyTransform();
                                        }
                                    }
                                }, { passive: false });

                                // 2. Kéo rê ảnh bằng chuột (Mouse Drag khi scale > 1)
                                modalStage.addEventListener('mousedown', function (e) {
                                    if (e.button !== 0) return;
                                    if (scale > 1) {
                                        isDragging = true;
                                        startX = e.clientX - posX;
                                        startY = e.clientY - posY;
                                        modalImg.style.cursor = 'grabbing';
                                    }
                                });

                                window.addEventListener('mousemove', function (e) {
                                    if (isDragging && scale > 1) {
                                        posX = e.clientX - startX;
                                        posY = e.clientY - startY;
                                        clampPosition();
                                        applyTransform();
                                    }
                                });

                                window.addEventListener('mouseup', function () {
                                    if (isDragging) {
                                        isDragging = false;
                                        if (modalImg) modalImg.style.cursor = scale > 1 ? 'grab' : 'default';
                                    }
                                });

                                // 3. Pinch-to-zoom (2 ngón tay) & Swipe / Pan (1 ngón tay) trên điện thoại
                                modalStage.addEventListener('touchstart', function (e) {
                                    if (e.touches.length === 2) {
                                        // Chụm 2 ngón tay để zoom
                                        isPinching = true;
                                        isDragging = false;
                                        initialDistance = Math.hypot(
                                            e.touches[0].clientX - e.touches[1].clientX,
                                            e.touches[0].clientY - e.touches[1].clientY
                                        );
                                        initialScale = scale;
                                    } else if (e.touches.length === 1) {
                                        isPinching = false;
                                        touchStartX = e.touches[0].clientX;
                                        touchStartY = e.touches[0].clientY;
                                        startX = e.touches[0].clientX - posX;
                                        startY = e.touches[0].clientY - posY;
                                        if (scale > 1) {
                                            isDragging = true;
                                        }
                                    }
                                }, { passive: false });

                                modalStage.addEventListener('touchmove', function (e) {
                                    if (e.touches.length === 2 && isPinching) {
                                        e.preventDefault();
                                        const currentDist = Math.hypot(
                                            e.touches[0].clientX - e.touches[1].clientX,
                                            e.touches[0].clientY - e.touches[1].clientY
                                        );
                                        let newScale = initialScale * (currentDist / initialDistance);
                                        newScale = Math.min(Math.max(newScale, minScale), maxScale);
                                        scale = newScale;
                                        clampPosition();
                                        applyTransform();
                                    } else if (e.touches.length === 1 && isDragging && scale > 1) {
                                        e.preventDefault();
                                        posX = e.touches[0].clientX - startX;
                                        posY = e.touches[0].clientY - startY;
                                        clampPosition();
                                        applyTransform();
                                    }
                                }, { passive: false });

                                modalStage.addEventListener('touchend', function (e) {
                                    if (e.touches.length === 0) {
                                        if (isPinching) {
                                            isPinching = false;
                                            if (scale <= 1.05) {
                                                resetZoom();
                                            } else {
                                                clampPosition();
                                                applyTransform();
                                            }
                                        }
                                        if (isDragging) {
                                            isDragging = false;
                                        }

                                        // Chuyển ảnh bằng vuốt (Swipe) nếu không zoom (scale === 1)
                                        if (scale <= 1) {
                                            const touchEndX = e.changedTouches[0].clientX;
                                            const touchEndY = e.changedTouches[0].clientY;
                                            const diffX = touchEndX - touchStartX;
                                            const diffY = touchEndY - touchStartY;
                                            if (Math.abs(diffX) > 45 && Math.abs(diffX) > Math.abs(diffY)) {
                                                if (diffX > 0) showPreviousImage();
                                                else showNextImage();
                                            } else if (diffY > 80 && Math.abs(diffY) > Math.abs(diffX) * 1.5) {
                                                // Vuốt dọc xuống để đóng nhanh modal xem ảnh trên điện thoại
                                                closeModal();
                                            }
                                        }

                                        // Xử lý nhấp đúp (Double-tap để phóng to 2.5x hoặc reset) HOẶC chạm 1 lần (Single-tap để ẩn/hiện thanh công cụ)
                                        const now = Date.now();
                                        const touchEndX = e.changedTouches[0].clientX;
                                        const touchEndY = e.changedTouches[0].clientY;
                                        const diffX = touchEndX - touchStartX;
                                        const diffY = touchEndY - touchStartY;

                                        if (now - lastTapTime < 300) {
                                            if (tapTimer) {
                                                clearTimeout(tapTimer);
                                                tapTimer = null;
                                            }
                                            handleDoubleTap(touchEndX, touchEndY);
                                        } else {
                                            if (Math.abs(diffX) < 12 && Math.abs(diffY) < 12) {
                                                if (tapTimer) clearTimeout(tapTimer);
                                                tapTimer = setTimeout(() => {
                                                    toggleModalUI();
                                                    tapTimer = null;
                                                }, 280);
                                            }
                                        }
                                        lastTapTime = now;
                                    }
                                });

                                // Nhấp chuột 1 lần vào vùng ảnh trên Desktop để ẩn/hiện thanh công cụ
                                let tapTimer = null;
                                modalStage.addEventListener('click', function (e) {
                                    if (e.target.closest('.modal-top-bar') || e.target.closest('.modal-bottom-bar') || e.target.closest('.modal-nav-btn')) return;
                                    if (isDragging) return;
                                    if (tapTimer) clearTimeout(tapTimer);
                                    tapTimer = setTimeout(() => {
                                        toggleModalUI();
                                        tapTimer = null;
                                    }, 260);
                                });

                                // Nhấp đúp chuột trên Desktop để phóng to
                                modalImg.addEventListener('dblclick', function (e) {
                                    if (tapTimer) {
                                        clearTimeout(tapTimer);
                                        tapTimer = null;
                                    }
                                    handleDoubleTap(e.clientX, e.clientY);
                                });
                            }

                            function handleDoubleTap(clientX, clientY) {
                                if (scale > 1) {
                                    resetZoom();
                                } else {
                                    zoomTo(2.5);
                                }
                            }

                            function zoomStep(delta) {
                                let newScale = scale + delta;
                                newScale = Math.min(Math.max(newScale, minScale), maxScale);
                                if (newScale <= 1.05) {
                                    resetZoom();
                                } else {
                                    scale = newScale;
                                    clampPosition();
                                    applyTransform();
                                }
                            }

                            function zoomTo(targetScale) {
                                scale = Math.min(Math.max(targetScale, minScale), maxScale);
                                if (scale <= 1.05) {
                                    resetZoom();
                                } else {
                                    clampPosition();
                                    applyTransform();
                                }
                            }

                            function resetZoom() {
                                scale = 1;
                                posX = 0;
                                posY = 0;
                                applyTransform();
                            }

                            function clampPosition() {
                                if (!modalImg) return;
                                const imgWidth = modalImg.offsetWidth * scale;
                                const imgHeight = modalImg.offsetHeight * scale;
                                const stageWidth = modalStage.offsetWidth;
                                const stageHeight = modalStage.offsetHeight;

                                const maxTranslateX = Math.max(0, (imgWidth - stageWidth) / 2);
                                const maxTranslateY = Math.max(0, (imgHeight - stageHeight) / 2);

                                posX = Math.min(Math.max(posX, -maxTranslateX), maxTranslateX);
                                posY = Math.min(Math.max(posY, -maxTranslateY), maxTranslateY);
                            }

                            function applyTransform() {
                                if (!modalImg) return;
                                modalImg.style.transform = "translate3d(" + posX + "px, " + posY + "px, 0) scale(" + scale + ")";
                                modalImg.style.cursor = scale > 1 ? "grab" : "default";
                                if (zoomBadge) {
                                    zoomBadge.innerText = Math.round(scale * 100) + "%";
                                }
                            }

                            // ====================================================
                            // CÁC HÀM XỬ LÝ MODAL XEM ẢNH & HIỂN THỊ
                            // ====================================================
                            function openModalByIndex(index) {
                                if (index < 0 || index >= allImagesData.length) return;
                                currentImageIndex = index;
                                resetZoom();
                                document.getElementById("imgModal").classList.remove("ui-hidden");
                                updateModalView();
                                document.getElementById("imgModal").classList.add("show");
                                document.body.style.overflow = "hidden";
                            }

                            function toggleModalUI() {
                                const modal = document.getElementById("imgModal");
                                if (!modal) return;
                                modal.classList.toggle("ui-hidden");
                            }

                            function fitModalImage(naturalW, naturalH) {
                                const modalImgEl = document.getElementById("modalImgEl");
                                const modalStage = document.getElementById("modalTouchArea");
                                if (!modalStage || !modalImgEl) return;
                                const stageW = modalStage.clientWidth || window.innerWidth;
                                const stageH = modalStage.clientHeight || window.innerHeight;
                                const maxW = stageW * 0.96;
                                const maxH = stageH * 0.94;
                                
                                if (naturalW && naturalH && naturalW > 0 && naturalH > 0) {
                                    const imgRatio = naturalW / naturalH;
                                    const targetRatio = maxW / maxH;
                                    if (imgRatio > targetRatio) {
                                        // Ảnh ngang: bung full theo chiều ngang tối đa
                                        modalImgEl.style.width = Math.round(maxW) + "px";
                                        modalImgEl.style.height = Math.round(maxW / imgRatio) + "px";
                                    } else {
                                        // Ảnh dọc: bung full theo chiều cao tối đa
                                        modalImgEl.style.height = Math.round(maxH) + "px";
                                        modalImgEl.style.width = Math.round(maxH * imgRatio) + "px";
                                    }
                                }
                            }

                            window.addEventListener('resize', function () {
                                const modal = document.getElementById("imgModal");
                                const modalImgEl = document.getElementById("modalImgEl");
                                if (modal && modal.classList.contains("show") && modalImgEl && modalImgEl.naturalWidth) {
                                    fitModalImage(modalImgEl.naturalWidth, modalImgEl.naturalHeight);
                                    clampPosition();
                                    applyTransform();
                                }
                            });

                            function updateModalView() {
                                const imgData = allImagesData[currentImageIndex];
                                const modalImgEl = document.getElementById("modalImgEl");
                                const nameTxt = document.getElementById("modalImgName");
                                const counterTxt = document.getElementById("modalCounter");
                                const dlBtn = document.getElementById("modalDownloadBtn");

                                resetZoom();
                                nameTxt.innerText = imgData.name;
                                counterTxt.innerText = (currentImageIndex + 1) + " / " + allImagesData.length;

                                // Khóa kích thước hiển thị vừa vặn khung nhìn ngay tức thì (0ms)
                                const cardImg = document.querySelector("#" + imgData.cardId + " .gallery-img");
                                if (cardImg && cardImg.naturalWidth && cardImg.naturalHeight) {
                                    fitModalImage(cardImg.naturalWidth, cardImg.naturalHeight);
                                } else if (modalImgEl.naturalWidth && modalImgEl.naturalHeight) {
                                    fitModalImage(modalImgEl.naturalWidth, modalImgEl.naturalHeight);
                                }

                                // 1. Nạp ngay ảnh thumbnail đã có trong cache để hiển thị tức thì full màn hình (0ms)
                                let previewUrl = (imgData.thumbLink || "").replace(/-c(?=$|[?&])/, "");
                                modalImgEl.src = previewUrl || imgData.thumbLink;
                                modalImgEl.onload = function () {
                                    fitModalImage(this.naturalWidth, this.naturalHeight);
                                };

                                // 2. Tải ngầm ảnh độ nét cao (HD) rồi chuyển sang mượt mà không làm lệch 1 pixel
                                const highResUrl = imgData.hdLink || imgData.link;
                                const hdPreload = new Image();
                                hdPreload.src = highResUrl;
                                hdPreload.onload = function () {
                                    if (allImagesData[currentImageIndex].name === imgData.name) {
                                        modalImgEl.src = highResUrl;
                                        fitModalImage(this.naturalWidth, this.naturalHeight);
                                    }
                                };

                                // Link tải 1 ảnh trực tiếp nếu có
                                if (dlBtn) {
                                    dlBtn.href = "tcController?action=downloadOne&name=" + encodeURIComponent(imgData.name) + "&url=" + encodeURIComponent(imgData.link);
                                }
                                updateModalCheckButtonState();

                                // Cập nhật ô ghi chú cho ảnh hiện tại
                                const noteInput = document.getElementById("modalPhotoNoteInput");
                                const clearBtn = document.getElementById("btnClearPhotoNote");
                                const currentNote = (photoNotes && photoNotes[imgData.name]) ? photoNotes[imgData.name] : "";
                                if (noteInput) {
                                    noteInput.value = currentNote;
                                }
                                if (clearBtn) {
                                    clearBtn.style.display = (currentNote && currentNote.trim()) ? "block" : "none";
                                }
                            }

                            function closeModal() {
                                document.getElementById("imgModal").classList.remove("show");
                                document.getElementById("imgModal").classList.remove("ui-hidden");
                                document.body.style.overflow = "auto";
                                resetZoom();
                                setTimeout(() => { 
                                    const modalImgEl = document.getElementById("modalImgEl");
                                    if (modalImgEl) {
                                        modalImgEl.src = ""; 
                                        modalImgEl.style.width = "";
                                        modalImgEl.style.height = "";
                                    }
                                }, 250);
                            }

                            function showNextImage(event) {
                                if (event) event.stopPropagation();
                                if (currentImageIndex < allImagesData.length - 1) {
                                    currentImageIndex++;
                                    updateModalView();
                                }
                            }

                            function showPreviousImage(event) {
                                if (event) event.stopPropagation();
                                if (currentImageIndex > 0) {
                                    currentImageIndex--;
                                    updateModalView();
                                }
                            }

                            function toggleModalSelection() {
                                const imgData = allImagesData[currentImageIndex];
                                const card = document.getElementById(imgData.cardId);
                                if (card) {
                                    toggleCardSelection(card);
                                    updateModalCheckButtonState();
                                }
                            }

                            function updateModalCheckButtonState() {
                                const imgData = allImagesData[currentImageIndex];
                                const card = document.getElementById(imgData.cardId);
                                const btn = document.getElementById('modalCheckBtn');
                                if (!btn) return;
                                if (card && card.classList.contains('selected')) {
                                    btn.className = "btn btn-neo btn-primary-glow";
                                    btn.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i> Đã chọn';
                                } else {
                                    btn.className = "btn btn-neo btn-outline-light";
                                    btn.innerHTML = '<i class="bi bi-circle me-1"></i> Chọn';
                                }
                            }

                            // Tự động thử lại khi tải thumbnail bị Google bóp băng thông
                            function handleThumbError(imgEl) {
                                let retries = parseInt(imgEl.getAttribute('data-retries') || '0', 10);
                                if (retries < 3) {
                                    imgEl.setAttribute('data-retries', retries + 1);
                                    setTimeout(() => {
                                        let originalSrc = imgEl.src.split('&_r=')[0];
                                        imgEl.src = originalSrc + (originalSrc.includes('?') ? '&' : '?') + '_r=' + (retries + 1);
                                    }, 1200 * (retries + 1));
                                }
                            }

                            function downloadCurrentModalPhoto() {
                                const imgData = allImagesData[currentImageIndex];
                                window.location.href = "tcController?action=downloadOne&name=" + encodeURIComponent(imgData.name) + "&url=" + encodeURIComponent(imgData.link);
                            }

                            function quickDownloadSingle(event, index) {
                                event.stopPropagation();
                                const imgData = allImagesData[index];
                                window.location.href = "tcController?action=downloadOne&name=" + encodeURIComponent(imgData.name) + "&url=" + encodeURIComponent(imgData.link);
                            }

                            // ====================================================
                            // BÀN PHÍM PHÍM TẮT (KEYBOARD SHORTCUTS)
                            // ====================================================
                            function initKeyboardShortcuts() {
                                document.addEventListener('keydown', function (event) {
                                    // Bỏ qua toàn bộ phím tắt nếu người dùng đang nhập liệu trong ô input/textarea/editable
                                    const tag = (event.target && event.target.tagName) ? event.target.tagName.toUpperCase() : '';
                                    if (tag === 'INPUT' || tag === 'TEXTAREA' || (event.target && event.target.isContentEditable)) {
                                        return;
                                    }

                                    const isModalOpen = document.getElementById("imgModal").classList.contains("show");
                                    if (!isModalOpen) return;

                                    if (event.key === "Escape") closeModal();
                                    if (event.key === "ArrowLeft") showPreviousImage();
                                    if (event.key === "ArrowRight") showNextImage();
                                    if (event.key === " " || event.code === "Space") {
                                        event.preventDefault();
                                        toggleModalSelection();
                                    }
                                    if (event.key === "+" || event.key === "=") zoomStep(0.25);
                                    if (event.key === "-" || event.key === "_") zoomStep(-0.25);
                                    if (event.key === "0") resetZoom();
                                });
                            }

                            // ====================================================
                            // QUẢN LÝ CHỌN ẢNH & TẢI THEO PHONG CÁCH GOOGLE DRIVE
                            // ====================================================
                            function toggleItemClick(event, btnElement) {
                                event.stopPropagation();
                                toggleCardSelection(btnElement.closest('.photo-card'));
                            }

                            function toggleCardSelection(card) {
                                if (!card) return;
                                const imgName = card.getAttribute('data-name');
                                const hasNote = imgName && photoNotes[imgName] && photoNotes[imgName].trim();

                                if (card.classList.contains('selected')) {
                                    // KHÓA BỎ CHỌN: Nếu ảnh đang có ghi chú riêng thì bắt buộc phải chọn!
                                    if (hasNote) {
                                        alert("⚠️ Ảnh \"" + getCleanPhotoName(imgName) + "\" đang có ghi chú: \"" + photoNotes[imgName].trim() + "\".\n\nẢnh có ghi chú dặn dò Studio thì bắt buộc phải chọn! Nếu bạn không muốn chọn ảnh này nữa, vui lòng xóa ghi chú của ảnh trước nhé.");
                                        return;
                                    }
                                    card.classList.remove('selected');
                                    selectedItems.delete(card);
                                } else {
                                    card.classList.add('selected');
                                    selectedItems.add(card);
                                }
                                updateFloatingBar();
                                saveSelectionToStorage();
                                if (isShowingSelectedOnly) {
                                    if (!card.classList.contains('selected')) {
                                        const col = card.closest('.col-6') || card.parentElement;
                                        if (col) col.classList.add('d-none');
                                    }
                                    const countBadge = document.getElementById('totalImgBadge');
                                    if (countBadge) countBadge.innerText = selectedItems.size;
                                    const bannerCount = document.getElementById('picksBannerCount');
                                    if (bannerCount) bannerCount.innerText = selectedItems.size;
                                }
                            }

                            function selectCard(card) {
                                if (!card.classList.contains('selected')) {
                                    card.classList.add('selected');
                                    selectedItems.add(card);
                                    saveSelectionToStorage();
                                }
                            }

                            function toggleSelectAll() {
                                const cards = document.querySelectorAll('.photo-card');
                                if (cards.length === 0) return;

                                const visibleCards = Array.from(cards).filter(c => !c.closest('div').classList.contains('d-none'));
                                const targetCards = visibleCards.length > 0 ? visibleCards : cards;
                                const allSelected = targetCards.every(c => c.classList.contains('selected'));

                                targetCards.forEach(card => {
                                    if (allSelected) {
                                        card.classList.remove('selected');
                                        selectedItems.delete(card);
                                    } else {
                                        if (!card.classList.contains('selected')) {
                                            card.classList.add('selected');
                                            selectedItems.add(card);
                                        }
                                    }
                                });
                                updateFloatingBar();
                                if (document.getElementById("imgModal").classList.contains("show")) updateModalCheckButtonState();
                                saveSelectionToStorage();
                            }

                            function clearSelection() {
                                document.querySelectorAll('.photo-card.selected').forEach(c => c.classList.remove('selected'));
                                selectedItems.clear();
                                updateFloatingBar();
                                if (document.getElementById("imgModal").classList.contains("show")) updateModalCheckButtonState();
                                saveSelectionToStorage();
                                if (isShowingSelectedOnly) toggleShowSelectedOnly();
                            }

                            // Cập nhật giao diện thanh tải nổi (Floating Bar) giống Google Drive
                            function updateFloatingBar() {
                                const bar = document.getElementById('floatingBar');
                                if (!bar) return;
                                const count = selectedItems.size;
                                document.getElementById('selectedCount').innerText = count;

                                const dlIcon = document.getElementById('dlBtnIcon');
                                const dlText = document.getElementById('dlBtnText');
                                const dlBtn = document.getElementById('btnSubmitDownload');

                                if (count === 1) {
                                    // Khi chọn đúng 1 ảnh: tải trực tiếp file đơn
                                    dlIcon.className = "bi bi-download me-2";
                                    dlText.innerText = "Tải 1 ảnh (Trực tiếp)";
                                    dlBtn.className = "btn btn-neo btn-primary-glow text-nowrap";
                                } else {
                                    // Khi chọn nhiều ảnh: nén ZIP tốc độ cao
                                    dlIcon.className = "bi bi-file-earmark-zip-fill me-2";
                                    dlText.innerText = "Tải " + count + " ảnh (Nén ZIP)";
                                    dlBtn.className = "btn btn-neo btn-success-glow text-nowrap";
                                }

                                if (count > 0) bar.classList.add('active');
                                else bar.classList.remove('active');
                            }

                            // Gửi form tải ảnh đã chọn
                            function submitDownloadSelected() {
                                if (selectedItems.size === 0) return;

                                let dataString = "";
                                selectedItems.forEach(card => {
                                    let name = card.getAttribute('data-name');
                                    let link = card.getAttribute('data-link');
                                    if (link) dataString += name + "###SEP###" + link + "###ROW###";
                                });

                                document.getElementById('hiddenDataInput').value = dataString;
                                document.getElementById('downloadSelectedForm').submit();
                            }

                            function saveSelectionToStorage() {
                                let names = [];
                                selectedItems.forEach(card => names.push(card.getAttribute('data-name')));
                                if (names.length === 0) {
                                    localStorage.removeItem(STORAGE_KEY);
                                } else {
                                    localStorage.setItem(STORAGE_KEY, JSON.stringify(names));
                                }
                            }

                            function loadSelectionFromStorage() {
                                const data = localStorage.getItem(STORAGE_KEY);
                                if (data) {
                                    try {
                                        const names = JSON.parse(data);
                                        if (Array.isArray(names)) {
                                            names.forEach(name => {
                                                const imgObj = allImagesData.find(img => img.name === name);
                                                if (imgObj) {
                                                    const card = document.getElementById(imgObj.cardId);
                                                    if (card) {
                                                        card.classList.add('selected');
                                                        selectedItems.add(card);
                                                    }
                                                }
                                            });
                                        }
                                    } catch (e) {
                                        console.error("Lỗi đọc storage", e);
                                    }
                                }
                            }

                            function toggleShowSelectedOnly() {
                                isShowingSelectedOnly = !isShowingSelectedOnly;
                                const btn = document.getElementById('btnShowSelected');
                                const allCols = document.querySelectorAll('#galleryContainer > div:not(#noSearchResultMsg)');
                                const countBadge = document.getElementById('totalImgBadge');

                                if (isShowingSelectedOnly) {
                                    btn.classList.remove('btn-outline-info');
                                    btn.classList.add('btn-info');
                                    btn.innerHTML = '<i class="bi bi-eye-slash me-1"></i> Hiện tất cả';

                                    let countSelected = 0;
                                    allCols.forEach(col => {
                                        const card = col.querySelector('.photo-card');
                                        if (!card || !card.classList.contains('selected')) {
                                            col.classList.add('d-none');
                                        } else {
                                            col.classList.remove('d-none');
                                            countSelected++;
                                        }
                                    });
                                    if (countBadge) countBadge.innerText = countSelected;
                                } else {
                                    btn.classList.add('btn-outline-info');
                                    btn.classList.remove('btn-info');
                                    btn.innerHTML = '<i class="bi bi-funnel me-1"></i> Xem ảnh đã chọn';

                                    allCols.forEach(col => col.classList.remove('d-none'));
                                    const filterInput = document.getElementById('txtFilterInput') || document.querySelector('input[name="txtFilter"]');
                                    if (filterInput && filterInput.value.trim() !== "") {
                                        filterInput.dispatchEvent(new Event('input'));
                                    } else if (countBadge && typeof allImagesData !== 'undefined') {
                                        countBadge.innerText = allImagesData.length;
                                    }
                                }
                            }

                            function showAllPhotosFromBanner() {
                                if (isShowingSelectedOnly) {
                                    toggleShowSelectedOnly();
                                }
                            }

                            // ====================================================
                            // TÌM KIẾM & BỘ LỌC TIẾNG VIỆT KHÔNG DẤU (FAST CLIENT SEARCH)
                            // ====================================================
                            function initClientSideSearch() {
                                const filterInput = document.getElementById('txtFilterInput') || document.querySelector('input[name="txtFilter"]');
                                const countBadge = document.getElementById('totalImgBadge');
                                const clearBtn = document.getElementById('btnClearFilter');
                                const noResultMsg = document.getElementById('noSearchResultMsg');

                                if (filterInput) {
                                    const doFilter = function () {
                                        if (isShowingSelectedOnly) toggleShowSelectedOnly();

                                        const val = filterInput.value.trim();
                                        if (clearBtn) clearBtn.style.display = val.length > 0 ? "block" : "none";

                                        const rawInput = removeVietnameseTones(val.toLowerCase());
                                        const keywords = rawInput.split(/[\s,]+/).filter(k => k.length > 0);
                                        const allCols = document.querySelectorAll('#galleryContainer > div:not(#noSearchResultMsg)');
                                        let visibleCount = 0;

                                        allCols.forEach(col => {
                                            const card = col.querySelector('.photo-card');
                                            if (!card) return;
                                            const originalName = card.getAttribute('data-name').toLowerCase();
                                            const noToneName = removeVietnameseTones(originalName);
                                            let isMatch = keywords.length === 0 ? true : keywords.some(key => noToneName.includes(key) || originalName.includes(key));

                                            if (isMatch) {
                                                col.classList.remove('d-none');
                                                visibleCount++;
                                            } else {
                                                col.classList.add('d-none');
                                            }
                                        });

                                        if (noResultMsg) {
                                            noResultMsg.style.display = (visibleCount === 0 && allCols.length > 0) ? "block" : "none";
                                        }

                                        if (countBadge) countBadge.innerText = visibleCount;
                                    };

                                    filterInput.addEventListener('input', doFilter);
                                    filterInput.addEventListener('keyup', doFilter);
                                    filterInput.addEventListener('keydown', function (e) {
                                        if (e.key === 'Enter') {
                                            e.preventDefault();
                                            filterInput.blur();
                                        }
                                    });

                                    // Lọc ngay khi mới tải trang nếu ô tìm kiếm có sẵn từ khóa
                                    if (filterInput.value.trim() !== '') {
                                        doFilter();
                                    }
                                }
                            }

                            function clearFilterText() {
                                const filterInput = document.getElementById('txtFilterInput') || document.querySelector('input[name="txtFilter"]');
                                if (filterInput) {
                                    filterInput.value = "";
                                    filterInput.dispatchEvent(new Event('input'));
                                    filterInput.focus();
                                }
                            }

                            function removeVietnameseTones(str) {
                                if (!str) return "";
                                str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
                                str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
                                str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
                                str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
                                str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
                                str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
                                str = str.replace(/đ/g, "d");
                                str = str.replace(/\u0300|\u0301|\u0303|\u0309|\u0323/g, "");
                                return str;
                            }

                            // ====================================================
                            // RÚT GỌN LINK & COPY (ƯU TIÊN is.gd)
                            // ====================================================
                            async function copyTextToClipboard(text) {
                                if (!text) return false;
                                try {
                                    if (navigator.clipboard && navigator.clipboard.writeText) {
                                        await navigator.clipboard.writeText(text);
                                        return true;
                                    }
                                } catch (e) {}
                                try {
                                    const textArea = document.createElement("textarea");
                                    textArea.value = text;
                                    textArea.style.position = "fixed";
                                    textArea.style.left = "-9999px";
                                    textArea.style.top = "0";
                                    document.body.appendChild(textArea);
                                    textArea.focus();
                                    textArea.select();
                                    const ok = document.execCommand('copy');
                                    document.body.removeChild(textArea);
                                    if (ok) return true;
                                } catch (e) {}
                                return false;
                            }

                            async function shortenUrlClientSide(longUrl) {
                                if (!longUrl) return "";
                                try {
                                    // Thử is.gd trực tiếp từ trình duyệt
                                    const res = await fetch("https://is.gd/create.php?format=json&url=" + encodeURIComponent(longUrl));
                                    if (res.ok) {
                                        const data = await res.json();
                                        if (data && data.shorturl) return data.shorturl;
                                    }
                                } catch (e) {}
                                try {
                                    // Thử da.gd trực tiếp từ trình duyệt
                                    const res = await fetch("https://da.gd/s?url=" + encodeURIComponent(longUrl));
                                    if (res.ok) {
                                        const short = (await res.text()).trim();
                                        if (short.startsWith("http")) return short;
                                    }
                                } catch (e) {}
                                return longUrl;
                            }

                            async function shortenAndCopyLink() {
                                const btn = document.getElementById('btnShare');
                                const originalText = btn.innerHTML;
                                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Đang tạo link...';
                                btn.disabled = true;

                                // 1. Xác định Domain chuẩn (tránh localhost khi test)
                                let host = window.location.origin;
                                if (host.includes("localhost") || host.includes("127.0.0.1") || host.includes("192.168.")) {
                                    host = "https://web-lay-anh-2jjf.onrender.com";
                                }

                                // 2. Lấy Folder ID hiện tại
                                let folderId = (typeof FOLDER_ID !== 'undefined' && FOLDER_ID) ? FOLDER_ID : '';
                                if (!folderId) {
                                    const urlParams = new URLSearchParams(window.location.search);
                                    folderId = urlParams.get('id') || urlParams.get('txtLink') || '';
                                }

                                // 3. Xây dựng link sạch gọn gàng https://web-lay-anh-2jjf.onrender.com/?id=...
                                let cleanUrl = host + '/?id=' + encodeURIComponent(folderId);
                                if (selectedItems.size > 0) {
                                    let names = [];
                                    selectedItems.forEach(card => { names.push(card.getAttribute('data-name')); });
                                    cleanUrl += '&picks=' + encodeURIComponent(names.join(','));
                                }

                                try {
                                    const apiUrl = 'tcController?action=shorten&longUrl=' + encodeURIComponent(cleanUrl);
                                    let response = await fetch(apiUrl);
                                    if (response.ok) {
                                        let shortLink = (await response.text()).trim();
                                        if (shortLink && (shortLink.startsWith("http://") || shortLink.startsWith("https://")) 
                                            && !shortLink.toLowerCase().includes("error") 
                                            && shortLink !== cleanUrl) {
                                            await copyTextToClipboard(shortLink);
                                            alert("✅ Đã copy Link Rút Gọn (is.gd):\n" + shortLink + "\n\n(Khách bấm vào link sẽ mở thẳng album ảnh ngay lập tức!)");
                                            return;
                                        }
                                    }

                                    // Dự phòng trực tiếp từ client nếu server chưa kịp trả về link rút gọn
                                    const clientShort = await shortenUrlClientSide(cleanUrl);
                                    if (clientShort && clientShort !== cleanUrl) {
                                        await copyTextToClipboard(clientShort);
                                        alert("✅ Đã copy Link Rút Gọn (is.gd):\n" + clientShort + "\n\n(Khách bấm vào link sẽ mở thẳng album ảnh ngay lập tức!)");
                                        return;
                                    }

                                    throw new Error("Lỗi dịch vụ rút gọn");
                                } catch (err) {
                                    console.warn(err);
                                    await copyTextToClipboard(cleanUrl);
                                    alert("✅ Đã copy Link Album Gọn Gàng:\n" + cleanUrl + "\n\n(Khách bấm vào link sẽ mở thẳng album ảnh ngay lập tức!)");
                                } finally {
                                    btn.innerHTML = originalText;
                                    btn.disabled = false;
                                }
                            }

                            // ====================================================
                            // XỬ LÝ GHI CHÚ ẢNH (MODAL PHOTO NOTES)
                            // ====================================================
                            function handlePhotoNoteInput(val) {
                                if (typeof allImagesData === 'undefined' || !allImagesData[currentImageIndex]) return;
                                const imgData = allImagesData[currentImageIndex];
                                const trimmed = (val || "").trim();
                                if (trimmed) {
                                    photoNotes[imgData.name] = val;
                                    // Tự động chọn ảnh này nếu chưa được chọn
                                    const card = document.getElementById(imgData.cardId);
                                    if (card && !card.classList.contains("selected")) {
                                        selectCard(card);
                                        updateFloatingBar();
                                        updateModalCheckButtonState();
                                    }
                                } else {
                                    delete photoNotes[imgData.name];
                                }
                                saveNotesToStorage();
                                const clearBtn = document.getElementById("btnClearPhotoNote");
                                if (clearBtn) clearBtn.style.display = trimmed ? "block" : "none";
                                const noteBadge = document.getElementById("card-note-badge-" + currentImageIndex);
                                if (noteBadge) noteBadge.style.display = trimmed ? "block" : "none";
                            }

                            function clearCurrentPhotoNote() {
                                const noteInput = document.getElementById("modalPhotoNoteInput");
                                if (noteInput) {
                                    noteInput.value = "";
                                    handlePhotoNoteInput("");
                                    noteInput.focus();
                                }
                            }

                            // ====================================================
                            // CHUẨN HÓA MÃ TÌM KIẾM WINDOWS EXPLORER (CÚ PHÁP "OR")
                            // ====================================================
                            function getCleanPhotoName(filename) {
                                if (!filename) return "";
                                // Cắt bỏ mọi đuôi file ảnh (.jpg, .jpeg, .png, .cr2, .cr3, .arw, .nef, .dng, .heic, v.v.)
                                return filename.replace(/\.[a-zA-Z0-9]+$/, "").trim();
                            }

                            function getOrSearchString() {
                                if (!selectedItems || selectedItems.size === 0) return "";
                                let cleanNames = [];
                                selectedItems.forEach(card => {
                                    let name = card.getAttribute('data-name');
                                    if (name) {
                                        let clean = getCleanPhotoName(name);
                                        if (clean && !cleanNames.includes(clean)) {
                                            cleanNames.push(clean);
                                        }
                                    }
                                });
                                return cleanNames.join(" OR ");
                            }

                            async function copyOrSearchString() {
                                if (selectedItems.size === 0) {
                                    alert("Vui lòng chọn ít nhất 1 ảnh trước!");
                                    return;
                                }
                                const orStr = getOrSearchString();
                                try {
                                    await navigator.clipboard.writeText(orStr);
                                    alert("✅ Đã copy mã tìm kiếm Windows Explorer:\n\n" + orStr + "\n\n(Dán vào ô tìm kiếm thư mục trên máy tính để tìm nhanh các file ảnh này!)");
                                } catch (err) {
                                    prompt("Sao chép mã tìm kiếm bên dưới:", orStr);
                                }
                            }

                            // ====================================================
                            // MODAL POPUP CHỐT DANH SÁCH ẢNH
                            // ====================================================
                            function openOrderModal() {
                                if (selectedItems.size === 0) {
                                    alert("Vui lòng chọn ít nhất 1 ảnh trước khi chốt danh sách!");
                                    return;
                                }

                                let notedCount = 0;
                                selectedItems.forEach(card => {
                                    let name = card.getAttribute('data-name');
                                    if (name && photoNotes[name] && photoNotes[name].trim()) {
                                        notedCount++;
                                    }
                                });

                                document.getElementById("modalSelectedCountBadge").innerText = selectedItems.size + " ảnh";
                                document.getElementById("modalNotedCountBadge").innerText = notedCount + " ảnh có ghi chú";
                                document.getElementById("modalOrCodePreview").innerText = getOrSearchString();

                                try {
                                    const savedCustomer = JSON.parse(localStorage.getItem("customer_info") || "{}");
                                    if (savedCustomer.name) document.getElementById("orderClientName").value = savedCustomer.name;
                                    if (savedCustomer.phone) document.getElementById("orderClientPhone").value = savedCustomer.phone;
                                } catch (e) {}

                                const isUpdate = !!localStorage.getItem("latest_submitted_order_" + FOLDER_ID) || new URLSearchParams(window.location.search).has('picks');
                                const titleEl = document.getElementById("orderModalTitle");
                                if (titleEl) {
                                    titleEl.innerText = isUpdate ? "Cập nhật danh sách ảnh chọn" : "Chốt danh sách ảnh chọn";
                                }
                                const submitBtn = document.getElementById("btnConfirmOrderSubmit");
                                if (submitBtn) {
                                    submitBtn.innerHTML = isUpdate ? '<i class="bi bi-check2-all me-2"></i> Xác nhận cập nhật & Gửi cho Studio' : '<i class="bi bi-send-fill me-2"></i> Xác nhận chốt & Gửi cho Studio';
                                }

                                const modal = document.getElementById("orderModal");
                                modal.classList.add("show");
                            }

                            function closeOrderModal(e) {
                                if (e && e.target && e.target.id !== "orderModal" && !e.target.closest('.btn-tool')) return;
                                const modal = document.getElementById("orderModal");
                                modal.classList.remove("show");
                            }

                            async function copyModalOrString() {
                                const orStr = getOrSearchString();
                                try {
                                    await navigator.clipboard.writeText(orStr);
                                    alert("✅ Đã sao chép mã:\n" + orStr);
                                } catch (err) {
                                    prompt("Sao chép mã bên dưới:", orStr);
                                }
                            }

                            function buildOrderMessage(clientName, clientPhone, generalNote) {
                                const isUpdate = !!localStorage.getItem("latest_submitted_order_" + FOLDER_ID) || new URLSearchParams(window.location.search).has('picks');
                                let msg = isUpdate ? "🔔 BẢN CẬP NHẬT CHỐT ẢNH MỚI NHẤT (Khách đã chỉnh sửa):\n" : "Chào Studio, mình gửi danh sách chọn ảnh:\n";
                                msg += "👤 Khách hàng: " + clientName + (clientPhone ? " - SĐT: " + clientPhone : "") + "\n";
                                msg += "📁 Tổng số ảnh chọn: " + selectedItems.size + " ảnh\n";
                                let host = window.location.origin;
                                if (host.includes("localhost") || host.includes("127.0.0.1") || host.includes("192.168.")) {
                                    host = "https://web-lay-anh-2jjf.onrender.com";
                                }
                                let shareUrl = host + "/?id=" + encodeURIComponent(FOLDER_ID);
                                if (selectedItems.size > 0) {
                                    let names = [];
                                    selectedItems.forEach(card => { names.push(card.getAttribute('data-name')); });
                                    shareUrl += "&picks=" + encodeURIComponent(names.join(','));
                                }
                                msg += "🔗 Link xem lại ảnh đã chọn: " + shareUrl + "\n";
                                if (generalNote) {
                                    msg += "📝 Dặn dò chung: " + generalNote + "\n";
                                }
                                msg += "🔍 Mã tìm kiếm (Windows Explorer):\n" + getOrSearchString() + "\n";

                                let notedList = [];
                                selectedItems.forEach(card => {
                                    let name = card.getAttribute('data-name');
                                    if (name && photoNotes[name] && photoNotes[name].trim()) {
                                        notedList.push("• " + getCleanPhotoName(name) + ": " + photoNotes[name].trim());
                                    }
                                });

                                if (notedList.length > 0) {
                                    msg += "\n📋 Ghi chú chi tiết từng tấm:\n" + notedList.join("\n");
                                }
                                return msg;
                            }

                            async function sendOrderViaZalo() {
                                const nameInput = document.getElementById("orderClientName");
                                const phoneInput = document.getElementById("orderClientPhone");
                                const noteInput = document.getElementById("orderGeneralNote");

                                const name = nameInput.value.trim();
                                const phone = phoneInput.value.trim();
                                if (!name) {
                                    alert("Vui lòng điền Họ tên của bạn!");
                                    nameInput.focus();
                                    return;
                                }

                                try {
                                    localStorage.setItem("customer_info", JSON.stringify({ name: name, phone: phone }));
                                } catch (e) {}

                                const fullMsg = buildOrderMessage(name, phone, noteInput.value.trim());
                                try {
                                    await navigator.clipboard.writeText(fullMsg);
                                } catch (e) {}

                                closeOrderModal();
                                alert("✅ Đã sao chép toàn bộ nội dung chốt ảnh mới!\n\nĐang mở Zalo chat với Studio (0388.520.391).\nBạn chỉ cần bấm 'Dán' (Ctrl+V) vào ô chat và gửi đi là xong!");
                                window.open("https://zalo.me/" + STUDIO_ZALO_PHONE, "_blank");
                            }

                            function submitOrderConfirmation() {
                                const nameInput = document.getElementById("orderClientName");
                                const phoneInput = document.getElementById("orderClientPhone");
                                const noteInput = document.getElementById("orderGeneralNote");

                                const name = nameInput.value.trim();
                                const phone = phoneInput.value.trim();
                                if (!name) {
                                    alert("Vui lòng điền Họ tên của bạn!");
                                    nameInput.focus();
                                    return;
                                }
                                if (!phone) {
                                    alert("Vui lòng điền Số điện thoại hoặc Zalo để Studio tiện liên hệ!");
                                    phoneInput.focus();
                                    return;
                                }

                                try {
                                    localStorage.setItem("customer_info", JSON.stringify({ name: name, phone: phone }));
                                } catch (e) {}

                                const now = new Date();
                                const orderId = "ORD-" + ("0" + now.getHours()).slice(-2) + ("0" + now.getMinutes()).slice(-2) + ("0" + now.getSeconds()).slice(-2);
                                const orderData = {
                                    orderId: orderId,
                                    folderId: FOLDER_ID,
                                    clientName: name,
                                    clientPhone: phone,
                                    generalNote: noteInput.value.trim(),
                                    selectedCount: selectedItems.size,
                                    orString: getOrSearchString(),
                                    notes: photoNotes,
                                    submittedAt: now.toISOString()
                                };

                                try {
                                    localStorage.setItem("latest_submitted_order_" + FOLDER_ID, JSON.stringify(orderData));
                                    localStorage.setItem("order_sub_" + FOLDER_ID + "_" + now.getTime(), JSON.stringify(orderData));
                                } catch (e) {}

                                // 1. Tự động lưu đơn chốt về Máy Chủ Trung Tâm (Central Server - Hoạt động trên mọi thiết bị & Facebook)
                                try {
                                    fetch("tcController?action=saveOrder", {
                                        method: "POST",
                                        headers: { "Content-Type": "application/json; charset=UTF-8" },
                                        body: JSON.stringify(orderData)
                                    }).then(r => r.json()).then(res => {
                                        console.log("Đã lưu đơn chốt về máy chủ trung tâm:", res);
                                    }).catch(err => console.warn("Lỗi lưu đơn về máy chủ:", err));
                                } catch (e) {}

                                // 2. Tự động đồng bộ đơn chốt dự phòng về Google Sheets cho Studio
                                if (typeof STUDIO_SCRIPT_URL !== 'undefined' && STUDIO_SCRIPT_URL) {
                                    try {
                                        fetch(STUDIO_SCRIPT_URL + "?action=save_order", {
                                            method: "POST",
                                            mode: "no-cors",
                                            headers: { "Content-Type": "application/json" },
                                            body: JSON.stringify(orderData)
                                        }).catch(err => console.log("Lỗi đồng bộ Sheet:", err));
                                    } catch (e) {}
                                }

                                closeOrderModal();
                                const isUpdate = !!localStorage.getItem("latest_submitted_order_" + FOLDER_ID) || new URLSearchParams(window.location.search).has('picks');
                                if (isUpdate) {
                                    alert("🎉 ĐÃ CẬP NHẬT DANH SÁCH ẢNH THÀNH CÔNG!\n\nStudio đã cập nhật danh sách " + selectedItems.size + " ảnh mới từ " + name + ".\nNếu muốn thông báo ngay cho Studio, bạn có thể bấm tiếp 'Gửi qua Zalo' nhé!");
                                } else {
                                    alert("🎉 XÁC NHẬN CHỐT DANH SÁCH THÀNH CÔNG!\n\nStudio đã ghi nhận " + selectedItems.size + " ảnh chọn từ " + name + ".\nStudio sẽ sớm liên hệ qua số " + phone + " để bàn giao ảnh đẹp cho bạn!");
                                }
                            }
                        </script>

                    </body>

                    </html>