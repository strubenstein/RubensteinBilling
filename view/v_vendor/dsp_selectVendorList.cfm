<cfoutput>
<cfif qry_selectVendorList.RecordCount is 0>
	<p class="ErrorMessage">No vendors meet your search criteria.</p>
<cfelse>
	<cfif Variables.formAction is not "">
		<form method="post" action="#Variables.formAction#">
		<input type="hidden" name="isFormSubmitted" value="True">
	</cfif>

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectVendorList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif Variables.formAction is not "">
			<td><input type="checkbox" name="vendorID" value="#qry_selectVendorList.vendorID#"></td><td>&nbsp;</td>
		</cfif>
		<cfif Variables.displayVendorID_custom is True>
			<td><cfif qry_selectVendorList.vendorID_custom is "">&nbsp;<cfelse>#qry_selectVendorList.vendorID_custom#</cfif></td><td>&nbsp;</td>
		</cfif>
		<cfif Variables.displayVendorCode is True>
			<td><cfif qry_selectVendorList.vendorCode is "">&nbsp;<cfelse>#qry_selectVendorList.vendorCode#</cfif></td><td>&nbsp;</td>
		</cfif>
		<td>#qry_selectVendorList.vendorName#</td><td>&nbsp;</td>
		<td>
			#qry_selectVendorList.companyName#
			<cfif qry_selectVendorList.companyDBA is not "" and qry_selectVendorList.companyDBA is not qry_selectVendorList.companyName>
				<br><i>DBA: #qry_selectVendorList.companyDBA#</i>
			</cfif>
			<cfif qry_selectVendorList.companyID is not 0 and ListFind(Variables.permissionActionList, "viewCompany")>
				 <font class="SmallText">(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectVendorList.companyID#" class="plainlink">go</a>)</font>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectVendorList.lastName is not "">#qry_selectVendorList.lastName#, #qry_selectVendorList.firstName#</cfif>
			<cfif qry_selectVendorList.userID is not 0 and ListFind(Variables.permissionActionList, "viewUser")>
				 <font class="SmallText">(<a href="index.cfm?method=user.viewUser&userID=#qry_selectVendorList.userID#" class="plainlink">go</a>)</font>
			</cfif>
		</td>
		<!--- 
		<td>&nbsp;</td>
		<td><cfif qry_selectVendorList.vendorStatus is 1><font color="green">Active</font><cfelse><font color="red">Inactive</font></cfif></td>
		--->
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectVendorList.vendorDateCreated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "viewVendor")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=#Variables.manageControl#.viewVendor&vendorID=#qry_selectVendorList.vendorID#&companyID=#qry_selectVendorList.companyID#" class="plainlink">Manage</a></td>
		</cfif>
		</tr>
	</cfloop>
	<cfif Variables.formAction is not "">
		<tr><td colspan="#Variables.columnCount#"><input type="submit" name="#Variables.formSubmitName#" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td></tr>
		</form>
	</cfif>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, Variables.alphabetList)#

	<cfif Application.fn_IsUserAuthorized("exportVendors")>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>
