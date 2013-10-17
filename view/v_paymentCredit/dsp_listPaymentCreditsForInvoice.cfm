<cfoutput>
<cfif qry_selectInvoicePaymentCreditList.RecordCount is 0>
	<p class="ErrorMessage">No payment credits have been applied to this invoice.</p>
<cfelse>
	<cfloop Query="qry_selectInvoicePaymentCreditList">
		<p>
		<cfif ListFind(Variables.permissionActionList, "viewPaymentCredit")>
			<div class="TableText">[ <a href="index.cfm?method=paymentCredit.viewPaymentCredit&paymentCreditID=#qry_selectInvoicePaymentCreditList.paymentCreditID#" class="plainlink">View Payment Credit</a> ]</div>
		</cfif>
		<table border="0" cellspacing="2" cellpadding="2" class="MainText">
		<cfif CurrentRow is not 1>
			<tr><td colspan="2"><hr noshade size="2" align="left" width="100%"></td></tr>
		</cfif>
		<tr>
			<td>Credit Amount: </td>
			<td>
				#DollarFormat(qry_selectInvoicePaymentCreditList.invoicePaymentCreditAmount)#
				<cfif qry_selectInvoicePaymentCreditList.invoicePaymentCreditAmount is not qry_selectInvoicePaymentCreditList.paymentCreditAmount>
					of maximum #DollarFormat(qry_selectInvoicePaymentCreditList.paymentCreditAmount)#
				</cfif>
			</td>
		</tr>

		<cfif ListFind(Variables.permissionActionList, "updateInvoicePaymentCredit")>
			<form method="post" action="index.cfm?method=#URL.control#.updateInvoicePaymentCredit#Variables.urlParameters#&paymentCreditID=#qry_selectInvoicePaymentCreditList.paymentCreditID#&invoicePaymentCreditID=#qry_selectInvoicePaymentCreditList.invoicePaymentCreditID#">
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
		<cfif ListFind(Variables.permissionActionList, "deleteInvoicePaymentCredit")>
			<tr>
				<td></td>
				<td bgcolor="dddddd">[<font class="SmallText"><a href="index.cfm?method=#URL.control#.deleteInvoicePaymentCredit#Variables.urlParameters#&paymentCreditID=#qry_selectInvoicePaymentCreditList.paymentCreditID#&invoicePaymentCreditID=#qry_selectInvoicePaymentCreditList.invoicePaymentCreditID#" class="plainlink" title="Remove Payment From Invoice?" onclick="return confirm('Are you sure you want to remove the credit from the invoice? If yes, click OK. If unsure, click Cancel.');">Remove Credit From Invoice</a></font>]</td>
			</tr>
		</cfif>
		</table>
		</p>
	</cfloop>
</cfif>
</cfoutput>
