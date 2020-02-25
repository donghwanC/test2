package bbs.action;

import java.io.File;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import mybatis.dao.BbsDAO;

public class WriteAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		// 현재 메서드는 list.jsp에 있는 글쓰기 버튼과
		// write.jsp 에서 보내기 버튼 클릭에 따라 액션이 달라짐
		String viewPath = "/write.jsp";
		
		String c_type = request.getContentType(); // ****************
		// MIME타입을 요청한 곳으로부터 얻는다.
		// get방식 : null, 
		// Post방식 : application/..
		// Post방식에 encType="multipart..." : multipart/..
		//System.out.println(c_type);
		
		if(c_type != null && c_type.startsWith("multipart/")) { // c_type의 앞 시작부분이 "multipart/"로 시작하냐?
			// Post방식으로 들어왔을 경우
			try {
				// 첨부파일을 저장할 위치를 절대경로화 시킴
				ServletContext application = request.getServletContext();
				
				String path = application.getRealPath("/upload");
				
				MultipartRequest mr = new MultipartRequest(request, path, 1024*1024*5, "utf-8", new DefaultFileRenamePolicy());
				// 파일첨부 되었다면 이때 업로드가 되어짐
				
				// 나머지 파라미터 받기
				String title = mr.getParameter("title");
				String writer = mr.getParameter("writer");
				String content = mr.getParameter("content");
				String ip = request.getRemoteAddr();

				String fname = "";
				String oname = "";
				File f = mr.getFile("file");

				if(f != null){
					
					fname = f.getName();
					oname = mr.getOriginalFileName("file");
				}
				
				// DB저장
				Boolean chk = BbsDAO.add(title, writer, content, fname, oname, ip);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			// jsp경로를 반환하면, forward처리가 되어짐
			// F5버튼을 누르면 저장 된 정보가 계속 저장
			
			// viewPath를 control?type=list로 정하게 된다면??
			// F5를 누를 때 마다 파라미터값을 가진 채 forward.
			// 계속해서 새로운 글이 작성 됨
			
			// null일 때 forward가 아닌, response.sendRedirect("control");
			// 설정해서 초기화? 시켜줌
			viewPath = null;
			
		}
	
		return viewPath;
	}

}
