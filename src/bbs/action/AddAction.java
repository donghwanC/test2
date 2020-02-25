package bbs.action;

import java.io.File;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import bbs.util.Paging;
import mybatis.dao.BbsDAO;
import mybatis.vo.BbsVO;

public class AddAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		
		try {
			request.setCharacterEncoding("utf-8");
			
			MultipartRequest multi = null;
			
			int sizeLimit = 1024*1024*10;
			
			String savePath = request.getRealPath("/upload");
			
			
			try {
				multi = new MultipartRequest(request, savePath, sizeLimit, "utf-8",
							new DefaultFileRenamePolicy());
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			String cPage = multi.getParameter("cPage");
			
			String title = multi.getParameter("title");
			String writer = multi.getParameter("writer");
			String content = multi.getParameter("content");			
			String ip = request.getRemoteAddr();
			
			String fname = "";
			String oname = "";
			File f = multi.getFile("file");
			
			if(f != null){
				fname = f.getName();
				oname = multi.getOriginalFileName("file");
			}
			
			boolean chk = BbsDAO.add(title, writer, content, fname, oname, ip);
			
			Paging page = new Paging();
			
			page.setTotalRecord(BbsDAO.getTotalCount());
			page.setNowPage(Integer.parseInt(cPage));
			
			//System.out.println(page.getNowPage()+","+page.getBegin()+","+page.getEnd());
			
			BbsVO[] ar = BbsDAO.getList(page.getBegin(), page.getEnd());
			
			request.setAttribute("cPage", cPage);
			request.setAttribute("chk", chk);
			request.setAttribute("ar", ar);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return "/add.jsp";
	}

}
