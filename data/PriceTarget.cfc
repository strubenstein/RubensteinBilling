<cfcomponent DisplayName="PriceTarget" Hint="Manages who has permission for custom price">

<cffunction Name="insertPriceTarget" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new price target. Returns True.">
	<cfargument Name="priceID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No" Default="0">
	<cfargument Name="targetID" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="priceTargetStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="priceTargetOrder" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_insertPriceTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPriceTarget
		(
			priceID, primaryTargetID, targetID, userID, priceTargetStatus,
			priceTargetOrder, priceTargetDateCreated, priceTargetDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.priceTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.priceTargetOrder#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updatePriceTarget" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new price target. Returns True.">
	<cfargument Name="priceTargetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="priceTargetStatus" Type="numeric" Required="No">
	<cfargument Name="priceTargetOrder" Type="numeric" Required="No">

	<cfquery Name="qry_updatePriceTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPriceTarget
		SET
			<cfif StructKeyExists(Arguments, "userID")>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "priceTargetStatus")>priceTargetStatus = <cfqueryparam Value="#Arguments.priceTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "priceTargetOrder")>priceTargetOrder = <cfqueryparam Value="#Arguments.priceTargetOrder#" cfsqltype="cf_sql_integer">,</cfif>
			priceTargetDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE priceTargetID = <cfqueryparam Value="#Arguments.priceTargetID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="copyPriceTarget" Access="public" Output="No" ReturnType="boolean" Hint="Copy price target when copy/update price. Returns True.">
	<cfargument Name="priceID_old" Type="numeric" Required="Yes">
	<cfargument Name="priceID_new" Type="numeric" Required="Yes">

	<cfquery Name="qry_copyPriceTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPriceTarget
		(
			priceID, primaryTargetID, targetID, userID, priceTargetStatus,
			priceTargetOrder, priceTargetDateCreated, priceTargetDateUpdated
		)
		SELECT
			<cfqueryparam Value="#Arguments.priceID_new#" cfsqltype="cf_sql_integer">,
			primaryTargetID,
			targetID,
			userID,
			priceTargetStatus,
			priceTargetOrder,
			priceTargetDateCreated,
			priceTargetDateUpdated
		FROM avPriceTarget
		WHERE priceID = #Arguments.priceID_old#
			AND (primaryTargetID <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
				OR targetID <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPriceTarget" Access="public" Output="No" ReturnType="query" Hint="Select Existing Price Target">
	<cfargument Name="priceTargetID" Type="numeric" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="numeric" Required="No">
	<cfargument Name="priceTargetStatus" Type="numeric" Required="No">
	<cfargument Name="priceTargetOrder" Type="numeric" Required="No">
	<cfargument Name="priceTargetWithTargetInfo" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectPriceTarget = QueryNew("blank")>

	<cfquery Name="qry_selectPriceTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT priceTargetID, priceID, primaryTargetID, targetID, userID, priceTargetStatus,
			priceTargetOrder, priceTargetDateCreated, priceTargetDateUpdated
			<cfif Arguments.priceTargetWithTargetInfo is True>
				,
				CASE primaryTargetID
				WHEN 0 THEN 'All Customers'
				WHEN #Application.fn_GetPrimaryTargetID("userID")# THEN (SELECT #PreserveSingleQuotes(Application.billingSql.concatLastFirstName)# FROM avUser WHERE avUser.userID = avPriceTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("companyID")# THEN (SELECT companyName FROM avCompany WHERE avCompany.companyID = avPriceTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("regionID")# THEN (SELECT regionName FROM avRegion WHERE avRegion.regionID = avPriceTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("groupID")# THEN (SELECT groupName FROM avGroup WHERE avGroup.groupID = avPriceTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("cobrandID")# THEN (SELECT cobrandName FROM avCobrand WHERE avCobrand.cobrandID = avPriceTarget.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("affiliateID")# THEN (SELECT affiliateName FROM avAffiliate WHERE avAffiliate.affiliateID = avPriceTarget.targetID)
				ELSE NULL
				END
				AS targetName
			</cfif>
		FROM avPriceTarget
		WHERE priceTargetID <> 0
			<cfif StructKeyExists(Arguments, "priceTargetID") and Application.fn_IsIntegerNonNegative(Arguments.priceTargetID)>AND priceTargetID = <cfqueryparam Value="#Arguments.priceTargetID#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "priceID") and Application.fn_IsIntegerList(Arguments.priceID)>AND priceID IN (<cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerNonNegative(Arguments.primaryTargetID)>AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerNonNegative(Arguments.targetID)>AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "priceTargetStatus") and ListFind("0,1", Arguments.priceTargetStatus)>AND priceTargetStatus = <cfqueryparam Value="#Arguments.priceTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		ORDER BY priceID, primaryTargetID, priceTargetStatus DESC, targetID, priceTargetOrder
	</cfquery>

	<cfreturn qry_selectPriceTarget>
</cffunction>

<!--- used when generating invoices --->
<cffunction Name="selectPriceListForTarget" Access="public" Output="No" ReturnType="query" Hint="Select Existing Prices For Category or Product and target">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="categoryID_parent" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="priceAppliesToInvoice" Type="numeric" Required="No">
	<cfargument Name="returnPriceVolumeDiscountMinimum" Type="boolean" Required="No" Default="False">
	<cfargument Name="priceHasMultipleStages" Type="numeric" Required="No">

	<cfset var qry_selectPriceListForTarget = QueryNew("blank")>

	<cfquery Name="qry_selectPriceListForTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT DISTINCT(avPriceStage.priceStageID), avPriceStage.priceStageOrder, avPriceStage.priceStageAmount, avPriceStage.priceStageDollarOrPercent,
			avPriceStage.priceStageNewOrDeduction, avPriceStage.priceStageVolumeDiscount, avPriceStage.priceStageVolumeDollarOrQuantity,
			avPriceStage.priceStageVolumeStep, avPriceStage.priceStageInterval, avPriceStage.priceStageIntervalType, avPriceStage.priceStageText,
			avPriceStage.priceStageDescription, avPrice.priceID, avPrice.priceName, avPrice.categoryID, avPrice.productID,
			avPrice.priceAppliesToCategoryChildren, avPrice.priceAppliesToCategory, avPrice.priceAppliesToProduct, avPrice.priceAppliesToProductChildren,
			avPrice.priceAppliesToAllProducts, avPrice.priceAppliesToAllCustomers, avPrice.priceAppliesToInvoice, avPrice.priceCode, avPrice.priceCodeRequired,
			avPrice.priceAppliedStatus, avPrice.priceQuantityMinimumPerOrder, avPrice.priceID_custom, avPrice.priceQuantityMaximumAllCustomers,
			avPrice.priceQuantityMaximumPerCustomer, avPrice.priceHasMultipleStages, avPrice.priceStatus, avPrice.priceDateBegin, avPrice.priceDateEnd,
			CASE avPriceTarget.primaryTargetID
			WHEN #Application.fn_GetPrimaryTargetID("userID")# THEN 1
			WHEN #Application.fn_GetPrimaryTargetID("companyID")# THEN 2
			WHEN #Application.fn_GetPrimaryTargetID("groupID")# THEN 3
			WHEN #Application.fn_GetPrimaryTargetID("affiliateID")# THEN 4
			WHEN #Application.fn_GetPrimaryTargetID("cobrandID")# THEN 5
			WHEN #Application.fn_GetPrimaryTargetID("regionID")# THEN 6
			ELSE 7
			END
			AS priceTargetPriority
			<cfif StructKeyExists(Arguments, "returnPriceVolumeDiscountMinimum") and Arguments.returnPriceVolumeDiscountMinimum is True>
				,
				CASE avPriceStage.priceStageVolumeDiscount
				WHEN 0
					THEN NULL
				ELSE
					(
					SELECT priceVolumeDiscountAmount
					FROM avPriceVolumeDiscount
					WHERE avPriceVolumeDiscount.priceStageID = avPriceStage.priceStageID
						AND avPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					)
				END
				AS priceVolumeDiscountMinimum
			</cfif>
		FROM avPrice, avPriceStage, avPriceTarget
		WHERE avPrice.priceID = avPriceStage.priceID
			AND avPrice.priceID = avPriceTarget.priceID
			<cfif StructKeyExists(Arguments, "priceID") and Application.fn_IsIntegerList(Arguments.priceID)>
				AND (avPrice.priceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					OR avPrice.priceID IN (<cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
			<cfelse>
				AND avPrice.priceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			AND avPrice.priceApproved = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avPriceTarget.priceTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			<!--- 
			AND avPrice.priceDateBegin <= #CreateODBCDateTime(Now())#
			AND (avPrice.priceDateEnd IS NULL OR avPrice.priceDateEnd >= #CreateODBCDateTime(Now())#)
			--->
			AND avPrice.companyID = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "priceHasMultipleStages") and ListFind("0,1", Arguments.priceHasMultipleStages)>
				AND avPrice.priceHasMultipleStages = <cfqueryparam Value="#Arguments.priceHasMultipleStages#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "priceAppliesToInvoice") and Arguments.priceAppliesToInvoice is 1>
				AND avPrice.priceAppliesToInvoice = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			<cfelse>
				AND (
					avPrice.priceAppliesToAllProducts = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
						OR avPrice.productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
						OR	(
							avPrice.priceAppliesToProductChildren = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
							AND
							avPrice.productID IN
								(
								SELECT productID_parent
								FROM avProduct
								WHERE productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
									AND productID_parent <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
								)
							)
					</cfif>
					<cfif StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerList(Arguments.categoryID)>
						OR avPrice.categoryID IN (<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					</cfif>
					<cfif StructKeyExists(Arguments, "categoryID_parent") and Application.fn_IsIntegerList(Arguments.categoryID_parent)>
						OR (avPrice.priceAppliesToCategoryChildren = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
							AND avPrice.categoryID IN (<cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
					</cfif>
					)
			</cfif>
			AND (
				avPrice.priceAppliesToAllCustomers = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
					OR (avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("userID")#" cfsqltype="cf_sql_integer">
						AND avPriceTarget.targetID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
					OR (avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("groupID")#" cfsqltype="cf_sql_integer">
						AND avPriceTarget.targetID IN 
							(
							SELECT groupID
							FROM avGroupTarget
							WHERE groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
								AND primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("userID")#" cfsqltype="cf_sql_integer">
								AND targetID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
							)
						)
				</cfif>
				<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID)>
					OR (avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("companyID")#" cfsqltype="cf_sql_integer">
						AND avPriceTarget.targetID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
					OR (avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("groupID")#" cfsqltype="cf_sql_integer">
						AND avPriceTarget.targetID IN
							(
							SELECT groupID
							FROM avGroupTarget
							WHERE groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
								AND primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("companyID")#" cfsqltype="cf_sql_integer">
								AND targetID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
							)
						)
					OR (avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("affiliateID")#" cfsqltype="cf_sql_integer">
						AND avPriceTarget.targetID IN (SELECT affiliateID FROM avCompany WHERE companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)))
					OR (avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("cobrandID")#" cfsqltype="cf_sql_integer">
						AND avPriceTarget.targetID IN (SELECT cobrandID FROM avCompany WHERE companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)))
				</cfif>
				<cfif StructKeyExists(Arguments, "regionID") and Application.fn_IsIntegerList(Arguments.regionID)>
					OR (avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("regionID")#" cfsqltype="cf_sql_integer">
						AND avPriceTarget.targetID IN (<cfqueryparam Value="#Arguments.regionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
				</cfif>
				)
		ORDER BY priceTargetPriority, avPrice.priceAppliesToProduct DESC, avPrice.priceAppliesToProductChildren DESC,
			avPrice.priceAppliesToCategory DESC, avPrice.priceAppliesToCategoryChildren DESC,
			avPrice.priceAppliesToAllProducts DESC, avPrice.priceID, avPriceStage.priceStageOrder
	</cfquery>

	<cfreturn qry_selectPriceListForTarget>
</cffunction>

</cfcomponent>
