<cfset errorMessage_fields = StructNew()>

<cfif Variables.doAction is "insertContentCategory">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.contentCategoryOrder)>
		<cfset errorMessage_fields.contentCategoryOrder = Variables.lang_insertUpdateContentCategory.contentCategoryOrder_valid>
	<cfelseif qry_selectContentCategoryList.RecordCount is not 0 and Form.contentCategoryOrder gt qry_selectContentCategoryList.contentCategoryOrder[qry_selectContentCategoryList.RecordCount]>
		<cfset errorMessage_fields.contentCategoryOrder = Variables.lang_insertUpdateContentCategory.contentCategoryOrder_range>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.contentCategoryStatus)>
	<cfset errorMessage_fields.contentCategoryStatus = Variables.lang_insertUpdateContentCategory.contentCategoryStatus>
</cfif>

<cfif Trim(Form.contentCategoryName) is "">
	<cfset errorMessage_fields.contentCategoryName = Variables.lang_insertUpdateContentCategory.contentCategoryName_blank>
<cfelseif Len(Form.contentCategoryName) gt maxlength_ContentCategory.contentCategoryName>
	<cfset errorMessage_fields.contentCategoryName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContentCategory.contentCategoryName_maxlength, "<<MAXLENGTH>>", maxlength_ContentCategory.contentCategoryName, "ALL"), "<<LEN>>", Len(Form.contentCategoryName), "ALL")>
<cfelse>
	<!--- validate category name is unique; use inline query --->
	<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="checkContentCategoryNameIsUnique" ReturnVariable="isContentCategoryNameUnique">
		<cfinvokeargument Name="contentCategoryName" Value="#Form.contentCategoryName#">
		<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
	</cfinvoke>

	<cfif isContentCategoryNameUnique is False>
		<cfset errorMessage_fields.contentCategoryName = Variables.lang_insertUpdateContentCategory.contentCategoryName_unique>
	</cfif>
</cfif>

<cfif Trim(Form.contentCategoryCode) is "">
	<cfset errorMessage_fields.contentCategoryCode = Variables.lang_insertUpdateContentCategory.contentCategoryCode_blank>
<cfelseif Len(Form.contentCategoryCode) gt maxlength_ContentCategory.contentCategoryCode>
	<cfset errorMessage_fields.contentCategoryCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContentCategory.contentCategoryCode_maxlength, "<<MAXLENGTH>>", maxlength_ContentCategory.contentCategoryCode, "ALL"), "<<LEN>>", Len(Form.contentCategoryCode), "ALL")>
<cfelse>
	<!--- validate category code is unique; use inline query --->
	<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="checkContentCategoryCodeIsUnique" ReturnVariable="isContentCategoryCodeUnique">
		<cfinvokeargument Name="contentCategoryCode" Value="#Form.contentCategoryCode#">
		<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
	</cfinvoke>

	<cfif isContentCategoryCodeUnique is False>
		<cfset errorMessage_fields.contentCategoryCode = Variables.lang_insertUpdateContentCategory.contentCategoryCode_unique>
	</cfif>
</cfif>

<cfif Len(Form.contentCategoryDescription) gt maxlength_ContentCategory.contentCategoryDescription>
	<cfset errorMessage_fields.contentCategoryDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContentCategory.contentCategoryDescription_maxlength, "<<MAXLENGTH>>", maxlength_ContentCategory.contentCategoryDescription, "ALL"), "<<LEN>>", Len(Form.contentCategoryDescription), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertContentCategory">
		<cfset errorMessage_title = Variables.lang_insertUpdateContentCategory.errorTitle_insert>
	<cfelse><!--- updateCompany --->
		<cfset errorMessage_title = Variables.lang_insertUpdateContentCategory.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateContentCategory.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateContentCategory.errorFooter>
</cfif>
