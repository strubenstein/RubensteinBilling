<cfset errorMessage_fields = StructNew()>

<cfif Variables.doAction is "insertExportQuery">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.exportQueryOrder) or Form.exportQueryOrder gt qry_selectExportQueryList.RecordCount>
		<cfset errorMessage_fields.exportQueryOrder = Variables.lang_insertUpdateExportQuery.exportQueryOrder>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.exportQueryStatus)>
	<cfset errorMessage_fields.exportQueryStatus = Variables.lang_insertUpdateExportQuery.exportQueryStatus>
</cfif>

<cfif Trim(Form.exportQueryName) is "">
	<cfset errorMessage_fields.exportQueryName = Variables.lang_insertUpdateExportQuery.exportQueryName_blank>
<cfelseif Len(Form.exportQueryName) gt maxlength_ExportQuery.exportQueryName>
	<cfset errorMessage_fields.exportQueryName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateExportQuery.exportQueryName_maxlength, "<<MAXLENGTH>>", maxlength_ExportQuery.exportQueryName, "ALL"), "<<LEN>>", Len(Form.exportQueryName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.ExportQuery" Method="checkExportQueryNameIsUnique" ReturnVariable="isExportQueryNameUnique">
		<cfinvokeargument Name="exportQueryName" Value="#Form.exportQueryName#">
		<cfif Variables.doAction is "updateExportQuery">
			<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
		</cfif>
	</cfinvoke>

	<cfif isExportQueryNameUnique is False>
		<cfset errorMessage_fields.exportQueryName = Variables.lang_insertUpdateExportQuery.exportQueryName_unique>
	</cfif>
</cfif>

<cfif Trim(Form.exportQueryTitle) is "">
	<cfset errorMessage_fields.exportQueryTitle = Variables.lang_insertUpdateExportQuery.exportQueryTitle_blank>
<cfelseif Len(Form.exportQueryTitle) gt maxlength_ExportQuery.exportQueryTitle>
	<cfset errorMessage_fields.exportQueryTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateExportQuery.exportQueryTitle_maxlength, "<<MAXLENGTH>>", maxlength_ExportQuery.exportQueryTitle, "ALL"), "<<LEN>>", Len(Form.exportQueryTitle), "ALL")>
</cfif>

<cfif Len(Form.exportQueryDescription) gt maxlength_ExportQuery.exportQueryDescription>
	<cfset errorMessage_fields.exportQueryDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateExportQuery.exportQueryDescription_maxlength, "<<MAXLENGTH>>", maxlength_ExportQuery.exportQueryDescription, "ALL"), "<<LEN>>", Len(Form.exportQueryDescription), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertExportQuery">
		<cfset errorMessage_title = Variables.lang_insertUpdateExportQuery.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateExportQuery.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateExportQuery.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateExportQuery.errorFooter>
</cfif>

