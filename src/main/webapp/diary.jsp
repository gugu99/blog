<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="vo.*"%>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------diary");

	String locationNo = request.getParameter("locationNo");
	System.out.println("locationNo --- " + locationNo); // 디버깅

	// diary
	Calendar c = Calendar.getInstance();
	if (request.getParameter("y") != null && request.getParameter("m") != null) {
		int y = Integer.parseInt(request.getParameter("y")); // 연도
		int m = Integer.parseInt(request.getParameter("m")); // 월
		
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
		
		System.out.println("y --- " + y); // 디버깅
		System.out.println("m --- " + m); // 디버깅
	}
	
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
	
	String sql = "SELECT diary_no diaryNo, diary_date diaryDate, diary_todo diaryTodo FROM diary WHERE YEAR(diary_date) = ? AND MONTH(diary_date) = ? ORDER BY diary_date";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, c.get(Calendar.YEAR));
	stmt.setInt(2, c.get(Calendar.MONTH)+1);
	System.out.println("c.get(Calendar.YEAR) --- " + c.get(Calendar.YEAR)); // 디버깅
	System.out.println("c.get(Calendar.MONTH) --- " + c.get(Calendar.MONTH)); // 디버깅
	System.out.println("stmt --- " + stmt); // 디버깅
	
	rs = stmt.executeQuery();
	
	// 특수한 환경의 타입 diary테이블의 ResultSet -> ArrayList<Diary>
	ArrayList<Diary> list = new ArrayList<Diary>();
	Diary m = new Diary();
	
	while (rs.next()) {
		Diary d = new Diary();
		d.diaryNo = rs.getInt("diaryNo");
		d.diaryDate = rs.getString("diaryDate");
		d.diaryTodo = rs.getString("diaryTodo");
		list.add(d);
	}
	// System.out.println("list --- " + list); // 디버깅
	// db 자원 해제
	rs.close();
	stmt.close();
	
	PreparedStatement locationStmt = null;
	ResultSet locationRs = null;
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
<link rel="stylesheet" href="css/diary.css">
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
	        
	    <!-- Page content-->
        <div class="container-fluid">
        	<section class="ftco-section">
				<div class="container">
					<h4 class="text-center mb-4">
						<strong><a href="./diary.jsp?y=<%=c.get(Calendar.YEAR) %>&m=<%=c.get(Calendar.MONTH)-1 %>"><</a></strong>
						<%=m.months[c.get(Calendar.MONTH)] %> <%=c.get(Calendar.YEAR) %>
						<strong><a href="./diary.jsp?y=<%=c.get(Calendar.YEAR) %>&m=<%=c.get(Calendar.MONTH)+1 %>">></a></strong>
					</h4>
					<div class="table-wrap">
						<table class="table table-bordered">
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
											<%
												if (session.getAttribute("loginId") != null && (Integer)session.getAttribute("loginLevel") > 0) { // 관리자일 때 insertDiaryForm으로 이동 가능
											%>
												<a class="day" href="./insertDiaryForm.jsp?y=<%=c.get(Calendar.YEAR) %>&m=<%=c.get(Calendar.MONTH)+1 %>&d=<%=i-startBlank%>"><%=i-startBlank %></a>
											<%
												} else {
											%>
												<span class="day"><%=i-startBlank %></span>
											<%
												}
												for (Diary d: list) {
													if (Integer.parseInt(d.diaryDate.substring(8)) == i-startBlank) {
														if (session.getAttribute("loginId") != null) { // 로그인상태만  diaryOne으로 이동 가능
											%>
															<div>- <a class="todo" href="./diaryOne.jsp?diaryNo=<%=d.diaryNo%>&y=<%=c.get(Calendar.YEAR) %>&m=<%=c.get(Calendar.MONTH)+1 %>"><%=d.diaryTodo %></a></div>
											<%
														} else {
											%>
															<div>- <%=d.diaryTodo %></div>
											<%
														}
													}
												}
											%>
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
					</div>
				</div>
			</section>
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
	conn.close();
%>