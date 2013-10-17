<cfset errorMessage_fields = StructNew()>

<cfif Variables.doAction is "insertExportTableField">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.exportTableFieldOrder) or Form.exportTableFieldOrder gt qry_selectExportTableFieldList.RecordCount>
		<cfset errorMessage_fields.exportTableFieldOrder = Variables.lang_insertUpdateExportTableField.exportTableFieldOrder>
	</cfif>
</cfif>

<cfloop Index="field" List="exportTableFieldStatus,exportTableFieldPrimaryKey,exportTableFieldXmlStatus,exportTableFieldTabStatus,exportTableFieldHtmlStatus">
	<cfif Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_insertUpdateExportTableField[field]>
	</cfif>
</cfloop>

<cfif Not ListFind(Variables.exportTableFieldTypeList, Form.exportTableFieldType)>
	<cfset errorMessage_fields.exportTableFieldType = Variables.lang_insertUpdateExportTableField.exportTableFieldType>
</cfif>

<cfif Form.exportTableFieldSize is not "" and Not Application.fn_IsIntegerNonNegative(Form.exportTableFieldSize)>
	<cfset errorMessage_fields.exportTableFieldSize = Variables.lang_insertUpdateExportTableField.exportTableFieldSize>
</cfif>

<cfif Trim(Form.exportTableFieldName) is "">
	<cfset errorMessage_fields.exportTableFieldName = Variables.lang_insertUpdateExportTableField.exportTableFieldName_blank>
<cfelseif Len(Form.exportTableFieldName) gt maxlength_ExportTableField.exportTableFieldName>
	<cfset errorMessage_fields.exportTableFieldName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateExportTableField.exportTableFieldName_maxlength, "<<MAXLENGTH>>", maxlength_ExportTableField.exportTableFieldName, "ALL"), "<<LEN>>", Len(Form.exportTableFieldName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.ExportTableField" Method="checkExportTableFieldNameIsUnique" ReturnVariable="isExportTableFieldNameUnique">
		<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
		<cfinvokeargument Name="exportTableFieldName" Value="#Form.exportTableFieldName#">
		<cfif Variables.doAction is "updateExportTableField">
			<cfinvokeargument Name="exportTableFieldID" Value="#URL.exportTableFieldID#">
		</cfif>
	</cfinvoke>

	<cfif isExportTableFieldNameUnique is False>
		<cfset errorMessage_fields.exportTableFieldName = Variables.lang_insertUpdateExportTableField.exportTableFieldName_unique>
	</cfif>
</cfif>

<cfloop Index="field" List="exportTableFieldDescription,exportTableFieldXmlName,exportTableFieldTabName,exportTableFieldHtmlName">
	<cfif Len(Form[field]) gt maxlength_ExportTableField[field]>
		<cfset errorMessage_fields[field] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateExportTableField["#field#_maxlength"], "<<MAXLENGTH>>", maxlength_ExportTableField[field], "ALL"), "<<LEN>>", Len(Form[field]), "ALL")>
	</cfif>
</cfloop>

<cfif Form.exportTableFieldXmlStatus is 1 and Trim(Form.exportTableFieldXmlName) is "">
	<cfset errorMessage_fields.exportTableFieldXmlName = Variables.lang_insertUpdateExportTableField.exportTableFieldXmlName_blank>
</cfif>
<cfif Form.exportTableFieldTabStatus is 1 and Trim(Form.exportTableFieldTabName) is "">
	<cfset errorMessage_fields.exportTableFieldTabName = Variables.lang_insertUpdateExportTableField.exportTableFieldTabName_blank>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertExportTable">
		<cfset errorMessage_title = Variables.lang_insertUpdateExportTableField.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateExportTableField.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateExportTableField.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateExportTableField.errorFooter>
</cfif>

