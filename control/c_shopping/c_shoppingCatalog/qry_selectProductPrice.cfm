<cfquery Name="qry_selectProductPrice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT productID, productPrice, productPriceCallForQuote, productWeight
	FROM avProduct
	WHERE productID IN <cfif Application.fn_IsIntegerList(Arguments.productID)>(#Arguments.productID#)<cfelse>0</cfif>
</cfquery>
