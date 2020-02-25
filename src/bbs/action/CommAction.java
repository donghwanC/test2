package bbs.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mybatis.dao.BbsDAO;
import mybatis.vo.BbsVO;
import mybatis.vo.CommVO;

public class CommAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		
		String writer = request.getParameter("writer");
		String content = request.getParameter("content");
		String pwd = request.getParameter("pwd");
		String b_idx = request.getParameter("b_idx");
		String cPage = request.getParameter("cPage");
		String ip = request.getRemoteAddr();
		
		CommVO cvo = new CommVO();
		cvo.setB_idx(b_idx); cvo.setWriter(writer);
		cvo.setContent(content); cvo.setPwd(pwd);
		cvo.setIp(ip);
		
		boolean chk = BbsDAO.addAns(cvo);
		
		BbsVO bvo = BbsDAO.getBbs(b_idx);
		
		CommVO[] c_ar = null;
		List<CommVO> list = bvo.getC_list();
		
		if(list!=null) {
			c_ar = new CommVO[list.size()];
			list.toArray(c_ar);
		}
		
		request.setAttribute("cPage", cPage);
		request.setAttribute("chk", chk);
		request.setAttribute("comm", c_ar);
		
		return "/comm.jsp";
	}

}
