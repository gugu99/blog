<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------deleteCommentAction");
	
	// 로그인 상태가 아니면 login.jsp로 이동 
	if (session.getAttribute("loginId") == null) {
		response.sendRedirect("./login.jsp?errorMsg=DoLogin");
		return;
	}
	
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println("commentNo --- " + commentNo);
	System.out.println("boardNo --- " + boardNo);
	
	// db 접속
   Class.forName("org.mariadb.jdbc.Driver");
   String url = "jdbc:mariadb://localhost:3306/blog";
   String dbuser = "root";
   String dbpw = "1002";
   Connection conn = null;
   PreparedStatement stmt = null;
   conn = DriverManager.getConnection(url, dbuser, dbpw);
   System.out.println("conn --- " + conn); // 디버깅
   
   // 메뉴 목록
   String sql = "Delete FROM comment WHERE comment_no = ? AND board_no = ?";
   stmt = conn.prepareStatement(sql);
   stmt.setInt(1, commentNo);
   stmt.setInt(2, boardNo);
   System.out.println("stmt --- " + stmt); // 디버깅
   
   int result = stmt.executeUpdate();
   
   if (result > 0) {
	   System.out.println("댓글 삭제 성공!");
   } else {
	   System.out.println("댓글 삭제 실패!");
   }
   
   response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
   
   // db 자원 해제
   stmt.close();
   conn.close();
%>