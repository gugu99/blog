<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------deleteDiaryAction");
	
	request.setCharacterEncoding("UTF-8");

	if (session.getAttribute("loginLevel") == null) { // 로그인이 안되어있을 때
		response.sendRedirect("./login.jsp");
		return;
	}
	
	if ((Integer)session.getAttribute("loginLevel") < 1) { // 권한이 없을 때
		response.sendRedirect("./boardList.jsp");
		return;
	}
	
	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
	int y = Integer.parseInt(request.getParameter("y")); // 연도
	int m = Integer.parseInt(request.getParameter("m")); // 월
	
	System.out.println("diaryNo --- " + diaryNo); // 디버깅
	
	// db 접속
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1002";
	Connection conn = null;
	PreparedStatement stmt = null;
	conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("conn --- " + conn); // 디버깅
	
	String sql = "DELETE FROM diary WHERE diary_no = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, diaryNo);
	System.out.println("stmt --- " + stmt); // 디버깅
	
	int result = stmt.executeUpdate();
	
	if (result > 0) {
		System.out.println("일정삭제성공!!!");
	} else {
		System.out.println("일정삭제실패!!!");
	}
	response.sendRedirect("diary.jsp?y="+y+"&m="+m);
	// db 자원 해제
	stmt.close();
	conn.close();
%>
