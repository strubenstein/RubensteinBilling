<cfoutput>
<cfif qry_selectExportQueryList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no export queries.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectExportQueryList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif Variables.isSuperuserPermission is True>
			<td>#qry_selectExportQueryList.exportQueryName#</td>
			<td>&nbsp;</td>
		</cfif>
		<td>#qry_selectExportQueryList.exportQueryTitle#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectExportQueryList.exportQueryDescription is "">&nbsp;<cfelse>#qry_selectExportQueryList.exportQueryDescription#</cfif></td>
		<cfif Variables.isSuperuserPermission is True>
			<td>&nbsp;</td>
			<td><cfif qry_selectExportQueryList.exportQueryStatus is 1>Active<cfelse>Inactive</cfif></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "moveExportQueryUp") and ListFind(Variables.permissionActionList, "moveExportQueryDown")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=export.moveExportQueryDown&exportQueryID=#qry_selectExportQueryList.exportQueryID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=export.moveExportQueryUp&exportQueryID=#qry_selectExportQueryList.exportQueryID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "listExportQueryFields")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=export.listExportQueryFields&exportQueryID=#qry_selectExportQueryList.exportQueryID#" class="plainlink">Manage</a></td>
		<cfelseif ListFind(Variables.permissionActionList, "listExportQueryFieldCompany")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=export.listExportQueryFieldCompany&exportQueryID=#qry_selectExportQueryList.exportQueryID#" class="plainlink">View Fields</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>