<cfoutput>

<cfif qry_selectSalesCommission.salesCommissionManual is 1 and qry_selectSalesCommission.userID_author is not 0>
	<p class="MainText">Manually created by #qry_selectUser_author.firstName# #qry_selectUser_author.lastName#</p>
</cfif>

<cfif ListFind(Variables.permissionActionList, "updateSalesCommission")>
	<form method="post" action="index.cfm?method=salesCommission.updateSalesCommission&salesCommissionID=#URL.salesCommissionID#">
	<input type="hidden" name="isFormSubmitted" value="True">
	<table border="0" cellspacing="2" cellpadding="2" class="TableText" bgcolor="f4f4fa">
	<tr><td class="TableText" colspan="2"><b>Update Sales Commission:</b></td></tr>
	<tr>
		<td>Status: </td>
		<td>
			<label style="color: green"><input type="radio" name="salesCommissionStatus" value="1"<cfif qry_selectSalesCommission.salesCommissionStatus is 1> checked</cfif>>Active</label> &nbsp; 
			<label style="color: red"><input type="radio" name="salesCommissionStatus" value="0"<cfif qry_selectSalesCommission.salesCommissionStatus is not 1> checked</cfif>>Inactive</label>
		</td>
	</tr>
	<tr>
		<td>Paid: </td>
		<td>
			<label style="color: red"><input type="radio" name="salesCommissionPaid" value=""<cfif qry_selectSalesCommission.salesCommissionPaid is ""> checked</cfif>>Not Paid</label> &nbsp; 
			<label style="color: gold"><input type="radio" name="salesCommissionPaid" value="0"<cfif qry_selectSalesCommission.salesCommissionPaid is 0> checked</cfif>>Partially Paid</label> &nbsp; 
			<label style="color: green"><input type="radio" name="salesCommissionPaid" value="1"<cfif qry_selectSalesCommission.salesCommissionPaid is 1> checked</cfif>>Fully Paid</label>
		</td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" name="submitUpdateSalesCommission" value="Update" class="TableText"></td>
	</tr>
	</table>
	</form>
</cfif>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr valign="top">
	<td><b>Amount:</b> </td>
	<td>
		<b>#DollarFormat(qry_selectSalesCommission.salesCommissionAmount)#</b><br>
		Based on revenue of #DollarFormat(qry_selectSalesCommission.salesCommissionBasisTotal)# and quantity of #Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectSalesCommission.salesCommissionBasisQuantity)#.<br>
		<cfif qry_selectSalesCommission.salesCommissionAmount is not qry_selectSalesCommission.salesCommissionCalculatedAmount>
			Calculated amount: #DollarFormat(qry_selectSalesCommission.salesCommissionCalculatedAmount)# 
			(<cfif qry_selectSalesCommission.salesCommissionAmount lt qry_selectSalesCommission.salesCommissionCalculatedAmount>minimum<cfelse>maximum</cfif> commission applied)
		</cfif>
	</td>
</tr>
<tr>
	<td>Status: </td>
	<td><cfif qry_selectSalesCommission.salesCommissionStatus is 1><font color="green">Active</font><cfelse><font color="red">Inactive</font></cfif></td>
</tr>
<tr>
	<td>Salesperson Target: </td>
	<td>
		<cfswitch expression="#Application.fn_GetPrimaryTargetKey(qry_selectSalesCommission.primaryTargetID)#">
		<cfcase value="affiliateID">Affiliate - #qry_selectAffiliate.affiliateName#<cfif ListFind(Variables.permissionActionList, "viewAffiliate")> (<a href="index.cfm?method=affiliate.viewAffiliate&affiliateID=#qry_selectSalesCommission.targetID#" class="plainlink">go</a>)</cfif></cfcase>
		<cfcase value="cobrandID">Cobrand - #qry_selectCobrand.cobrandName#<cfif ListFind(Variables.permissionActionList, "viewCobrand")> (<a href="index.cfm?method=cobrand.viewCobrand&cobrandID=#qry_selectSalesCommission.targetID#" class="plainlink">go</a>)</cfif></cfcase>
		<cfcase value="companyID">Company - #qry_selectCompany.companyName#<cfif ListFind(Variables.permissionActionList, "viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectSalesCommission.targetID#" class="plainlink">go</a>)</cfif></cfcase>
		<cfcase value="userID">User - #qry_selectUser.firstName# #qry_selectUser.lastName#<cfif ListFind(Variables.permissionActionList, "viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectSalesCommission.targetID#" class="plainlink">go</a>)</cfif></cfcase>
		<cfcase value="vendorID">Vendor - #qry_selectVendor.vendorName#<cfif ListFind(Variables.permissionActionList, "viewVendor")> (<a href="index.cfm?method=vendor.viewVendor&vendorID=#qry_selectSalesCommission.targetID#" class="plainlink">go</a>)</cfif></cfcase>
		</cfswitch>
	</td>
</tr>
<tr>
	<td>Finalized: </td>
	<td>
		<cfif qry_selectSalesCommission.salesCommissionFinalized is 0>
			<font color="red">Not Finalized</font>
		<cfelseif Not IsDate(qry_selectSalesCommission.salesCommissionDateFinalized)>
			<font color="gold">Finalized</font> (but no date specified)
		<cfelse>
			<font color="green">Finalized</font> on #DateFormat(qry_selectSalesCommission.salesCommissionDateFinalized, "mmmm dd, yyyy")#
		</cfif>
	</td>
</tr>
<tr>
	<td>Paid: </td>
	<td>
		<cfif qry_selectSalesCommission.salesCommissionPaid is "">
			<font color="red">Not Paid</font>
		<cfelseif qry_selectSalesCommission.salesCommissionPaid is 0>
			<font color="gold">Partially Paid</font> <cfif Not IsDate(qry_selectSalesCommission.salesCommissionDatePaid)>(no date specified)<cfelse>on #DateFormat(qry_selectSalesCommission.salesCommissionDatePaid, "mmmm dd, yyyy")#</cfif>
		<cfelse>
			<font color="green">Fully Paid</font> <cfif Not IsDate(qry_selectSalesCommission.salesCommissionDatePaid)>(no date specified)<cfelse>on #DateFormat(qry_selectSalesCommission.salesCommissionDatePaid, "mmmm dd, yyyy")#</cfif>
		</cfif>
	</td>
</tr>
<cfif IsDate(qry_selectSalesCommission.salesCommissionDateBegin)>
	<tr>
		<td>Period: </td>
		<td>#DateFormat(qry_selectSalesCommission.salesCommissionDateBegin, "mmmm dd, yyyy")# thru <cfif IsDate(qry_selectSalesCommission.salesCommissionDateEnd)>#DateFormat(qry_selectSalesCommission.salesCommissionDateEnd, "mmmm dd, yyyy")#</cfif></td>
	</tr>
</cfif>
<tr>
	<td>Commission Plan: </td>
	<td>
		<cfif qry_selectSalesCommission.commissionID is 0>
			n/a
		<cfelseif Variables.commissionRow is 0>
			?
		<cfelse>
			<cfif qry_selectCommission.commissionID_custom[Variables.commissionRow] is not "">#qry_selectCommission.commissionID_custom[Variables.commissionRow]#. </cfif>
			#qry_selectCommission.commissionName[Variables.commissionRow]#
			<cfif ListFind(Variables.permissionActionList, "viewCommission")> (<a href="index.cfm?method=commission.viewCommission&commissionID=#qry_selectSalesCommission.commissionID#" class="plainlink">go</a>)</cfif><br>
			<cfif qry_selectCommission.commissionDescription[Variables.commissionRow] is not "">Description: #qry_selectCommission.commissionDescription[Variables.commissionRow]#. </cfif>
			<cfif qry_selectCommission.commissionHasMultipleStages[Variables.commissionRow] is 1>
				Stage ###qry_selectCommission.commissionStageOrder[Variables.commissionRow]#. 
				<cfif qry_selectCommission.commissionStageText[Variables.commissionRow] is not "">#qry_selectCommission.commissionStageText[Variables.commissionRow]#</cfif><br>
				<cfif qry_selectCommission.commissionStageDescription[Variables.commissionRow] is not "">Stage Description: #qry_selectCommission.commissionStageDescription[Variables.commissionRow]#</cfif>
			</cfif>
		</cfif>
	</td>
</tr>
<tr>
	<td>Date Created: </td>
	<td>#DateFormat(qry_selectSalesCommission.salesCommissionDateCreated, "mmmm dd, yyyy")#</td>
</tr>
<tr>
	<td>Last Updated: </td>
	<td>#DateFormat(qry_selectSalesCommission.salesCommissionDateUpdated, "mmmm dd, yyyy")#</td>
</tr>
<cfif Application.fn_IsUserAuthorized("exportSalesCommissions")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectSalesCommission.salesCommissionIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectSalesCommission.salesCommissionIsExported is not "" and IsDate(qry_selectSalesCommission.salesCommissionDateExported)>
				on #DateFormat(qry_selectSalesCommission.salesCommissionDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectSalesCommission.salesCommissionDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>

<cfif qry_selectSalesCommissionInvoice.RecordCount is not 0>
	<cfscript>
	function fn_DisplayCustomer (invoiceRow)
	{
		var returnValue = "";
		if (qry_selectInvoiceList.companyName[invoiceRow] is not "")
			{
			returnValue = returnValue & qry_selectInvoiceList.companyName[invoiceRow];
			if (ListFind(Variables.permissionActionList, "viewCompany"))
				returnValue = returnValue & " (<a href=""index.cfm?method=company.viewCompany&companyID=#qry_selectInvoiceList.companyID[invoiceRow]#"" class=""plainlink"">go</a>)";
			returnValue = returnValue & "<br>";
			}
		if (qry_selectInvoiceList.subscriberID[invoiceRow] is not 0)
			{
			returnValue = returnValue & "Sub: " & qry_selectInvoiceList.subscriberName[invoiceRow];
			if (ListFind(Variables.permissionActionList, "viewSubscriber"))
				returnValue = returnValue & " (<a href=""index.cfm?method=subscription.viewSubscriber&subscriberID=#qry_selectInvoiceList.subscriberID[invoiceRow]#"" class=""plainlink"">go</a>)";
			returnValue = returnValue & "<br>";
			}
		if (qry_selectInvoiceList.userID[invoiceRow] is not 0)
			{
			returnValue = returnValue & "Contact: " & qry_selectInvoiceList.firstName[invoiceRow] & " " & qry_selectInvoiceList.lastName[invoiceRow];
			if (ListFind(Variables.permissionActionList, "viewUser"))
				returnValue = returnValue & " (<a href=""index.cfm?method=user.viewUser&userID=#qry_selectInvoiceList.userID[invoiceRow]#"" class=""plainlink"">go</a>)";
			returnValue = returnValue & "<br>";
			}
		return returnValue;
	}

	function fn_DisplayInvoice (invoiceRow)
	{
		var returnValue = "";
		if (qry_selectInvoiceList.invoiceID_custom[invoiceRow] is not "")
			returnValue = returnValue & qry_selectInvoiceList.invoiceID_custom[invoiceRow];
		else
			returnValue = returnValue & qry_selectInvoiceList.invoiceID[invoiceRow];

		if (ListFind(Variables.permissionActionList, "viewInvoice"))
			returnValue = returnValue & " (<a href=""index.cfm?method=invoice.viewInvoice&invoiceID=#qry_selectInvoiceList.invoiceID[invoiceRow]#"" class=""plainlink"">go</a>)";
		returnValue = returnValue & "<br>" & "Total: " & DollarFormat(qry_selectInvoiceList.invoiceTotal[invoiceRow]) & "<br>";
		if (IsDate(qry_selectInvoiceList.invoiceDateClosed[invoiceRow]))
			returnValue = returnValue & "Closed " & DateFormat(qry_selectInvoiceList.invoiceDateClosed[invoiceRow], 'mm-dd-yy') & "<br>";
		if (IsDate(qry_selectInvoiceList.invoiceDatePaid[invoiceRow]))
			returnValue = returnValue & "Paid " & DateFormat(qry_selectInvoiceList.invoiceDatePaid[invoiceRow], 'mm-dd-yy') & "<br>";
		return returnValue;
	}

	function fn_SalespersonInfo (customerRow)
	{
		var returnValue = Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectCommissionCustomer.commissionCustomerPercent[customerRow] * 100) & "%<br>";
		if (qry_selectCommissionCustomer.commissionCustomerPrimary[customerRow] is 1)
			returnValue = returnValue & "(primary)<br>";
		returnValue = returnValue & DateFormat(qry_selectCommissionCustomer.commissionCustomerDateBegin[customerRow], "mm-dd-yy") & "<br>thru<br>";

		if (IsDate(qry_selectCommissionCustomer.commissionCustomerDateEnd[customerRow]))
			returnValue = returnValue & DateFormat(qry_selectCommissionCustomer.commissionCustomerDateEnd[customerRow], "mm-dd-yy") & "<br>";
		else
			returnValue = returnValue & "(no end date)<br>";

		if (qry_selectCommissionCustomer.commissionCustomerDescription[customerRow] is not "")
			returnValue = returnValue & qry_selectCommissionCustomer.commissionCustomerDescription[customerRow];
		return returnValue;
	}
	</cfscript>

	<p class="MainText"><b>Customer(s) &amp; Invoice(s) used to calculate this sales commission:</b></p>
	<table border="1" cellspacing="2" cellpadding="4">
	<tr class="TableHeader" valign="bottom">
		<th>Customer</th>
		<th>Invoice</th>
		<th>Product(s)</th>
		<th>Basis ($/##)</th>
		<cfif Variables.displaySalespersonColumn is True><th>Salesperson</th></cfif>
	</tr>
	<cfloop Query="qry_selectSalesCommissionInvoice">
		<cfset Variables.invoiceRow = ListFind(ValueList(qry_selectInvoiceList.invoiceID), qry_selectSalesCommissionInvoice.invoiceID)>
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><cfif Variables.invoiceRow is 0>??<cfelse>#fn_DisplayCustomer(Variables.invoiceRow)#</cfif></td>
		<td><cfif Variables.invoiceRow is 0>??<cfelse>#fn_DisplayInvoice(Variables.invoiceRow)#</cfif></td>
		<td>
			<cfif qry_selectSalesCommissionInvoice.invoiceLineItemID is 0>-
			<cfelseif Variables.invoiceRow is 0>??
			<cfelse>
				#qry_selectInvoiceLineItemList.invoiceLineItemName[Variables.invoiceRow]#
				<cfif qry_selectInvoiceLineItemList.productID[Variables.invoiceRow] is not 0 and ListFind(Variables.permissionActionList, "viewProduct")>
					 (<a href="index.cfm?method=product.viewProduct&productID=#qry_selectInvoiceLineItemList.productID[Variables.invoiceRow]#" class="plainlink">go</a>)
				</cfif>
			</cfif>
		</td>
		<td>#DollarFormat(qry_selectSalesCommissionInvoice.salesCommissionInvoiceAmount)#<br>Qty: #Application.fn_LimitPaddedDecimalZerosQuantity(salesCommissionInvoiceQuantity)#<br></td>
		<cfif Variables.displaySalespersonColumn is True>
			<td><cfif qry_selectSalesCommissionInvoice.commissionCustomerID is 0>-<cfelse><cfset Variables.customerRow = ListFind(ValueList(qry_selectCommissionCustomer.commissionCustomerID), qry_selectSalesCommissionInvoice.commissionCustomerID)><cfif Variables.customerRow is 0>??<cfelse>#fn_(Variables.customerRow)#</cfif></cfif></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
