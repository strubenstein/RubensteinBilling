<cfquery Name="qry_viewVendorByID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avVendor.vendorID, avVendor.vendorID_custom, avVendor.vendorCode, avVendor.vendorName,
		avCompany.companyName
	FROM avVendor, avCompany
	WHERE avVendor.companyID = avCompany.companyID
		AND avVendor.companyID_author = <cfqueryparam Value="#Session.companyID#" cfsqltype="cf_sql_integer">
		AND (
			avVendor.vendorID_custom = <cfqueryparam Value="#URL.vendorID#" cfsqltype="cf_sql_varchar">
			OR
			avVendor.vendorCode = <cfqueryparam Value="#URL.vendorID#" cfsqltype="cf_sql_varchar">
			<cfif Application.fn_IsIntegerNonNegative(URL.vendorID)>
				OR avVendor.vendorID = <cfqueryparam Value="#URL.vendorID#" cfsqltype="cf_sql_integer">
			</cfif>
			)
	ORDER BY avVendor.vendorID_custom, avVendor.vendorName, avCompany.companyName
</cfquery>

<cfif qry_viewVendorByID.RecordCount is 1>
	<cfset URL.vendorID = qry_viewVendorByID.vendorID>
<cfelseif qry_viewVendorByID.RecordCount gt 1>
	<cfset URL.vendorID = qry_viewVendorByID.vendorID[1]>
	<cfset Variables.displayViewByIDList = True>
</cfif>
