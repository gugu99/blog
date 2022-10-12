<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------boardOne");

	if (session.getAttribute("loginId") == null) { // 로그인 상태가 아니면 login.jsp로 이동
		response.sendRedirect("./login.jsp?errorMsg=DoLogin");
		return;
	}
	
	request.setCharacterEncoding("UTF-8");
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String id = request.getParameter("id");
	System.out.println("boardNo --- " + boardNo);
	System.out.println("commentContent --- " + commentContent);
	System.out.println("id --- " + id);
	
	// db 접속
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1002";
	Connection conn = null;
	PreparedStatement stmt = null;
	String sql = "INSERT INTO comment (board_no, comment_content, create_date, id) VALUES (?, ?, NOW(), ?)";
	
	conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("conn --- " + conn); // 디버깅
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentContent);
	stmt.setString(3, id);
	System.out.println("stmt --- " + stmt);
	
	int result = stmt.executeUpdate();
	
	if (result == 1){
		System.out.println("댓글 작성 성공!");
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	} else {
		System.out.println("댓글 작성 실!");
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	}
	
	//db 자원해제 
	stmt.close();
	conn.close();
%>