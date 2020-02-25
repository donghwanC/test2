package bbs.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mybatis.dao.BbsDAO;

public class DeleteAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		
		String b_idx = request.getParameter("b_idx");
		String pw = request.getParameter("pwd");
		
		boolean chk = BbsDAO.delBbs(b_idx, pw);

		request.setAttribute("chk", chk);
		
		
		return "/delete.jsp";
	}

}
