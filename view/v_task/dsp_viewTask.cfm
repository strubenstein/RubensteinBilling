<cfoutput>
<cfif qry_selectTask.taskStatus is 0>
	<p class="MainText" style="color: red">This task is currently ignored.</p>
</cfif>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif StructKeyExists(taskStruct, "authorRow")>
	<tr valign="top">
		<td>Created By: </td>
		<td>#qry_selectUserList.lastName[taskStruct.authorRow]#, #qry_selectUserList.firstName[taskStruct.authorRow]#</td>
	</tr>
</cfif>
<tr valign="top">
	<td>Created On: </td>
	<td>#DateFormat(qry_selectTask.taskDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectTask.taskDateCreated, "hh:mm tt")#</td>
</tr>
<cfif qry_selectTask.companyID_target is not 0 and qry_selectCompany.RecordCount is not 0>
	<tr>
		<td>Target Company: </td>
		<td>#qry_selectCompany.companyName#</td>
	</tr>
</cfif>
<cfif StructKeyExists(taskStruct, "targetRow")>
	<tr>
		<td>Target User: </td>
		<td>#qry_selectUserList.firstName# #qry_selectUserList.lastName#</td>
	</tr>
</cfif>
<tr>
	<td>Scheduled Date: </td>
	<td><cfif Not IsDate(qry_selectTask.taskDateScheduled)>(No scheduled date)<cfelse>#DateFormat(qry_selectTask.taskDateScheduled, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectTask.taskDateScheduled, "hh:mm tt")#</cfif></td>
</tr>
<tr>
	<td>Status: </td>
	<td><cfif qry_selectTask.taskCompleted is 0><div style="color: red">Not Completed</div><cfelse><div style="color: green">Completed</div></cfif></td>
</tr>
<tr valign="top">
	<td>Assigned To: </td>
	<td><cfif Not StructKeyExists(taskStruct, "agentRow")>(not assigned)<cfelse>#qry_selectUserList.lastName[taskStruct.agentRow]#, #qry_selectUserList.firstName[taskStruct.agentRow]#</cfif></td>
</tr>
<tr>
	<td valign="top">Description:</td>
	<td><div class="TableText" style="width: 400">#Replace(qry_selectTask.taskMessage, Chr(10), "<br>", "all")#</div></td>
</tr>
</table>
</cfoutput>
