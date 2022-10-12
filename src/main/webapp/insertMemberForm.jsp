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
<div class="container">
	<h1>회원가입</h1>
	<%
		if (request.getParameter("errorMsg") != null) {
	%>
			<span style="color: red;"><%=request.getParameter("errorMsg") %></span>
	<%
		}
	%>
	<%
		if (session.getAttribute("loginId") == null) {
	%>
	
	<form action="./insertMemberAction.jsp" method="post">
		<fieldset>
			<legend>회원가입</legend>
			<div class="form-group">
				<label for="id">ID</label>
				<input type="text" name="id" id="id" class="form-control"/>
			</div>
			<div>
				<label for="pw">PW</label>
				<input type="password" name="pw" id="pw" class="form-control"/>
			</div>
			<div class="text-right">
				<button type="submit" class="btn btn-primary">회원가입</button>
			</div>
		</fieldset>
	</form>
</div>
	<%
		}
	%>
</body>
</html>