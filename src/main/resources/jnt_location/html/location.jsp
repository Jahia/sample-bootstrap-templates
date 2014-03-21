<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>

<c:set var="props" value="${currentNode.propertiesAsString}"/>

<address>
    <c:if test="${not empty props['jcr:title']}">
        <strong>${fn:escapeXml(props['jcr:title'])}</strong><br>
    </c:if>

    <c:if test="${not empty props['j:street']}">
        ${fn:escapeXml(props['j:street'])}
    </c:if>
    <c:if test="${not empty props['j:zipCode'] || not empty props['j:town']}">
        <br>
            <c:if test="${not empty props['j:zipCode']}">
                ${fn:escapeXml(props['j:zipCode'])}&nbsp;
            </c:if>
            ${not empty props['j:town'] ? fn:escapeXml(props['j:town']) : ''}
    </c:if>
        <br>
        <jcr:nodePropertyRenderer name="j:country" node="${currentNode}" renderer="country" var="country"/>${fn:escapeXml(country.displayName)}
</address>