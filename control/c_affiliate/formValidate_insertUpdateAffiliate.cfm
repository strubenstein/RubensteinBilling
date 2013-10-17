<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.affiliateStatus)>
	<cfset errorMessage_fields.affiliateStatus = Variables.lang_insertUpdateAffiliate.affiliateStatus>
</cfif>

<cfif Trim(Form.affiliateName) is "">
	<cfset errorMessage_fields.affiliateName = Variables.lang_insertUpdateAffiliate.affiliateName_blank>
<cfelseif Len(Form.affiliateName) gt maxlength_Affiliate.affiliateName>
	<cfset errorMessage_fields.affiliateName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateAffiliate.affiliateName_maxlength, "<<MAXLENGTH>>", maxlength_Affiliate.affiliateName, "ALL"), "<<LEN>>", Len(Form.affiliateName), "ALL")>
</cfif>

<cfif Form.userID is not "" and Form.userID is not 0 and Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.userID)>
	<cfset errorMessage_fields.userID = Variables.lang_insertUpdateAffiliate.userID>
</cfif>

<cfif Len(Form.affiliateURL) gt maxlength_Affiliate.affiliateURL>
	<cfset errorMessage_fields.affiliateURL = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateAffiliate.affiliateURL_maxlength, "<<MAXLENGTH>>", maxlength_Affiliate.affiliateURL, "ALL"), "<<LEN>>", Len(Form.affiliateURL), "ALL")>
<cfelseif Form.affiliateURL is not Variables.default_affiliateURL and Trim(Form.affiliateURL) is not "">
	<cfif Not fn_IsValidURL(Form.affiliateURL)>
		<cfset errorMessage_fields.affiliateURL = Variables.lang_insertUpdateAffiliate.affiliateURL_valid>
	</cfif>
</cfif>

<cfif Len(Form.affiliateCode) gt maxlength_Affiliate.affiliateCode>
	<cfset errorMessage_fields.affiliateCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateAffiliate.affiliateCode_maxlength, "<<MAXLENGTH>>", maxlength_Affiliate.affiliateCode, "ALL"), "<<LEN>>", Len(Form.affiliateCode), "ALL")>
<cfelseif Form.affiliateCode is not "">
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="checkAffiliateCodeIsUnique" ReturnVariable="isAffiliateCodeUnique">
		<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		<cfelse>
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID#">
		</cfif>
		<cfinvokeargument Name="affiliateCode" Value="#Form.affiliateCode#">
		<cfif URL.affiliateID is not 0>
			<cfinvokeargument Name="affiliateID" Value="#URL.affiliateID#">
		</cfif>
	</cfinvoke>

	<cfif isAffiliateCodeUnique is False>
		<cfset errorMessage_fields.affiliateCode = Variables.lang_insertUpdateAffiliate.affiliateCode_unique>
	</cfif>
</cfif>

<cfif Len(Form.affiliateID_custom) gt maxlength_Affiliate.affiliateID_custom>
	<cfset errorMessage_fields.affiliateID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateAffiliate.affiliateID_custom, "<<MAXLENGTH>>", maxlength_Affiliate.affiliateID_custom, "ALL"), "<<LEN>>", Len(Form.affiliateID_custom), "ALL")>
</cfif>

<!--- Validate custom fields and custom status if applicable (and not via web service) --->
<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
	<cfif isCustomFieldValueExist is True>
		<cfinvoke component="#objInsertCustomFieldValue#" method="formValidate_insertCustomFieldValue" returnVariable="errorMessageStruct_customField" />
		<cfif Not StructIsEmpty(errorMessageStruct_customField)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_customField)>
		</cfif>
	</cfif>

	<cfif isStatusExist is True>
		<cfinvoke component="#objInsertStatusHistory#" method="formValidate_insertStatusHistory" returnVariable="errorMessageStruct_status" />
		<cfif Not StructIsEmpty(errorMessageStruct_status)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_status)>
		</cfif>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertAffiliate">
		<cfset errorMessage_title = Variables.lang_insertUpdateAffiliate.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateAffiliate.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateAffiliate.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateAffiliate.errorFooter>
</cfif>

