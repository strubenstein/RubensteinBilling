<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Primary Targets: </span>
<cfif Application.fn_IsUserAuthorized("listPrimaryTargets")><a href="index.cfm?method=primaryTarget.listPrimaryTargets" title="List existing primary targets" class="SubNavLink<cfif Variables.doAction is "listPrimaryTargets">On</cfif>">List Existing Primary Targets</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertPrimaryTarget")> | <a href="index.cfm?method=primaryTarget.insertPrimaryTarget" title="Create new primary target" class="SubNavLink<cfif Variables.doAction is "insertPrimaryTarget">On</cfif>">Create New Primary Target</a></cfif>
</div><br>
</cfoutput>

