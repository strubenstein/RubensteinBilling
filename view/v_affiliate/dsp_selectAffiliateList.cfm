<cfoutput>
<cfif qry_selectAffiliateList.RecordCount is 0>
	<p class="ErrorMessage">No affiliates meet your search criteria.</p>
<cfelse>
	<cfif Variables.formAction is not "">
		<form method="post" action="#Variables.formAction#">
		<input type="hidden" name="isFormSubmitted" value="True">
	</cfif>

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectAffiliateList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif Variables.formAction is not "">
			<td><input type="checkbox" name="affiliateID" value="#qry_selectAffiliateList.affiliateID#"></td>
			<td>&nbsp;</td>
		</cfif>
		<cfif Variables.displayAffiliateID_custom is True>
			<td><cfif qry_selectAffiliateList.affiliateID_custom is "">&nbsp;<cfelse>#qry_selectAffiliateList.affiliateID_custom#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		<cfif Variables.displayAffiliateCode is True>
			<td><cfif qry_selectAffiliateList.affiliateCode is "">&nbsp;<cfelse>#qry_selectAffiliateList.affiliateCode#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		<td>#qry_selectAffiliateList.affiliateName#</td>
		<td>&nbsp;</td>
		<td>
			#qry_selectAffiliateList.companyName#
			<cfif qry_selectAffiliateList.companyDBA is not "" and qry_selectAffiliateList.companyDBA is not qry_selectAffiliateList.companyName>
				<br><i>DBA: #qry_selectAffiliateList.companyDBA#</i>
			</cfif>
			<cfif qry_selectAffiliateList.companyID is not 0 and ListFind(Variables.permissionActionList, "viewCompany")>
				 <font class="SmallText">(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectAffiliateList.companyID#" class="plainlink">go</a>)</font>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectAffiliateList.lastName is not "">#qry_selectAffiliateList.lastName#, #qry_selectAffiliateList.firstName#</cfif>
			<cfif qry_selectAffiliateList.userID is not 0 and ListFind(Variables.permissionActionList, "viewUser")> <font class="SmallText">(<a href="index.cfm?method=user.viewUser&userID=#qry_selectAffiliateList.userID#" class="plainlink">go</a>)</font></cfif>
		</td>
		<!--- 
		<td>&nbsp;</td>
		<td><cfif qry_selectAffiliateList.affiliateStatus is 1><font color="green">Active</font><cfelse><font color="red">Inactive</font></cfif></td>
		--->
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectAffiliateList.affiliateDateCreated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "viewAffiliate")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=#Variables.manageControl#.viewAffiliate&affiliateID=#qry_selectAffiliateList.affiliateID#&companyID=#qry_selectAffiliateList.companyID#" class="plainlink">Manage</a></td>
		</cfif>
		</tr>
	</cfloop>
	<cfif Variables.formAction is not "">
		<tr><td colspan="#Variables.columnCount#"><input type="submit" name="#Variables.formSubmitName#" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td></tr>
		</form>
	</cfif>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, Variables.alphabetList)#

	<cfif Application.fn_IsUserAuthorized("exportAffiliates")>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>
