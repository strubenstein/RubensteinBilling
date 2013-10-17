<cfoutput>
<script language="JavaScript">
function setTitle () {
	if (document.insertUpdateMerchant.merchantTitle.value == "")
	document.insertUpdateMerchant.merchantTitle.value = document.insertUpdateMerchant.merchantName.value;
}
</script>

<form method="post" name="insertUpdateMerchant" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="merchantStatus" value="1"<cfif Form.merchantStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="merchantStatus" value="0"<cfif Form.merchantStatus is not 1> checked</cfif>> Inactive</label>
	</td>
</tr>
<tr>
	<td>Internal Name: </td>
	<td><input type="text" name="merchantName" value="#HTMLEditFormat(Form.merchantName)#" size="40" maxlength="#maxlength_Merchant.merchantName#" onBlur="javascript:setTitle();"></td>
</tr>
<tr>
	<td>Public Title: </td>
	<td><input type="text" name="merchantTitle" value="#HTMLEditFormat(Form.merchantTitle)#" size="40" maxlength="#maxlength_Merchant.merchantTitle#"></td>
</tr>
<tr>
	<td>Credit Cards: </td>
	<td><label><input type="checkbox" name="merchantCreditCard" value="1"<cfif Form.merchantCreditCard is 1> checked</cfif>> Merchant processor can process credit card transactions.</label></td>
</tr>
<tr>
	<td>Bank/ACH: </td>
	<td><label><input type="checkbox" name="merchantBank" value="1"<cfif Form.merchantBank is 1> checked</cfif>> Merchant processor can process bank/ACH transactions.</label></td>
</tr>
<cfif Variables.displayUsers is True>
	<tr>
		<td>Contact Person: </td>
		<td>
			<select name="userID" size="1">
			<option value="0">-- PRIMARY CONTACT --</option>
			<cfloop Query="qry_selectUserCompanyList_company">
				<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>
<tr>
	<td>Merchant URL: </td>
	<td><input type="text" name="merchantURL" value="#HTMLEditFormat(Form.merchantURL)#" size="40" maxlength="#maxlength_Merchant.merchantURL#"></td>
</tr>
<tr>
	<td>Internal Description: </td>
	<td><input type="text" name="merchantDescription" value="#HTMLEditFormat(Form.merchantDescription)#" size="40" maxlength="#maxlength_Merchant.merchantDescription#"></td>
</tr>
<tr>
	<td>Filename: </td>
	<td class="TableText">
		<input type="text" name="merchantFilename" value="#HTMLEditFormat(Form.merchantFilename)#" size="30" maxlength="#maxlength_Merchant.merchantFilename#"> 
		(file must exist in include/merchant directory)
	</td>
</tr>
<tr>
	<td>Required Fields: </td>
	<td>
		<label><input type="checkbox" name="merchantRequiredFields" value="merchantAccountUsername"<cfif ListFind(Form.merchantRequiredFields, "merchantAccountUsername")> checked</cfif>>Username</label> &nbsp; &nbsp; 
		<label><input type="checkbox" name="merchantRequiredFields" value="merchantAccountPassword"<cfif ListFind(Form.merchantRequiredFields, "merchantAccountPassword")> checked</cfif>>Password</label> &nbsp; &nbsp; 
		<label><input type="checkbox" name="merchantRequiredFields" value="merchantAccountID_custom"<cfif ListFind(Form.merchantRequiredFields, "merchantAccountID_custom")> checked</cfif>>Custom ID</label>
	</td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitInsertUpdateMerchant" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
