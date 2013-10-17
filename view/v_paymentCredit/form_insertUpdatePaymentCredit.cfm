<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<script language="JavaScript">
function setTitle () {
	var newLineItemText = "";
	if (document.#Variables.formName#.paymentCreditName.value == "")
	{
		switch(document.#Variables.formName#.paymentCategoryID.value)
			{
			<cfloop Query="qry_selectPaymentCategoryList">case "#qry_selectPaymentCategoryList.paymentCategoryID#" : newLineItemText = "#qry_selectPaymentCategoryList.paymentCategoryTitle#"; break;</cfloop>
			default : newLineItemText = "";
			}
		document.#Variables.formName#.paymentCreditName.value = newLineItemText;
	}
}
</script>

<style type="text/css">
	.RedDisabled {color: red};
</style>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.displaySubscriberList is True and (Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "subscriberID"))>
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
			Select the subscriber for this company that should receive the credit.<br>
			If none selected, credit will never be applied to an invoice.
			</div>
		</td>
	</tr>
</cfif>
<cfif Variables.displayInvoiceLineItemList is True and (Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "invoiceLineItemID"))>
	<tr valign="top">
		<td>Invoice Line Item: </td>
		<td>
			<select name="invoiceLineItemID" size="5" multiple>
			<cfloop Query="qry_selectInvoiceLineItemList">
				<option value="#qry_selectInvoiceLineItemList.invoiceLineItemID#"<cfif Form.invoiceLineItemID is qry_selectInvoiceLineItemList.invoiceLineItemID> selected</cfif>>#qry_selectInvoiceLineItemList.invoiceLineItemOrder#. #HTMLEditFormat(qry_selectInvoiceLineItemList.invoiceLineItemName)# -- #DollarFormat(qry_selectInvoiceLineItemList.invoiceLineItemTotal)#</option>
			</cfloop>
			</select>
			<div class="SmallText">Select the line item(s) from this invoice that is the source of this credit.</div>
		</td>
	</tr>
</cfif>
<cfif Variables.displaySubscriptionList is True and (Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "subscriptionID"))>
	<tr valign="top">
		<td>Product Subscription: </td>
		<td>
			<select name="subscriptionID" size="5" multiple>
			<cfloop Query="qry_selectSubscriptionList">
				<cfif Variables.displaySubscriberList is True and qry_selectSubscriberList.RecordCount gt 1 and (CurrentRow is 1 or qry_selectSubscriptionList.subscriberID is not qry_selectSubscriptionList.subscriberID[CurrentRow - 1])>
					<cfset Variables.subRow = ListFind(ValueList(qry_selectSubscriberList.subscriberID), qry_selectSubscriptionList.subscriberID)>
					<cfif Variables.subRow is not 0><option value="0" class="RedDisabled">-- Subscriber: #HTMLEditFormat(qry_selectSubscriberList.subscriberName[Variables.subRow])# --</option></cfif>
				</cfif>
				<option value="#qry_selectSubscriptionList.subscriptionID#"<cfif Form.subscriptionID is qry_selectSubscriptionList.subscriptionID> selected</cfif>>#qry_selectSubscriptionList.subscriptionOrder#. #HTMLEditFormat(qry_selectSubscriptionList.subscriptionName)# -- #DollarFormat(qry_selectSubscriptionList.subscriptionPriceUnit * qry_selectSubscriptionList.subscriptionQuantity)#</option>
			</cfloop>
			</select>
			<div class="SmallText">Select the product subscription(s) that is the source of this credit.</div>
		</td>
	</tr>
</cfif>

<cfif Variables.doAction is "updatePaymentCredit" and ListFind(Variables.updatePaymentFieldList, "paymentCreditStatus")>
	<tr>
		<td>Status: </td>
		<td>
			<label style="color: green"><input type="radio" name="paymentCreditStatus" value="1"<cfif Form.paymentCreditStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; &nbsp; 
			<label style="color: red"><input type="radio" name="paymentCreditStatus" value="0"<cfif Form.paymentCreditStatus is not 1> checked</cfif>>Ignored</label>
		</td>
	</tr>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCategoryID")>
	<tr valign="top">
		<td>Category: </td>
		<td>
			<select name="paymentCategoryID" size="1"<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditName")> onChange="setTitle();"</cfif>>
			<option value="">-- SELECT CATEGORY --</option>
			<cfloop Query="qry_selectPaymentCategoryList">
				<cfif qry_selectPaymentCategoryList.paymentCategoryStatus is 1 or Form.paymentCategoryID is qry_selectPaymentCategoryList.paymentCategoryID>
					<option value="#qry_selectPaymentCategoryList.paymentCategoryID#" <cfif Form.paymentCategoryID is qry_selectPaymentCategoryList.paymentCategoryID> selected</cfif>>#HTMLEditFormat(qry_selectPaymentCategoryList.paymentCategoryName)#</option>
				</cfif>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>
<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditName")>
	<tr valign="top">
		<td>Line Item Text: </td>
		<td><input type="text" name="paymentCreditName" value="#HTMLEditFormat(Form.paymentCreditName)#" size="50" maxlength="#maxlength_PaymentCredit.paymentCreditName#"></td>
	</tr>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditAmount")>
	<tr>
		<td>Credit Amount: </td>
		<td>$<input type="text" name="paymentCreditAmount"<cfif IsNumeric(Form.paymentCreditAmount)> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.paymentCreditAmount)#"</cfif> size="10"> (#maxlength_PaymentCredit.paymentCreditAmount# decimal places permitted)</td>
	</tr>
</cfif>
<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditID_custom")>
	<tr>
		<td>Custom ID: </td>
		<td><input type="text" name="paymentCreditID_custom" value="#HTMLEditFormat(Form.paymentCreditID_custom)#" size="20" maxlength="#maxlength_PaymentCredit.paymentCreditID_custom#"></td>
	</tr>
</cfif>
<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditDescription")>
	<tr>
		<td>Description: </td>
		<td><input type="text" name="paymentCreditDescription" value="#HTMLEditFormat(Form.paymentCreditDescription)#" size="50" maxlength="#maxlength_PaymentCredit.paymentCreditDescription#"></td>
	</tr>
</cfif>
<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditRollover")>
	<tr valign="top">
		<td>Roll Over: </td>
		<td>
			<label><input type="radio" name="paymentCreditRollover" value="0"<cfif Form.paymentCreditRollover is not 1> checked</cfif>>
			No - If invoice total is less than credit amount, customer does not receive remaining credit amount.</label><br>
			<label><input type="radio" name="paymentCreditRollover" value="1"<cfif Form.paymentCreditRollover is 1> checked</cfif>>
			Yes - Remaining credit amount rolls over to subsequent invoices until it is completely used.</label>
		</td>
	</tr>
</cfif>
<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditNegativeInvoice")>
	<tr valign="top">
		<td>Negative Invoice: </td>
		<td>
			<label><input type="radio" name="paymentCreditNegativeInvoice" value="0"<cfif Form.paymentCreditNegativeInvoice is not 1> checked</cfif>>
			No - If invoice total is less than credit amount, customer does not receive remaining credit amount.</label><br>
			<label><input type="radio" name="paymentCreditNegativeInvoice" value="1"<cfif Form.paymentCreditNegativeInvoice is 1> checked</cfif>>
			Yes - Remaining credit amount rolls over to subsequent invoices until it is completely used.</label>
		</td>
	</tr>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditAppliedMaximum")>
	<tr valign="top">
		<td>## Times to Apply: </td>
		<td>
			<input type="text" name="paymentCreditAppliedMaximum" value="#HTMLEditFormat(Form.paymentCreditAppliedMaximum)#" size="2">
			<cfif Variables.doAction is "updatePaymentCredit">
				<cfif Form.paymentCreditAppliedCount is 0>
					 (not yet applied)
				<cfelseif Form.paymentCreditAppliedCount is 1>
					(already applied #Form.paymentCreditAppliedCount# time)
				<cfelse>
					(already applied #Form.paymentCreditAppliedCount# times)
				</cfif>
			</cfif>
			<div class="SmallText">
			If more than one, credit is applied to subsequent invoices.<br>
			If zero, credit is applied to <u>all</u> future invoices until credit is made inactive.
			</div>
		</td>
	</tr>
</cfif>
<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditDateBegin")>
	<tr valign="top">
		<td>Beginning Date: </td>
		<td>
			#fn_FormSelectDateTime(Variables.formName, "paymentCreditDateBegin_date", Form.paymentCreditDateBegin_date, "", 0, "", 0, "", "am", True)#
			<div class="SmallText">
			Specifies the first date the credit should be applied to invoice. Defaults to today or to existing open invoice.<br>
			If other date, credit is applied to the first invoice created after begin date.<br>
			<cfif URL.control is "invoice">
				<font style="width:550">
				INVOICE NOTE: Because you are creating this payment credit via an existing invoice, the credit will automatically be
				applied to this invoice regardless of the begin date. To create a credit that does not apply to this invoice, create
				the credit via the customer's company and not this invoice. To do so, <a href="index.cfm?method=company.insertPaymentCredit&companyID=#Variables.companyID#" class="bluelink">click here</a>.
			</cfif>
			</font>
			</div>
		</td>
	</tr>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditDateEnd")>
	<tr valign="top">
		<td>Expiration Date: </td>
		<td>
			#fn_FormSelectDateTime(Variables.formName, "paymentCreditDateEnd_date", Form.paymentCreditDateEnd_date, "", 0, "", 0, "", "am", True)#
			<div class="SmallText">
			Specifies the last date the credit can be applied to invoice. No date means the credit does not expire (until used).<br>
			The expiration date means the credit will expire at the end of that day, i.e., 11:59 pm.<br>
			</font>
			</div>
		</td>
	</tr>
</cfif>

<tr>
	<td></td>
	<td><input type="submit" name="submitPaymentCredit" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>

</form>
</cfoutput>
