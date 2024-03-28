<%@page import="java.util.Calendar"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="jakarta.websocket.Encoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
	//로그인(인증) 분기
	// diary.login.my_session => "OFF" 일땐 redirect("loginForm.jsp")
	
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
	
	//달력
	Calendar calendar = Calendar.getInstance();
	
	String calendarYear = request.getParameter("calendarYear");
	String calendarMonth = request.getParameter("calendarMonth");
	//디버깅
	System.out.println(calendarYear + "<-- calendarYear");
	System.out.println(calendarMonth + "<-- calendarMonth");
	
	if(calendarYear != null || calendarMonth != null){
		calendar.set(Calendar.YEAR, Integer.parseInt(calendarYear));
		calendar.set(Calendar.MONTH, Integer.parseInt(calendarMonth));
	}
	
	int year = calendar.get(Calendar.YEAR);
	int month = calendar.get(Calendar.MONTH);
	
	calendar.set(Calendar.DATE, 1);
	
	int yoNum = calendar.get(Calendar.DAY_OF_WEEK);
	//디버깅
	System.out.println(yoNum + " <-- yoNum");
	int startBlank = yoNum - 1;
	
	int lastDate = calendar.getActualMaximum(Calendar.DATE);	
	//디버깅
	System.out.println(lastDate + " <-- lastDate");
	
	int countDiv = startBlank + lastDate;
	
	String sql2 = "select diary_date diaryDate, day(diary_date) day, left(title, 5) title, feeling from diary where year(diary_date) = ? and month(diary_date) = ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, year);
	stmt2.setInt(2, month+1);
	//디버깅
	System.out.println(stmt2);
	
	ResultSet rs2 = null;
	rs2 = stmt2.executeQuery();
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>diary</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
	@import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap");
	
	
	.cell {
		background-color: #FFFFFF;
		float: left;
		width: 120px;
		height: 90px;
		border: 1px solid #F6F6F6;
		margin: 3px;
	}
	
	.sun {
		clear: both;
		color: #FF0000;
	}
	
	.satur {
		color: #0000FF;
	}
	
	.yo {
		background-color: #F6F6F6;
		float: left;
		width: 120px;
		height: 40px;
		margin: 3px;
		padding: 7px;
		border-radius: 2px;
		text-align: center;
	}
	a{
		text-decoration: none;
		color: #000000;
	}
	
	body {
		background-color: #E0E7E9;
		font-family: "Noto Sans KR", sans-serif;
	}

	header {
		height: 100px;
		background-color: #354649;
	}
	
	header a:hover {
		text-decoration: underline;
	}
	
	
	
</style>
	
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
		<div class="mt-4 col-9">
				<div class="mb-4 text-center">
					<h1>
						<a class="me-5" href="/diary/diary.jsp?calendarYear=<%=year %>&calendarMonth=<%=month-1 %>"><</a>
						<%=year %>년 <%=month+1 %>월
						<a class="ms-5" href="/diary/diary.jsp?calendarYear=<%=year %>&calendarMonth=<%=month+1 %>">></a>
					</h1>
				</div>
				
				
			<div class="ms-5">
				<div class="yo sun">일</div>
				<div class="yo">월</div>
				<div class="yo">화</div>
				<div class="yo">수</div>
				<div class="yo">목</div>
				<div class="yo">금</div>
				<div class="yo satur">토</div>
				
				<%
					for(int i=1; i<=countDiv; i=i+1) {
						
						if(i%7 == 1) {
				%>
							<div class="ps-2 cell sun">
				<%			
						} else if(i%7 == 0){
						
				%>
							<div class="ps-2 cell satur">
				<%
						}else {
				%>
							<div class="ps-2 cell">
				<%				
						}
								if(i-startBlank > 0) {
									
							%>
									<%=i-startBlank%>
							<%		
									
									while(rs2.next()){
										if(rs2.getInt("day") == i-startBlank){
							%>
											<div>
												<span><%=rs2.getString("feeling") %></span>
												<a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>'>
													<%=rs2.getString("title") %>...
												</a>
											</div>
							<%
											break;
										}
									}
									rs2.beforeFirst();
								} else {
							%>
									&nbsp;
							<%		
								}
							%>
						</div>
				<%		
					}
				%>
			</div>
		</div>
		<div class="col"></div>
	</div>
	<%
		//자원반납
		rs2.close();
		stmt2.close();
		conn.close();
	%>
</body>
</html>