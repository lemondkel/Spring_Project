<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>mypage_Sidebar.jsp(host)</title>
</head>
<body>

	<div class="col-lg-2 sidebar pl-lg-5 ftco-animate">
		<div class="sidebar-box ftco-animate">
			<div class="categories back-default">
				<h3><a href="mypage.action?identify=host">마이페이지</a></h3><hr>
				<li><a href="profile.action?identify=host">프로필 관리 <span
						class="ion-ios-arrow-forward"></span></a></li>
				<li><a href="bankinfomanage.action?identify=host">계좌 관리 <span
						class="ion-ios-arrow-forward"></span></a></li>
				<li><a href="booklisthost.action">예약 리스트 <span
						class="ion-ios-arrow-forward"></span></a></li>
				<li><a href="loadandexchange.action?identify=host">환전
						신청 <span class="ion-ios-arrow-forward"></span>
				</a></li>
				<li><a href="mileagehistory.action?identify=host">마일리지 내역 <span
						class="ion-ios-arrow-forward"></span></a></li>
				<li><a href="locationlist.action">공간 관리 <span
						class="ion-ios-arrow-forward"></span></a></li>
			</div>
		</div>
	</div>

</body>
</html>