<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<bootstrap:addCSS/>
<template:addResources type="css" resources="languageSwitchingLinks.css"/>
<template:addResources type="javascript" resources="bootstrap-dropdown.js"/>
<c:set var="linkKind" value="${currentNode.properties.typeOfDisplay.string}"/>
<c:set var="flag" value="${linkKind eq 'flag'}"/>

<ui:initLangBarAttributes activeLanguagesOnly="${renderContext.liveMode}"/>
<div class="btn-group btn-mini">
    <c:forEach items="${requestScope.languageCodes}" var="language">
        <c:if test="${language eq currentResource.locale}">
            <ui:displayLanguageSwitchLink languageCode="${language}" display="false" urlVar="switchUrl"
                                          var="renderedLanguage"
                                          linkKind="${currentNode.properties.typeOfDisplay.string}"/>
            <c:if test="${language eq currentResource.locale}">
                <c:if test="${flag}">
                    <c:set var="renderedLanguage">
                        <span class='flag ${functions:getLanguageFlagCSSClass(functions:toLocale(language))}'></span>
                    </c:set>
                </c:if>
                <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#">${renderedLanguage}<span
                        class="caret"></span></a>
            </c:if>
        </c:if>
    </c:forEach>
    <ul class="dropdown-menu">
        <c:forEach items="${requestScope.languageCodes}" var="language">
            <c:if test="${ language ne currentResource.locale}">
                <ui:displayLanguageSwitchLink languageCode="${language}" display="false" urlVar="switchUrl"
                                              var="renderedLanguage"
                                              linkKind="${currentNode.properties.typeOfDisplay.string}"/>
                <c:set var="thisLocale" value="${functions:toLocale(language)}"/>

                <c:if test="${flag}">
                    <c:set var="renderedLanguage">
                        <span class='flag ${functions:getLanguageFlagCSSClass(thisLocale)}'> ${functions:displayLocaleNameWith(thisLocale, thisLocale)}</span>
                    </c:set>
                </c:if>
                <li><a title="<fmt:message key='switchTo'/>"
                       href="<c:url context='/' value='${switchUrl}'/>">${renderedLanguage}</a>
                </li>
            </c:if>
        </c:forEach>
    </ul>
</div>
