<cfoutput>
<cfif qry_selectSchedulerList.RecordCount is 0>
	<p class="ErrorMessage">There are no scheduled tasks yet.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectSchedulerList">
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
		<td>#qry_selectSchedulerList.schedulerName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectSchedulerList.schedulerStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td nowrap><cfif Not IsDate(qry_selectSchedulerList.schedulerDateBegin)>n/a<cfelse>#DateFormat(qry_selectSchedulerList.schedulerDateBegin, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectSchedulerList.schedulerDateBegin, "hh:mm tt")#</div></cfif></td>
		<td>&nbsp;</td>
		<td nowrap><cfif Not IsDate(qry_selectSchedulerList.schedulerDateEnd)>n/a<cfelse>#DateFormat(qry_selectSchedulerList.schedulerDateEnd, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectSchedulerList.schedulerDateEnd, "hh:mm tt")#</div></cfif></td>
		<td>&nbsp;</td>
		<td><cfif Not IsNumeric(qry_selectSchedulerList.schedulerInterval)>#qry_selectSchedulerList.schedulerInterval#<cfelse>#fn_displaySecondsAsHMS(qry_selectSchedulerList.schedulerInterval, "<br>")#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectSchedulerList.schedulerRequestTimeOut is 0>-<cfelse>#qry_selectSchedulerList.schedulerRequestTimeOut#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectSchedulerList.userID is 0>-<cfelse>#qry_selectSchedulerList.firstName# #qry_selectSchedulerList.lastName#</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectSchedulerList.schedulerDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectSchedulerList.schedulerDateCreated, "hh:mm tt")#</div></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectSchedulerList.schedulerDateUpdated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectSchedulerList.schedulerDateUpdated, "hh:mm tt")#</div></td>
		<cfif ListFind(Variables.permissionActionList, "updateScheduler")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=scheduler.updateScheduler&schedulerID=#qry_selectSchedulerList.schedulerID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
		<tr class="SmallText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
			<td colspan="#Variables.columnCount#">
				#qry_selectSchedulerList.schedulerURL#<br>
				<cfif qry_selectSchedulerList.schedulerDescription is not ""><i>Description</i>: #qry_selectSchedulerList.schedulerDescription#<br></cfif>
			</td>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>

