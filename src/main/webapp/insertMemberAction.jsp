<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------insertMemberAction");
	// encoding
	request.setCharacterEncoding("UTF-8");
	
	if (session.getAttribute("loginId") != null) { // 로그인 상태면 board.jsp로 이동
		response.sendRedirect("./boardList.jsp");
		return;
	}
	
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	if (id == null || pw == null || id.length() < 4 || pw.length() < 4) {
		response.sendRedirect("./register.jsp?errorMsg=error");
		return; // return; 대신 else 블록을 사용해도 된다.
	}
	
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
	   String sql = "INSERT INTO member (id, pw, level) VALUES (?, PASSWORD(?), 0)";
	   stmt = conn.prepareStatement(sql);
	   stmt.setString(1, id);
	   stmt.setString(2, pw);
	   System.out.println("locationStmt --- " + stmt); // 디버깅
	   
	   int result = stmt.executeUpdate();
	   
	   if (result == 1 ) {
		   System.out.println("회원가입 성공");
		   response.sendRedirect("./login.jsp");
	   } else {
		   System.out.println("회원가입 실패!");
		   response.sendRedirect("./register.jsp");
	   }
	   
%>

<%
	//db 자원해제 
	stmt.close();
	conn.close();
%>