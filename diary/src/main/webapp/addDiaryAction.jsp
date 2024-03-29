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
	
	String diaryDate = request.getParameter("diaryDate");
	String feeling = request.getParameter("feeling");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	//디버깅
	System.out.println(diaryDate + " <-- addDiaryAction param diaryDate");
	System.out.println(feeling + " <-- addDiaryAction param feeling");
	System.out.println(title + " <-- addDiaryAction param title");
	System.out.println(weather + " <-- addDiaryAction param weather");
	System.out.println(content + " <-- addDiaryAction param content");
	
	String sql = "insert into diary (diary_date, feeling, title, weather, content, update_date, create_date) values (?, ?, ?, ?, ?, now(), now());";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, feeling);
	stmt.setString(3, title);
	stmt.setString(4, weather);
	stmt.setString(5, content);
	
	//디버깅
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	if(row == 1){
		// 입력 성공
		System.out.println("입력 성공");
		response.sendRedirect("/diary/diary.jsp");
	} else {
		// 입력 실패
		System.out.println("입력 실패");
		response.sendRedirect("/diary/addDiaryForm.jsp");
	}
	
	stmt.close();
	conn.close();
%>