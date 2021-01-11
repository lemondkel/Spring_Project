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
<title>Lookation</title>
<c:import url="${cp}/includes/includes_admin.jsp"></c:import>
<style type="text/css">

	.bd-box
	{
	padding : 0.8em;
	font-size: 0.8em;
	}
	
	.div-table{
	display: table;
	width: 100%;
	}
	
	.div-table-body {
	display: table-row-group;
	}
	
	.div-table-header {
	padding: 30px;
    margin-bottom: 0;
    background-color: #f8f9fc;
    border-bottom: 1px solid #e3e6f0;
    color: #4e73df;
    height: 2em;
    font-weight: bold;
    font-size: 1.1em;
	}

	.div-row {
	display: table-row;
	}

	.div-col {
	display: table-cell;
	max-width: 150px;
	padding: 15px 8px 15px 8px;
	}
	
	
	.div-col-half {
	display: table-cell;
	padding: 3px;
	width: 50%;
	}
	
	.vertical-center{
	vertical-align: middle;
	}
	
	.cancel-reason{
	font-size: 1em;
	
	}
	
	
</style>
</head>
<body class="">
<!-- 회원 신고내역 확인하려고 할 경우 팝업 -->

	<div class="">
		<div class="row">
			<div class="col-md-12 px-4 pb-3 pt-4 mx-4 bd-box">
				<span class="ml-3">신고횟수 : </span>
				<span class="font-weight-bold text-primary">3회</span>
				<div class="float-right">
					<!-- 공간 예약코드 -->
					<span class="text-dark">회원코드 : U000001</span>
				</div>
				<!-- 이전 페이지(reservationList.jsp)에서 해당 예약에 대한 데이터 받아와야 함. -->
				<div class="div-table mt-4 card shadow">
					<div class="div-table-body">
						<div class="div-row div-table-header vertical-center">
							<div class="div-col">신고코드</div>
							<div class="div-col">신고유형</div>
							<div class="div-col">신고사유</div>
							<div class="div-col">신고일자</div>
						</div>
						<div class="div-row card-body">
							<!-- 예약신고시 BRP -->
							<!-- 공간신고시 LRP -->
							<div class="div-col">BRP00005</div>
							<div class="div-col">욕설</div>
							<div class="div-col">갑자기 저한테 욕했어요. 갑자기 저한테 욕했어요. 갑자기 저한테 욕했어요. 갑자기 저한테 욕했어요. 갑자기 저한테 욕했어요. 갑자기 저한테 욕했어요. 갑자기 저한테 욕했어요. 갑자</div>
							<div class="div-col">2020-12-28 19:17:16</div>
						</div>
						<div class="div-row">
							<div class="div-col">BRP00007</div>
							<div class="div-col">광고</div>
							<div class="div-col">광고</div>
							<div class="div-col">2020-12-29 07:14:14</div>
						</div>
						<div class="div-row">
							<div class="div-col">BRP00009</div>
							<div class="div-col">난리한바가지</div>
							<div class="div-col">악성 리뷰를 작성하였습니다.</div>
							<div class="div-col">2021-01-02 22:08:04</div>
						</div>
					</div> 
				</div><!-- End .div-table -->
			</div><!-- End .row -->
		<div class="button-group div-table mt-3 px-4">
		<div class="div-table-body">
			<div class="div-row">
				<div class="div-col"><button type="button" class="btn btn-secondary btn-block">닫기</button></div>
			</div>
		</div><!-- End .div-table-body-->
	</div><!-- End .div-table -->
	</div><!-- End .col-md-12  -->
		
		
		
</div>
</body>
</html>