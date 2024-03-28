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
	System.out.println(lunchDate + " <-- deleteLunch param lunchDate");
	
	String sql2 = "delete from lunch where lunch_date = ?";
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, lunchDate);
	int row = 0;
	row = stmt2.executeUpdate();
	
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
	stmt2.close();
	conn.close();
	
%>