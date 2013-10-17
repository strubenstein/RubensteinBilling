<cfoutput>
<cfif qry_selectCompanyVendorList.RecordCount is 0>
	<p class="ErrorMessage">This company is not a listed vendor.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.vendorColumnCount, 0, 0, 0, Variables.vendorColumnList, "", False)#
	<cfloop Query="qry_selectCompanyVendorList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><cfif qry_selectCompanyVendorList.vendorID_custom is "">&nbsp;<cfelse>#qry_selectCompanyVendorList.vendorID_custom#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectCompanyVendorList.vendorName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyVendorList.vendorStatus is 1>Live<cfelse>Disabled</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyVendorList.vendorCode is "">&nbsp;<cfelse>#qry_selectCompanyVendorList.vendorCode#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyVendorList.vendorURLdisplay is 1>Yes<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyVendorList.vendorDescriptionDisplay is 1>Yes<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCompanyVendorList.vendorDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCompanyVendorList.vendorDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "viewVendor")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=company.viewVendor&companyID=#URL.companyID#&vendorID=#qry_selectCompanyVendorList.vendorID#" class="plainlink">Manage</a></td>
		</cfif>
		<!--- 
		<cfif ListFind(Variables.permissionActionList, "updateVendor")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=company.updateVendor&companyID=#URL.companyID#&vendorID=#qry_selectCompanyVendorList.vendorID#" class="plainlink">Update</a></td>
		</cfif>
		--->
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
