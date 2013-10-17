<cfinvoke Component="#Application.billingMapping#data.ExportQueryField" Method="selectExportQueryFieldList" ReturnVariable="qry_selectExportQueryFieldList">
	<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
</cfinvoke>

<cfif Not IsDefined("URL.exportQueryFieldID") or Not ListFind(ValueList(qry_selectExportQueryFieldList.exportQueryFieldID), URL.exportQueryFieldID)>
	<cflocation url="index.cfm?method=export.listExportQueryFields&exportQueryID=#URL.exportQueryID#&error_export=#Variables.doAction#" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.ExportQueryField" Method="switchExportQueryFieldOrder" ReturnVariable="isExportQueryFieldOrderSwitched">
	<cfinvokeargument Name="exportQueryFieldID" Value="#URL.exportQueryFieldID#">
	<cfinvokeargument Name="exportQueryFieldOrder_direction" Value="#Variables.doAction#">
</cfinvoke>

<cflocation url="index.cfm?method=export.listExportQueryFields&exportQueryID=#URL.exportQueryID#&confirm_export=#Variables.doAction#" AddToken="No">
