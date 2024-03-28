<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.net.URLEncoder"%>
<% 
	//로그인(인증) 분기

	String sql = "SELECT my_session mySession FROM login";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	ResultSet rs = null;
	rs = stmt.executeQuery();
	
	String mySession = null;
	
	if(rs.next()){
		mySession = rs.getString("mySession");
			
	}
	
	if(mySession.equals("OFF")){
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		//자원 반납
		rs.close();
		stmt.close();
		conn.close();
		return;
	}
	
	
	//if문 안걸릴 시 자원 반납
	rs.close();
	stmt.close();
	
	//요청값
	String diaryDate = request.getParameter("diaryDate");
	
	System.out.println(diaryDate + "<-- diaryOne param diaryDate");
	
	String sql2 = "select diary_date diaryDate, feeling, title, weather, content, update_date updateDate, create_date createDate from diary where diary_date = ?";
	
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, diaryDate);
	//디버깅
	System.out.println(stmt2);
	ResultSet rs2 = null;
	rs2 = stmt2.executeQuery();
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
		color: #000000;
	}
	
	header a:hover {
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
				</div>
			</div>
			<div class="col">
				<div style="margin-top: 40px; margin-left: 20px">
					<a class="text-white fs-6" href="/diary/logout.jsp">로그아웃</a>
				</div>
				
			</div>
		</div>
	</header>
	<div class="row">
		<div class="col"></div>
		<div class="mt-5 col-6 bg-white rounded">
			<h1 class="mt-4 text-center"><%=diaryDate %> Diary</h1>
	
			<%
				if(rs2.next()){	
					String feeling = rs2.getString("feeling");
					String title = rs2.getString("title");
					String weather = rs2.getString("weather");
					String content = rs2.getString("content");
					String updateDate = rs2.getString("updateDate");
					String createDate = rs2.getString("createDate");
					
			%>
				<table class="mt-4 table">
					<tr>
						<th>Title</th>
						<td><%=title %></td>
					</tr>
					<tr>
						<th>feeling</th>
						<td><%=feeling %></td>
					</tr>					
					<tr>
						<th>Weather</th>
						<td><%=weather %></td>
					</tr>
					<tr>
						<th>Content</th>
						<td><%=content %></td>
					</tr>
					<tr>
						<th>Update</th>
						<td><%=updateDate %></td>
					</tr>
					<tr>
						<th>Create</th>
						<td><%=createDate %></td>
					</tr>
				</table>
			<%
				}
				
				rs2.close();
				stmt2.close();
				conn.close();
			%>
				<div class="mb-4">
					<a href="/diary/updateDiaryForm.jsp?diaryDate=<%=diaryDate%>" class="mt-3 btn" style="background-color: #A3C6C4">수정</a>
					<a href="/diary/deleteDiary.jsp?diaryDate=<%=diaryDate%>" class="mt-3 btn" style="background-color: #A3C6C4">삭제</a>
				</div>
		</div>
		<div class="col"></div>
	</div>

</body>
</html>