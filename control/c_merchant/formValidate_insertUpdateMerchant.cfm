<cfset errorMessage_fields = StructNew()>

<cfif Form.userID is not 0>
	<cfif Variables.displayUsers is False>
		<cfset errorMessage_fields.userID = Variables.lang_insertUpdateMerchant.userID_none>
	<cfelseif Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.userID)>
		<cfset errorMessage_fields.userID = Variables.lang_insertUpdateMerchant.userID_valid>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.merchantBank)>
	<cfset errorMessage_fields.merchantBank = Variables.lang_insertUpdateMerchant.merchantBank>
</cfif>

<cfif Not ListFind("0,1", Form.merchantCreditCard)>
	<cfset errorMessage_fields.merchantCreditCard = Variables.lang_insertUpdateMerchant.merchantCreditCard>
</cfif>

<cfif Not ListFind("0,1", Form.merchantStatus)>
	<cfset errorMessage_fields.merchantStatus = Variables.lang_insertUpdateMerchant.merchantStatus>
</cfif>

<cfif Trim(Form.merchantName) is "">
	<cfset errorMessage_fields.merchantName = Variables.lang_insertUpdateMerchant.merchantName_blank>
<cfelseif Len(Form.merchantName) gt maxlength_Merchant.merchantName>
	<cfset errorMessage_fields.merchantName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchant.merchantName_maxlength, "<<MAXLENGTH>>", maxlength_Merchant.merchantName, "ALL"), "<<LEN>>", Len(Form.merchantName), "ALL")>
</cfif>

<cfif Trim(Form.merchantTitle) is "">
	<cfset errorMessage_fields.merchantTitle = Variables.lang_insertUpdateMerchant.merchantTitle_blank>
<cfelseif Len(Form.merchantTitle) gt maxlength_Merchant.merchantTitle>
	<cfset errorMessage_fields.merchantTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchant.merchantTitle_maxlength, "<<MAXLENGTH>>", maxlength_Merchant.merchantTitle, "ALL"), "<<LEN>>", Len(Form.merchantTitle), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Merchant" Method="checkMerchantTitleIsUnique" ReturnVariable="isMerchantTitleUnique">
		<cfinvokeargument Name="merchantTitle" Value="#Form.merchantTitle#">
		<cfif Variables.doAction is "updateMerchant">
			<cfinvokeargument Name="merchantID" Value="#URL.merchantID#">
		</cfif>
	</cfinvoke>

	<cfif isMerchantTitleUnique is False>
		<cfset errorMessage_fields.merchantTitle = Variables.lang_insertUpdateMerchant.merchantTitle_unique>
	</cfif>
</cfif>

<cfif Len(Form.merchantURL) gt maxlength_Merchant.merchantURL>
	<cfset errorMessage_fields.merchantURL = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchant.merchantURL_maxlength, "<<MAXLENGTH>>", maxlength_Merchant.merchantURL, "ALL"), "<<LEN>>", Len(Form.merchantURL), "ALL")>
<cfelseif Form.merchantURL is not Variables.default_merchantURL and Trim(Form.merchantURL) is "">
	<cfif Not fn_IsValidURL(Form.merchantURL)>
		<cfset errorMessage_fields.merchantURL = Variables.lang_insertUpdateMerchant.merchantURL_valid>
	</cfif>
</cfif>

<cfif Len(Form.merchantDescription) gt maxlength_Merchant.merchantDescription>
	<cfset errorMessage_fields.merchantDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchant.merchantDescription_maxlength, "<<MAXLENGTH>>", maxlength_Merchant.merchantDescription, "ALL"), "<<LEN>>", Len(Form.merchantDescription), "ALL")>
</cfif>

<cfif Trim(Form.merchantFilename) is "">
	<cfset errorMessage_fields.merchantFilename = Variables.lang_insertUpdateMerchant.merchantFilename_blank>
<cfelseif Len(Form.merchantFilename) gt maxlength_Merchant.merchantFilename>
	<cfset errorMessage_fields.merchantFilename = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchant.merchantFilename_maxlength, "<<MAXLENGTH>>", maxlength_Merchant.merchantFilename, "ALL"), "<<LEN>>", Len(Form.merchantFilename), "ALL")>
<cfelse>
	<cfset Variables.merchantFilepath = Application.billingFilePath & Application.billingFilePathSlash & "include" & Application.billingFilePathSlash & "merchant">
	<cfif Not FileExists(Variables.merchantFilepath & Application.billingFilePathSlash & Form.merchantFilename)>
		<cfset errorMessage_fields.merchantFilename = Variables.lang_insertUpdateMerchant.merchantFilename_exist>
	</cfif>
</cfif>

<cfif Len(Form.merchantRequiredFields) gt maxlength_Merchant.merchantRequiredFields>
	<cfset errorMessage_fields.merchantRequiredFields = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateMerchant.merchantRequiredFields_maxlength, "<<MAXLENGTH>>", maxlength_Merchant.merchantRequiredFields, "ALL"), "<<LEN>>", Len(Form.merchantRequiredFields), "ALL")>
<cfelseif Form.merchantRequiredFields is not "">
	<cfloop Index="requiredField" List="#Form.merchantRequiredFields#">
		<cfif Not ListFind("merchantAccountUsername,merchantAccountPassword,merchantAccountID_custom", requiredField)>
			<cfset errorMessage_fields.merchantRequiredFields = Variables.lang_insertUpdateMerchant.merchantRequiredFields_valid>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertMerchant">
		<cfset errorMessage_title = Variables.lang_insertUpdateMerchant.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateMerchant.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateMerchant.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateMerchant.errorFooter>
</cfif>

