<cfoutput>
<div class="SubTitle">#qry_selectUser.firstName# #qry_selectUser.lastName# <span class="TableText">&nbsp; [<a href="#Replace(Arguments.formAction, 'viewUserActivityReport', 'viewLoginSessionsForUser', 'one')#" class="plainlink">Return to Session List</a>]</span></div>
<div class="MainText" style="font-weight: bold">#activityStruct.dateBeginDisplay# &mdash; #activityStruct.dateEndDisplay#</div>

<p>
<table border="1" cellspacing="0" cellpadding="3" class="MainText">
<tr valign="bottom" class="TableHeader">
	<th>Action</th>
	<th>##</th>
</tr>
<tr>
<tr bgcolor="ffffff" onMouseOver="bgColor='##FFFFCC'" onMouseOut="bgColor='##FFFFFF'">
	<td>Notes Recorded: </td>
	<td align="center">#noteCountAll#</td>
</tr>
<tr bgcolor="##f4f4ff" onMouseOver="bgColor='##FFFFCC'" onMouseOut="bgColor='##f4f4ff'">
	<td>Emails Sent: </td>
	<td align="center">#mailCountAll#</td>
</tr>
<tr bgcolor="ffffff" onMouseOver="bgColor='##FFFFCC'" onMouseOut="bgColor='##f4f4ff'">
	<td>Scheduled Tasks: </td>
	<td align="center">#taskCount_scheduledAll#</td>
</tr>
<tr bgcolor="##f4f4ff" onMouseOver="bgColor='##FFFFCC'" onMouseOut="bgColor='##FFFFFF'">
	<td>Tasks/Events Created: </td>
	<td align="center">#taskCount_createdAll#</td>
</tr>
<tr bgcolor="ffffff" onMouseOver="bgColor='##FFFFCC'" onMouseOut="bgColor='##f4f4ff'">
	<td>Tasks/Events Updated: </td>
	<td align="center">#taskCount_updatedAll#</td>
</tr>
<tr bgcolor="##f4f4ff" onMouseOver="bgColor='##FFFFCC'" onMouseOut="bgColor='##FFFFFF'">
	<td>Changed Status: </td>
	<td align="center">#statusHistoryCount#</td>
</tr>
</table>
</p>
</cfoutput>