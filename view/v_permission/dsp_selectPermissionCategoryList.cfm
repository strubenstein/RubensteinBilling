<cfoutput>
<cfif qry_selectPermissionCategoryList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no permission categories.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectPermissionCategoryList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td align="right">#qry_selectPermissionCategoryList.permissionCategoryOrder#</td>
		<td>&nbsp;</td>
		<td>#qry_selectPermissionCategoryList.permissionCategoryName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPermissionCategoryList.permissionCategoryTitle is "">&nbsp;<cfelseif qry_selectPermissionCategoryList.permissionCategoryTitle is qry_selectPermissionCategoryList.permissionCategoryName><div align="center">&quot;</div><cfelse>#qry_selectPermissionCategoryList.permissionCategoryTitle#</cfif></td>
		<td>&nbsp;</td>
		<td class="SmallText"><cfif qry_selectPermissionCategoryList.permissionCategoryDescription is "">&nbsp;<cfelse>#qry_selectPermissionCategoryList.permissionCategoryDescription#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPermissionCategoryList.permissionCategoryStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPermissionCategoryList.permissionCategoryDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPermissionCategoryList.permissionCategoryDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "movePermissionCategoryDown") and ListFind(Variables.permissionActionList, "movePermissionCategoryUp")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=permission.movePermissionCategoryDown&permissionCategoryID=#qry_selectPermissionCategoryList.permissionCategoryID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=permission.movePermissionCategoryUp&permissionCategoryID=#qry_selectPermissionCategoryList.permissionCategoryID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updatePermissionCategory")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=permission.updatePermissionCategory&permissionCategoryID=#qry_selectPermissionCategoryList.permissionCategoryID#" class="plainlink">Update Category</a></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "listPermissions")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=permission.listPermissions&permissionCategoryID=#qry_selectPermissionCategoryList.permissionCategoryID#" class="plainlink">View Permissions</a></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "insertPermission")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=permission.insertPermission&permissionCategoryID=#qry_selectPermissionCategoryList.permissionCategoryID#" class="plainlink">Add Permission</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
