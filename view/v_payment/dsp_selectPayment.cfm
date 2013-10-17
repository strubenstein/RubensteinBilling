<!--- paymentStatus --->
<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif qry_selectPayment.paymentStatus is 0>
	<tr>
		<td colspan="2"><b>This <cfif qry_selectPayment.paymentIsRefund is 0>payment<cfelse>refund</cfif> payment is currently inactive/ignored.</b></td>
	</tr>
</cfif>
<cfif qry_selectPayment.paymentIsRefund is 0 and qry_selectPayment.paymentID_refund is not 0>
	<tr>
		<td colspan="2">
			<b>This payment has been refunded.</b>
			<cfif ListFind(Variables.permissionActionList, "viewPaymentRefund")>
				 [ <a href="index.cfm?method=payment.viewPaymentRefund&paymentID=#URL.paymentID#" class="plainlink">View Refund</a> ]
			</cfif>
		</td>
	</tr>
</cfif>
<cfif qry_selectPayment.userID_author is not 0>
	<tr>
		<td>Processed By: </td>
		<td>#qry_selectPayment.authorFirstName# #qry_selectPayment.authorLastName#</td>
	</tr>
</cfif>
<cfif qry_selectPayment.companyID is not 0>
	<tr>
		<td>Target Company: </td>
		<td>
			#qry_selectPayment.targetCompanyName#
			<cfif ListFind(Variables.permissionActionList, "viewCompany")>
				 (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectPayment.companyID#" class="plainlink">go</a>)
			</cfif>
		</td>
	</tr>
</cfif>
<cfif qry_selectPayment.userID is not 0>
	<tr>
		<td>Target Name: </td>
		<td>
			#qry_selectPayment.targetFirstName# #qry_selectPayment.targetLastName#
			<cfif ListFind(Variables.permissionActionList, "viewUser")>
				 (<a href="index.cfm?method=user.viewUser&userID=#qry_selectPayment.userID#" class="plainlink">go</a>)
			</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Approval Status: </td>
	<td>#fn_DisplayPaymentApproved(qry_selectPayment.paymentApproved)#</td>
</tr>
<tr>
	<td>Amount: </td>
	<td>#DollarFormat(qry_selectPayment.paymentAmount)#</td>
</tr>
<cfif qry_selectPayment.paymentID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectPayment.paymentID_custom#</td>
	</tr>
</cfif>
<cfif qry_selectPayment.paymentDescription is not "">
	<tr valign="top">
		<td>Description: </td>
		<td>#qry_selectPayment.paymentDescription#</td>
	</tr>
</cfif>
<cfif qry_selectPayment.paymentCategoryID is not 0 and IsDefined("qry_selectPaymentCategory") and qry_selectPaymentCategory.RecordCount is not 0>
	<tr>
		<td>Payment Category: </td>
		<td>#qry_selectPaymentCategory.paymentCategoryName#</td>
	</tr>
</cfif>
<cfif qry_selectPayment.paymentMessage is not "">
	<tr>
		<td>Error Message: </td>
		<td>#qry_selectPayment.paymentMessage#</td>
	</tr>
</cfif>
<tr>
	<td>Date <cfif qry_selectPayment.paymentIsRefund is 0>Received<cfelse>Processed</cfif>: </td>
	<td>#DateFormat(qry_selectPayment.paymentDateReceived, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectPayment.paymentDateReceived, "hh:mm tt")#</td>
</tr>
<cfif IsDate(qry_selectPayment.paymentDateScheduled)>
	<tr>
		<td>Scheduled Processing Date: </td>
		<td>#DateFormat(qry_selectPayment.paymentDateScheduled, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectPayment.paymentDateScheduled, "hh:mm tt")#</td>
	</tr>
</cfif>
<tr>
	<td>Date Recorded: </td>
	<td>#DateFormat(qry_selectPayment.paymentDateCreated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectPayment.paymentDateCreated, "hh:mm tt")#</td>
</tr>
<tr>
	<td>Recorded Method: </td>
	<td><cfif qry_selectPayment.paymentManual is 0>Automatically via scheduled script<cfelse>Manually by a user</cfif></td>
</tr>
<tr>
	<td>Date Last Updated: </td>
	<td>#DateFormat(qry_selectPayment.paymentDateUpdated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectPayment.paymentDateUpdated, "hh:mm tt")#</td>
</tr>
<tr valign="top">
	<td>#Variables.paymentOrRefundTextUcase# Method: </td>
	<td>
	<cfswitch expression="#qry_selectPayment.paymentMethod#">
	<cfcase value="creditCard">
		Credit card
		<cfif qry_selectPayment.creditCardID is 0>
			 - Not Specified
		<cfelse>
			<cfif Variables.displayMerchantAccount is True>
				 - Processed via merchant account: <cfif qry_selectMerchantAccount.merchantAccountName is not "">#qry_selectMerchantAccount.merchantAccountName#<cfelse>#qry_selectMerchantAccount.merchantTitle#</cfif><br>
			<cfelse>
				 - Processed via the system<br>
			</cfif>
			<cfif Variables.displayCreditCard is True>
				<cfif qry_selectCreditCard.creditCardName is not "">#qry_selectCreditCard.creditCardName#<br></cfif>
				<cfif qry_selectCreditCard.creditCardType is not "">#qry_selectCreditCard.creditCardType# &nbsp; </cfif>
				<cfif qry_selectCreditCard.creditCardNumber is not "">#RepeatString("*", Len(qry_selectCreditCard.creditCardNumber) - 4)##Right(qry_selectCreditCard.creditCardNumber, 4)# &nbsp; </cfif>
				Expires #qry_selectCreditCard.creditCardExpirationMonth#/#qry_selectCreditCard.creditCardExpirationYear#
			</cfif>
		</cfif>
	</cfcase>
	<cfcase value="bank">
		Bank
		<cfif qry_selectPayment.bankID is 0>
			 - Not Specified
		<cfelse>
			<cfif Variables.displayMerchantAccount is True>
				 - Processed via merchant account: <cfif qry_selectMerchantAccount.merchantAccountName is not "">#qry_selectMerchantAccount.merchantAccountName#<cfelse>#qry_selectMerchantAccount.merchantTitle#</cfif><br>
			<cfelse>
				 - Processed via the system<br>
			</cfif>
			<cfif Variables.displayBank is True>
				<cfif qry_selectBank.bankName is not "">#qry_selectBank.bankName# </cfif>
				<cfif qry_selectBank.bankAccountNumber is not "">#qry_selectBank.bankAccountNumber#</cfif><br>
				<cfif qry_selectBank.bankAccountName is not "">#qry_selectBank.bankAccountName# </cfif>
				(<cfif qry_selectBank.bankPersonalOrCorporate is 0>Personal<cfelse>Corporate</cfif> 
				<cfif qry_selectBank.bankCheckingOrSavings is 0>Checking<cfelseif qry_selectBank.bankCheckingOrSavings is 1>Savings<cfelseif qry_selectBank.bankAccountType is not "">#qry_selectBank.bankAccountType#</cfif>)
			</cfif>
		</cfif>
	</cfcase>
	<cfcase value="cash,barter,services,other">
		#UCase(Left(qry_selectPayment.paymentMethod, 1))##Mid(qry_selectPayment.paymentMethod, 2, Len(qry_selectPayment.paymentMethod) - 1)#
	</cfcase>
	<cfcase value="check,certified check,cashier check">
		#UCase(Left(qry_selectPayment.paymentMethod, 1))##Mid(qry_selectPayment.paymentMethod, 2, Len(qry_selectPayment.paymentMethod) - 1)#
		<cfif qry_selectPayment.paymentCheckNumber is not 0> - check ###qry_selectPayment.paymentCheckNumber#</cfif>
	</cfcase>
	<cfdefaultcase><!--- other specified --->
		#qry_selectPayment.paymentMethod#
	</cfdefaultcase>
	</cfswitch>
	</td>
</tr>
<cfif Application.fn_IsUserAuthorized("exportPayments")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectPayment.paymentIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectPayment.paymentIsExported is not "" and IsDate(qry_selectPayment.paymentDateExported)>
				on #DateFormat(qry_selectPayment.paymentDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectPayment.paymentDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>
</cfoutput>
