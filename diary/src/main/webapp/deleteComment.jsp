<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String diaryDate = request.getParameter("diaryDate");
	
	System.out.println(commentNo + "<-- deleteComment param commentNo");
	System.out.println(diaryDate + "<-- deleteComment param diaryDate");

	String sql = "DELETE FROM COMMENT WHERE comment_no = ? AND diary_date = ?;";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, commentNo);
	stmt.setString(2, diaryDate);
	
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	System.out.println(row + "<-- deleteCommentAction row");
	
	if(row == 0){
		System.out.println("댓글 삭제 실패");
	} else {
		System.out.println("댓글 삭제 성공");
	}
	
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate);
	
	stmt.close();
	conn.close();
	
%>