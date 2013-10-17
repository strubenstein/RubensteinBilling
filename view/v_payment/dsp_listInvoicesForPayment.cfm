<!--- display invoices that payment applies to --->
<cfoutput>
<cfif qry_selectInvoicePaymentList.RecordCount is 0>
	<p class="ErrorMessage">No invoices have been applied to this payment.</p>
<cfelse>
	<br>
	<div class="MainText"><b>Invoice(s) that payment has been applied to:</b></div>
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<cfloop Query="qry_selectInvoicePaymentList">
		<cfif CurrentRow is not 1>
			<tr><td colspan="2"><hr noshade size="2" align="left" width="100%"></td></tr>
		</cfif>
		<tr>
			<td>Invoice ID: </td>
			<td>
				#qry_selectInvoicePaymentList.invoiceID#
				<cfif ListFind(Variables.permissionActionList, "viewInvoice")>
					 (<a href="index.cfm?method=invoice.viewInvoice&invoiceID=#qry_selectInvoicePaymentList.invoiceID#" class="plainlink">go</a>)
				</cfif>
				<cfif Application.fn_IsIntegerPositive(qry_selectInvoicePaymentList.subscriberID) and ListFind(Variables.permissionActionList, "viewSubscriber")>
					 [<a href="index.cfm?method=subscriber.viewSubscriber&subscriberID=#qry_selectInvoicePaymentList.subscriberID#" class="plainlink">View Subscriber</a>]
				</cfif>
			</td>
		</tr>
		<cfif qry_selectInvoicePaymentList.invoiceID_custom is not "">
			<tr>
				<td>Custom ID: </td>
				<td>#qry_selectInvoicePaymentList.invoiceID_custom#</td>
			</tr>
		</cfif>
		<tr>
			<td>Amount Attributed: </td>
			<td>#DollarFormat(qry_selectInvoicePaymentList.invoicePaymentAmount)#</td>
		</tr>
		<tr>
			<td>Date Payment Recorded: </td>
			<td><cfif Not IsDate(qry_selectInvoicePaymentList.invoicePaymentDate)>n/a<cfelse>#DateFormat(qry_selectInvoicePaymentList.invoicePaymentDate, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectInvoicePaymentList.invoicePaymentDate, "hh:mm tt")#</cfif></td>
		</tr>
		<tr>
			<td>Payment Recorded Method: </td>
			<td><cfif qry_selectInvoicePaymentList.invoicePaymentManual is 0>Automatically via scheduled script<cfelse>Manually by a user</cfif></td>
		</tr>
		<cfif qry_selectInvoicePaymentList.invoicePaymentUserID is not 0>
			<tr>
				<td>Payment Recorded By: </td>
				<td>#qry_selectInvoicePaymentList.firstName# #qry_selectInvoicePaymentList.lastName#</td>
			</tr>
		</cfif>
		<tr>
			<td>Date Closed: </td>
			<td><cfif Not IsDate(qry_selectInvoicePaymentList.invoiceDateClosed)>n/a<cfelse>#DateFormat(qry_selectInvoicePaymentList.invoiceDateClosed, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectInvoicePaymentList.invoiceDateClosed, "hh:mm tt")#</cfif></td>
		</tr>
		<tr>
			<td>Date Created: </td>
			<td><cfif Not IsDate(qry_selectInvoicePaymentList.invoiceDateCreated)>n/a<cfelse>#DateFormat(qry_selectInvoicePaymentList.invoiceDateCreated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectInvoicePaymentList.invoiceDateCreated, "hh:mm tt")#</cfif></td>
		</tr>
		<cfif IsNumeric(qry_selectInvoicePaymentList.invoiceTotal)>
			<tr>
				<td>Total: </td>
				<td>#DollarFormat(qry_selectInvoicePaymentList.invoiceTotal)#</td>
			</tr>
		</cfif>
		<cfif IsNumeric(qry_selectInvoicePaymentList.invoiceTotalLineItem)>
			<tr>
				<td>Line Items: </td>
				<td>#DollarFormat(qry_selectInvoicePaymentList.invoiceTotalLineItem)#</td>
			</tr>
		</cfif>
		<cfif IsNumeric(qry_selectInvoicePaymentList.invoiceTotalPaymentCredit) and qry_selectInvoicePaymentList.invoiceTotalPaymentCredit is not 0>
			<tr>
				<td>Credits: </td>
				<td>(#DollarFormat(qry_selectInvoicePaymentList.invoiceTotalPaymentCredit)#)</td>
			</tr>
		</cfif>
		<cfif IsNumeric(qry_selectInvoicePaymentList.invoiceTotalTax) and qry_selectInvoicePaymentList.invoiceTotalTax is not 0>
			<tr>
				<td>Taxes: </td>
				<td>#DollarFormat(qry_selectInvoicePaymentList.invoiceTotalTax)#</td>
			</tr>
		</cfif>
		<cfif IsNumeric(qry_selectInvoicePaymentList.invoiceTotalShipping) and qry_selectInvoicePaymentList.invoiceTotalShipping is not 0>
			<tr>
				<td>Shipping: </td>
				<td>#DollarFormat(qry_selectInvoicePaymentList.invoiceTotalShipping)#</td>
			</tr>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "deleteInvoicePayment")>
			<tr>
				<td></td>
				<td></td>
				<td bgcolor="dddddd">[<font class="SmallText"><a href="index.cfm?method=#URL.control#.deleteInvoicePayment#Variables.urlParameters#&paymentID=#URL.paymentID#&invoiceID=#qry_selectInvoicePaymentList.invoiceID#" class="plainlink" title="Remove Invoice From Payment?" onclick="return confirm('Are you sure you want to remove the invoice from the payment? If yes, click OK. If unsure, click Cancel.');">Remove Invoice From Payment</a></font>]</td>
			</tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>