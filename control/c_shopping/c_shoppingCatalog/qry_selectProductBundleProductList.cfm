<!--- select products included in a specified product bundle --->
<cfquery Name="qry_selectProductBundleProductList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avProductBundle.productBundleID, avProductBundleProduct.productID,
		avProductBundleProduct.productBundleProductOrder, avProductBundleProduct.productBundleProductQuantity,
		avProduct.productPrice, avProduct.vendorID, avProduct.productCode, avProduct.productID_custom,
		avProduct.productID_parent, avProduct.productHasCustomPrice,
		avProduct.productPriceCallForQuote, avProductLanguage.productLanguageName,
		avProductLanguage.productLanguageSummary, avProductLanguage.productLanguageSummaryHtml
	FROM avProductBundle, avProductBundleProduct, avProduct, avProductLanguage
	WHERE avProductBundle.productBundleID = avProductBundleProduct.productBundleID
		AND avProductBundleProduct.productID = avProduct.productID
		AND avProductBundleProduct.productID = avProductLanguage.productID
		AND avProductBundle.productBundleStatus = 1
		AND avProduct.productStatus = 1
		AND avProduct.productListedOnSite = 1
		AND avProductLanguage.productLanguageStatus = 1
		AND avProductBundle.productID = #Arguments.productID#
		AND avProductLanguage.languageID = '#Arguments.languageID#'
	ORDER BY avProductBundleProduct.productBundleProductOrder
</cfquery>

