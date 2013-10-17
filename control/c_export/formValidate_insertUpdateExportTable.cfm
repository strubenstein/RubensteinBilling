<cfset errorMessage_fields = StructNew()>

<cfif Variables.doAction is "insertExportTable">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.exportTableOrder) or Form.exportTableOrder gt qry_selectExportTableList.RecordCount>
		<cfset errorMessage_fields.exportTableOrder = Variables.lang_insertUpdateExportTable.exportTableOrder>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertExportTable">
	<cfif Not ListFind(ValueList(qry_selectPrimaryTargetList.primaryTargetID), Form.primaryTargetID)>
		<cfset errorMessage_fields.primaryTargetID = Variables.lang_insertUpdateExportTable.primaryTargetID_exist>
	<cfelseif ListFind(ValueList(qry_selectExportTableList.primaryTargetID), Form.primaryTargetID)>
		<cfset errorMessage_fields.primaryTargetID = Variables.lang_insertUpdateExportTable.primaryTargetID_unique>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.exportTableStatus)>
	<cfset errorMessage_fields.exportTableStatus = Variables.lang_insertUpdateExportTable.exportTableStatus>
</cfif>

<cfif Trim(Form.exportTableName) is "">
	<cfset errorMessage_fields.exportTableName = Variables.lang_insertUpdateExportTable.exportTableName_blank>
<cfelseif Len(Form.exportTableName) gt maxlength_ExportTable.exportTableName>
	<cfset errorMessage_fields.exportTableName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateExportTable.exportTableName_maxlength, "<<MAXLENGTH>>", maxlength_ExportTable.exportTableName, "ALL"), "<<LEN>>", Len(Form.exportTableName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.ExportTable" Method="checkExportTableNameIsUnique" ReturnVariable="isExportTableNameUnique">
		<cfinvokeargument Name="exportTableName" Value="#Form.exportTableName#">
		<cfif Variables.doAction is "updateExportTable">
			<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
		</cfif>
	</cfinvoke>

	<cfif isExportTableNameUnique is False>
		<cfset errorMessage_fields.exportTableName = Variables.lang_insertUpdateExportTable.exportTableName_unique>
	</cfif>
</cfif>

<cfif Len(Form.exportTableDescription) gt maxlength_ExportTable.exportTableDescription>
	<cfset errorMessage_fields.exportTableDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateExportTable.exportTableDescription_maxlength, "<<MAXLENGTH>>", maxlength_ExportTable.exportTableDescription, "ALL"), "<<LEN>>", Len(Form.exportTableDescription), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertExportTable">
		<cfset errorMessage_title = Variables.lang_insertUpdateExportTable.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateExportTable.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateExportTable.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateExportTable.errorFooter>
</cfif>

