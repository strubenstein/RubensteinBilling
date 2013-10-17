<cfinvoke Component="#Application.billingMapping#data.ExportTable" Method="selectExportTableList" ReturnVariable="qry_selectExportTableList" />

<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="selectPrimaryTargetList" ReturnVariable="qry_selectPrimaryTargetList" />

<cfinclude template="formParam_insertUpdateExportTable.cfm">
<cfinvoke component="#Application.billingMapping#data.ExportTable" method="maxlength_ExportTable" returnVariable="maxlength_ExportTable" />

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitExportTable")>
	<cfinclude template="../../view/v_export/lang_insertUpdateExportTable.cfm">
	<cfinclude template="formValidate_insertUpdateExportTable.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- determine order --->
		<cfif Form.exportTableOrder is 0>
			<cfset Form.exportTableOrder = qry_selectExportTableList.RecordCount + 1>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ExportTable" Method="insertExportTable" ReturnVariable="newExportTableID">
			<cfinvokeargument Name="exportTableName" Value="#Form.exportTableName#">
			<cfinvokeargument Name="primaryTargetID" Value="#Form.primaryTargetID#">
			<cfinvokeargument Name="exportTableDescription" Value="#Form.exportTableDescription#">
			<cfinvokeargument Name="exportTableOrder" Value="#Form.exportTableOrder#">
			<cfinvokeargument Name="exportTableStatus" Value="#Form.exportTableStatus#">
		</cfinvoke>

		<cflocation url="index.cfm?method=export.listExportTables&confirm_export=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=export.#Variables.doAction#">
<cfset Variables.formSubmitValue = "Add Export Table">

<cfinclude template="../../view/v_export/form_insertUpdateExportTable.cfm">

