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
	
	String sql2 = "insert into diary (diary_date, feeling, title, weather, content, update_date, create_date) values (?, ?, ?, ?, ?, now(), now());";
	
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, diaryDate);
	stmt2.setString(2, feeling);
	stmt2.setString(3, title);
	stmt2.setString(4, weather);
	stmt2.setString(5, content);
	
	//디버깅
	System.out.println(stmt2);
	
	int row = 0;
	row = stmt2.executeUpdate();
	
	if(row == 1){
		// 입력 성공
		System.out.println("입력 성공");
		response.sendRedirect("/diary/diary.jsp");
	} else {
		// 입력 실패
		System.out.println("입력 실패");
		response.sendRedirect("/diary/addDiaryForm.jsp");
	}
	
	stmt2.close();
	conn.close();
%>