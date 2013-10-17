<cfset errorMessage_fields = StructNew()>

<!--- Form.regionID --->

<!--- 
<cfif Form.isNewBillingAddress is 0 and IsDefined("Form.billingAddressID") and IsNumeric(Form.billingAddressID)>
	<cfif Not ListFind(ValueList(qry_selectBillingAddressList.addressID), Form.billingAddressID)>
		<cfset errorMessage_fields.addressID = Variables.lang_checkoutBilling.addressID>
	</cfif>
<cfelse><!--- new address --->
	<cfset Form.isNewBillingAddress = 1>
--->

<cfif IsNumeric(Variables.formSubmitName_submitted)><!--- selected existing address; validate credit card expiration --->
	<cfif qry_selectBillingAddressList.creditCardExpirationYear[Variables.billingRow] lt Year(Now())
			or (qry_selectBillingAddressList.creditCardExpirationYear[Variables.billingRow] is Year(Now())
					and qry_selectBillingAddressList.creditCardExpirationMonth[Variables.billingRow] lt Month(Now()))>
		<cfset errorMessage_fields.creditCardExpiration = Variables.lang_checkoutBilling.creditCardExpiration_expiredSaved>
	</cfif>
<cfelse>
	<cfif Trim(Form.billingAddressName) is "">
		<cfset errorMessage_fields.addressName = Variables.lang_checkoutBilling.addressName_blank>
	<cfelseif Len(Form.billingAddressName) gt maxlength_Address.addressName>
		<cfset errorMessage_fields.addressName = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutBilling.addressName_maxlength, "<<MAXLENGTH>>", maxlength_Address.addressName, "ALL"), "<<LEN>>", Len(Form.billingAddressName), "ALL")>
	<!--- 
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Address" Method="checkAddressNameIsUnique" ReturnVariable="isAddressNameUnique">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="addressName" Value="#Form.billingAddressName#">
		</cfinvoke>

		<cfif isAddressNameUnique is False>
			<cfset errorMessage_fields.addressName = Variables.lang_checkoutBilling.addressName_unique>
		</cfif>
	--->
	</cfif>

	<cfif Trim(Form.billingAddress) is "">
		<cfset errorMessage_fields.address = Variables.lang_checkoutBilling.address_blank>
	<cfelseif Len(Form.billingAddress) gt maxlength_Address.address>
		<cfset errorMessage_fields.address = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutBilling.address_maxlength, "<<MAXLENGTH>>", maxlength_Address.address, "ALL"), "<<LEN>>", Len(Form.billingAddress), "ALL")>
	</cfif>

	<cfif Len(Form.billingAddress2) gt maxlength_Address.address2>
		<cfset errorMessage_fields.address2 = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutBilling.address2, "<<MAXLENGTH>>", maxlength_Address.address2, "ALL"), "<<LEN>>", Len(Form.billingAddress2), "ALL")>
	</cfif>

	<cfif Trim(Form.billingCity) is "">
		<cfset errorMessage_fields.city = Variables.lang_checkoutBilling.city_blank>
	<cfelseif Len(Form.billingCity) gt maxlength_Address.city>
		<cfset errorMessage_fields.city = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutBilling.city_maxlength, "<<MAXLENGTH>>", maxlength_Address.city, "ALL"), "<<LEN>>", Len(Form.billingCity), "ALL")>
	</cfif>

	<cfif Trim(Form.billingState) is "">
		<cfset errorMessage_fields.state = Variables.lang_checkoutBilling.state_blank>
	<cfelseif Len(Form.billingState) gt maxlength_Address.state>
		<cfset errorMessage_fields.state = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutBilling.state_maxlength, "<<MAXLENGTH>>", maxlength_Address.state, "ALL"), "<<LEN>>", Len(Form.billingState), "ALL")>
	<cfelseif Not ListFind(Variables.selectStateList_value, Form.billingState)>
		<cfset errorMessage_fields.state = Variables.lang_checkoutBilling.state_valid>
	</cfif>

	<cfif Trim(Form.billingZipCode) is "">
		<cfset errorMessage_fields.zipCode = Variables.lang_checkoutBilling.zipCode_blank>
	<cfelseif Len(Form.billingZipCode) gt maxlength_Address.zipCode>
		<cfset errorMessage_fields.zipCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutBilling.zipCode_maxlength, "<<MAXLENGTH>>", maxlength_Address.zipCode, "ALL"), "<<LEN>>", Len(Form.billingZipCode), "ALL")>
	</cfif>

	<cfif Len(Form.billingZipCodePlus4) gt maxlength_Address.zipCodePlus4>
		<cfset errorMessage_fields.zipCodePlus4 = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutBilling.zipCodePlus4, "<<MAXLENGTH>>", maxlength_Address.zipCodePlus4, "ALL"), "<<LEN>>", Len(Form.billingZipCodePlus4), "ALL")>
	</cfif>

	<cfif Trim(Form.billingCountry) is "">
		<cfset errorMessage_fields.country = Variables.lang_checkoutBilling.country_blank>
	<cfelseif Len(Form.billingCountry) gt maxlength_Address.country>
		<cfset errorMessage_fields.country = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutBilling.country_maxlength, "<<MAXLENGTH>>", maxlength_Address.country, "ALL"), "<<LEN>>", Len(Form.billingCountry), "ALL")>
	<cfelseif Not ListFind(Variables.countryList_value, Form.billingCountry)>
		<cfset errorMessage_fields.country = Variables.lang_checkoutBilling.country_valid>
	</cfif>

	<!--- credit card information --->
	<cfif Trim(Form.creditCardName) is "">
		<cfset errorMessage_fields.creditCardName = Variables.lang_checkoutBilling.creditCardName_blank>
	<cfelseif Len(Form.creditCardName) gt maxlength_CreditCard.creditCardName_decrypted>
		<cfset errorMessage_fields.creditCardName = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutBilling.creditCardName_maxlength, "<<MAXLENGTH>>", maxlength_CreditCard.creditCardName_decrypted, "ALL"), "<<LEN>>", Len(Form.creditCardName), "ALL")>
	</cfif>

	<cfif Trim(Form.creditCardType) is "">
		<cfset errorMessage_fields.creditCardType = Variables.lang_checkoutBilling.creditCardType_blank>
	<cfelseif Not ListFind(Variables.creditCardTypeList_value, Form.creditCardType)>
		<cfset errorMessage_fields.creditCardType = Variables.lang_checkoutBilling.creditCardType_valid>
	</cfif>

	<cfset Form.creditCardNumber = Replace(Replace(Form.creditCardNumber, " ", "", "ALL"), "-", "", "ALL")>
	<cfif Trim(Form.creditCardNumber is "")>
		<cfset errorMessage_fields.creditCardNumber = Variables.lang_checkoutBilling.creditCardNumber_blank>
	<cfelseif Len(Form.creditCardNumber) gt maxlength_CreditCard.creditCardNumber_decrypted
			or REFind("[^0-9]", Form.creditCardNumber) or Not fn_IsMod10(Form.creditCardNumber)>
		<cfset errorMessage_fields.creditCardNumber = Variables.lang_checkoutBilling.creditCardNumber_valid>
	<cfelseif Not StructKeyExists(errorMessage_fields, "creditCardType") and Not fn_IsCreditCardNumberSameAsType(Form.creditCardNumber, Form.creditCardType)>
		<cfset errorMessage_fields.creditCardNumber = Variables.lang_checkoutBilling.creditCardNumber_type>
	</cfif>

	<cfif Trim(Form.creditCardExpirationMonth) is "">
		<cfset errorMessage_fields.creditCardExpirationMonth = Variables.lang_checkoutBilling.creditCardExpirationMonth_blank>
	<cfelseif Not ListFind(Variables.creditCardExpirationMonthList_value, Form.creditCardExpirationMonth)>
		<cfset errorMessage_fields.creditCardExpirationMonth = Variables.lang_checkoutBilling.creditCardExpirationMonth_valid>
	</cfif>

	<cfif Trim(Form.creditCardExpirationYear) is "">
		<cfset errorMessage_fields.creditCardExpirationYear = Variables.lang_checkoutBilling.creditCardExpirationYear_blank>
	<cfelseif Not Application.fn_IsIntegerPositive(Form.creditCardExpirationYear)
			or Form.creditCardExpirationYear lt Year(Now()) or Form.creditCardExpirationYear gt (Year(Now()) + 10)>
		<cfset errorMessage_fields.creditCardExpirationYear = Variables.lang_checkoutBilling.creditCardExpirationYear_valid>
	</cfif>

	<cfif Not StructKeyExists(errorMessage_fields, "creditCardExpirationMonth") and Not StructKeyExists(errorMessage_fields, "creditCardExpirationYear")
			and Form.creditCardExpirationYear is Year(Now()) and Form.creditCardExpirationMonth lt Month(Now())>
		<cfset errorMessage_fields.creditCardExpiration = Variables.lang_checkoutBilling.creditCardExpiration_expired>
	</cfif>

	<cfif Trim(Form.creditCardCVC is "")>
		<cfset errorMessage_fields.creditCardCVC = Variables.lang_checkoutBilling.creditCardCVC_blank>
	<cfelseif REFind("[^0-9]", Form.creditCardCVC)>
		<cfset errorMessage_fields.creditCardCVC = Variables.lang_checkoutBilling.creditCardCVC_valid>
	<cfelseif Len(Form.creditCardCVC) gt maxlength_CreditCard.creditCardCVC_decrypted>
		<cfset errorMessage_fields.creditCardCVC = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutBilling.creditCardCVC_maxlength, "<<MAXLENGTH>>", 4, "ALL"), "<<LEN>>", Len(Form.creditCardCVC), "ALL")>
	</cfif>

	<cfif Not ListFind("0,1", Form.creditCardRetain)>
		<cfset errorMessage_fields.creditCardRetain = Variables.lang_checkoutBilling.creditCardRetain>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.control is "checkout">
		<cfset errorMessage_title = Variables.lang_checkoutBilling.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_checkoutBilling.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_checkoutBilling.errorHeader>
	<cfset errorMessage_footer = Variables.lang_checkoutBilling.errorFooter>
</cfif>

