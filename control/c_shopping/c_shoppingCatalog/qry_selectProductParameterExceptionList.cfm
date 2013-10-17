<cfquery Name="qry_selectProductParameterExceptionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT productParameterExceptionID, productParameterOptionID1, productParameterOptionID2,
		productParameterOptionID3, productParameterOptionID4, productParameterExceptionExcluded,
		productParameterExceptionPricePremium, productParameterExceptionText
	FROM avProductParameterException
	WHERE productID = #Arguments.productID#
		AND productParameterExceptionStatus = 1
</cfquery>

