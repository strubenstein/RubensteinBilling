<cfquery Name="qry_selectProductRecommendList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avProductRecommend.productID_recommend AS productID, 
		avProduct.productPrice, avProduct.productHasCustomPrice,
		avProduct.vendorID, avProduct.productCode, avProduct.productID_parent,
		avProduct.productID_custom, avProduct.productPriceCallForQuote, 
		avProductLanguage.productLanguageName, avProductLanguage.productLanguageSummary,
		avProductLanguage.productLanguageSummaryHtml
	FROM avProductRecommend, avProduct, avProductLanguage
	WHERE avProductRecommend.productID_recommend = avProduct.productID
		AND avProduct.productID = avProductLanguage.productID
		AND avProductRecommend.productRecommendStatus = 1
		AND avProduct.productStatus = 1
		AND avProduct.productListedOnSite = 1
		AND avProductLanguage.productLanguageStatus = 1
		AND avProductRecommend.productID_target = #Arguments.productID_target#
		AND avProductLanguage.languageID = '#Arguments.languageID#'
	ORDER BY avProductLanguage.productLanguageName
</cfquery>
