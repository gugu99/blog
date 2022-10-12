<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//콘솔 구분선
	System.out.println("---------------------------------------boardList");
	
   String locationNo = request.getParameter("locationNo");
   System.out.println(locationNo+" <-- locationNo");
   
   String word = request.getParameter("word");
   System.out.println("word --- " + word);
   
   int currentPage = 1;
   if (request.getParameter("currentPage") != null) {
	   currentPage = Integer.parseInt(request.getParameter("currentPage"));
   }
   final int ROW_PER_PAGE = 10;
   int beginRow = (currentPage - 1) * ROW_PER_PAGE;

   Class.forName("org.mariadb.jdbc.Driver");
   String url = "jdbc:mariadb://localhost:3306/blog";
   String dbuser = "root";
   String dbpw = "1002";
   Connection conn = null;
   PreparedStatement locationStmt = null;
   ResultSet locationRs = null;
   conn = DriverManager.getConnection(url, dbuser, dbpw);
   
   // 메뉴 목록
   String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
   locationStmt = conn.prepareStatement(locationSql);
   locationRs = locationStmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BLOG</title>
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
	<h1>BLOG</h1>
	<div class="row">
	  <div class="col-sm-2">
	  <!-- left menu -->
		  	<div>
		      <ul>
		         <li><a href="./boardList.jsp">전체</a></li>
		         <%
		            while(locationRs.next()) {
		         %>
		               <li>
		                  <a href="./boardList.jsp?locationNo=<%=locationRs.getString("locationNo")%>">
		                     <%=locationRs.getString("locationName")%>
		                  </a>
		               </li>
		         <%      
		            }
		         %>   
		      </ul>
		   </div>
	  </div>
	  <div class="col-sm-10">
	  <!-- main -->
		  <%
		      // 게시글 목록
		      String boardSql = "";
		      PreparedStatement boardStmt = null;
		      if(locationNo == null) {
		    	  if (word == null){
		    		 boardSql = "SELECT l.location_name locationName, l.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b	ON l.location_no = b.location_no ORDER BY board_no DESC LIMIT ?,?";
			         boardStmt = conn.prepareStatement(boardSql);
			         boardStmt.setInt(1, beginRow);
			         boardStmt.setInt(2, ROW_PER_PAGE);
		    	  } else {
			    	  /* 
			    	  	SELECT 
			    	  		l.location_name locationName,
			    	  		l.location_no locationNo, 
			    	  		b.board_no boardNo, 
			    	  		b.board_title boardTitle 
			    	  	FROM location l INNER JOIN board b
			    	  	ON l.location_no = b.location_no
			    	  	ORDER BY board_no DESC
			    	  	limit ?,?
			    	  */
			    	 boardSql = "SELECT l.location_name locationName, l.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.board_title like ? ORDER BY board_no DESC LIMIT ?,?";
			         boardStmt = conn.prepareStatement(boardSql);
			         boardStmt.setString(1, "%"+word+"%");
			         boardStmt.setInt(2, beginRow);
			         boardStmt.setInt(3, ROW_PER_PAGE);
		    	  }
		      } else {
		    	  if (word == null){
		    		 boardSql = "SELECT l.location_name locationName, l.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b	ON l.location_no = b.location_no WHERE l.location_no = ? ORDER BY board_no DESC LIMIT ?,?";
			         boardStmt = conn.prepareStatement(boardSql);
			         boardStmt.setInt(1, Integer.parseInt(locationNo));
			         boardStmt.setInt(2, beginRow);
			         boardStmt.setInt(3, ROW_PER_PAGE);
		    	  } else {
		    	  /* 
		    	  	SELECT 
		    	  		l.location_name locationName,
		    	  		l.location_no locationNo, 
		    	  		b.board_no boardNo, 
		    	  		b.board_title boardTitle 
		    	  	FROM location l INNER JOIN board b
		    	  	ON l.location_no = b.location_no
    	  			WHERE l.location_no = ?
		    	  	ORDER BY board_no DESC
		    	  	limit ?,?
		    	  */
		    		  boardSql = "SELECT l.location_name locationName, l.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE l.location_no = ? and b.board_title like ? ORDER BY board_no DESC LIMIT ?,?";
			         boardStmt = conn.prepareStatement(boardSql);
			         boardStmt.setInt(1, Integer.parseInt(locationNo));
			         boardStmt.setString(2, "%"+word+"%");
			         boardStmt.setInt(3, beginRow);
			         boardStmt.setInt(4, ROW_PER_PAGE);
		    	  }
		      }
		      System.out.println("boardStmt --- " + boardStmt);
		      ResultSet boardRs = boardStmt.executeQuery();
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
		                  <td><%=boardRs.getString("boardTitle")%></td>
		               </tr>
		         <%      
		            }
		         %>
		      </tbody>
		   </table>
		   <!-- 검색 -->
		   <%
		   		int totalRow = 0;
		   		
		   %>
		   <form class="form-inline" action="./boardList.jsp" method="get">
		   		<%
		   			if (locationNo != null){
		   				
		   		
		   		%>
		   				<input type="hidden" name="locationNo" value="<%=locationNo %>" />
		   		<%
		   			}
		   		%>
		   		
               <label for="word">제목검색</label>
               <input type="text" class="form-control" id="word" name="word">
               <button type="submit" class="btn btn-primary">검색</button>
            </form>
		   <!-- 페이징 -->
		   <div>
		   		<ul class="pagination">
		   		<%	
			   		/* int lastPage = totalRow / ROW_PER_PAGE;
			   		if(totalRow % ROW_PER_PAGE != 0) {
			   			lastPage += 1;
			   		} */
			   		
					if (currentPage > 1){
						if (locationNo == null){
				%>
					
						<li class="page-item"><a class="page-link" href="./boardList.jsp?currentPage=<%=currentPage-1%>">Previous</a></li>
				<%		
						} else {
				%>
						<li class="page-item"><a class="page-link" href="./boardList.jsp?currentPage=<%=currentPage-1%>%locationNo=<%=locationNo%>">Previous</a></li>
				<%			
						}
					} else {
		   		%>
		   		<%	
					}
					/* if (currentPage < lastPage){ */
						if (locationNo == null){
				%>
						<li class="page-item"><a class="page-link" href="./boardList.jsp?currentPage=<%=currentPage+1%>">Next</a></li>
				<%		
						} else {
				%>
						<li class="page-item"><a class="page-link" href="./boardList.jsp?currentPage=<%=currentPage+1%>%locationNo=<%=locationNo%>">Next</a></li>
				<%			
						/* } */
					}
		   		%>
		   		</ul>
		   </div>
	  </div>
	</div>
</div>
</body>
</html>




