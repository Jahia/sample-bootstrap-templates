<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<div class="container-fluid ">
    <div class="flexslider carousel">
        <ul class="${renderContext.editMode?'':'slides'}">
            <c:forEach items="${jcr:getChildrenOfType(currentNode, 'jnt:sampleCarouselItem')}" var="item">
                <li>
                    <template:module node="${item}" nodeTypes="jnt:sampleCarouselItem" editable="true"/>
                </li>
            </c:forEach>
        </ul>
    </div>
</div>
<c:if test="${renderContext.editMode}">
    <template:module path="*" nodeTypes="jnt:sampleCarouselItem"/>
</c:if>
<template:addResources type="css" resources="flexslider.css" media="screen"/>

<%-- FlexSlider --%>
<template:addResources type="javascript" resources="jquery.min.js,jquery.flexslider.js"/>
<c:if test="${! renderContext.editMode}">
    <template:addResources type="inline">
        <script>
            // Can also be used with $(window).load
            $(document).ready(function () {
                $('.flexslider').flexslider({
                    animation: "slide",
                    smoothHeight: true
                });
            });
        </script>
    </template:addResources>
</c:if>