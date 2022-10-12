<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------deleteAction");

	if (session.getAttribute("loginLevel") == null) { // 로그인이 안되어있을 때
		response.sendRedirect("./login.jsp");
		return;
	}
	
	if ((Integer)session.getAttribute("loginLevel") < 1) { // 권한이 없을 때
		response.sendRedirect("./boardList.jsp");
		return;
	}

	request.setCharacterEncoding("UTF-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	System.out.println("boardNo --- " + boardNo); // 디버깅
	System.out.println("boardPw --- " + boardPw); // 디버깅
	
	// db 접속
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1002";
	Connection conn = null;
	PreparedStatement stmt = null;
	
	conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("conn --- " + conn); // 디버깅
	 
	String sql = "DELETE FROM board WHERE board_no = ? AND board_pw = PASSWORD(?)";
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, boardPw);
	System.out.println("stmt --- " + stmt);
	
	int result = stmt.executeUpdate();
	
	if (result == 1){
		System.out.println("삭제 성공!!!");
		response.sendRedirect("./boardList.jsp");
	} else {
		System.out.println("삭제 실패!!!");
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	}
   
 	//db 자원해제 
 	stmt.close();
 	conn.close();
%>