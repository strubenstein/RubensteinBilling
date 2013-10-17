<cfcomponent DisplayName="CommissionTarget" Hint="Manages targets to which commission applies">

<cffunction Name="insertCommissionTarget" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new commission target. Returns True.">
	<cfargument Name="commissionID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No" Default="0">
	<cfargument Name="targetID" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="commissionTargetStatus" Type="numeric" Required="No" Default="1">

	<cfquery Name="qry_insertCommissionTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCommissionTarget
		(
			commissionID, primaryTargetID, targetID, userID, commissionTargetStatus,
			commissionTargetDateCreated, commissionTargetDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.commissionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.commissionTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateCommissionTarget" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new commission target. Returns True.">
	<cfargument Name="commissionTargetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="commissionTargetStatus" Type="numeric" Required="No">

	<cfquery Name="qry_updateCommissionTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCommissionTarget
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "commissionTargetStatus") and ListFind("0,1", Arguments.commissionTargetStatus)>commissionTargetStatus = <cfqueryparam Value="#Arguments.commissionTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			commissionTargetDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE commissionTargetID = <cfqueryparam Value="#Arguments.commissionTargetID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="copyCommissionTarget" Access="public" Output="No" ReturnType="boolean" Hint="Copy commission target(s) when copy/update commission. Returns True.">
	<cfargument Name="commissionID_old" Type="numeric" Required="Yes">
	<cfargument Name="commissionID_new" Type="numeric" Required="Yes">

	<cfquery Name="qry_copyCommissionTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCommissionTarget
		(
			commissionID, primaryTargetID, targetID, userID, commissionTargetStatus,
			commissionTargetDateCreated, commissionTargetDateUpdated
		)
		SELECT
			<cfqueryparam Value="#Arguments.commissionID_new#" cfsqltype="cf_sql_integer">,
			primaryTargetID,
			targetID,
			userID,
			commissionTargetStatus,
			commissionTargetDateCreated,
			commissionTargetDateUpdated
		FROM avCommissionTarget
		WHERE commissionID = <cfqueryparam Value="#Arguments.commissionID_old#" cfsqltype="cf_sql_integer">
			AND (primaryTargetID <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
				OR targetID <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectCommissionTarget" Access="public" Output="No" ReturnType="query" Hint="Select existing commission target">
	<cfargument Name="commissionTargetID" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="commissionTargetStatus" Type="numeric" Required="No">
	<cfargument Name="commissionTargetWithTargetInfo" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectCommissionTarget = QueryNew("blank")>

	<cfquery Name="qry_selectCommissionTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT commissionTargetID, commissionID, primaryTargetID, targetID, userID,
			commissionTargetStatus, commissionTargetDateCreated, commissionTargetDateUpdated
			<cfif Arguments.commissionTargetWithTargetInfo is True>
				,
				CASE primaryTargetID
				WHEN 0 THEN 'All'
				WHEN #Application.fn_GetPrimaryTargetID("userID")# THEN (SELECT #PreserveSingleQuotes(Application.billingSql.concatLastFirstName)# FROM avUser WHERE avUser.userID = avCommissionTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("companyID")# THEN (SELECT companyName FROM avCompany WHERE avCompany.companyID = avCommissionTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("regionID")# THEN (SELECT regionName FROM avRegion WHERE avRegion.regionID = avCommissionTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("groupID")# THEN (SELECT groupName FROM avGroup WHERE avGroup.groupID = avCommissionTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("cobrandID")# THEN (SELECT cobrandName FROM avCobrand WHERE avCobrand.cobrandID = avCommissionTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("affiliateID")# THEN (SELECT affiliateName FROM avAffiliate WHERE avAffiliate.affiliateID = avCommissionTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("vendorID")# THEN (SELECT vendorName FROM avVendor WHERE avVendor.vendorID = avCommissionTarget.targetID)
				ELSE NULL
				END
				AS targetName
			</cfif>
		FROM avCommissionTarget
		WHERE commissionTargetID <> 0
			<cfloop Index="field" List="commissionTargetID,commissionID,targetID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>AND #field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerNonNegative(Arguments.primaryTargetID)>AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "commissionTargetStatus") and ListFind("0,1", Arguments.commissionTargetStatus)>AND commissionTargetStatus = <cfqueryparam Value="#Arguments.commissionTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		ORDER BY commissionID, primaryTargetID, commissionTargetStatus DESC, targetID
	</cfquery>

	<cfreturn qry_selectCommissionTarget>
</cffunction>

<!--- Used when inserting sales commissions --->
<cffunction Name="selectCommissionListForTarget" Access="public" Output="No" ReturnType="query" Hint="Select existing commission plans for company, sales target(s) and product(s).">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="commissionPeriodOrInvoiceBased" Type="numeric" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="commissionDate" Type="date" Required="No" Default="#Now()#">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="productID_parent" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="categoryID_parent" Type="string" Required="No">

	<cfset var qry_selectCommissionListForTarget = QueryNew("blank")>
	<cfset var checkProduct = False>
	<cfset var checkProductParent = False>
	<cfset var checkCategory = False>
	<cfset var checkCategoryParent = False>

	<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
		<cfset checkProduct = True>
	</cfif>
	<cfif StructKeyExists(Arguments, "productID_parent") and Application.fn_IsIntegerList(Arguments.productID_parent)>
		<cfset checkProductParent = True>
	</cfif>

	<cfif StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerList(Arguments.categoryID)>
		<cfset checkCategory = True>
	</cfif>
	<cfif StructKeyExists(Arguments, "categoryID_parent") and Application.fn_IsIntegerList(Arguments.categoryID_parent)>
		<cfset checkCategoryParent = True>
	</cfif>

	<cfquery Name="qry_selectCommissionListForTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avCommission.commissionID, avCommission.commissionAppliesToInvoice,
			avCommission.commissionAppliesToCustomProducts, avCommission.commissionAppliesToExistingProducts,
			avCommission.commissionAppliedStatus, avCommission.commissionDateBegin, avCommission.commissionDateEnd,
			avCommission.commissionPeriodOrInvoiceBased, avCommission.commissionPeriodIntervalType,
			avCommissionTarget.commissionTargetDateCreated, avCommissionTarget.commissionTargetStatus,
			<cfif checkProduct is True>
				avCommissionProduct.productID, avCommissionProduct.commissionProductChildren,
			<cfelse>
				NULL AS productID, NULL AS commissionProductChildren,
			</cfif>
			<cfif checkCategory is True>
				avCommissionCategory.categoryID, avCommissionCategory.commissionCategoryChildren
			<cfelse>
				NULL AS categoryID, NULL AS commissionCategoryChildren
			</cfif>
		FROM avCommission
			INNER JOIN avCommissionTarget ON avCommission.commissionID = avCommissionTarget.commissionID
			<cfif checkProduct is True>
				LEFT OUTER JOIN avCommissionProduct ON avCommission.commissionID = avCommissionProduct.commissionID
					AND avCommissionProduct.commissionProductStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND (avCommissionProduct.productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
						<cfif checkProductParent is True>
							OR (avCommissionProduct.productID IN (<cfqueryparam Value="#Arguments.productID_parent#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
							AND avCommissionProduct.commissionProductChildren = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)
						</cfif>
						)
				<cfif checkCategory is True>
					LEFT OUTER JOIN avCommissionCategory ON avCommission.commissionID = avCommissionCategory.commissionID
						AND avCommissionCategory.commissionCategoryStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
						AND	(avCommissionCategory.categoryID IN (<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
							<cfif checkCategoryParent is True>
								OR (avCommissionCategory.categoryID IN (<cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
								AND avCommissionCategory.commissionCategoryChildren = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)
							</cfif>
							)
				</cfif><!--- check categories --->
			</cfif><!--- /check products --->
		WHERE avCommission.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND avCommission.commissionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avCommission.commissionDateBegin <= <cfqueryparam Value="#CreateODBCDateTime(Arguments.commissionDate)#" cfsqltype="cf_sql_timestamp">
			AND (avCommission.commissionDateEnd IS NULL OR avCommission.commissionDateEnd >= <cfqueryparam Value="#CreateODBCDateTime(Arguments.commissionDate)#" cfsqltype="cf_sql_timestamp">)
			<cfif StructKeyExists(Arguments, "commissionPeriodOrInvoiceBased") and ListFind("0,1", Arguments.commissionPeriodOrInvoiceBased)>
				AND avCommission.commissionPeriodOrInvoiceBased = <cfqueryparam Value="#Arguments.commissionPeriodOrInvoiceBased#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<!--- applies to target (recipient) of commission --->
			AND avCommissionTarget.commissionTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND	(avCommission.commissionAppliesToInvoice = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				<cfif checkProduct is True> OR avCommissionProduct.productID IS NOT NULL</cfif>
				<cfif checkCategory is True>OR avCommissionCategory.categoryID IS NOT NULL</cfif>)
			<cfif Not StructKeyExists(Arguments, "targetID") or Not Application.fn_IsIntegerPositive(Arguments.targetID)>
				AND avCommissionTarget.primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND avCommissionTarget.targetID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfelse>
				AND ((avCommissionTarget.primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
					AND avCommissionTarget.targetID IN (<cfqueryparam Value="0,#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
					OR (avCommissionTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("groupID")#" cfsqltype="cf_sql_integer">
						AND avCommissionTarget.targetID IN 
						(
						SELECT groupID
						FROM avGroupTarget
						WHERE groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
							AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
							AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
						)))
			</cfif>
		ORDER BY avCommission.commissionID
	</cfquery>

	<cfreturn qry_selectCommissionListForTarget>
</cffunction>

</cfcomponent>
