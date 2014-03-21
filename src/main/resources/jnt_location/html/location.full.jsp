<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>

<c:set var="props" value="${currentNode.propertiesAsString}"/>

<address>
    <strong>${fn:escapeXml(props['jcr:title'])}</strong><br>

        ${fn:escapeXml(props['j:street'])}
    <br>
        ${fn:escapeXml(props['j:zipCode'])}
    <br>
        ${fn:escapeXml(props['j:town'])}
    <br>
        <jcr:nodePropertyRenderer name="j:country" node="${currentNode}" renderer="country" var="country"/>${fn:escapeXml(country.displayName)}
    <br>
        ${fn:escapeXml(props['j:latitude'])}
    <br>
        ${fn:escapeXml(props['j:longitude'])}
    <br>
</address>