<cfoutput>
<p class="LargeText" style="font-weight: bold">#qry_selectUser.firstName# #qry_selectUser.lastName#
<cfif qry_selectUser.companyID is Session.companyID and Application.fn_IsUserAuthorized("listLoginSessions")> <span class="TableText">[<a href="index.cfm?method=user.listLoginSessions" class="plainlink">Return to All Users</a>]</span></cfif>
</p>

<p class="TableText">
	<a href="#activityAction#" class="plainlink" title="View a summary report of activity by this user during this session. You may also specify the date range.">View Report on All Activity by this user</a> | 
	<a href="#Arguments.formAction#&viewTimesheet=True" class="plainlink" title="View user login data as timesheet report.">View in Timesheet Format</a>
</p>

<cfif qry_selectLoginSessionList.RecordCount is 0>
	<p class="ErrorMessage">There is no login history for this user.</p>
<cfelse>
	<table border="0" cellspacing="0" cellpadding="3" class="TableText">
	<tr valign="bottom" class="TableHeader" align="left">
		<th>Date</th><th>&nbsp;</th>
		<th>Login Time</th><th>&nbsp;</th>
		<th>Logout Time</th><th>&nbsp;</th>
		<th>Session Length</th><th>&nbsp;</th>
		<th>Timeout?</th><th>&nbsp;</th>
		<th>Activity<br>Report</th>
	</tr>

	<cfloop query="qry_selectLoginSessionList">
		<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="##f4f4ff"</cfif> onMouseOver="bgColor='##FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='##f4f4ff'"<cfelse>onMouseOut="bgColor='##FFFFFF'"</cfif>>
			<td>#DateFormat(qry_selectLoginSessionList.loginSessionDateBegin, "ddd, mmm dd, yyyy")#</td><td>&nbsp;</td>
			<td>#TimeFormat(qry_selectLoginSessionList.loginSessionDateBegin, "hh:mm tt")#</td><td>&nbsp;</td>
			<td><cfif qry_selectLoginSessionList.loginSessionDateEnd is "">&nbsp; -<cfelse>#TimeFormat(qry_selectLoginSessionList.loginSessionDateEnd, "hh:mm tt")#</cfif></td><td>&nbsp;</td>
			<td>
				<cfif qry_selectLoginSessionList.loginSessionDateEnd is "">
					&nbsp; -
				<cfelse>
					<cfset hourDiff = DateDiff("h", qry_selectLoginSessionList.loginSessionDateBegin, qry_selectLoginSessionList.loginSessionDateEnd)>
					<cfset minuteDiff = DateDiff("n", qry_selectLoginSessionList.loginSessionDateBegin, qry_selectLoginSessionList.loginSessionDateEnd) - (hourDiff * 60)>
					#hourDiff# hrs #minuteDiff# mins
				</cfif>
			</td><td>&nbsp;</td>
			<td><cfif qry_selectLoginSessionList.loginSessionDateEnd is "">&nbsp; -<cfelseif qry_selectLoginSessionList.loginSessionTimeout is 0>No<cfelse>Yes</cfif></td><td>&nbsp;</td>
			<td class="SmallText" align="center"><a href="#activityAction#&loginSessionID=#qry_selectLoginSessionList.loginSessionID#" class="plainlink" title="View a summary report of activity by this user during this session. You may also specify the date range.">Activity</a></td>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>