<cfset errorMessage_fields = StructNew()>

<cfif Len(Form.merchantAccountCreditCardTypeList) gt maxlength_MerchantAccount.merchantAccountCreditCardTypeList>
	<cfset errorMessage_fields.merchantAccountCreditCardTypeList = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchantAccount.merchantAccountCreditCardTypeList_maxlength, "<<MAXLENGTH>>", maxlength_MerchantAccount.merchantAccountCreditCardTypeList, "ALL"), "<<LEN>>", Len(Form.merchantAccountCreditCardTypeList), "ALL")>
<cfelse>
	<cfloop Index="card" List="#Form.merchantAccountCreditCardTypeList#">
		<cfif Not ListFind(Variables.creditCardTypeList_value, card)>
			<cfset errorMessage_fields.merchantAccountCreditCardTypeList = Variables.lang_insertUpdateMerchantAccount.merchantAccountCreditCardTypeList_valid>
			<cfbreak>
		</cfif>
	</cfloop>

	<cfif Not StructKeyExists(errorMessage_fields, "merchantAccountCreditCardTypeList")>
		<cfif Form.merchantAccountCreditCardTypeList is "">
			<cfset Form.merchantAccountCreditCard = 0>
		<cfelse>
			<cfset Form.merchantAccountCreditCard = 1>
		</cfif>
	</cfif>
</cfif>

<cfset Variables.merchantRow = ListFind(ValueList(qry_selectMerchantList.merchantID), Form.merchantID)>
<cfif Variables.merchantRow is 0>
	<cfset errorMessage_fields.merchantID = Variables.lang_insertUpdateMerchantAccount.merchantID>
<cfelse>
	<cfif Not ListFind("0,1", Form.merchantAccountBank)>
		<cfset errorMessage_fields.merchantAccountBank = Variables.lang_insertUpdateMerchantAccount.merchantAccountBank_valid>
	<cfelseif Form.merchantAccountBank is 1 and qry_selectMerchantList.merchantBank[Variables.merchantRow] is 0>
		<cfset errorMessage_fields.merchantAccountBank = Variables.lang_insertUpdateMerchantAccount.merchantAccountBank_merchant>
	</cfif>

	<cfif Not ListFind("0,1", Form.merchantAccountCreditCard)>
		<cfset errorMessage_fields.merchantAccountCreditCard = Variables.lang_insertUpdateMerchantAccount.merchantAccountCreditCard>
	<cfelseif Form.merchantAccountCreditCard is 1 and qry_selectMerchantList.merchantCreditCard[Variables.merchantRow] is 0>
		<cfset errorMessage_fields.merchantAccountCreditCard = Variables.lang_insertUpdateMerchantAccount.merchantAccountCreditCard_merchant>
	</cfif>

	<cfif Len(Form.merchantAccountUsername) gt maxlength_MerchantAccount.merchantAccountUsername_decrypted>
		<cfset errorMessage_fields.merchantAccountUsername = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchantAccount.merchantAccountUsername_maxlength, "<<MAXLENGTH>>", maxlength_MerchantAccount.merchantAccountUsername_decrypted, "ALL"), "<<LEN>>", Len(Form.merchantAccountUsername), "ALL")>
	<cfelseif Trim(Form.merchantAccountUsername) is "" and ListFind(qry_selectMerchantList.merchantRequiredFields[Variables.merchantRow], "merchantAccountUsername")>
		<cfset errorMessage_fields.merchantAccountUsername = Variables.lang_insertUpdateMerchantAccount.merchantAccountUsername_blank>
	</cfif>

	<cfif Len(Form.merchantAccountPassword) gt maxlength_MerchantAccount.merchantAccountPassword_decrypted>
		<cfset errorMessage_fields.merchantAccountPassword = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchantAccount.merchantAccountPassword_maxlength, "<<MAXLENGTH>>", maxlength_MerchantAccount.merchantAccountPassword_decrypted, "ALL"), "<<LEN>>", Len(Form.merchantAccountPassword), "ALL")>
	<cfelseif Trim(Form.merchantAccountPassword) is "" and ListFind(qry_selectMerchantList.merchantRequiredFields[Variables.merchantRow], "merchantAccountPassword")>
		<cfset errorMessage_fields.merchantAccountPassword = Variables.lang_insertUpdateMerchantAccount.merchantAccountPassword_blank>
	</cfif>

	<cfif Len(Form.merchantAccountID_custom) gt maxlength_MerchantAccount.merchantAccountID_custom_decrypted>
		<cfset errorMessage_fields.merchantAccountID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchantAccount.merchantAccountID_custom_maxlength, "<<MAXLENGTH>>", maxlength_MerchantAccount.merchantAccountID_custom_decrypted, "ALL"), "<<LEN>>", Len(Form.merchantAccountID_custom), "ALL")>
	<cfelseif Trim(Form.merchantAccountID_custom) is "" and ListFind(qry_selectMerchantList.merchantRequiredFields[Variables.merchantRow], "merchantAccountID_custom")>
		<cfset errorMessage_fields.merchantAccountID_custom = Variables.lang_insertUpdateMerchantAccount.merchantAccountID_custom_blank>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.merchantAccountStatus)>
	<cfset errorMessage_fields.merchantAccountStatus = Variables.lang_insertUpdateMerchantAccount.merchantAccountStatus>
</cfif>

<cfif Len(Form.merchantAccountDescription) gt maxlength_MerchantAccount.merchantAccountDescription>
	<cfset errorMessage_fields.merchantAccountDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchantAccount.merchantAccountDescription_maxlength, "<<MAXLENGTH>>", maxlength_MerchantAccount.merchantAccountDescription, "ALL"), "<<LEN>>", Len(Form.merchantAccountDescription), "ALL")>
</cfif>

<cfif Len(Form.merchantAccountName) gt maxlength_MerchantAccount.merchantAccountName>
	<cfset errorMessage_fields.merchantAccountName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchantAccount.merchantAccountName_maxlength, "<<MAXLENGTH>>", maxlength_MerchantAccount.merchantAccountName, "ALL"), "<<LEN>>", Len(Form.merchantAccountName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="checkMerchantAccountNameIsUnique" ReturnVariable="isMerchantAccountNameUnique">
		<cfinvokeargument Name="merchantAccountName" Value="#Form.merchantAccountName#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfif Variables.doAction is "updateMerchantAccount">
			<cfinvokeargument Name="merchantAccountID" Value="#URL.merchantAccountID#">
		</cfif>
	</cfinvoke>

	<cfif isMerchantAccountNameUnique is False>
		<cfset errorMessage_fields.merchantAccountName = Variables.lang_insertUpdateMerchantAccount.merchantAccountName_unique>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertMerchantAccount">
		<cfset errorMessage_title = Variables.lang_insertUpdateMerchantAccount.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateMerchantAccount.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateMerchantAccount.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateMerchantAccount.errorFooter>
</cfif>

