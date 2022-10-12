<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------updateBoardForm");

	if (session.getAttribute("loginLevel") == null) { // 로그인이 안되어있을 때
		response.sendRedirect("./login.jsp");
		return;
	}
	
	if ((Integer)session.getAttribute("loginLevel") < 1) { // 권한이 없을 때
		response.sendRedirect("./boardList.jsp");
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
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>BLOG</title>
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
			int boardNo = Integer.parseInt(request.getParameter("boardNo"));
			/*
				SELECT 
					l.location_name locationName, 
					b.board_title boardTitle, 
					b.board_content boardContent, 
					b.create_date 
					FROM board b INNER JOIN location l
					ON b.location_no = l.location_no
					WHERE b.board_no = ?
			*/
			String boardSql = "SELECT l.location_name locationName, b.board_title boardTitle, b.board_content boardContent, b.create_date FROM board b INNER JOIN location l ON b.location_no = l.location_no WHERE b.board_no = ?";
			PreparedStatement boardStmt = null;
			ResultSet boardRs = null;
			
			boardStmt = conn.prepareStatement(boardSql);
			boardStmt.setInt(1, boardNo);
			System.out.println("boardStmt --- " + boardStmt);
			
			boardRs = boardStmt.executeQuery();
			
			if (boardRs.next()){
		%>
		
		<!-- Page content-->
        <div class="container-fluid">
        	<form action="./updateAction.jsp" method="post">
				<fieldset>
					<legend>게시글 수정</legend>
					<div class="form-group">
						<input type="hidden" name="boardNo" value="<%=boardNo%>"/>
						<label for="locationName">LOCAIOTNNAME</label>
						<select id="locationName" name="locationNo" class="form-control">
							<%
								// issue
								locationRs.first();
								do {
							%>
									<option value="<%=locationRs.getInt("locationNo")%>">
										<%=locationRs.getString("locationName") %>
									</option>
							<%		
								}while(locationRs.next());
							%>
						</select>
					</div>
					<div class="form-group">
						<label for="boardTitle">TITLE</label>
						<input class="form-control" type="text" name="boardTitle" id="boardTitle" value="<%=boardRs.getString("boardTitle") %>"/>
					</div>
					<div class="form-group">
						<label for="boardContent">CONTENT</label>
						<textarea class="form-control" rows="5" cols="80" name="boardContent" id="boardContent"><%=boardRs.getString("boardContent") %></textarea>
					</div>
					<div class="form-group">
						<label>PASSWORD</label>
						<input class="form-control" type="password" name="boardPw" id="boardPw"/>
					</div>
					<div class="form-group text-right">
						<button type="submit" class="btn btn-primary">수정</button>
						<a href="./boardOne.jsp?boardNo=<%=boardNo %>" class="btn btn-danger">취소</a>
						<a class="btn btn-success" href="./boardList.jsp">목록으로</a>
					</div>
				</fieldset>
			</form>
        </div>
		<%
			}
			
		%>
	</div>
</div><!-- container -->
<!-- Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="js/scripts.js"></script>
</body>
</html>
<%
	//db 자원해제 
	locationRs.close();
	locationStmt.close();
	boardRs.close();
	boardStmt.close();
	conn.close();
%>