<cfquery Name="qry_selectProductSpecList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT productID, productSpecID, productSpecName, productSpecValue,
		productSpecOrder, productSpecStatus, productSpecHasImage
	FROM avProductSpec
	WHERE productSpecStatus = 1
		AND productID IN
		<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
			(#Arguments.productID#)
		<cfelse>
			(0)
		</cfif>
		<cfif StructKeyExists(Arguments, "languageID")>
			AND languageID = '#Arguments.languageID#'
		</cfif>
	ORDER BY productID, productSpecOrder
</cfquery>

