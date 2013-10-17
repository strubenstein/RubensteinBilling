<cfquery Name="qry_selectProductParameterOptionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT productParameterID, productParameterOptionID, productParameterOptionLabel,
		productParameterOptionValue, productParameterOptionOrder,
		productParameterOptionImage, productParameterOptionCode
	FROM avProductParameterOption
	WHERE productParameterID IN (#Arguments.productParameterID#)
		AND productParameterOptionStatus = 1
	ORDER BY productParameterID, productParameterOptionOrder
</cfquery>

