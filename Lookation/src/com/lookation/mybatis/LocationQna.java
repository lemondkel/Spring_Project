package com.lookation.mybatis;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.lookation.dao.IHostAccountDAO;
import com.lookation.dao.ILocationQnaDAO;
import com.lookation.dao.IMemberAccountDAO;
import com.lookation.dto.LocationQnaDTO;

@Controller
public class LocationQna
{
	@Autowired
	private SqlSession sqlSession;

	// QnA 작성 팝업으로 이동
	@RequestMapping(value = "/actions/writeqna.action", method = RequestMethod.GET)
	public String QnaForm(Model model, HttpServletRequest request)
	{
		String loc_code = request.getParameter("loc_code");
		String identify = request.getParameter("identify");

		// 세션을 통한 로그인 확인
		HttpSession session = request.getSession();
		String accountCode = (String) session.getAttribute(identify + "Code");

		// 로그인 확인을 기록하기 위함
		String result = "noSigned";

		// 회원 코드가 세션에 세팅되어 있다면
		if (accountCode != null)
		{
			// 이용자일 경우
			if (identify.equals("member"))
			{
				IMemberAccountDAO dao = sqlSession.getMapper(IMemberAccountDAO.class);
				model.addAttribute("info", dao.getInfo(accountCode));
				String member_code = request.getParameter("member_code");
				model.addAttribute("member_code", member_code);

			}
			// 호스트일 경우
			else if (identify.equals("host"))
			{
				IHostAccountDAO dao = sqlSession.getMapper(IHostAccountDAO.class);
				model.addAttribute("info", dao.getInfo(accountCode));
				String hostCode = request.getParameter("host_code");
				model.addAttribute("host_code", hostCode);
			}
			// 로그인이 되었음을 기록한다.
			result = "signed";
		}
		model.addAttribute("result", result);
		model.addAttribute("accountCode", accountCode);

		if (result.equals("noSigned"))
		{
			return "redirect:loginform.action?identify=" + identify;
		}

		model.addAttribute("loc_code", loc_code);

		return "../WEB-INF/views/common/writeQnaPopup.jsp?identify=" + identify;
	}

	// QnA 수정 팝업으로 이동
	@RequestMapping(value = "/actions/modifyformqna.action", method = RequestMethod.GET)
	public String modifyFormQna(Model model, HttpServletRequest request)
	{
		String identify = request.getParameter("identify");

		ILocationQnaDAO locDao = sqlSession.getMapper(ILocationQnaDAO.class);

		HttpSession session = request.getSession();
		String accountCode = (String) session.getAttribute(identify + "Code");

		String result = "noSigned";

		if (accountCode != null)
		{
			// 이용자일 경우
			if (identify.equals("member"))
			{
				IMemberAccountDAO dao = sqlSession.getMapper(IMemberAccountDAO.class);
				model.addAttribute("info", dao.getInfo(accountCode));

				String qna_code = request.getParameter("qna_code");
				model.addAttribute("modify", locDao.updateQnaForm(qna_code));
			}
			// 호스트일 경우
			else if (identify.equals("host"))
			{
				IHostAccountDAO dao = sqlSession.getMapper(IHostAccountDAO.class);
				model.addAttribute("info", dao.getInfo(accountCode));

				String qna_reply_code = request.getParameter("qna_reply_code");
				model.addAttribute("modifyQnaReply", locDao.updateQnaReplyForm(qna_reply_code));
			}
			// 로그인이 되었음을 기록한다.
			result = "signed";
		}

		// 로그인 여부 데이터를 뷰에 넘겨준다.
		model.addAttribute("result", result);

		if (result.equals("noSigned"))
		{
			// 로그인 창으로 이동한다.
			return "redirect:loginform.action?identify=" + identify;
		}

		// 뒤에 identify를 GET 해준다.
		return "../WEB-INF/views/common/modifyQnaPopup.jsp?identify=" + identify;
	}

	/* === 이용자 === */

	// 이용자 : QnA 작성
	@RequestMapping(value = "/actions/qnainsert.action", method = RequestMethod.POST)
	public String insertQna(LocationQnaDTO dto)
	{
		ILocationQnaDAO dao = sqlSession.getMapper(ILocationQnaDAO.class);

		dao.insertMemQna(dto);
		//System.out.println("qna작성 : " + dto.getMember_code());
		return "redirect:locationdetail.action";
	}

	// 이용자 : QnA 수정
	@RequestMapping(value = "/actions/modifyqna.action", method = RequestMethod.POST)
	public String modifyQna(LocationQnaDTO dto)
	{
		ILocationQnaDAO dao = sqlSession.getMapper(ILocationQnaDAO.class);

		dao.updateMemQna(dto);
		return "redirect:locationdetail.action";
	}

	// 이용자 : QnA 삭제
	@RequestMapping(value = "/actions/deleteqna.action", method = RequestMethod.GET)
	public String deleteQna(LocationQnaDTO dto, HttpServletRequest request)
	{
		ILocationQnaDAO dao = sqlSession.getMapper(ILocationQnaDAO.class);
		String loc_code = request.getParameter("loc_code");
		dao.deleteMemQna(dto);
		
		return "redirect:locationdetail.action?loc_code="+loc_code;

		//return result;
	}

	/* === 호스트 === */

	// 호스트 : QnA 답글 작성
	@RequestMapping(value = "/actions/qnareplyinsert.action", method = RequestMethod.POST)
	public String insertQnaReply(LocationQnaDTO dto)
	{
		ILocationQnaDAO dao = sqlSession.getMapper(ILocationQnaDAO.class);

		dao.insertHostQna(dto);

		return "redirect:locationdetailhost.action";
	}

	// 호스트 : Qna 답글 수정
	@RequestMapping(value = "/actions/modifyqnareply.action", method = RequestMethod.POST)
	public void modifyQnaReply(LocationQnaDTO dto)
	{
		ILocationQnaDAO dao = sqlSession.getMapper(ILocationQnaDAO.class);

		dao.updateHostQna(dto);
	}

	// 호스트 : QnA 답글 삭제
	@RequestMapping(value = "/actions/deleteqnareply.action", method = RequestMethod.GET)
	public String deleteQnaReply(String qna_reply_code, HttpServletRequest request)
	{
		ILocationQnaDAO dao = sqlSession.getMapper(ILocationQnaDAO.class);
		String loc_code = request.getParameter("loc_code");
		dao.deleteHostQna(qna_reply_code);
		return "redirect:locationdetailhost.action?loc_code="+loc_code;

	}

}
