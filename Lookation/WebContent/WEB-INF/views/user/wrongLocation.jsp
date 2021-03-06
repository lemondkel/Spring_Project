<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath();
	
	String identify = (String)request.getParameter("identify");
	pageContext.setAttribute("identify", identify);
	
	pageContext.setAttribute("path", cp);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<c:import url="${cp}/includes/includes_home.jsp"></c:import>
<c:import url="${cp}/includes/defaults.jsp"></c:import>
<title>잘못된 접근</title>

<style type="text/css">
	*
	{
		font-family : inherit;
		font-size: 15px;
	}
	
	.back-default 
	{
		background-color: #f6f6f6;
	}
	
	.head
	{
		text-align:center;
		padding-top: 5%;
		padding-bottom: 3%;
	}
	
	.container
	{
		padding: 150px 50px 100px;
		padding-top: 120px;
	}
	
	.confirmBox
	{
	    width: 900px;
	    
	    margin: 0 auto; 
		float: none;
		padding: 32px;
		text-align: center;
	}
	
	.buttonForm
	{
		width:70%;
		margin: 0 auto; 
		float: none;
	}
	
	button
	{
		border-style: ridge;
		border-width: thin;
		border-color: silver;
		font-size: 17px;
		font-weight: bold;
		background: #fdbe34;
		width:100%;
		height: 75px;
	}
	
	span
	{
		font-size: 100%;
		font-weight: bold;
	}
	
	p
	{
		font-size: 120%;
		font-weight: 500;
	}
	
</style>
</head>

<body class="back-default">

	<div class = "container">
		<div class = "confirmBox">
			
			<div class="dbox" style="margin-bottom: 30px;">
				<div class="icon d-flex align-items-center justify-content-center">
	                  <span class="fa fa-close" style="font-size:400%"></span>
	            </div>
            </div>
			<%-- <img src="<%=cp%>/images/check.png" style="width:15%;"/> --%>
			<h2><span>관리자에 의해 블라인드 되었거나 삭제된 공간입니다.</span></h2>
			<br>
			
			<p>다른 공간을 이용해주세요.</p> 
			<hr style="border: solid thin silver;
			           margin: 50px 0px 35px 0px;">
			
			<div class="buttonForm">
				<button style="float: center; "
				        onclick="location.href='membermain.action'">홈으로</button> 
			</div>
		</div>
	</div>

</body>
</html>