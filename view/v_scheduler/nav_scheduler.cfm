<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Scheduled Tasks: </span>
<cfif Application.fn_IsUserAuthorized("listSchedulers")><a href="index.cfm?method=scheduler.listSchedulers" title="List existing scheduled tasks" class="SubNavLink<cfif Variables.doAction is "listSchedulers">On</cfif>">List Scheduled Tasks</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertScheduler")> | <a href="index.cfm?method=scheduler.insertScheduler" title="Create new scheduled task" class="SubNavLink<cfif Variables.doAction is "insertScheduler">On</cfif>">Create New Scheduled Task</a></cfif>
<cfif URL.schedulerID is not 0 and Variables.doAction is not "listSchedulers">
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<div class="SubNavObject"><b><i>Scheduled Task</i>: #qry_selectScheduler.schedulerName#</b></b></div>
	<!--- 
	<cfif Application.fn_IsUserAuthorized("viewScheduler")><a href="index.cfm?method=scheduler.viewScheduler&schedulerID=#URL.schedulerID#" title="View scheduled task" class="SubNavLink<cfif Variables.doAction is "viewScheduler">On</cfif>">View</a></cfif>
	--->
	<cfif Application.fn_IsUserAuthorized("updateScheduler")><!---  | ---><a href="index.cfm?method=scheduler.updateScheduler&schedulerID=#URL.schedulerID#" title="Update scheduled task options/status" class="SubNavLink<cfif Variables.doAction is "updateScheduler">On</cfif>">Update</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")> | <a href="index.cfm?method=scheduler.insertNote&schedulerID=#URL.schedulerID#" title="Add and view notes associated with this scheduled task" class="SubNavLink<cfif FindNoCase("Note", Variables.doAction)>On</cfif>">Notes</a>
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")> | <a href="index.cfm?method=scheduler.listNotes&schedulerID=#URL.schedulerID#" title="View notes associated with this scheduled task" class="SubNavLink<cfif FindNoCase("Note", Variables.doAction)>On</cfif>">Notes</a></cfif>
	</div>
</cfif>
</div><br>
</cfoutput>

