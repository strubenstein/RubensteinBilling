<cfquery Name="qry_selectProductCategoryList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avProductCategory.productID, avProductCategory.categoryID,
		avCategory.categoryTitle, avCategory.categoryLevel, avCategory.categoryOrder,
		avCategory.categoryID_parent, avCategory.categoryID_parentList
	FROM avProductCategory, avCategory
	WHERE avProductCategory.categoryID = avCategory.categoryID
		AND avProductCategory.productCategoryStatus = 1
		AND avProductCategory.productCategoryDateBegin <= #CreateODBCDateTime(Now())#
		AND (avProductCategory.productCategoryDateEnd IS NULL OR avProductCategory.productCategoryDateEnd > #CreateODBCDateTime(Now())#)
		AND avCategory.categoryStatus = 1
		AND avProductCategory.productID IN (#Arguments.productID#)
</cfquery>

