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
<template:addResources type="css" resources="feature.css"/>
<c:set var="imageLayout" value="${currentNode.properties.imageLayout.string}"/>
<c:choose>
    <c:when test="${imageLayout == 'rounded'}">
        <c:set var="imageCSS" value=" class='img-rounded'"/>
    </c:when>
    <c:when test="${imageLayout == 'rounded-and-polaroid    '}">
        <c:set var="imageCSS" value=" class='img-rounded img-polaroid'"/>
    </c:when>
    <c:when test="${imageLayout == 'circle'}">
        <c:set var="imageCSS" value=" class='img-circle'"/>
    </c:when>
    <c:when test="${imageLayout == 'polaroid'}">
        <c:set var="imageCSS" value=" class='img-polaroid'"/>
    </c:when>
    <c:when test="${imageLayout == 'circle-and-polaroid'}">
        <c:set var="imageCSS" value=" class='img-circle img-polaroid'"/>
    </c:when>
    <c:otherwise>
        <c:set var="imageCSS"/>
    </c:otherwise>
</c:choose>
<div class="row-fluid">
    <div class="span6">
        <h2>${currentNode.properties['jcr:title'].string}</h2>

        <p>
            ${currentNode.properties['text'].string}
        </p>
    </div>
    <div class="span6 fadeParent">
        <div class="span6"  >
            <a class="fancybox" rel="${currentNode.name}" href="${currentNode.properties['imageHover'].node.url}"><img src="${currentNode.properties['image'].node.url}" alt="${currentNode.properties['image'].node.displayableName}" ${imageCSS}/></a>
        </div>
    </div>
</div>

<%-- Add mousewheel plugin (this is optional) --%>
<template:addResources type="javascript" resources="jquery.mousewheel-3.0.6.pack.js"/>

<%-- Add fancyBox --%>
<template:addResources type="css" resources="jquery.fancybox.css"/>
<template:addResources type="javascript" resources="jquery.fancybox.js"/>


<%-- Optionally add helpers - button, thumbnail and/or media --%>
<template:addResources type="css" resources="jquery.fancybox-buttons.css,jquery.fancybox-thumbs.css"/>
<template:addResources type="javascript" resources="jquery.fancybox-buttons.js,jquery.fancybox-media.js,jquery.fancybox-thumbs.js"/>
<template:addResources type="inline">
    <script type="text/javascript">
        $(document).ready(function() {
            $(".fancybox").fancybox();
        });
    </script>
</template:addResources>