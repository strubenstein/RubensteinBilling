<cfoutput>
<cfif qry_selectInvoiceList.RecordCount is 0>
	<p class="ErrorMessage">No purchases/invoices meet your search criteria.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectInvoiceList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td><cfif qry_selectInvoiceList.invoiceID_custom is "">#qry_selectInvoiceList.invoiceID#<cfelse>#qry_selectInvoiceList.invoiceID_custom#</cfif></td>
		<td>&nbsp;</td>
		<td>
			#qry_selectInvoiceList.companyName#<cfif ListFind(Variables.permissionActionList, "viewCompany")> <font class="SmallText">(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectInvoiceList.companyID#" class="plainlink">go</a>)</font></cfif>
			<cfif qry_selectInvoiceList.subscriberID is not 0 and qry_selectInvoiceList.subscriberName is not ""><div class="SmallText"><i>Subscriber</i>: #qry_selectInvoiceList.subscriberName#</div></cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectInvoiceList.userID is 0>
				-
			<cfelse>
				#qry_selectInvoiceList.lastName#, #qry_selectInvoiceList.firstName#
				<cfif ListFind(Variables.permissionActionList, "viewUser")> <font class="SmallText">(<a href="index.cfm?method=user.viewUser&userID=#qry_selectInvoiceList.userID#" class="plainlink">go</a>)</font></cfif>
			</cfif>
			</td>
		<td>&nbsp;</td>
		<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceList.invoiceTotal)#</td>
		<td>&nbsp;</td>
		<td nowrap>
			<cfif qry_selectInvoiceList.invoiceCompleted is 1>
				<font color="red">Completed</font><cfif IsDate(qry_selectInvoiceList.invoiceDateCompleted)><br>#DateFormat(qry_selectInvoiceList.invoiceDateCompleted, "mm-dd-yy")#</cfif>
			<cfelseif qry_selectInvoiceList.invoiceClosed is 0>
				<font color="green">Open</font>
			<cfelse>
				<font color="gold">Closed</font><cfif IsDate(qry_selectInvoiceList.invoiceDateClosed)><br>#DateFormat(qry_selectInvoiceList.invoiceDateClosed, "mm-dd-yy")#</cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td nowrap>
			<cfif qry_selectInvoiceList.invoicePaid is ""><font color="red">Not Paid</font><br><cfelseif qry_selectInvoiceList.invoicePaid is 0><font color="gold">Partial</font><br><cfelse><font color="green">Paid</font><br></cfif>
			<cfif IsDate(qry_selectInvoiceList.invoiceDatePaid)>#DateFormat(qry_selectInvoiceList.invoiceDatePaid, "mm-dd-yy")#</cfif>
		</td>
		<cfif Variables.displayShipping is True>
			<td>&nbsp;</td>
			<td><cfif qry_selectInvoiceList.invoiceShippingMethod is "">n/a<cfelse>#qry_selectInvoiceList.invoiceShippingMethod#</cfif></td>
			<td>&nbsp;</td>
			<td><cfif qry_selectInvoiceList.invoiceShipped is ""><font color="red">n/a<br>or No</font><cfelseif qry_selectInvoiceList.invoiceShipped is 0><font color="gold">Partial</font><cfelse><font color="green">Shipped</font></cfif></td>
		</cfif>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectInvoiceList.invoiceDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectInvoiceList.invoiceDateCreated, "hh:mm tt")#</div></td>
		<cfif ListFind(Variables.permissionActionList, "viewInvoice") or URL.action is "applyInvoicesToPayment">
			<td>&nbsp;</td>
			<td class="SmallText"><a href="#Variables.manageURL#=#qry_selectInvoiceList.invoiceID#" class="plainlink">#Variables.manageText#</a></td>
		</cfif>
		</tr>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, "")#

	<cfif Application.fn_IsUserAuthorized("exportInvoices")>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>
