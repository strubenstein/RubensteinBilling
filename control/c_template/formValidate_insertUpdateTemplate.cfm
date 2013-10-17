<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind(Variables.var_templateTypeList_value, Form.templateType)>
	<cfset errorMessage_fields.templateType = Variables.lang_insertUpdateTemplate.templateType>
</cfif>

<cfif Not ListFind("0,1", Form.templateStatus)>
	<cfset errorMessage_fields.templateStatus = Variables.lang_insertUpdateTemplate.templateStatus>
</cfif>

<cfif Trim(Form.templateName) is "">
	<cfset errorMessage_fields.templateName = Variables.lang_insertUpdateTemplate.templateName_blank>
<cfelseif Len(Form.templateFilename) gt maxlength_Template.templateName>
	<cfset errorMessage_fields.templateName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateTemplate.templateName_maxlength, "<<MAXLENGTH>>", maxlength_Template.templateName, "ALL"), "<<LEN>>", Len(Form.templateName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Template" Method="checkTemplateNameIsUnique" ReturnVariable="isTemplateNameUnique">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="templateName" Value="#Form.templateName#">
		<cfinvokeargument Name="templateType" Value="#Form.templateType#">
		<cfif URL.templateID is not 0>
			<cfinvokeargument Name="templateID" Value="#URL.templateID#">
		</cfif>
	</cfinvoke>

	<cfif isTemplateNameUnique is False>
		<cfset errorMessage_fields.templateName = Variables.lang_insertUpdateTemplate.templateName_unique>
	</cfif>
</cfif>

<cfif Trim(Form.templateFilename) is "" or Form.templateFilename is ".cfm">
	<cfset errorMessage_fields.templateFilename = Variables.lang_insertUpdateTemplate.templateFilename_blank>
<cfelseif Right(Form.templateFilename, 4) is not ".cfm">
	<cfset errorMessage_fields.templateFilename = Variables.lang_insertUpdateTemplate.templateFilename_cfm>
<cfelseif Len(Form.templateFilename) gt maxlength_Template.templateFilename>
	<cfset errorMessage_fields.templateFilename = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateTemplate.templateFilename_maxlength, "<<MAXLENGTH>>", maxlength_Template.templateFilename, "ALL"), "<<LEN>>", Len(Form.templateFilename), "ALL")>
<cfelseif REFindNoCase("[^A-Za-z0-9_]", ListFirst(Form.templateFilename, ".")) or ListLen(Form.templateFilename, ".") gt 2>
	<cfset errorMessage_fields.templateFilename = Variables.lang_insertUpdateTemplate.templateFilename_valid>
<cfelseif Not FileExists(Application.billingTemplateDirectoryPath & Application.billingFilePathSlash & Form.templateFilename)>
	<cfset errorMessage_fields.templateFilename = Variables.lang_insertUpdateTemplate.templateFilename_fileExists>
<cfelseif Variables.doAction is not "copyTemplate">
	<cfinvoke Component="#Application.billingMapping#data.Template" Method="checkTemplateFilenameIsUnique" ReturnVariable="isTemplateNameUnique">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="templateFilename" Value="#Form.templateFilename#">
		<cfif URL.templateID is not 0>
			<cfinvokeargument Name="templateID" Value="#URL.templateID#">
		</cfif>
	</cfinvoke>

	<cfif isTemplateNameUnique is False>
		<cfset errorMessage_fields.templateFilename = Variables.lang_insertUpdateTemplate.templateFilename_unique>
	</cfif>
</cfif>

<cfif Len(Form.templateDescription) gt maxlength_Template.templateDescription>
	<cfset errorMessage_fields.templateDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateTemplate.templateDescription, "<<MAXLENGTH>>", maxlength_Template.templateDescription, "ALL"), "<<LEN>>", Len(Form.templateDescription), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertTemplate">
		<cfset errorMessage_title = Variables.lang_insertUpdateTemplate.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateTemplate.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateTemplate.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateTemplate.errorFooter>
</cfif>

