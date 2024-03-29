<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
	//session.removeAttribute("loginMember");
	session.invalidate(); // 세션 초기화
	response.sendRedirect("/diary/loginForm.jsp");
%>