<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");

	String result = request.getParameter("result");
	String nick = request.getParameter("nick");
	
	pageContext.setAttribute("result", result);
	pageContext.setAttribute("nick", nick);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>header_user.jsp</title>

<%@ include file="../includes/includes_home.jsp"%>
<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	
<script type="text/javascript">
	/* 서브메뉴 애니메이션 */
	$(function()
	{
		$("ul.sub").hide();
		$("#menu li").hover(function()
		{
			//$("ul:not(:animated)",this).slideDown("fast");
		    $("ul:not(:animated)",this).fadeIn("fast");
		},
		function()
		{
			//$("ul",this).slideUp("fast");
			$("ul",this).fadeOut("fast");
		});
		
		$("a#sub").hover(function()
		{
		    $(this).css("color","#fdbe34");
		},
		function()
		{
			$(this).css("color","white");
		});
	});
	
	function logout()
	{
		if(confirm("정말 로그아웃 하시겠습니까?"))
		{
			alert("로그아웃 되었습니다.");
			location.href = "memberlogout.action";
		}
	}
	
	function search()
	{
		if($("#searchName").val() == "")
		{
			alert("검색어를 먼저 입력해주세요.");
			return;
		}
		
		$("#searchForm").submit();
	}
</script>

<style type="text/css">
/* 불릿 제거, 들여쓰기, 밑, 위 여유공간 */
ul.sub 
{
    width:130px;

	text-align: center;
	list-style: none;
	padding-left: 0px;
	padding-top: 10px;
	padding-bottom: 10px;
		
	position: absolute;
	display:none;
}

li.nav-item
{
	text-align: center;
    width:130px;
}

#menu 
{
	font-size: 14px;
	font-weight: 500;
	color: #fdbe34;
}

#menuWhite 
{
	font-size: 14px;
	font-weight: 500;
	color: #ffffff;
}

.back-default
{
	background: #f6f6f6;
}

.navbar
{
	margin-bottom: 0px;
}

a#sub
{
	color: white;
}
</style>

</head>

<body class="back-default">
	<div class="container pt-5">
		<div class="row justify-content-between">
			<!-- 좌상단 -->
			<div class="col">
				<!-- 로고 -->
				<a class="navbar-brand" href="membermain.action">Look<span>ation.</span></a>
			</div>
			<!-- 우상단 -->
			<div class="col d-flex justify-content-end">

				<!-- 검색 -->
				<div class="sidebar-box">
					<form action="searchkeyword.action" method="post" class="search-form" id="searchForm">
						<div class="form-group">
							<a href="javascript:search()"><span class="icon icon-search" style="font-size: 30px;"></span></a>
							<input type="text" id="searchName" name="searchName" class="form-control" placeholder="지역 또는 공간을 검색해보세요!" style="font-size: 20px;">
						</div>
					</form>
				</div>

			</div>
		</div>
	</div>

	<!-- 메뉴바 -->
	<nav
		class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light"
		id="ftco-navbar">
		<div class="container">
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#ftco-nav" aria-controls="ftco-nav"
				aria-expanded="false" aria-label="Toggle navigation">
				<span class="fa fa-bars"></span> Menu
			</button>

			<!-- 메뉴 -->
			<div class="collapse navbar-collapse" id="ftco-nav">
				<ul class="navbar-nav mr-auto" id="menu">
					<li class="nav-item"><a href="#" class="nav-link">바로가기</a>
						<ul class="sub navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light">
							<li><a href="search.action" class="nav-link" id="sub">선택검색</a></li>
						</ul></li>

					<li class="nav-item"><a href="#" class="nav-link">편의기능</a>
						<ul class="sub navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light">
							<li><a href="mypage.action?identify=member" class="nav-link" id="sub">마이페이지</a></li>
							<li><a href="mileagehistory.action?identify=member" class="nav-link" id="sub">마일리지 관리</a></li>
							<li><a href="booklist.action?identify=member" class="nav-link" id="sub">예약 리스트</a></li>
							<li><a href="userreviewlist.action" class="nav-link" id="sub">리뷰 관리</a></li>
							<li><a href="userqnalist.action" class="nav-link" id="sub">Q&amp;A관리</a></li>
						</ul></li>

					<li class="nav-item"><a href="#" class="nav-link">고객지원</a>
						<ul class="sub navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light">
							<li><a href="notice.action?identify=member" class="nav-link" id="sub">공지사항</a></li>
							<li><a href="help.action?identify=member" class="nav-link" id="sub">도움말</a></li>
						</ul></li>
				
				</ul>
			</div>

			<!-- 로그인 상태 -->
			<div class="align-self-start"
				style="padding-top: 1.8rem; padding-right: 40px;">
				<form action="#">
					<!-- 로그인 전 -->
					<c:if test="${result eq 'noSigned' }">
						<a id="menuWhite">로그인 하세요.</a>
						<a href="loginform.action?identify=member" id="menu">&emsp;로그인</a>
						<a href="signupform.action?identify=member" id="menu">&emsp;회원가입</a>
					</c:if>

					<!-- 로그인 후 -->
					<c:if test="${result eq 'signed' }">
						<a id="menuWhite"><span id="menu">${nick }</span>님 환영합니다.</a> 
						<a href="profile.action?identify=member" id="menu">&emsp;프로필</a> 
						<a href="javascript:logout()" id="menu">&emsp;로그아웃</a>
					</c:if>
				</form>
			</div>

		</div>
	</nav>
	<!-- END 메뉴바 -->

</body>
</html>