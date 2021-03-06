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

<meta http-equiv="X-UA-Compatible" content="IE=edge">
<c:import url="${cp}/includes/includes_admin.jsp"></c:import>
<title>충전신청 관리</title>
<!-- <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>	※ 페이징처리 안됨.. 제이쿼리 → 자스 -->
<script type="text/javascript">

	function approval(val)
	{
		if(confirm("승인 처리 하시겠습니까?"))
		{
			location.href = "loadmgrapprove.action?regCode="+val;			
		}
	}
	function denial(val)
	{
		if(confirm("반려 처리 하시겠습니까?"))
		{
			location.href = "loadmgrdeny.action?regCode="+val;			
		}
	}
	/*
	$(document).ready(function()
	{
		// 승인 버튼 클릭 시
		$(".approval").click(function()
		{
			if(confirm("승인 처리 하시겠습니까?"))
			{
				$(location).attr("href", "loadmgrapprove.action?regCode=" + $(this).val());
			}
		});
		
		// 반려 버튼 클릭 시
		$(".denial").click(function()
		{
			if(confirm("반려 처리 하시겠습니까?"))
			{
				$(location).attr("href", "loadmgrdeny.action?regCode=" + $(this).val());	
			}
		});
	});
	 /*
	$(function()
	{
		$("#approval").click(function()
		{
			var chk = confirm("승인처리 하시겠습니까?");
			if(chk==false) return;
				
				$.post("loadmgrapprove.action"
					, {regCode : $(this).val()}
					, function(args)
					{
						alert("요청성공");
						location.reload();
					});
		});
	});

	$(function()
	{
		$("#denial").click(function()
		{
			var chk = confirm("반려처리 하시겠습니까?");
			if(chk==false) return;
			
			$.post("loadmgrdeny.action"
					, {regCode : $(this).val()}
					, function(args)
					{
						alert("요청성공");
						location.reload();
					});
		});
	});
	*/
</script>

</head>
<body id="page-top">

	<!-- Page Wrapper -->
	<div id="wrapper">

		<!-- Sidebar -->
		<div>
			<c:import url="${cp}/includes/Admin_Sidebar.jsp"></c:import>
		</div>
	
		<!-- Content Wrapper -->
		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">

				<!-- Topbar -->
				<!-- Header -->
				<c:import url="${cp }/includes/header.jsp"></c:import>
				
				<!-- Begin Page Content -->
				<div class="container-fluid">

					<!-- Page Heading -->
					<h1 class="h3 mb-2 text-gray-800">충전신청 관리</h1>
					<p class="mb-4">이용자 마일리지 충전신청 목록입니다.</p>

					<!-- DataTales Example -->
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">충전신청 리스트</h6>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered" id="dataTable" width="100%"	cellspacing="0">
									<thead>
										<tr align="center">
											<th>번호</th>
											<th>충전신청코드</th>
											<th>E-Mail</th>
											<th>계좌번호</th>
											<th>은행명</th>
											<th>예금주</th>
											<th>금액</th>
											<th>충전신청일</th>
											<th>처리상태</th>
											<th>처리일</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list }" varStatus="status">
										<tr>
											<td>${status.count}</td>
											<td>${item.regCode}</td>
											<td>${item.email}</td>
											<td>${item.bankNumber}</td>
											<td>${item.bank }</td>
											<td>${item.bankHolder }</td>
											<td>${item.amount }</td>
											<td>${item.regDate }</td>
											<c:choose>
												<c:when test="${item.loadType eq null}">
													<td>충전대기</td>
													<td>
														<button class="btn btn-primary mt-0 mb-0 approval" id="approval" name="approval" value="${item.regCode}" onclick="approval(this.value)">승인</button>
														<button class="btn btn-danger mt-0 mb-0 denial" id="denial" name="denial" value="${item.regCode}" onclick="denial(this.value)">반려</button>
													</td>
												</c:when>
												<c:when test="${not empty item.loadType}">
													<td>${item.loadType}</td>
													<td>${item.procDate}</td>
												</c:when>
											</c:choose>
										</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
					</div>

				</div>
				<!-- /.container-fluid -->

			</div>
			<!-- End of Main Content -->

			<!-- Footer -->
			<footer class="sticky-footer bg-white">
				<div class="container my-auto">
					<div class="copyright text-center my-auto">
						<span>Copyright &copy; Your Website 2020</span>
					</div>
				</div>
			</footer>
			<!-- End of Footer -->

		</div>
		<!-- End of Content Wrapper -->

	</div>
	<!-- End of Page Wrapper -->

	<!-- Scroll to Top Button-->
	<a class="scroll-to-top rounded" href="#page-top"> <i
		class="fas fa-angle-up"></i>
	</a>

	<!-- Logout Modal-->
	<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body">Select "Logout" below if you are ready
					to end your current session.</div>
				<div class="modal-footer">
					<button class="btn btn-secondary" type="button"
						data-dismiss="modal">Cancel</button>
					<a class="btn btn-primary" href="login.html">Logout</a>
				</div>
			</div>
		</div>
	</div>
</body>


</html>