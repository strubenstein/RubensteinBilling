<cfoutput>
<cfif qry_selectCobrandList.RecordCount is 0>
	<p class="ErrorMessage">No cobrands meet your search criteria.</p>
<cfelse>
	<cfif Variables.formAction is not "">
		<form method="post" action="#Variables.formAction#">
		<input type="hidden" name="isFormSubmitted" value="True">
	</cfif>

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectCobrandList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif Variables.formAction is not "">
			<td><input type="checkbox" name="cobrandID" value="#qry_selectCobrandList.cobrandID#"></td><td>&nbsp;</td>
		</cfif>
		<cfif Variables.displayCobrandID_custom is True>
			<td><cfif qry_selectCobrandList.cobrandID_custom is "">&nbsp;<cfelse>#qry_selectCobrandList.cobrandID_custom#</cfif></td><td>&nbsp;</td>
		</cfif>
		<cfif Variables.displayCobrandCode is True>
			<td><cfif qry_selectCobrandList.cobrandCode is "">&nbsp;<cfelse>#qry_selectCobrandList.cobrandCode#</cfif></td><td>&nbsp;</td>
		</cfif>
		<td>#qry_selectCobrandList.cobrandName#</td><td>&nbsp;</td>
		<td>
			#qry_selectCobrandList.companyName#
			<cfif qry_selectCobrandList.companyDBA is not "" and qry_selectCobrandList.companyDBA is not qry_selectCobrandList.companyName>
				<br><i>DBA: #qry_selectCobrandList.companyDBA#</i>
			</cfif>
			<cfif qry_selectCobrandList.companyID is not 0 and ListFind(Variables.permissionActionList, "viewCompany")>
				 <font class="SmallText">(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectCobrandList.companyID#" class="plainlink">go</a>)</font>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectCobrandList.lastName is not "">#qry_selectCobrandList.lastName#, #qry_selectCobrandList.firstName#</cfif>
			<cfif qry_selectCobrandList.userID is not 0 and ListFind(Variables.permissionActionList, "viewUser")> <font class="SmallText">(<a href="index.cfm?method=user.viewUser&userID=#qry_selectCobrandList.userID#" class="plainlink">go</a>)</font></cfif>
		</td>
		<!--- 
		<td>&nbsp;</td>
		<td><cfif qry_selectCobrandList.cobrandStatus is 1><font color="green">Active</font><cfelse><font color="red">Inactive</font></cfif></td>
		--->
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCobrandList.cobrandDateCreated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "viewCobrand")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=#Variables.manageControl#.viewCobrand&cobrandID=#qry_selectCobrandList.cobrandID#&companyID=#qry_selectCobrandList.companyID#" class="plainlink">Manage</a></td>
		</cfif>
		</tr>
	</cfloop>
	<cfif Variables.formAction is not "">
		<tr><td colspan="#Variables.columnCount#"><input type="submit" name="#Variables.formSubmitName#" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td></tr>
		</form>
	</cfif>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, Variables.alphabetList)#

	<cfif Application.fn_IsUserAuthorized("exportCobrands")>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>
