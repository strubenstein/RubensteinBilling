<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Subscription Processing Methods: </span>
<cfif Application.fn_IsUserAuthorized("listPayflows")><a href="index.cfm?method=#URL.control#.listPayflows#Variables.urlParameters#" title="List existing subscription processing methods" class="SubNavLink<cfif Variables.doAction is "listPayflows">On</cfif>">List Existing Methods</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertPayflow")> | <a href="index.cfm?method=#URL.control#.insertPayflow#Variables.urlParameters#" title="Create new subscription processing methods" class="SubNavLink<cfif Variables.doAction is "insertPayflow">On</cfif>">Create New Method</a></cfif>
<cfif URL.payflowID is not 0 and Variables.doAction is not "listPayflows">
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Processing Method:</span> <span class="SubNavName">#qry_selectPayflow.payflowName#</b><cfif qry_selectPayflow.payflowID_custom is not ""> (#qry_selectPayflow.payflowID_custom#)</cfif></span><br>
	<cfif Application.fn_IsUserAuthorized("viewPayflow")><a href="index.cfm?method=#URL.control#.viewPayflow#Variables.urlParameters#&payflowID=#URL.payflowID#" title="View summary of subscription processing method" class="SubNavLink<cfif Variables.doAction is "viewPayflow">On</cfif>">Summary</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("updatePayflow")><a href="index.cfm?method=#URL.control#.updatePayflow#Variables.urlParameters#&payflowID=#URL.payflowID#" title="Update subscription processing method" class="SubNavLink<cfif Variables.doAction is "updatePayflow">On</cfif>">Update</a> | </cfif>
	<!--- 
	<cfif Application.fn_IsUserAuthorized("insertPayflowTemplate")><a href="index.cfm?method=#URL.control#.insertPayflowTemplate#Variables.urlParameters#&payflowID=#URL.payflowID#" title="" class="SubNavLink<cfif Variables.doAction is "insertPayflowTemplate">On</cfif>">Templates</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listPayflowTemplates")><a href="index.cfm?method=#URL.control#.listPayflowTemplates#Variables.urlParameters#&payflowID=#URL.payflowID#" title="" class="SubNavLink<cfif Variables.doAction is "listPayflowTemplates">On</cfif>">Templates</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertPayflowNotify")><a href="index.cfm?method=#URL.control#.insertPayflowNotify#Variables.urlParameters#&payflowID=#URL.payflowID#" title="" class="SubNavLink<cfif Variables.doAction is "insertPayflowNotify">On</cfif>">New Notifed User</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("updatePayflowNotify")><a href="index.cfm?method=#URL.control#.updatePayflowNotify#Variables.urlParameters#&payflowID=#URL.payflowID#" title="" class="SubNavLink<cfif Variables.doAction is "updatePayflowNotify">On</cfif>">Existing Notifed Admin Users</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listPayflowNotify")><a href="index.cfm?method=#URL.control#.listPayflowNotify#Variables.urlParameters#&payflowID=#URL.payflowID#" title="" class="SubNavLink<cfif Variables.doAction is "listPayflowNotify">On</cfif>">Existing Notifed Admin Users</a> | </cfif>
	--->
	<cfif Application.fn_IsUserAuthorized("listPayflowGroups")><a href="index.cfm?method=#URL.control#.listPayflowGroups#Variables.urlParameters#&payflowID=#URL.payflowID#" title="Manage and view the groups that use this subscription processing method" class="SubNavLink<cfif Variables.doAction is "listPayflowGroups">On</cfif>">Groups</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listPayflowCompanies")><a href="index.cfm?method=#URL.control#.listPayflowCompanies#Variables.urlParameters#&payflowID=#URL.payflowID#" title="View existing customer companies that use this subscription processing method" class="SubNavLink<cfif Variables.doAction is "listPayflowCompanies">On</cfif>">Companies</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listPayflowInvoices")><a href="index.cfm?method=#URL.control#.listPayflowInvoices#Variables.urlParameters#&payflowID=#URL.payflowID#" title="View existing invoices that were processed using this subscription processing method" class="SubNavLink<cfif Variables.doAction is "listPayflowInvoices">On</cfif>">Invoices</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")><a href="index.cfm?method=payflow.insertNote#Variables.urlParameters#&payflowID=#URL.payflowID#" title="Add and view existing notes associated with this subscription processing method" class="SubNavLink<cfif FindNoCase("Note", Variables.doAction)>On</cfif>">Notes</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")><a href="index.cfm?method=payflow.listNotes#Variables.urlParameters#&payflowID=#URL.payflowID#" title="View existing notes associated with this subscription processing method" class="SubNavLink<cfif FindNoCase("Note", Variables.doAction)>On</cfif>">Notes</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertTask")><a href="index.cfm?method=payflow.insertTask#Variables.urlParameters#&payflowID=#URL.payflowID#" title="Add and view existing tasks associated with this subscription processing method" class="SubNavLink<cfif FindNoCase("Task", Variables.doAction)>On</cfif>">Tasks</a>
	  <cfelseif Application.fn_IsUserAuthorized("listTasks")><a href="index.cfm?method=payflow.listTasks#Variables.urlParameters#&payflowID=#URL.payflowID#" title="View existing tasks associated with this subscription processing method" class="SubNavLink<cfif FindNoCase("Task", Variables.doAction)>On</cfif>">Tasks</a></cfif>
</cfif>
</div><br>
</cfoutput>

