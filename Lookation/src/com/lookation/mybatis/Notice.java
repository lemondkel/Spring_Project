package com.lookation.mybatis;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.lookation.dao.IHostAccountDAO;
import com.lookation.dao.IMemberAccountDAO;
import com.lookation.dao.INoticeDAO;

@Controller
public class Notice
{
	@Autowired
	private SqlSession sqlSession;
	
	//유저 측 공지사항 <<조회>>
	@RequestMapping(value="/actions/notice.action", method = RequestMethod.GET)
	public String U_noticeList(ModelMap model,HttpServletRequest request)
	{
		// 공통 측면 뷰일 경우 사용자가 누구인지 알기 위해 
		// identify를 GET 받아야한다.
		String identify = request.getParameter("identify");
	
		// 세션을 통한 로그인 확인                                                                    
		HttpSession session = request.getSession();
		String accountCode = (String)session.getAttribute(identify + "Code"); 
	
		// 로그인 확인을 기록하기 위함                  
		String result = "noSigned";                                                         
	
		// 회원 코드가 세션에 세팅되어 있다면                                                                                   
		if(accountCode != null)                                         
		{       
			// 다음 사이트 header에 이용자 정보를 보여줄 수 있게
		        // db에서 회원 정보를 받아 뷰에 데이터를 넘겨준다.
	
			// 이용자일 경우                                                                            
			if(identify.equals("member"))                                                   
			{                                                                               
				IMemberAccountDAO dao = sqlSession.getMapper(IMemberAccountDAO.class);	    
				model.addAttribute("info", dao.getInfo(accountCode));
	
				// 이용자측면 추가로 해야할 작업은 이 밑에 쓴다.
	
		                                                                                 
			}
			// 호스트일 경우
			else if(identify.equals("host"))                                                   
			{                                                                               
				IHostAccountDAO dao = sqlSession.getMapper(IHostAccountDAO.class);	    
				model.addAttribute("info", dao.getInfo(accountCode));
	
				// 호스트측면 추가로 해야할 작업은 이 밑에 쓴다.
	
	
		                                                  
			}
			// 로그인이 되었음을 기록한다.
		        result = "signed";                                                                                
		}
	
		// 로그인 여부 데이터를 뷰에 넘겨준다.                                                                                   
		model.addAttribute("result", result);                                               
	
	
		/*
		 * // ********* 만약 로그인기능이 사용되는 뷰페이지의 경우 이 코드를 추가한다. ********* // 로그인이 안되어 있다면
		 * if(result.equals("noSigned")) { // 로그인 창으로 이동한다. return
		 * "redirect:loginform.action?identify=" + identify; } //
		 * *****************************************************************************
		 * ****
		 * 
		 * // 뒤에 identify를 GET 해준다.
		 */	
		
		INoticeDAO dao = sqlSession.getMapper(INoticeDAO.class);
		
		model.addAttribute("U_noticeList", dao.U_noticeList());

		//String notice_code = request.getParameter("notice_code");
		
	
		//model.addAttribute("notice_code", notice_code);
		//System.out.println("여기는 조회중 : " + notice_code);
	
		
		return "/WEB-INF/views/common/notice.jsp?identify=" + identify;
		//return "/WEB-INF/views/common/notice.jsp";
	}
	
	// 공지사항 상세보기
	@RequestMapping(value = "/actions/noticedetail.action", method = RequestMethod.GET)
	public String U_ndetailList(String notice_code, ModelMap model)
	{
		INoticeDAO dao = sqlSession.getMapper(INoticeDAO.class);

		model.addAttribute("U_ndetailList", dao.U_ndetailList(notice_code));
		
		return "/WEB-INF/views/common/noticeDetail.jsp";
	}

}
