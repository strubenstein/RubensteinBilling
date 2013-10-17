<cfoutput>
<cfif qry_selectSalesCommissionList.RecordCount is 0>
	<p class="ErrorMessage">There are no sales commissions that meet your criteria.</p>
<cfelse>
	<cfscript>
	function fn_DisplaySalesCommissionTargetType (primaryTargetID)
	{
		var targetKey = Application.fn_GetPrimaryTargetKey(primaryTargetID);
		switch (targetKey)
		{
			case "affiliateID" : return "Affiliate";
			case "cobrandID" : return "Cobrand";
			case "vendorID" : return "Vendor";
			case "userID" : return "User";
			case "companyID" : return "Company";
			default : return "?";
		}
	}

	function fn_DisplaySalesCommissionTargetName (primaryTargetID, targetID, targetName)
	{
		var returnValue = targetName;
		var targetKey = Application.fn_GetPrimaryTargetKey(primaryTargetID);

		if (targetKey is "affiliateID" and ListFind(Variables.permissionActionList, "viewAffiliate"))
			returnValue = returnValue & " <font class=""SmallText"">(<a href=""index.cfm?method=affiliate.viewAffiliate&affiliateID=#targetID#"" class=""plainlink"">go</a>)</font>";
		else if (targetKey is "cobrandID" and ListFind(Variables.permissionActionList, "viewCobrand"))
			returnValue = returnValue & " <font class=""SmallText"">(<a href=""index.cfm?method=cobrand.viewCobrand&cobrandID=#targetID#"" class=""plainlink"">go</a>)</font>";
		else if (targetKey is "companyID" and ListFind(Variables.permissionActionList, "viewCompany"))
			returnValue = returnValue & " <font class=""SmallText"">(<a href=""index.cfm?method=company.viewCompany&companyID=#targetID#"" class=""plainlink"">go</a>)</font>";
		else if (targetKey is "vendorID" and ListFind(Variables.permissionActionList, "viewVendor"))
			returnValue = returnValue & " <font class=""SmallText"">(<a href=""index.cfm?method=vendor.viewVendor&vendorID=#targetID#"" class=""plainlink"">go</a>)</font>";
		else if (targetKey is "userID" and ListFind(Variables.permissionActionList, "viewUser"))
			returnValue = returnValue & " <font class=""SmallText"">(<a href=""index.cfm?method=user.viewUser&userID=#targetID#"" class=""plainlink"">go</a>)</font>";

		return returnValue;
	}
	</cfscript>

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfset Variables.rowBG = 1>
	<cfloop Query="qry_selectSalesCommissionList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif Form.returnTargetName is True>
			<td>#fn_DisplaySalesCommissionTargetType(qry_selectSalesCommissionList.primaryTargetID)#</td>
			<td>&nbsp;</td>
			<td>#fn_DisplaySalesCommissionTargetName(qry_selectSalesCommissionList.primaryTargetID, qry_selectSalesCommissionList.targetID, qry_selectSalesCommissionList.targetName)#</td>
			<td>&nbsp;</td>
		</cfif>
		<td>#DollarFormat(qry_selectSalesCommissionList.salesCommissionAmount)#</td>
		<cfif Form.returnSalesCommissionSum is False>
			<td>&nbsp;</td>
			<td>
				<cfif qry_selectSalesCommissionList.commissionID is 0>(custom)<cfelseif qry_selectSalesCommissionList.commissionName is "">&nbsp;<cfelse>#qry_selectSalesCommissionList.commissionName#</cfif>
				<cfif qry_selectSalesCommissionList.commissionID is not 0 and ListFind(Variables.permissionActionList, "viewCommission")>
					 <font class="SmallText">(<a href="index.cfm?method=commission.viewCommission&commissionID=#qry_selectSalesCommissionList.commissionID#" class="plainlink">go</a>)</font>
				</cfif>
			</td>
			<td>&nbsp;</td>
			<td><cfif Not IsDate(qry_selectSalesCommissionList.salesCommissionDateFinalized)>-<cfelse>#DateFormat(qry_selectSalesCommissionList.salesCommissionDateFinalized, "mm-dd-yy")#</cfif></td>
			<td>&nbsp;</td>
			<td>
				<cfif qry_selectSalesCommissionList.salesCommissionDatePaid is ""><font color="red">Not Paid</font><cfelseif qry_selectSalesCommissionList.salesCommissionDatePaid is 0><font color="gold">Partial</font><cfelse><font color="green">Paid</font></cfif><br>
				<cfif IsDate(qry_selectSalesCommissionList.salesCommissionDatePaid)>#DateFormat(qry_selectSalesCommissionList.salesCommissionDatePaid, "mm-dd-yy")#</cfif>
			</td>
			<!--- 
			<td>&nbsp;</td>
			<td><cfif qry_selectSalesCommissionList.userID_author is 0>&nbsp;<cfelse>#qry_selectSalesCommissionList.lastName#, #qry_selectSalesCommissionList.firstName#<cfif ListFind(Variables.permissionActionList, "viewUser")> <font class="SmallText">(<a href="index.cfm?method=user.viewUser&userID=#qry_selectSalesCommissionList.userID_author#" class="plainlink">go</a>)</font></cfif></cfif></td>
			--->
			<td>&nbsp;</td>
			<td nowrap>#DateFormat(qry_selectSalesCommissionList.salesCommissionDateCreated, "mm-dd-yy")#</td>
			<cfif ListFind(Variables.permissionActionList, "viewSalesCommission")>
				<td>&nbsp;</td>
				<td class="SmallText"><a href="index.cfm?method=#URL.control#.viewSalesCommission#Variables.urlParameters#&salesCommissionID=#qry_selectSalesCommissionList.salesCommissionID#" class="plainlink">Manage</a></td>
			</cfif>
		</cfif>
		</tr>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, Variables.alphabetList)#

	<cfif Form.returnSalesCommissionSum is False and ListFind(Variables.permissionActionList, "updateSalesCommission")>
		<form method="post" action="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#">
		<input type="hidden" name="updateSalesCommissionPaidViaList" value="True">
		<table border="0" cellspacing="0" cellpadding="5" width="800">
		<tr>
			<td align="center">
				<label><input type="checkbox" name="salesCommissionPaid" value="1"> Mark all sales commissions meeting above criteria as paid</label><br>
				<input type="submit" name="submitUpdateSalesCommissionPaidViaList" value="Update Sales Commissions As Paid">
				<div class="SmallText">Updates all sales commissions on all pages that meet criteria - not just this page.</div>
			</td>
		</tr>
		</table>
		</form>
	</cfif>
	<cfif Application.fn_IsUserAuthorized("exportSalesCommissions")>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>
