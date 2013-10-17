<cfoutput>
avProduct.companyID = <cfqueryparam value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
AND avProduct.productStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
AND avProduct.productListedOnSite = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
AND avProduct.productID_parent = <cfqueryparam value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
AND avProductLanguage.productLanguageStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
AND avProductLanguage.languageID = <cfqueryparam value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">
<cfif StructKeyExists(Arguments, "vendorID") and Application.fn_IsIntegerNonNegative(Arguments.vendorID)>
	AND avProduct.vendorID = <cfqueryparam value="#Arguments.vendorID#" cfsqltype="cf_sql_integer">
</cfif>
<cfif StructKeyExists(Arguments, "productIsBundle") and ListFind("0,1", Arguments.productIsBundle)>
	AND avProduct.productIsBundle = <cfqueryparam value="#Arguments.productIsBundle#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
</cfif>
<cfif StructKeyExists(Arguments, "productInWarehouse") and ListFind("0,1", Arguments.productInWarehouse)>
	AND avProduct.productInWarehouse = <cfqueryparam value="#Arguments.productInWarehouse#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
</cfif>
<cfif StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerList(Arguments.categoryID)>
	<!--- AND avProduct.productID = avProductCategory.productID --->
	AND avProductCategory.productCategoryStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	AND avProductCategory.productCategoryDateBegin <= <cfqueryparam value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp">
	AND (avProductCategory.productCategoryDateEnd IS NULL OR avProductCategory.productCategoryDateEnd > <cfqueryparam value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp">)
	AND avProductCategory.categoryID IN (<cfqueryparam value="#Arguments.categoryID#" cfsqltype="cf_sql_integer" list="yes">)
</cfif>
<cfif StructKeyExists(Arguments, "productCatalogPageNumber") and Arguments.productCatalogPageNumber is not "">
	<cfif IsNumeric(Arguments.productCatalogPageNumber)>
		AND avProduct.productCatalogPageNumber = <cfqueryparam value="#Arguments.productCatalogPageNumber#" cfsqltype="cf_sql_smallint">
	<cfelseif ListLen(Arguments.productCatalogPageNumber, "-" is 2)
			and IsNumeric(ListFirst(Arguments.productCatalogPageNumber, "-")) and IsNumeric(ListLast(Arguments.productCatalogPageNumber, "-"))
			and ListLast(Arguments.productCatalogPageNumber, "-") gt ListFirst(Arguments.productCatalogPageNumber, "-")>
		AND avProduct.productCatalogPageNumber BETWEEN <cfqueryparam value="#ListFirst(Arguments.productCatalogPageNumber, '-')#" cfsqltype="cf_sql_smallint"> AND <cfqueryparam value="#ListFirst(Arguments.productCatalogPageNumber, '-')#" cfsqltype="cf_sql_smallint">
	<cfelseif ListLen(Arguments.productCatalogPageNumber, ",") gt 1 and Application.fn_IsIntegerList(Arguments.productCatalogPageNumber)>
		AND avProduct.productCatalogPageNumber IN (<cfqueryparam value="#Arguments.productCatalogPageNumber#" cfsqltype="cf_sql_smallint" list="yes">)
	</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "productPrice_min") and IsNumeric(Arguments.productPrice_min) and StructKeyExists(Arguments, "productPrice_max") and IsNumeric(Arguments.productPrice_max)><!--- price between min and max --->
	AND avProduct.productPrice BETWEEN <cfqueryparam value="#Arguments.productPrice_min#" cfsqltype="cf_sql_money"> AND <cfqueryparam value="#Arguments.productPrice_min#" cfsqltype="cf_sql_money">
<cfelseif StructKeyExists(Arguments, "productPrice_min") and IsNumeric(Arguments.productPrice_min)><!--- price gte min --->
	AND avProduct.productPrice >= <cfqueryparam value="#Arguments.productPrice_min#" cfsqltype="cf_sql_money">
<cfelseif StructKeyExists(Arguments, "productPrice_max") and IsNumeric(Arguments.productPrice_max)><!--- price lte max --->
	AND avProduct.productPrice <= <cfqueryparam value="#Arguments.productPrice_min#" cfsqltype="cf_sql_money">
</cfif>
<!--- <cfif StructKeyExists(Arguments, "productWeight") and IsNumeric(Arguments.productWeight)>AND productWeight = #Arguments.productWeight#</cfif> --->
<cfif StructKeyExists(Arguments, "productWeight_min") and IsNumeric(Arguments.productWeight_min) and StructKeyExists(Arguments, "productWeight_max") and IsNumeric(Arguments.productWeight_max)><!--- price between min and max --->
	AND avProduct.productWeight BETWEEN <cfqueryparam value="#Arguments.productWeight_min#" cfsqltype="decimal" scale="2"> AND <cfqueryparam value="#Arguments.productWeight_min#" cfsqltype="decimal" scale="2">
<cfelseif StructKeyExists(Arguments, "productWeight_min") and IsNumeric(Arguments.productWeight_min)><!--- price gte min --->
	AND avProduct.productWeight >= <cfqueryparam value="#Arguments.productWeight_min#" cfsqltype="decimal" scale="2">
<cfelseif StructKeyExists(Arguments, "productWeight_max") and IsNumeric(Arguments.productWeight_max)><!--- price lte max --->
	AND avProduct.productWeight <= <cfqueryparam value="#Arguments.productWeight_min#" cfsqltype="decimal" scale="2">
</cfif>
<cfif StructKeyExists(Arguments, "searchText") and Trim(Arguments.searchText) is not "" and StructKeyExists(Arguments, "searchField")
		and (ListFind(Arguments.searchField, "productName") or ListFind(Arguments.searchField, "productCode") or ListFind(Arguments.searchField, "productDescription"))>
	AND
	(
	<cfif ListFind(Arguments.searchField, "productName") or ListFind(Arguments.searchField, "productDescription")>
		avProduct.productName LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		OR avProductLanguage.productLanguageName LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		OR avProductLanguage.productLanguageLineItemName LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		OR productLanguageSummary LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		OR productLanguageLineItemDescription LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		OR productLanguageDescription LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
	</cfif>
	<cfif ListFind(Arguments.searchField, "productCode")>
		<cfif ListFind(Arguments.searchField, "productName") or ListFind(Arguments.searchField, "productDescription")>OR</cfif>
		avProduct.productCode LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		OR
		avProduct.productID_custom LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
	</cfif>
	<!--- 
	<cfif ListFind(Arguments.searchField, "productDescription")>
		<cfif ListFind(Arguments.searchField, "productName") or ListFind(Arguments.searchField, "productCode")>OR</cfif>
		productLanguageSummary LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		OR productLanguageLineItemDescription LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		OR productLanguageDescription LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
	</cfif>
	--->
	)
</cfif>
</cfoutput>
