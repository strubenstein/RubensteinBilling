<cfoutput>
<div class="SubNav">
<cfif URL.control is not "image">
	<cfif Application.fn_IsUserAuthorized("listImages")><a href="index.cfm?method=#URL.control#.listImages#Variables.urlParameters#" title="List existing images and thumbnails" class="SubNavLink<cfif Variables.doAction is "listImages">On</cfif>">List Existing Images</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertImage")> | <a href="index.cfm?method=#URL.control#.insertImage#Variables.urlParameters#" title="Add/Upload a new image and optional thumbnail" class="SubNavLink<cfif Variables.doAction is "insertImage">On</cfif>">Add New Image</a></cfif>
</cfif>
</div><br>
</cfoutput>
