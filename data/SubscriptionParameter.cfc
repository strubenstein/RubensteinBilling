<cfcomponent DisplayName="SubscriptionParameter" Hint="Manages product parameters for each subscription">

<!--- Subscription Parameters --->
<cffunction Name="insertSubscriptionParameter" Access="public" Output="No" ReturnType="boolean" Hint="Insert parameter option for a subscription">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterOptionID" Type="string" Required="Yes">
	<cfargument Name="deleteExistingSubscriptionParameter" Type="boolean" Required="No" Default="True">

	<cfif Not Application.fn_IsIntegerList(Arguments.productParameterOptionID)>
		<cfreturn False>
	<cfelse>
		<cftransaction>
		<cfif StructKeyExists(Arguments, "deleteExistingSubscriptionParameter") and Arguments.deleteExistingSubscriptionParameter is True>
			<cfquery Name="qry_insertSubscriptionParameter_delete" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				DELETE FROM avSubscriptionParameter
				WHERE subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>

		<cfif Not StructKeyExists(Arguments, "deleteExistingSubscriptionParameter") or Arguments.deleteExistingSubscriptionParameter is False>
			<cfquery Name="qry_selectSubscriptionParameter_insert" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				SELECT productParameterOptionID
				FROM avSubscriptionParameter
				WHERE subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>

		<cfquery Name="qry_insertSubscriptionParameter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			INSERT INTO avSubscriptionParameter (subscriptionID, productParameterOptionID)
			SELECT 
				<cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">,
				productParameterOptionID
			FROM avProductParameterOption
			WHERE productParameterOptionID IN (<cfqueryparam Value="#Arguments.productParameterOptionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif (Not StructKeyExists(Arguments, "deleteExistingSubscriptionParameter") or Arguments.deleteExistingSubscriptionParameter is False) and IsDefined("qry_selectSubscriptionParameter_insert") and qry_selectSubscriptionParameter_insert.RecordCount is not 0>
					AND productParameterOptionID NOT IN (#ValueList(qry_selectSubscriptionParameter_insert.productParameterOptionID)#)
				</cfif>
		</cfquery>
		</cftransaction>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectSubscriptionParameterList" Access="public" Output="No" ReturnType="query" Hint="Select parameter options for designated subscription(s)">
	<cfargument Name="subscriptionID" Type="string" Required="Yes">

	<cfset var qry_selectSubscriptionParameterList = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.subscriptionID)>
		<cfset Arguments.subscriptionID = 0>
	</cfif>

	<cfquery Name="qry_selectSubscriptionParameterList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT subscriptionID, productParameterOptionID
		FROM avSubscriptionParameter
		WHERE subscriptionID IN (<cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		ORDER BY subscriptionID
	</cfquery>

	<cfreturn qry_selectSubscriptionParameterList>
</cffunction>

</cfcomponent>
