<cfquery Name="qry_selectProductList_count" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT COUNT(avProduct.productID) AS totalRecords
	FROM avProduct INNER JOIN avProductLanguage ON avProduct.productID = avProductLanguage.productID
		<cfif StructKeyExists(Arguments, "categoryID")>
			INNER JOIN avProductCategory ON avProduct.productID = avProductCategory.productID
		</cfif>
	WHERE 
		<cfinclude template="qryParam_selectProductList.cfm">
</cfquery>

