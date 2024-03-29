<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.net.URLEncoder"%>
<% 
	//로그인(인증) 분기
	String loginMember = (String)session.getAttribute("loginMember");
	System.out.println(loginMember + "<-- loginMember");
	if(loginMember == null){
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		
		return;
			
	}
	
	//요청값
	String diaryDate = request.getParameter("diaryDate");
	
	System.out.println(diaryDate + "<-- diaryOne param diaryDate");
	
	String sql = "select diary_date diaryDate, feeling, title, weather, content, update_date updateDate, create_date createDate from diary where diary_date = ?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	//디버깅
	System.out.println(stmt);
	ResultSet rs = null;
	rs = stmt.executeQuery();
	
	String sql2 = "select comment_no commentNo, memo, create_date createDate from comment where diary_date = ?";
	
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
		<div class="mt-5 col-6 bg-white rounded">
			<h1 class="mt-4 text-center"><%=diaryDate %> Diary</h1>
	
			<%
				if(rs.next()){	
					String feeling = rs.getString("feeling");
					String title = rs.getString("title");
					String weather = rs.getString("weather");
					String content = rs.getString("content");
					String updateDate = rs.getString("updateDate");
					String createDate = rs.getString("createDate");
					
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
				
							%>
				<div class="mb-4">
					<a href="/diary/updateDiaryForm.jsp?diaryDate=<%=diaryDate%>" class="mt-3 btn" style="background-color: #A3C6C4">수정</a>
					<a href="/diary/deleteDiary.jsp?diaryDate=<%=diaryDate%>" class="mt-3 btn" style="background-color: #A3C6C4">삭제</a>
				</div>
				
				<!-- 댓글 작성 form -->
				<div class="mt-3 fs-4">댓글</div>
				<form method="post" action="/diary/insertComment.jsp">
					<input type="hidden" name="diaryDate" value="<%=diaryDate %>" >
					<div class="input-group">
						<textarea rows="3" class="m-2 form-control" name="memo"></textarea>
					</div>
					<button type="submit" class="ms-2 mt-3 btn" style="background-color: #A3C6C4">댓글 입력</button>
				</form>
				
				<hr>
				
					<!-- 댓글 목록 -->
			<%
				while(rs2.next()){
			%>
					
					<div>
						<div>
							<%=rs2.getString("memo") %>
						</div>
						<div class="position-relative">
							<a href="/diary/deleteComment.jsp?commentNo=<%=rs2.getInt("commentNo") %>&diaryDate=<%=diaryDate%>" class="btn-close position-absolute top-50 end-0 translate-middle-y me-3" aria-label="Close"></a>
						</div>
					</div>
					<div><%=rs2.getString("createDate") %></div>
					<hr>
			<%
				}
			%>
					
		</div>
		<div class="col"></div>
	</div>
	<%
		rs.close();
		stmt.close();
		rs2.close();
		stmt2.close();
		conn.close();
	
	%>

</body>
</html>