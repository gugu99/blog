<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("\n---------------------------------------boardList");
	
	String locationNo = request.getParameter("locationNo");
    System.out.println("locationNo --- " + locationNo); // 디버깅
   
    String word = request.getParameter("word");
    System.out.println("word --- " + word); // 디버깅
   
   // 파라미터 null 체크
   String locationNoNullCheck = (locationNo == null) ? "is not null" : "= "+ locationNo; //	locationNo null값 체크
   String wordNullCheck = (word == null) ? "is not null" : "like '%"+word+"%'"; // word null값 체크
   System.out.println("LocationNoNullCheck --- " + locationNoNullCheck); // 디버깅
   System.out.println("wordNullCheck --- " + wordNullCheck); // 디버깅
   
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
	                <!-- 검색 -->
				   	<form class="form-inline" action="./boardList.jsp" method="get">
				   		<%
				   			if (locationNo != null){
				   				
				   		
				   		%>
				   				<input type="hidden" name="locationNo" value="<%=locationNo %>" />
				   		<%
				   			}
				   		%>
				   		
		               <label for="word"></label>
		               <input type="text" class="form-control" id="word" name="word" placeholder="제목 검색">
		               <button type="submit" class="btn btn-primary">검색</button>
		            </form>
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
        	<!-- main -->
		  <%
		      // 게시글 목록
		      String boardSql = "";
		      PreparedStatement boardStmt = null;
		      
		      /* 
		      	SELECT l.location_name locationName, l.location_no locationNo, b.board_no boardNo, b.board_title boardTitle 
				FROM location l INNER JOIN board b 
				ON l.location_no = b.location_no 
				WHERE l.location_no = ? 
				and b.board_title like ? 
				ORDER BY board_no DESC 
				LIMIT ?,?";
		      */
		     boardSql = "SELECT l.location_name locationName, l.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE l.location_no "+ locationNoNullCheck +" and b.board_title "+ wordNullCheck +" ORDER BY board_no DESC LIMIT ?,?";
		     boardStmt = conn.prepareStatement(boardSql);
	         /* boardStmt.setString(1, LocationNoNullCheck);
	         boardStmt.setString(2, wordNullCheck); */
	         boardStmt.setInt(1, beginRow);
	         boardStmt.setInt(2, ROW_PER_PAGE);
		      
		      
		      System.out.println("boardStmt --- " + boardStmt); // 디버깅
		      ResultSet boardRs = boardStmt.executeQuery();
		   %>
		   <%
		   		if (session.getAttribute("loginLevel") != null && (Integer)(session.getAttribute("loginLevel")) > 0) {
		   	%>
		   			 <div class="text-right">
						<a class="btn btn-primary" href="./insertBoardForm.jsp">글쓰기</a>
				   </div>
		   	<%		
		   		}
		   %>
		   <table class="table table-hover table-striped">
		      <thead>
		         <tr>
		         	<th>locationName</th>
		            <th>boardNo</th>
		            <th>boardTitle</th>
		         </tr>
		      </thead>
		      <tbody>
		         <% 
		            while(boardRs.next()) {
		         %>
		               <tr>
		               	  <td><%=boardRs.getString("locationName")%></td>
		                  <td><%=boardRs.getInt("boardNo")%></td>
		                  <td>
		                  	<a href="./boardOne.jsp?boardNo=<%=boardRs.getInt("boardNo")%>">
		                  		<%=boardRs.getString("boardTitle")%>
		                  	</a>
		                  </td>
		               </tr>
		         <%      
		            }
		         %>
		      </tbody>
		   </table>

		   <!-- 페이징 -->
		   <%
		   		int totalRow = 0;
            	PreparedStatement pageStmt = null;
            	ResultSet pageRs = null;
            	String pageSql = "SELECT count(*) cnt FROM board WHERE board_title " + wordNullCheck + " AND location_no " + locationNoNullCheck;
            	pageStmt = conn.prepareStatement(pageSql);
            	pageRs = pageStmt.executeQuery();
            	
            	if(pageRs.next()){
            		totalRow = pageRs.getInt("cnt");
            	}
		   		System.out.println("pageStmt --- " + pageStmt);
		   		System.out.println("pageRs --- " + pageRs);
		   %>
		   <div class="text-center">
		   		<ul class="pagination justify-content-center">
		   		<%	
		   			String locationNoLinkNullCheck = (locationNo == null) ? "" : "&loactionNo="+locationNo; //	locationNo null값 체크
					String wordLinkNullCheck = (word == null) ? "" : "&word="+word; // word null값 체크
			   		
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
					<li class="page-item <%=preDisabled%>"><a class="page-link" href="./boardList.jsp?currentPage=<%=1+locationNoLinkNullCheck+wordLinkNullCheck%>"><<</a></li>
					<li class="page-item <%=preDisabled%>"><a class="page-link" href="./boardList.jsp?currentPage=<%=currentPage-1+locationNoLinkNullCheck+wordLinkNullCheck%>">Previous</a></li>
				<%		
					
					for (int i = start; i <= end; i++){
				%>	
					<li class="page-item"><a class="page-link" href="./boardList.jsp?currentPage=<%=i+locationNoLinkNullCheck+wordLinkNullCheck%>"><%=i %></a></li>
				<%
						
					}
					
				%>
					<li class="page-item <%=nextDisabled%>"><a class="page-link" href="./boardList.jsp?currentPage=<%=currentPage+1+locationNoLinkNullCheck+wordLinkNullCheck%>">Next</a></li>
					<li class="page-item <%=nextDisabled%>"><a class="page-link" href="./boardList.jsp?currentPage=<%=lastPage+locationNoLinkNullCheck+wordLinkNullCheck%>">>></a></li>
		   		</ul>
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
	//db 자원해제 
	locationRs.close();
	locationStmt.close();
	boardRs.close();
	boardStmt.close();
	pageRs.close();
	pageStmt.close();
	conn.close();
%>
