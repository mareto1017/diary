<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
	//로그인(인증) 분기
	// my_session이 ON일때 OFF으로 변경후 loginForm.jsp로 리다이렉트, OFF일땐 바로 loginForm.jsp로 리다이렉트
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
	
	String sql2 = "UPDATE login SET my_session = 'OFF', off_date = NOW();";
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	
	int row = 0;
	row = stmt2.executeUpdate();

	if(row == 1){
		response.sendRedirect("/diary/loginForm.jsp");
	}
	
	stmt2.close();
	conn.close();
%>