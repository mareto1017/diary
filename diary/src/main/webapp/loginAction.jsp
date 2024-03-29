<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%

	//로그인(인증) 분기
	String loginMember = (String)session.getAttribute("loginMember");
	System.out.println(loginMember + "<-- loginMember");
	if(loginMember != null){
		response.sendRedirect("/diary/diary.jsp");
		
		return;
			
	}
		
	
	// 요청값 받기
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//디버깅
	System.out.println(memberId + " <-- loginAction param memberId");
	System.out.println(memberPw + " <-- loginAction param memberPw");
	
	String sql = "SELECT member_id, member_pw FROM MEMBER WHERE member_id = ? AND member_pw = ?;";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	//디버깅
	System.out.println(stmt);
	ResultSet rs = null;
	rs = stmt.executeQuery();
	
	// id와 pw가 검색이 되면 diary로 리다이렉트, 안되면 loginForm으로 리다이렉트
	if(rs.next()){
		//로그인 성공
		System.out.println("로그인 성공");
		
		session.setAttribute("loginMember", rs.getString("member_id"));
		response.sendRedirect("/diary/diary.jsp");

	} else {
		//로그인 실패
		System.out.println("로그인 실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
	}
	
	//자원반납
	rs.close();
	stmt.close();
	conn.close();
	
%>