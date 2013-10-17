<cfparam Name="URL.exportTableID" Default="0">
<cfparam Name="URL.exportQueryID" Default="0">

<cfif Session.companyID_author is Application.billingSuperuserCompanyID>
	<cfset Variables.isSuperuserPermission = True>
<cfelse>
	<cfset Variables.isSuperuserPermission = False>
</cfif>

<cfinclude template="security_export.cfm">
<cfif URL.control is "export">
	<cfinclude template="../../view/v_export/nav_export.cfm">
</cfif>
<cfif IsDefined("URL.confirm_export")>
	<cfinclude template="../../view/v_export/confirm_export.cfm">
</cfif>
<cfif IsDefined("URL.error_export")>
	<cfinclude template="../../view/v_export/error_export.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<!--- Export Tables --->
<cfcase value="listExportTables">
	<cfinclude template="control_listExportTables.cfm">
</cfcase>

<cfcase value="insertExportTable">
	<cfinclude template="control_insertExportTable.cfm">
</cfcase>

<cfcase value="updateExportTable">
	<cfinclude template="control_updateExportTable.cfm">
</cfcase>

<cfcase value="moveExportTableUp,moveExportTableDown">
	<cfinvoke Component="#Application.billingMapping#data.ExportTable" Method="switchExportTableOrder" ReturnVariable="isExportTableOrderSwitched">
		<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
		<cfinvokeargument Name="exportTableOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=export.listExportTables&confirm_export=#Variables.doAction#" AddToken="No">
</cfcase>

<!--- Export Table Fields --->
<cfcase value="listExportTableFields">
	<cfinclude template="control_listExportTableFields.cfm">
</cfcase>

<cfcase value="insertExportTableField">
	<cfinclude template="control_insertExportTableField.cfm">
</cfcase>

<cfcase value="updateExportTableField">
	<cfinclude template="control_updateExportTableField.cfm">
</cfcase>

<cfcase value="moveExportTableFieldUp,moveExportTableFieldDown">
	<cfinvoke Component="#Application.billingMapping#data.ExportTableField" Method="switchExportTableFieldOrder" ReturnVariable="isExportTableFieldOrderSwitched">
		<cfinvokeargument Name="exportTableFieldID" Value="#URL.exportTableFieldID#">
		<cfinvokeargument Name="exportTableFieldOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=export.listExportTableFields&exportTableID=#URL.exportTableID#&confirm_export=#Variables.doAction#" AddToken="No">
</cfcase>

<!--- Table Field options for Company --->
<cfcase value="listExportTableFieldCompany">
	<cfinclude template="control_listExportTableFieldCompany.cfm">
</cfcase>

<cfcase value="updateExportTableFieldCompany">
	<cfinclude template="control_updateExportTableFieldCompany.cfm">
</cfcase>

<!--- Export Queries --->
<cfcase value="listExportQueries">
	<cfinclude template="control_listExportQueries.cfm">
</cfcase>

<cfcase value="insertExportQuery">
	<cfinclude template="control_insertExportQuery.cfm">
</cfcase>

<cfcase value="updateExportQuery">
	<cfinclude template="control_updateExportQuery.cfm">
</cfcase>

<cfcase value="moveExportQueryUp,moveExportQueryDown">
	<cfinvoke Component="#Application.billingMapping#data.ExportQuery" Method="switchExportQueryOrder" ReturnVariable="isExportQueryOrderSwitched">
		<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
		<cfinvokeargument Name="exportQueryOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=export.listExportQueries&confirm_export=#Variables.doAction#" AddToken="No">
</cfcase>


<!--- Export Query Fields --->
<cfcase value="listExportQueryFields">
	<cfinclude template="control_listExportQueryFields.cfm">
</cfcase>

<cfcase value="insertExportQueryField">
	<cfinclude template="control_insertExportQueryField.cfm">
</cfcase>

<cfcase value="updateExportQueryField">
	<cfinclude template="control_updateExportQueryField.cfm">
</cfcase>

<cfcase value="deleteExportQueryField">
	<cfinclude template="control_deleteExportQueryField.cfm">
</cfcase>

<cfcase value="moveExportQueryFieldUp,moveExportQueryFieldDown">
	<cfinclude template="control_switchExportQueryFieldOrder.cfm">
</cfcase>

<!--- Query Field options for Company --->
<cfcase value="updateExportQueryFieldCompany,listExportQueryFieldCompany">
	<!--- have not enabled order yet --->
	<cfinclude template="control_updateExportQueryFieldCompany.cfm">
</cfcase>

<cfcase value="moveExportQueryFieldCompanyUp,moveExportQueryFieldCompanyDown">
	<!--- COMING SOON! --->
</cfcase>

<cfdefaultcase>
	<cfset URL.error_category = "invalidAction">
	<cfinclude template="../../view/v_export/error_export.cfm">
</cfdefaultcase>
</cfswitch>
