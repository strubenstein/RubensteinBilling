<cfoutput>
<div class="SubNav">
<cfif URL.control is "customField">
	<span class="SubNavTitle">Custom Fields: </span>
	<cfif Application.fn_IsUserAuthorized("listCustomFields")><a href="index.cfm?method=customField.listCustomFields" title="List existing custom fields by data type" class="SubNavLink<cfif Variables.doAction is "listCustomFields">On</cfif>">List Existing Custom Fields by Type</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listCustomFieldTargets")> | <a href="index.cfm?method=customField.listCustomFieldTargets" title="List existing custom fields by the target(s) they apply to" class="SubNavLink<cfif Variables.doAction is "listCustomFieldTargets">On</cfif>">List Existing Custom Fields by Target</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertCustomField")> | <a href="index.cfm?method=customField.insertCustomField" title="Create new custom field. Data type and target(s) are specified on the form." class="SubNavLink<cfif Variables.doAction is "insertCustomField">On</cfif>">Create New Custom Field</a></cfif>
</cfif>
</div><br>
</cfoutput>

