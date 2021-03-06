<%@include file="/libs/foundation/global.jsp"%>
<%@page session="false"%><%@ page import="com.day.cq.tagging.TagManager,
                 java.util.Locale,
                 java.util.ResourceBundle,
                 java.net.URLEncoder,
                 com.coresecure.tools.content.*,
				com.day.cq.wcm.api.components.*,
                 org.apache.sling.commons.json.io.JSONWriter,
                 java.io.StringWriter,
				com.day.cq.wcm.foundation.Image,
				org.apache.sling.api.resource.ValueMap,
				com.day.cq.commons.JSONItem" %>
<%@page import="java.util.*,com.day.cq.wcm.api.WCMMode"%>
<%

boolean editMode = false;
if (!(WCMMode.fromRequest(request) == WCMMode.DISABLED || WCMMode.fromRequest(request) == WCMMode.PREVIEW)) editMode = true;




String dialogPath = component.getDialogPath();

if(editMode && component.noDecoration() && editContext != null){
		StringWriter writer = new StringWriter();
		JSONWriter jsonWriter = new JSONWriter(writer);
		EditConfig editConf = editContext.getComponentContext().getEditContext().getEditConfig();
		Toolbar tb = editConf.getToolbar();

    	StringWriter writerLR = new StringWriter();
		JSONWriter jsonWriterLR = new JSONWriter(writerLR);

	    JSONItem liveRelationship = editConf.getLiveRelationship();
	    if(liveRelationship != null){
    		liveRelationship.write(jsonWriterLR);
	    }


		int idx = 0;
		String label = "";
		label += component.getTitle();	
    	String account = (String) request.getAttribute("account");
    	label += " | Account: "+account;
    	tb.add(0,new Toolbar.Label(label));
		tb.add(1,new Toolbar.Separator());
        editConf.write(jsonWriter);

	%>
	<div>
        <script type="text/javascript">
            CQ.WCM.edit({
                "path": "<%=resource.getPath()%>",
                "dialog": "<%=dialogPath%>",
                "type": "<%=resource.getResourceType()%>",
                "editConfig": <%=writer.toString()%>
                <c:if test="<%= liveRelationship != null%>">
                ,
                "msm:liveRelationship": <%= writerLR.toString() %>
		        </c:if>
            });
        </script>
	</div>
<%}%>