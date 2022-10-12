<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Login-From</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/main.css">
</head>
<body>
	<div class="login-page">
	  <div class="form">
	    <form action="./insertMemberAction.jsp" method="post" class="register-form">
	      <fieldset>
	      	<legend>REGISTER</legend>
	      	<%
				if (request.getParameter("errorMsg") != null) {
			%>
				<div>
					<span style="color: red;"><%=request.getParameter("errorMsg") %></span>
				</div>
			<%
				}
			%>
	      	<label for="id">ID</label>
	      	<input id="id" type="text" name="id" placeholder="Enter Id"/>
	    	<label for="pw">PASSWORD</label>
		    <input id="pw" type="password" name="pw" placeholder="Enter Password"/>
	      	<button type="submit">create</button>
	      	<p class="message">Already registered? <a href="login.jsp">로그인</a></p>
	      </fieldset>
	    </form>
	  </div>
	</div>
</body>
</html>