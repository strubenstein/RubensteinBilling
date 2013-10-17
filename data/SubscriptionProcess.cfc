<cfcomponent DisplayName="SubscriptionProcess" Hint="Manages periodic processing of subscribers and subscriptions">

<cffunction name="maxlength_SubscriptionProcess" access="public" output="no" returnType="struct">
	<cfset var maxlength_SubscriptionProcess = StructNew()>

	<cfset maxlength_SubscriptionProcess.subscriptionProcessQuantity = 4>

	<cfreturn maxlength_SubscriptionProcess>
</cffunction>

<!--- Subscription Process Quantities --->
<cffunction Name="insertSubscriptionProcess" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new subscription process for recording quantity. Returns True.">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="priceStageID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionProcessQuantity" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionProcessQuantityFinal" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionProcessDateBegin" Type="string" Required="No" Default="">
	<cfargument Name="subscriptionProcessDateEnd" Type="string" Required="No" Default="">
	<cfargument Name="categoryID" Type="numeric" Required="No" Default="0">

	<cfinvoke component="#Application.billingMapping#data.SubscriptionProcess" method="maxlength_SubscriptionProcess" returnVariable="maxlength_SubscriptionProcess" />

	<cfquery Name="qry_insertSubscriptionProcess" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avSubscriptionProcess
		(
			subscriberProcessID, subscriptionID, priceStageID, subscriptionProcessQuantity, subscriptionProcessQuantityFinal,
			subscriptionProcessDateBegin, subscriptionProcessDateEnd, categoryID
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.subscriberProcessID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.priceStageID#" cfsqltype="cf_sql_integer">,
			<cfif Not IsNumeric(Arguments.subscriptionProcessQuantity) or Arguments.subscriptionProcessQuantity lt 0>
				NULL,
			<cfelse>
				<cfqueryparam Value="#Arguments.subscriptionProcessQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_SubscriptionProcess.subscriptionProcessQuantity#">,
			</cfif>
			<cfqueryparam Value="#Arguments.subscriptionProcessQuantityFinal#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Arguments.subscriptionProcessDateBegin is "">NULL<cfelse><cfqueryparam Value="#Arguments.subscriptionProcessDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Arguments.subscriptionProcessDateEnd is "">NULL<cfelse><cfqueryparam Value="#Arguments.subscriptionProcessDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateSubscriptionProcess" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing subscription process quantity. Returns True.">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="priceStageID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="subscriptionProcessQuantity" Type="string" Required="No">
	<cfargument Name="subscriptionProcessQuantityFinal" Type="numeric" Required="No">
	<cfargument Name="subscriptionProcessDateBegin" Type="string" Required="No">
	<cfargument Name="subscriptionProcessDateEnd" Type="string" Required="No">

	<cfset var displayComma = False>

	<cfif (StructKeyExists(Arguments, "subscriptionProcessQuantity") and (Arguments.subscriptionProcessQuantity is "" or IsNumeric(Arguments.subscriptionProcessQuantity))) or (StructKeyExists(Arguments, "subscriptionProcessQuantityFinal") and ListFind("0,1", Arguments.subscriptionProcessQuantityFinal)) or StructKeyExists(Arguments, "subscriptionProcessDateBegin") or StructKeyExists(Arguments, "subscriptionProcessDateEnd")>
		<cfinvoke component="#Application.billingMapping#data.SubscriptionProcess" method="maxlength_SubscriptionProcess" returnVariable="maxlength_SubscriptionProcess" />

		<cfquery Name="qry_updateSubscriptionProcess" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSubscriptionProcess
			SET
				<cfif StructKeyExists(Arguments, "subscriptionProcessQuantity") and (Arguments.subscriptionProcessQuantity is "" or IsNumeric(Arguments.subscriptionProcessQuantity))>
					<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>
					subscriptionProcessQuantity = <cfif Arguments.subscriptionProcessQuantity is "">NULL<cfelse><cfqueryparam Value="#Arguments.subscriptionProcessQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_SubscriptionProcess.subscriptionProcessQuantity#"></cfif>
				</cfif>
				<cfif StructKeyExists(Arguments, "subscriptionProcessQuantityFinal") and ListFind("0,1", Arguments.subscriptionProcessQuantityFinal)>
					<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>
					subscriptionProcessQuantityFinal = <cfqueryparam Value="#Arguments.subscriptionProcessQuantityFinal#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
				<cfif StructKeyExists(Arguments, "subscriptionProcessDateBegin") and (Arguments.subscriptionProcessDateBegin is "" or IsDate(Arguments.subscriptionProcessDateBegin))>
					<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>
					subscriptionProcessDateBegin = <cfif Arguments.subscriptionProcessDateBegin is "">NULL<cfelse><cfqueryparam Value="#Arguments.subscriptionProcessDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>
				</cfif>
				<cfif StructKeyExists(Arguments, "subscriptionProcessDateEnd") and (Arguments.subscriptionProcessDateEnd is "" or IsDate(Arguments.subscriptionProcessDateEnd))>
					<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>
					subscriptionProcessDateEnd = <cfif Arguments.subscriptionProcessDateEnd is "">NULL<cfelse><cfqueryparam Value="#Arguments.subscriptionProcessDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>
				</cfif>
			WHERE subscriberProcessID = <cfqueryparam Value="#Arguments.subscriberProcessID#" cfsqltype="cf_sql_integer">
				AND subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
				AND priceStageID = <cfqueryparam Value="#Arguments.priceStageID#" cfsqltype="cf_sql_integer">
				<cfif StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerNonNegative(Arguments.categoryID)>
					AND categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
				</cfif>
		</cfquery>

		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectSubscriptionProcessList" Access="public" Output="No" ReturnType="query" Hint="Select existing subscription process quantities.">
	<cfargument Name="subscriberProcessID" Type="string" Required="Yes">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="priceStageID" Type="string" Required="No">
	<cfargument Name="subscriptionProcessQuantity" Type="numeric" Required="No">
	<cfargument Name="subscriptionProcessQuantityFinal" Type="numeric" Required="No">
	<cfargument Name="subscriptionIsRollup" Type="numeric" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="subscriptionProcessID" Type="string" Required="No">

	<cfset var qry_selectSubscriptionProcessList = QueryNew("blank")>

	<cfif Not StructKeyExists(Arguments, "subscriptionIsRollup") or Not ListFind("0,1", Arguments.subscriptionIsRollup)>
		<cfset Arguments.subscriptionIsRollup = "">
	</cfif>

	<cfquery Name="qry_selectSubscriptionProcessList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avSubscriptionProcess.subscriptionProcessID, avSubscriptionProcess.subscriberProcessID, avSubscriptionProcess.subscriptionID, avSubscriptionProcess.priceStageID,
			avSubscriptionProcess.subscriptionProcessQuantity, avSubscriptionProcess.subscriptionProcessQuantityFinal, avSubscriptionProcess.subscriptionProcessDateBegin,
			avSubscriptionProcess.subscriptionProcessDateEnd, avSubscriptionProcess.categoryID,
			<cfif Application.billingDatabase is "MySQL">
				CONCAT(avSubscriptionProcess.subscriptionID, '_', avSubscriptionProcess.priceStageID) AS subscriptionID_priceStageID
			<cfelse><!--- MSSQLServer --->
				CAST(avSubscriptionProcess.subscriptionID AS VARCHAR (10)) + '_' + CAST(avSubscriptionProcess.priceStageID AS VARCHAR (10)) AS subscriptionID_priceStageID
			</cfif>
		FROM avSubscriptionProcess
			<cfif Arguments.subscriptionIsRollup is not "">
				INNER JOIN avSubscription ON avSubscriptionProcess.subscriptionID = avSubscription.subscriptionID
			</cfif>
		WHERE avSubscriptionProcess.subscriberProcessID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif Arguments.subscriptionIsRollup is not "">
				AND avSubscription.subscriptionIsRollup = <cfqueryparam Value="#Arguments.subscriptionIsRollup#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfloop Index="field" List="subscriberProcessID,subscriptionID,priceStageID,categoryID,subscriptionProcessID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND avSubscriptionProcess.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "subscriptionProcessQuantityFinal") and ListFind("0,1", Arguments.subscriptionProcessQuantityFinal)>
				AND avSubscriptionProcess.subscriptionProcessQuantityFinal = <cfqueryparam Value="#Arguments.subscriptionProcessQuantityFinal#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriptionProcessQuantity") and IsNumeric(Arguments.subscriptionProcessQuantity)>
				AND avSubscriptionProcess.subscriptionProcessQuantity = <cfqueryparam Value="#Arguments.subscriptionProcessQuantity#" cfsqltype="cf_sql_decimal">
			</cfif>
		ORDER BY avSubscriptionProcess.subscriberProcessID, avSubscriptionProcess.subscriptionID, avSubscriptionProcess.priceStageID
	</cfquery>

	<cfreturn qry_selectSubscriptionProcessList>
</cffunction>

<!--- Rollup does not take categoryID into account --->
<cffunction Name="updateSubscriptionProcess_rollup" Access="public" Output="No" ReturnType="boolean" Hint="If all variable-quantity subscriptions are finalized, check for and calculate rollup subscriptions">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="Yes">

	<cfset var qry_selectSubscriptionList_rollup = QueryNew("blank")>
	<cfset var qry_selectSubscriberProcessList = QueryNew("blank")>
	<cfset var qry_selectSubscriptionRollupQuantity = QueryNew("blank")>
	<cfset var thisSubscriptionID = 0>
	<cfset var thisMethod = "">

	<!--- If all variable-quantity subscriptions are finalized, check for and calculate rollup subscriptions --->
	<cfquery Name="qry_selectSubscriptionList_rollup" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avSubscription.subscriptionID
		FROM avSubscription, avSubscriptionProcess
		WHERE avSubscription.subscriptionID = avSubscriptionProcess.subscriptionID
			AND avSubscriptionProcess.subscriberProcessID = <cfqueryparam Value="#Arguments.subscriberProcessID#" cfsqltype="cf_sql_integer">
			AND avSubscription.subscriptionIsRollup = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>

	<cfif qry_selectSubscriptionList_rollup.RecordCount is not 0>
		<cfquery Name="qry_selectSubscriptionProcessList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT subscriptionID, subscriptionProcessID, priceStageID,
				<cfif Application.billingDatabase is "MySQL">
					CONCAT(subscriptionID, '_', priceStageID) AS subscriptionID_priceStageID
				<cfelse><!--- MSSQLServer --->
					CAST(subscriptionID AS VARCHAR (10)) + '_' + CAST(priceStageID AS VARCHAR (10)) AS subscriptionID_priceStageID
				</cfif>
			FROM avSubscriptionProcess
			WHERE subscriberProcessID = <cfqueryparam Value="#Arguments.subscriberProcessID#" cfsqltype="cf_sql_integer">
				AND subscriptionID IN (<cfqueryparam Value="#ValueList(qry_selectSubscriptionList_rollup.subscriptionID)#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfloop Query="qry_selectSubscriptionList_rollup">
			<cfquery Name="qry_selectSubscriptionRollupQuantity" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				SELECT avSubscriptionProcess.priceStageID, SUM(avSubscriptionProcess.subscriptionProcessQuantity) AS totalSubscriptionProcessQuantity
				FROM avSubscriptionProcess, avSubscription
				WHERE avSubscriptionProcess.subscriptionID = avSubscription.subscriptionID
					AND avSubscription.subscriptionID_rollup = <cfqueryparam Value="#qry_selectSubscriptionList_rollup.subscriptionID#" cfsqltype="cf_sql_integer">
					AND avSubscriptionProcess.subscriberProcessID = <cfqueryparam Value="#Arguments.subscriberProcessID#" cfsqltype="cf_sql_integer">
				GROUP BY avSubscriptionProcess.priceStageID
			</cfquery>

			<cfset thisSubscriptionID = qry_selectSubscriptionList_rollup.subscriptionID>
			<cfloop Query="qry_selectSubscriptionRollupQuantity">
				<cfif ListFind(ValueList(qry_selectSubscriptionProcessList.subscriptionID_priceStageID), "#thisSubscriptionID#_#qry_selectSubscriptionRollupQuantity.priceStageID#")>
					<cfset thisMethod = "updateSubscriptionProcess">
				<cfelse>
					<cfset thisMethod = "insertSubscriptionProcess">
				</cfif>

				<cfinvoke component="#Application.billingMapping#data.SubscriptionProcess" Method="#thisMethod#" ReturnVariable="isSubscriptionProcessUpdated">
					<cfinvokeargument Name="subscriberProcessID" Value="#Arguments.subscriberProcessID#">
					<cfinvokeargument Name="subscriptionID" Value="#thisSubscriptionID#">
					<cfinvokeargument Name="priceStageID" Value="#qry_selectSubscriptionRollupQuantity.priceStageID#">
					<cfinvokeargument Name="subscriptionProcessQuantity" Value="#qry_selectSubscriptionRollupQuantity.totalSubscriptionProcessQuantity#">
					<cfinvokeargument Name="subscriptionProcessQuantityFinal" Value="1">
				</cfinvoke>
			</cfloop><!--- /loop thru price stages for each rollup subscription --->
		</cfloop><!--- /loop thru rollup subscriptions --->
	</cfif><!--- /if at least one rollup subscription --->

	<cfreturn True>
</cffunction>

</cfcomponent>
