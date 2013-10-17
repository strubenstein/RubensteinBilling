<cfoutput>
<form method="post" name="checkoutBilling" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<cfif qry_selectBillingAddressList.RecordCount is 0>
	<p class="SubTitle">Enter The Billing Information</p>
<cfelse>
	<p class="SubTitle">Select Existing Billing Information or Enter New Billing Information Below</p>
	<p>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr class="TableText" valign="top">
	<cfloop Query="qry_selectBillingAddressList">
		<td width="15">&nbsp;</td>
		<td nowrap>
			<cfif qry_selectBillingAddressList.addressName is not "">#qry_selectBillingAddressList.addressName#<br></cfif>
			#qry_selectBillingAddressList.address#<br>
			<cfif qry_selectBillingAddressList.address2 is not "">#qry_selectBillingAddressList.address2#<br></cfif>
			<cfif qry_selectBillingAddressList.address3 is not "">#qry_selectBillingAddressList.address3#<br></cfif>
			#qry_selectBillingAddressList.city#, #qry_selectBillingAddressList.state# #qry_selectBillingAddressList.zipCode#<cfif qry_selectBillingAddressList.zipCodePlus4 is not "">-#qry_selectBillingAddressList.zipCodePlus4#</cfif><br>
			<cfif Not ListFind("US,USA,United States", qry_selectBillingAddressList.country) and qry_selectBillingAddressList.country is not "">#qry_selectBillingAddressList.country#<br></cfif>
			<cfif qry_selectBillingAddressList.creditCardName is not "">Name: #qry_selectBillingAddressList.creditCardName#<br></cfif>
			<cfif qry_selectBillingAddressList.creditCardNumber is not "">Card ##: **** #Right(qry_selectBillingAddressList.creditCardNumber, 4)#<br></cfif>
			<cfif qry_selectBillingAddressList.creditCardExpirationMonth is not "" and qry_selectBillingAddressList.creditCardExpirationYear is not "">
				Exp. Date: #qry_selectBillingAddressList.creditCardExpirationMonth#/#qry_selectBillingAddressList.creditCardExpirationYear#<br>
			</cfif>
			<input type="submit" name="#Variables.formSubmitName##qry_selectBillingAddressList.creditCardID#" value="Use This Billing Info">
		</td>
	</cfloop>
	</tr>
	</table>
	</p>
	<p class="MainText"><b>Only complete form below if entering a new billing address:</b></p>
</cfif>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr valign="top">
	<td>Bill-To Name: </td>
	<td>
		<input type="text" name="billingAddressName" value="#HTMLEditFormat(Form.billingAddressName)#" size="30" maxlength="#maxlength_Address.addressName#">
		<div class="SmallText">(e.g., Home, Business, or the name of the person you are sending these items to.)</div>
	</td>
</tr>
<!--- address attn field? --->
<tr valign="top">
	<td>Address: </td>
	<td>
		<input type="text" name="billingAddress" value="#HTMLEditFormat(Form.billingAddress)#" size="30" maxlength="#maxlength_Address.address#"><br>
		<input type="text" name="billingAddress2" value="#HTMLEditFormat(Form.billingAddress2)#" size="30" maxlength="#maxlength_Address.address2#">
	</td>
</tr>
<tr>
	<td>City: </td>
	<td><input type="text" name="billingCity" value="#HTMLEditFormat(Form.billingCity)#" size="20" maxlength="#maxlength_Address.city#"></td>
</tr>
<tr>
	<td>State/Province: </td>
	<td>
		<cfset Variables.selectStateSelected = Form.billingState>
		<select name="billingState" size="1">
		<cfinclude template="../../v_address/form_selectState.cfm">
		</select>
	</td>
</tr>
<tr>
	<td>Zip/Postal Code: </td>
	<td>
		<input type="text" name="billingZipCode" value="#HTMLEditFormat(Form.billingZipCode)#" size="5" maxlength="#maxlength_Address.zipCode#">
		-<input type="text" name="billingZipCodePlus4" value="#HTMLEditFormat(Form.billingZipCodePlus4)#" size="4" maxlength="#maxlength_Address.zipCodePlus4#">
	</td>
</tr>

<tr>
	<td>Country: </td>
	<td>
		<cfset Variables.countrySelected = Form.billingCountry>
		<select name="billingCountry" size="1">
		<cfinclude template="../../v_address/form_selectCountry.cfm">
		</select>
	</td>
</tr>

<tr>
	<td>Name on Card: </td>
	<td><input type="text" name="creditCardName" value="#HTMLEditFormat(Form.creditCardName)#" size="25" maxlength="#maxlength_CreditCard.creditCardName_decrypted#"></td>
</tr>
<tr>
	<td>Card Type: </td>
	<td>
		<select name="creditCardType" size="1">
		<option value=""<cfif Form.creditCardType is ""> selected</cfif>>-- CARD TYPE --</option>
		<cfloop Index="count" From="1" To="#ListLen(Variables.creditCardTypeList_value)#">
			<option value="#ListGetAt(Variables.creditCardTypeList_value, count)#"<cfif Form.creditCardType is ListGetAt(Variables.creditCardTypeList_value, count)> selected</cfif>>#ListGetAt(Variables.creditCardTypeList_label, count)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td>Card Number: </td>
	<td><input type="text" name="creditCardNumber" value="#HTMLEditFormat(Form.creditCardNumber)#" size="16" maxlength="#maxlength_CreditCard.creditCardNumber_decrypted#"></td>
</tr>
<tr>
	<td>Card Expiration: </td>
	<td>
		<select name="creditCardExpirationMonth" size="1">
		<option value=""<cfif Form.creditCardExpirationMonth is ""> selected</cfif>>-- MONTH --</option>
		<cfloop Index="count" From="1" To="12">
			<option value="#ListGetAt(Variables.creditCardExpirationMonthList_value, count)#"<cfif Form.creditCardExpirationMonth is ListGetAt(Variables.creditCardExpirationMonthList_value, count)> selected</cfif>>#ListGetAt(Variables.creditCardExpirationMonthList_label, count)#</option>
		</cfloop>
		</select>/
		<select name="creditCardExpirationYear" size="1">
		<option value=""<cfif Form.creditCardExpirationYear is ""> selected</cfif>>-- YEAR --</option>
		<cfloop Index="count" From="#Year(Now())#" To="#Evaluate(Year(Now()) + 10)#">
			<option value="#count#"<cfif Form.creditCardExpirationYear is count> selected</cfif>>#count#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td>CVC ##: </td>
	<td><input type="text" name="creditCardCVC" value="#HTMLEditFormat(Form.creditCardCVC)#" size="3" maxlength="#maxlength_CreditCard.creditCardCVC_decrypted#"> (3 digits on back of card)</td>
</tr>
<!--- 
<tr>
	<td>Retain Info: </td>
	<td><label><input type="checkbox" name="creditCardRetain" value="1"<cfif Form.creditCardRetain is 1> checked</cfif>> Click here to store this billing and credit card information for future purchases.</label></td>
</tr>
--->

<tr>
	<td></td>
	<td><input type="submit" name="#Variables.formSubmitName#" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>

