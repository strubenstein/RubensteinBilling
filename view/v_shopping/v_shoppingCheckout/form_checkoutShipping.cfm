<cfoutput>
<form method="post" name="checkoutShipping" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<cfif qry_selectShippingAddressList.RecordCount is 0>
	<p class="SubTitle">Enter The Shipping Address</p>
<cfelse>
	<p class="SubTitle">Select Existing Shipping Address or Enter a New Address Below</p>
	<p>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr class="TableText" valign="top">
	<cfloop Query="qry_selectShippingAddressList">
		<td width="15">&nbsp;</td>
		<td nowrap>
			#qry_selectShippingAddressList.addressName#<br>
			#qry_selectShippingAddressList.address#<br>
			<cfif qry_selectShippingAddressList.address2 is not "">#qry_selectShippingAddressList.address2#<br></cfif>
			<cfif qry_selectShippingAddressList.address3 is not "">#qry_selectShippingAddressList.address3#<br></cfif>
			#qry_selectShippingAddressList.city#, #qry_selectShippingAddressList.state# #qry_selectShippingAddressList.zipCode#<cfif qry_selectShippingAddressList.zipCodePlus4 is not "">-#qry_selectShippingAddressList.zipCodePlus4#</cfif><br>
			<cfif Not ListFind("US,USA,United States", qry_selectShippingAddressList.country) and qry_selectShippingAddressList.country is not "">#qry_selectShippingAddressList.country#<br></cfif>
			<input type="submit" name="#Variables.formSubmitName##qry_selectShippingAddressList.addressID#" value="Use This Address">
		</td>
	</cfloop>
	</tr>
	</table>
	</p>
	<p class="MainText"><b>Only complete form below if entering a new shipping address:</b></p>
</cfif>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr valign="top">
	<td>Ship-To Name: </td>
	<td>
		<input type="text" name="shippingAddressName" value="#HTMLEditFormat(Form.shippingAddressName)#" size="30" maxlength="#maxlength_Address.addressName#">
		<div class="SmallText">(e.g., Home, Business, or the name of the person you are sending these items to.)</div>
	</td>
</tr>
<!--- address attn field? --->
<tr valign="top">
	<td>Address: </td>
	<td>
		<input type="text" name="shippingAddress" value="#HTMLEditFormat(Form.shippingAddress)#" size="30" maxlength="#maxlength_Address.address#"><br>
		<input type="text" name="shippingAddress2" value="#HTMLEditFormat(Form.shippingAddress2)#" size="30" maxlength="#maxlength_Address.address2#">
	</td>
</tr>
<tr>
	<td>City: </td>
	<td><input type="text" name="shippingCity" value="#HTMLEditFormat(Form.shippingCity)#" size="20" maxlength="#maxlength_Address.city#"></td>
</tr>
<tr>
	<td>State/Province: </td>
	<td>
		<cfset Variables.selectStateSelected = Form.shippingState>
		<select name="shippingState" size="1">
		<cfinclude template="../../v_address/form_selectState.cfm">
		</select>
	</td>
</tr>
<tr>
	<td>Zip/Postal Code: </td>
	<td>
		<input type="text" name="shippingZipCode" value="#HTMLEditFormat(Form.shippingZipCode)#" size="5" maxlength="#maxlength_Address.zipCode#">
		-<input type="text" name="shippingZipCodePlus4" value="#HTMLEditFormat(Form.shippingZipCodePlus4)#" size="4" maxlength="#maxlength_Address.zipCodePlus4#">
	</td>
</tr>

<tr>
	<td>Country: </td>
	<td>
		<cfset Variables.countrySelected = Form.shippingCountry>
		<select name="shippingCountry" size="1">
		<cfinclude template="../../v_address/form_selectCountry.cfm">
		</select>
	</td>
</tr>

<!--- 
<tr>
	<td>Shipping Option: </td>
	<td>
		<select name="invoiceShippingMethod" size="1">
		<option value="">-- SHIPPING OPTION --</option>
		<cfloop Index="count" From="1" To="#ListLen(Variables.shippingMethodList_value)#">
			<option value="#HTMLEditFormat(ListGetAt(Variables.shippingMethodList_value, count))#"<cfif Form.invoiceShippingMethod is ListGetAt(Variables.shippingMethodList_value, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.shippingMethodList_label, count))#</option>
		</cfloop>
		</select>
	</td>
</tr>
--->

<tr>
	<td valign="top">Special Instructions: <div class="TableText">(Max. #maxlength_Invoice.invoiceInstructions# chars.)</div></td>
	<td><textarea name="invoiceInstructions" rows="4" cols="60" wrap="soft">#HTMLEditFormat(Form.invoiceInstructions)#</textarea></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="#Variables.formSubmitName#" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
