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
<%@ include file="../includes/includes_admin.jsp" %>
<title>userQna.jsp</title>

<style type="text/css">
	table 
	{
		text-align: center;
	}
	table tr td
	{
		text-overflow: ellipsis;
		overflow: hidden;
		white-space: nowrap;
		max-width: 300px;
	}

</style>

<script type="text/javascript">
	
	function popupOpen()
	{
		var popUrl = "qnaPopup.jsp";
		var popOption = "width=500, height=700, resizable=no, scrollbars=yes, status=no";
		window.open(popUrl, "", popOption);
	}
	
	function deleteReview()
	{
		confirm("해당 게시글을 삭제하시겠습니까?");
		/* if문으로 분기하여 true(=확인버튼)일 때 삭제할 수 있도록 변경 */
	}
	
	/* 체크박스 전체선택 전체 해제 */
	$(document).ready(function()
	{
		$("#allCheck").click(function()
		{
			//전체 선택 체크
			if($("#allCheck").prop("checked"))
			{
				// 해당화면 전체 checkbox 체크하는 구문
				$("input[type=checkbox]").prop("checked", true);
			}
			// 전체 선택 해제
			else
			{
				// 해당화면 전체 checkbox 체크 해제 하는 구문
				$("input[type=checkbox]").prop("checked", false);
			}
		});
	});
	
	/* 선택삭제 눌렀을 때 */
	$(document).ready(function()
	{
		$("#selectDelete").click(function()
		{
			/* 체크가 선택된 모든 리뷰 삭제 구문 */
			if($("input[type=checkbox]"))	// 체크가 되어있는 것들..근데 이게 맞나?
			{
				confirm("정말로 삭제하시겠습니까?");
				/* 분기하여 확인 누르면 다중삭제 되게 처리할 것 */
			}
		});
	});
        
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
					<%@ include file="../includes/header.jsp" %>

                 <!-- Begin Page Content -->
                <div class="container-fluid">

                    <!-- Page Heading -->
                    <h1 class="h3 mb-2 text-gray-800">Q&A조회</h1>
                    <p class="mb-4">온 QNA를 조회할 수 있읍니다.
                     검색을 통해 특정 이용자QNA를 조회할 수 있읍니다.</p>

                    <!-- DataTales Example -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Q&A</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0" >
                                    <thead>
                                    	<tr>
                                    		<th><input type="checkbox" id="allCheck">
                                    		<button type="button" id="selectDelete" class="btn">선택삭제</button></th>
                                    		<th>Q&A코드</th>
                                    		<th>닉네임</th>
                                    		<th>이메일</th>
                                    		<th>공간코드</th>
                                    		<th>Q&A내용</th>
                                    		<th>처리</th>
                                    	</tr>
                                    </thead>
                                    
                                    <tbody>
                                    	<tr>
                                    		<td><input type="checkbox"></td>
	                                    	<td>Q00005</td>
	                                    	<td>알 수 없음</td>
	                                    	<td>test5@test.com</td>
	                                    	<td>P05005</td>
	                                    	<td>★홍$대#카&지@노☆</td>
	                                    	<td>
												<button type="button" class="btn btn-primary" onclick="popupOpen()">상세보기</button>
												<button type="button" class="btn btn-danger" onclick="deleteReview()">삭제</button>
											</td>
                                    	</tr>
                                    	<tr>
                                    		<td><input type="checkbox"></td>
	                                    	<td>Q00004</td>
	                                    	<td>닉네임4</td>
	                                    	<td>test4@test.com</td>
	                                    	<td>P05005</td>
	                                    	<td>브라이덜 샤워할건데 혹시 가능한가요?</td>
	                                    	<td>
												<button type="button" class="btn btn-primary" onclick="popupOpen()">상세보기</button>
												<button type="button" class="btn btn-danger" onclick="deleteReview()">삭제</button>
											</td>
                                    	</tr>
                                    	<tr>
                                    		<td><input type="checkbox"></td>
	                                    	<td>Q00003</td>
	                                    	<td>닉네임3</td>
	                                    	<td>test3@test.com</td>
	                                    	<td>P03002</td>
	                                    	<td>코로난데 혹시 영업 계속 하시나요?</td>
	                                    	<td>
												<button type="button" class="btn btn-primary" onclick="popupOpen()">상세보기</button>
												<button type="button" class="btn btn-danger" onclick="deleteReview()">삭제</button>
											</td>
                                    	</tr>
                                    	<tr>
                                    		<td><input type="checkbox"></td>
	                                    	<td>Q00002</td>
	                                    	<td>닉네임2</td>
	                                    	<td>test2@test.com</td>
	                                    	<td>P05001</td>
	                                    	<td>이거 길어지면 ...처리 되는지 확인하려고 엄청 길게 써봅니다. 지금 붕어빵 먹고있는데 존 맛 탱 그자체
	                                    	커스터드 크림도 존맛이고 팥도 개개개개개존맛..;;이게 바로 소..확..행?ㅋ</td>
	                                    	<td>
												<button type="button" class="btn btn-primary" onclick="popupOpen()">상세보기</button>
												<button type="button" class="btn btn-danger" onclick="deleteReview()">삭제</button>
											</td>
                                    	</tr>
                                    	<tr>
                                    		<td><input type="checkbox"></td>
	                                    	<td>Q00001</td>
	                                    	<td>닉네임1</td>
	                                    	<td>test1@test.com</td>
	                                    	<td>P05003</td>
	                                    	<td>사진이 좀 흐릿해서 그러는데 뫄뫄 있는거 확실한가요?</td>
	                                    	<td>
												<button type="button" class="btn btn-primary" onclick="popupOpen()">상세보기</button>
												<button type="button" class="btn btn-danger" onclick="deleteReview()">삭제</button>
											</td>
                                    	</tr>
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
    <a class="scroll-to-top rounded" href="#page-top">
        <i class="fas fa-angle-up"></i>
    </a>

    <!-- Logout Modal-->
    <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
                    <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
                    <a class="btn btn-primary" href="login.html">Logout</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>