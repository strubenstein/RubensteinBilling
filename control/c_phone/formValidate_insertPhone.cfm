<cfset errorMessage_fields = StructNew()>

<!--- 
<cfif Not ListFind("0,1", Form.phoneStatus)>
	<cfset errorMessage_fields.phoneStatus = Variables.lang_insertPhone.phoneStatus>
</cfif>
--->

<cfif Trim(Form.phoneAreaCode) is "">
	<cfset errorMessage_fields.phoneAreaCode = Variables.lang_insertPhone.phoneAreaCode_blank>
<cfelseif Not Application.fn_IsIntegerPositive(Form.phoneAreaCode)>
	<cfset errorMessage_fields.phoneAreaCode = Variables.lang_insertPhone.phoneAreaCode_valid>
<cfelseif Len(Form.phoneAreaCode) gt maxlength_Phone.phoneAreaCode>
	<cfset errorMessage_fields.phoneAreaCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPhone.phoneAreaCode_maxlength, "<<MAXLENGTH>>", maxlength_Phone.phoneAreaCode, "ALL"), "<<LEN>>", Len(Form.phoneAreaCode), "ALL")>
</cfif>

<cfset Form.phoneNumber = REReplace(Form.phoneNumber, "[ -]", "", "ALL")>
<cfif Trim(Form.phoneNumber) is "">
	<cfset errorMessage_fields.phoneNumber = Variables.lang_insertPhone.phoneNumber_blank>
<cfelseif Not Application.fn_IsIntegerPositive(Form.phoneNumber)>
	<cfset errorMessage_fields.phoneNumber = Variables.lang_insertPhone.phoneNumber_valid>
<cfelseif Len(Form.phoneNumber) gt maxlength_Phone.phoneNumber>
	<cfset errorMessage_fields.phoneNumber = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPhone.phoneNumber_maxlength, "<<MAXLENGTH>>", maxlength_Phone.phoneNumber, "ALL"), "<<LEN>>", Len(Form.phoneNumber), "ALL")>
</cfif>

<cfif Trim(Form.phoneExtension) is not "" and Not Application.fn_IsIntegerPositive(Form.phoneExtension)>
	<cfset errorMessage_fields.phoneExtension = Variables.lang_insertPhone.phoneExtension_valid>
<cfelseif Len(Form.phoneExtension) gt maxlength_Phone.phoneExtension>
	<cfset errorMessage_fields.phoneExtension = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPhone.phoneExtension_maxlength, "<<MAXLENGTH>>", maxlength_Phone.phoneExtension, "ALL"), "<<LEN>>", Len(Form.phoneExtension), "ALL")>
</cfif>

<cfif Trim(Form.phoneType) is not "" and Not ListFind(Variables.phoneTypeList_value, Form.phoneType)>
	<cfset errorMessage_fields.phoneType = Variables.lang_insertPhone.phoneType_valid>
<cfelseif Len(Form.phoneType) gt maxlength_Phone.phoneType>
	<cfset errorMessage_fields.phoneType = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPhone.phoneType_maxlength, "<<MAXLENGTH>>", maxlength_Phone.phoneType, "ALL"), "<<LEN>>", Len(Form.phoneType), "ALL")>
</cfif>

<cfif Len(Form.phoneDescription) gt maxlength_Phone.phoneDescription>
	<cfset errorMessage_fields.phoneDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertPhone.phoneDescription, "<<MAXLENGTH>>", maxlength_Phone.phoneDescription, "ALL"), "<<LEN>>", Len(Form.phoneDescription), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.phoneID is 0>
		<cfset errorMessage_title = Variables.lang_insertPhone.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertPhone.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertPhone.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertPhone.errorFooter>
</cfif>

