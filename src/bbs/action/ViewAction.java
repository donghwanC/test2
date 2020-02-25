package bbs.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mybatis.dao.BbsDAO;
import mybatis.vo.BbsVO;
import mybatis.vo.CommVO;

public class ViewAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {

		
		String cPage = request.getParameter("cPage");
		String b_idx = request.getParameter("b_idx");

		BbsVO bvo = BbsDAO.getBbs(b_idx);
		
		HttpSession session = request.getSession();
		
		Object obj = session.getAttribute("read_bbs");

		boolean chk = false;
		List<BbsVO> list = null;

		if(obj == null){
			list = new ArrayList<BbsVO>();
			session.setAttribute("read_bbs", list);
		}else{
			list = (List<BbsVO>)obj;
			
			//vo의 b_idx와 list에 있는 각 BbsVO의 b_idx를 비교
			for(BbsVO r_vo : list){
				if(b_idx.equals(r_vo.getB_idx())){
					chk = true;
					break;
				}
					
			}
		}

		if(!chk){
			//일단 현 게시물의 조회수 값을 가져온다.
			int hit = Integer.parseInt(bvo.getHit());
			++hit;
			
			bvo.setHit(String.valueOf(hit)); 
			
			// 여기까지는 vo가 가지고 있는 hit값을 변경했지만
			// DB에는 변경되지 않았다.
			BbsDAO.hit(b_idx);
			
			//읽은 게시물로 처리하기 위해 list에 vo를 추가
			list.add(bvo);
		}
		
		CommVO[] c_ar = null;
		List<CommVO> c_list = bvo.getC_list();
		
		if(c_list!=null) {
			c_ar = new CommVO[c_list.size()];
			c_list.toArray(c_ar);
		}
		
		request.setAttribute("view", bvo);
		request.setAttribute("comm", c_ar);
		request.setAttribute("cPage", cPage);
		

		return "/view.jsp";
		
	}
}

