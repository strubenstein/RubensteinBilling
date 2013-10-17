<cfset errorMessage_fields = StructNew()>

<!--- 
<cfif Not ListFind("0,1", Form.creditCardStatus)>
	<cfset errorMessage_fields.creditCardStatus = Variables.lang_insertCreditCard.creditCardStatus>
</cfif>
--->
<cfif Not ListFind("0,1", Form.creditCardRetain)>
	<cfset errorMessage_fields.creditCardRetain = Variables.lang_insertCreditCard.creditCardRetain>
</cfif>

<cfif Form.addressID is not 0 and Not ListFind(ValueList(qry_selectAddressList.addressID), Form.addressID)>
	<cfset errorMessage_fields.addressID = Variables.lang_insertCreditCard.addressID_valid>
</cfif>

<cfif Trim(Form.creditCardName) is "">
	<cfset errorMessage_fields.creditCardName = Variables.lang_insertCreditCard.creditCardName_blank>
<cfelseif Len(Form.creditCardName) gt maxlength_CreditCard.creditCardName_decrypted>
	<cfset errorMessage_fields.creditCardName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertCreditCard.creditCardName_maxlength, "<<MAXLENGTH>>", maxlength_CreditCard.creditCardName_decrypted, "ALL"), "<<LEN>>", Len(Form.creditCardName), "ALL")>
</cfif>

<cfif Trim(Form.creditCardType) is "">
	<cfset errorMessage_fields.creditCardType = Variables.lang_insertCreditCard.creditCardType_blank>
<cfelseif Not ListFind(Variables.creditCardTypeList_value, Form.creditCardType)>
	<cfset errorMessage_fields.creditCardType = Variables.lang_insertCreditCard.creditCardType_valid>
</cfif>

<cfset Form.creditCardNumber = Replace(Replace(Form.creditCardNumber, " ", "", "ALL"), "-", "", "ALL")>
<cfif Trim(Form.creditCardNumber is "")>
	<cfset errorMessage_fields.creditCardNumber = Variables.lang_insertCreditCard.creditCardNumber_blank>
<cfelseif Len(Form.creditCardNumber) gt maxlength_CreditCard.creditCardNumber_decrypted
		or REFind("[^0-9]", Form.creditCardNumber) or Not fn_IsMod10(Form.creditCardNumber)>
	<cfset errorMessage_fields.creditCardNumber = Variables.lang_insertCreditCard.creditCardNumber_valid>
<cfelseif Not StructKeyExists(errorMessage_fields, "creditCardType") and Not fn_IsCreditCardNumberSameAsType(Form.creditCardNumber, Form.creditCardType)>
	<cfset errorMessage_fields.creditCardNumber = Variables.lang_insertCreditCard.creditCardNumber_type>
</cfif>

<cfif Trim(Form.creditCardExpirationMonth) is "">
	<cfset errorMessage_fields.creditCardExpirationMonth = Variables.lang_insertCreditCard.creditCardExpirationMonth_blank>
<cfelseif Not ListFind(Variables.creditCardExpirationMonthList_value, Form.creditCardExpirationMonth)>
	<cfset errorMessage_fields.creditCardExpirationMonth = Variables.lang_insertCreditCard.creditCardExpirationMonth_valid>
</cfif>

<cfif Trim(Form.creditCardExpirationYear) is "">
	<cfset errorMessage_fields.creditCardExpirationYear = Variables.lang_insertCreditCard.creditCardExpirationYear_blank>
<cfelseif Not Application.fn_IsIntegerPositive(Form.creditCardExpirationYear)
		or Form.creditCardExpirationYear lt Year(Now()) or Form.creditCardExpirationYear gt (Year(Now()) + 10)>
	<cfset errorMessage_fields.creditCardExpirationYear = Variables.lang_insertCreditCard.creditCardExpirationYear_valid>
</cfif>

<cfif Not StructKeyExists(errorMessage_fields, "creditCardExpirationMonth") and Not StructKeyExists(errorMessage_fields, "creditCardExpirationYear")
		and Form.creditCardExpirationYear is Year(Now()) and Form.creditCardExpirationMonth lt Month(Now())>
	<cfset errorMessage_fields.creditCardExpiration = Variables.lang_insertCreditCard.creditCardExpiration_expired>
</cfif>

<!--- 
<cfif Trim(Form.creditCardCVC is "")>
	<cfset errorMessage_fields.creditCardCVC = Variables.lang_insertCreditCard.creditCardCVC_blank>
--->
<cfif REFind("[^0-9]", Form.creditCardCVC)>
	<cfset errorMessage_fields.creditCardCVC = Variables.lang_insertCreditCard.creditCardCVC_valid>
<cfelseif Len(Form.creditCardCVC) gt maxlength_CreditCard.creditCardCVC_decrypted>
	<cfset errorMessage_fields.creditCardCVC = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertCreditCard.creditCardCVC_maxlength, "<<MAXLENGTH>>", 4, "ALL"), "<<LEN>>", Len(Form.creditCardCVC), "ALL")>
</cfif>

<cfif Len(Form.creditCardDescription) gt maxlength_CreditCard.creditCardDescription>
	<cfset errorMessage_fields.creditCardDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertCreditCard.creditCardDescription_maxlength, "<<MAXLENGTH>>", 4, "ALL"), "<<LEN>>", Len(Form.creditCardDescription), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.creditCardID is 0>
		<cfset errorMessage_title = Variables.lang_insertCreditCard.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertCreditCard.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertCreditCard.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertCreditCard.errorFooter>
</cfif>

