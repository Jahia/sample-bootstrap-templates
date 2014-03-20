<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="propertyDefinition" type="org.jahia.services.content.nodetypes.ExtendedPropertyDefinition"--%>
<%--@elvariable id="type" type="org.jahia.services.content.nodetypes.ExtendedNodeType"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<jcr:nodeProperty var="folder" node="${currentNode}" name="folder"/>
<c:choose>
    <c:when test="${! empty folder.node}">
        <div>
            <div class="flexslider carousel">
                <c:forEach items="${jcr:getChildrenOfType(folder.node, 'jmix:image')}" var="image" varStatus="status">
                    <c:choose>
                        <c:when test="${jcr:isNodeType(image, 'jmix:thumbnail')}">
                            <a class="fancy" rel="${image.parent.name}" href="${image.url}"><img src="${image.thumbnailUrls['thumbnail']}" alt="${image.properties['image'].node.displayableName}" /><span class="fancy-more"></span></a>
                        </c:when>
                        <c:otherwise>
                            <a class="fancy" rel="${image.parent.name}" href="${image.url}"><img src="${image.url}" alt="${image.properties['image'].node.displayableName}" /><span class="fancy-more"></span></a>    </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </div>
        <template:addResources type="css" resources="fancy-image.css"/>


        <%-- Add mousewheel plugin (this is optional) --%>
        <template:addResources type="javascript" resources="jquery.mousewheel-3.0.6.pack.js"/>

        <%-- Add fancyBox --%>
        <template:addResources type="css" resources="jquery.fancybox.css"/>
        <template:addResources type="javascript" resources="jquery.fancybox.js"/>


        <%-- Optionally add helpers - button, thumbnail and/or media --%>
        <template:addResources type="css" resources="jquery.fancybox-buttons.css,jquery.fancybox-thumbs.css"/>
        <template:addResources type="javascript"
                               resources="jquery.fancybox-buttons.js,jquery.fancybox-media.js,jquery.fancybox-thumbs.js"/>
        <template:addResources type="inline">
            <script type="text/javascript">
                $(document).ready(function () {
                    $(".fancy").fancybox();
                });
            </script>
        </template:addResources>
    </c:when>
    <c:otherwise>
        <c:if test="${renderContext.editMode}">
            <div class="span12">
                <div class="alert">
                    <button type="button" class="close" data-dismiss="alert">x</button>
                    <strong><fmt:message key="label.message.warning"/>!</strong> Could not open folder.
                </div>
            </div>
        </c:if>
    </c:otherwise>
</c:choose>
