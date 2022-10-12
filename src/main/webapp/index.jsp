<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<%
	if ( request.getParameter("errorMsg") != null) {
%>
		<span style="color: red;"><%=request.getParameter("errorMsg") %></span>
<%		
	}
%>
	
	<div class="container">
		<h1>index</h1>
		<hr/>
		<%
			if (session.getAttribute("loginId") == null) { // 로그인 전
		%>
		<form action="./loginAction.jsp" method="post">
			<fieldset>
				<legend>로그인</legend>
				<div class="form-group">
					<label for="id">ID</label>
					<input type="text" name="id" id="id" class="form-control" value="admin"/>
				</div>
				<div>
					<label for="pw">PW</label>
					<input type="password" name="pw" id="pw" class="form-control" value="1234"/>
				</div>
				<div class="text-right">
					<button type="submit" class="btn btn-primary">로그인</button>
				</div>
				<table class="table">
					<tr>
						<td><a href="./insertMemberForm.jsp" class="btn btn-info">회원가입</a></td>
					</tr>
				</table>
			</fieldset>
		</form>
		
		<%
			} else {
		%>
			<div class="container">
				<h2><%=session.getAttribute("loginId") %>님 반갑습니다.</h2> <!-- session은 Object 타입 -->
				<a href="./logout.jsp" class="btn btn-danger">로그아웃</a>
			</div>
		<%		
			}
		%>
		<table class="table">
			<tr>
				<td><a href="./boardList.jsp" class="btn btn-success">게시판</a></td>
			</tr>
			<tr>
				<td><a href="./guestbook.jsp" class="btn btn-warning">방명록</a></td>
			</tr>
		</table>
	</div>
		
		
</body>
</html>