<cfoutput>
<form method="post" name="insertUpdateMerchantAccount" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="merchantAccountStatus" value="1"<cfif Form.merchantAccountStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="merchantAccountStatus" value="0"<cfif Form.merchantAccountStatus is not 1> checked</cfif>> Inactive</label>
	</td>
</tr>
<tr>
	<td>Reference Name: </td>
	<td><input type="text" name="merchantAccountName" value="#HTMLEditFormat(Form.merchantAccountName)#" size="40" maxlength="#maxlength_MerchantAccount.merchantAccountName#"></td>
</tr>
<tr>
	<td>Merchant Processor: </td>
	<td>
		<select name="merchantID" size="1">
		<option value="0">-- SELECT MERCHANT --</option>
		<cfloop Query="qry_selectMerchantList">
			<option value="#qry_selectMerchantList.merchantID#"<cfif Form.merchantID is qry_selectMerchantList.merchantID> selected</cfif>>#HTMLEditFormat(qry_selectMerchantList.merchantTitle)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td>Username: </td>
	<td><input type="text" name="merchantAccountUsername" value="#HTMLEditFormat(Form.merchantAccountUsername)#" size="40" maxlength="#maxlength_MerchantAccount.merchantAccountUsername_decrypted#"></td>
</tr>
<tr>
	<td>Password: </td>
	<td><input type="text" name="merchantAccountPassword" value="#HTMLEditFormat(Form.merchantAccountPassword)#" size="40" maxlength="#maxlength_MerchantAccount.merchantAccountPassword_decrypted#"></td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="merchantAccountID_custom" value="#HTMLEditFormat(Form.merchantAccountID_custom)#" size="40" maxlength="#maxlength_MerchantAccount.merchantAccountID_custom_decrypted#"></td>
</tr>
<tr>
	<td>Bank/ACH: </td>
	<td><label><input type="checkbox" name="merchantAccountBank" value="1"<cfif Form.merchantAccountBank is 1> checked</cfif>> Merchant account is used to process bank/ACH transactions.</label></td>
</tr>
<tr>
	<td>Credit Cards: </td>
	<td>
		<cfloop Index="count" From="1" To="#ListLen(Variables.creditCardTypeList_value)#">
			<label><input type="checkbox" name="merchantAccountCreditCardTypeList" value="#ListGetAt(Variables.creditCardTypeList_value, count)#"<cfif ListFindNoCase(Form.merchantAccountCreditCardTypeList, ListGetAt(Variables.creditCardTypeList_value, count))> checked</cfif>>#ListGetAt(Variables.creditCardTypeList_label, count)#</label> &nbsp; 
		</cfloop>
		<!--- <label><input type="checkbox" name="merchantAccountCreditCard" value="1"<cfif Form.merchantAccountCreditCard is 1> checked</cfif>> Merchant account is used to process credit card transactions.</label> --->
	</td>
</tr>
<tr>
	<td>Internal Description: </td>
	<td><input type="text" name="merchantAccountDescription" value="#HTMLEditFormat(Form.merchantAccountDescription)#" size="40" maxlength="#maxlength_MerchantAccount.merchantAccountDescription#"></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitInsertUpdateMerchantAccount" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
