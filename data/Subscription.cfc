<cfcomponent DisplayName="Subscription" Hint="Manages inserting, updating, deleting and viewing subscriptions to products">

<cffunction name="maxlength_Subscription" access="public" output="no" returnType="struct">
	<cfset var maxlength_Subscription = StructNew()>

	<cfset maxlength_Subscription.subscriptionIntervalType = 5>
	<cfset maxlength_Subscription.subscriptionName = 255>
	<cfset maxlength_Subscription.subscriptionProductID_custom = 50>
	<cfset maxlength_Subscription.subscriptionDescription = 1000>
	<cfset maxlength_Subscription.subscriptionQuantity = 4>
	<cfset maxlength_Subscription.subscriptionPriceUnit = 4>
	<cfset maxlength_Subscription.subscriptionPriceNormal = 4>
	<cfset maxlength_Subscription.subscriptionDiscount = 4>
	<cfset maxlength_Subscription.subscriptionID_custom = 50>

	<cfreturn maxlength_Subscription>
</cffunction>

<cffunction Name="insertSubscription" Access="public" Output="no" ReturnType="numeric" Hint="Insert subscription for line item">
	<cfargument Name="subscriberID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_cancel" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="subscriptionCompleted" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionDateBegin" Type="date" Required="No" Default="#CreateODBCDate(Now())#">
	<cfargument Name="subscriptionDateEnd" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionContinuesAfterEnd" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionEndByDateOrAppliedMaximum" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionAppliedMaximum" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionAppliedCount" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionIntervalType" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionInterval" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionID_parent" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionID_trend" Type="numeric" Required="No" Default="0">
	<cfargument Name="productID" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceID" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceStageID" Type="numeric" Required="No" Default="0">
	<cfargument Name="regionID" Type="numeric" Required="No" Default="0">
	<cfargument Name="categoryID" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionProductID_custom" Type="string" Required="No" Default="">
	<cfargument Name="productParameterExceptionID" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionQuantity" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionQuantityVaries" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionName" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionID_custom" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionDescription" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionDescriptionHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionPriceNormal" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionPriceUnit" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionDiscount" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionDateProcessNext" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionDateProcessLast" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionProRate" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionIsRollup" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionID_rollup" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionCategoryMultiple" Type="numeric" Required="No" Default="0">

	<cfset var qry_insertSubscription = QueryNew("blank")>
	<cfset var subscriptionID = 0>
	<cfset var primaryTargetID = 0>
	<cfset var qry_insertSubscription_updateOrder_select = QueryNew("blank")>

	<cfif IsDate(Arguments.subscriptionDateBegin) and Not IsDate(Arguments.subscriptionDateEnd)
			and Arguments.subscriptionEndByDateOrAppliedMaximum is not 0 and Arguments.subscriptionAppliedMaximum is not 0>
		<cfset Arguments.subscriptionDateEnd = DateAdd(Arguments.subscriptionIntervalType, Arguments.subscriptionInterval * Arguments.subscriptionAppliedMaximum, Arguments.subscriptionDateBegin)>
	</cfif>

	<cfif Not StructKeyExists(Arguments, "subscriptionPriceNormal") or Not IsNumeric(Arguments.subscriptionPriceNormal)>
		<cfset Arguments.subscriptionPriceNormal = Arguments.subscriptionPriceUnit>
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.Subscription" method="maxlength_Subscription" returnVariable="maxlength_Subscription" />

	<cftransaction>
	<cfquery Name="qry_insertSubscription" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avSubscription
		(
			subscriberID, userID_author, userID_cancel, subscriptionStatus, subscriptionCompleted,
			subscriptionDateBegin, subscriptionDateEnd, subscriptionEndByDateOrAppliedMaximum,
			subscriptionContinuesAfterEnd, subscriptionAppliedMaximum, subscriptionAppliedCount,
			subscriptionIntervalType, subscriptionInterval, subscriptionID_parent, subscriptionID_trend,
			productID, priceID, priceStageID, regionID, categoryID, subscriptionProductID_custom,
			productParameterExceptionID, subscriptionQuantity, subscriptionQuantityVaries, subscriptionOrder,
			subscriptionName, subscriptionID_custom, subscriptionDescription, subscriptionDescriptionHtml,
			subscriptionPriceNormal, subscriptionPriceUnit, subscriptionDiscount, subscriptionDateProcessNext,
			subscriptionDateProcessLast, subscriptionProRate, subscriptionIsRollup, subscriptionID_rollup,
			subscriptionCategoryMultiple, subscriptionDateCreated, subscriptionDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_cancel#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriptionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriptionCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "subscriptionDateBegin") or Not IsDate(Arguments.subscriptionDateBegin)>#Application.billingSql.sql_nowDateTime#<cfelse><cfqueryparam Value="#Arguments.subscriptionDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not StructKeyExists(Arguments, "subscriptionDateEnd") or Not IsDate(Arguments.subscriptionDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriptionDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not ListFind("0,1", Arguments.subscriptionEndByDateOrAppliedMaximum)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriptionEndByDateOrAppliedMaximum#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfqueryparam Value="#Arguments.subscriptionContinuesAfterEnd#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriptionAppliedMaximum#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.subscriptionAppliedCount#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.subscriptionIntervalType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Subscription.subscriptionIntervalType#">,
			<cfqueryparam Value="#Arguments.subscriptionInterval#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.subscriptionID_parent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriptionID_trend#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.priceStageID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.regionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriptionProductID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Subscription.subscriptionProductID_custom#">,
			<cfqueryparam Value="#Arguments.productParameterExceptionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriptionQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_Subscription.subscriptionQuantity#">,
			<cfqueryparam Value="#Arguments.subscriptionQuantityVaries#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriptionOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.subscriptionName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Subscription.subscriptionName#">,
			<cfqueryparam Value="#Arguments.subscriptionID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Subscription.subscriptionID_custom#">,
			<cfqueryparam Value="#Arguments.subscriptionDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Subscription.subscriptionDescription#">,
			<cfqueryparam Value="#Arguments.subscriptionDescriptionHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriptionPriceNormal#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.subscriptionPriceUnit#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.subscriptionDiscount#" cfsqltype="cf_sql_money">,
			<cfif Not StructKeyExists(Arguments, "subscriptionDateProcessNext") or Not IsDate(Arguments.subscriptionDateProcessNext)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriptionDateProcessNext#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not StructKeyExists(Arguments, "subscriptionDateProcessLast") or Not IsDate(Arguments.subscriptionDateProcessLast)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriptionDateProcessLast#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.subscriptionProRate#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriptionIsRollup#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriptionID_rollup#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriptionCategoryMultiple#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "subscriptionID", "ALL")#;
	</cfquery>

	<cfset subscriptionID = qry_insertSubscription.primaryKeyID>
	<cfif Arguments.subscriptionID_trend is 0>
		<cfquery Name="qry_insertSubscription_trend" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSubscription
			SET subscriptionID_trend = subscriptionID
			WHERE subscriptionID = <cfqueryparam Value="#subscriptionID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>

	<cfif Application.fn_IsIntegerList(Arguments.userID) and Arguments.userID is not 0>
		<cfquery Name="qry_insertSubscriptionUser" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			INSERT INTO avSubscriptionUser (subscriptionID, userID)
			SELECT #subscriptionID#, userID
			FROM avUser
			WHERE userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>
	</cfif>

	<cfif Arguments.subscriptionOrder lte 0>
		<cfquery Name="qry_insertSubscription_updateOrder_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT MAX(subscriptionOrder) AS maxSubscriptionOrder
			FROM avSubscription
			WHERE subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery Name="qry_insertSubscription_updateOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSubscription
			SET subscriptionOrder = <cfqueryparam Value="1" cfsqltype="cf_sql_smallint"> + 
				<cfif Not IsNumeric(qry_insertSubscription_updateOrder_select.maxSubscriptionOrder)>
					<cfqueryparam Value="0" cfsqltype="cf_sql_smallint">
				<cfelse>
					<cfqueryparam Value="#qry_insertSubscription_updateOrder_select.maxSubscriptionOrder#" cfsqltype="cf_sql_smallint">
				</cfif>
			WHERE subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">
				AND subscriptionID = <cfqueryparam Value="#subscriptionID#" cfsqltype="cf_sql_integer">
		</cfquery>
	<cfelse>
		<cfquery Name="qry_updateSubscriptionOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSubscription
			SET subscriptionOrder = subscriptionOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">
				AND subscriptionID <> <cfqueryparam Value="#subscriptionID#" cfsqltype="cf_sql_integer">
				AND subscriptionOrder >= <cfqueryparam Value="#Arguments.subscriptionOrder#" cfsqltype="cf_sql_smallint">
		</cfquery>
	</cfif>

	<!--- if updating existing subscription, update targetID of notes,tasks,custom status and custom fields --->
	<cfif Arguments.subscriptionID_parent is not 0>
		<cfset primaryTargetID = Application.fn_GetPrimaryTargetID("subscriptionID")>
		<cfquery Name="qry_updateSubscriptionID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfloop Index="tableName" List="avTask,avNote,avStatusHistory,avCustomFieldBit,avCustomFieldDateTime,avCustomFieldDecimal,avCustomFieldInt,avCustomFieldVarchar">
				UPDATE #tableName#
				SET targetID = <cfqueryparam Value="#subscriptionID#" cfsqltype="cf_sql_integer">
				WHERE primaryTargetID = <cfqueryparam Value="#primaryTargetID#" cfsqltype="cf_sql_integer">
					AND targetID = <cfqueryparam Value="#Arguments.subscriptionID_parent#" cfsqltype="cf_sql_integer">;
			</cfloop>
		</cfquery>
	</cfif>

	<cfif Arguments.subscriptionID_rollup is not 0>
		<cfquery Name="qry_updateSubscriptionIsRollup" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSubscription
			SET subscriptionIsRollup = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			WHERE subscriptionID = <cfqueryparam Value="#subscriptionID_rollup#" cfsqltype="cf_sql_integer">
		</cfquery>
	<cfelseif Arguments.subscriptionID_parent is not 0>
		<cfquery Name="qry_updateSubscriptionID_rollup" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSubscription
			SET subscriptionID_rollup = <cfqueryparam Value="#subscriptionID#" cfsqltype="cf_sql_integer">
			WHERE subscriptionID_rollup = <cfqueryparam Value="#Arguments.subscriptionID_parent#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	</cftransaction>

	<cfreturn qry_insertSubscription.primaryKeyID>
</cffunction>

<cffunction Name="updateSubscription" Access="public" Output="No" ReturnType="boolean" Hint="Update status of existing subscription for specified subscriber to inactive">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="userID_cancel" Type="numeric" Required="No">

	<cftransaction>
	<cfquery Name="qry_selectSubscriptionOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT subscriptionOrder, subscriberID, subscriptionIsRollup, subscriptionID_rollup
		FROM avSubscription
		WHERE subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery Name="qry_updateSubscription" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avSubscription
		SET	
			<cfif StructKeyExists(Arguments, "userID_cancel") and Application.fn_IsIntegerNonNegative(Arguments.userID_cancel)>
				userID_cancel = <cfqueryparam Value="#Arguments.userID_cancel#" cfsqltype="cf_sql_integer">,
			</cfif>
			subscriptionStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			subscriptionOrder = <cfqueryparam Value="0" cfsqltype="cf_sql_smallint">,
			subscriptionDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">;

		<cfif qry_selectSubscriptionOrder.subscriptionOrder is not 0>
			UPDATE avSubscription
			SET subscriptionOrder = subscriptionOrder - <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE subscriberID = <cfqueryparam Value="#qry_selectSubscriptionOrder.subscriberID#" cfsqltype="cf_sql_integer">
				AND subscriptionOrder > <cfqueryparam Value="#qry_selectSubscriptionOrder.subscriptionOrder#" cfsqltype="cf_sql_smallint">;
		</cfif>
	</cfquery>

	<!--- if this subscription is roll up to, de-roll up other subscriptions --->
	<cfif qry_selectSubscriptionOrder.subscriptionIsRollup is 1>
		<cfquery Name="qry_updateSubscriptionID_rollup" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSubscription
			SET subscriptionID_rollup = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			WHERE subscriberID = <cfqueryparam Value="#qry_selectSubscriptionOrder.subscriberID#" cfsqltype="cf_sql_integer">
				AND subscriptionID_rollup = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
		</cfquery>
	<!--- if this subscription rolls up, check that other subscriptions roll up to master. if not, master is no longer a roll up --->
	<cfelseif qry_selectSubscriptionOrder.subscriptionID_rollup is not 0>
		<cfquery Name="qry_checkSubscriptionIsRollup" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT COUNT(subscriptionID) AS subscriptionRollupCount
			FROM avSubscription
			WHERE subscriberID = <cfqueryparam Value="#qry_selectSubscriptionOrder.subscriberID#" cfsqltype="cf_sql_integer">
				AND subscriptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND subscriptionID <> <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
				AND subscriptionID_rollup = <cfqueryparam Value="#qry_selectSubscriptionOrder.subscriptionID_rollup#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfif Not Application.fn_IsIntegerPositive(qry_checkSubscriptionIsRollup.subscriptionRollupCount)>
			<cfquery Name="qry_updateSubscriptionID_rollup" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				UPDATE avSubscription
				SET subscriptionIsRollup = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				WHERE subscriptionID = <cfqueryparam Value="#qry_selectSubscriptionOrder.subscriptionID_rollup#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="updateSubscription_process" Access="public" Output="No" ReturnType="boolean" Hint="Update status of existing subscription after processing subscriber">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="incrementSubscriptionAppliedCount" Type="boolean" Required="No" Default="False">
	<cfargument Name="subscriptionDateProcessLast" Type="string" Required="No">
	<cfargument Name="subscriptionDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriptionCompleted" Type="numeric" Required="No">
	<cfargument Name="priceStageID" Type="numeric" Required="No">

	<cfset var displayComma = False>

	<cfquery Name="qry_updateSubscription_process" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avSubscription
		SET 
			<cfif StructKeyExists(Arguments, "incrementSubscriptionAppliedCount") and Arguments.incrementSubscriptionAppliedCount is True>
				<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriptionAppliedCount = subscriptionAppliedCount + <cfqueryparam Value="1" cfsqltype="cf_sql_smallint"></cfif>
			<cfif StructKeyExists(Arguments, "subscriptionDateProcessLast")>
				<cfif Arguments.subscriptionDateProcessLast is "">
					<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriptionDateProcessLast = NULL
				<cfelseif IsDate(Arguments.subscriptionDateProcessLast)>
					<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriptionDateProcessLast = <cfqueryparam Value="#Arguments.subscriptionDateProcessLast#" cfsqltype="cf_sql_timestamp">
				</cfif>
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriptionDateProcessNext")>
				<cfif Arguments.subscriptionDateProcessNext is "">
					<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriptionDateProcessNext = NULL
				<cfelseif IsDate(Arguments.subscriptionDateProcessNext)>
					<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriptionDateProcessNext = <cfqueryparam Value="#Arguments.subscriptionDateProcessNext#" cfsqltype="cf_sql_timestamp">
				</cfif>
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriptionCompleted") and ListFind("0,1", Arguments.subscriptionCompleted)>
				<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriptionCompleted = <cfqueryparam Value="#Arguments.subscriptionCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "priceStageID") and Application.fn_IsIntegerNonNegative(Arguments.priceStageID)>
				<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>priceStageID = <cfqueryparam Value="#Arguments.priceStageID#" cfsqltype="cf_sql_integer">
			</cfif>
		WHERE subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateSubscriptionStatus" Access="public" Output="No" ReturnType="boolean" Hint="Updates all subscriptions to inactive status for specified subscriber">
	<cfargument Name="subscriberID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionStatus" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_updateSubscriptionStatus" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avSubscription
		SET	subscriptionStatus = <cfqueryparam Value="#Arguments.subscriptionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			subscriptionDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateSubscriptionCompleted" Access="public" Output="No" ReturnType="boolean" Hint="Updates subscriptions to reflect they are completed">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionCompleted" Type="numeric" Required="No" Default="1">

	<cfif Not Application.fn_IsIntegerList(Arguments.subscriberID) or Not ListFind("0,1", Arguments.subscriptionCompleted)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateSubscriptionCompleted" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSubscription
			SET	subscriptionCompleted = <cfqueryparam Value="#Arguments.subscriptionCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				subscriptionDateUpdated = #Application.billingSql.sql_nowDateTime#
			WHERE subscriptionID IN (<cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectSubscription" Access="public" Output="No" ReturnType="query" Hint="Select existing subscription">
	<cfargument Name="subscriptionID" Type="string" Required="No">

	<cfset var qry_selectSubscription = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.subscriptionID)>
		<cfset Arguments.subscriptionID = 0>
	</cfif>

	<cfquery Name="qry_selectSubscription" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT subscriberID, subscriptionID, userID_author, userID_cancel, subscriptionStatus, subscriptionCompleted,
			subscriptionDateBegin, subscriptionDateEnd, subscriptionAppliedMaximum, subscriptionAppliedCount,
			subscriptionIntervalType, subscriptionInterval, subscriptionID_parent, subscriptionID_trend,
			productID, priceID, priceStageID, regionID, categoryID, subscriptionProductID_custom,
			subscriptionQuantity, subscriptionQuantityVaries, subscriptionOrder, subscriptionName, subscriptionID_custom,
			subscriptionDescription, subscriptionDescriptionHtml, subscriptionPriceNormal, subscriptionPriceUnit,
			subscriptionDiscount, subscriptionDateProcessNext, subscriptionDateProcessLast, productParameterExceptionID,
			subscriptionProRate, subscriptionEndByDateOrAppliedMaximum, subscriptionContinuesAfterEnd, subscriptionIsRollup,
			subscriptionID_rollup, subscriptionCategoryMultiple, subscriptionDateCreated, subscriptionDateUpdated
		FROM avSubscription
		WHERE subscriptionID IN (<cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectSubscription>
</cffunction>

<cffunction Name="selectSubscriptionList" Access="public" Output="No" ReturnType="query" Hint="Select all or specified subscriptions">
	<cfargument Name="subscriberID" Type="string" Required="Yes">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="subscriptionID_parent" Type="string" Required="No">
	<cfargument Name="subscriptionID_trend" Type="string" Required="No">
	<cfargument Name="subscriptionStatus" Type="numeric" Required="No">
	<cfargument Name="subscriptionCompleted" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantityVaries" Type="numeric" Required="No">
	<cfargument Name="subscriptionDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriptionDateProcessNext_before" Type="boolean" Required="No" Default="False">
	<cfargument Name="subscriptionIsRollup" Type="numeric" Required="No">
	<cfargument Name="subscriptionID_rollup" Type="string" Required="No">

	<cfset var qry_selectSubscriptionList = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.subscriberID)>
		<cfset Arguments.subscriberID = 0>
	</cfif>

	<cfquery Name="qry_selectSubscriptionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avSubscription.subscriberID, avSubscription.subscriptionID, avSubscription.userID_author,
			avSubscription.userID_cancel, avSubscription.subscriptionStatus, avSubscription.subscriptionCompleted,
			avSubscription.subscriptionDateBegin, avSubscription.subscriptionDateEnd, avSubscription.subscriptionAppliedMaximum,
			avSubscription.subscriptionAppliedCount, avSubscription.subscriptionIntervalType, avSubscription.subscriptionInterval,
			avSubscription.subscriptionID_parent, avSubscription.subscriptionID_trend, avSubscription.productID,
			avSubscription.priceID, avSubscription.priceStageID, avSubscription.regionID, avSubscription.categoryID,
			avSubscription.subscriptionProductID_custom, avSubscription.subscriptionQuantity, avSubscription.subscriptionQuantityVaries,
			avSubscription.subscriptionOrder, avSubscription.subscriptionName, avSubscription.subscriptionID_custom,
			avSubscription.subscriptionDescription, avSubscription.subscriptionDescriptionHtml, avSubscription.subscriptionPriceNormal,
			avSubscription.subscriptionPriceUnit, avSubscription.subscriptionDiscount, avSubscription.subscriptionDateProcessNext,
			avSubscription.subscriptionDateProcessLast, avSubscription.productParameterExceptionID, avSubscription.subscriptionProRate,
			avSubscription.subscriptionEndByDateOrAppliedMaximum, avSubscription.subscriptionContinuesAfterEnd, avSubscription.subscriptionIsRollup,
			avSubscription.subscriptionID_rollup, avSubscription.subscriptionCategoryMultiple, avSubscription.subscriptionDateCreated, avSubscription.subscriptionDateUpdated,
			avProduct.vendorID, avProduct.productCode, avProduct.productID_custom, avProduct.productName, avProduct.productPrice, avProduct.productWeight,
			AuthorUser.firstName AS authorFirstName, AuthorUser.lastName AS authorLastName, AuthorUser.userID_custom AS authorUserID_custom,
			CancelUser.firstName AS cancelFirstName, CancelUser.lastName AS cancelLastName, CancelUser.userID_custom AS cancelUserID_custom
		FROM avSubscription 
			LEFT OUTER JOIN avProduct ON avSubscription.productID = avProduct.productID
			LEFT OUTER JOIN avUser AS AuthorUser ON avSubscription.userID_author = AuthorUser.userID
			LEFT OUTER JOIN avUser AS CancelUser ON avSubscription.userID_cancel = CancelUser.userID
		WHERE avSubscription.subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "subscriptionID_parent")>
				<!--- if listing all (not just active) subscriptions, only include those that are the latest version --->
				<cfif Arguments.subscriptionID_parent is -1>
					AND (avSubscription.subscriptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
						OR avSubscription.subscriptionID NOT IN (SELECT subscriptionID_parent FROM avSubscription WHERE subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)))
				<cfelseif Application.fn_IsIntegerList(Arguments.subscriptionID_parent)>
					AND avSubscription.subscriptionID_parent IN (<cfqueryparam Value="#Arguments.subscriptionID_parent#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfif>
			<cfloop Index="field" List="subscriptionID,subscriptionID_trend,subscriptionID_rollup">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND avSubscription.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfloop Index="field" List="subscriptionStatus,subscriptionCompleted,subscriptionQuantityVaries,subscriptionIsRollup">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND avSubscription.#field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "subscriptionDateProcessNext")>
				<cfif Arguments.subscriptionDateProcessNext is "">
					AND avSubscription.subscriptionDateProcessNext IS NULL
				<cfelseif IsDate(Arguments.subscriptionDateProcessNext)>
					AND avSubscription.subscriptionDateProcessNext 
					<cfif StructKeyExists(Arguments, "subscriptionDateProcessNext_before") and Arguments.subscriptionDateProcessNext_before is True>
						<= <cfqueryparam Value="#CreateODBCDateTime(CreateDateTime(Year(Arguments.subscriptionDateProcessNext), Month(Arguments.subscriptionDateProcessNext), Day(Arguments.subscriptionDateProcessNext), 23, 59, 00))#" cfsqltype="cf_sql_timestamp">
					<cfelse>
						BETWEEN
						<cfqueryparam Value="#CreateODBCDateTime(CreateDateTime(Year(Arguments.subscriptionDateProcessNext), Month(Arguments.subscriptionDateProcessNext), Day(Arguments.subscriptionDateProcessNext), 0, 00, 00))#" cfsqltype="cf_sql_timestamp">
						AND
						<cfqueryparam Value="#CreateODBCDateTime(CreateDateTime(Year(Arguments.subscriptionDateProcessNext), Month(Arguments.subscriptionDateProcessNext), Day(Arguments.subscriptionDateProcessNext), 23, 59, 00))#" cfsqltype="cf_sql_timestamp">
					</cfif>
				</cfif>
			</cfif>
		ORDER BY avSubscription.subscriberID, avSubscription.subscriptionStatus DESC, avSubscription.subscriptionOrder, avSubscription.subscriptionDateCreated DESC
	</cfquery>

	<cfreturn qry_selectSubscriptionList>
</cffunction>

<cffunction Name="selectSubscriptionList_special" Access="public" Output="No" ReturnType="query" Hint="Select subscriptions for a particular object">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<!--- 
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	--->
	<cfargument Name="subscriptionStatus" Type="numeric" Required="No">
	<cfargument Name="subscriptionCompleted" Type="numeric" Required="No">

	<cfset var qry_selectSubscriptionList_special = QueryNew("blank")>
	<cfset var displayAnd = False>

	<cfquery Name="qry_selectSubscriptionList_special" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT subscriptionID, subscriberID, subscriptionName, subscriptionCompleted, subscriptionCategoryMultiple,
			subscriptionDateBegin, subscriptionDateEnd, subscriptionDateProcessNext, subscriptionDateProcessLast,
			subscriptionOrder, subscriptionStatus, subscriptionDateCreated, priceID, priceStageID, productID
		FROM avSubscription 
		WHERE 
			<cfif StructKeyExists(Arguments, "priceID") and Application.fn_IsIntegerList(Arguments.priceID)>
				<cfif displayAnd is True>AND <cfelse><cfset displayAnd = True></cfif>priceID IN (<cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
				<cfif displayAnd is True>AND <cfelse><cfset displayAnd = True></cfif>productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<!--- 
			<cfif StructKeyExists(Arguments, "regionID") and Application.fn_IsIntegerList(Arguments.regionID)>
				<cfif displayAnd is True>AND <cfelse><cfset displayAnd = True></cfif>regionID IN (<cfqueryparam Value="#Arguments.regionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerList(Arguments.categoryID)>
				<cfif displayAnd is True>AND <cfelse><cfset displayAnd = True></cfif>categoryID IN (<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriberID") and Application.fn_IsIntegerList(Arguments.subscriberID)>
				<cfif displayAnd is True>AND <cfelse><cfset displayAnd = True></cfif>subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			--->
			<cfif StructKeyExists(Arguments, "subscriptionStatus") and ListFind("0,1", Arguments.subscriptionStatus)>
				<cfif displayAnd is True>AND <cfelse><cfset displayAnd = True></cfif>subscriptionStatus = <cfqueryparam Value="#Arguments.subscriptionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriptionCompleted") and ListFind("0,1", Arguments.subscriptionCompleted)>
				<cfif displayAnd is True>AND <cfelse><cfset displayAnd = True></cfif>subscriptionCompleted = <cfqueryparam Value="#Arguments.subscriptionCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY subscriberID, subscriptionStatus DESC, subscriptionOrder
	</cfquery>

	<cfreturn qry_selectSubscriptionList_special>
</cffunction>

<cffunction Name="checkSubscriptionPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check company permission for existing subscription">
	<cfargument Name="subscriptionID" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">

	<cfset var qry_checkSubscriptionPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.subscriptionID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkSubscriptionPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT avSubscription.subscriptionID
			FROM avSubscription, avSubscriber
			WHERE avSubscription.subscriberID = avSubscriber.subscriberID
				AND avSubscriber.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
				AND avSubscription.subscriptionID IN (<cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfif qry_checkSubscriptionPermission.RecordCount is 0 or qry_checkSubscriptionPermission.RecordCount is not ListLen(Arguments.subscriptionID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectSubscriptionIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects subscriptionID of existing company via custom ID and returns subscriptionID if exists, 0 if not exists, and -1 if multiple companies have the same subscriptionID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionID_custom" Type="string" Required="Yes">

	<cfset var qry_selectSubscriptionIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectSubscriptionIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avSubscription.subscriptionID
		FROM avSubscription, avSubscriber
		WHERE avSubscription.subscriberID = avSubscriber.subscriberID
			AND avSubscriber.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND avSubscription.subscriptionID_custom IN (<cfqueryparam Value="#Arguments.subscriptionID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
			AND avSubscription.subscriptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>

	<cfif qry_selectSubscriptionIDViaCustomID.RecordCount is 0 or qry_selectSubscriptionIDViaCustomID.RecordCount lt ListLen(Arguments.subscriptionID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectSubscriptionIDViaCustomID.RecordCount gt ListLen(Arguments.subscriptionID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectSubscriptionIDViaCustomID.subscriptionID)>
	</cfif>
</cffunction>

<cffunction Name="switchSubscriptionOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing subscriptions">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionOrder_direction" Type="string" Required="Yes">

	<cfquery Name="qry_switchSubscriptionOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avSubscription
		SET subscriptionOrder = subscriptionOrder
			<cfif Arguments.subscriptionOrder_direction is "moveSubscriptionDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avSubscription INNER JOIN avSubscription AS avSubscription2
			SET avSubscription.subscriptionOrder = avSubscription.subscriptionOrder 
				<cfif Arguments.subscriptionOrder_direction is "moveSubscriptionDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avSubscription.subscriptionOrder = avSubscription2.subscriptionOrder
				AND avSubscription.subscriberID = avSubscription2.subscriberID
				AND avSubscription.subscriptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND avSubscription.subscriptionID <> <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
				AND avSubscription2.subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avSubscription
			SET subscriptionOrder = subscriptionOrder 
				<cfif Arguments.subscriptionOrder_direction is "moveSubscriptionDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE subscriptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND subscriptionID <> <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
				AND subscriberID = (SELECT subscriberID FROM avSubscription WHERE subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">)
				AND subscriptionOrder = (SELECT subscriptionOrder FROM avSubscription WHERE subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
