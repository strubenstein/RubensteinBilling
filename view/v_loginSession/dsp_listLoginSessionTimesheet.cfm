<cfoutput>
<p class="LargeText" style="font-weight: bold">#qry_selectUser.firstName# #qry_selectUser.lastName#
<cfif qry_selectUser.companyID is Session.companyID and Application.fn_IsUserAuthorized("listLoginSessions")> <span class="TableText">[<a href="index.cfm?method=user.listLoginSessions" class="plainlink">Return to All Users</a>]</span></cfif>
</p>

<p class="TableText">
	<a href="#activityAction#" class="plainlink" title="View a summary report of activity by this user during this session. You may also specify the date range.">View Report on All Activity by this user</a> | 
	<a href="#Arguments.formAction#" class="plainlink" title="View user login data as list report.">View in List Format</a>
</p>

<cfif qry_selectLoginSessionList.RecordCount is 0>
	<p class="ErrorMessage">There is no login history for this user.</p>
<cfelse>
	<table border="1" cellspacing="0" cellpadding="3" class="TableText">
	<tr class="TableHeader" align="left">
		<th>Month</th>
		<th>Total</th>
	</tr>
	<cfset timeStruct.row = 0>
	<cfloop index="monthKey" list="#timeStruct.monthList#">
		<cfset timeStruct.row += 1>
		<cfset timeStruct.thisMonthFirst = CreateDate(Mid(monthKey, 6, 4), Right(monthKey, 2), 1)>
		<cfset timeStruct.thisMonthLast = CreateDate(Mid(monthKey, 6, 4), Right(monthKey, 2), DaysInMonth(timeStruct.thisMonthFirst))>
		<tr valign="top"<cfif (timeStruct.row mod 2) is 0> bgcolor="##f4f4ff"</cfif> onMouseOver="bgColor='##FFFFCC'" <cfif (timeStruct.row mod 2) is 0>onMouseOut="bgColor='##f4f4ff'"<cfelse>onMouseOut="bgColor='##FFFFFF'"</cfif>>
		<td><a href="#activityAction#&userActivityDateBegin=#URLEncodedFormat(DateFormat(timeStruct.thisMonthFirst, 'mm/dd/yyyy'))#&userActivityDateEnd=#URLEncodedFormat(DateFormat(timeStruct.thisMonthLast, 'mm/dd/yyyy'))#" class="plainlink" style="color: black" title="View user activity report for this user for #MonthAsString(Right(monthKey, 2))# #Mid(monthKey, 6, 4)#">#MonthAsString(Right(monthKey, 2))# #Mid(monthKey, 6, 4)#</a></td>
		<td><a href="#Arguments.formAction#&loginSessionDateBegin_from=#URLEncodedFormat(DateFormat(timeStruct.thisMonthFirst, 'mm/dd/yyyy'))#&loginSessionDateBegin_to=#URLEncodedFormat(DateFormat(timeStruct.thisMonthLast, 'mm/dd/yyyy'))#" class="plainlink" style="color: black" title="List all login sessions for this user for #MonthAsString(Right(monthKey, 2))# #Mid(monthKey, 6, 4)#">#Application.fn_SetDecimalPrecision(timeStruct[monthKey], 2)#</a></td>
		</tr>
	</cfloop>
	</table>

	<p>
	<table border="1" cellspacing="0" cellpadding="3" class="TableText">
	<tr valign="bottom" class="TableHeader">
		<th width="70">Sun</th>
		<th width="70">Mon</th>
		<th width="70">Tue</th>
		<th width="70">Wed</th>
		<th width="70">Thu</th>
		<th width="70">Fri</th>
		<th width="70">Sat</th>
	</tr>

	<cfloop index="weekCount" from="1" to="#timeStruct.weekCount#">
		<cfset timeStruct.thisSunday = DateAdd("ww", -1 * DecrementValue(weekCount), timeStruct.firstSunday)>
		<cfset timeStruct.thisTotal = 0>
		<tr valign="top" bgcolor="##f4f4ff">
			<cfloop index="dayCount" from="0" to="6">
				<cfset timeStruct.thisDay = DateAdd("d", dayCount, timeStruct.thisSunday)>
				<th><a href="#activityAction#&userActivityDateBegin=#URLEncodedFormat(DateFormat(timeStruct.thisDay, 'mm/dd/yyyy'))#&userActivityDateEnd=#URLEncodedFormat(DateFormat(timeStruct.thisDay, 'mm/dd/yyyy'))#" class="plainlink" style="color: black" title="View user activity report for this user for #DateFormat(timeStruct.thisDay, 'mm/dd/yyyy')#">#DateFormat(timeStruct.thisDay, "m/d")#</a></th>
			</cfloop>
			<th width="70" bgcolor="lime"><a href="#activityAction#&userActivityDateBegin=#URLEncodedFormat(DateFormat(timeStruct.thisSunday, 'mm/dd/yyyy'))#&userActivityDateEnd=#URLEncodedFormat(DateFormat(timeStruct.thisDay, 'mm/dd/yyyy'))#" class="plainlink" style="color: black" title="View user activity report for this user for the week #DateFormat(timeStruct.thisSunday, 'mm/dd/yyyy')# thru #DateFormat(timeStruct.thisDay, 'mm/dd/yyyy')#">Total</a></th>
		</tr>
		<tr valign="top">
			<cfloop index="dayCount" from="0" to="6">
				<cfset timeStruct.thisDay = DateAdd("d", dayCount, timeStruct.thisSunday)>
				<cfset timeKey = "date" & DateFormat(timeStruct.thisDay, "yyyymmdd")>
				<cfif StructKeyExists(timeStruct, timeKey)><cfset timeStruct.thisHours = timeStruct[timeKey]><cfelse><cfset timeStruct.thisHours = 0></cfif>
				<cfset timeStruct.thisTotal += timeStruct.thisHours>
				<td align="center" onMouseOver="bgColor='##FFFFCC'" onMouseOut="bgColor='##FFFFFF'"><a href="#Arguments.formAction#&loginSessionDateBegin_from=#URLEncodedFormat(DateFormat(timeStruct.thisDay, 'mm/dd/yyyy'))#&loginSessionDateBegin_to=#URLEncodedFormat(DateFormat(timeStruct.thisDay, 'mm/dd/yyyy'))#" class="plainlink" style="color: black" title="List all login sessions for this user for #DateFormat(timeStruct.thisDay, 'mm/dd/yyyy')#">#Application.fn_SetDecimalPrecision(timeStruct.thisHours, 2)#</a></td>
			</cfloop>
			<th class="TableHeader" align="center"><a href="#Arguments.formAction#&loginSessionDateBegin_from=#URLEncodedFormat(DateFormat(timeStruct.thisSunday, 'mm/dd/yyyy'))#&loginSessionDateBegin_to=#URLEncodedFormat(DateFormat(timeStruct.thisDay, 'mm/dd/yyyy'))#" class="plainlink" style="color: black" title="List all login sessions for this user for the week #DateFormat(timeStruct.thisSunday, 'mm/dd/yyyy')# thru #DateFormat(timeStruct.thisDay, 'mm/dd/yyyy')#">#Application.fn_SetDecimalPrecision(timeStruct.thisTotal, 2)#</a></th>
		</tr>
		<cfif weekCount is not timeStruct.weekCount>
			<tr><td colspan="8" height="3" bgcolor="##dddddd"><img src="#Application.billingUrlRoot#/images/blank.gif" height="1" width="20" border="0"></td></tr>
		</cfif>
	</cfloop>

	<tr valign="bottom" class="TableHeader">
		<th width="70">Sun</th>
		<th width="70">Mon</th>
		<th width="70">Tue</th>
		<th width="70">Wed</th>
		<th width="70">Thu</th>
		<th width="70">Fri</th>
		<th width="70">Sat</th>
	</tr>
	</table>
	</p>

	<p>
	<table border="0" cellspacing="0" cellpadding="3" class="TableText">
	<tr class="TableHeader" align="left"><th>To View ... </th><th>For Time Period ...</th><th>Click ...</th></tr>
	<tr><td>Login Records</td><td align="center">Day/Month</td><td>Hours for that day/month</td></tr>
	<tr bgcolor="##f4f4ff"><td>Login Records</td><td align="center">Week</td><td>Total hours for that week</td></tr>
	<tr><td>Activity Report</td><td align="center">Day/Month</td><td>That date/month</td></tr>
	<tr bgcolor="##f4f4ff"><td>Activity Report</td><td align="center">Week</td><td><i>Total</i> text for that week</td></tr>
	</table>
	</p>
</cfif>
</cfoutput>