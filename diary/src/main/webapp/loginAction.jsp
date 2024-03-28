<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
	//로그인(인증) 분기
	// diary.login.my_session => "ON" 일땐 redirect("diary.jsp")
	
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
	
	if(mySession.equals("ON")){
		response.sendRedirect("/diary/diary.jsp");
		
		//자원 반납
		rs.close();
		stmt.close();
		conn.close();
		
		return;
	}
	
	
	//if문 안걸릴 시 자원 반납
	rs.close();
	stmt.close();
	
	// 요청값 받기
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//디버깅
	System.out.println(memberId + " <-- loginAction param memberId");
	System.out.println(memberPw + " <-- loginAction param memberPw");
	
	String sql2 = "SELECT member_id, member_pw FROM MEMBER WHERE member_id = ? AND member_pw = ?;";
	
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	//디버깅
	System.out.println(stmt2);
	ResultSet rs2 = null;
	rs2 = stmt2.executeQuery();
	
	// id와 pw가 검색이 되면 diary로 리다이렉트, 안되면 loginForm으로 리다이렉트
	if(rs2.next()){
		//로그인성공
		//db의 mySession값을 ON으로 변경
		String sql3 = "UPDATE login SET my_session = 'ON', on_date = NOW();";
		PreparedStatement stmt3 = null;
		stmt3 = conn.prepareStatement(sql3);
		int row = 0;
		row = stmt3.executeUpdate();
		if(row == 1){
			System.out.println("로그인 성공");
			response.sendRedirect("/diary/diary.jsp");
		} else {
			System.out.println("로그인 실패");
			response.sendRedirect("/diary/loginForm.jsp");
		}
		
		//자원반납
		stmt3.close();
	} else {
		//로그인 실패
		System.out.println("로그인 실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
	}
	
	//자원반납
	rs2.close();
	stmt2.close();
	conn.close();
%>