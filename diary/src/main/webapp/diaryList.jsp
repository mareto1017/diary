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
	String search = request.getParameter("search");
	System.out.println(search + "<-- diaryList param search");
	
	if(search == null){
		search = "";
	}
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	//if(request.getParameter("rowPerPage") != null){
	//	rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	//}
	
	String sql2 = null;
	int startRow = (currentPage-1) * rowPerPage;
	sql2 = "select diary_date diaryDate, title from diary where title like ? order by diary_date desc limit ?, ?";
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, "%" + search + "%");
	stmt2.setInt(2, startRow);
	stmt2.setInt(3, rowPerPage);
	//디버깅
	System.out.println(stmt2);
	ResultSet rs2 = null;
	rs2 = stmt2.executeQuery();
	
	String sql3 = "select count(*) cnt from diary where title like ?";
	PreparedStatement stmt3 = null;
	stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1, "%" + search + "%");
	System.out.println(stmt3);
	ResultSet rs3 = null;
	rs3 = stmt3.executeQuery();
	
	int count = 0;
	if(rs3.next()){
		 count = rs3.getInt("cnt");
	}
	
	int lastPage = 0;
	if(count % rowPerPage == 0){
    	lastPage = count / rowPerPage;
	} else {
		lastPage = count / rowPerPage + 1;
	}
	
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
		<div class="mt-5 col-7 bg-white rounded">
			<h1 class="mt-4 text-center">Diary List</h1>
			<table class="mt-4 mb-4 table table-hover">
				<tr>
						<th>날짜</th>
						<th>제목</th>
				</tr>
				<%
					while(rs2.next()){
						String diaryDate = rs2.getString("diaryDate");
						String title = rs2.getString("title");				
				%>
						<tr class="mb-3">
							<td><%=diaryDate %></td>
							<td><a href="/diary/diaryOne.jsp?diaryDate=<%=diaryDate %>"><%=title%></a></td>
						</tr>
				<%
					}
				%>
			</table>
			<ul class="mb-4 pagination justify-content-center">
				<%
					if(currentPage > 1 && currentPage < lastPage){
				%>
						
						  	<li class="page-item"><a class="page-link" href="/diary/diaryList.jsp?currentPage=1">처음</a></li>
						  	<li class="page-item"><a class="page-link" href="/diary/diaryList.jsp?currentPage=<%=currentPage - 1 %>">이전</a></li>
						  	<li class="page-item"><a class="page-link" href="/diary/diaryList.jsp?currentPage=<%=currentPage + 1 %>">다음</a></li>
						  	<li class="page-item"><a class="page-link" href="/diary/diaryList.jsp?currentPage=<%=lastPage %>">마지막</a></li>
				<%
					} else if(currentPage == 1){
				%>
							<li class="page-item disabled"><a class="page-link" href="/diary/diaryList.jsp?currentPage=1">처음</a></li>
						  	<li class="page-item disabled"><a class="page-link" href="/diary/diaryList.jsp?currentPage=<%=currentPage - 1 %>">이전</a></li>
						  	<li class="page-item"><a class="page-link" href="/diary/diaryList.jsp?currentPage=<%=currentPage + 1 %>">다음</a></li>
						  	<li class="page-item"><a class="page-link" href="/diary/diaryList.jsp?currentPage=<%=lastPage %>">마지막</a></li>
				<%
					} else {
				%>
						  	<li class="page-item"><a class="page-link" href="/diary/diaryList.jsp?currentPage=1">처음</a></li>
						  	<li class="page-item"><a class="page-link" href="/diary/diaryList.jsp?currentPage=<%=currentPage - 1 %>">이전</a></li>
						  	<li class="page-item disabled"><a class="page-link" href="/diary/diaryList.jsp?currentPage=<%=currentPage + 1 %>">다음</a></li>
						  	<li class="page-item disabled"><a class="page-link" href="/diary/diaryList.jsp?currentPage=<%=lastPage %>">마지막</a></li>
				<%
					}
				%>
			</ul>
			<form method="get" action="/diary/diaryList.jsp">
				<div class="input-group w-50 mb-4">
						<input type="text" class="form-control " name="search">
						<button type="submit" class="ms-3 btn rounded" style="background-color: #A3C6C4">검색</button>
				</div>
			</form>
		</div>
		<div class="col"></div>
	</div>
	<%
		//자원반납
		rs2.close();
		stmt2.close();
		rs3.close();
		stmt3.close();
		conn.close();
	%>
</body>
</html>