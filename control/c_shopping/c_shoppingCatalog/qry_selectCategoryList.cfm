<cfquery Name="qry_selectCategoryList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#" CachedWithin="#Application.billingQueryCacheTimeSpan#">
	SELECT categoryID, categoryTitle, categoryOrder, categoryID_parent, categoryID_parentList,
		categoryLevel, categoryHasChildren, categoryAcceptListing, categoryIsListed
	FROM avCategory
	WHERE companyID = #Arguments.companyID#
		AND categoryStatus = 1
		<cfif StructKeyExists(Arguments, "categoryIsListed") and ListFind("0,1", Arguments.categoryIsListed)>
			AND categoryIsListed = #Arguments.categoryIsListed#
		</cfif>
		<cfif StructKeyExists(Arguments, "categoryLevel") and Application.fn_IsIntegerNonNegative(Arguments.categoryLevel)>
			AND categoryLevel = #Arguments.categoryLevel#
		</cfif>
		<cfif StructKeyExists(Arguments, "categoryID_parent") and Application.fn_IsIntegerNonNegative(Arguments.categoryID_parent)>
			AND categoryID_parent = #Arguments.categoryID_parent#
		</cfif>
		<cfif StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerList(Arguments.categoryID)>
			AND categoryID IN (#Arguments.categoryID#)
		</cfif>
	ORDER BY 
	<cfif StructKeyExists(Arguments, "categoryOrderByManual") and Arguments.categoryOrderByManual is True>
		categoryOrder_manual
	<cfelse>
		categoryOrder
	</cfif>
</cfquery>

