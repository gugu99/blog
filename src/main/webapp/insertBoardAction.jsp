<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------insertBoardAction");	

	if (session.getAttribute("loginLevel") == null) { // 로그인이 안되어있을 때
		response.sendRedirect("./login.jsp");
		return;
	}
	
	if ((Integer)session.getAttribute("loginLevel") < 1) { // 권한이 없을 때
		response.sendRedirect("./boardList.jsp");
		return;
	}

	request.setCharacterEncoding("UTF-8");
	
	int locationNo = Integer.parseInt(request.getParameter("locationNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	
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
   String sql = "INSERT INTO board (location_no, board_title, board_content, board_pw, create_date) VALUES (?,?,?,PASSWORD(?),NOW())";
   stmt = conn.prepareStatement(sql);
   stmt.setInt(1, locationNo);
   stmt.setString(2, boardTitle);
   stmt.setString(3, boardContent);
   stmt.setString(4, boardPw);
   System.out.println("locationStmt --- " + stmt); // 디버깅
   
   int result = stmt.executeUpdate();
   // 쿼리 실행 디버깅
   if (result == 1){
	   System.out.println("insert 성공!");
   } else {
	   System.out.println("insert 실!");
   }
   
   // 재요청
   response.sendRedirect("./boardList.jsp");
   
 	//db 자원해제 
 	stmt.close();
 	conn.close();
%>