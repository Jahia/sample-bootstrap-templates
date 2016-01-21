<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>

<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addCacheDependency node="${renderContext.site}"/>
<jcr:nodeProperty node="${renderContext.site}" name="displayFooterLinks" var="displayLinks"/>
        <c:set var="displayFooterLinks" value="false"/>
        <c:choose>
            <c:when test="${displayLinks.string == 'home' and renderContext.site.home.path == renderContext.mainResource.node.path}">
                <c:set var="displayFooterLinks" value="true"/>
            </c:when>
            <c:when test="${displayLinks.string == 'all'}">
                <c:set var="displayFooterLinks" value="true"/>
            </c:when>
        </c:choose>
        <c:if test="${displayFooterLinks}">
    <section class="footer-links" id="footer-links">
        <div class="container-fluid">
            <div class="row-fluid">
                <c:forEach items="${jcr:getChildrenOfType(renderContext.site.home, 'jnt:page')}" var="page">
                    <div class="span2"><h4>${page.displayableName}</h4>
                        <ul class="fa-ul">
                            <c:forEach items="${jcr:getChildrenOfType(page, 'jnt:page')}" var="childpage">
                                <li><i class="fa-li fa fa-angle-right"></i>
                                    <a href="<c:url value="${childpage.url}" context="/"/>" title="${childpage.displayableName}">${childpage.displayableName}</a>
                                </li>
                            </c:forEach>
                        </ul><div class="clear"></div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section><div class="clear"></div>
    </c:if>