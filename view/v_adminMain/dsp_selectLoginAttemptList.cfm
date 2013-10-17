<cfoutput>
<cfif qry_selectLoginAttemptList.RecordCount is 0>
	<p class="ErrorMessage">No users have been disabled within the past 24 hours because of consecutive unsuccessful logins.</p>
<cfelse>
	<p>
	<cfset Variables.count = 1>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
	<cfloop Query="qry_selectLoginAttemptList">
		<cfif CurrentRow gt 1 and qry_selectLoginAttemptList.loginAttemptUsername is qry_selectLoginAttemptList.loginAttemptUsername[CurrentRow - 1]>
			<cfset Variables.sameUsername = True>
		<cfelse>
			<cfset Variables.count = Variables.count + 1>
			<cfset Variables.sameUsername = False>
		</cfif>
		<tr class="TableText" valign="top"<cfif (Variables.count mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (Variables.count mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td><cfif Variables.sameUsername is True>&nbsp; &quot;<cfelse>#qry_selectLoginAttemptList.loginAttemptUsername#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectLoginAttemptList.loginAttemptCount#</td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectLoginAttemptList.loginAttemptDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectLoginAttemptList.loginAttemptDateCreated, "hh:mm tt")#</div></td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectLoginAttemptList.loginAttemptDateUpdated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectLoginAttemptList.loginAttemptDateUpdated, "hh:mm tt")#</div></td>
		<td>&nbsp;</td>
		<td>
			<cfif Variables.sameUsername is True>
				&nbsp; &quot;
			<cfelseif qry_selectLoginAttemptList.userID is 0>
				n/a
			<cfelse>
				<cfif qry_selectLoginAttemptList.userID_custom is not "">#qry_selectLoginAttemptList.userID_custom#. </cfif>
				#qry_selectLoginAttemptList.lastName#, #qry_selectLoginAttemptList.firstName#
				<cfif qry_selectLoginAttemptList.email is not ""><div class="SmallText"><a href="mailto:#qry_selectLoginAttemptList.email#" class="plainlink">#qry_selectLoginAttemptList.email#</a></div></cfif>
			</cfif>
		</td>
		<cfif ListFind(Variables.permissionActionList, "deleteLoginAttempt")>
			<td>&nbsp;</td>
			<td class="SmallText"><cfif Variables.sameUsername is True>&nbsp;<cfelse><a href="index.cfm?method=admin.deleteLoginAttempt&loginAttemptUsername=#URLEncodedFormat(qry_selectLoginAttemptList.loginAttemptUsername)#" class="plainlink">Re-Enable</a></cfif></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
	</p>
</cfif>
</cfoutput>

