<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	if (session.getAttribute("loginId") == null) { // 로그인 상태가 아니면 login.jsp로 이동
		response.sendRedirect("./login.jsp?errorMsg=DoLogin");
		return;
	}
	session.invalidate(); // 세션 리셋
	response.sendRedirect("./boardList.jsp"); // 로그아웃하고 boardList.jsp로 이동
%>