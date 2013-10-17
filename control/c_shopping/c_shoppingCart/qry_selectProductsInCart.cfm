<cfquery Name="qry_selectProductsInCart" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avProduct.productID, avProduct.productCode, avProduct.productPrice, avProduct.productWeight,
		avProduct.productHasCustomPrice, avProduct.productID_custom, avProduct.productInWarehouse,
		avProduct.productID_parent, avProduct.productIsBundle, avProduct.productCatalogPageNumber,
		avProduct.productPriceCallForQuote, avProductLanguage.productLanguageName,
		avProductLanguage.productLanguageLineItemName, avProductLanguage.productLanguageLineItemDescription,
		avProductLanguage.productLanguageLineItemDescriptionHtml
	FROM avProduct, avProductLanguage
	WHERE avProduct.productID = avProductLanguage.productID
		AND avProductLanguage.productLanguageStatus = 1
		AND avProduct.productID IN (#productID_list#)
		AND avProductLanguage.languageID = '#Arguments.languageID#'
</cfquery>

