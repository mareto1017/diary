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
	String memo = request.getParameter("memo");
	
	//디버깅
	System.out.println(diaryDate + " <-- insertComment param diaryDate");
	System.out.println(memo + " <-- insertComment param memo");

	
	String sql = "insert into comment (diary_date, memo, update_date, create_date) values (?, ?, now(), now());";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, memo);
	
	//디버깅
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	if(row == 1){
		// 입력 성공
		System.out.println("입력 성공");
	} else {
		// 입력 실패
		System.out.println("입력 실패");
	}
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate);
	
	stmt.close();
	conn.close();
%>