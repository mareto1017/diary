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
	
	String lunchDate = request.getParameter("lunchDate");
	System.out.println(lunchDate + " <-- deleteLunch param lunchDate");
	
	String sql = "delete from lunch where lunch_date = ?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, lunchDate);
	int row = 0;
	row = stmt.executeUpdate();
	
	if(row == 1){
		//삭제 성공
		System.out.println("삭제 성공");
		response.sendRedirect("/diary/lunchOne.jsp");
	} else {
		//삭제 실패
		System.out.println("삭제 실패");
		response.sendRedirect("/diary/lunchOne.jsp?lunchDate=" + lunchDate);
	}
	
	//자원반납
	stmt.close();
	conn.close();
	
%>