<cfinvoke Component="#Application.billingMapping#data.ExportQuery" Method="selectExportQueryList" ReturnVariable="qry_selectExportQueryList" />

<cfinclude template="formParam_insertUpdateExportQuery.cfm">
<cfinvoke component="#Application.billingMapping#data.ExportQuery" method="maxlength_ExportQuery" returnVariable="maxlength_ExportQuery" />

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitExportQuery")>
	<cfinclude template="../../view/v_export/lang_insertUpdateExportQuery.cfm">
	<cfinclude template="formValidate_insertUpdateExportQuery.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- determine order --->
		<cfif Form.exportQueryOrder is 0>
			<cfset Form.exportQueryOrder = qry_selectExportQueryList.RecordCount + 1>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ExportQuery" Method="insertExportQuery" ReturnVariable="newExportQueryID">
			<cfinvokeargument Name="exportQueryName" Value="#Form.exportQueryName#">
			<cfinvokeargument Name="exportQueryTitle" Value="#Form.exportQueryTitle#">
			<cfinvokeargument Name="exportQueryDescription" Value="#Form.exportQueryDescription#">
			<cfinvokeargument Name="exportQueryOrder" Value="#Form.exportQueryOrder#">
			<cfinvokeargument Name="exportQueryStatus" Value="#Form.exportQueryStatus#">
		</cfinvoke>

		<cfif Application.fn_IsUserAuthorized("insertExportQueryField") and Form.exportQueryStatus is 0>
			<cflocation url="index.cfm?method=export.insertExportQueryField&exportQueryID=#newExportQueryID#&confirm_export=#Variables.doAction#" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=export.listExportQueries&confirm_export=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=export.#Variables.doAction#">
<cfset Variables.formSubmitValue = "Add Export Query">

<cfinclude template="../../view/v_export/form_insertUpdateExportQuery.cfm">
