<cfoutput>
<cfif qry_selectUserList.RecordCount is 0>
	<p class="ErrorMessage">No users meet your search criteria.</p>
<cfelse>
	<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
	<input type="hidden" name="isFormSubmitted" value="True">
	<input type="hidden" name="userListRedirect" value="#HTMLEditFormat(Variables.userListRedirect)#">

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectUserList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td align="center"><input type="checkbox" name="userID" value="#qry_selectUserList.userID#"></td>
		<td>&nbsp;</td>
		<cfif Form.returnCompanyFields is True>
			<td><cfif qry_selectUserList.companyName is "">&nbsp;<cfelse>#qry_selectUserList.companyName#</cfif></td>
			<td>&nbsp;</td>
			<cfif Variables.isDisplayCompanyID_custom is True>
				<td><cfif qry_selectUserList.companyID_custom is "">&nbsp;<cfelse>#qry_selectUserList.companyID_custom#</cfif></td>
				<td>&nbsp;</td>
			</cfif>
		</cfif>
		<td><a href="mailto:#qry_selectUserList.email#" class="plainlink">#qry_selectUserList.lastName#, #qry_selectUserList.firstName#</a></td>
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
			<td class="SmallText"><a href="index.cfm?method=user.viewUser&userID=#qry_selectUserList.userID#" class="plainlink">Manage</a></td>
		</cfif>
		</tr>
	</cfloop>
	<tr><td colspan="#Variables.columnCount#"><input type="submit" name="#Variables.formSubmitName#" value="#Variables.formSubmitValue#"></td></tr>
	</form>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, Variables.alphabetList)#

</cfif>
</cfoutput>

