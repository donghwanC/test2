<%@page import="mybatis.vo.BbsVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
boolean chk = (boolean)request.getAttribute("chk");

if(chk){
%>
{"value":"ok"}
<%
}else{
%>
{"value":"no"}
<%	
}
%>