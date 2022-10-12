<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("---------------------------------------boardList");
	
	String locationNo = request.getParameter("locationNo");
	System.out.println("locationNo --- " + locationNo); // 디버깅
	
	// db 접속
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1002";
	Connection conn = null;
	PreparedStatement locationStmt = null;
	ResultSet locationRs = null;
	conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("conn --- " + conn); // 디버깅
	   
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	locationStmt = conn.prepareStatement(locationSql);
	locationRs = locationStmt.executeQuery();
	System.out.println("locationStmt --- " + locationStmt); // 디버깅
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert Board</title>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<!-- jQuery library -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>
<!-- Popper JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container">
	<div class="row">
		<div class="col-sm-6">
			<h1><a href="./boardList.jsp">BLOG</a></h1>
		</div>
		<%
			if (session.getAttribute("loginId") != null) { // 로그인 상태일때만 로그아웃 버튼 보이기
		%>
		<div class="col-sm-6 text-right">
			<a href="./logout.jsp" class="btn btn-danger text-right">로그아웃</a>
		</div>
		<%
			}
		%>
	</div>
	<hr/>
	<div class="row">
		<div class="col-sm-2">
		<!-- left menu -->
			<div>
		         <a href="./boardList.jsp">전체</a>
		         <table class="table table-hover">
		         <%
		            while(locationRs.next()) {
		         %>
		               <tr>
		               		<td>
			                  <a href="./boardList.jsp?locationNo=<%=locationRs.getString("locationNo")%>">
			                     <%=locationRs.getString("locationName")%>
			                  </a>
		               		</td>
		               </tr>
		         <%      
		            }
		         %>  
		         </table> 
		         <hr/>
		         <a href="./index.jsp" class="btn btn-success">INDEX</a>
		         <hr/>
		         <a href="./guestbook.jsp" class="btn btn-warning">GUESTBOOK</a>
		   </div>
		</div>
		
		<!-- start main -->
		<div class="col-sm-10">
			
		</div><!-- main end -->
	</div><!-- row -->
</div><!-- container -->
</body>
</html>