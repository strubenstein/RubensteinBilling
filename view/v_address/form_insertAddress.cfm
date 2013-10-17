<!--- regionID --->
<cfoutput>
<form method="post" name="insertAddress" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<!--- 
<tr>
	<td>Status: </td>
	<td>
		<label><input type="checkbox" name="addressStatus" value="1"<cfif Form.addressStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp;
		<label><input type="checkbox" name="addressStatus" value="0"<cfif Form.addressStatus is not 1> checked</cfif>> Inactive</label>
	</td>
</tr>
--->
<tr>
	<td>Reference/Contact Name: </td>
	<td><input type="text" name="addressName" size="40" value="#HTMLEditFormat(Form.addressName)#" maxlength="#maxlength_Address.addressName#"></td>
</tr>
<tr>
	<td>Optional Description: </td>
	<td><input type="text" name="addressDescription" size="40" value="#HTMLEditFormat(Form.addressDescription)#" maxlength="#maxlength_Address.addressDescription#"></td>
</tr>

<tr valign="top">
	<td>Address Type: </td>
	<td>
		<label><input type="checkbox" name="addressTypeShipping" value="1"<cfif Form.addressTypeShipping is 1> checked</cfif>> Check if this is the address for shipping purposes.</label><br>
		<label><input type="checkbox" name="addressTypeBilling" value="1"<cfif Form.addressTypeBilling is 1> checked</cfif>> Check if this is the address for billing purposes.</label>
	</td>
</tr>

<tr valign="top">
	<td>Street Address: </td>
	<td>
		<input type="text" name="address" size="40" value="#HTMLEditFormat(Form.address)#" maxlength="#maxlength_Address.address#"><br>
		<input type="text" name="address2" size="40" value="#HTMLEditFormat(Form.address2)#" maxlength="#maxlength_Address.address2#"><br>
		<input type="text" name="address3" size="40" value="#HTMLEditFormat(Form.address3)#" maxlength="#maxlength_Address.address3#">
	</td>
</tr>
<tr>
	<td>City: </td>
	<td><input type="text" name="city" size="30" value="#HTMLEditFormat(Form.city)#" maxlength="#maxlength_Address.city#"></td>
</tr>
<tr>
	<td>State/Province: </td>
	<td>
		<cfset Variables.selectStateSelected = Form.state>
		<select name="state" size="1">
		<cfinclude template="form_selectState.cfm">
		</select> &nbsp;
		<i>Other</i>: <input type="text" name="stateOther" size="20" <cfif Variables.isStateSelected is False> value="#HTMLEditFormat(Form.state)#"</cfif> maxlength="#maxlength_Address.state#">
	</td>
</tr>
<tr>
	<td>Zip/Postal Code: </td>
	<td>
		<input type="text" name="zipCode" size="6" value="#HTMLEditFormat(Form.zipCode)#" maxlength="#maxlength_Address.zipCode#">-
		<input type="text" name="zipCodePlus4" size="4" value="#HTMLEditFormat(Form.zipCodePlus4)#" maxlength="#maxlength_Address.zipCodePlus4#">
	</td>
</tr>
<tr>
	<td>County: </td>
	<td>
		<input type="text" name="county" size="30" value="#HTMLEditFormat(Form.county)#" maxlength="#maxlength_Address.county#">
	</td>
</tr>
<tr>
	<td>Country: </td>
	<td>
		<cfset Variables.countrySelected = Form.country>
		<select name="country" size="1">
		<cfinclude template="form_selectCountry.cfm">
		</select> &nbsp;
		<i>Other</i>: <input type="text" name="countryOther" size="20" <cfif Variables.isCountrySelected is False> value="#HTMLEditFormat(Form.country)#"</cfif> maxlength="#maxlength_Address.country#">
	</td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitAddress" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>