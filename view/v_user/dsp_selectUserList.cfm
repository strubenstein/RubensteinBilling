<cfoutput>
<cfif qry_selectUserList.RecordCount is 0>
	<p class="ErrorMessage">No users meet your search criteria.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectUserList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif Variables.isDisplayCompanyID_custom is True>
			<td><cfif qry_selectUserList.companyID_custom is "">&nbsp;<cfelse>#qry_selectUserList.companyID_custom#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		<td>
			<cfif qry_selectUserList.companyName is "">&nbsp;<cfelse>#qry_selectUserList.companyName#</cfif>
			<cfif ListFind(Variables.permissionActionList, "viewCompany")>
				 <font class="SmallText">(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectUserList.companyID#" class="plainlink">go</a>)</font>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>#qry_selectUserList.lastName#, #qry_selectUserList.firstName#</td>
		<td>&nbsp;</td>
		<cfif Variables.isDisplayUserID_custom is True>
			<td><cfif qry_selectUserList.userID_custom is "">&nbsp;<cfelse>#qry_selectUserList.userID_custom#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		<td>#qry_selectUserList.username#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectUserList.userDateCreated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "viewUser")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="#Variables.viewUserAction#&userID=#qry_selectUserList.userID#" class="plainlink">Manage</a></td>
		</cfif>
		</tr>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, Variables.alphabetList)#

	<cfif Application.fn_IsUserAuthorized("exportUsers")>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>

