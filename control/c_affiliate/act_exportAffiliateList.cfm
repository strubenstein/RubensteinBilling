<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="affiliates">
	<cfinvokeargument name="xmlTagSingle" value="affiliate">
	<cfinvokeargument name="fileNamePrefix" value="affiliates">
	<cfinvokeargument name="exportQueryName" value="qry_selectAffiliateList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectAffiliateList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="affiliateStatus,affiliateDateCreated,affiliateDateUpdated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="">
	</cfif>
</cfinvoke>

