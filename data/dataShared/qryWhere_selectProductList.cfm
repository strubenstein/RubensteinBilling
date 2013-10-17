<cfoutput>
avProduct.companyID = <cfqueryparam value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
<cfif StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerNonNegative(Arguments.categoryID)>
	AND avProduct.productID <cfif Arguments.categoryID is 0>NOT</cfif> IN 
		(SELECT productID FROM avProductCategory WHERE productCategoryStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avProductCategory.productCategoryDateBegin <= <cfqueryparam value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp">
			AND (avProductCategory.productCategoryDateEnd IS NULL OR avProductCategory.productCategoryDateEnd > <cfqueryparam value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp">)
			<cfif Arguments.categoryID is not 0>
				<cfif StructKeyExists(Arguments, "categoryID_sub") and Arguments.categoryID_sub is 1 and StructKeyExists(Arguments, "categoryID_list") and Arguments.categoryID_list is not "">
					AND categoryID IN (<cfqueryparam value="#Arguments.categoryID_list#" cfsqltype="cf_sql_integer" list="yes">)
				<cfelse>
					AND categoryID = <cfqueryparam value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
				</cfif>
			</cfif>
		)
</cfif>
<cfif StructKeyExists(Arguments, "categoryID_multiple") and Arguments.categoryID_multiple is 1>AND avProduct.productID IN (SELECT productID FROM avProductCategory WHERE productCategoryStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> HAVING Count(productID) > 1)</cfif>
<cfloop Index="field" List="vendorID,userID_manager"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerNonNegative(Arguments[field])> AND avProduct.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer"> </cfif></cfloop>
<cfloop Index="field" List="productStatus,productListedOnSite,productHasImage,productIsBundle,productInBundle,productIsRecommended,productHasRecommendation,productHasCustomPrice,productPriceCallForQuote,productIsDateRestricted,productIsDateAvailable,productHasChildren,productHasSpec,productCanBePurchased,productHasParameter,productHasParameterException,productInWarehouse">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>AND avProduct.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "productID_not") and Application.fn_IsIntegerList(Arguments.productID_not)>AND avProduct.productID NOT IN (<cfqueryparam value="#Arguments.productID_not#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "productID_parent") and Application.fn_IsInteger(Arguments.productID_parent)>AND avProduct.productID_parent <cfif Arguments.productID_parent gte 0> = #Arguments.productID_parent# <cfelse> > 0 </cfif></cfif>
<cfif StructKeyExists(Arguments, "productCatalogPageNumber") and Arguments.productCatalogPageNumber is not "">
	<cfif IsNumeric(Arguments.productCatalogPageNumber)>
		AND avProduct.productCatalogPageNumber = <cfqueryparam value="#Arguments.productCatalogPageNumber#" cfsqltype="cf_sql_smallint">
	<cfelseif ListLen(Arguments.productCatalogPageNumber, "-" is 2) and IsNumeric(ListFirst(Arguments.productCatalogPageNumber, "-")) and IsNumeric(ListLast(Arguments.productCatalogPageNumber, "-")) and ListLast(Arguments.productCatalogPageNumber, "-") gt ListFirst(Arguments.productCatalogPageNumber, "-")>
		AND avProduct.productCatalogPageNumber BETWEEN <cfqueryparam value="#ListFirst(Arguments.productCatalogPageNumber, '-')#" cfsqltype="cf_sql_smallint"> AND <cfqueryparam value="#ListFirst(Arguments.productCatalogPageNumber, '-')#" cfsqltype="cf_sql_smallint">
	<cfelseif ListLen(Arguments.productCatalogPageNumber, ",") gt 1 and Application.fn_IsIntegerList(Arguments.productCatalogPageNumber)>
		AND avProduct.productCatalogPageNumber IN (<cfqueryparam value="#Arguments.productCatalogPageNumber#" cfsqltype="cf_sql_smallint">)
	</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "templateFilename")>AND avProduct.templateFilename = <cfqueryparam value="#Arguments.templateFilename#" cfsqltype="cf_sql_varchar"></cfif>
<cfif StructKeyExists(Arguments, "productPrice") and IsNumeric(Arguments.productPrice)>AND avProduct.productPrice = <cfqueryparam value="#Arguments.productPrice#" cfsqltype="cf_sql_money"></cfif>
<cfif StructKeyExists(Arguments, "productPrice_min") and IsNumeric(Arguments.productPrice_min) and StructKeyExists(Arguments, "productPrice_max") and IsNumeric(Arguments.productPrice_max)><!--- price between min and max --->
	AND avProduct.productPrice BETWEEN <cfqueryparam value="#Arguments.productPrice_min#" cfsqltype="cf_sql_money"> AND <cfqueryparam value="#Arguments.productPrice_min#" cfsqltype="cf_sql_money">
 <cfelseif StructKeyExists(Arguments, "productPrice_min") and IsNumeric(Arguments.productPrice_min)><!--- price gte min --->
	AND avProduct.productPrice >= <cfqueryparam value="#Arguments.productPrice_min#" cfsqltype="cf_sql_money">
 <cfelseif StructKeyExists(Arguments, "productPrice_max") and IsNumeric(Arguments.productPrice_max)><!--- price lte max --->
	AND avProduct.productPrice <= <cfqueryparam value="#Arguments.productPrice_min#" cfsqltype="cf_sql_money">
</cfif>
<cfif StructKeyExists(Arguments, "productWeight") and ListFind("0,1", Arguments.productWeight)>AND avProduct.productWeight <cfif Arguments.productWeight is 0> = 0 <cfelse> <> 0 </cfif></cfif>
<cfif StructKeyExists(Arguments, "productWeight_min") and IsNumeric(Arguments.productWeight_min) and StructKeyExists(Arguments, "productWeight_max") and IsNumeric(Arguments.productWeight_max)><!--- price between min and max --->
	AND avProduct.productWeight BETWEEN <cfqueryparam value="#Arguments.productWeight_min#" cfsqltype="cf_sql_decimal" Scale="2"> AND <cfqueryparam value="#Arguments.productWeight_min#" cfsqltype="cf_sql_decimal" Scale="2">
 <cfelseif StructKeyExists(Arguments, "productWeight_min") and IsNumeric(Arguments.productWeight_min)><!--- price gte min --->
	AND avProduct.productWeight >= <cfqueryparam value="#Arguments.productWeight_min#" cfsqltype="cf_sql_decimal" Scale="2">
 <cfelseif StructKeyExists(Arguments, "productWeight_max") and IsNumeric(Arguments.productWeight_max)><!--- price lte max --->
	AND avProduct.productWeight <= <cfqueryparam value="#Arguments.productWeight_min#" cfsqltype="cf_sql_decimal" Scale="2">
</cfif>
<cfif StructKeyExists(Arguments, "searchText") and Trim(Arguments.searchText) is not "" and StructKeyExists(Arguments, "searchField") and (ListFind(Arguments.searchField, "productName") or ListFind(Arguments.searchField, "productCode") or ListFind(Arguments.searchField, "productDescription"))>
	<cfset displayOr = False>
	AND (
		<cfif ListFind(Arguments.searchField, "productName")>
			<cfif displayOr is True>OR<cfelse><cfset displayOr = True></cfif>
			avProduct.productName LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
			OR avProductLanguage.productLanguageName LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
			OR avProductLanguage.productLanguageLineItemName LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif ListFind(Arguments.searchField, "productCode")>
			<cfif displayOr is True>OR<cfelse><cfset displayOr = True></cfif>
			avProduct.productCode LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar"> OR avProduct.productID_custom LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		</cfif>
		<cfif ListFind(Arguments.searchField, "productDescription")>
			<cfif displayOr is True>OR<cfelse><cfset displayOr = True></cfif>
			avProductLanguage.productLanguageSummary LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
			OR avProductLanguage.productLanguageLineItemDescription LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
			OR avProductLanguage.productLanguageDescription LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		</cfif>
	)
</cfif>
<cfif StructKeyExists(Arguments, "commissionID") and Application.fn_IsIntegerPositive(Arguments.commissionID)>AND avProduct.productID IN (SELECT productID FROM avCommissionProduct WHERE commissionProductStatus = 1 AND commissionID = <cfqueryparam value="#Arguments.commissionID#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "commissionID_not") and Application.fn_IsIntegerPositive(Arguments.commissionID_not)>AND avProduct.productID NOT IN (SELECT productID FROM avCommissionProduct WHERE commissionProductStatus = 1 AND commissionID = <cfqueryparam value="#Arguments.commissionID_not#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "statusID") and Application.fn_IsIntegerList(Arguments.statusID)>AND avProduct.productID <cfif Arguments.statusID is 0>NOT</cfif> IN	(SELECT targetID FROM avStatusHistory WHERE primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('productID')#" cfsqltype="cf_sql_integer"> <cfif Arguments.statusID is not 0>AND statusID IN (<cfqueryparam value="#Arguments.statusID#" cfsqltype="cf_sql_integer" list="yes">)</cfif> AND statusHistoryStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)</cfif>
<cfif StructKeyExists(Arguments, "productIsExported") and (Arguments.productIsExported is "" or ListFind("0,1", Arguments.productIsExported))>AND avProduct.productIsExported <cfif Arguments.productIsExported is "">IS NULL<cfelse>= <cfqueryparam value="#Arguments.productIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
<cfif StructKeyExists(Arguments, "productDateExported_from") and IsDate(Arguments.productDateExported_from)>AND avProduct.productDateExported >= <cfqueryparam value="#CreateODBCDateTime(Arguments.productDateExported_from)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "productDateExported_to") and IsDate(Arguments.productDateExported_to)>AND avProduct.productDateExported <= <cfqueryparam value="#CreateODBCDateTime(Arguments.productDateExported_to)#" cfsqltype="cf_sql_timestamp"></cfif>
</cfoutput>
