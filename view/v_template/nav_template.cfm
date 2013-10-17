<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Templates: </span>
<cfif Application.fn_IsUserAuthorized("listTemplates")><a href="index.cfm?method=template.listTemplates" title="List existing templates of all types" class="SubNavLink<cfif Variables.doAction is "listTemplates">On</cfif>">List Existing Templates</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertTemplate")> | <a href="index.cfm?method=template.insertTemplate" title="Add new template (must exist in file system first)" class="SubNavLink<cfif Variables.doAction is "insertTemplate">On</cfif>">Add New Template</a></cfif>
</div><br>
</cfoutput>
