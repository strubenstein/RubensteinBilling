<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listTasks")><a href="index.cfm?method=#Arguments.doControl#.listTasks#Arguments.urlParameters#" title="List existing tasks" class="SubNavLink<cfif Arguments.doAction is "listTasks">On</cfif>">List Existing Tasks</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertTask")> | <a href="index.cfm?method=#Arguments.doControl#.insertTask#Arguments.urlParameters#" title="Add new task" class="SubNavLink<cfif Arguments.doAction is "insertTask">On</cfif>">Create New Task</a></cfif>
</div><br>
</cfoutput>

