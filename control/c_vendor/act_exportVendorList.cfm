<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="vendors">
	<cfinvokeargument name="xmlTagSingle" value="vendor">
	<cfinvokeargument name="fileNamePrefix" value="vendors">
	<cfinvokeargument name="exportQueryName" value="qry_selectVendorList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectVendorList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="vendorStatus,vendorDateCreated,vendorDateUpdated,vendorDescriptionDisplay,vendorURLdisplay,vendorDescriptionHtml">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="">
	</cfif>
</cfinvoke>

