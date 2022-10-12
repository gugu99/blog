<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------updateDiaryForm");

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
<link rel="stylesheet" href="css/diary.css">
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
		   	 System.out.println("diaryNo --- " + diaryNo); // 디버깅
		   	 
		   	 PreparedStatement diaryStmt = null;
		   	 ResultSet diaryRs = null;
		   	 String diarySql = "SELECT diary_no diaryNo, diary_date diaryDate, diary_todo diaryTodo, create_date FROM diary WHERE diary_no = ?";
		
		   	 diaryStmt = conn.prepareStatement(diarySql);
			 diaryStmt.setInt(1, diaryNo);
			 System.out.println("diaryStmt --- " + diaryStmt); // 디버깅
			
			 diaryRs = diaryStmt.executeQuery();
			 
			String diaryTodo = "";
    		 
 			 if (diaryRs.next()){
 				diaryTodo = diaryRs.getString("diaryTodo");
 				
 				System.out.println("diaryTodo --- " + diaryTodo); // 디버깅
 			 }
	    
			// diary
 			Calendar c = Calendar.getInstance();
			int y = Integer.parseInt(request.getParameter("y")); // 연도
			int m = Integer.parseInt(request.getParameter("m")); // 월
			int d = Integer.parseInt(request.getParameter("d")); // 월
			
			if (m == -1) { // 1월에서 이전버튼 눌렀을 때
				m = 11;
				y = y-1; // y -= 1; y--; --y;
			}
			
			if (m == 12) { // 12월에서 다음버튼 눌렀을 떄
				m = 0;
				y = y+1; // y+=1; y++; ++y;
			}
			
			c.set(Calendar.YEAR, y);
			c.set(Calendar.MONTH, m);
			c.set(Calendar.DATE, d);
			
			System.out.println("y --- " + y); // 디버깅
			System.out.println("m --- " + m); // 디버깅
			System.out.println("d --- " + d); // 디버깅
 			
 			int lastDay = c.getActualMaximum(Calendar.DATE);
 			System.out.println("lastDay --- " + lastDay); // 디버깅
 			
 			
 			// 출력하는 달의 1일의 날짜객체
 			Calendar first = Calendar.getInstance();
 			first.set(Calendar.YEAR, c.get(Calendar.YEAR));
 			first.set(Calendar.MONTH, c.get(Calendar.MONTH));
 			first.set(Calendar.DATE, 1);
 			
 			// 1일 전에 빈td의 개수, 일요일0,월1 토6 <- (1일의 요일값 - 1) 
 			// 일요일0,월1 토6 <- (1일의 요일값 - 1)
 			int startBlank = first.get(Calendar.DAY_OF_WEEK) -1;
 			System.out.println("first.get(Calendar.DAY_OF_WEEK) --- " + first.get(Calendar.DAY_OF_WEEK)); // 디버깅
 			
 			// 마지막날 이후에 빈 td 개수
 			int endBlank = 7 - (startBlank + lastDay)%7; 
 			if (endBlank == 7) {
 				endBlank = 0;
 			}
 			
 			System.out.println("startBlank --- " + startBlank); // 디버깅
 			System.out.println("endBlank --- " + endBlank); // 디버깅
 			
 			conn = DriverManager.getConnection(url, dbuser, dbpw);
 			System.out.println("c.get(Calendar.YEAR) --- " + c.get(Calendar.YEAR)); // 디버깅
 			System.out.println("c.get(Calendar.MONTH) --- " + c.get(Calendar.MONTH)); // 디버깅

 			Diary w = new Diary();
	 			
	    %>
		<!-- Page content-->
        <div class="container-fluid">
        	<div class="text-center">
				<a href="./updateDiaryForm.jsp?diaryNo=<%=diaryNo %>&y=<%=c.get(Calendar.YEAR) %>&m=<%=c.get(Calendar.MONTH)-1 %>&d=<%=d%>"><</a>
				<strong><%=w.months[c.get(Calendar.MONTH)] %> <%=c.get(Calendar.YEAR) %></strong>
				<a href="./updateDiaryForm.jsp?diaryNo=<%=diaryNo %>&y=<%=c.get(Calendar.YEAR) %>&m=<%=c.get(Calendar.MONTH)+1 %>&d=<%=d%>">></a>
			</div>
			
			<table class="table text-center">
             <thead>
               <tr class="week">
				 <th class="sunday">Sunday</th>
                 <th>Monday</th>
                 <th>Tuesday</th>
                 <th>Wednesday</th>
                 <th>Thursday</th>
                 <th>Friday</th>
                 <th class="saturday">Saturday</th>
               </tr>
             </thead>
			<tbody>
				<tr>
				<%
					for (int i = 1; i <= startBlank+lastDay+endBlank; i++) {
						if ( i - startBlank < 1) {
				%>
							<td>&nbsp;</td>
				<%
						} else if (i - startBlank > lastDay) {
				%>
							<td>&nbsp;</td>
				<%			
						} else {
				%>
							<td>
								<a href="./updateDiaryForm.jsp?diaryNo=<%=diaryNo %>&y=<%=c.get(Calendar.YEAR) %>&m=<%=c.get(Calendar.MONTH) %>&d=<%=i-startBlank%>"><%=i-startBlank %></a>
							</td>
				<%		
						}
						if (i % 7 == 0) {
				%>
							</tr><tr>
				<%		
						}
					}
				%>
			</tbody>
		</table>
        	<form action="./updateDiaryAction.jsp" method="post">
				<fieldset>
					<legend>일정 수정</legend>
					<input type="hidden" name="diaryNo" value="<%=diaryNo%>"/>
					<div class="form-group">
						<label for="commentContent">연</label>
						<input class="form-control" type="text" name="y" value="<%=y %>" readonly/>
					</div>
					<div class="form-group">
						<label for="m">월</label>
						<input class="form-control" type="text" name="m" value="<%=m+1 %>" readonly/>
					</div>
					<label for="d">일</label>
					<input class="form-control" type="text" name="d" value="<%=d %>" readonly/>
					<div class="diaryTodo">
						<label for="d">할일</label>
						<textarea rows="2" cols="50" class="form-control" id="diaryTodo" name="diaryTodo"><%=diaryTodo %></textarea>
					</div>
					<div class="form-group text-right">
						<button type="submit" class="btn btn-primary">수정</button>
						<a class="btn btn-danger" href="diary.jsp">취소</a>
					</div>
				</fieldset>
			</form>
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
	// db 자원해제
	locationRs.close();
	locationStmt.close();
	diaryRs.close();
	diaryStmt.close();
	conn.close();
%>