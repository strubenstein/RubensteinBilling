<!--- display invoices that payment credit has been applied to --->
<cfoutput>
<cfif qry_selectInvoicePaymentCreditList.RecordCount is 0>
	<p class="ErrorMessage">This payment credit has not been applied to any invoices.</p>
<cfelse>
	<br>
	<div class="MainText"><b>Invoice(s) that payment credit has been applied to:</b></div>
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<cfloop Query="qry_selectInvoicePaymentCreditList">
		<cfif CurrentRow is not 1>
			<tr><td colspan="2"><hr noshade size="2" align="left" width="100%"></td></tr>
		</cfif>
		<tr>
			<td>Invoice ID: </td>
			<td>
				#qry_selectInvoicePaymentCreditList.invoiceID#
				<cfif ListFind(Variables.permissionActionList, "viewInvoice")>
					 (<a href="index.cfm?method=invoice.viewInvoice&invoiceID=#qry_selectInvoicePaymentCreditList.invoiceID#" class="plainlink">go</a>)
				</cfif>
				<cfif Application.fn_IsIntegerPositive(qry_selectInvoicePaymentCreditList.subscriberID) and ListFind(Variables.permissionActionList, "viewSubscriber")>
					 [<a href="index.cfm?method=subscriber.viewSubscriber&subscriberID=#qry_selectInvoicePaymentCreditList.subscriberID#" class="plainlink">View Subscriber</a>]
				</cfif>
			</td>
		</tr>
		<cfif qry_selectInvoicePaymentCreditList.invoiceID_custom is not "">
			<tr>
				<td>Custom ID: </td>
				<td>#qry_selectInvoicePaymentCreditList.invoiceID_custom#</td>
			</tr>
		</cfif>

		<tr>
			<td>Credit Amount: </td>
			<td>#DollarFormat(qry_selectInvoicePaymentCreditList.invoicePaymentCreditAmount)#</td>
		</tr>

		<cfif ListFind(Variables.permissionActionList, "updateInvoicePaymentCredit")>
			<form method="post" action="index.cfm?method=#URL.control#.updateInvoicePaymentCredit#Variables.urlParameters#&invoiceID=#qry_selectInvoicePaymentCreditList.invoiceID#&paymentCreditID=#qry_selectInvoicePaymentCreditList.paymentCreditID#&invoicePaymentCreditID=#qry_selectInvoicePaymentCreditList.invoicePaymentCreditID#">
			<input type="hidden" name="isFormSubmitted" value="True">
		</cfif>
		<tr valign="top">
			<td>Line Item Text: </td>
			<td>
				<cfif qry_selectInvoicePaymentCreditList.invoicePaymentCreditText is "">(<i>blank</i>)<cfelse>#qry_selectInvoicePaymentCreditList.invoicePaymentCreditText#</cfif>
				<cfif ListFind(Variables.permissionActionList, "updateInvoicePaymentCredit")>
					<br><i>Update Text</i>: 
					<input type="text" name="invoicePaymentCreditText" value="#HTMLEditFormat(qry_selectInvoicePaymentCreditList.invoicePaymentCreditText)#" size="30" maxlength="#maxlength_InvoicePaymentCredit.invoicePaymentCreditText#"> 
					<input type="submit" name="submitInvoicePaymentCreditText" value="Update">
				</cfif>
			</td>
		</tr>
		<cfif ListFind(Variables.permissionActionList, "updateInvoicePaymentCredit")>
			</form>
		</cfif>

		<tr>
			<td>Date Credit Recorded: </td>
			<td><cfif Not IsDate(qry_selectInvoicePaymentCreditList.invoicePaymentCreditDate)>n/a<cfelse>#DateFormat(qry_selectInvoicePaymentCreditList.invoicePaymentCreditDate, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectInvoicePaymentCreditList.invoicePaymentCreditDate, "hh:mm tt")#</cfif></td>
		</tr>
		<cfif qry_selectInvoicePaymentCreditList.invoicePaymentCreditRolloverPrevious is 1 or qry_selectInvoicePaymentCreditList.invoicePaymentCreditRolloverNext is 1>
			<tr>
				<td>Rollover: </td>
				<td>
					<cfif qry_selectInvoicePaymentCreditList.invoicePaymentCreditRolloverPrevious is 1>
						Credit was rolled over from previous invoice that did not use full credit amount.<br>
					</cfif>
					<cfif qry_selectInvoicePaymentCreditList.invoicePaymentCreditRolloverNext is 1>
						Credit was rolled over to future invoice as this invoice did not use the full credit amount.<br>
					</cfif>
				</td>
			</tr>
		</cfif>
		<tr>
			<td>Credit Recorded Method: </td>
			<td><cfif qry_selectInvoicePaymentCreditList.invoicePaymentCreditManual is 0>Automatically via scheduled script<cfelse>Manually by a user</cfif></td>
		</tr>
		<cfif qry_selectInvoicePaymentCreditList.invoicePaymentCreditUserID is not 0>
			<tr>
				<td>Payment Recorded By: </td>
				<td>#qry_selectInvoicePaymentCreditList.firstName# #qry_selectInvoicePaymentCreditList.lastName#</td>
			</tr>
		</cfif>

		<tr>
			<td>Date Invoice Closed: </td>
			<td><cfif Not IsDate(qry_selectInvoicePaymentCreditList.invoiceDateClosed)>n/a<cfelse>#DateFormat(qry_selectInvoicePaymentCreditList.invoiceDateClosed, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectInvoicePaymentCreditList.invoiceDateClosed, "hh:mm tt")#</cfif></td>
		</tr>
		<tr>
			<td>Date Invoice Created: </td>
			<td><cfif Not IsDate(qry_selectInvoicePaymentCreditList.invoiceDateCreated)>n/a<cfelse>#DateFormat(qry_selectInvoicePaymentCreditList.invoiceDateCreated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectInvoicePaymentCreditList.invoiceDateCreated, "hh:mm tt")#</cfif></td>
		</tr>
		<cfif IsNumeric(qry_selectInvoicePaymentCreditList.invoiceTotal)>
			<tr>
				<td>Total: </td>
				<td>#DollarFormat(qry_selectInvoicePaymentCreditList.invoiceTotal)#</td>
			</tr>
		</cfif>
		<cfif IsNumeric(qry_selectInvoicePaymentCreditList.invoiceTotalLineItem)>
			<tr>
				<td>Line Items: </td>
				<td>#DollarFormat(qry_selectInvoicePaymentCreditList.invoiceTotalLineItem)#</td>
			</tr>
		</cfif>
		<cfif IsNumeric(qry_selectInvoicePaymentCreditList.invoiceTotalPaymentCredit) and qry_selectInvoicePaymentCreditList.invoiceTotalPaymentCredit is not 0>
			<tr>
				<td>Credits: </td>
				<td>(#DollarFormat(qry_selectInvoicePaymentCreditList.invoiceTotalPaymentCredit)#)</td>
			</tr>
		</cfif>
		<cfif IsNumeric(qry_selectInvoicePaymentCreditList.invoiceTotalTax) and qry_selectInvoicePaymentCreditList.invoiceTotalTax is not 0>
			<tr>
				<td>Taxes: </td>
				<td>#DollarFormat(qry_selectInvoicePaymentCreditList.invoiceTotalTax)#</td>
			</tr>
		</cfif>
		<cfif IsNumeric(qry_selectInvoicePaymentCreditList.invoiceTotalShipping) and qry_selectInvoicePaymentCreditList.invoiceTotalShipping is not 0>
			<tr>
				<td>Shipping: </td>
				<td>#DollarFormat(qry_selectInvoicePaymentCreditList.invoiceTotalShipping)#</td>
			</tr>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "deleteInvoicePaymentCredit")>
			<tr>
				<td></td>
				<td></td>
				<td bgcolor="dddddd">[<font class="SmallText"><a href="index.cfm?method=#URL.control#.deleteInvoicePaymentCredit#Variables.urlParameters#&paymentCreditID=#URL.paymentCreditID#&invoiceID=#qry_selectInvoicePaymentCreditList.invoiceID#&invoicePaymentCreditID=#qry_selectInvoicePaymentCreditList.invoicePaymentCreditID#" class="plainlink" title="Remove Invoice From Payment?" onclick="return confirm('Are you sure you want to remove the invoice from the payment? If yes, click OK. If unsure, click Cancel.');">Remove Invoice From Payment</a></font>]</td>
			</tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>