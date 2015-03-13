/**
 * ==========================================================================================
 * =                   JAHIA'S DUAL LICENSING - IMPORTANT INFORMATION                       =
 * ==========================================================================================
 *
 *     Copyright (C) 2002-2015 Jahia Solutions Group SA. All rights reserved.
 *
 *     THIS FILE IS AVAILABLE UNDER TWO DIFFERENT LICENSES:
 *     1/GPL OR 2/JSEL
 *
 *     1/ GPL
 *     ======================================================================================
 *
 *     IF YOU DECIDE TO CHOSE THE GPL LICENSE, YOU MUST COMPLY WITH THE FOLLOWING TERMS:
 *
 *     "This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License
 *     as published by the Free Software Foundation; either version 2
 *     of the License, or (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program; if not, write to the Free Software
 *     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 *     As a special exception to the terms and conditions of version 2.0 of
 *     the GPL (or any later version), you may redistribute this Program in connection
 *     with Free/Libre and Open Source Software ("FLOSS") applications as described
 *     in Jahia's FLOSS exception. You should have received a copy of the text
 *     describing the FLOSS exception, also available here:
 *     http://www.jahia.com/license"
 *
 *     2/ JSEL - Commercial and Supported Versions of the program
 *     ======================================================================================
 *
 *     IF YOU DECIDE TO CHOOSE THE JSEL LICENSE, YOU MUST COMPLY WITH THE FOLLOWING TERMS:
 *
 *     Alternatively, commercial and supported versions of the program - also known as
 *     Enterprise Distributions - must be used in accordance with the terms and conditions
 *     contained in a separate written agreement between you and Jahia Solutions Group SA.
 *
 *     If you are unsure which license is appropriate for your use,
 *     please contact the sales department at sales@jahia.com.
 *
 *
 * ==========================================================================================
 * =                                   ABOUT JAHIA                                          =
 * ==========================================================================================
 *
 *     Rooted in Open Source CMS, Jahia’s Digital Industrialization paradigm is about
 *     streamlining Enterprise digital projects across channels to truly control
 *     time-to-market and TCO, project after project.
 *     Putting an end to “the Tunnel effect”, the Jahia Studio enables IT and
 *     marketing teams to collaboratively and iteratively build cutting-edge
 *     online business solutions.
 *     These, in turn, are securely and easily deployed as modules and apps,
 *     reusable across any digital projects, thanks to the Jahia Private App Store Software.
 *     Each solution provided by Jahia stems from this overarching vision:
 *     Digital Factory, Workspace Factory, Portal Factory and eCommerce Factory.
 *     Founded in 2002 and headquartered in Geneva, Switzerland,
 *     Jahia Solutions Group has its North American headquarters in Washington DC,
 *     with offices in Chicago, Toronto and throughout Europe.
 *     Jahia counts hundreds of global brands and governmental organizations
 *     among its loyal customers, in more than 20 countries across the globe.
 *
 *     For more information, please visit http://www.jahia.com
 */
package org.jahia.module.sampleBootstrapTemplate.actions;

import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.io.FilenameUtils;
import org.apache.tika.io.IOUtils;
import org.jahia.api.Constants;
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
import java.lang.String;
import java.util.List;
import java.util.Map;

/**
 * Action to upload (and resize) site logo
 */
public class UpdateLogo extends Action {

    public static final String FILES = "files";
    public static final String BOOTSTRAP = "bootstrap";
    public static final String IMG = "img";
    public static final String LOGO_PNG = "logo.png";
    private transient static Logger logger = org.slf4j.LoggerFactory.getLogger(UpdateLogo.class);

    JahiaImageService imageService;

    @Override
    public ActionResult doExecute(HttpServletRequest req, RenderContext renderContext, Resource resource, JCRSessionWrapper session, Map<String, List<String>> parameters, URLResolver urlResolver) throws Exception {
        JCRNodeWrapper logoFolder = renderContext.getSite().getNode(FILES);
        if (logoFolder.hasNode(BOOTSTRAP)) {
            logoFolder = logoFolder.getNode(BOOTSTRAP);
        } else {
            logoFolder = logoFolder.addNode(BOOTSTRAP, Constants.JAHIANT_FOLDER);
        }
        if (logoFolder.hasNode(IMG)) {
            logoFolder = logoFolder.getNode(IMG);
        } else {
            logoFolder = logoFolder.addNode(IMG, Constants.JAHIANT_FOLDER);
        }
        JCRNodeWrapper logo;
        final FileUpload fileUpload = (FileUpload) req.getAttribute(FileUpload.FILEUPLOAD_ATTRIBUTE);
        if (fileUpload != null && fileUpload.getFileItems() != null && fileUpload.getFileItems().size() > 0) {
            final Map<String, DiskFileItem> stringDiskFileItemMap = fileUpload.getFileItems();
            DiskFileItem itemEntry = stringDiskFileItemMap.get(stringDiskFileItemMap.keySet().iterator().next());
            logo = logoFolder.uploadFile(LOGO_PNG, itemEntry.getInputStream(),
                    JCRContentUtils.getMimeType(itemEntry.getName(), itemEntry.getContentType()));
            String fileExtension = FilenameUtils.getExtension(logo.getName());

            final File f = File.createTempFile("logo", "." + fileExtension);
            imageService.createThumb(imageService.getImage(logo), f, 200, false);
            InputStream is = new FileInputStream(f);
            try {
                logo = logoFolder.uploadFile(LOGO_PNG,is,JCRContentUtils.getMimeType(itemEntry.getName(),itemEntry.getContentType()));
            } finally {
                IOUtils.closeQuietly(is);
            }
            session.save();
            return new ActionResult(HttpServletResponse.SC_OK, null, new JSONObject().put("logoUpdate", true).put("logoUrl",logo.getUrl()));
        } else {
            String error = Messages.get("resources.sample-bootstrap-templates", "sampleBootstrapTemplates.uploadLogo.error", session.getLocale());

            return new ActionResult(HttpServletResponse.SC_OK, null, new JSONObject().put("logoUpdate", false).put("errorMessage", error));
        }
    }

    public void setImageService(JahiaImageService imageService) {
        this.imageService = imageService;
    }
}

