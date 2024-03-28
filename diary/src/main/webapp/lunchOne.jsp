<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Calendar"%>
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
	
	String lunchDate = request.getParameter("lunchDate");
	//디버깅
	System.out.println(lunchDate + " <-- lunchOne param lunchDate");
	
	//lunchDate가 null일 경우 lunchDate에 오늘 날짜 넣어주기
	if(lunchDate == null){
		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String today = now.format(formatter);
		lunchDate = today;
	}
	String sql2 = "select menu from lunch where lunch_date = ?";
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, lunchDate);
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
	
	input[type = radio] {
		margin : 10px;
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
				<div style="margin-top: 40px; margin-left: 20px">
					<a class="text-white fs-6" href="/diary/logout.jsp">로그아웃</a>
				</div>
				
			</div>
		</div>
	</header>
	<div class="row">
		<div class="col"></div>
		<div class="mt-5 col-5 bg-white rounded">
			<form method="get" action="/diary/lunchOne.jsp">
				<div class="mt-3">
					<input type="date" name="lunchDate" value="<%=lunchDate %>">
					<button type="submit" class="btn" style="background-color: #A3C6C4">검색</button>
				</div>
			</form>
			
			<%
				if(rs2.next()){
			%>
					<div class="mt-4 text-center">
						<div><h1><%=lunchDate %> 의 점심 </h1></div>
						<div class="mt-5 mb-5"><h2><%=rs2.getString("menu") %></h2></div>
					</div>
			
			
			<div class="mb-4">
					<a href="/diary/deleteLunch.jsp?lunchDate=<%=lunchDate%>" class="mt-3 btn" style="background-color: #A3C6C4">삭제</a>
			</div>
			<%
				} else { // rs2.next()결과 값이 없으면 메뉴가 입력되지않은거. 그래서 메뉴 입력창을 띄움
			%>
					<form method="post" action="/diary/insertLunch.jsp">
						<input type="hidden" name="lunchDate" value="<%=lunchDate %>">
						<div class="mt-3" style="text-align: center;">
							<div><input type="radio" name="menu" value="한식">한식</div>
							<div><input type="radio" name="menu" value="일식">일식</div>
							<div><input type="radio" name="menu" value="중식">중식</div>
							<div><input type="radio" name="menu" value="양식">양식</div>
							<div><input type="radio" name="menu" value="기타">기타</div>
						</div>
						<button type="submit" class="mb-4 mt-3 btn" style="background-color: #A3C6C4">입력</button>
					</form>
			<%
				}
			%>
		</div>
		<div class="col"></div>
	</div>