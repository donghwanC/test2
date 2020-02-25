<%@page import="mybatis.vo.CommVO"%>
<%@page import="mybatis.vo.BbsVO"%>
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
	#del_win{
		display: none;
	}

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
	
	#bbs table th {
	    text-align:center;
	    border:1px solid black;
	    padding:4px 10px;
	}
	
	#bbs table td {
	    text-align:left;
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
	
	#pop1{
		display:none;
	}
	#pop2{
		display:none;
	}
	
	.comm_table{
		background-color: #0bf;
	}
</style>
</head>
<body>
	<%
	String cPage = request.getParameter("cPage");
	
	BbsVO bvo = null;
	Object obj = request.getAttribute("view");
	
	if(obj != null){
		bvo = (BbsVO)obj;	
	%>
	<div id="bbs">
	<form method="post" >
		<table id="view_table" summary="게시판 글쓰기">
			<caption>게시판 글쓰기</caption>
			<tbody>
				<tr>
					<th>제목:</th>
					<td><%=bvo.getSubject() %></td>
					<th>조회수:</th>
					<td><%=bvo.getHit() %></td>
				</tr>

				<tr>
					<th>첨부파일:</th>
					<td colspan="3">
					<%
					if(bvo.getFile_name() != null && bvo.getFile_name().trim().length() > 4){
					%>
					<a href="javascript: down('<%=bvo.getFile_name() %>')"><%=bvo.getOri_name() %></a>
					<%
					} else {
					%>
					파일없음
					<%	
					}
					%>
					</td>
				</tr>
				
				<tr>
					<th>이름:</th>
					<td colspan="3"><%=bvo.getWriter() %></td>
				</tr>
				<tr>
					<th>내용:</th>
					<td colspan="3"><%=bvo.getContent() %></td>
				</tr>
			</tbody>
		</table>
		<table border="0">
			<tbody>
				<tr>
					<td colspan="4">
						<input type="button" value="수정" id="edit_btn"/>
						<input type="button" value="삭제" id="del_btn"/>
						<input type="button" value="목록" onclick="javascript:golist('<%=cPage %>')"/>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	<br/>

	<hr/>	
	댓글들
	<input type="button" value="댓글추가" id="comm_btn">
	<hr/>

	<div id="comm_area">
<%
CommVO[] c_ar = null;
Object obj2 = request.getAttribute("comm");

if(obj2!=null)
	c_ar = (CommVO[])obj2;

for(int i=0; i<c_ar.length; i++) {
	CommVO cvo = c_ar[i];
%>		
			<table class="comm_table">
				<colgroup>
					<col width="20px"/>
					<col width="100px"/>
				</colgroup>
				<tbody>
					<tr>
						<td>이름:</td>
						<td><%=cvo.getWriter() %></td>
					</tr>
					<tr>
						<td>내용:</td>
						<td><%=cvo.getContent() %></td>
					</tr>
					<tr>
						<td>날짜:</td>						
						<td>
<%
						if(cvo.getWrite_date() != null)
							out.println(cvo.getWrite_date().substring(0,10));
%> 											
						</td>				
					</tr>
				</tbody>
			</table>
			<hr/>
<%
}
%>
		</div>

	</div>
		
	<form name="frm" method="post">
		<input type="hidden" name="cPage" value="<%=cPage %>"/>
		<input type="hidden" name="b_idx" value="<%=bvo.getB_idx() %>"/>
		<input type="hidden" name="fname"/>
	</form>
	

	<div id="del_win">
		<form>
			<input type="hidden" name="b_idx" id="b_idx" value="<%=bvo.getB_idx() %>"/>
			<label for="pw">비밀번호:</label>
			<input type="password" id="pwd" name="pwd"/>
			<input type="hidden" id="cPage" value="<%=cPage %>"/>
			<br/>
			<button type="button" id="delete_bt">삭제</button>
			<button type="button" id="close_bt">닫기</button>
		</form>
	</div>
	
	
	
	<div id="pop1">
	<form action="control?type=edit" id="edit_frm" method="post" encType="multipart/form-data">
		<table summary="게시판 수정하기">
			<caption>수정하기</caption>
			<tbody>
				<tr>
					<th>제목:</th>
					<td><input type="text" id="edit_title" name="title" size="45"/></td>
				</tr>
				<tr>
					<th>이름:</th>
					<td><input type="text" id="edit_writer" name="writer" size="12" value="<%=bvo.getWriter() %>" readonly="readonly"/></td>
				</tr>
<%--				
				<tr>
					<th>내용:</th>
					<td><textarea name="content" cols="50" 
							rows="8" id="content"></textarea>
					</td>
				</tr>
 --%>				
				<tr>
					<th>첨부파일:</th>
					<td><input type="file" name="file"/></td>
				</tr>

				<tr>
					<th>비밀번호:</th>
					<td><input type="password" id="edit_pwd" name="pwd" size="12"/></td>
				</tr>

<%--
				<tr>
					<td colspan="2">
						<input type="button" value="보내기"
						onclick="sendData()"/>
						<input type="button" value="다시"/>
						<input type="button" value="목록"/>
					</td>
				</tr>
 --%>		
			</tbody>
		</table>
		<input type="hidden" name="b_idx" value="<%=bvo.getB_idx() %>"/>
		<input type="hidden" name="content" id="str"/>
	</form>

		<table>
			<tbody>
				<tr>
					<th style="width:83px;">내용:</th>
					<td><textarea name="content" cols="50" 
							rows="8" id="content"></textarea>
					</td>
				</tr>			
				<tr>
					<td colspan="2">
						<input type="button" value="수정"
						id="ok_btn" onclick="javascript:goedit('<%=bvo.getPwd() %>')"/>
						<input type="button" value="취소"
						onclick="javascript:goclose()"/>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
		
		
		
	<div id="pop2">
		<form method="post">
			이름:<input type="text" id="comm_writer" name="writer"/><br/>
			내용:<textarea rows="4" cols="55" id="comm_content" name="content"></textarea><br/>
			비밀번호:<input type="password" id="comm_pwd" name="pwd"/><br/>
	
			<input type="hidden" name="b_idx" value="<%=bvo.getB_idx() %>">
			<input type="hidden" name="cPage" value="<%=cPage %>"/>
			<input type="button" value="추가" id="okok_btn"/> 
			<input type="button" value="취소" id="nono_btn"/>
		</form>
	</div>
<%
	}
%>

	<form name="frm0" method="post">
		<input type="hidden" name="cPage" value="<%=cPage %>"/>
		<input type="hidden" name="b_idx" value="<%=bvo.getB_idx() %>"/>
		<input type="hidden" name="fname"/>
	</form>


	<script type="text/javascript" src="js/jquery-3.4.1.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="js/summernote-lite.js"></script>
	<script type="text/javascript" src="js/lang/summernote-ko-KR.min.js"></script>
	
	<script type="text/javascript">
		$(function(){
			
			$("#content").summernote({
				dialogsInBody: true,
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
			
			function sendFile(file, editor){
				//이미지를 서버로 업로드 시키기 위해
				// 비동기식 통신을 수행하자!
				
				//파라미터를 전달하기 위해 폼객체 준비!
				var frm = new FormData($('#edit_frm')[0]); //<form encType="multipart/form-data"></form>
				
				//보내고자 하는 자원을 파라미터 값으로 등록(추가)
				frm.append("upload", file);
				//frm.append("str", "Michael");
				
				//비동기식 통신
				$.ajax({
					url: "control?type=saveImage",
					type: "post",
					dataType: "json",
					// 파일을 보낼 때는
					//일반적인 데이터 전송이 아님을 증명해야 한다.
					contentType: false,
					processData: false,
					//data: "v1="+encodeURIComponent(값)
					data: frm
					
				}).done(function(data){
					
					//console.log(data.img_url);
					//에디터에 img태그로 저장하기 위해
					// img태그 만들고, src라는 속성을 지정해야 함!
					//var img = $("<img>").attr("src",data.img_url);
					//$("#content").summernote("insertNode", img[0]);
					
					 $("#content").summernote(
						"editor.insertImage", data.url);
				
					//console.log(data.url);
					
				}).fail(function(err){
					console.log(err);
				});

			}
			
			
			$("#content").summernote("lineHeight", 1.0); // 자간높이?여백설정

					
					
			
			$("#edit_btn").click(function(){
				$("#pop1").dialog();
				$("#pop1").dialog("option","width",800);
			});
			
			
			$("#del_btn").click(function(){
				$("#del_win").css("display", "block");
				$("#del_win").dialog();
			});
			
			
			$("#close_bt").click(function(){
				$("#del_win").dialog("close");
			});
			
			$("#delete_bt").click(function(){
				var b_idx = $("#b_idx").val();
				var pwd = $("#pwd").val();
				var cPage = $("#cPage").val();
				
				var param = "type=delete&b_idx="+encodeURIComponent(b_idx)+
							"&pwd="+encodeURIComponent(pwd);
				
				$.ajax({
					url:"control",
					type:"post",
					dataType:"json",
					data:param
				}).done(function(data){
					if(data.value == "ok")
						location.href="control?type=list&cPage="+${cPage};
					else
						alert("실패");
					
					
					$("#pop1").dialog("close");
				}).fail(function(err){
					console.log(err);
				});
			});
			
			
			$("#comm_btn").click(function(){
				$("#pop2").dialog();
				$("#pop2").dialog("option","width",500);
			});
			
			$("#nono_btn").click(function(){
				$("#pop2").dialog("close");
			});
			
			$("#okok_btn").click(function(){
				var writer = $("#comm_writer").val();
				var content = $("#comm_content").val();
				var pwd = $("#comm_pwd").val();
				var b_idx = $("#b_idx").val();
				var cPage = $("#cPage").val();
				
				var param = "type=comm&writer="+encodeURIComponent(writer)+
							"&content="+encodeURIComponent(content)+
							"&pwd="+encodeURIComponent(pwd)+
							"&b_idx="+encodeURIComponent(b_idx)+
							"&cPage="+encodeURIComponent(cPage);
				
				$.ajax({
					url:"control",
					type:"post",
					dataType:"json",
					data:param
				}).done(function(data){
					var msg = "";

					for(var i=0; i<data.length; i++){
						msg += "<table class=\"comm_table\"><colgroup><col width=\"20px\"/><col width=\"100px\"/></colgroup><tbody>";
								
						msg += "<tr><td>이름:</td><td>"+data[i].writer+"</td></tr>";
						msg += "<tr><td>날짜:</td><td>"+data[i].write_date+"</td></tr>";
						msg += "<tr><td>내용:</td><td>"+data[i].content+"</td></tr>";
						
						msg += "</tbody></table><hr/>";
					}
					
					$("#comm_area").html(msg);		
					
					$("#pop2").dialog("close");
					$("#comm_writer").val("");
					$("#comm_content").val("");
					$("#comm_pwd").val("");
					
				}).fail(function(err){
					console.log(err);
				});
			});
			
			
			$("#exit_btn").click(function(){
				$("#pop1").dialog("close");
			});
			
		});
		
		function golist(cPage) {
			document.forms[0].action = "control?type=list&cPage="+cPage;
			document.forms[0].submit();
		}
		
		function down(fname) {
			document.frm0.fname.value = fname;
			document.frm0.action = "control?type=down";
			document.frm0.submit();
		}
		
		function goedit(pwd) {
			var pw = $("#edit_pwd").val();
			
			if(pwd != pw){
				alert("비번재입력");
				return;
			}
			
			var str = $("#content").val();
			//console.log(str);
			$("#str").val(str);
			
			var form = $('#edit_frm')[0];
		    var formData = new FormData(form);
		    
		    $.ajax({
		        url : "control?type=edit",
		        type : "post",
		        data : formData,
		        dataType:"json",
		        contentType : false,
		        processData : false
		    }).done(function(data){
			    	
				var msg = "";
				
				msg += "<tr><th>제목:</th><td>"+data.subject+"</td><th>조회수:</th><td>"+data.hit+"</td></tr>";
				msg += "<tr><th>첨부파일:</th><td colspan=\"3\">";
				
				if(data.file_name != null)
					msg += "<a href=\"javascript: down(\'"+data.file_name+"\')\">"+data.ori_name+"</a>";
				else
					msg += "파일없음";
				msg += "</td></tr>";
				msg += "<tr><th>이름:</th><td colspan=\"3\">"+data.writer+"</td></tr>";
				msg += "<tr><th>내용:</th><td colspan=\"3\">"+data.content+"</td></tr>";
				
				
				$("#view_table tbody").html(msg);
				
				$("#pop1").dialog("close");
				
				$("#edit_title").val("");
				$("#content").summernote('reset');
				$("#edit_pwd").val("");
				
				//console.log(data.content);
				
			}).fail(function(err){
				console.log(err);
			});    
		    
		}
		
		function goclose() {
	    	$("#pop1").dialog("close");
	    	
	    	$("#edit_title").val("");
			$("#content").summernote('reset');
		}
	</script>
</body>
</html>