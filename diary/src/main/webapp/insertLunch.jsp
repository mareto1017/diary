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
	
	String lunchDate = request.getParameter("lunchDate");
	String menu = request.getParameter("menu");
	System.out.println(lunchDate + " <-- insertLunch param lunchDate");
	System.out.println(menu + " <-- insertLunch param menu");
	
	String sql2 = "INSERT INTO lunch (lunch_date, menu, update_date, create_date) VALUES(?, ?, NOW(), NOW());";
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, lunchDate);
	stmt2.setString(2, menu);
	int row = 0;
	row = stmt2.executeUpdate();
	
	if(row == 1){
		//입력 성공
		System.out.println("입력 성공");
		response.sendRedirect("/diary/lunchOne.jsp?lunchDate=" + lunchDate);
	} else {
		//입력 실패
		System.out.println("입력 실패");
		response.sendRedirect("/diary/lunchOne.jsp");
	}
	
	stmt2.close();
	conn.close();
	
%>