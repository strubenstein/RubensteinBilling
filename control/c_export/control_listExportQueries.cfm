<cfinvoke Component="#Application.billingMapping#data.ExportQuery" Method="selectExportQueryList" ReturnVariable="qry_selectExportQueryList">
	<cfif Variables.isSuperuserPermission is False>
		<cfinvokeargument Name="exportQueryStatus" Value="1">
	</cfif>
</cfinvoke>

<!--- indicate which tables they have customized? --->
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateExportQuery,listExportQueryFields,moveExportQueryUp,moveExportQueryDown,insertExportQueryField,listExportQueryFieldCompany,updateExportQueryFieldCompany")>

<cfset Variables.columnHeaderList = "">
<cfif Variables.isSuperuserPermission is True>
	<cfset Variables.columnHeaderList = "Query Name^">
</cfif>
<cfset Variables.columnHeaderList = Variables.columnHeaderList & "Query Title^Query Description">
<cfif Variables.isSuperuserPermission is True>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Status">
</cfif>
<cfif ListFind(Variables.permissionActionList, "moveExportQueryUp") and ListFind(Variables.permissionActionList, "moveExportQueryDown")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Switch<br>Order">
</cfif>
<cfif ListFind(Variables.permissionActionList, "listExportQueryFields")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Manage">
<cfelseif ListFind(Variables.permissionActionList, "listExportQueryFieldCompany")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^View<br>Fields">
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

<cfinclude template="../../view/v_export/dsp_selectExportQueryList.cfm">