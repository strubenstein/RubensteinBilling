<cfoutput>
<script language="JavaScript">
function setTitle () {
	if (document.#Variables.formName#.paymentCategoryTitle.value == "")
	document.#Variables.formName#.paymentCategoryTitle.value = document.#Variables.formName#.paymentCategoryName.value;
}
</script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.doAction is "insertPaymentCategory">
	<tr>
		<td>Order: </td>
		<td>
			<select name="paymentCategoryOrder" size="1">
			<cfloop Query="qry_selectPaymentCategoryList">
				<option value="#qry_selectPaymentCategoryList.paymentCategoryOrder#"<cfif Form.paymentCategoryOrder is qry_selectPaymentCategoryList.paymentCategoryOrder> selected</cfif>>Before ###qry_selectPaymentCategoryList.paymentCategoryOrder# #HTMLEditFormat(qry_selectPaymentCategoryList.paymentCategoryName)#</option>
			</cfloop>
			<option value="0"<cfif Form.paymentCategoryOrder is 0> selected</cfif>>-- LAST CATEGORY --</option>
			</select>
		</td>
	</tr>
</cfif>
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="paymentCategoryStatus" value="1"<cfif Form.paymentCategoryStatus is 1> checked</cfif>>Active</label> &nbsp; 
		<label style="color: red"><input type="radio" name="paymentCategoryStatus" value="0"<cfif Form.paymentCategoryStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr>
	<td>Name: </td>
	<td><input type="text" name="paymentCategoryName" value="#HTMLEditFormat(Form.paymentCategoryName)#" size="30" maxlength="#maxlength_PaymentCategory.paymentCategoryName#" onBlur="javascript:setTitle();"> (required; listed in select list)</td>
</tr>
<tr>
	<td>Title: </td>
	<td><input type="text" name="paymentCategoryTitle" value="#HTMLEditFormat(Form.paymentCategoryTitle)#" size="30" maxlength="#maxlength_PaymentCategory.paymentCategoryTitle#"> (displayed on invoice)</td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="paymentCategoryID_custom" value="#HTMLEditFormat(Form.paymentCategoryID_custom)#" size="30" maxlength="#maxlength_PaymentCategory.paymentCategoryID_custom#"> (optional; for integration purposes)</td>
</tr>
<tr>
	<td colspan="2">Select the payment method(s) for which this payment category should automatically be used when processing subscriptions:</td>
</tr>
<tr>
	<td></td>
	<td>
		<label><input type="checkbox" name="paymentCategoryAutoMethod" value="credit card"<cfif ListFind(Form.paymentCategoryAutoMethod, "credit card")> checked</cfif>>Credit Card</label><br>
		<label><input type="checkbox" name="paymentCategoryAutoMethod" value="bank"<cfif ListFind(Form.paymentCategoryAutoMethod, "bank")> checked</cfif>>Bank</label>
	</td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitPaymentCategory" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>

</form>
</cfoutput>