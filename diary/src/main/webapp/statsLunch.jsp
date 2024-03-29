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
	
	String sql = "SELECT menu, COUNT(*) cnt FROM lunch GROUP BY menu;";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	ResultSet rs = null;
	rs = stmt.executeQuery();
	
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
		<div class="mt-5 col-4 bg-white rounded" style="text-align: center;">
			<%
					int maxHeight = 300;
					int totalCnt = 0;
					while(rs.next()){
						totalCnt += rs.getInt("cnt");
					}
			%>
			<h1 class="mt-4">Stats Lunch</h1>
			<div>
				전체 득표수 : <%=totalCnt %>
			</div>
			<table class="mt-4 mb-4" style="display: inline-block;">
				<tr>
					<%
					
						String[] c = {"#FF0000", "#FF5E00", "#FFE400", "#1DDB16", "#0054FF"};
					
						int i = 0;
						rs.beforeFirst();
						
						while(rs.next()){
							int h = maxHeight *  rs.getInt("cnt") / totalCnt;
					%>
							<td style="vertical-align: bottom">
								<div style="height: <%=h %>px; width: 40px; background-color: <%=c[i] %>; text-align: center;">
									<%=rs.getInt("cnt") %>
								</div>
							</td>	
					<%
							i++;
						}
					%>
				</tr>
				<tr>
					<%
						rs.beforeFirst();
						
						while(rs.next()){
					%>
							<td><%=rs.getString("menu") %></td>
					<%
						}
					%>
				</tr>
			</table>
		</div>
		<div class="col"></div>
	</div>
	<%
		//자원반납
		rs.close();
		stmt.close();
		conn.close();
	%>
</body>
</html>