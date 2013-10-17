<cfquery Name="qry_selectProductLanguageVendor" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avProduct.productID, avProduct.vendorID, avProduct.productCode, avProduct.productName,
		avProduct.productPrice, avProduct.productPriceCallForQuote, avProduct.productWeight,
		avProduct.productHasImage, avProduct.productHasSpec, avProduct.productHasParameter,
		avProduct.productHasParameterException, avProduct.productCanBePurchased,
		avProduct.productDisplayChildren, avProduct.productHasCustomPrice,
		avProduct.productID_custom, avProduct.vendorID, avProduct.productInBundle, avProduct.productIsBundle, 
		avProduct.productIsRecommended, avProduct.productHasRecommendation, avProduct.productIsDateRestricted,
		avProduct.productIsDateAvailable, avProduct.templateFilename, avProduct.productCatalogPageNumber,
		avProduct.productInWarehouse, avProduct.productID_parent, avProduct.productChildType,
		avProduct.productHasChildren, avProduct.productChildOrder, avProduct.productChildSeparate,
		avProductLanguage.productLanguageName,
		avProductLanguage.productLanguageSummary, avProductLanguage.productLanguageSummaryHtml, 
		avProductLanguage.productLanguageDescription, avProductLanguage.productLanguageDescriptionHtml,
		avVendor.vendorName, avVendor.vendorCode
		<cfif Arguments.returnUserInfo is True>, avUser.firstName, avUser.lastName, avUser.username, avUser.email</cfif>
	FROM avProduct
		INNER JOIN avProductLanguage ON avProduct.productID = avProductLanguage.productID
		LEFT OUTER JOIN avVendor ON avProduct.vendorID = avVendor.vendorID
		<cfif Arguments.returnUserInfo is True>LEFT OUTER JOIN avUser ON avProduct.userID_manager = avUser.userID</cfif>
	WHERE avProduct.productStatus = 1
		AND avProduct.productListedOnSite = 1
		AND avProduct.companyID = #Arguments.companyID#
		AND avProductLanguage.languageID = '#Arguments.languageID#'
		AND avProductLanguage.productLanguageStatus = 1
		<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
			AND avProduct.productID IN (#Arguments.productID#)
		<cfelseif StructKeyExists(Arguments, "productID_parent") and Application.fn_IsIntegerList(Arguments.productID_parent)>
			AND avProduct.productID_parent IN (#Arguments.productID_parent#)
		<cfelse>
			AND avProduct.productID = 0
		</cfif>
	<cfif StructKeyExists(Arguments, "productID_parent")>
		ORDER BY avProduct.productChildOrder
	</cfif>
</cfquery>
