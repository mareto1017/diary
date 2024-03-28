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
	
	String feeling = request.getParameter("feeling");
	String diaryDate = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	//디버깅
	System.out.println(feeling + " <-- addDiaryAction param feeling");
	System.out.println(diaryDate + " <-- addDiaryAction param diaryDate");
	System.out.println(title + " <-- addDiaryAction param title");
	System.out.println(weather + " <-- addDiaryAction param weather");
	System.out.println(content + " <-- addDiaryAction param content");
	
	String sql2 = "update diary set feeling = ?, title = ?, weather = ?, content = ?, update_date = now() where diary_date = ?";
	
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, feeling);
	stmt2.setString(2, title);
	stmt2.setString(3, weather);
	stmt2.setString(4, content);
	stmt2.setString(5, diaryDate);
	//디버깅
	System.out.println(stmt2);
	
	int row = 0;
	row = stmt2.executeUpdate();
	
	if(row == 1){
		// 수정 성공
		System.out.println("수정 성공");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate);
	} else {
		// 수정 실패
		System.out.println("수정 실패");
		response.sendRedirect("/diary/updateDiaryForm.jsp?diaryDate=" + diaryDate);
	}
	
	stmt2.close();
	conn.close();
%>