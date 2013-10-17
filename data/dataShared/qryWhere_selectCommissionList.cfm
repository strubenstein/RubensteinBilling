<cfoutput>
avCommission.companyID = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
<cfif StructKeyExists(Arguments, "commissionID") and Arguments.commissionID is not 0 and Application.fn_IsIntegerList(Arguments.commissionID)>AND avCommission.commissionID IN (<cfqueryparam value="#Arguments.commissionID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "commissionID_parent") and Application.fn_IsIntegerList(Arguments.commissionID_parent)>AND avCommission.commissionID_parent IN (<cfqueryparam value="#Arguments.commissionID_parent#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "commissionID_trend") and Arguments.commissionID_trend is not 0 and Application.fn_IsIntegerList(Arguments.commissionID_trend)>AND avCommission.commissionID_trend IN (<cfqueryparam value="#Arguments.commissionID_trend#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "categoryID") and Arguments.categoryID is not 0 and Application.fn_IsIntegerList(Arguments.categoryID)>
	AND avCommission.commissionID IN (SELECT commissionID FROM avCommissionCategory WHERE commissionCategoryStatus = 1 AND (categoryID IN (<cfqueryparam value="#Arguments.categoryID#" cfsqltype="cf_sql_integer" list="yes">)
	<cfif categoryID_parentList is not "">OR (categoryID IN (<cfqueryparam value="#categoryID_parentList#" cfsqltype="cf_sql_integer" list="yes">) AND commissionCategoryChildren = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)</cfif>))
</cfif>
<cfif StructKeyExists(Arguments, "productID") and Arguments.productID is not 0 and Application.fn_IsIntegerList(Arguments.productID)>
	AND avCommission.commissionID IN (SELECT commissionID FROM avCommissionProduct WHERE commissionProductStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND (productID IN (<cfqueryparam value="#Arguments.productID#" cfsqltype="cf_sql_integer" list="yes">)
	<cfif productID_parentList is not "">OR (productID IN (<cfqueryparam value="#productID_parentList#" cfsqltype="cf_sql_integer" list="yes">) AND commissionProductChildren = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)</cfif>))
</cfif>
<cfif StructKeyExists(Arguments, "vendorID_product") and Arguments.vendorID_product is not 0 and Application.fn_IsIntegerList(Arguments.vendorID_product)>
	AND avCommission.commissionID IN (SELECT avCommissionProduct.commissionID FROM avCommissionProduct, avProduct WHERE avCommissionProduct.productID = avProduct.productID AND avCommissionProduct.commissionProductStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND avProduct.vendorID IN (<cfqueryparam value="#Arguments.vendorID_product#" cfsqltype="cf_sql_integer" list="yes">))
</cfif>
<cfloop Index="field" List="commissionStatus,commissionAppliedStatus,commissionAppliesToCategory,commissionAppliesToCategoryChildren,commissionAppliesToProduct,commissionAppliesToProductChildren,commissionAppliesToExistingProducts,commissionAppliesToCustomProducts,commissionAppliesToInvoice,commissionHasMultipleStages,commissionIsParent,commissionPeriodOrInvoiceBased">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>AND avCommission.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "commissionPeriodIntervalType") and Arguments.commissionPeriodIntervalType is not "">
	AND avCommission.commissionPeriodIntervalType <cfif Not ListFind("m,q", Arguments.commissionPeriodIntervalType)> = '' <cfelse> IN (<cfqueryparam value="#Arguments.commissionPeriodIntervalType#" cfsqltype="cf_sql_varchar" list="yes">) </cfif>
</cfif>
<cfloop Index="field" List="commissionStageVolumeDiscount,commissionStageVolumeDollarOrQuantity,commissionStageVolumeStep,commissionStageDollarOrPercent">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>AND avCommissionStage.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "commissionStageInterval_min") and Application.fn_IsIntegerPositive(Arguments.commissionStageInterval_min)
		and StructKeyExists(Arguments, "commissionStageInterval_max") and Application.fn_IsIntegerPositive(Arguments.commissionStageInterval_max)>
	AND avCommissionStage.commissionStageInterval BETWEEN <cfqueryparam value="#Arguments.commissionStageInterval_min#" cfsqltype="cf_sql_smallint"> AND <cfqueryparam value="#Arguments.commissionStageInterval_max#" cfsqltype="cf_sql_smallint">
  <cfelseif StructKeyExists(Arguments, "commissionStageInterval_min") and Application.fn_IsIntegerPositive(Arguments.commissionStageInterval_min)>
	AND avCommissionStage.commissionStageInterval >= <cfqueryparam value="#Arguments.commissionStageInterval_min#" cfsqltype="cf_sql_smallint">
  <cfelseif StructKeyExists(Arguments, "commissionStageInterval_max") and Application.fn_IsIntegerPositive(Arguments.commissionStageInterval_max)>
  	AND avCommissionStage.commissionStageInterval <= <cfqueryparam value="#Arguments.commissionStageInterval_max#" cfsqltype="cf_sql_smallint">
</cfif>
<cfif StructKeyExists(Arguments, "commissionStageIntervalType") and Trim(Arguments.commissionStageIntervalType) is not "">AND avCommissionStage.commissionStageIntervalType IN (<cfqueryparam value="#Arguments.commissionStageIntervalType#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "commissionHasCustomID") and ListFind("0,1", Arguments.commissionHasCustomID)>AND avCommission.commissionID_custom <cfif Arguments.commissionHasCustomID is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "commissionBeforeBeginDate") and ListFind("0,1", Arguments.commissionBeforeBeginDate)>AND avCommission.commissionDateBegin <cfif Arguments.commissionBeforeBeginDate is 1> >= <cfelse> <= </cfif> <cfqueryparam value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "commissionHasEndDate") and ListFind("0,1", Arguments.commissionHasEndDate)>AND avCommission.commissionDateEnd IS <cfif Arguments.commissionHasEndDate is 1> NOT </cfif> NULL</cfif>

<cfif StructKeyExists(Arguments, "commissionDateType")
		and (ListFind(Arguments.commissionDateType, "commissionDateCreated") or ListFind(Arguments.commissionDateType, "commissionDateUpdated")
			or ListFind(Arguments.commissionDateType, "commissionDateBegin") or ListFind(Arguments.commissionDateType, "commissionDateEnd"))
		and ((StructKeyExists(Arguments, "commissionDateFrom") and IsDate(Arguments.commissionDateFrom))
			or (StructKeyExists(Arguments, "commissionDateTo") and IsDate(Arguments.commissionDateTo)))>
	<cfif StructKeyExists(Arguments, "commissionDateFrom") and IsDate(Arguments.commissionDateFrom) and StructKeyExists(Arguments, "commissionDateTo") and IsDate(Arguments.commissionDateTo)>
		<cfset dateClause = "BETWEEN " & CreateODBCDateTime(Arguments.commissionDateFrom) & " AND " & CreateODBCDateTime(Arguments.commissionDateTo)>
	<cfelseif StructKeyExists(Arguments, "commissionDateFrom") and IsDate(Arguments.commissionDateFrom)>
		<cfset dateClause = ">= " & CreateODBCDateTime(Arguments.commissionDateFrom)>
	<cfelseif StructKeyExists(Arguments, "commissionDateTo") and IsDate(Arguments.commissionDateTo)>
		<cfset dateClause = "<= " & CreateODBCDateTime(Arguments.commissionDateTo)>
	</cfif>

	<cfset displayAnd = True>
	<cfloop Index="field" List="commissionDateCreated,commissionDateUpdated,commissionDateBegin,commissionDateEnd">
		<cfif ListFind(Arguments.commissionDateType, field)><cfif displayAnd is True> AND (<cfset displayAnd = False><cfelse> OR </cfif> avCommission.#field# #dateClause# </cfif>
	</cfloop>
	<cfif displayAnd is False>)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "commissionSearchText") and Trim(Arguments.commissionSearchText) is not "" and StructKeyExists(Arguments, "commissionSearchField") and (ListFind(Arguments.commissionSearchField, "commissionName") or ListFind(Arguments.commissionSearchField, "commissionID_custom") or ListFind(Arguments.commissionSearchField, "commissionDescription"))>
	<cfset displayAnd = True>
	<cfloop Index="field" List="commissionName,commissionCode,commissionDescription">
		<cfif ListFind(Arguments.commissionSearchField, field)><cfif displayAnd is True> AND (<cfset displayAnd = False><cfelse> OR </cfif> avCommission.#field# LIKE <cfqueryparam value="%#Arguments.commissionSearchText#%" cfsqltype="cf_sql_varchar"> </cfif>
	</cfloop>
	<cfif displayAnd is False>)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "productSearchText") and Trim(Arguments.productSearchText) is not "" and StructKeyExists(Arguments, "productSearchField") and (ListFind(Arguments.productSearchField, "productName") or ListFind(Arguments.productSearchField, "productID") or ListFind(Arguments.productSearchField, "productID_custom"))>
	<cfset displayAnd = True>
	<cfloop Index="field" List="productName,productID,productID_custom">
		<cfif ListFind(Arguments.productSearchText, field)>
			<cfif displayAnd is True> AND (<cfset displayAnd = False><cfelse> OR </cfif>
			avCommission.commissionID IN
				(
				SELECT avCommissionProduct.commissionID
				FROM avCommissionProduct, avProduct
				WHERE avCommissionProduct.productID = avProduct.productID
					AND avCommissionProduct.commissionProductStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND avProduct.companyID = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
					AND avProduct.#field# LIKE <cfqueryparam value="%#Arguments.productSearchField#%" cfsqltype="cf_sql_integer">
				)
		</cfif>
	</cfloop>
	<cfif displayAnd is False>)</cfif>
</cfif>
<!--- select commission target fields as a sub-query to avoid a huge number of joins and select distinct commissionID --->
<cfset commissionTargetQueryBegin = "AND avCommission.commissionID IN (SELECT avCommissionTarget.commissionID FROM avCommissionTarget WHERE avCommissionTarget.commissionTargetStatus = 1">
<cfloop Index="field" List="groupID,affiliateID,cobrandID,regionID,companyID,userID,vendorID">
	<cfset displayAnd = True>
	<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
		<cfif commissionTargetQueryBegin is not "">#commissionTargetQueryBegin#<cfset commissionTargetQueryBegin = ""></cfif>
		<cfif displayAnd is True> AND (<cfset displayAnd = False><cfelse> OR </cfif>
		((avCommissionTarget.primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID(field)#" cfsqltype="cf_sql_integer"> AND avCommissionTarget.targetID IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">))
			<cfif field is not "groupID">
				OR (avCommissionTarget.primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">
					AND avCommissionTarget.targetID IN (SELECT groupID FROM avGroupTarget WHERE groupTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID(field)#" cfsqltype="cf_sql_integer"> AND targetID IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">)))
			</cfif>
		)
	</cfif>
	<cfif displayAnd is False>)</cfif>
</cfloop>
<cfif commissionTargetQueryBegin is "">)</cfif>
<cfloop Index="field" List="commissionHasGroupTarget,commissionHasAffiliateTarget,commissionHasCobrandTarget,commissionHasCompanyTarget,commissionHasUserTarget,commissionHasVendorTarget">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
		<cfset fieldID = LCase(Replace(Replace(field, "commissionHas", "", "ONE"), "Target", "", "ONE")) & "ID">
		AND avCommission.commissionID <cfif Arguments[field] is 0> NOT </cfif> IN (SELECT commissionID FROM avCommissionTarget WHERE commissionTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID(fieldID)#" cfsqltype="cf_sql_integer">)
	</cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "commissionTargetsAllCompanies") and ListFind("0,1", Arguments.commissionTargetsAllCompanies)>AND avCommission.commissionID <cfif Arguments.commissionTargetsAllCompanies is 0> NOT </cfif> IN (SELECT commissionID FROM avCommissionTarget WHERE commissionTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND targetID = 0 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "commissionTargetsAllUsers") and ListFind("0,1", Arguments.commissionTargetsAllUsers)>AND avCommission.commissionID <cfif Arguments.commissionTargetsAllUsers is 0> NOT </cfif> IN (SELECT commissionID FROM avCommissionTarget WHERE commissionTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND targetID = 0 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('userID')#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "commissionTargetsAllGroups") and ListFind("0,1", Arguments.commissionTargetsAllGroups)>AND avCommission.commissionID <cfif Arguments.commissionTargetsAllGroups is 0> NOT </cfif> IN (SELECT commissionID FROM avCommissionTarget WHERE commissionTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND targetID = 0 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "commissionTargetsAllAffiliates") and ListFind("0,1", Arguments.commissionTargetsAllAffiliates)>AND avCommission.commissionID <cfif Arguments.commissionTargetsAllAffiliates is 0> NOT </cfif> IN (SELECT commissionID FROM avCommissionTarget WHERE commissionTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND targetID = 0 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('affiliateID')#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "commissionTargetsAllCobrands") and ListFind("0,1", Arguments.commissionTargetsAllCobrands)>AND avCommission.commissionID <cfif Arguments.commissionTargetsAllCobrands is 0> NOT </cfif> IN (SELECT commissionID FROM avCommissionTarget WHERE commissionTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND targetID = 0 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('cobrandID')#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "commissionTargetsAllVendors") and ListFind("0,1", Arguments.commissionTargetsAllVendors)>AND avCommission.commissionID <cfif Arguments.commissionTargetsAllVendors is 0> NOT </cfif> IN (SELECT commissionID FROM avCommissionTarget WHERE commissionTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND targetID = 0 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('vendorID')#" cfsqltype="cf_sql_integer">)</cfif>
</cfoutput>
