<cfinvoke Component="#Application.billingMapping#data.ExportQueryField" Method="selectExportQueryFieldList" ReturnVariable="qry_selectExportQueryFieldList">
	<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
</cfinvoke>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("deleteExportQueryField,moveExportQueryFieldUp,moveExportQueryFieldDown,updateExportQueryField")>

<cfset Variables.columnHeaderList = "##^Table Name^Table<br>Field Name^&quot;Select As&quot;<br>Field Name^Type">
<cfif ListFind(Variables.permissionActionList, "moveExportQueryFieldUp") and ListFind(Variables.permissionActionList, "moveExportQueryFieldDown")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Switch<br>Order">
</cfif>
<cfif ListFind(Variables.permissionActionList, "deleteExportQueryField")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Remove">
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

<cfif ListFind(Variables.permissionActionList, "updateExportQueryField")>
	<cfset Variables.formAction = "index.cfm?method=export.updateExportQueryField&exportQueryID=#URL.exportQueryID#">
	<cfset Variables.formSubmitValue = "Update Select As">
	<cfinvoke component="#Application.billingMapping#data.ExportQueryField" method="maxlength_ExportQueryField" returnVariable="maxlength_ExportQueryField" />
</cfif>

<cfinclude template="../../view/v_export/dsp_selectExportQueryFieldList.cfm">
