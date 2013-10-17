<cfset errorMessage_fields = StructNew()>

<cfif Variables.doAction is "updateContent" or (Variables.doAction is "insertContent" and URL.contentCategoryID is 0)>
	<cfif Not ListFind(ValueList(qry_selectContentCategoryList.contentCategoryID), Form.contentCategoryID)>
		<cfset errorMessage_fields.contentCategoryID = Variables.lang_insertUpdateContent.contentCategoryID_valid>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertContent" and URL.contentCategoryID is not 0>
	<cfif Not Application.fn_IsIntegerNonNegative(Form.contentOrder)>
		<cfset errorMessage_fields.contentOrder = Variables.lang_insertUpdateContent.contentOrder_valid>
	<cfelseif qry_selectContentList.RecordCount is not 0 and Form.contentOrder gt qry_selectContentList.contentOrder[qry_selectContentList.RecordCount]>
		<cfset errorMessage_fields.contentOrder = Variables.lang_insertUpdateContent.contentOrder_range>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.contentStatus)>
	<cfset errorMessage_fields.contentStatus = Variables.lang_insertUpdateContent.contentStatus>
</cfif>

<cfif Trim(Form.contentName) is "">
	<cfset errorMessage_fields.contentName = Variables.lang_insertUpdateContent.contentName_blank>
<cfelseif Len(Form.contentName) gt maxlength_Content.contentName>
	<cfset errorMessage_fields.contentName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContent.contentName_maxlength, "<<MAXLENGTH>>", maxlength_Content.contentName, "ALL"), "<<LEN>>", Len(Form.contentName), "ALL")>
<cfelseif Not StructKeyExists(errorMessage_fields, "contentCategoryID")>
	<cfinvoke Component="#Application.billingMapping#data.Content" Method="checkContentNameIsUnique" ReturnVariable="isContentNameUnique">
		<cfinvokeargument Name="contentName" Value="#Form.contentName#">
		<cfinvokeargument Name="contentCategoryID" Value="#Form.contentCategoryID#">
		<cfinvokeargument Name="contentID" Value="#URL.contentID#">
	</cfinvoke>

	<cfif isContentNameUnique is False>
		<cfset errorMessage_fields.contentName = Variables.lang_insertUpdateContent.contentName_unique>
	</cfif>
</cfif>

<cfif Trim(Form.contentCode) is "">
	<cfset errorMessage_fields.contentCode = Variables.lang_insertUpdateContent.contentCode_blank>
<cfelseif Len(Form.contentCode) gt maxlength_Content.contentCode>
	<cfset errorMessage_fields.contentCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContent.contentCode_maxlength, "<<MAXLENGTH>>", maxlength_Content.contentCode, "ALL"), "<<LEN>>", Len(Form.contentCode), "ALL")>
<cfelseif Not StructKeyExists(errorMessage_fields, "contentCategoryID")>
	<cfinvoke Component="#Application.billingMapping#data.Content" Method="checkContentCodeIsUnique" ReturnVariable="isContentCodeUnique">
		<cfinvokeargument Name="contentCode" Value="#Form.contentCode#">
		<cfinvokeargument Name="contentID" Value="#URL.contentID#">
	</cfinvoke>

	<cfif isContentCodeUnique is False>
		<cfset errorMessage_fields.contentCode = Variables.lang_insertUpdateContent.contentCode_unique>
	</cfif>
</cfif>

<cfif Trim(Form.contentTypeOther) is not "">
	<cfif Len(Form.contentTypeOther) gt maxlength_Content.contentType>
		<cfset errorMessage_fields.contentTypeOther = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContent.contentTypeOther_maxlength, "<<MAXLENGTH>>", maxlength_Content.contentType, "ALL"), "<<LEN>>", Len(Form.contentTypeOther), "ALL")>
	</cfif>
<cfelseif Trim(Form.contentType) is not "" and Len(Form.contentType) gt maxlength_Content.contentType>
		<cfset errorMessage_fields.contentType = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContent.contentType_maxlength, "<<MAXLENGTH>>", maxlength_Content.contentType, "ALL"), "<<LEN>>", Len(Form.contentType), "ALL")>
</cfif>

<cfif Len(Form.contentDescription) gt maxlength_Content.contentDescription>
	<cfset errorMessage_fields.contentDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContent.contentDescription_maxlength, "<<MAXLENGTH>>", maxlength_Content.contentDescription, "ALL"), "<<LEN>>", Len(Form.contentDescription), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.contentHtmlOk)>
	<cfset errorMessage_fields.contentHtmlOk = Variables.lang_insertUpdateContent.contentHtmlOk>
</cfif>

<cfif Not ListFind("0,1", Form.contentRequired)>
	<cfset errorMessage_fields.contentRequired = Variables.lang_insertUpdateContent.contentRequired>
</cfif>

<cfif Variables.doAction is "insertContent" and Form.contentFilename is not "">
	<cfif REFindNoCase("[^A-Za-z0-9_.]", Form.contentFilename) or ListLen(Form.contentFilename, ".") is not 2
			or Not ListFindNoCase("cfm,txt,htm,html", ListLast(Form.contentFilename, "."))>
		<cfset errorMessage_fields.contentFilename = Variables.lang_insertUpdateContent.contentFilename_valid>
	<cfelseif Len(Form.contentFilename) gt maxlength_Content.contentFilename>
		<cfset errorMessage_fields.contentFilename = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContent.contentFilename_maxlength, "<<MAXLENGTH>>", maxlength_Content.contentFilename, "ALL"), "<<LEN>>", Len(Form.contentFilename), "ALL")>
	<cfelseif Not StructKeyExists(errorMessage_fields, "contentCategoryID")>
		<cfinvoke Component="#Application.billingMapping#data.Content" Method="checkContentFilenameIsUnique" ReturnVariable="isContentFilenameUnique">
			<cfinvokeargument Name="contentFilename" Value="#Form.contentFilename#">
			<cfinvokeargument Name="contentID" Value="#URL.contentID#">
		</cfinvoke>

		<cfif isContentFilenameUnique is False>
			<cfset errorMessage_fields.contentFilename = Variables.lang_insertUpdateContent.contentFilename_unique>
		</cfif>
	</cfif>
</cfif>

<cfif Form.contentMaxlength is not "" and Not Application.fn_IsIntegerPositive(Form.contentMaxlength)>
	<cfset errorMessage_fields.contentMaxlength = Variables.lang_insertUpdateContent.contentMaxlength_valid>
<cfelseif Form.contentMaxlength gt maxlength_ContentCompany.contentCompanyText>
	<cfset errorMessage_fields.contentMaxlength = ReplaceNoCase(Variables.lang_insertUpdateContent.contentMaxlength_maxlength, "<<MAXLENGTH>>", maxlength_ContentCompany.contentCompanyText, "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertContent">
		<cfset errorMessage_title = Variables.lang_insertUpdateContent.errorTitle_insert>
	<cfelse><!--- updateCompany --->
		<cfset errorMessage_title = Variables.lang_insertUpdateContent.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateContent.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateContent.errorFooter>
</cfif>
