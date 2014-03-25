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
    <c:when test="${imageLayout == 'rounded-and-polaroid'}">
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

<c:set var="textpart">
    <h2>${currentNode.properties['jcr:title'].string}</h2>

    <p>
            ${currentNode.properties['text'].string}
    </p>
</c:set>
<c:set var="imagepart">
    <jcr:nodeProperty var="imageFancy" node="${currentNode}" name="imageFancy"/>
    <jcr:nodeProperty var="imageHover" node="${currentNode}" name="imageHover"/>
    <div class="clearfix">
        <c:choose>
            <c:when test="${! empty imageFancy}">
                <a class="fancybox" rel="${currentNode.name}" href="${imageFancy.node.url}"><img
                        src="${currentNode.properties['image'].node.url}"
                        alt="${currentNode.properties['image'].node.displayableName}"  ${imageCSS}/>
                    <span class="images-actions"><i class="fa fa-search-plus fa-2"></i></span>
                    <c:if test="${! empty imageHover && ! renderContext.editMode}"><span class="images-actions images-actions2"><i class="fa fa-refresh fa-2"></i></span></c:if>
                </a>
            </c:when>
            <c:otherwise>
                <img alt="${currentNode.properties['image'].node.displayableName}"
                     src="${currentNode.properties['image'].node.url}"  ${imageCSS}/>
                <c:if test="${! empty imageHover && ! renderContext.editMode}"><span class="images-actions"><i class="fa fa-refresh fa-2"></i></span></c:if>
            </c:otherwise>
        </c:choose>
    </div>
    <c:if test="${! empty imageHover && ! renderContext.editMode}">
        <div class="clearfix fadeChild fadeHover ">
            <c:choose>
                <c:when test="${! empty imageFancy}">
                    <a class="fancybox" rel="${currentNode.name}" href="${imageFancy.node.url}"><img
                            src="${imageHover.node.url}"
                            alt="${currentNode.properties['image'].node.displayableName}"  ${imageCSS}/>
                        <span class="images-actions"><i class="fa fa-search-plus fa-2"></i></span>
                    </a>
                </c:when>
                <c:otherwise>
                    <img alt="${currentNode.properties['image'].node.displayableName}"
                         src="${imageHover.node.url}"  ${imageCSS}/>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${! empty imageFancy}">
        <%-- Add mousewheel plugin (this is optional) --%>
        <template:addResources type="javascript" resources="jquery.mousewheel-3.0.6.pack.js"/>

        <%-- Add fancyBox --%>
        <template:addResources type="css" resources="jquery.fancybox.css"/>
        <template:addResources type="javascript" resources="jquery.fancybox.js"/>


        <%-- Optionally add helpers - button, thumbnail and/or media --%>
        <template:addResources type="css"
                               resources="jquery.fancybox-buttons.css,jquery.fancybox-thumbs.css"/>
        <template:addResources type="javascript"
                               resources="jquery.fancybox-buttons.js,jquery.fancybox-media.js,jquery.fancybox-thumbs.js"/>
        <template:addResources type="inline">
            <script type="text/javascript">
                $(document).ready(function () {
                    $(".fancybox").fancybox();
                });
            </script>
        </template:addResources>

        <c:if test="${renderContext.editMode}">
            <a class="fancybox" rel="${currentNode.name}" href="${imageFancy.node.url}"><img src="${imageFancy.node.url}" style="float: left;width:50px;"
                                                                                             alt="${imageFancy.node.displayableName}"/></a>
        </c:if>
        <c:forEach items="${jcr:getChildrenOfType(currentNode, 'jnt:sampleSingleImage')}" var="image" varStatus="status">

            <jcr:nodeProperty var="imageProp" node="${image}" name="image"/>
            <a class="fancybox" rel="${currentNode.name}"
                    <c:if test="${!renderContext.editMode}"> style="display: none"</c:if>
               href="${imageProp.node.url}"><img src="${imageProp.node.url}"
                    <c:if test="${renderContext.editMode}"> style="float: left;width:50px;"</c:if>
                                             alt="${imageProp.node.displayableName}"/></a>
        </c:forEach>
        <c:if test="${renderContext.editMode}">
            <div class="clear"></div>
            <template:module path="*" nodeTypes="jnt:sampleSingleImage"/>
        </c:if>
    </c:if>
</c:set>

<c:set var="layout" value="${currentNode.properties.layout.string}"/>
<c:set var="grid" value="${currentNode.properties.grid.string}"/>
<c:choose>
    <c:when test="${grid eq '8-4'}">
        <c:set var="textWidth" value="span8"/>
        <c:set var="imageWidth" value="span4"/>
    </c:when>
    <c:otherwise>
        <c:set var="textWidth" value="span6"/>
        <c:set var="imageWidth" value="span6"/>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${layout eq 'imageonleft'}">
        <div class="feature-item row-fluid clearfix">
            <div class="${imageWidth} clearfix fadeParent">
                    ${imagepart}
            </div>
            <div class="${textWidth}">
                    ${textpart}
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="feature-item row-fluid clearfix">
            <div class="${textWidth}">
                    ${textpart}
            </div>
            <div class="${imageWidth} clearfix fadeParent">
                    ${imagepart}
            </div>
        </div>
    </c:otherwise>
</c:choose>

