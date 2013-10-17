<cfoutput>
<cfif qry_selectCompanyCobrandList.RecordCount is 0>
	<p class="ErrorMessage">This company is not a listed cobrand.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.cobrandColumnCount, 0, 0, 0, Variables.cobrandColumnList, "", False)#
	<cfloop Query="qry_selectCompanyCobrandList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><cfif qry_selectCompanyCobrandList.cobrandID_custom is "">&nbsp;<cfelse>#qry_selectCompanyCobrandList.cobrandID_custom#</cfif></td>
		<td>&nbsp;</td>
		<td>
			#qry_selectCompanyCobrandList.cobrandName#
			<cfif qry_selectCompanyCobrandList.cobrandName is not qry_selectCompanyCobrandList.cobrandTitle><br><i>Title: #qry_selectCompanyCobrandList.cobrandTitle#</i></cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyCobrandList.cobrandStatus is 1>Live<cfelse>Disabled</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyCobrandList.cobrandCode is "">&nbsp;<cfelse>#qry_selectCompanyCobrandList.cobrandCode#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyCobrandList.cobrandDomain is "">&nbsp;<cfelse>#qry_selectCompanyCobrandList.cobrandDomain#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyCobrandList.cobrandDirectory is "">&nbsp;<cfelse>#qry_selectCompanyCobrandList.cobrandDirectory#</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCompanyCobrandList.cobrandDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCompanyCobrandList.cobrandDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "viewCobrand")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=company.viewCobrand&companyID=#URL.companyID#&cobrandID=#qry_selectCompanyCobrandList.cobrandID#" class="plainlink">Manage</a></td>
		</cfif>
		<!--- 
		<cfif ListFind(Variables.permissionActionList, "updateCobrand")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=company.updateCobrand&companyID=#URL.companyID#&cobrandID=#qry_selectCompanyCobrandList.cobrandID#" class="plainlink">Update</a></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "insertCobrandHeader")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=company.insertCobrandHeader&companyID=#URL.companyID#&cobrandID=#qry_selectCompanyCobrandList.cobrandID#" class="plainlink">Header</a></td>
		</cfif>
		--->
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
