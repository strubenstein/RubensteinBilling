<cfoutput>
<div class="SubTitle">Current Admin Sessions</div>

<p class="TableText">
	<a href="#listAction#&viewUsers=all" class="plainlink"<cfif URL.viewUsers is "all"> style="font-weight: bold"</cfif>>View All Users</a> | 
	<a href="#listAction#&viewUsers=current" class="plainlink"<cfif URL.viewUsers is "current"> style="font-weight: bold"</cfif>>Currently Logged In Users</a> | 
	<a href="#listAction#&viewUsers=ever" class="plainlink"<cfif URL.viewUsers is "ever"> style="font-weight: bold"</cfif>>Users Who Have Logged In At Least Once</a>
</p>

<p>
#fn_DisplayCurrentRecordNumbers(listAction, URL.queryOrderBy, "<br>", methodStruct.columnCount, 0, 0, 0, methodStruct.columnHeaderList, methodStruct.columnOrderByList, True)#
<cfloop query="qry_selectLoginSessionList">
	<tr valign="top" class="TableText"<cfif (CurrentRow mod 2) is 0> bgcolor="##f4f4ff"</cfif> onMouseOver="bgColor='##FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='##f4f4ff'"<cfelse>onMouseOut="bgColor='##FFFFFF'"</cfif>>
	<td class="SubTitle" style="color: green"><cfif qry_selectLoginSessionList.loginSessionDateBegin is not "" and qry_selectLoginSessionList.loginSessionDateEnd is "">*<cfelse>&nbsp;</cfif></td><td>&nbsp;</td>
	<td class="MainText"><a href="#Arguments.formAction#&userID=#qry_selectLoginSessionList.userID#" class="plainlink" title="View the list of login sessions for this user">#qry_selectLoginSessionList.lastName#, #qry_selectLoginSessionList.firstName#</a></td><td>&nbsp;</td>
	<td><cfif qry_selectLoginSessionList.loginSessionDateBegin is "">&nbsp; -<cfelse>#DateFormat(qry_selectLoginSessionList.loginSessionDateBegin, "ddd, mm/dd/yy")# at #TimeFormat(qry_selectLoginSessionList.loginSessionDateBegin, "hh:mm tt")#</cfif></td><td>&nbsp;</td>
	<td><cfif qry_selectLoginSessionList.loginSessionDateEnd is "">&nbsp; -<cfelse>#DateFormat(qry_selectLoginSessionList.loginSessionDateEnd, "ddd, mm/dd/yy")# at #TimeFormat(qry_selectLoginSessionList.loginSessionDateEnd, "hh:mm tt")#</cfif></td><td>&nbsp;</td>
	<td>
		<cfif qry_selectLoginSessionList.loginSessionDateBegin is "">
			&nbsp; -
		<cfelseif qry_selectLoginSessionList.loginSessionDateEnd is not "">
			<cfset hourDiff = DateDiff("h", qry_selectLoginSessionList.loginSessionDateBegin, qry_selectLoginSessionList.loginSessionDateEnd)>
			<cfset minuteDiff = DateDiff("n", qry_selectLoginSessionList.loginSessionDateBegin, qry_selectLoginSessionList.loginSessionDateEnd) - (hourDiff * 60)>
			#hourDiff# hrs #minuteDiff# mins
		<cfelse>
			<cfset hourDiff = DateDiff("h", qry_selectLoginSessionList.loginSessionDateBegin, Now())>
			<cfset minuteDiff = DateDiff("n", qry_selectLoginSessionList.loginSessionDateBegin, Now()) - (hourDiff * 60)>
			#hourDiff# hrs #minuteDiff# mins
		</cfif>
	</td><td>&nbsp;</td>
	<td><cfif qry_selectLoginSessionList.loginSessionDateBegin is "" or qry_selectLoginSessionList.loginSessionDateEnd is "">&nbsp; -<cfelseif qry_selectLoginSessionList.loginSessionTimeout is 0>No<cfelse>Yes</cfif></td><td>&nbsp;</td>
	<td class="SmallText"><cfif qry_selectLoginSessionList.loginSessionDateBegin is "" or qry_selectLoginSessionList.loginSessionDateEnd is not "">&nbsp; -<cfelse><a href="#listAction#&updateLoginSession=True&userID=#qry_selectLoginSessionList.userID#&loginSessionID=#qry_selectLoginSessionList.loginSessionID#" class="plainlink" title="Log this user out so they can log back in">Logout</a></cfif></td><td>&nbsp;</td>
	<td class="SmallText"><a href="#activityAction#&userID=#qry_selectLoginSessionList.userID#" class="plainlink" title="View a summary report of all activity by this user since the beginning. For a session-based report, first click to view their sessions. You may also specify the date range.">Activity</a></td>
	</tr>
</cfloop>

<!---
<cfloop query="qry_selectUserList">
	<cfif StructKeyExists(userRowStruct, "user#qry_selectUserList.userID#")><cfset userRow = userRowStruct["user#qry_selectUserList.userID#"]><cfelse><cfset userRow = 0></cfif>
	<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="##f4f4ff"</cfif> onMouseOver="bgColor='##FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='##f4f4ff'"<cfelse>onMouseOut="bgColor='##FFFFFF'"</cfif>>
	<td class="SubTitle" style="color: green"><cfif userRow is not 0 and qry_selectLoginSessionList.loginSessionDateEnd[userRow] is "">*<cfelse>&nbsp;</cfif></td><td>&nbsp;</td>
	<td class="MainText"><a href="#Arguments.formAction#&userID=#qry_selectUserList.userID#" class="plainlink" title="View the list of login sessions for this user">#qry_selectUserList.lastName#, #qry_selectUserList.firstName#</a></td><td>&nbsp;</td>
	<cfif userRow is 0>
		<td>&nbsp; -</td><td>&nbsp;</td>
		<td>&nbsp; -</td><td>&nbsp;</td>
		<td>&nbsp; -</td><td>&nbsp;</td>
		<td>&nbsp; -</td><td>&nbsp;</td>
		<td>&nbsp; -</td><td>&nbsp;</td>
	<cfelse>
		<td>#DateFormat(qry_selectLoginSessionList.loginSessionDateBegin[userRow], "ddd, mm/dd/yy")# at #TimeFormat(qry_selectLoginSessionList.loginSessionDateBegin[userRow], "hh:mm tt")#</td><td>&nbsp;</td>
		<td><cfif qry_selectLoginSessionList.loginSessionDateEnd[userRow] is "">&nbsp; -<cfelse>#DateFormat(qry_selectLoginSessionList.loginSessionDateEnd[userRow], "ddd, mm/dd/yy")# at #TimeFormat(qry_selectLoginSessionList.loginSessionDateEnd[userRow], "hh:mm tt")#</cfif></td><td>&nbsp;</td>
		<td>
			<cfif qry_selectLoginSessionList.loginSessionDateEnd[userRow] is "">
				&nbsp; -
			<cfelse>
				<cfset hourDiff = DateDiff("h", qry_selectLoginSessionList.loginSessionDateBegin[userRow], qry_selectLoginSessionList.loginSessionDateEnd[userRow])>
				<cfset minuteDiff = DateDiff("n", qry_selectLoginSessionList.loginSessionDateBegin[userRow], qry_selectLoginSessionList.loginSessionDateEnd[userRow]) - (hourDiff * 60)>
				#hourDiff# hrs #minuteDiff# mins
			</cfif>
		</td><td>&nbsp;</td>
		<td><cfif qry_selectLoginSessionList.loginSessionDateEnd[userRow] is "">&nbsp; -<cfelseif qry_selectLoginSessionList.loginSessionTimeout[userRow] is 0>No<cfelse>Yes</cfif></td><td>&nbsp;</td>
		<td class="SmallText"><cfif qry_selectLoginSessionList.loginSessionDateEnd[userRow] is not "">&nbsp; -<cfelse><a href="#listAction#&updateLoginSession=True&userID=#qry_selectLoginSessionList.userID[userRow]#&loginSessionID=#qry_selectLoginSessionList.loginSessionID[userRow]#" class="plainlink" title="Log this user out so they can log back in">Logout</a></cfif></td><td>&nbsp;</td>
	</cfif>
	<td class="SmallText"><a href="#activityAction#&userID=#qry_selectUserList.userID#" class="plainlink" title="View a summary report of all activity by this user since the beginning. For a session-based report, first click to view their sessions. You may also specify the date range.">Activity</a></td>
	</tr>
</cfloop>
--->
</table>
</p>
</cfoutput>