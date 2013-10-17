<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.cobrandStatus)>
	<cfset errorMessage_fields.cobrandStatus = Variables.lang_insertUpdateCobrand.cobrandStatus>
</cfif>

<cfif Trim(Form.cobrandName) is "">
	<cfset errorMessage_fields.cobrandName = Variables.lang_insertUpdateCobrand.cobrandName_blank>
<cfelseif Len(Form.cobrandName) gt maxlength_Cobrand.cobrandName>
	<cfset errorMessage_fields.cobrandName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCobrand.cobrandName_maxlength, "<<MAXLENGTH>>", maxlength_Cobrand.cobrandName, "ALL"), "<<LEN>>", Len(Form.cobrandName), "ALL")>
</cfif>

<cfif Trim(Form.cobrandTitle) is "">
	<cfset errorMessage_fields.cobrandTitle = Variables.lang_insertUpdateCobrand.cobrandTitle_blank>
<cfelseif Len(Form.cobrandTitle) gt maxlength_Cobrand.cobrandTitle>
	<cfset errorMessage_fields.cobrandTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCobrand.cobrandTitle_maxlength, "<<MAXLENGTH>>", maxlength_Cobrand.cobrandTitle, "ALL"), "<<LEN>>", Len(Form.cobrandTitle), "ALL")>
</cfif>

<cfif Form.userID is not "" and Form.userID is not 0 and Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.userID)>
	<cfset errorMessage_fields.userID = Variables.lang_insertUpdateCobrand.userID>
</cfif>

<cfif Len(Form.cobrandURL) gt maxlength_Cobrand.cobrandURL>
	<cfset errorMessage_fields.cobrandURL = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCobrand.cobrandURL_maxlength, "<<MAXLENGTH>>", maxlength_Cobrand.cobrandURL, "ALL"), "<<LEN>>", Len(Form.cobrandURL), "ALL")>
<cfelseif Form.cobrandURL is not Variables.default_cobrandURL and Trim(Form.cobrandURL) is not "">
	<cfif Not fn_IsValidURL(Form.cobrandURL)>
		<cfset errorMessage_fields.cobrandURL = Variables.lang_insertUpdateCobrand.cobrandURL_valid>
	</cfif>
</cfif>

<cfif Len(Form.cobrandCode) gt maxlength_Cobrand.cobrandCode>
	<cfset errorMessage_fields.cobrandCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCobrand.cobrandCode_maxlength, "<<MAXLENGTH>>", maxlength_Cobrand.cobrandCode, "ALL"), "<<LEN>>", Len(Form.cobrandCode), "ALL")>
<cfelseif Form.cobrandCode is not "">
	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="checkCobrandCodeIsUnique" ReturnVariable="isCobrandCodeUnique">
		<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		<cfelse>
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID#">
		</cfif>
		<cfinvokeargument Name="cobrandCode" Value="#Form.cobrandCode#">
		<cfif URL.cobrandID is not 0>
			<cfinvokeargument Name="cobrandID" Value="#URL.cobrandID#">
		</cfif>
	</cfinvoke>

	<cfif isCobrandCodeUnique is False>
		<cfset errorMessage_fields.cobrandCode = Variables.lang_insertUpdateCobrand.cobrandCode_unique>
	</cfif>
</cfif>

<cfif Len(Form.cobrandID_custom) gt maxlength_Cobrand.cobrandID_custom>
	<cfset errorMessage_fields.cobrandID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCobrand.cobrandID_custom, "<<MAXLENGTH>>", maxlength_Cobrand.cobrandID_custom, "ALL"), "<<LEN>>", Len(Form.cobrandID_custom), "ALL")>
</cfif>

<cfif Form.cobrandDirectory is not "" and REFindNoCase("[^A-Za-z0-9_]", Form.cobrandDirectory)>
	<cfset errorMessage_fields.cobrandDirectory = Variables.lang_insertUpdateCobrand.cobrandDirectory_valid>
<cfelseif Len(Form.cobrandDirectory) gt maxlength_Cobrand.cobrandDirectory>
	<cfset errorMessage_fields.cobrandDirectory = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCobrand.cobrandDirectory_maxlength, "<<MAXLENGTH>>", maxlength_Cobrand.cobrandDirectory, "ALL"), "<<LEN>>", Len(Form.cobrandDirectory), "ALL")>
</cfif>

<cfif Form.cobrandDomain is not "" and (REFindNoCase("[^A-Za-z0-9.-]", Form.cobrandDomain) or ListLen(Form.cobrandDomain, ".") is not 2)>
	<cfset errorMessage_fields.cobrandDomain = Variables.lang_insertUpdateCobrand.cobrandDomain_valid>
<cfelseif Len(Form.cobrandDomain) gt maxlength_Cobrand.cobrandDomain>
	<cfset errorMessage_fields.cobrandDomain = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCobrand.cobrandDomain_maxlength, "<<MAXLENGTH>>", maxlength_Cobrand.cobrandDomain, "ALL"), "<<LEN>>", Len(Form.cobrandDomain), "ALL")>
</cfif>

<cfif URL.action is "insertCobrand">
	<cfset uploadDirectoryPath = Application.billingFilePath & Application.billingFilePathSlash & "images" & Application.billingFilePathSlash & "img_cobrand">
	<cfset uploadDirectoryURL = "#Application.billingUrl#/images/img_cobrand">
<cfelse>
	<cfset uploadDirectoryPath = Application.billingFilePath & Application.billingFilePathSlash & Application.billingPartnerDirectory & Application.billingFilePathSlash & "p" & URL.cobrandID>
	<cfset uploadDirectoryURL = "#Application.billingUrl#/#Application.billingPartnerDirectory#/p#URL.cobrandID#">
</cfif>

<cfset imageField = "cobrandImage">
<cfset imageFieldFileUpload = "cobrandImageFile">

<cfinclude template="../../include/function/act_imageUpload.cfm">
<cfif isImageUploaded is False and Not StructKeyExists(errorMessage_fields, "cobrandImage")>
	<cfif Len(Form.cobrandImage) gt maxlength_Cobrand.cobrandImage>
		<cfset errorMessage_fields.cobrandImage = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCobrand.cobrandImage_maxlength, "<<MAXLENGTH>>", maxlength_Cobrand.cobrandImage, "ALL"), "<<LEN>>", Len(Form.cobrandImage), "ALL")>
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
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertCobrand">
		<cfset errorMessage_title = Variables.lang_insertUpdateCobrand.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateCobrand.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateCobrand.errorHeader>
	<cfif isImageUploaded is True>
		<cfset errorMessage_footer = Variables.lang_insertUpdateCobrand.errorFooter_imageUpload>
	<cfelse>
		<cfset errorMessage_footer = Variables.lang_insertUpdateCobrand.errorFooter_standard>
	</cfif>
</cfif>

