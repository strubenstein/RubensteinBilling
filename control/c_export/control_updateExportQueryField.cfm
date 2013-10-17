<cfset Variables.redirectURL = "index.cfm?method=export.listExportQueryFields&exportQueryID=#URL.exportQueryID#">

<cfif Not IsDefined("Form.isFormSubmitted") or Not IsDefined("Form.submitExportQueryField")>
	<cflocation url="#Variables.redirectURL#&error_export=#Variables.doAction#" AddToken="No">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.ExportQueryField" Method="selectExportQueryFieldList" ReturnVariable="qry_selectExportQueryFieldList">
		<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
	</cfinvoke>

	<cfset Variables.allExportQueryFieldAsOk = True>
	<cfloop Query="qry_selectExportQueryFieldList">
		<cfif IsDefined("Form.exportQueryFieldAs#qry_selectExportQueryFieldList.exportQueryFieldID#")
				and (Form["exportQueryFieldAs#qry_selectExportQueryFieldList.exportQueryFieldID#"] is not ""
					or qry_selectExportQueryFieldList.exportQueryFieldAs is not "")>
			<cfif REFindNoCase("[^A-Za-z0-9_]", Form["exportQueryFieldAs#qry_selectExportQueryFieldList.exportQueryFieldID#"])>
				<cfset Variables.allExportQueryFieldAsOk = False>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.ExportQueryField" Method="updateExportQueryField" ReturnVariable="isExportQueryFieldUpdated">
					<cfinvokeargument Name="exportQueryFieldID" Value="#qry_selectExportQueryFieldList.exportQueryFieldID#">
					<cfinvokeargument Name="exportQueryFieldAs" Value="#Form["exportQueryFieldAs#qry_selectExportQueryFieldList.exportQueryFieldID#"]#">
				</cfinvoke>
			</cfif>
		</cfif>
	</cfloop>

	<cfif Variables.allExportQueryFieldAsOk is True>
		<cflocation url="#Variables.redirectURL#&confirm_export=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cflocation url="#Variables.redirectURL#&confirm_export=#Variables.doAction#_bad" AddToken="No">
	</cfif>
</cfif>

