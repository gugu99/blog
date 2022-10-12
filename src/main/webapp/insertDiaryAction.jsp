<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.util.*"%>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------insertDiaryAction");
	
	request.setCharacterEncoding("UTF-8");

	if (session.getAttribute("loginLevel") == null) { // 로그인이 안되어있을 때
		response.sendRedirect("./login.jsp");
		return;
	}
	
	if ((Integer)session.getAttribute("loginLevel") < 1) { // 권한이 없을 때
		response.sendRedirect("./boardList.jsp");
		return;
	}
	
	// diary
	Calendar c = Calendar.getInstance();
	int y = Integer.parseInt(request.getParameter("y")); // 연도
	int m = Integer.parseInt(request.getParameter("m")); // 월
	int d = Integer.parseInt(request.getParameter("d")); // 일
	String diaryTodo = request.getParameter("diaryTodo");
	
	String diaryDate = y+"-"+m+"-"+d;
		
	c.set(Calendar.YEAR, y);
	c.set(Calendar.MONTH, m-1);
	c.set(Calendar.DATE, d);
		
	System.out.println("y --- " + y); // 디버깅
	System.out.println("m --- " + m); // 디버깅
	System.out.println("d--- " + d); // 디버깅
	System.out.println("diaryTodo --- " + diaryTodo); // 디버깅
	
	// db 접속
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1002";
	Connection conn = null;
	PreparedStatement stmt = null;
	conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("conn --- " + conn); // 디버깅
	
	String sql = "INSERT INTO diary (diary_date, diary_todo, create_date) VALUES (?,?,NOW())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, diaryTodo);
	System.out.println("stmt --- " + stmt); // 디버깅
	
	int result = stmt.executeUpdate();
	
	if (result > 0) {
		System.out.println("일정등록성공!!!");
	} else {
		System.out.println("일정등록실패!!!");
	}
	response.sendRedirect("diary.jsp?y="+y+"&m="+(m-1));
	// db 자원 해제
	stmt.close();
	conn.close();
%>
