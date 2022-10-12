<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------diaryOne");

	if (session.getAttribute("loginLevel") == null) { // 로그인이 안되어있을 때
		response.sendRedirect("./login.jsp");
		return;
	}
	
	String locationNo = request.getParameter("locationNo");
	System.out.println("locationNo --- " + locationNo); // 디버깅

	// db 접속
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1002";
	Connection conn = null;
	conn = DriverManager.getConnection(url, dbuser, dbpw);
	
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
<title>Diary</title>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link  >
<link href='https://fonts.googleapis.com/css?family=Roboto:400,100,300,700' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="css/style.css">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<!-- Favicon-->
<link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
<!-- Core theme CSS (includes Bootstrap)-->
<link href="css/styles.css" rel="stylesheet" />
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
<div class="d-flex" id="wrapper">
	    <!-- Sidebar-->
	    <div class="border-end bg-white" id="sidebar-wrapper">
	        <div class="sidebar-heading border-bottom bg-light">
	        	<h1><a href="./boardList.jsp">BLOG</a></h1>
	        
	        <%
				if (session.getAttribute("loginId") != null) { // 로그인 상태일때만 로그아웃 버튼 보이기
			%>
					<span><%=session.getAttribute("loginId") %>님 반갑습니다.</span>
			<%
				}
			%>
			</div>
	        <div class="list-group list-group-flush">
	            <a class="list-group-item list-group-item-action list-group-item-light p-3" href="./boardList.jsp">전체</a>
	            <%
	       while(locationRs.next()) {
	    %>
	    	<a class="list-group-item list-group-item-action list-group-item-light p-3" href="./boardList.jsp?locationNo=<%=locationRs.getString("locationNo")%>">
	    		<%=locationRs.getString("locationName")%>
	    	</a>
	    <%      
	       }
	    %> 
	        </div>
	    </div>
	    <!-- Page content wrapper-->
	    <div id="page-content-wrapper">
	        <!-- Top navigation-->
	        <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
	            <div class="container-fluid">
	                <button class="btn" id="sidebarToggle"><span class="navbar-toggler-icon"></span></button>
	                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
	                <div class="collapse navbar-collapse" id="navbarSupportedContent">
	                    <ul class="navbar-nav ms-auto mt-2 mt-lg-0">
	                    
	                        <li class="nav-item active"><a class="nav-link" href="./boardList.jsp">BOARD</a></li>
	                        <li class="nav-item"><a class="nav-link" href="./guestbook.jsp">GUESTBOOK</a></li>
	                        <li class="nav-item"><a class="nav-link" href="./diary.jsp">DIARY</a></li>
	                        <%
								if (session.getAttribute("loginId") != null) { // 로그인 상태일때만 로그아웃 버튼 보이기
							%>
									<li class="nav-item"><a class="nav-link" href="./logout.jsp">LOGOUT</a></li>
							<%
								} else {
							%>
									<li class="nav-item"><a class="nav-link" href="./login.jsp">LOGIN</a></li>
									<li class="nav-item"><a class="nav-link" href="./register.jsp">REGISTER</a></li>
							<%
								}
							%>
	                    </ul>
	                </div>
	            </div>
	        </nav>
	    
	   <%
			int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
	   		int y = Integer.parseInt(request.getParameter("y")); // 연도
			int m = Integer.parseInt(request.getParameter("m")); // 월

			String diarySql = "SELECT diary_no diaryNo, diary_date diaryDate, diary_todo diaryTodo, create_date FROM diary WHERE diary_no = ?";
			PreparedStatement diaryStmt = null;
			ResultSet diaryRs = null;
			
			diaryStmt = conn.prepareStatement(diarySql);
			diaryStmt.setInt(1, diaryNo);
			System.out.println("diaryStmt --- " + diaryStmt);
			
			diaryRs = diaryStmt.executeQuery();
				
			String d = "";
			if (diaryRs.next()){
				String date = diaryRs.getString("diaryDate");
 				d = date.substring(8, date.length());
		%>
		<!-- Page content-->
        <div class="container-fluid">
        	<!-- start main -->
			<h1>일정 상세보기</h1>
			<table class="table table-bordered">
				<tr>
					
					<th>DIARY_NO</th>
					<th>DIARY_DATE</th>
					<th>CREATE_DATE</th>
				</tr>
				<tr>
					
					<td><%=diaryRs.getInt("diaryNo") %></td>
					<td><%=diaryRs.getString("diaryDate") %></td>
					<td><%=diaryRs.getString("create_date") %></td>
				</tr>
				<tr>
					<th colspan="3">DIARY_TODO</th>
				</tr>
				<tr>
					<td colspan="3"><%=diaryRs.getString("diaryTodo") %></td>
				</tr>
			</table>
		<%
			}
			
		%>
			<div class="text-right">
			<%
					if ((Integer)session.getAttribute("loginLevel") > 0){
			%>
				<a href="./updateDiaryForm.jsp?diaryNo=<%=diaryNo %>&y=<%=y %>&m=<%=m-1 %>&d=<%=d %>" class="btn btn-primary" type="submit">수정</a>
				<a href="./deleteDiaryAction.jsp?diaryNo=<%=diaryNo %>&y=<%=y %>&m=<%=m-1 %>" class="btn btn-danger" type="reset">삭제</a>
			<%
					}
			%>
				<a class="btn btn-success" href="./diary.jsp?y=<%=y %>&m=<%=m-1 %>">목록으로</a>
		   </div>
        </div>
	</div>
</div>
<!-- Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="js/scripts.js"></script>
</body>
</html>
<%
	// db 자원해
	locationRs.close();
	locationStmt.close();
	diaryRs.close();
	diaryStmt.close();
	conn.close();
%>