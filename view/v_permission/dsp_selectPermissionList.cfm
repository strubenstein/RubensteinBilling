<cfoutput>
<cfif qry_selectPermissionList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no permissions listings in this category.</p>
<cfelse>
	<cfset Variables.lastPermissionCategoryID = 0>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectPermissionList">
		<cfif CurrentRow is 1 or qry_selectPermissionList.permissionCategoryID is not qry_selectPermissionList.permissionCategoryID[CurrentRow - 1]>
			<cfset Variables.permissionCategoryRow = ListFind(ValueList(qry_selectPermissionCategoryList.permissionCategoryID), qry_selectPermissionList.permissionCategoryID)>
			<tr class="TableText" valign="top" bgcolor="CCCCFF">
			<td colspan="12"> &nbsp; <b>#qry_selectPermissionCategoryList.permissionCategoryOrder[Variables.permissionCategoryRow]#. #qry_selectPermissionCategoryList.permissionCategoryName[Variables.permissionCategoryRow]#</b></td>
			<td colspan="9" class="SmallText" align="right">
				<cfif ListFind(Variables.permissionActionList, "updatePermissionCategory")>
					[<a href="index.cfm?method=permission.updatePermissionCategory&permissionCategoryID=#qry_selectPermissionList.permissionCategoryID#" class="plainlink">Update Category</a>]  
				</cfif>
				<cfif ListFind(Variables.permissionActionList, "insertPermission")>
					[<a href="index.cfm?method=permission.insertPermission&permissionCategoryID=#qry_selectPermissionList.permissionCategoryID#" class="plainlink">Add Permission</a>]
				</cfif>
				 &nbsp;
			</td>
		</cfif>
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td align="right">#qry_selectPermissionList.permissionOrder#</td>
		<td>&nbsp;</td>
		<td>#qry_selectPermissionList.permissionName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPermissionList.permissionTitle is "">&nbsp;<cfelseif qry_selectPermissionList.permissionTitle is qry_selectPermissionList.permissionName><div align="center">&quot;</div><cfelse>#qry_selectPermissionList.permissionTitle#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPermissionList.permissionSuperuserOnly is 1>Yes<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td class="SmallText"><cfif qry_selectPermissionList.permissionDescription is "">&nbsp;<cfelse>#qry_selectPermissionList.permissionDescription#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPermissionList.permissionStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPermissionList.permissionDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPermissionList.permissionDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "movePermissionDown") and ListFind(Variables.permissionActionList, "movePermissionUp")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount or qry_selectPermissionList.permissionCategoryID is not qry_selectPermissionList.permissionCategoryID[CurrentRow + 1]>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=permission.movePermissionDown&permissionID=#qry_selectPermissionList.permissionID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1 or qry_selectPermissionList.permissionCategoryID is not qry_selectPermissionList.permissionCategoryID[CurrentRow - 1]>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=permission.movePermissionUp&permissionID=#qry_selectPermissionList.permissionID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updatePermission")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=permission.updatePermission&permissionID=#qry_selectPermissionList.permissionID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
