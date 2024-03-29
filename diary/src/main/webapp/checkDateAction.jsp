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
	
	
	String checkDate = request.getParameter("checkDate");
	
	//디버깅
	System.out.println(checkDate + " <--checkDateAction param checkDate");
	
	String sql = "select diary_date diaryDate from diary where diary_date = ?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	ResultSet rs = null;
	stmt.setString(1, checkDate);
	rs = stmt.executeQuery();
	
	//결과가 있으면 입력 x
	if(rs.next()){
		// 해당 날짜에 일기 있음
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate=" + checkDate + "&ck=F");
	} else {
		// 해당 날짜에 일기 없음
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate=" + checkDate + "&ck=T");
	}
	
	stmt.close();
	rs.close();
	
	conn.close();
	
%>