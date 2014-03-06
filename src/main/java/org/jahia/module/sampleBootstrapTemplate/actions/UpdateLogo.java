package org.jahia.module.sampleBootstrapTemplate.actions;

import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.io.FilenameUtils;
import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRContentUtils;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.image.JahiaImageService;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.jahia.tools.files.FileUpload;
import org.jahia.utils.i18n.Messages;
import org.json.JSONObject;
import org.slf4j.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by david on 3/6/14.
 */
public class UpdateLogo extends Action {

    private transient static Logger logger = org.slf4j.LoggerFactory.getLogger(UpdateLogo.class);

    JahiaImageService imageService;

    @Override
    public ActionResult doExecute(HttpServletRequest req, RenderContext renderContext, Resource resource, JCRSessionWrapper session, Map<String, List<String>> parameters, URLResolver urlResolver) throws Exception {
        // cleanup folder logo
        if (  renderContext.getSite().getNode("files").hasNode("logo")) {
            renderContext.getSite().getNode("files").getNode("logo").remove();
        }
        JCRNodeWrapper logoFolder =  createNode(req, new HashMap<String, List<String>>(),renderContext.getSite().getNode("files"),"jnt:folder","logo",true);
        JCRNodeWrapper logo;
        final FileUpload fileUpload = (FileUpload) req.getAttribute(FileUpload.FILEUPLOAD_ATTRIBUTE);
        if (fileUpload != null && fileUpload.getFileItems() != null && fileUpload.getFileItems().size() > 0) {
            final Map<String, DiskFileItem> stringDiskFileItemMap = fileUpload.getFileItems();
            DiskFileItem itemEntry = stringDiskFileItemMap.get(stringDiskFileItemMap.keySet().iterator().next());
            logo = logoFolder.uploadFile(itemEntry.getName(), itemEntry.getInputStream(),
                    JCRContentUtils.getMimeType(itemEntry.getName(), itemEntry.getContentType()));
            String fileExtension = FilenameUtils.getExtension(logo.getName());

            final File f = File.createTempFile("logo", "." + fileExtension);
            imageService.createThumb(imageService.getImage(logo), f, 200, false);
            InputStream is = new FileInputStream(f);
            logo = logoFolder.uploadFile(itemEntry.getName(),is,JCRContentUtils.getMimeType(itemEntry.getName(),itemEntry.getContentType()));
            is.close();
            session.save();
            return new ActionResult(HttpServletResponse.SC_OK, null, new JSONObject().put("logoUpdate", true).put("logoUrl",logo.getUrl()));
        } else {
            String error = Messages.get("resources.sample-bootstrap-templates", ".updateIcon.error.wrong.format", session.getLocale());

            return new ActionResult(HttpServletResponse.SC_OK, null, new JSONObject().put("logoUpdate", false).put("errorMessage",error));
        }
    }

    public void setImageService(JahiaImageService imageService) {
        this.imageService = imageService;
    }
}

