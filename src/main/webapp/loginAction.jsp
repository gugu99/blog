<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	if (session.getAttribute("loginId") != null) { // 로그인 상태면 boardList.jsp로 이동
		response.sendRedirect("./boardList.jsp");
		return;
	}

	request.setCharacterEncoding("UTF-8");
	
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	System.out.println("id --- " + id);
	System.out.println("pw --- " + pw);

	if (id == null || pw == null) {
		response.sendRedirect("./login.jsp?errorMsg=Invalid Access");
		return;
	}
	
		// db 접속
	   Class.forName("org.mariadb.jdbc.Driver");
	   String url = "jdbc:mariadb://localhost:3306/blog";
	   String dbuser = "root";
	   String dbpw = "1002";
	   Connection conn = null;
	   PreparedStatement stmt = null;
	   ResultSet rs = null;
	   conn = DriverManager.getConnection(url, dbuser, dbpw);
	   System.out.println("conn --- " + conn); // 디버깅
	   
	   String sql = "SELECT id, level FROM member WHERE id = ? AND pw = PASSWORD(?)";
	   stmt = conn.prepareStatement(sql);
	   stmt.setString(1, id);
	   stmt.setString(2, pw);
	   System.out.println("stmt --- " + stmt);
	   
	   rs = stmt.executeQuery();
	   
	   if (rs.next()){ // 로그인 성공
		   // setAttribute(String, Object)
		   session.setAttribute("loginId", rs.getString("id")); // Object <- String 추상화,상속,다형성,캡슐화
		   session.setAttribute("loginLevel", rs.getInt("level")); // Object <-(다형성) Integer <-(오토박싱) int 
		   
		   response.sendRedirect("./boardList.jsp");
	   } else { // 로그인 실패
		   response.sendRedirect("./login.jsp?errorMsg=Invalid ID or PW");
	   }
	
	 //db 자원해제 
	rs.close();
	stmt.close();
	conn.close();
%>