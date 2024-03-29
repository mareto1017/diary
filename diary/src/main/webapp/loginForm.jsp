<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	//로그인(인증) 분기
	String loginMember = (String)session.getAttribute("loginMember");
	System.out.println(loginMember + "<-- loginMember");
	if(loginMember != null){
		response.sendRedirect("/diary/diary.jsp");
		
		return;
			
	}
	
	// 요청값 받기
	String errMsg = request.getParameter("errMsg");
	
	//디버깅
	System.out.println(errMsg + " <-- loginForm param errMsg");
	

	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>loginForm</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
	@import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap");

	body {
		background-color: #E0E7E9;
		font-family: "Noto Sans KR", sans-serif;
	}

	header {
		height: 100px;
		background-color: #354649;
	}
	
	a {
		text-decoration: none;
	}
	
	a:hover {
		text-decoration: underline;
	}
	
</style>
</head>
<body class="container">
	<header>
		<div class="row">
			<div class="col">
				<h1 class="m-4 text-white">Diary</h1>
			</div>
			<div class="col-9">
				<div style="margin-top: 40px; margin-left: 20px">
					<a class="text-white fs-4 " href="/diary/diary.jsp">Calenar</a>
					<a class="ms-5 text-white fs-4 " href="/diary/diaryList.jsp">List</a>
					<a class="ms-5 text-white fs-4 " href="/diary/addDiaryForm.jsp">Write</a>
					<a class="ms-5 text-white fs-4 " href="/diary/lunchOne.jsp">Lunch</a>
					<a class="ms-5 text-white fs-4 " href="/diary/statsLunch.jsp">Stats</a>
				</div>
			</div>
			<div class="col">
			</div>
		</div>
	</header>
	<div class="row">
		<div class="col"></div>
		<div class="mt-5 col-4 bg-white rounded" style="height: 450px">
			<div class="mt-2">
				<%
					if(errMsg != null) {
				%>
						<%=errMsg %>
				<%
					} else {
				%>
						<div>&nbsp;</div>
				<%
					}
				%>
			</div>
			<h1 class="text-center mt-4">Login</h1>
			<form method="post" action="/diary/loginAction.jsp">
			  	<div class="ms-5 mb-3 mt-3 w-75">
			    	<label class="form-label">ID</label>
			    	<input type="text" class="form-control" name="memberId">
			  	</div>
			  	<div class="ms-5 mb-3 w-75">
			    	<label class="form-label">Password</label>
			    	<input type="password" class="form-control" name="memberPw">
			  	</div>
				<button type="submit" class="ms-5 mt-3 w-75 btn" style="background-color: #A3C6C4">로그인</button>
			</form>
				</div>
		<div class="col"></div>
	</div>
	
	
</body>
</html>