<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<title>공지사항 수정</title>
<c:import url="${cp}/includes/includes_admin.jsp"></c:import>

<script type="text/javascript">
$(document).ready(function()
		{
			$("#btn_list").click(function()
			{
				
				if(confirm("목록으로 돌아가시겠습니까?"))
				{
					$(location).attr("href","noticemanager.action");
				}
			});
			
			$("#btn_submit").click(function()
			{
				
				$("#updateForm").submit();
			});
		});
</script>

</head>
<body id="page-top">
	<!-- Page Wrapper -->
	<div id="wrapper">
	<c:import url="${cp}/includes/Admin_Sidebar.jsp"></c:import>
		
		<!-- Content Wrapper -->
		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">
			<c:import url="${cp}/includes/header.jsp"></c:import>

				<!-- Begin Page Content -->
				<div class="container-fluid">

					<!-- 도움말 등록 폼 -->
					<div class="row">
						<!-- left column -->
						<div class="col-md-12">
							<!-- general form elements -->
							<div class="box box-primary">
								<div class="box-header">
									<h3 class="box-title">공지사항 수정하기</h3>
								</div>
								<br>

								<!-- /.box-header -->
								<form id='updateForm' role="form" action="noticeupdate.action" method="post" >
									<div class="box-body">
									<input type="hidden" value="${search.notice_code }" name="notice_code">
										<label for="exampleInputEmail1">중요도</label>
										<div class="form-group">
											<select class="form-control" id="mainCategory" name="important_notice_code"
												style="width: 30%; margin-right: 10px; display: inline-block;">
												<option value="default">전체</option>
												<option value="IN000002">일반공지</option>
												<option value="IN000001">중요공지</option>
											</select>
										</div><!-- end form-group -->

										
										<div class="form-group">
											<label for="exampleInputEmail1">제목</label> 
											<input type="text" id="help_title" name="notice_title" class="form-control" 
											value="${search.notice_title }">
										</div>


										<div class="form-group">
											<label for="exampleInputPassword1">글쓰기</label>
											<textarea class="form-control" id="notice_content" name="notice_content" rows="8" >
											${search.notice_content }
											</textarea>
										</div>

										<div class="form-group">
											<label for="exampleInputEmail1">Upload Image</label> 
											<input type="file" id="file1" name="file1" class="form-control" />
										</div>
										
									</div><!-- end box-body -->
								
								</form>
								</div>
								</div>
							</div>
							<!-- /.container-fluid -->
							
							<div class="box-footer">
                           <div>
                              <hr>
                           </div>

                           <ul class="mailbox-attachments clearfix uploadedList">
                           </ul>

                           <button id="btn_submit" type="button" class="btn btn-primary">수정하기</button>
                           <button id="btn_list" type="button" class="btn btn-primary" onclick="location.href='noticemanager.action'">목록으로</button>
                        </div>
                     
                  </div>

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



				<!-- 관리자 로그아웃 모달  -->
				<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog"
					aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLabel">로그아웃</h5>
								<button class="close" type="button" data-dismiss="modal"
									aria-label="Close" style="float: right;">
									<span aria-hidden="true" style="float: right;">×</span>
								</button>
							</div>
							<div class="modal-body">로그아웃 시 메인 페이지로 이동합니다.</div>
							<div class="modal-footer">
								<button class="btn btn-secondary" type="button"
									data-dismiss="modal">Cancel</button>
								<a class="btn btn-primary" href="adminlogout.action">Logout</a>
							</div>
						</div>
					</div>
				</div>
	
			<!-- 	<script>
				$(document).ready(function(){
			         
			         /* CkEditor 설정 */
			         // config.js 외 개별설정. JSON문법 스타일 사용한 설정 구문
			         var ckeditor_config = {
			            resize_enable: false,
			            enterMode: CKEDITOR.ENTER_BR,
			            shiftEnterMode: CKEDITOR.ENTER_P,
			            toolbarCanCollapse: true,
			            removePlugins : "elementspath", 
			            /* 파일 업로드 기능
			               CkEditor를 이용해 업로드 할 때 아래 주소에 업로드   
			            */
			            
			            
			         };
			         CKEDITOR.replace("pro_detail", ckeditor_config);
				</script> -->
</body>

</html>
