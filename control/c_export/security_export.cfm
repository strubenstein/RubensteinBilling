<cfif Not Application.fn_IsIntegerNonNegative(URL.exportTableID)>
	<cfset URL.error_export = "invalidExportTable">
	<cfset Variables.doAction = "listExportTables">
<cfelseif URL.exportTableID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ExportTable" Method="selectExportTable" ReturnVariable="qry_selectExportTable">
		<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
	</cfinvoke>

	<cfif qry_selectExportTable.RecordCount is 0 or (qry_selectExportTable.exportTableStatus is 0 and Session.companyID_author is not Application.billingSuperuserCompanyID)>
		<cfset URL.error_export = "invalidExportTable">
		<cfset Variables.doAction = "listExportTables">
	</cfif>
<cfelseif ListFind("updateExportTable,listExportTableFields,insertExportTableField,updateExportTableField,updateExportTableFieldCompany,moveExportTableUp,moveExportTableDown,moveExportTableFieldUp,moveExportTableFieldDown", Variables.doAction)>
	<cfset URL.error_export = "noExportTable">
	<cfset Variables.doAction = "listExportTables">
</cfif>

<cfif Not Application.fn_IsIntegerNonNegative(URL.exportQueryID)>
	<cfset URL.error_export = "invalidExportQuery">
	<cfset Variables.doAction = "listExportQueries">
<cfelseif URL.exportQueryID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ExportQuery" Method="selectExportQuery" ReturnVariable="qry_selectExportQuery">
		<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
	</cfinvoke>

	<cfif qry_selectExportQuery.RecordCount is 0 or (qry_selectExportQuery.exportQueryStatus is 0 and Session.companyID_author is not Application.billingSuperuserCompanyID)>
		<cfset URL.error_export = "invalidExportQuery">
		<cfset Variables.doAction = "listExportQueries">
	</cfif>
<cfelseif ListFind("updateExportQuery,listExportQueryFields,insertExportQueryField,deleteExpertQueryField,updateExportQueryField,moveExportQueryFieldUp,moveExportQueryFieldDown,listExportQueryFieldCompany,updateExportQueryFieldCompany,moveExportQueryFieldCompanyUp,moveExportQueryFieldCompanyDown", Variables.doAction)>
	<cfset URL.error_export = "noExportQuery">
	<cfset Variables.doAction = "listExportQueries">
</cfif>

