<cfquery Name="qry_viewAffiliateByID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avAffiliate.affiliateID, avAffiliate.affiliateID_custom, avAffiliate.affiliateCode, avAffiliate.affiliateName,
		avCompany.companyName
	FROM avAffiliate, avCompany
	WHERE avAffiliate.companyID = avCompany.companyID
		AND avAffiliate.companyID_author = <cfqueryparam Value="#Session.companyID#" cfsqltype="cf_sql_integer">
		AND (
			avAffiliate.affiliateID_custom = <cfqueryparam Value="#URL.affiliateID#" cfsqltype="cf_sql_varchar">
			OR
			avAffiliate.affiliateCode = <cfqueryparam Value="#URL.affiliateID#" cfsqltype="cf_sql_varchar">
			<cfif Application.fn_IsIntegerNonNegative(URL.affiliateID)>
				OR avAffiliate.affiliateID = <cfqueryparam Value="#URL.affiliateID#" cfsqltype="cf_sql_integer">
			</cfif>
			)
	ORDER BY avAffiliate.affiliateID_custom, avAffiliate.affiliateName, avCompany.companyName
</cfquery>

<cfif qry_viewAffiliateByID.RecordCount is 1>
	<cfset URL.affiliateID = qry_viewAffiliateByID.affiliateID>
<cfelseif qry_viewAffiliateByID.RecordCount gt 1>
	<cfset URL.affiliateID = qry_viewAffiliateByID.affiliateID[1]>
	<cfset Variables.displayViewByIDList = True>
</cfif>
