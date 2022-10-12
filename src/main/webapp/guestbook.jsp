<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("---------------------------------------guestbook");
	
	String locationNo = request.getParameter("locationNo");
	System.out.println("locationNo --- " + locationNo); // 디버깅
	
	// 페이징
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;
	System.out.println("currentPage --- " + currentPage); // 디버깅
	System.out.println("beginRow --- " + beginRow); // 디버깅
	
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
		<!-- Page content-->
        <div class="container-fluid">
        	<%
			if (session.getAttribute("loginId") != null) {
			%>
				<form action="./insertGuestbookAction.jsp" method="post">
					<fieldset>
						<legend>방명록</legend>
						<div class="form-group">
							<label for="guestbookContent">내용</label>
							<textarea rows="3" cols="50" name="guestbookContent" id="guestbookContent" class="form-control"></textarea>
						</div>
						<div>
							<button type="submit" class="btn btn-primary form-control" >글 입력</button>
						</div>
					</fieldset>
					<!-- 
						guestbook_no : auto_increment
						guestbook_content : guestbookContent
						id : sessiongetAttribute("loginId")
						create_date : now()
					 -->
				</form>
			<%
				}
			%>
			<!-- to do -->
			<%
				String guestbookSql = "SELECT guestbook_no guestbookNo, guestbook_content guestbookContent, id, create_date FROM guestbook ORDER BY create_date DESC LIMIT ?,?";
				PreparedStatement guestbookStmt = conn.prepareStatement(guestbookSql);
				guestbookStmt.setInt(1, beginRow);
				guestbookStmt.setInt(2, ROW_PER_PAGE);
				ResultSet guestbookRs = guestbookStmt.executeQuery();
				System.out.println("guestbookStmt --- " + guestbookStmt);
			%>
				<hr/>
				<table class="table table-striped">
					<%	
						while (guestbookRs.next()) {
					%>
						<tr>
							<td>ID : <%=guestbookRs.getString("id") %></td>
							<td>DATE : <%=guestbookRs.getString("create_date") %></td>
							<%
								String loginId = (String)session.getAttribute("loginId");
								if (loginId != null && loginId.equals(guestbookRs.getString("id"))) {
							%>
							<td>
								<a href="./deleteGuestbookAction.jsp?guestbookNo=<%=guestbookRs.getInt("guestbookNo")%>">삭제</a>
							</td>
							<%
								} else {
							%>
								<td></td>
							<%
								}
							%>
						</tr>
						<tr>
							<td colspan="3"><%=guestbookRs.getString("guestbookContent") %></td>
						</tr>
					<%
						}
					%>
			</table>
			
			<!-- 페이징 -->
			<%
		   		int totalRow = 0;
            	PreparedStatement pageStmt = null;
            	ResultSet pageRs = null;
            	String pageSql = "SELECT count(*) from guestbook";
            	pageStmt = conn.prepareStatement(pageSql);
            	pageRs = pageStmt.executeQuery();
            	
            	if(pageRs.next()){
            		totalRow = pageRs.getInt("count(*)");
            	}
		   		System.out.println("pageStmt --- " + pageStmt);
		   		System.out.println("pageRs --- " + pageRs);
		   %>
		   <div>
		   		<ul class="pagination justify-content-center">
		   		<%	
			   		int lastPage = totalRow / ROW_PER_PAGE;
			   		if(totalRow % ROW_PER_PAGE != 0) {
			   			lastPage += 1;
			   		}
			   		
			   		int end = (int)(Math.ceil(currentPage / (double)ROW_PER_PAGE) * ROW_PER_PAGE);
					int start = end - ROW_PER_PAGE + 1;
					end = (end < lastPage) ? end : lastPage; // lastPage 이상이 되면 end페이지 번호가 lastPage
					String preDisabled = (currentPage == 1) ? "disabled" : "";
					String nextDisabled = (currentPage == lastPage) ? "disabled" : "";
					
					System.out.println("totalRow --- " + totalRow);
					System.out.println("lastPage --- " + lastPage);
					System.out.println("currentPage --- " + currentPage);
					System.out.println("beginRow --- " + beginRow);
					System.out.println("start --- " + start);
					System.out.println("end --- " + end);
			   		
				%>
					<li class="page-item <%=preDisabled%>"><a class="page-link" href="./guestbook.jsp?currentPage=<%=1%>"><<</a></li>
					<li class="page-item <%=preDisabled%>"><a class="page-link" href="./guestbook.jsp?currentPage=<%=currentPage-1%>">Previous</a></li>
				<%		
					
					for (int i = start; i <= end; i++){
				%>	
					<li class="page-item"><a class="page-link" href="./guestbook.jsp?currentPage=<%=i%>"><%=i %></a></li>
				<%
						
					}
					
				%>
					<li class="page-item <%=nextDisabled%>"><a class="page-link" href="./guestbook.jsp?currentPage=<%=currentPage+1%>">Next</a></li>
					<li class="page-item <%=nextDisabled%>"><a class="page-link" href="./guestbook.jsp?currentPage=<%=lastPage%>">>></a></li>
		   		</ul>
		   </div>
        </div>
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
	guestbookRs.close();
	guestbookStmt.close();
	pageRs.close();
	pageStmt.close();
	conn.close();
%>







