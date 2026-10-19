<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    // Chuyển tiếp sang /tcController để xử lý dữ liệu, giữ nguyên mọi tham số (?id=..., ?picks=...) và giữ URL sạch trên trình duyệt
    request.getRequestDispatcher("/tcController").forward(request, response); 
%>