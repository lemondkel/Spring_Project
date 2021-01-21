package com.lookation.mybatis;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.lookation.dao.ISearchDAO;

@Controller
public class Search
{
	@Autowired
	private SqlSession sqlSession;
	
	/*
	 * @RequestMapping(value="/actions/search.action", method = RequestMethod.GET)
	 * public String locList(Model model) { ISearchDAO dao =
	 * sqlSession.getMapper(ISearchDAO.class);
	 * 
	 * model.addAttribute("view", dao.searchLoc()); return
	 * "/WEB-INF/views/user/search.jsp"; };
	 */
	@RequestMapping(value="/actions/search.action", method = RequestMethod.GET)
	public String searchKeyword(Model model, HttpServletRequest request)
	{
		ISearchDAO dao = sqlSession.getMapper(ISearchDAO.class);
		
		// 파라미터 키워드값 받음
		String keyword = request.getParameter("keyword");
		String order = request.getParameter("order");
		
		model.addAttribute("view", dao.searchKeyword(keyword));
		
		System.out.println(keyword + "&" + order);
		
		return "/WEB-INF/views/user/search.jsp";
	}
	
	@RequestMapping(value="/actions/searchorder.action", method = RequestMethod.GET)
	public String searchOrder(Model model, HttpServletRequest request)
	{
		ISearchDAO dao = sqlSession.getMapper(ISearchDAO.class);
		
		// 파라미터 키워드값 받음
		String order = request.getParameter("order");
		System.out.println("22"+order);
		
		return "redirect:search.action?order="+order;
	}
}
