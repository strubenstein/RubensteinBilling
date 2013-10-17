<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="cobrands">
	<cfinvokeargument name="xmlTagSingle" value="cobrand">
	<cfinvokeargument name="fileNamePrefix" value="cobrands">
	<cfinvokeargument name="exportQueryName" value="qry_selectCobrandList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectCobrandList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="cobrandStatus,cobrandDateCreated,cobrandDateUpdated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="">
	</cfif>
</cfinvoke>

