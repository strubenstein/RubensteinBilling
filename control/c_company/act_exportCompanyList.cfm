<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="companies">
	<cfinvokeargument name="xmlTagSingle" value="company">
	<cfinvokeargument name="fileNamePrefix" value="companies">
	<cfinvokeargument name="exportQueryName" value="qry_selectCompanyList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectCompanyList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="companyStatus,companyID_parent,companyIsAffiliate,companyIsCobrand,companyIsVendor,companyIsCustomer,companyIsTaxExempt,companyDateCreated,companyDateUpdated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="">
	</cfif>
</cfinvoke>

