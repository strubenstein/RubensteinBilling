<cfinvoke Component="#Application.billingMapping#data.ExportTable" Method="selectExportTableList" ReturnVariable="qry_selectExportTableList">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="selectPrimaryTarget" ReturnVariable="qry_selectPrimaryTarget">
	<cfinvokeargument Name="primaryTargetID" Value="#qry_selectExportTable.primaryTargetID#">
</cfinvoke>

<cfinclude template="formParam_insertUpdateExportTable.cfm">
<cfinvoke component="#Application.billingMapping#data.ExportTable" method="maxlength_ExportTable" returnVariable="maxlength_ExportTable" />

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitExportTable")>
	<cfinclude template="../../view/v_export/lang_insertUpdateExportTable.cfm">
	<cfinclude template="formValidate_insertUpdateExportTable.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.ExportTable" Method="updateExportTable" ReturnVariable="isExportTableUpdated">
			<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
			<cfinvokeargument Name="exportTableName" Value="#Form.exportTableName#">
			<cfinvokeargument Name="exportTableDescription" Value="#Form.exportTableDescription#">
			<cfinvokeargument Name="exportTableStatus" Value="#Form.exportTableStatus#">
		</cfinvoke>

		<cflocation url="index.cfm?method=export.#Variables.doAction#&exportTableID=#URL.exportTableID#&confirm_export=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=export.#Variables.doAction#&exportTableID=#URL.exportTableID#">
<cfset Variables.formSubmitValue = "Update Export Table">

<cfinclude template="../../view/v_export/form_insertUpdateExportTable.cfm">

