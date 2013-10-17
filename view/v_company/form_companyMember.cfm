<cfoutput>
<cfif qry_selectCompanyList.RecordCount is 0>
	<p class="ErrorMessage">No companies meet your search criteria.</p>
<cfelse>
	<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
	<input type="hidden" name="isFormSubmitted" value="True">
	<input type="hidden" name="companyListRedirect" value="#HTMLEditFormat(Variables.companyListRedirect)#">

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectCompanyList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td align="center"><input type="checkbox" name="companyID" value="#qry_selectCompanyList.companyID#"></td>
		<td>&nbsp;</td>
		<cfif Variables.displayCompanyID_custom is True>
			<td><cfif qry_selectCompanyList.companyID_custom is "">&nbsp;<cfelse>#qry_selectCompanyList.companyID_custom#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		<td>#qry_selectCompanyList.companyName#<cfif qry_selectCompanyList.companyDBA is not "" and qry_selectCompanyList.companyDBA is not qry_selectCompanyList.companyName><br><i>DBA: #qry_selectCompanyList.companyDBA#</i></cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyList.companyStatus is 1><font color="green">Active</font><cfelse><font color="red">Inactive</font></cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyList.userID is 0>&nbsp;<cfelse>#qry_selectCompanyList.firstName# #qry_selectCompanyList.lastName#</cfif></td>
		<td>&nbsp;</td>
		<cfif Variables.displayPartner is True>
			<td>
				<cfif qry_selectCompanyList.affiliateID is not 0 and StructKeyExists(Variables.struct_selectAffiliateList, "affiliate#qry_selectCompanyList.affiliateID#")>#Variables.struct_selectAffiliateList["affiliate#qry_selectCompanyList.affiliateID#"]#<br></cfif>
				<cfif qry_selectCompanyList.cobrandID is not 0 and StructKeyExists(Variables.struct_selectCobrandList, "cobrand#qry_selectCobrandList.cobrandID#")>#Variables.struct_selectCobrandList["cobrand#qry_selectCobrandList.cobrandID#"]#<br></cfif>
			</td>
			<td>&nbsp;</td>
		</cfif>
		<td class="SmallText">
			<cfif qry_selectCompanyList.companyIsCustomer is 1>Customer<br></cfif>
			<cfif qry_selectCompanyList.companyIsTaxExempt is 1>Tax-Exempt<br></cfif>
			<cfif qry_selectCompanyList.companyIsVendor is 1>Vendor<br></cfif>
			<cfif qry_selectCompanyList.companyIsAffiliate is 1>Affiliate<br></cfif>
			<cfif qry_selectCompanyList.companyIsCobrand is 1>Cobrand</cfif>
		</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCompanyList.companyDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td class="SmallText"><a href="index.cfm?method=company.viewCompany&companyID=#qry_selectCompanyList.companyID#" class="plainlink">Manage</a></td>
		</tr>
	</cfloop>
	<tr><td colspan="#Variables.columnCount#"><input type="submit" name="#Variables.formSubmitName#" value="#Variables.formSubmitValue#"></td></tr>
	</form>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, Variables.alphabetList)#
</cfif>
</cfoutput>

