<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif qry_selectPaymentCredit.paymentCreditStatus is 0>
	<tr>
		<td colspan="2"><b>This payment credit is currently being ignored.</b></td>
	</tr>
</cfif>
<tr>
	<td>Completion Status: </td>
	<td>
		<cfif qry_selectPaymentCredit.paymentCreditCompleted is 1>
			Credit has been fully used.
		<cfelseif IsDate(qry_selectPaymentCredit.paymentCreditDateBegin) and DateCompare(Now(), qry_selectPaymentCredit.paymentCreditDateBegin) is -1>
			Before begin date. Credit not yet available.
		<cfelseif IsDate(qry_selectPaymentCredit.paymentCreditDateEnd) and DateCompare(Now(), qry_selectPaymentCredit.paymentCreditDateEnd) is not -1>
			After expiration date. Credit has expired.
		<cfelse>
			Credit is still available. Not yet fully used.
		</cfif>
	</td>
</tr>
<cfif qry_selectPaymentCredit.userID_author is not 0>
	<tr>
		<td>Created By: </td>
		<td>#qry_selectPaymentCredit.authorFirstName# #qry_selectPaymentCredit.authorLastName#</td>
	</tr>
</cfif>
<cfif qry_selectPaymentCredit.companyID is not 0>
	<tr>
		<td>Target Company: </td>
		<td>
			#qry_selectPaymentCredit.targetCompanyName#
			<cfif ListFind(Variables.permissionActionList, "viewCompany")>
				 (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectPaymentCredit.companyID#" class="plainlink">go</a>)
			</cfif>
		</td>
	</tr>
</cfif>
<cfif qry_selectPaymentCredit.subscriberID is not 0>
	<tr>
		<td>Target Subscriber: </td>
		<td>
			#qry_selectPaymentCredit.subscriberName#
			<cfif ListFind(Variables.permissionActionList, "viewSubscriber")>
				 (<a href="index.cfm?method=subscription.viewSubscriber&companyID=#qry_selectPaymentCredit.companyID#&subscriberID=#qry_selectPaymentCredit.subscriberID#" class="plainlink">go</a>)
			</cfif>
		</td>
	</tr>
</cfif>
<cfif qry_selectPaymentCredit.userID is not 0>
	<tr>
		<td>Target Name: </td>
		<td>
			#qry_selectPaymentCredit.targetFirstName# #qry_selectPaymentCredit.targetLastName#
			<cfif ListFind(Variables.permissionActionList, "viewUser")>
				 (<a href="index.cfm?method=user.viewUser&userID=#qry_selectPaymentCredit.userID#" class="plainlink">go</a>)
			</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Amount: </td>
	<td>#DollarFormat(qry_selectPaymentCredit.paymentCreditAmount)#</td>
</tr>
<tr>
	<td>## Times to Apply: </td>
	<td>
		Applied #qry_selectPaymentCredit.paymentCreditAppliedCount# 
		<cfif qry_selectPaymentCredit.paymentCreditAppliedCount is 1>time<cfelse>time(s)</cfif> 
		of #qry_selectPaymentCredit.paymentCreditAppliedMaximum# maximum
	</td>
</tr>
<tr>
	<td>Rollover: </td>
	<td>
		<cfif qry_selectPaymentCredit.paymentCreditRollover is 0>
			No - If invoice total is less than credit amount, customer does not receive remaining credit amount.
		<cfelse>
			Yes - Remaining credit amount rolls over to subsequent invoices until it is completely used.
		</cfif>
	</td>
</tr>
<tr>
	<td>Negative Invoice: </td>
	<td>
		<cfif qry_selectPaymentCredit.paymentCreditNegativeInvoice is 0>
			No - Applying credit cannot cause a negative invoice total, so customer does not receive full credit amount (separate from rollover setting).
		<cfelse>
			Yes - Customer receives full credit amount, even if it means a negative invoice total, i.e., customer refund.
		</cfif>
	</td>
</tr>

<cfif qry_selectPaymentCredit.paymentCreditName is not "">
	<tr>
		<td>Line Item Text: </td>
		<td>#qry_selectPaymentCredit.paymentCreditName#</td>
	</tr>
</cfif>
<cfif qry_selectPaymentCredit.paymentCreditID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectPaymentCredit.paymentCreditID_custom#</td>
	</tr>
</cfif>
<cfif qry_selectPaymentCredit.paymentCreditDescription is not "">
	<tr valign="top">
		<td>Description: </td>
		<td>#qry_selectPaymentCredit.paymentCreditDescription#</td>
	</tr>
</cfif>
<cfif qry_selectPaymentCredit.paymentCategoryID is not 0 and IsDefined("qry_selectPaymentCategory") and qry_selectPaymentCategory.RecordCount is not 0>
	<tr>
		<td>Payment Category: </td>
		<td>#qry_selectPaymentCategory.paymentCategoryName#</td>
	</tr>
</cfif>
<tr>
	<td>Date Created: </td>
	<td>#DateFormat(qry_selectPaymentCredit.paymentCreditDateCreated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectPaymentCredit.paymentCreditDateCreated, "hh:mm tt")#</td>
</tr>
<tr>
	<td>Begin Date: </td>
	<td>
		<cfif Not IsDate(qry_selectPaymentCredit.paymentCreditDateBegin)>
			No specified begin date (began immediately)
		<cfelse>
			#DateFormat(qry_selectPaymentCredit.paymentCreditDateBegin, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectPaymentCredit.paymentCreditDateBegin, "hh:mm tt")#
		</cfif>
	</td>
</tr>
<tr>
	<td>Expiration Date: </td>
	<td>
		<cfif Not IsDate(qry_selectPaymentCredit.paymentCreditDateEnd)>
			No expiration date
		<cfelse>
			#DateFormat(qry_selectPaymentCredit.paymentCreditDateEnd, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectPaymentCredit.paymentCreditDateEnd, "hh:mm tt")#
		</cfif>
	</td>
</tr>
<tr>
	<td>Date Last Updated: </td>
	<td>#DateFormat(qry_selectPaymentCredit.paymentCreditDateUpdated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectPaymentCredit.paymentCreditDateUpdated, "hh:mm tt")#</td>
</tr>
<cfif Application.fn_IsUserAuthorized("exportPaymentCredits")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectPaymentCredit.paymentCreditIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectPaymentCredit.paymentCreditIsExported is not "" and IsDate(qry_selectPaymentCredit.paymentCreditDateExported)>
				on #DateFormat(qry_selectPaymentCredit.paymentCreditDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectPaymentCredit.paymentCreditDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>

</cfoutput>
