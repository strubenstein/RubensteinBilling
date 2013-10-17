<cfoutput>
avPrice.companyID = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
<cfif StructKeyExists(Arguments, "priceID") and Arguments.priceID is not 0 and Application.fn_IsIntegerList(Arguments.priceID)>AND avPrice.priceID IN (<cfqueryparam value="#Arguments.priceID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "priceID_parent") and Application.fn_IsIntegerList(Arguments.priceID_parent)>AND avPrice.priceID_parent IN (<cfqueryparam value="#Arguments.priceID_parent#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "priceID_trend") and Arguments.priceID_trend is not 0 and Application.fn_IsIntegerList(Arguments.priceID_trend)>AND avPrice.priceID IN (<cfqueryparam value="#Arguments.priceID_trend#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "categoryID") and Arguments.categoryID is not 0 and Application.fn_IsIntegerList(Arguments.categoryID)>AND avPrice.categoryID IN (<cfqueryparam value="#Arguments.categoryID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "productID") and Arguments.productID is not 0 and Application.fn_IsIntegerList(Arguments.productID)>
	AND (avPrice.productID IN (<cfqueryparam value="#Arguments.productID#" cfsqltype="cf_sql_integer" list="yes">) OR (avPrice.priceAppliesToProductChildren = 1 AND avProduct.productID_parent IN (<cfqueryparam value="#Arguments.productID#" cfsqltype="cf_sql_integer" list="yes">)))
</cfif>
<cfif StructKeyExists(Arguments, "vendorID") and Application.fn_IsIntegerList(Arguments.vendorID)>AND avProduct.vendorID IN (<cfqueryparam value="#Arguments.vendorID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfloop Index="field" List="priceStatus,priceAppliedStatus,priceAppliesToCategory,priceAppliesToCategoryChildren,priceAppliesToProduct,priceAppliesToProductChildren,priceAppliesToAllProducts,priceAppliesToInvoice,priceAppliesToAllCustomers,priceHasMultipleStages,priceCodeRequired,priceIsParent">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>AND avPrice.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
</cfloop>
<cfloop Index="field" List="priceStageVolumeDiscount,priceStageVolumeDollarOrQuantity,priceStageVolumeStep,priceStageDollarOrPercent,priceStageNewOrDeduction">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>AND avPriceStage.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "priceStageInterval_min") and Application.fn_IsIntegerPositive(Arguments.priceStageInterval_min)
		and StructKeyExists(Arguments, "priceStageInterval_max") and Application.fn_IsIntegerPositive(Arguments.priceStageInterval_max)>
	AND avPriceStage.priceStageInterval BETWEEN <cfqueryparam value="#Arguments.priceStageInterval_min#" cfsqltype="cf_sql_smallint"> AND <cfqueryparam value="#Arguments.priceStageInterval_max#" cfsqltype="cf_sql_smallint">
 <cfelseif StructKeyExists(Arguments, "priceStageInterval_min") and Application.fn_IsIntegerPositive(Arguments.priceStageInterval_min)>
	AND avPriceStage.priceStageInterval >= <cfqueryparam value="#Arguments.priceStageInterval_min#" cfsqltype="cf_sql_smallint">
 <cfelseif StructKeyExists(Arguments, "priceStageInterval_max") and Application.fn_IsIntegerPositive(Arguments.priceStageInterval_max)>
	AND avPriceStage.priceStageInterval AND avPriceStage.priceStageInterval <= <cfqueryparam value="#Arguments.priceStageInterval_max#" cfsqltype="cf_sql_smallint">
</cfif>
<cfif StructKeyExists(Arguments, "priceStageIntervalType") and Trim(Arguments.priceStageIntervalType) is not "">AND avPriceStage.priceStageIntervalType IN (<cfqueryparam value="#Arguments.priceStageIntervalType#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "priceHasCode") and ListFind("0,1", Arguments.priceHasCode)>AND avPrice.priceCode <cfif Arguments.priceHasCode is 1> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "priceHasCustomID") and ListFind("0,1", Arguments.priceHasCustomID)>AND avPrice.priceID_custom <cfif Arguments.priceHasCustomID is 1> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "priceBeforeBeginDate") and ListFind("0,1", Arguments.priceBeforeBeginDate)>AND avPrice.priceDateBegin <cfif Arguments.priceBeforeBeginDate is 1> >= <cfelse> <= </cfif> <cfqueryparam value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "priceHasEndDate") and ListFind("0,1", Arguments.priceHasEndDate)>AND avPrice.priceDateEnd IS <cfif Arguments.priceHasEndDate is 0> NOT </cfif> NULL</cfif>
<cfif StructKeyExists(Arguments, "priceHasQuantityMinimumPerOrder") and ListFind("0,1", Arguments.priceHasQuantityMinimumPerOrder)>AND avPrice.priceQuantityMinimumPerOrder <cfif Arguments.priceHasQuantityMinimumPerOrder is 1> <> 0<cfelse> = 0</cfif></cfif>
<cfif StructKeyExists(Arguments, "priceHasQuantityMaximumPerCustomer") and ListFind("0,1", Arguments.priceHasQuantityMaximumPerCustomer)>AND avPrice.priceQuantityMaximumPerCustomer <cfif Arguments.priceHasQuantityMaximumPerCustomer is 1> <> 0<cfelse> = 0</cfif></cfif>
<cfif StructKeyExists(Arguments, "priceHasQuantityMaximumAllCustomers") and ListFind("0,1", Arguments.priceHasQuantityMaximumAllCustomers)>AND avPrice.priceQuantityMaximumAllCustomers <cfif Arguments.priceHasQuantityMaximumAllCustomers is 1> <> 0<cfelse> = 0</cfif></cfif>
<cfif StructKeyExists(Arguments, "priceAppliedToSubscription") and ListFind("0,1", Arguments.priceAppliedToSubscription)>AND avPrice.priceID <cfif Arguments.priceAppliedToSubscription is 0> NOT </cfif> IN (SELECT priceID FROM avSubscription WHERE companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "priceDateType") and (ListFind("priceDateCreated", Arguments.priceDateType) or ListFind("priceDateUpdated", Arguments.priceDateType) or ListFind("priceDateBegin", Arguments.priceDateType) or ListFind("priceDateEnd", Arguments.priceDateType)) and ((StructKeyExists(Arguments, "priceDateFrom") and IsDate(Arguments.priceDateFrom)) or (StructKeyExists(Arguments, "priceDateTo") and IsDate(Arguments.priceDateTo)))>
	<cfif StructKeyExists(Arguments, "priceDateFrom") and IsDate(Arguments.priceDateFrom)>
		<cfif StructKeyExists(Arguments, "priceDateTo") and IsDate(Arguments.priceDateTo)>
			<cfset dateClause = "BETWEEN " & CreateODBCDateTime(Arguments.priceDateFrom) & " AND " & CreateODBCDateTime(Arguments.priceDateTo)>
		<cfelse>
			<cfset dateClause = ">= " & CreateODBCDateTime(Arguments.priceDateFrom)>
		</cfif>
	<cfelseif StructKeyExists(Arguments, "priceDateTo") and IsDate(Arguments.priceDateTo)>
		<cfset dateClause = "<= " & CreateODBCDateTime(Arguments.priceDateTo)>
	</cfif>

	<cfset displayAnd = True>
	<cfloop Index="field" List="priceDateCreated,priceDateUpdated,priceDateBegin,priceDateEnd">
		<cfif ListFind(Arguments.priceDateType, field)>
			<cfif displayAnd is True> AND (<cfset displayAnd = False><cfelse> OR </cfif>
			avPrice.#field# #dateClause#
		</cfif>
	</cfloop>
	<cfif displayAnd is False>)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "priceSearchText") and Trim(Arguments.priceSearchText) is not "" and StructKeyExists(Arguments, "priceSearchField") and (ListFind(Arguments.priceSearchField, "priceName") or ListFind(Arguments.priceSearchField, "priceCode") or ListFind(Arguments.priceSearchField, "priceDescription") or ListFind(Arguments.priceSearchField, "priceID_custom"))>
	<cfset displayAnd = True>
	<cfloop Index="field" List="priceName,priceCode,priceDescription,priceID_custom">
		<cfif ListFind(Arguments.priceSearchField, field)>
			<cfif displayAnd is True> AND (<cfset displayAnd = False><cfelse> OR </cfif>
			avPrice.#field# LIKE <cfqueryparam value="%#Arguments.priceSearchText#%" cfsqltype="cf_sql_varchar">
		</cfif>
	</cfloop>
	<cfif displayAnd is False>)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "productSearchText") and Trim(Arguments.productSearchText) is not "" and StructKeyExists(Arguments, "productSearchField") and (ListFind(Arguments.productSearchField, "productName") or ListFind(Arguments.productSearchField, "productID") or ListFind(Arguments.productSearchField, "productID_custom"))>
	<cfset displayAnd = True>
	<cfloop Index="field" List="productName,productID,productID_custom">
		<cfif ListFind(Arguments.productSearchText, field)>
			<cfif displayAnd is True> AND (<cfset displayAnd = False><cfelse> OR </cfif>
			avProduct.#field# LIKE <cfqueryparam value="%#Arguments.productSearchField#%" cfsqltype="cf_sql_varchar">
		</cfif>
	</cfloop>
	<cfif displayAnd is False>)</cfif>
</cfif>
<!--- select price target fields as a sub-query to avoid a huge number of joins and select distinct priceID --->
<cfset priceTargetQueryBegin = "AND avPrice.priceID IN (SELECT avPriceTarget.priceID FROM avPriceTarget WHERE avPriceTarget.priceTargetStatus = 1">
<cfloop Index="field" List="groupID,affiliateID,cobrandID,regionID,companyID,userID">
	<cfset displayAnd = True>
	<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
		<cfif priceTargetQueryBegin is not "">#priceTargetQueryBegin#<cfset priceTargetQueryBegin = ""></cfif>
		<cfif displayAnd is True> AND (<cfset displayAnd = False><cfelse> OR </cfif>
		(avPriceTarget.primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID(field)#" cfsqltype="cf_sql_integer"> AND avPriceTarget.targetID IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">))
	</cfif>
	<cfif displayAnd is False>)</cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "priceStageDollarOrPercent_priceStageNewOrDeduction") and Trim(Arguments.priceStageDollarOrPercent_priceStageNewOrDeduction) is not "">
	<cfset displayAnd = True>
	<cfloop Index="thisDollarNew" List="#Arguments.priceStageDollarOrPercent_priceStageNewOrDeduction#">
		<cfif ListFind("0,1", ListFirst(Arguments.priceStageDollarOrPercent_priceStageNewOrDeduction, "_")) and ListFind("0,1", ListLast(Arguments.priceStageDollarOrPercent_priceStageNewOrDeduction, "_")) and ListLen(Arguments.priceStageDollarOrPercent_priceStageNewOrDeduction, "_") is 2>
			<cfif priceTargetQueryBegin is not "">#priceTargetQueryBegin#<cfset priceTargetQueryBegin = ""></cfif>
			<cfif displayAnd is True> AND (<cfset displayAnd = False><cfelse> OR </cfif>
			(avPriceTarget.priceStageDollarOrPercent = <cfqueryparam Value="#ListFirst(Arguments.priceStageDollarOrPercent_priceStageNewOrDeduction, '_')#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avPriceTarget.priceStageNewOrDeduction = <cfqueryparam Value="#ListLast(Arguments.priceStageDollarOrPercent_priceStageNewOrDeduction, '_')#)" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		</cfif>
	</cfloop>
	<cfif displayAnd is False>)</cfif>
</cfif>
<cfloop Index="field" List="priceHasGroupTarget,priceHasRegionTarget,priceHasAffiliateTarget,priceHasCobrandTarget,priceHasCompanyTarget,priceHasUserTarget">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
		<cfif priceTargetQueryBegin is not "">#priceTargetQueryBegin#<cfset priceTargetQueryBegin = ""></cfif>
		<cfset fieldID = LCase(Replace(Replace(field, "priceHas", "", "ONE"), "Target", "", "ONE")) & "ID">
		AND avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID(fieldID)#" cfsqltype="cf_sql_integer">
	</cfif>
</cfloop>
<cfif priceTargetQueryBegin is "">)</cfif>
</cfoutput>
