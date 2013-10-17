<cfinvoke Component="#Application.billingMapping#data.ExportTableField" Method="selectExportTableFieldList" ReturnVariable="qry_selectExportTableFieldList">
	<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
</cfinvoke>

<cfinclude template="../../view/v_export/var_exportTableFieldTypeList.cfm">
<cfinclude template="formParam_insertUpdateExportTableField.cfm">
<cfinvoke component="#Application.billingMapping#data.ExportTableField" method="maxlength_ExportTableField" returnVariable="maxlength_ExportTableField" />

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitExportTableField")>
	<cfinclude template="../../view/v_export/lang_insertUpdateExportTableField.cfm">
	<cfinclude template="formValidate_insertUpdateExportTableField.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- determine order --->
		<cfif Form.exportTableFieldOrder is 0>
			<cfset Form.exportTableFieldOrder = qry_selectExportTableFieldList.RecordCount + 1>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ExportTableField" Method="insertExportTableField" ReturnVariable="newExportTableFieldID">
			<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
			<cfinvokeargument Name="exportTableFieldName" Value="#Form.exportTableFieldName#">
			<cfinvokeargument Name="exportTableFieldType" Value="#Form.exportTableFieldType#">
			<cfinvokeargument Name="exportTableFieldPrimaryKey" Value="#Form.exportTableFieldPrimaryKey#">
			<cfif Not IsNumeric(Form.exportTableFieldSize)>
				<cfinvokeargument Name="exportTableFieldSize" Value="0">
			<cfelse>
				<cfinvokeargument Name="exportTableFieldSize" Value="#Form.exportTableFieldSize#">
			</cfif>
			<cfinvokeargument Name="exportTableFieldDescription" Value="#Form.exportTableFieldDescription#">
			<cfinvokeargument Name="exportTableFieldOrder" Value="#Form.exportTableFieldOrder#">
			<cfinvokeargument Name="exportTableFieldXmlName" Value="#Form.exportTableFieldXmlName#">
			<cfinvokeargument Name="exportTableFieldXmlStatus" Value="#Form.exportTableFieldXmlStatus#">
			<cfinvokeargument Name="exportTableFieldTabName" Value="#Form.exportTableFieldTabName#">
			<cfinvokeargument Name="exportTableFieldTabStatus" Value="#Form.exportTableFieldTabStatus#">
			<cfinvokeargument Name="exportTableFieldHtmlName" Value="#Form.exportTableFieldHtmlName#">
			<cfinvokeargument Name="exportTableFieldHtmlStatus" Value="#Form.exportTableFieldHtmlStatus#">
			<cfinvokeargument Name="exportTableFieldStatus" Value="#Form.exportTableFieldStatus#">
		</cfinvoke>

		<cflocation url="index.cfm?method=export.listExportTableFields&exportTableID=#URL.exportTableID#&confirm_export=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=export.#Variables.doAction#&exportTableID=#URL.exportTableID#">
<cfset Variables.formSubmitValue = "Add Field to Export Table">

<cfinclude template="../../view/v_export/form_insertUpdateExportTableField.cfm">

