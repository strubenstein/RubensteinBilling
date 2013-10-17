<!--- select product bundles which include a specified product --->
<cfquery Name="qry_selectProductBundleList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avProductBundle.productBundleID, avProductBundleProduct.productID,
		avProduct.productPrice, avProduct.vendorID, avProduct.productHasCustomPrice,
		avProduct.productID_bundle, avProduct.productCode, avProduct.productID_custom,
		avProduct.productPriceCallForQuote, avProductLanguage.productLanguageName,
		avProductLanguage.productLanguageSummary, avProductLanguage.productLanguageSummaryHtml
	FROM avProductBundleProduct, avProductBundle, avProduct, avProductLanguage
	WHERE avProductBundleProduct.productBundleID = avProductBundle.productBundleID
		AND avProductBundle.productID = avProduct.productID
		AND avProductBundle.productID = avProductLanguage.productID
		AND avProductBundle.productBundleStatus = 1
		AND avProduct.productStatus = 1
		AND avProduct.productListedOnSite = 1
		AND avProductLanguage.productLanguageStatus = 1
		AND avProductBundleProduct.productID = #Arguments.productID#
		AND avProductLanguage.languageID = '#Arguments.languageID#'
	ORDER BY avProductLanguage.productLanguageName
</cfquery>

