<%@page import="org.json.JSONObject"%>
<%@page import="mybatis.vo.BbsVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
boolean chk = (boolean)request.getAttribute("chk");

if(chk){
	BbsVO[] ar = null;
	Object obj = request.getAttribute("ar");
	
	if(obj!=null){
		ar = (BbsVO[])obj;
		
		//System.out.println(ar.length);
%>
	<%=JSONObject.wrap(ar) %>
<%
	}
}
%>