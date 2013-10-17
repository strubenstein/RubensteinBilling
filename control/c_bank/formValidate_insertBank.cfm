<cfset errorMessage_fields = StructNew()>

<cfif Form.addressID is not 0 and Not ListFind(ValueList(qry_selectAddressList.addressID), Form.addressID)>
	<cfset errorMessage_fields.addressID = Variables.lang_insertBank.addressID_valid>
</cfif>

<cfloop Index="field" List="bankRetain,bankPersonalOrCorporate"><!---- bankStatus --->
	<cfif Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_insertBank[field]>
	</cfif>
</cfloop>

<cfif Form.bankCheckingOrSavings is not "" and Not ListFind("0,1", Form.bankCheckingOrSavings)>
	<cfset errorMessage_fields.bankCheckingOrSavings = Variables.lang_insertBank.bankCheckingOrSavings>
</cfif>

<cfloop Index="field" List="bankName,bankBranch,bankBranchCity,bankBranchContactName,bankBranchPhone,bankBranchFax,bankAccountName,bankDescription,bankAccountType">
	<cfif Len(Form[field]) gt maxlength_Bank[field]>
		<cfset errorMessage_fields[field] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertBank["#field#_maxlength"], "<<MAXLENGTH>>", maxlength_Bank[field], "ALL"), "<<LEN>>", Len(Form[field]), "ALL")>
	</cfif>
</cfloop>

<cfloop Index="field" List="bankRoutingNumber,bankAccountNumber">
	<cfif Len(Form[field]) gt maxlength_Bank["#field#_decrypted"]>
		<cfset errorMessage_fields[field] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertBank["#field#_maxlength"], "<<MAXLENGTH>>", maxlength_Bank["#field#_decrypted"], "ALL"), "<<LEN>>", Len(Form[field]), "ALL")>
	</cfif>
</cfloop>

<cfif Trim(Form.bankBranchStateOther) is not "">
	<cfif Len(Form.bankBranchStateOther) gt maxlength_Bank.bankBranchState>
		<cfset errorMessage_fields.bankBranchState = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertBank.bankBranchState_maxlength, "<<MAXLENGTH>>", maxlength_Bank.bankBranchState, "ALL"), "<<LEN>>", Len(Form.bankBranchStateOther), "ALL")>
	<cfelse>
		<cfset Form.bankBranchState = Form.bankBranchStateOther>
	</cfif>
<cfelseif Len(Form.bankBranchState) gt maxlength_Bank.bankBranchState>
	<cfset errorMessage_fields.bankBranchState = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertBank.bankBranchState_maxlength, "<<MAXLENGTH>>", maxlength_Bank.bankBranchState, "ALL"), "<<LEN>>", Len(Form.bankBranchState), "ALL")>
<cfelseif Trim(Form.bankBranchState) is not "" and Not ListFind(Variables.selectStateList_value, Form.bankBranchState)>
	<cfset errorMessage_fields.bankBranchState = Variables.lang_insertBank.bankBranchState_valid>
</cfif>

<cfif Trim(Form.bankBranchCountryOther) is not "">
	<cfif Len(Form.bankBranchCountryOther) gt maxlength_Bank.bankBranchCountry>
		<cfset errorMessage_fields.bankBranchCountry = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertBank.bankBranchCountry_maxlength, "<<MAXLENGTH>>", maxlength_Bank.bankBranchCountry, "ALL"), "<<LEN>>", Len(Form.bankBranchCountryOther), "ALL")>
	<cfelse>
		<cfset Form.bankBranchCountry = Form.bankBranchCountryOther>
	</cfif>
<cfelseif Len(Form.bankBranchCountry) gt maxlength_Bank.bankBranchCountry>
	<cfset errorMessage_fields.bankBranchCountry = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertBank.bankBranchCountry_maxlength, "<<MAXLENGTH>>", maxlength_Bank.bankBranchCountry, "ALL"), "<<LEN>>", Len(Form.bankBranchCountry), "ALL")>
<cfelseif Trim(Form.bankBranchCountry) is not "" and Not ListFind(Variables.countryList_value, Form.bankBranchCountry)>
	<cfset errorMessage_fields.bankBranchCountry = Variables.lang_insertBank.bankBranchCountry_valid>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.bankID is 0>
		<cfset errorMessage_title = Variables.lang_insertBank.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertBank.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertBank.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertBank.errorFooter>
</cfif>

