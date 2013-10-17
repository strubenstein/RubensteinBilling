<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.vendorStatus)>
	<cfset errorMessage_fields.vendorStatus = Variables.lang_insertUpdateVendor.vendorStatus>
</cfif>

<cfif Trim(Form.vendorName) is "">
	<cfset errorMessage_fields.vendorName = Variables.lang_insertUpdateVendor.vendorName_blank>
<cfelseif Len(Form.vendorName) gt maxlength_Vendor.vendorName>
	<cfset errorMessage_fields.vendorName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateVendor.vendorName_maxlength, "<<MAXLENGTH>>", maxlength_Vendor.vendorName, "ALL"), "<<LEN>>", Len(Form.vendorName), "ALL")>
</cfif>

<cfif Form.userID is not "" and Form.userID is not 0 and Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.userID)>
	<cfset errorMessage_fields.userID = Variables.lang_insertUpdateVendor.userID>
</cfif>

<cfif Len(Form.vendorURL) gt maxlength_Vendor.vendorURL>
	<cfset errorMessage_fields.vendorURL = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateVendor.vendorURL_maxlength, "<<MAXLENGTH>>", maxlength_Vendor.vendorURL, "ALL"), "<<LEN>>", Len(Form.vendorURL), "ALL")>
<cfelseif Form.vendorURL is not Variables.default_vendorURL and Trim(Form.vendorURL) is not "">
	<cfif Not fn_IsValidURL(Form.vendorURL)>
		<cfset errorMessage_fields.vendorURL = Variables.lang_insertUpdateVendor.vendorURL_valid>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.vendorURLdisplay)>
	<cfset errorMessage_fields.vendorURLdisplay = Variables.lang_insertUpdateVendor.vendorURLdisplay>
</cfif>

<cfif Len(Form.vendorCode) gt maxlength_Vendor.vendorCode>
	<cfset errorMessage_fields.vendorCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateVendor.vendorCode_maxlength, "<<MAXLENGTH>>", maxlength_Vendor.vendorCode, "ALL"), "<<LEN>>", Len(Form.vendorCode), "ALL")>
<cfelseif Form.vendorCode is not "">
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="checkVendorCodeIsUnique" ReturnVariable="isVendorCodeUnique">
		<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		<cfelse>
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID#">
		</cfif>
		<cfinvokeargument Name="vendorCode" Value="#Form.vendorCode#">
		<cfif URL.vendorID is not 0>
			<cfinvokeargument Name="vendorID" Value="#URL.vendorID#">
		</cfif>
	</cfinvoke>

	<cfif isVendorCodeUnique is False>
		<cfset errorMessage_fields.vendorCode = Variables.lang_insertUpdateVendor.vendorCode_unique>
	</cfif>
</cfif>

<cfset uploadDirectoryPath = Application.billingFilePath & Application.billingFilePathSlash & "images" & Application.billingFilePathSlash & "img_vendor">
<cfset uploadDirectoryURL = "#Application.billingUrl#/images/img_vendor">
<cfset imageField = "vendorImage">
<cfset imageFieldFileUpload = "vendorImageFile">

<cfinclude template="../../include/function/act_imageUpload.cfm">
<cfif isImageUploaded is False and Not StructKeyExists(errorMessage_fields, "vendorImage")>
	<cfif Len(Form.vendorImage) gt maxlength_Vendor.vendorImage>
		<cfset errorMessage_fields.vendorImage = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateVendor.vendorImage_maxlength, "<<MAXLENGTH>>", maxlength_Vendor.vendorImage, "ALL"), "<<LEN>>", Len(Form.vendorImage), "ALL")>
	</cfif>
</cfif>

<cfif Len(Form.vendorID_custom) gt maxlength_Vendor.vendorID_custom>
	<cfset errorMessage_fields.vendorID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateVendor.vendorID_custom, "<<MAXLENGTH>>", maxlength_Vendor.vendorID_custom, "ALL"), "<<LEN>>", Len(Form.vendorID_custom), "ALL")>
</cfif>

<cfif Len(Form.vendorDescription) gt maxlength_Vendor.vendorDescription>
	<cfset errorMessage_fields.vendorDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateVendor.vendorDescription, "<<MAXLENGTH>>", maxlength_Vendor.vendorDescription, "ALL"), "<<LEN>>", Len(Form.vendorDescription), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.vendorDescriptionHtml)>
	<cfset errorMessage_fields.vendorDescriptionHtml = Variables.lang_insertUpdateVendor.vendorDescriptionHtml>
</cfif>

<cfif Not ListFind("0,1", Form.vendorDescriptionDisplay)>
	<cfset errorMessage_fields.vendorDescriptionDisplay = Variables.lang_insertUpdateVendor.vendorDescriptionDisplay>
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
	<cfif Variables.doAction is "insertVendor">
		<cfset errorMessage_title = Variables.lang_insertUpdateVendor.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateVendor.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateVendor.errorHeader>
	<cfif isImageUploaded is True>
		<cfset errorMessage_footer = Variables.lang_insertUpdateVendor.errorFooter_imageUpload>
	<cfelse>
		<cfset errorMessage_footer = Variables.lang_insertUpdateVendor.errorFooter_standard>
	</cfif>
</cfif>

