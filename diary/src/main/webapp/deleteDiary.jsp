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
	
	//디버깅
	System.out.println(diaryDate + " <-- addDiaryAction param diaryDate");
	String sql = "delete from diary where diary_date = ?";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	//디버깅
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	if(row == 1){
		// 삭제 성공
		System.out.println("삭제 성공");
		response.sendRedirect("/diary/diary.jsp");
	} else {
		// 삭제 실패
		System.out.println("수정 실패");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate);
	}
	
	stmt.close();
	conn.close();
%>