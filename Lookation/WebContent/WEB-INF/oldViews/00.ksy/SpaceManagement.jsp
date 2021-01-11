<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>SpaceManagement.jsp</title>

<style>
	
	div.container  p
	{
		color: #fdbe34;
		font-weight: bold;
	}

</style>

<!-- css 등 공통적으로 들어가는 요소 include -->
<c:import url="${cp }/includes/includes_home.jsp"></c:import>

</head>
<body>
	
	<!-- 경로변경 필요 -->
	<!-- Lookation 로고 및 메뉴 include -->
	<!-- 분기 필요 -->
	<div>
		<c:import url="${cp}/includes/header_user.jsp"></c:import>
	</div>
		
	<div>
		<c:import url="${cp}/includes/header_host.jsp"></c:import>
	</div>
	
	
	<section class="hero-wrap hero-wrap-2"
		style="background-image: url('images/bg_3.jpg');"
		data-stellar-background-ratio="0.5">
		<div class="overlay"></div>
		<div class="container">
			<div class="row no-gutters slider-text align-items-end">
				<div class="col-md-9 ftco-animate pb-5">
					<p class="breadcrumbs mb-2">
						<span class="mr-2"><a href="index.html">Services
						<i class="ion-ios-arrow-forward"></i></a></span>
					</p>
					<h1 class="mb-0 bread">공간관리정책</h1>
				</div>
			</div>
		</div>
	</section>

	<!-- 정책 본문 -->
	<div class="container" style="margin: 10% 10% 10% 10%;">
		<div>
			본 정책은 Lookation 회원 이용약관에 따라 작성되었으며 본 정책에서
			사용되는 용어의 정의는 Lookation 회원 이용약관과 동일하다.
		</div>
		<br>
		<div>
			<p>와 이건 어케 써야할지 모르겠다 ㅠㅠㅠ</p>
			
		</div>
		
		후략...
		
	</div>
	
	<!-- 분기 필요 -->
	<div>
		<c:import url="${cp}/includes/footer_user.jsp"></c:import>
	</div>
	
	<div>
		<c:import url="${cp}/includes/footer_host.jsp"></c:import>
	</div>
	
	
	<!-- 자바스크립트 include -->
	<c:import url="${cp }/includes/includes_home_end.jsp"></c:import>

</body>
</html>