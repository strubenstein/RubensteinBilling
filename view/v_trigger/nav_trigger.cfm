<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Triggers: </span>
<cfif Application.fn_IsUserAuthorized("listTriggerActions")><a href="index.cfm?method=trigger.listTriggerActions" title="List all triggers and trigger-enabled actions" class="SubNavLink<cfif Variables.doAction is "listTriggerActions">On</cfif>">List Existing Triggers &amp; Enabled Actions</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertTriggerAction")> | <a href="index.cfm?method=trigger.insertTriggerAction" title="Add new trigger action" class="SubNavLink<cfif Variables.doAction is "insertTriggerAction">On</cfif>">Trigger-Enable New Action</a></cfif>
</div><br>
</cfoutput>

