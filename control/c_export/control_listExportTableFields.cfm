<cfinvoke Component="#Application.billingMapping#data.ExportTableField" Method="selectExportTableFieldList" ReturnVariable="qry_selectExportTableFieldList">
	<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
</cfinvoke>

<!--- indicate which tables they have customized? --->
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateExportTableField,moveExportTableFieldUp,moveExportTableFieldDown,insertExportTableField,listExportTableFieldCompany,updateExportTableFieldCompany")>

<cfset Variables.columnHeaderList = "Field Name^Primary<br>Key?^Type^Size^XML File<br>Field Name^Tab-Delimited<br>Header"><!--- ^HTML Header --->
<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Status">
<cfif ListFind(Variables.permissionActionList, "moveExportTableFieldUp") and ListFind(Variables.permissionActionList, "moveExportTableFieldDown")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Switch<br>Order">
</cfif>
<cfif ListFind(Variables.permissionActionList, "updateExportTableField")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Update">
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">

<cfinclude template="../../view/v_export/dsp_selectExportTableFieldList.cfm">