<cfquery Name="qry_selectProductParameterOptionsInCart" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avProductParameterOption.productParameterID,
		avProductParameterOption.productParameterOptionID, avProductParameterOption.productParameterOptionLabel,
		avProductParameter.productID, avProductParameter.productParameterText, avProductParameter.productParameterOrder
	FROM avProductParameter, avProductParameterOption
	WHERE avProductParameter.productParameterID = avProductParameterOption.productParameterID
		AND avProductParameterOption.productParameterOptionID IN (#productParameterOptionID_list#)
	ORDER BY avProductParameter.productID, avProductParameter.productParameterOrder
</cfquery>

