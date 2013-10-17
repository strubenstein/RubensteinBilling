<cfinvoke Component="#Application.billingMapping#data.ExportTable" Method="selectExportTableList" ReturnVariable="qry_selectExportTableList">
	<cfif Variables.isSuperuserPermission is False>
		<cfinvokeargument Name="exportTableStatus" Value="1">
	</cfif>
</cfinvoke>

<!--- indicate which tables they have customized? --->
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateExportTable,listExportTableFields,moveExportTableUp,moveExportTableDown,insertExportTableField,listExportTableFieldCompany,updateExportTableFieldCompany")>

<cfset Variables.columnHeaderList = "Table Name^Table Description">
<cfif Variables.isSuperuserPermission is True>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Status">
</cfif>
<cfif ListFind(Variables.permissionActionList, "moveExportTableUp") and ListFind(Variables.permissionActionList, "moveExportTableDown")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Switch<br>Order">
</cfif>
<cfif ListFind(Variables.permissionActionList, "listExportTableFields")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Manage">
<cfelseif ListFind(Variables.permissionActionList, "listExportTableFieldCompany")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^View<br>Fields">
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

<cfinclude template="../../view/v_export/dsp_selectExportTableList.cfm">