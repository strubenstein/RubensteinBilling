<cfinclude template="formParam_insertUpdateExportQuery.cfm">
<cfinvoke component="#Application.billingMapping#data.ExportQuery" method="maxlength_ExportQuery" returnVariable="maxlength_ExportQuery" />

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitExportQuery")>
	<cfinclude template="../../view/v_export/lang_insertUpdateExportQuery.cfm">
	<cfinclude template="formValidate_insertUpdateExportQuery.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.ExportQuery" Method="updateExportQuery" ReturnVariable="isExportQueryUpdated">
			<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
			<cfinvokeargument Name="exportQueryName" Value="#Form.exportQueryName#">
			<cfinvokeargument Name="exportQueryTitle" Value="#Form.exportQueryTitle#">
			<cfinvokeargument Name="exportQueryDescription" Value="#Form.exportQueryDescription#">
			<cfinvokeargument Name="exportQueryStatus" Value="#Form.exportQueryStatus#">
		</cfinvoke>

		<cflocation url="index.cfm?method=export.#Variables.doAction#&exportQueryID=#URL.exportQueryID#&confirm_export=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=export.#Variables.doAction#&exportQueryID=#URL.exportQueryID#">
<cfset Variables.formSubmitValue = "Update Export Query">

<cfinclude template="../../view/v_export/form_insertUpdateExportQuery.cfm">
