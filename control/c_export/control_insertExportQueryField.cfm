<cfinvoke Component="#Application.billingMapping#data.ExportTable" Method="selectExportTableList" ReturnVariable="qry_selectExportTableList" />

<cfif URL.exportTableID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ExportTableField" Method="selectExportTableFieldList" ReturnVariable="qry_selectExportTableFieldList">
		<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
	</cfinvoke>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.ExportQueryField" Method="selectExportQueryFieldList" ReturnVariable="qry_selectExportQueryFieldList">
	<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitExportQueryField")>
	<cfinclude template="../../view/v_export/lang_insertExportQueryField.cfm">
	<cfinclude template="formValidate_insertExportQueryField.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfloop Index="count" From="1" To="#ListLen(Form.exportTableFieldID_in)#">
			<cfset Variables.exportQueryFieldOrder = qry_selectExportQueryFieldList.RecordCount + count>

			<cfinvoke Component="#Application.billingMapping#data.ExportQueryField" Method="insertExportQueryField" ReturnVariable="isExportQueryFieldInserted">
				<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
				<cfinvokeargument Name="exportTableFieldID" Value="#ListGetAt(Form.exportTableFieldID_in, count)#">
				<cfinvokeargument Name="exportQueryFieldOrder" Value="#Variables.exportQueryFieldOrder#">
				<cfinvokeargument Name="exportQueryFieldAs" Value="">
			</cfinvoke>
		</cfloop>

		<cflocation url="index.cfm?method=export.#Variables.doAction#&exportQueryID=#URL.exportQueryID#&exportTableID=#URL.exportTableID#&confirm_export=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=export.#Variables.doAction#&exportQueryID=#URL.exportQueryID#">
<cfset Variables.formName = "exportQueryField">
<cfset Variables.formSubmitValue = "Add Field(s) to Export Query">

<cfinclude template="../../view/v_export/form_insertExportQueryField.cfm">
