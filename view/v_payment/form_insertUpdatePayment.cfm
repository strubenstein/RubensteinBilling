<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<style type="text/css">
	.RedDisabled {color: red};
</style>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif displaySubscriberList is True and (ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "subscriberID"))>
	<tr valign="top">
		<td>Subscriber: </td>
		<td>
			<select name="subscriberID" size="1">
			<option value="0"<cfif Form.subscriberID is 0> selected</cfif>> -- NO SUBSCRIBER SPECIFIED --</option>
			<cfloop Query="qry_selectSubscriberList">
				<option value="#qry_selectSubscriberList.subscriberID#"<cfif Form.subscriberID is qry_selectSubscriberList.subscriberID> selected</cfif>>#HTMLEditFormat(qry_selectSubscriberList.subscriberName)#</option>
			</cfloop>
			</select>
			<div class="SmallText">
			Select the subscriber for this company that this #Variables.paymentOrRefundText# should apply to.<br>
			</div>
		</td>
	</tr>
</cfif>
<cfif displayInvoiceLineItemList is True and (Variables.doAction is "insertPaymentRefund" or ListFind(Variables.updatePaymentFieldList, "invoiceLineItemID"))>
	<tr valign="top">
		<td>Invoice Line Item: </td>
		<td>
			<select name="invoiceLineItemID" size="5" multiple>
			<cfloop Query="qry_selectInvoiceLineItemList">
				<option value="#qry_selectInvoiceLineItemList.invoiceLineItemID#"<cfif Form.invoiceLineItemID is qry_selectInvoiceLineItemList.invoiceLineItemID> selected</cfif>>#qry_selectInvoiceLineItemList.invoiceLineItemOrder#. #HTMLEditFormat(qry_selectInvoiceLineItemList.invoiceLineItemName)# -- #DollarFormat(qry_selectInvoiceLineItemList.invoiceLineItemTotal)#</option>
			</cfloop>
			</select>
			<div class="SmallText">Select the line item(s) from this invoice that is the source of this refund.</div>
		</td>
	</tr>
</cfif>
<cfif displaySubscriptionList is True and (Variables.doAction is "insertPaymentRefund" or ListFind(Variables.updatePaymentFieldList, "subscriptionID"))>
	<tr valign="top">
		<td>Product Subscription: </td>
		<td>
			<select name="subscriptionID" size="5" multiple>
			<cfloop Query="qry_selectSubscriptionList">
				<cfif displaySubscriberList is True and qry_selectSubscriberList.RecordCount gt 1 and (CurrentRow is 1 or qry_selectSubscriptionList.subscriberID is not qry_selectSubscriptionList.subscriberID[CurrentRow - 1])>
					<cfset Variables.subRow = ListFind(ValueList(qry_selectSubscriberList.subscriberID), qry_selectSubscriptionList.subscriberID)>
					<cfif Variables.subRow is not 0><option value="0" class="RedDisabled">-- Subscriber: #HTMLEditFormat(qry_selectSubscriberList.subscriberName[Variables.subRow])# --</option></cfif>
				</cfif>
				<option value="#qry_selectSubscriptionList.subscriptionID#"<cfif Form.subscriptionID is qry_selectSubscriptionList.subscriptionID> selected</cfif>>#qry_selectSubscriptionList.subscriptionOrder#. #HTMLEditFormat(qry_selectSubscriptionList.subscriptionName)# -- #DollarFormat(qry_selectSubscriptionList.subscriptionPriceUnit * qry_selectSubscriptionList.subscriptionQuantity)#</option>
			</cfloop>
			</select>
			<div class="SmallText">Select the product subscription(s) that is the source of this refund.</div>
		</td>
	</tr>
</cfif>

<cfif Variables.doAction is "updatePayment" and ListFind(Variables.updatePaymentFieldList, "paymentStatus")>
	<tr>
		<td>Status: </td>
		<td>
			<label style="color: green"><input type="radio" name="paymentStatus" value="1"<cfif Form.paymentStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; &nbsp; 
			<label style="color: red"><input type="radio" name="paymentStatus" value="0"<cfif Form.paymentStatus is not 1> checked</cfif>>Inactive/Ignored</label>
		</td>
	</tr>
</cfif>
<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentCategoryID")>
	<tr valign="top">
		<td>Category: </td>
		<td>
			<select name="paymentCategoryID" size="1">
			<option value="0">-- SELECT CATEGORY --</option>
			<cfloop Query="qry_selectPaymentCategoryList">
				<cfif qry_selectPaymentCategoryList.paymentCategoryStatus is 1 or Form.paymentCategoryID is qry_selectPaymentCategoryList.paymentCategoryID>
					<option value="#qry_selectPaymentCategoryList.paymentCategoryID#"<cfif Form.paymentCategoryID is qry_selectPaymentCategoryList.paymentCategoryID> selected</cfif>>#HTMLEditFormat(qry_selectPaymentCategoryList.paymentCategoryName)#</option>
				</cfif>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>
<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentApproved")>
	<tr valign="top">
		<td>Approval Status: </td>
		<td>
			<label><input type="radio" name="paymentApproved" value=""<cfif Form.paymentApproved is ""> checked</cfif>>Unknown</label> &nbsp; 
			<label style="color: red"><input type="radio" name="paymentApproved" value="0"<cfif Form.paymentApproved is 0> checked</cfif>>Rejected/Bounced</label> &nbsp; 
			<label style="color: green"><input type="radio" name="paymentApproved" value="1"<cfif Form.paymentApproved is 1> checked</cfif>>Approved/Cleared</label>
			<div class="SmallText">If processing bank or credit card now, check &quot;Unknown&quot; now.<br>It will automatically be updated based on the transaction success.</div>
		</td>
	</tr>
</cfif>
<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentAmount")>
	<tr>
		<td>#Variables.paymentOrRefundTextUcase# Amount: </td>
		<td>$<input type="text" name="paymentAmount"<cfif IsNumeric(Form.paymentAmount)> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.paymentAmount)#"</cfif> size="10"> (#maxlength_Payment.paymentAmount# decimal places permitted)</td>
	</tr>
</cfif>
<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentDateReceived")>
	<tr>
		<td>Date <cfif Variables.doAction is "insertPayment">Received<cfelse>Processed</cfif>: </td>
		<td>#fn_FormSelectDateTime(Variables.formName, "paymentDateReceived_date", Form.paymentDateReceived_date, "paymentDateReceived_hh", Form.paymentDateReceived_hh, "paymentDateReceived_mm", Form.paymentDateReceived_mm, "paymentDateReceived_tt", Form.paymentDateReceived_tt, True)#</td>
	</tr>
</cfif>
<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentID_custom")>
	<tr>
		<td>Custom ID: </td>
		<td><input type="text" name="paymentID_custom" value="#HTMLEditFormat(Form.paymentID_custom)#" size="20" maxlength="#maxlength_Payment.paymentID_custom#"></td>
	</tr>
</cfif>
<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentDescription")>
	<tr>
		<td>Description: </td>
		<td><input type="text" name="paymentDescription" value="#HTMLEditFormat(Form.paymentDescription)#" size="50" maxlength="#maxlength_Payment.paymentDescription#"></td>
	</tr>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentMethod")>
	<tr valign="top">
		<td>#Variables.paymentOrRefundTextUcase# Method:&nbsp;</td>
		<td>
			<cfif qry_selectCreditCardList.RecordCount is 0>
				<label><input type="radio" name="paymentMethod_select" value="credit card"<cfif Form.paymentMethod_select is "credit card"> checked</cfif>>Credit Card - Not Specified</label><br>
			<cfelse>
				<i><b>Credit Card:</b></i><br>
				<label><input type="radio" name="paymentMethod_select" value="credit card"<cfif Form.paymentMethod_select is "credit card"> checked</cfif>>Credit Card - Not Specified</label><br>
				<table border="0" cellspacing="0" cellpadding="0" class="TableText">
				<cfloop Query="qry_selectCreditCardList">
					<tr valign="top"<cfif (CurrentRow mod 2) is 1> bgcolor="f4f4ff"</cfif>>
					<td><input type="radio" name="paymentMethod_select" value="creditCard#qry_selectCreditCardList.creditCardID#"<cfif Form.paymentMethod_select is "creditCard#qry_selectCreditCardList.creditCardID#"> checked</cfif>></td>
					<td>
						<cfif qry_selectCreditCardList.creditCardName is not "">#qry_selectCreditCardList.creditCardName#<br></cfif>
						<cfif qry_selectCreditCardList.creditCardType is not "">#qry_selectCreditCardList.creditCardType# &nbsp; </cfif>
						<cfif qry_selectCreditCardList.creditCardNumber is not "">#RepeatString("*", Len(qry_selectCreditCardList.creditCardNumber) - 4)##Right(qry_selectCreditCardList.creditCardNumber, 4)# &nbsp; </cfif>
						Expires #qry_selectCreditCardList.creditCardExpirationMonth#/#qry_selectCreditCardList.creditCardExpirationYear#
					</td>
					</tr>
				</cfloop>
				<tr><td colspan="2" height="3" align="center"><img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr>
				</table>
			</cfif>

			<cfif qry_selectBankList.RecordCount is 0>
				<label><input type="radio" name="paymentMethod_select" value="bank"<cfif Form.paymentMethod_select is "bank"> checked</cfif>>Bank - Not Specified</label><br>
			<cfelse>
				<i><b>Bank/ACH:</b></i><br>
				<label><input type="radio" name="paymentMethod_select" value="bank"<cfif Form.paymentMethod_select is "bank"> checked</cfif>>Bank - Not Specified</label><br>
				<table border="0" cellspacing="0" cellpadding="0" class="TableText">
				<cfloop Query="qry_selectBankList">
					<tr valign="top"<cfif (CurrentRow mod 2) is 1> bgcolor="f4f4ff"</cfif>>
					<td><input type="radio" name="paymentMethod_select" value="bank#qry_selectBankList.bankID#"<cfif Form.paymentMethod_select is "bank#qry_selectBankList.bankID#"> checked</cfif>></td>
					<td>
						<cfif qry_selectBankList.bankName is not "">#qry_selectBankList.bankName# </cfif>
						<cfif qry_selectBankList.bankAccountNumber is not "">#qry_selectBankList.bankAccountNumber#</cfif><br>
						<cfif qry_selectBankList.bankAccountName is not "">#qry_selectBankList.bankAccountName# </cfif>
						(<cfif qry_selectBankList.bankPersonalOrCorporate is 0>Personal<cfelse>Corporate</cfif> 
						<cfif qry_selectBankList.bankCheckingOrSavings is 0>Checking<cfelseif qry_selectBankList.bankCheckingOrSavings is 1>Savings<cfelseif qry_selectBankList.bankAccountType is not "">#qry_selectBankList.bankAccountType#</cfif>)
					</td>
					</tr>
				</cfloop>
				<tr><td colspan="2" height="3" align="center"><img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr>
				</table>
			</cfif>
			<label><input type="radio" name="paymentMethod_select" value="cash"<cfif Form.paymentMethod_select is "cash"> checked</cfif>>Cash</label><br>
			<label><input type="radio" name="paymentMethod_select" value="check"<cfif Form.paymentMethod_select is "check"> checked</cfif>>Check</label> 
				##: <input type="text" name="paymentCheckNumber_check" value="#HTMLEditFormat(Form.paymentCheckNumber_check)#" size="6"><br>
			<label><input type="radio" name="paymentMethod_select" value="certified check"<cfif Form.paymentMethod_select is "certified check"> checked</cfif>>Certified Check</label>
				##: <input type="text" name="paymentCheckNumber_certified" value="#HTMLEditFormat(Form.paymentCheckNumber_certified)#" size="6"><br>
			<label><input type="radio" name="paymentMethod_select" value="cashier check"<cfif Form.paymentMethod_select is "cashier check"> checked</cfif>>Cashier's Check</label>
				##: <input type="text" name="paymentCheckNumber_cashier" value="#HTMLEditFormat(Form.paymentCheckNumber_cashier)#" size="6"><br>
			<label><input type="radio" name="paymentMethod_select" value="barter"<cfif Form.paymentMethod_select is "barter"> checked</cfif>>Barter</label><br>
			<label><input type="radio" name="paymentMethod_select" value="services"<cfif Form.paymentMethod_select is "services"> checked</cfif>>Services</label><br>
			<label><input type="radio" name="paymentMethod_select" value="other"<cfif Form.paymentMethod_select is "other"> checked</cfif>>Other:</label> 
				<input type="text" name="paymentMethod_text" value="#HTMLEditFormat(Form.paymentMethod_text)#" size="20" maxlength="#maxlength_Payment.paymentMethod#">
		</td>
	</tr>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentDateScheduled")>
	<cfif qry_selectMerchantAccountList.RecordCount is 0>
		<input type="hidden" name="paymentProcessed" value="0">
		<input type="hidden" name="merchantAccountID" value="0">
	<cfelse>
		<tr valign="top">
			<td><br>Process #Variables.paymentOrRefundTextUcase#:&nbsp;</td>
			<td><br>
				<label><input type="radio" name="paymentProcessed" value="0"<cfif Form.paymentProcessed is 0> checked</cfif>>Do not process payment (<i>or payment method is not credit card or bank</i>)</label><br>
				<label><input type="radio" name="paymentProcessed" value="1"<cfif Form.paymentProcessed is 1> checked</cfif>>Process payment now (<i>uses merchant account specified below</i>)</label><br>
				<label><input type="radio" name="paymentProcessed" value=""<cfif Form.paymentProcessed is ""> checked</cfif>>Schedule payment:</label> 
				#fn_FormSelectDateTime(Variables.formName, "paymentDateScheduled_date", Form.paymentDateScheduled_date, "paymentDateScheduled_hh", Form.paymentDateScheduled_hh, "paymentDateScheduled_mm", Form.paymentDateScheduled_mm, "paymentDateScheduled_tt", Form.paymentDateScheduled_tt, True)#
			</td>
		</tr>
		<tr valign="top">
			<td>Merchant Account:&nbsp;</td>
			<td>
				<cfif qry_selectMerchantAccountList.RecordCount is 1>
					<input type="hidden" name="merchantAccountID" value="#qry_selectMerchantAccountList.merchantAccountID#">
					<cfif qry_selectMerchantAccountList.merchantAccountName is not "">#qry_selectMerchantAccountList.merchantAccountName#<cfelse>#qry_selectMerchantAccountList.merchantTitle#</cfif> 
					<cfif qry_selectMerchantAccountList.merchantAccountBank is 1 and qry_selectMerchantAccountList.merchantAccountCreditCard is 1>
						(bank/ACH &amp; <cfif qry_selectMerchantAccountList.merchantAccountCreditCardTypeList is "">credit card<cfelse>#qry_selectMerchantAccountList.merchantAccountCreditCardTypeList#</cfif>)
					<cfelseif qry_selectMerchantAccountList.merchantAccountBank is 1>
						(bank/ACH)
					<cfelseif qry_selectMerchantAccountList.merchantAccountCreditCardTypeList is not "">
						(#qry_selectMerchantAccountList.merchantAccountCreditCardTypeList#)
					<cfelseif qry_selectMerchantAccountList.merchantAccountCreditCard is 1>
						(credit card)
					</cfif>
				<cfelse>
					<i><b>Select Merchant Account:</b></i> 
					<table border="0" cellspacing="0" cellpadding="0" class="TableText">
					<cfloop Query="qry_selectMerchantAccountList">
						<tr valign="top"<cfif (CurrentRow mod 2) is 1> bgcolor="f4f4ff"</cfif>>
						<td><input type="radio" name="merchantAccountID" value="#qry_selectMerchantAccountList.merchantAccountID#"<cfif Form.merchantAccountID is qry_selectMerchantAccountList.merchantAccountID> checked</cfif>></td>
						<td>
							<cfif qry_selectMerchantAccountList.merchantAccountName is not "">#qry_selectMerchantAccountList.merchantAccountName#<cfelse>#qry_selectMerchantAccountList.merchantTitle#</cfif> 
							<cfif qry_selectMerchantAccountList.merchantAccountBank is 1 and qry_selectMerchantAccountList.merchantAccountCreditCard is 1>
								(bank/ACH &amp; <cfif qry_selectMerchantAccountList.merchantAccountCreditCardTypeList is "">credit card<cfelse>#qry_selectMerchantAccountList.merchantAccountCreditCardTypeList#</cfif>)
							<cfelseif qry_selectMerchantAccountList.merchantAccountBank is 1>
								(bank/ACH)
							<cfelseif qry_selectMerchantAccountList.merchantAccountCreditCardTypeList is not "">
								(#qry_selectMerchantAccountList.merchantAccountCreditCardTypeList#)
							<cfelseif qry_selectMerchantAccountList.merchantAccountCreditCard is 1>
								(credit card)
							</cfif>
							<cfif qry_selectMerchantAccountList.merchantAccountDescription is not "">
								<div class="SmallText"><i>Description</i>: #qry_selectMerchantAccountList.merchantAccountDescription#</div>
							</cfif>
						</td>
						</tr>
					</cfloop>
					</table>
				</cfif>
			</td>
		</tr>
	</cfif>
</cfif>

<tr>
	<td></td>
	<td><input type="submit" name="submitPayment" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>

</form>
</cfoutput>
