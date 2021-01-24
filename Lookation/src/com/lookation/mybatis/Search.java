package com.lookation.mybatis;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.lookation.dao.ISearchDAO;
import com.lookation.dto.AvgRateCompare;
import com.lookation.dto.ReviewCountCompare;
import com.lookation.dto.SearchDTO;

@Controller
public class Search
{
	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value="/actions/search.action", method = RequestMethod.GET)
	public String searchKeyword(Model model, HttpServletRequest request)
	{
		ISearchDAO dao = sqlSession.getMapper(ISearchDAO.class);
		
		// 키워드 파라미터
		String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");
		// 정렬 파라미터
		String order = request.getParameter("order") == null ? "" : request.getParameter("order");

		// default 날짜 값 계산---------------------------------------------------------------------------------------------------
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());	
		SimpleDateFormat df1 = new SimpleDateFormat ("yyyy-MM-dd");
		SimpleDateFormat df2 = new SimpleDateFormat ("yyyy-MM-dd");
		String default_start_date = df1.format(cal.getTime());
		cal.add(Calendar.MONTH, 3);
		String default_end_date = df2.format(cal.getTime());
		
		// 상세검색 파라미터------------------------------------------------------------------------------------------------------
		String loc_type = request.getParameter("loc_type") == null ? "" : request.getParameter("loc_type");
		String start_date = request.getParameter("start_date") == null ? default_start_date : request.getParameter("start_date");
		String end_date = request.getParameter("end_date") == null ? default_end_date : request.getParameter("end_date");
		int start_price;		
		if(request.getParameter("start_price") == null)
		{
			start_price = 0;
		}
		else if(request.getParameter("start_price").equals(""))
		{
			start_price = 0;
		}
		else
		{
			start_price = Integer.parseInt(request.getParameter("start_price"));
		}

		int end_price;		
		if(request.getParameter("end_price") == null)
		{
			end_price = 1000000;
		}
		else if(request.getParameter("end_price").equals(""))
		{
			end_price = 1000000;
		}
		else
		{
			end_price = Integer.parseInt(request.getParameter("end_price"));
		}
		
		String loc_addr_city = request.getParameter("loc_addr_city") == null ? "" : request.getParameter("loc_addr_city");
		String loc_addr_dong = request.getParameter("loc_addr_dong") == null ? "" : request.getParameter("loc_addr_dong");
		
		// 상세검색 파라미터 예외처리
		if(loc_type.equals("모든공간"))		// 전체공간 선택시 
			loc_type="";
		if(loc_addr_city.equals("전체"))	// 전체도시 선택시
			loc_addr_city="";
		if(end_date.equals(""))				// 날짜선택 안할시
			end_date = default_end_date;
		
		// dto 객체 초기화--------------------------------------------------------------------------------------------------------
		SearchDTO dto = new SearchDTO();
		dto.setKeyword(keyword);
		dto.setLoc_type(loc_type);
		dto.setStart_date(start_date);
		dto.setEnd_date(end_date);
		dto.setStart_price(start_price);
		dto.setEnd_price(end_price);
		dto.setLoc_addr_city(loc_addr_city);
		dto.setLoc_addr_dong(loc_addr_dong);
		
		// dto 초기화 결과 확인--------------------------------------
		System.out.println("dto 초기화 결과 : " + dto);
		System.out.println("getKeyword"+dto.getKeyword());
		System.out.println("getLoc_type"+dto.getLoc_type());
		System.out.println("getStart_date"+dto.getStart_date());
		System.out.println("getEnd_date"+dto.getEnd_date());
		System.out.println("getStart_price"+dto.getStart_price());
		System.out.println("getEnd_price"+dto.getEnd_price());
		System.out.println("getLoc_addr_city"+dto.getLoc_addr_city());
		System.out.println("getLoc_addr_dong"+dto.getLoc_addr_dong());
				                    
		
		//정렬--------------------------------------------------------------------------------------------------------------
		List<SearchDTO> list = new ArrayList<SearchDTO>();

		// 낮은 가격순
		if(order.equals("sortLtH"))
		{
			list = dao.search(dto);
			Collections.sort(list);
			System.out.println(list);
			model.addAttribute("view", list);
		}
		// 높은 가격순
		else if (order.equals("sortHtL"))
		{
			list = dao.search(dto);
			Collections.sort(list);
			Collections.reverse(list);
			System.out.println(list);
			model.addAttribute("view", list);
		}
		// 리뷰 많은순
		else if (order.equals("sortReview"))
		{
			list = dao.search(dto);
			Collections.sort(list, new ReviewCountCompare());
			Collections.reverse(list);
			System.out.println(list);
			model.addAttribute("view", list);
		}
		// 평점 높은순
		else if (order.equals("sortRateAvg"))
		{
			list = dao.search(dto);
			Collections.sort(list, new AvgRateCompare());
			Collections.reverse(list);
			System.out.println(list);
			model.addAttribute("view", list);
		}
		else 
		{
			list = dao.search(dto);
			System.out.println(list);
			model.addAttribute("view", list);
		}

		System.out.println("searchorder" + order);
		
		return "/WEB-INF/views/user/search.jsp";
		
	}
	
	@RequestMapping(value="/actions/searchkeyword.action", method = RequestMethod.POST)
	public String searchKeywordOther(Model model, HttpServletRequest request)
	{
		ISearchDAO dao = sqlSession.getMapper(ISearchDAO.class);
		
		// 키워드 파라미터
		String searchWord = request.getParameter("searchName");
		
		// 정렬 파라미터
		String order = "";

		// default 날짜 값 계산---------------------------------------------------------------------------------------------------
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());	
		SimpleDateFormat df1 = new SimpleDateFormat ("yyyy-MM-dd");
		SimpleDateFormat df2 = new SimpleDateFormat ("yyyy-MM-dd");
		String default_start_date = df1.format(cal.getTime());
		cal.add(Calendar.MONTH, 3);
		String default_end_date = df2.format(cal.getTime());
		
		// 상세검색 파라미터------------------------------------------------------------------------------------------------------
		String loc_type = "";
		String start_date = default_start_date;
		String end_date = default_end_date;
		
		int start_price;		
		if(request.getParameter("start_price") == null)
		{
			start_price = 0;
		}
		else if(request.getParameter("start_price").equals(""))
		{
			start_price = 0;
		}
		else
		{
			start_price = Integer.parseInt(request.getParameter("start_price"));
		}

		int end_price;		
		if(request.getParameter("end_price") == null)
		{
			end_price = 1000000;
		}
		else if(request.getParameter("end_price").equals(""))
		{
			end_price = 1000000;
		}
		else
		{
			end_price = Integer.parseInt(request.getParameter("end_price"));
		}
		
		String loc_addr_city = "";
		String loc_addr_dong = "";
		
		// 상세검색 파라미터 예외처리
		if(loc_type.equals("모든공간"))		// 전체공간 선택시 
			loc_type="";
		if(loc_addr_city.equals("전체"))	// 전체도시 선택시
			loc_addr_city="";
		if(end_date.equals(""))				// 날짜선택 안할시
			end_date = default_end_date;
		
		// dto 객체 초기화--------------------------------------------------------------------------------------------------------
		SearchDTO dto = new SearchDTO();
		dto.setKeyword(searchWord);
		dto.setLoc_type(loc_type);
		dto.setStart_date(start_date);
		dto.setEnd_date(end_date);
		dto.setStart_price(start_price);
		dto.setEnd_price(end_price);
		dto.setLoc_addr_city(loc_addr_city);
		dto.setLoc_addr_dong(loc_addr_dong);
				                    
		
		//정렬--------------------------------------------------------------------------------------------------------------
		List<SearchDTO> list = new ArrayList<SearchDTO>();

		// 낮은 가격순
		if(order.equals("sortLtH"))
		{
			list = dao.search(dto);
			Collections.sort(list);
			System.out.println(list);
			model.addAttribute("view", list);
		}
		// 높은 가격순
		else if (order.equals("sortHtL"))
		{
			list = dao.search(dto);
			Collections.sort(list);
			Collections.reverse(list);
			System.out.println(list);
			model.addAttribute("view", list);
		}
		// 리뷰 많은순
		else if (order.equals("sortReview"))
		{
			list = dao.search(dto);
			Collections.sort(list, new ReviewCountCompare());
			Collections.reverse(list);
			System.out.println(list);
			model.addAttribute("view", list);
		}
		// 평점 높은순
		else if (order.equals("sortRateAvg"))
		{
			list = dao.search(dto);
			Collections.sort(list, new AvgRateCompare());
			Collections.reverse(list);
			System.out.println(list);
			model.addAttribute("view", list);
		}
		else 
		{
			list = dao.search(dto);
			System.out.println(list);
			model.addAttribute("view", list);
		}

		System.out.println("searchorder" + order);
		
		model.addAttribute("keyword", searchWord);
		
		return "/WEB-INF/views/user/search.jsp";
		
	}

}
