<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Contact Management Templates: </span>
<cfif Application.fn_IsUserAuthorized("listContactTemplates")><a href="index.cfm?method=contactTemplate.listContactTemplates" title="List all existing contact management templates" class="SubNavLink<cfif Variables.doAction is "listContactTemplates">On</cfif>">List Existing Templates</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertContactTemplate")> | <a href="index.cfm?method=contactTemplate.insertContactTemplate" title="Create new contact management template" class="SubNavLink<cfif Variables.doAction is "insertContactTemplate">On</cfif>">Add New Template</a></cfif>
<cfif Application.fn_IsUserAuthorized("viewContactTemplateFields")> | <a href="index.cfm?method=contactTemplate.viewContactTemplateFields" title="View the list of fields that can automatically be included in contact management templates" class="SubNavLink<cfif Variables.doAction is "viewContactTemplateFields">On</cfif>">View Available Template Fields</a></cfif>
</div><br>
</cfoutput>

