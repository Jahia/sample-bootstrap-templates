<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<fmt:message key="label.changeSaved" var="i18nSaved"/><c:set var="i18nSaved" value="${functions:escapeJavaScript(i18nSaved)}"/>
<template:addResources type="css" resources="jquery.fileupload.css"/>
<template:addResources type="javascript" resources="jquery.min.js,jquery.form.min.js,jquery.fileupload-with-ui.min.js"/>
<template:addResources>
    <script type="text/javascript">
        function updateSiteFooterLinks() {
            $('#updateSiteForm').ajaxSubmit({
                data: {'displayFooterLinks':$('#footerLinks').val()},
                dataType: "json",
                success: function(response) {
                    if (response.warn != undefined) {
                        alert(response.warn);
                    } else {
                        alert('${i18nSaved}');
                    }
                },
                error: function() {
                   //do nothing;
                }
            });
        }
    </script>
</template:addResources>
<c:set var="site" value="${renderContext.mainResource.node.resolveSite}"/>

<c:set var="displayFooterLinks" value="${site.properties['displayFooterLinks']}"/>

<h2>display footer links - ${fn:escapeXml(site.displayableName)}</h2>

<form id="updateSiteForm" action="<c:url value='${url.base}${renderContext.mainResource.node.resolveSite.path}'/>" method="post">
    <input type="hidden" name="jcrMethodToCall" value="put"/>
    <input type="hidden" name="jcr:mixinTypes" value="jmix:bootstrapTemplateCustomization"/>
    <input type="hidden" name="jcrTargetName" value="logo.png"/>
    <input type="hidden" name="jcrNodeName" value="logo.png"/>

    <label for="footerLinks" class="checkbox">
        <select id="footerLinks" name="footerLinks" onchange="updateSiteFooterLinks()">
            <option value="all">All</option>
            <option value="none">None</option>
            <option value="home">Home</option>
        </select>
    </label>
</form>

<fmt:message key="sampleBootsrapTemplate.setting.logo"/>
<img class="moduleIcon" id="moduleIcon-${currentNode.identifier}" src="${not empty icon.url ? icon.url : iconUrl}"
     alt="<fmt:message key="sampleBootsrapTemplate.logo"><fmt:param value="${title}"/></fmt:message>"/>

<form class="file_upload" id="file_upload_${currentNode.identifier}"
      action="<c:url value='${url.base}${renderContext.mainResource.node.resolveSite.path}.updateLogo.do'/>" method="POST" enctype="multipart/form-data"
      accept="application/json">
    <div id="file_upload_container-${currentNode.identifier}" class="btn btn-block">
        <input type="file" name="file" multiple>
        <button><fmt:message key="sampleBootsrapTemplate.uploadLogo"/></button>
        <div id="drop-box-file-upload-${currentNode.identifier}"><fmt:message key="sampleBootsrapTemplate.uploadLogo"/></div>
    </div>
</form>
<table id="files${currentNode.identifier}" class="table"></table>
<script>
    /*global $ */
    $(function () {
        $('#file_upload_${currentNode.identifier}').fileUploadUI({
            namespace: 'file_upload_${currentNode.identifier}',
            onComplete: function (event, files, index, xhr, handler) {
                <%--$('#fileList${renderContext.mainResource.node.identifier}').load('${targetNodePath}', function () {--%>
                <%--$('#moduleScreenshotsList').triggerHandler('uploadCompleted');--%>
                <%--});--%>
                // refresh the icon
                var response = JSON.parse(xhr.response);
                if (response.iconUpdate) {
                    d = new Date();
                    $("#moduleIcon-${currentNode.identifier}").attr("src", response.iconUrl+"?"+d.getTime());
                } else {
                    alert(response.errorMessage);
                }

            },
            acceptFileTypes: /(\.|\/)(png)$/i,
            uploadTable: $('#files${currentNode.identifier}'),
            dropZone: $('#file_upload_container-${currentNode.identifier}'),
            beforeSend: function (event, files, index, xhr, handler, callBack) {
                handler.formData = {
                    'jcrNodeType': "jnt:file",
                    'jcrNodeName': "logo.png",
                    'jcrTargetName': "logo.png",
                    'jcrReturnContentType': "json",
                    'jcrReturnContentTypeOverride': 'application/json; charset=UTF-8'
                };
                callBack();
            },
            buildUploadRow: function (files, index) {
                return $('<tr><td>' + files[index].name + '<\/td>' +
                        '<td class="file_upload_progress"><div><\/div><\/td>' + '<td class="file_upload_cancel">' +
                        '<button class="ui-state-default ui-corner-all" title="Cancel">' +
                        '<span class="ui-icon ui-icon-cancel">Cancel<\/span>' + '<\/button><\/td><\/tr>');
            }
        });
    });
</script>

