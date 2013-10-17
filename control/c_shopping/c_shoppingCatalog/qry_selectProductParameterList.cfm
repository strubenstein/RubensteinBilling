<cfquery Name="qry_selectProductParameterList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT productParameterID, productParameterText, productParameterOrder,
		productParameterImage, productParameterRequired,
		productParameterCodeStatus, productParameterCodeOrder
	FROM avProductParameter
	WHERE productID IN (#Arguments.productID#)
			AND productParameterStatus = 1
	ORDER BY productParameterOrder
</cfquery>

