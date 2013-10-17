<cfquery Name="qry_selectCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#" CachedWithin="#Application.billingQueryCacheTimeSpan#">
	SELECT categoryTitle, categoryDescription, categoryID_parent, categoryID_parentList,
		categoryLevel, categoryHasChildren, categoryAcceptListing, categoryIsListed,
		categoryItemsPerPage, categoryNumberOfPages, headerFooterID_header,
		headerFooterID_footer, templateFilename, categoryHasCustomPrice
	FROM avCategory
	WHERE companyID = #Arguments.companyID#
		AND categoryStatus = 1
		AND categoryID = #Arguments.categoryID#
</cfquery>

