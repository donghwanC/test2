<%@page import="org.json.JSONObject"%>
<%@page import="mybatis.vo.BbsVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
BbsVO bvo = null;
Object obj = request.getAttribute("bvo");

if(obj!=null){
	bvo = (BbsVO)obj;
%>
<%=JSONObject.wrap(bvo) %>
<%
}
%>