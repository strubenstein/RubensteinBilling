<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="1">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.displayCompanyList is True>
	<tr>
		<td>Company: </td>
		<td>
			<select name="userID" size="1">
			<cfloop Query="qry_selectUserCompanyList_user">
				<option value="#qry_selectUserCompanyList_user.companyID#"<cfif Form.companyID is qry_selectUserCompanyList_user.companyID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_user.companyName)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>
<tr>
	<td>Contact Person: </td>
	<td>
		<select name="userID" size="1">
		<option value="0">-- SELECT CONTACT --</option>
		<cfloop Query="qry_selectUserCompanyList_company">
			<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr valign="top">
	<td>Optional Reference Name: </td>
	<td>
		<input type="text" name="subscriberName" value="#HTMLEditFormat(Form.subscriberName)#" size="40" maxlength="#maxlength_Subscriber.subscriberName#">
		<div class="TableText">(<i>Useful for differentiating multiple subscribers within same company</i>.)</div>
	</td>
</tr>
<tr>
	<td>Optional Custom ID: </td>
	<td><input type="text" name="subscriberID_custom" value="#HTMLEditFormat(Form.subscriberID_custom)#" size="20" maxlength="#maxlength_Subscriber.subscriberID_custom#"> (<i>for integration purposes</i>)</td>
</tr>
<tr valign="top">
	<td>Subscriber Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="subscriberStatus" value="1"<cfif Form.subscriberStatus is 1> checked</cfif>>Active</label> &nbsp; 
		<label style="color: red"><input type="radio" name="subscriberStatus" value="0"<cfif Form.subscriberStatus is not 1> checked</cfif>>Not Active</label>
	</td>
</tr>
<tr valign="top">
	<td>Completed: </td>
	<td><label><input type="checkbox" name="subscriberCompleted" value="1"<cfif Form.subscriberCompleted is 1> checked</cfif>> Subscriber has completed all subscriptions</label></td>
</tr>
<tr valign="top">
	<td>Most Recent Invoice Date: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "subscriberDateProcessLast_date", Form.subscriberDateProcessLast_date, "", 0, "", 0, "", "", True)#</td>
</tr>
<tr>
	<td>Next Invoice Date: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "subscriberDateProcessNext_date", Form.subscriberDateProcessNext_date, "", 0, "", 0, "", "", True)#</td>
</tr>

<tr><td colspan="2"><b>For optional automatic billing, select a credit card <i>or</i> bank account.</b></td></tr>
<tr bgcolor="dddddd">
	<td valign="top">Credit Card: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td><input type="radio" name="creditCardID" value="0"<cfif Form.creditCardID is 0 or Not ListFind(ValueList(qry_selectCreditCardList.creditCardID), Form.creditCardID)> checked</cfif>></td>
			<td>No credit card specified</td>
		</tr>
		<cfloop Query="qry_selectCreditCardList">
			<tr valign="top"<cfif (CurrentRow mod 2) is 1> bgcolor="f4f4ff"</cfif>>
			<td><input type="radio" name="creditCardID" value="#qry_selectCreditCardList.creditCardID#"<cfif Form.creditCardID is qry_selectCreditCardList.creditCardID> checked</cfif>></td>
			<td>
				<cfif qry_selectCreditCardList.creditCardName is not "">#qry_selectCreditCardList.creditCardName#<br></cfif>
				<cfif qry_selectCreditCardList.creditCardType is not "">#qry_selectCreditCardList.creditCardType# &nbsp; </cfif>
				<cfif qry_selectCreditCardList.creditCardNumber is not "">#RepeatString("*", Len(qry_selectCreditCardList.creditCardNumber) - 4)##Right(qry_selectCreditCardList.creditCardNumber, 4)# &nbsp; </cfif>
				Expires #qry_selectCreditCardList.creditCardExpirationMonth#/#qry_selectCreditCardList.creditCardExpirationYear#
			</td>
			</tr>
		</cfloop>
		</table>
	</td>
</tr>
<tr>
	<td valign="top">Bank Account: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td><input type="radio" name="bankID" value="0"<cfif Form.bankID is 0 or Not ListFind(ValueList(qry_selectBankList.bankID), Form.bankID)> checked</cfif>></td>
			<td>No bank account specified</td>
		</tr>
		<cfloop Query="qry_selectBankList">
			<tr valign="top"<cfif (CurrentRow mod 2) is 1> bgcolor="f4f4ff"</cfif>>
			<td><input type="radio" name="bankID" value="#qry_selectBankList.bankID#"<cfif Form.bankID is qry_selectBankList.bankID> checked</cfif>></td>
			<td>
				<cfif qry_selectBankList.bankName is not "">#qry_selectBankList.bankName# </cfif>
				<cfif qry_selectBankList.bankAccountNumber is not "">#qry_selectBankList.bankAccountNumber#</cfif><br>
				<cfif qry_selectBankList.bankAccountName is not "">#qry_selectBankList.bankAccountName# </cfif>
				(<cfif qry_selectBankList.bankPersonalOrCorporate is 0>Personal<cfelse>Corporate</cfif> 
				<cfif qry_selectBankList.bankCheckingOrSavings is 0>Checking<cfelseif qry_selectBankList.bankCheckingOrSavings is 1>Savings<cfelseif qry_selectBankList.bankAccountType is not "">#qry_selectBankList.bankAccountType#</cfif>)
			</td>
			</tr>
		</cfloop>
		</table>
	</td>
</tr>
<tr><td colspan="2"><b>The shipping &amp; billing addresses will be listed on the invoice.</b></td></tr>
<tr bgcolor="dddddd">
	<td valign="top">Shipping Address: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td><input type="radio" name="addressID_shipping" value="0"<cfif Form.addressID_shipping is 0 or Not ListFind(ValueList(qry_selectShippingAddressList.addressID), Form.addressID_shipping)> checked</cfif>></td>
			<td>No shipping address specified</td>
		</tr>
		<cfset Variables.count = 0>
		<cfloop Query="qry_selectShippingAddressList">
			<cfif qry_selectShippingAddressList.addressStatus is 1 or Form.addressID_shipping is qry_selectShippingAddressList.addressID>
				<cfset Variables.count = Variables.count + 1>
				<tr valign="top"<cfif (Variables.count mod 2) is 1> bgcolor="f4f4ff"</cfif>>
				<td><input type="radio" name="addressID_shipping" value="#qry_selectShippingAddressList.addressID#"<cfif Form.addressID_shipping is qry_selectShippingAddressList.addressID> checked</cfif>></td>
				<td>
					<cfif qry_selectShippingAddressList.addressName is not "">#qry_selectShippingAddressList.addressName#<br></cfif>
					<cfif qry_selectShippingAddressList.addressDescription is not "">#qry_selectShippingAddressList.addressDescription#<br></cfif>
					#qry_selectShippingAddressList.address#<br>
					<cfif qry_selectShippingAddressList.address2 is not "">#qry_selectShippingAddressList.address2#<br></cfif>
					<cfif qry_selectShippingAddressList.address3 is not "">#qry_selectShippingAddressList.address3#<br></cfif>
					#qry_selectShippingAddressList.city#, #qry_selectShippingAddressList.state# #qry_selectShippingAddressList.zipCode#<cfif qry_selectShippingAddressList.zipCodePlus4 is not "">-#qry_selectShippingAddressList.zipCodePlus4#</cfif>
					<cfif qry_selectShippingAddressList.country is not "" and Not ListFind("US,USA,United States", qry_selectShippingAddressList.country)><br>#qry_selectShippingAddressList.country#</cfif>
				</td>
				</tr>
			</cfif>
		</cfloop>
		</table>
	</td>
</tr>
<tr>
	<td valign="top">Billing Address: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td><input type="radio" name="addressID_billing" value="0"<cfif Form.addressID_billing is 0 or Not ListFind(ValueList(qry_selectBillingAddressList.addressID), Form.addressID_billing)> checked</cfif>></td>
			<td>No billing address specified</td>
		</tr>
		<cfset Variables.count = 0>
		<cfloop Query="qry_selectBillingAddressList">
			<cfif qry_selectBillingAddressList.addressStatus is 1 or Form.addressID_billing is qry_selectBillingAddressList.addressID>
				<cfset Variables.count = Variables.count + 1>
				<tr valign="top"<cfif (Variables.count mod 2) is 1> bgcolor="f4f4ff"</cfif>>
				<td><input type="radio" name="addressID_billing" value="#qry_selectBillingAddressList.addressID#"<cfif Form.addressID_billing is qry_selectBillingAddressList.addressID> checked</cfif>></td>
				<td>
					<cfif qry_selectBillingAddressList.addressName is not "">#qry_selectBillingAddressList.addressName#<br></cfif>
					<cfif qry_selectBillingAddressList.addressDescription is not "">#qry_selectBillingAddressList.addressDescription#<br></cfif>
					#qry_selectBillingAddressList.address#<br>
					<cfif qry_selectBillingAddressList.address2 is not "">#qry_selectBillingAddressList.address2#<br></cfif>
					<cfif qry_selectBillingAddressList.address3 is not "">#qry_selectBillingAddressList.address3#<br></cfif>
					#qry_selectBillingAddressList.city#, #qry_selectBillingAddressList.state# #qry_selectBillingAddressList.zipCode#<cfif qry_selectBillingAddressList.zipCodePlus4 is not "">-#qry_selectBillingAddressList.zipCodePlus4#</cfif>
					<cfif qry_selectBillingAddressList.country is not "" and Not ListFind("US,USA,United States", qry_selectBillingAddressList.country)><br>#qry_selectBillingAddressList.country#</cfif>
				</td>
				</tr>
			</cfif>
		</cfloop>
		</table>
	</td>
</tr>
</table>
</cfoutput>

<!--- Insert custom fields and custom status forms if necessary --->
<cfif isStatusExist is True>
	<cfinvoke component="#objInsertStatusHistory#" method="form_insertStatusHistory" returnVariable="isStatusHistoryForm" />
</cfif>
<cfif isCustomFieldValueExist is True>
	<cfinvoke component="#objInsertCustomFieldValue#" method="form_insertCustomFieldValue" returnVariable="isCustomFieldValueForm" />
</cfif>

<cfoutput>
<p><input type="submit" name="submitSubscriber" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>
</cfoutput>

