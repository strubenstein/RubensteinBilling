<cfoutput>
<form method="post" name="insertBank" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<!--- 
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="bankStatus" value="1"<cfif Form.bankStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp;
		<label style="color: red"><input type="radio" name="bankStatus" value="0"<cfif Form.bankStatus is not 1> checked</cfif>> Inactive</label>
	</td>
</tr>
--->
<tr>
	<td valign="top">Billing Address: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td><input type="radio" name="addressID" value="0"<cfif Form.addressID is 0 or Not ListFind(ValueList(qry_selectAddressList.addressID), Form.addressID)> checked</cfif>></td>
			<td>No address specified</td>
		</tr>
		<cfloop Query="qry_selectAddressList">
			<tr valign="top"<cfif (CurrentRow mod 2) is 1> bgcolor="f4f4ff"</cfif>>
			<td><input type="radio" name="addressID" value="#qry_selectAddressList.addressID#"<cfif Form.addressID is qry_selectAddressList.addressID> checked</cfif>></td>
			<td>
				<cfif qry_selectAddressList.addressName is not "">#qry_selectAddressList.addressName#<br></cfif>
				<cfif qry_selectAddressList.addressDescription is not "">#qry_selectAddressList.addressDescription#<br></cfif>
				#qry_selectAddressList.address#<br>
				<cfif qry_selectAddressList.address2 is not "">#qry_selectAddressList.address2#<br></cfif>
				<cfif qry_selectAddressList.address3 is not "">#qry_selectAddressList.address3#<br></cfif>
				#qry_selectAddressList.city#, #qry_selectAddressList.state# #qry_selectAddressList.zipCode#<cfif qry_selectAddressList.zipCodePlus4 is not "">-#qry_selectAddressList.zipCodePlus4#</cfif>
				<cfif qry_selectAddressList.country is not "" and Not ListFind("US,USA,United States", qry_selectAddressList.country)><br>#qry_selectAddressList.country#</cfif>
			</td>
			</tr>
		</cfloop>
		</table>
	</td>
</tr>
<tr>
	<td>Optional Description: </td>
	<td><input type="text" name="bankDescription" size="40" value="#HTMLEditFormat(Form.bankDescription)#" maxlength="#maxlength_Bank.bankDescription#"></td>
</tr>
<tr>
	<td>Name of Bank: </td>
	<td><input type="text" name="bankName" value="#HTMLEditFormat(Form.bankName)#" size="25" maxlength="#maxlength_Bank.bankName#"></td>
</tr>
<tr>
	<td>Name on Account: </td>
	<td><input type="text" name="bankAccountName" value="#HTMLEditFormat(Form.bankAccountName)#" size="25" maxlength="#maxlength_Bank.bankAccountName#"></td>
</tr>
<tr>
	<td>Account Ownership: </td>
	<td>
		<label><input type="radio" name="bankPersonalOrCorporate" value="1"<cfif Form.bankPersonalOrCorporate is 1> checked</cfif>> Corporate</label> &nbsp; &nbsp;
		<label><input type="radio" name="bankPersonalOrCorporate" value="0"<cfif Form.bankPersonalOrCorporate is not 1> checked</cfif>> Personal</label>
	</td>
</tr>
<tr>
	<td>Routing ##: </td>
	<td><input type="text" name="bankRoutingNumber" value="#HTMLEditFormat(Form.bankRoutingNumber)#" size="25" maxlength="#maxlength_Bank.bankRoutingNumber_decrypted#"></td>
</tr>
<tr>
	<td>Account ##: </td>
	<td><input type="text" name="bankAccountNumber" value="#HTMLEditFormat(Form.bankAccountNumber)#" size="25" maxlength="#maxlength_Bank.bankAccountNumber_decrypted#"></td>
</tr>
<tr>
	<td>Account Type: </td>
	<td>
		<label><input type="radio" name="bankCheckingOrSavings" value="0"<cfif Form.bankCheckingOrSavings is 0> checked</cfif>>Checking</label> &nbsp; &nbsp; 
		<label><input type="radio" name="bankCheckingOrSavings" value="1"<cfif Form.bankCheckingOrSavings is 1> checked</cfif>>Savings</label> &nbsp; &nbsp; 
		<label><input type="radio" name="bankCheckingOrSavings" value=""<cfif Form.bankCheckingOrSavings is ""> checked</cfif>>Other</label> 
		<input type="text" name="bankAccountType" value="#HTMLEditFormat(Form.bankAccountType)#" size="15" maxlength="#maxlength_Bank.bankAccountType#">
	</td>
</tr>
<tr>
	<td>Retain Bank Info: </td>
	<td><label><input type="checkbox" name="bankRetain" value="1"<cfif Form.bankRetain is 1> checked</cfif>> Continue to store this bank account information after it has been processed.</label></td>
</tr>


<tr><td colspan="2"><br>Bank Branch Information</td></tr>
<tr>
	<td>Branch Name: </td>
	<td><input type="text" name="bankBranch" value="#HTMLEditFormat(Form.bankBranch)#" size="25" maxlength="#maxlength_Bank.bankBranch#"></td>
</tr>
<tr>
	<td>City: </td>
	<td><input type="text" name="bankBranchCity" value="#HTMLEditFormat(Form.bankBranchCity)#" size="25" maxlength="#maxlength_Bank.bankBranchCity#"></td>
</tr>
<tr>
	<td>State/Province: </td>
	<td>
		<cfset Variables.selectStateSelected = Form.bankBranchState>
		<select name="bankBranchState" size="1">
		<cfinclude template="../v_address/form_selectState.cfm">
		</select> &nbsp;
		<i>Other</i>: <input type="text" name="bankBranchStateOther" size="20" <cfif Variables.isStateSelected is False> value="#HTMLEditFormat(Form.bankBranchState)#"</cfif> maxlength="#maxlength_Bank.bankBranchState#">
	</td>
</tr>
<tr>
	<td>Country: </td>
	<td>
		<cfset Variables.countrySelected = Form.bankBranchCountry>
		<select name="bankBranchCountry" size="1">
		<cfinclude template="../v_address/form_selectCountry.cfm">
		</select> &nbsp;
		<i>Other</i>: <input type="text" name="bankBranchCountryOther" size="20" <cfif Variables.isCountrySelected is False> value="#HTMLEditFormat(Form.bankBranchCountry)#"</cfif> maxlength="#maxlength_Bank.bankBranchCountry#">
	</td>
</tr>
<tr>
	<td>Contact Person: </td>
	<td><input type="text" name="bankBranchContactName" value="#HTMLEditFormat(Form.bankBranchContactName)#" size="25" maxlength="#maxlength_Bank.bankBranchContactName#"></td>
</tr>
<tr>
	<td>Phone: </td>
	<td><input type="text" name="bankBranchPhone" value="#HTMLEditFormat(Form.bankBranchPhone)#" size="25" maxlength="#maxlength_Bank.bankBranchPhone#"></td>
</tr>
<tr>
	<td>Fax: </td>
	<td><input type="text" name="bankBranchFax" value="#HTMLEditFormat(Form.bankBranchFax)#" size="25" maxlength="#maxlength_Bank.bankBranchFax#"></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitBank" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>