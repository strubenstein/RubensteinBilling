<cfoutput>
<form method="post" name="insertCreditCard" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<!--- 
<tr>
	<td>Status: </td>
	<td>
		<label><input type="radio" name="creditCardStatus" value="1"<cfif Form.creditCardStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp;
		<label><input type="radio" name="creditCardStatus" value="0"<cfif Form.creditCardStatus is not 1> checked</cfif>> Inactive</label>
	</td>
</tr>
--->
<tr>
	<td valign="top">Billing Address: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td><input type="radio" name="addressID" value="0"<cfif Form.addressID is 0 or Not ListFind(ValueList(qry_selectAddressList.addressID), Form.addressID)> checked</cfif>></td>
			<td>No billing address specified</td>
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
	<td><input type="text" name="creditCardDescription" size="40" value="#HTMLEditFormat(Form.creditCardDescription)#" maxlength="#maxlength_CreditCard.creditCardDescription#"></td>
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
<tr>
	<td>Retain CC Info: </td>
	<td><label><input type="checkbox" name="creditCardRetain" value="1"<cfif Form.creditCardRetain is 1> checked</cfif>> Continue to store this credit card information after it has been processed.</label></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitCreditCard" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>