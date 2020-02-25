<%@page import="bbs.util.Paging"%>
<%@page import="mybatis.vo.BbsVO"%>
<%@page import="mybatis.dao.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="css/jquery-ui.min.css"/>
<link rel="stylesheet" href="css/summernote-lite.css"/>
<style type="text/css">
	#bbs table {
	    width:580px;
	    margin-left:10px;
	    border:1px solid black;
	    border-collapse:collapse;
	    font-size:14px;
	    
	}
	
	#bbs table caption {
	    font-size:20px;
	    font-weight:bold;
	    margin-bottom:10px;
	}
	
	#bbs table th,#bbs table td {
	    text-align:center;
	    border:1px solid black;
	    padding:4px 10px;
	}
	
	.no {width:15%}
	.subject {width:30%}
	.writer {width:20%}
	.reg {width:20%}
	.hit {width:15%}
	.title{background:lightsteelblue}
	
	.odd {background:silver}
	
	/* paging */
	
	table tfoot ol.paging {
	    list-style:none;
	}
	
	table tfoot ol.paging li {
	    float:left;
	    margin-right:8px;
	    background:#0bf;
	}
	
	table tfoot ol.paging li a {
	    display:block;
	    padding:3px 7px;
	    border:1px solid #00B3DC;
	    color:yellow;
	    font-weight:bold;

	}
	
	table tfoot ol.paging li a:hover {
	    background:red;
	    color:white;
	    font-weight:bold;
	}
	
	.disable {
	    padding:3px 7px;
	    border:1px solid silver;
	    color:silver;
	}
	
	.now {
	   padding:3px 7px;
	    border:1px solid #ff4aa5;
	    background:#ff4aa5;
	    color:white;
	    font-weight:bold;
	}
	
	.empty{
		height: 60px;
	}
	#pop1{
		display: none;
	}
</style>
</head>
<body>
	<div id="bbs">
		<table id="t1" summary="게시판 목록">
			<caption>게시판 목록</caption>
			<thead>
				<tr class="title">
					<th class="no">번호</th>
					<th class="subject">제목</th>
					<th class="writer">글쓴이</th>
					<th class="reg">날짜</th>
					<th class="hit">조회수</th>
				</tr>
			</thead>
			
			<tfoot>
                      <tr>
                          <td colspan="4">
                              <ol class="paging">
<%
	//페이징을 위해 request에 저장된 page객체를 얻어낸다.
	Object obj = request.getAttribute("page");
	Paging pvo = null;
	if(obj != null){
		pvo = (Paging)obj;
		//startPage의 값은 항상 1,4,7,...형식이다.
		//그러다보니 이전으로 가는 기능은
		// startPage가 pagePerBlock보다 작을 때는 
		//비활성화가 되어야 한다.
		if(pvo.getStartPage() < pvo.getPagePerBlock()){
%>
	<li class="disable">&lt;</li>
<%		
		}else{ //활성화
%>
	<li><a href="control?type=list&cPage=<%=pvo.getNowPage()-pvo.getPagePerBlock()%>">&lt;</a></li>
<%		
		}
	
		for(int i=pvo.getStartPage(); i<=pvo.getEndPage(); i++){
		
			if(pvo.getNowPage() == i){
%>
	<li class="now"><%=i %></li>
<%			
			}else{
%>
	<li><a href="control?type=list&cPage=<%=i%>"><%=i %></a></li>
<%		
			}//if문의 끝
		}//for문의 끝
	
	//다음 기능을 활성화 비활성화 시켜야 한다.
	//endPage가 totalPage보다 작을 경우에만 활성화!
		if(pvo.getEndPage() < pvo.getTotalPage()){
%>
	<li><a href="control?type=list&cPage=<%=pvo.getNowPage()+pvo.getPagePerBlock()%>">&gt;</a></li>	
<%		
		}else{
%>
	<li class="disable">&gt;</li>
<%		
		}
	}
%>             
	
                              </ol>
                          </td>
						  <td>
						  	<!--  id="write_btn" -->
						  	<!-- onclick="javascript:goadd('<%=pvo.getNowPage()%>')" -->
							<input type="button" value="글쓰기" onclick="javascript:goadd('<%=pvo.getNowPage()%>')"/>
						  </td>
                      </tr>
                  </tfoot>
			<tbody>
<%
	// 게시물들 begin과 end에 맞도록 가져온다.
	BbsVO[] ar = null;
	Object ar_obj = request.getAttribute("ar");
	
	if(ar_obj != null){
	
		ar = (BbsVO[])ar_obj;
		
		int i = 0; // 게시물 번호를 만들기 위한 변수
		
		
		for(BbsVO vo : ar){
			int num = pvo.getTotalRecord() - (pvo.getNowPage()-1)*pvo.getNumPerPage()-i; // 게시물 번호
			System.out.println("num"+num+"=total:"+pvo.getTotalPage()+",now:"+pvo.getNowPage()+",numper:"+pvo.getNumPerPage()+",i="+i);

%>			
		<tr>
			<td><%=num %></td>
			<td style="text-align: left">
				<a href="javascript:goview('<%=vo.getB_idx() %>')">
					<%=vo.getSubject() %>
					<%
						if(vo.getC_list().size() > 0){
					%>
						(<%=vo.getC_list().size() %>)
					<%		
						}
					%>	
				</a>		
				
			</td>
			<td><%=vo.getWriter() %></td>
			<td>
			<%
				if(vo.getWrite_date() != null)
					out.println(vo.getWrite_date().substring(0,10));
			%>	
			</td>
			<td><%=vo.getHit() %></td>
		</tr>
<%
	++i;
		}//for의 끝
		
	}else{
%>
		<tr>
			<td colspan="5" class="empty">
				등록된 게시물이 없습니다.
			</td>
		</tr>
<%		
	}
%>
			</tbody>
		</table>
	</div>
	
	
	<div id="pop1">
	<form action="control?type=add" id="add_frm" method="post" encType="multipart/form-data">
		<table summary="게시판 글쓰기">
			<caption>게시판 글쓰기</caption>
			<tbody>
				<tr>
					<th>제목:</th>
					<td><input type="text" id="add_title" name="title" size="45"/></td>
				</tr>
				<tr>
					<th>이름:</th>
					<td><input type="text" id="add_writer" name="writer" size="12"/></td>
				</tr>			
				<tr>
					<th>첨부파일:</th>
					<td><input type="file" name="file"/></td>
				</tr>
				
			</tbody>
		</table>
		<input type="hidden" name="cPage" value="<%=pvo.getNowPage() %>"/>
		<input type="hidden" name="content" id="str"/>
	</form>
		<table>
			<tbody>
				<tr>
					<th style="width:83px;">내용:</th>
					<td><textarea name="content" cols="50" 
							rows="8" id="add_content"></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="button" value="보내기"
						id="ok_btn"/>
						<input type="button" value="취소"
						id="exit_btn"/>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<form name="view_frm" method="post">
		<input type="hidden" name="cPage" value="<%=pvo.getNowPage()%>"/>
		<input type="hidden" name="b_idx"/>
	</form>
	
	<script type="text/javascript" src="js/jquery-3.4.1.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="js/summernote-lite.js"></script>
	<script type="text/javascript" src="js/lang/summernote-ko-KR.min.js"></script>
	<script type="text/javascript">
		$(function(){
			$("#write_btn").click(function(){
				$("#pop1").dialog();
				$("#pop1").dialog("option","width",800);
			});
			
			$("#exit_btn").click(function(){
				$("#pop1").dialog("close");
			});
			
			$("#ok_btn").click(function(){
				var form = $('#add_frm')[0];
			    var formData = new FormData(form);
			 
			    $.ajax({
			        url : "control?type=add",
			        type : "post",
			        data : formData,
			        dataType:"json",
			        contentType : false,
			        processData : false        
			    }).done(function(data){
					var msg = "";
					
					for(var i=0; i<data.length; i++){
				
						msg += "<tr>";
						msg += "<td>"+data[i].b_idx+"</td>";
						msg += "<td style=\"text-align: left\">";
						msg += "<a href=\"javascript:goview(\'"+data[i].b_idx+"\')\">";
						msg +=	data[i].subject;
						 if(data[i].c_list.length > 0)
							msg += "("+data[i].c_list.length+")";
						msg	+=	"</a></td>";
						msg += 	"<td>"+data[i].writer+"</td>";
						msg +=	"<td>"+data[i].write_date+"</td>";
						msg +=	"<td>"+data[i].hit+"</td>";
						msg += 	"</tr>";
						
					}
					$("#t1 tbody").html(msg);
					
					$("#add_title").val("");
					$("#add_content").val("");
					$("#add_writer").val("");
					
					$("#pop1").dialog("close");

					//console.log(data.length);
					
				}).fail(function(err){
					console.log(err);
				});
			});
			
			$("#content").summernote({
				width: 550,
				height: 300,
				lang: "ko-KR",
				callbacks:{ /* 특정한사건이 발생했을 때 자동으로 실행되는 함수 */
					onImageUpload: function(files, editor){ // 이미지가 에디터에 추가될 때 마다 수행하는 곳
						//console.log("Img++");
						
						// 이미지를 첨부하면 배열로 인식한다
						// 이것을 서버로 비동식 통신을 수행하는 함수를 호출하여 upload시킨다
						for(var i=0; i<files.length; i++){
							sendFile(files[i], editor);
						}
					}
				}
			});
			
			$("#content").summernote("lineHeight", 1.0); // 자간높이?여백설정

			
		});
		
		function goview(b_idx) {
			document.view_frm.b_idx.value = b_idx;
			document.view_frm.action = "control?type=view";
			document.view_frm.submit();
					
		}
		
		function goadd(cPage) {
			document.view_frm.cPage.value = cPage;
			document.view_frm.action = "control?type=write";
			document.view_frm.submit();
		}
	</script>
</body>
</html>
    