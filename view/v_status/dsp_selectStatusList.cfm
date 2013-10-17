<cfoutput>
<cfif qry_selectStatusList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no status options for this target type.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectStatusList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td align="right">#qry_selectStatusList.statusOrder#.&nbsp;</td><td>&nbsp;</td>
		<td>#qry_selectStatusList.statusName#</td><td>&nbsp;</td>
		<td>#qry_selectStatusList.statusTitle#</td><td>&nbsp;</td>
		<!--- <td><cfif qry_selectStatusList.statusDisplayToCustomer is 1>Yes<cfelse>No</cfif></td><td>&nbsp;</td> --->
		<td class="SmallText"><cfif qry_selectStatusList.statusID_custom is "">&nbsp;<cfelse>#qry_selectStatusList.statusID_custom#</cfif></td><td>&nbsp;</td>
		<td class="SmallText"><cfif qry_selectStatusList.statusDescription is "">&nbsp;<cfelse>#qry_selectStatusList.statusDescription#</cfif></td><td>&nbsp;</td>
		<td><cfif qry_selectStatusList.statusStatus is 1>Active<cfelse>Inactive</cfif></td><td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectStatusList.statusDateCreated, "mm-dd-yy")#</td><td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectStatusList.statusDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "moveStatusDown") and ListFind(Variables.permissionActionList, "moveStatusUp")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=status.moveStatusDown&statusID=#qry_selectStatusList.statusID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=status.moveStatusUp&statusID=#qry_selectStatusList.statusID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateStatus")>
			<td>&nbsp;</td><td class="SmallText"><a href="index.cfm?method=status.updateStatus&primaryTargetID=#qry_selectStatusList.primaryTargetID#&statusID=#qry_selectStatusList.statusID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
