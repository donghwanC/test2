package bbs.action;

import java.io.File;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import mybatis.dao.BbsDAO;
import mybatis.vo.BbsVO;

public class EditAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		
		String c_type = request.getContentType(); // form의 타입?을 알려줌
		
		if(c_type != null && c_type.startsWith("multipart/")) { // c_type의 앞 시작부분이 "multipart/"로 시작하냐?
			
			try {
				// 첨부파일을 저장할 위치를 절대경로화 시킴
				ServletContext application = request.getServletContext();
				
				String path = application.getRealPath("/upload");
				
				// 파일첨부 되었다면 이때 업로드가 되어짐
				MultipartRequest mr = new MultipartRequest(request, path, 1024*1024*5, "utf-8", new DefaultFileRenamePolicy());				
				
				// 나머지 파라미터 받기
				String b_idx = mr.getParameter("b_idx");
				String writer = mr.getParameter("writer");
				String title = mr.getParameter("title");
				String content = mr.getParameter("content");
				String pwd = mr.getParameter("pwd");
				String ip = request.getRemoteAddr();
				
				String fname = "";
				String oname = "";
				File f = mr.getFile("file");
				
				if(f != null){
					fname = f.getName();
					oname = mr.getOriginalFileName("file");
				}
				
				boolean chk = BbsDAO.edit(b_idx, title, writer, content, fname, oname, ip, pwd);
				
				BbsVO bvo = BbsDAO.getBbs(b_idx);
				
				request.setAttribute("bvo", bvo);
				
				//System.out.println(content);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		
			
		}
		return "/edit.jsp";
	}

}
