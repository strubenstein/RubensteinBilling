<cfoutput>
<cfif qry_selectPrimaryTargetList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no primary targets.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers(Variables.viewAction, URL.queryOrderBy, "<br>", Variables.primaryTargetColumnCount, 0, 0, 0, Variables.primaryTargetColumnList, Variables.primaryTargetOrderList, True)#
	<cfloop Query="qry_selectPrimaryTargetList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td align="right">#qry_selectPrimaryTargetList.primaryTargetID#</td>
		<td>&nbsp;</td>
		<td>#qry_selectPrimaryTargetList.primaryTargetTable#</td>
		<td>&nbsp;</td>
		<td>#qry_selectPrimaryTargetList.primaryTargetKey#</td>
		<td>&nbsp;</td>
		<td>#qry_selectPrimaryTargetList.primaryTargetName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPrimaryTargetList.primaryTargetDescription is "">&nbsp;<cfelse>#qry_selectPrimaryTargetList.primaryTargetDescription#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPrimaryTargetList.primaryTargetStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPrimaryTargetList.primaryTargetDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPrimaryTargetList.primaryTargetDateUpdated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPrimaryTargetList.userID is 0>&nbsp;<cfelse>#qry_selectPrimaryTargetList.lastName#, #qry_selectPrimaryTargetList.firstName#</cfif></td>
		<cfif ListFind(Variables.permissionActionList, "updatePrimaryTarget")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=primaryTarget.updatePrimaryTarget&primaryTargetID=#qry_selectPrimaryTargetList.primaryTargetID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
