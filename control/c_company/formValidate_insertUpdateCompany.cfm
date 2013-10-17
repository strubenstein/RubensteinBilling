<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.companyStatus)>
	<cfset errorMessage_fields.companyStatus = Variables.lang_insertUpdateCompany.companyStatus>
</cfif>

<cfif Len(Form.companyName) gt maxlength_Company.companyName>
	<cfset errorMessage_fields.companyName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCompany.companyName, "<<MAXLENGTH>>", maxlength_Company.companyName, "ALL"), "<<LEN>>", Len(Form.companyName), "ALL")>
</cfif>

<cfif Len(Form.companyDBA) gt maxlength_Company.companyDBA>
	<cfset errorMessage_fields.companyDBA = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCompany.companyDBA, "<<MAXLENGTH>>", maxlength_Company.companyDBA, "ALL"), "<<LEN>>", Len(Form.companyDBA), "ALL")>
</cfif>

<cfif Len(Form.companyID_custom) gt maxlength_Company.companyID_custom>
	<cfset errorMessage_fields.companyID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCompany.companyID_custom, "<<MAXLENGTH>>", maxlength_Company.companyID_custom, "ALL"), "<<LEN>>", Len(Form.companyID_custom), "ALL")>
</cfif>

<cfif Len(Form.companyURL) gt maxlength_Company.companyURL>
	<cfset errorMessage_fields.companyURL = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCompany.companyURL_maxlength, "<<MAXLENGTH>>", maxlength_Company.companyURL, "ALL"), "<<LEN>>", Len(Form.companyURL), "ALL")>
<cfelseif Form.companyURL is not Variables.default_companyURL and Trim(Form.companyURL) is not "">
	<cfif Not fn_IsValidURL(Form.companyURL)>
		<cfset errorMessage_fields.companyURL = Variables.lang_insertUpdateCompany.companyURL_valid>
	</cfif>
</cfif>

<cfif Form.affiliateID is not 0 and Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
	<cfset errorMessage_fields.affiliateID = Variables.lang_insertUpdateCompany.affiliateID>
</cfif>

<cfif Form.cobrandID is not 0 and Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
	<cfset errorMessage_fields.cobrandID = Variables.lang_insertUpdateCompany.cobrandID>
</cfif>

<cfif Not ListFind("0,1", Form.companyIsCustomer)>
	<cfset errorMessage_fields.companyIsCustomer = Variables.lang_insertUpdateCompany.companyIsCustomer>
</cfif>
<cfif Not ListFind("0,1", Form.companyIsAffiliate)>
	<cfset errorMessage_fields.companyIsAffiliate = Variables.lang_insertUpdateCompany.companyIsAffiliate>
</cfif>
<cfif Not ListFind("0,1", Form.companyIsCobrand)>
	<cfset errorMessage_fields.companyIsCobrand = Variables.lang_insertUpdateCompany.companyIsCobrand>
</cfif>
<cfif Not ListFind("0,1", Form.companyIsVendor)>
	<cfset errorMessage_fields.companyIsVendor = Variables.lang_insertUpdateCompany.companyIsVendor>
</cfif>
<cfif Not ListFind("0,1", Form.companyIsTaxExempt)>
	<cfset errorMessage_fields.companyIsTaxExempt = Variables.lang_insertUpdateCompany.companyIsTaxExempt>
</cfif>

<cfif Form.userID is not "" and Form.userID is not 0 and Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.userID)>
	<cfset errorMessage_fields.userID = Variables.lang_insertUpdateCompany.userID>
</cfif>

<!--- if creating primary company and specifying directory name, validate directory name --->
<cfif Variables.doAction is "insertCompany" and IsDefined("Form.companyPrimary") and Form.companyPrimary is 1>
	<cfif IsDefined("Form.companyDirectory") and Form.companyDirectory is not "">
		<cfif REFindNoCase("[^A-Za-z0-9_]", Form.companyDirectory)>
			<cfset errorMessage_fields.userID = Variables.lang_insertUpdateCompany.companyDirectory_valid>
		<cfelseif Len(Form.companyDirectory) gt maxlength_Company.companyDirectory>
			<cfset errorMessage_fields.companyDirectory = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCompany.companyDirectory_maxlength, "<<MAXLENGTH>>", maxlength_Company.companyDirectory, "ALL"), "<<LEN>>", Len(Form.companyDirectory), "ALL")>
		<cfelseif DirectoryExists(Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & Form.companyDirectory)>
			<cfset errorMessage_fields.userID = Variables.lang_insertUpdateCompany.companyDirectory_unique>
		</cfif>
	</cfif>
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
	<cfif Form.companyURL is Variables.default_companyURL>
		<cfset Form.companyURL = "">
	</cfif>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertCompany">
		<cfset errorMessage_title = Variables.lang_insertUpdateCompany.errorTitle_insert>
	<cfelse><!--- updateCompany --->
		<cfset errorMessage_title = Variables.lang_insertUpdateCompany.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateCompany.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateCompany.errorFooter>
</cfif>

