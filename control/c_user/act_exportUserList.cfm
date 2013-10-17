<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="users">
	<cfinvokeargument name="xmlTagSingle" value="user">
	<cfinvokeargument name="fileNamePrefix" value="users">
	<cfinvokeargument name="exportQueryName" value="qry_selectUserList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectUserList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="userStatus,userNewsletterStatus,userNewsletterHtml,userDateCreated,userDateUpdated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="">
	</cfif>
</cfinvoke>

