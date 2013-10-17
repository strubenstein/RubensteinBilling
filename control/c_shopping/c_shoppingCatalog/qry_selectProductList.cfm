<cfquery Name="qry_selectProductList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT 
		<cfif Application.billingDatabase is "MSSQLServer">
			* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
		</cfif>
		avProduct.productID, avProduct.vendorID, avProduct.productCode,
		avProduct.productPrice, avProduct.productHasImage,
		avProduct.productHasCustomPrice, avProduct.productID_custom, 
		avProduct.productCatalogPageNumber, avProduct.productInWarehouse,
		avProduct.productID_parent, avProduct.productPriceCallForQuote, 
		avProductLanguage.productLanguageName
		<cfif Arguments.queryDisplayProductImage is True>, avImage.imageTag, avImage.imageURL</cfif>
		<cfif Arguments.returnUserInfo is True>, avUser.firstName, avUser.lastName, avUser.username, avUser.email</cfif>
	FROM avProduct INNER JOIN avProductLanguage ON avProduct.productID = avProductLanguage.productID
		<cfif StructKeyExists(Arguments, "categoryID")>
			INNER JOIN avProductCategory ON avProduct.productID = avProductCategory.productID
		</cfif>
		<cfif Arguments.queryDisplayProductImage is True>
			LEFT OUTER JOIN avImage ON avProduct.productID = avImage.targetID
			AND avImage.primaryTargetID = #Application.fn_GetPrimaryTargetID("productID")#
			AND avImage.imageStatus = 1
			AND avImage.imageDisplayCategory = 1 
		</cfif>
		<cfif Arguments.returnUserInfo is True>LEFT OUTER JOIN avUser ON avProduct.userID_manager = Manager.userID</cfif>
	WHERE 
		<cfinclude template="qryParam_selectProductList.cfm">
	<cfif Application.billingDatabase is "MSSQLServer">
		) AS T
		<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
		ORDER BY #queryParameters_orderBy_noTable#
	<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
		ORDER BY #queryParameters_orderBy#
		LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
	</cfif>
</cfquery>

