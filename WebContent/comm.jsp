<%@page import="org.json.JSONObject"%>
<%@page import="mybatis.vo.CommVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
CommVO[] cvo = null;
Object obj = request.getAttribute("comm");

if(obj!=null){
	cvo = (CommVO[])obj;
%>
	<%=JSONObject.wrap(cvo) %>
<%
}
%>