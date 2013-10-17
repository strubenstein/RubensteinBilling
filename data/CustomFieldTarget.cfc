<cfcomponent DisplayName="CustomFieldTarget" Hint="Manages custom field targets">

<!--- CUSTOM FIELD TARGETS --->
<cffunction Name="insertCustomFieldTarget" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new custom field target and returns True">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="customFieldID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="customFieldTargetStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="customFieldTargetOrder" Type="numeric" Required="No" Default="0">

	<cftransaction>
	<cfquery Name="qry_insertCustomFieldTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCustomFieldTarget
		(
			customFieldID, primaryTargetID, userID, customFieldTargetStatus,
			customFieldTargetOrder, customFieldTargetDateCreated, customFieldTargetDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.customFieldTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.customFieldTargetOrder#" cfsqltype="cf_sql_smallint">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfif Arguments.customFieldTargetOrder is 0>
		<cfquery Name="qry_insertCustomFieldTarget_order_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT MAX(avCustomFieldTarget.customFieldTargetOrder) AS maxCustomFieldTargetOrder
			FROM avCustomFieldTarget, avCustomField
			WHERE avCustomFieldTarget.customFieldID = avCustomField.customFieldID
				AND avCustomFieldTarget.primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND avCustomField.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery Name="qry_insertCustomFieldTarget_order" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avCustomFieldTarget
			SET customFieldTargetOrder = <cfqueryparam Value="1" cfsqltype="cf_sql_smallint"> + 
				<cfif Not IsNumeric(qry_insertCustomFieldTarget_order_select.maxCustomFieldTargetOrder)>
					<cfqueryparam Value="0" cfsqltype="cf_sql_smallint">
				<cfelse>
					<cfqueryparam Value="#qry_insertCustomFieldTarget_order_select.maxCustomFieldTargetOrder#" cfsqltype="cf_sql_smallint">
				</cfif>
			WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="updateCustomFieldTarget" Access="public" Output="No" ReturnType="boolean" Hint="Update existing custom field target and returns True">
	<cfargument Name="customFieldID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="customFieldTargetStatus" Type="numeric" Required="No">
	<cfargument Name="customFieldTargetOrder" Type="numeric" Required="No">

	<cfquery Name="qry_updateCustomFieldTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCustomFieldTarget
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldTargetStatus") and ListFind("0,1", Arguments.customFieldTargetStatus)>customFieldTargetStatus = <cfqueryparam Value="#Arguments.customFieldTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldTargetOrder") and Application.fn_IsIntegerNonNegative(Arguments.customFieldTargetOrder)>customFieldTargetOrder = <cfqueryparam Value="#Arguments.customFieldTargetOrder#" cfsqltype="cf_sql_smallint">,</cfif>
			customFieldTargetDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
			AND primaryTargetID IN (<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectCustomFieldTarget" Access="public" Output="No" ReturnType="query" Hint="Select existing custom field target">
	<cfargument Name="customFieldID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">

	<cfset var qry_selectCustomFieldTarget = QueryNew("blank")>

	<cfquery Name="qry_selectCustomFieldTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID, customFieldTargetStatus, customFieldTargetOrder, customFieldTargetDateCreated, customFieldTargetDateUpdated
		FROM avCustomFieldTarget
		WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
			AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectCustomFieldTarget>
</cffunction>

<cffunction Name="selectCustomFieldTargetList" Access="public" Output="No" ReturnType="query" Hint="Select existing custom field targets">
	<cfargument Name="customFieldID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="customFieldTargetStatus" Type="numeric" Required="No">
	<cfargument Name="queryOrderByCustomFieldID" Type="string" Required="No" Default="True">

	<cfset var displayAnd = "False">
	<cfset var qry_selectCustomFieldTargetList = QueryNew("blank")>

	<cfquery Name="qry_selectCustomFieldTargetList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT customFieldID, primaryTargetID, userID, customFieldTargetStatus, customFieldTargetOrder,
			customFieldTargetDateCreated, customFieldTargetDateUpdated
		FROM avCustomFieldTarget
		WHERE 
			<cfif StructKeyExists(Arguments, "customFieldID") and Application.fn_IsIntegerList(Arguments.customFieldID)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				customFieldID IN (<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				primaryTargetID IN (<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "customFieldTargetStatus") and ListFind("0,1", Arguments.customFieldTargetStatus)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				customFieldTargetStatus = <cfqueryparam Value="#Arguments.customFieldTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY 
			<cfif StructKeyExists(Arguments, "queryOrderByCustomFieldID") and Arguments.queryOrderByCustomFieldID is True>customFieldID, </cfif>
			primaryTargetID, customFieldTargetOrder
	</cfquery>

	<cfreturn qry_selectCustomFieldTargetList>
</cffunction>

<cffunction Name="switchCustomFieldTargetOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of custom fields for a particular target">
	<cfargument Name="customFieldID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="customFieldTargetOrder_direction" Type="string" Required="Yes">

	<cfquery Name="qry_switchCustomFieldTargetOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCustomFieldTarget
		SET customFieldTargetOrder = customFieldTargetOrder 
			<cfif Arguments.customFieldTargetOrder_direction is "moveCustomFieldTargetDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avCustomFieldTarget INNER JOIN avCustomFieldTarget AS avCustomFieldTarget2
			SET avCustomFieldTarget.customFieldTargetOrder = avCustomFieldTarget.customFieldTargetOrder 
				<cfif Arguments.customFieldTargetOrder_direction is "moveCustomFieldTargetDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avCustomFieldTarget.customFieldTargetOrder = avCustomFieldTarget2.customFieldTargetOrder
				AND avCustomFieldTarget.primaryTargetID = avCustomFieldTarget2.primaryTargetID
				AND avCustomFieldTarget.primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND avCustomFieldTarget.customFieldID <> <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
				AND avCustomFieldTarget2.customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
				AND avCustomFieldTarget.customFieldID IN 
					(
					SELECT customFieldID
					FROM avCustomField
					WHERE companyID = 
						(
						SELECT companyID
						FROM avCustomField
						WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
						)
					);
		<cfelse>
			UPDATE avCustomFieldTarget
			SET customFieldTargetOrder = customFieldTargetOrder 
				<cfif Arguments.customFieldTargetOrder_direction is "moveCustomFieldTargetDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND customFieldTargetOrder = 
					(
					SELECT customFieldTargetOrder
					FROM avCustomFieldTarget
					WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
						AND customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
					)
				AND customFieldID IN 
					(
					SELECT customFieldID
					FROM avCustomField
					WHERE companyID = 
						(
						SELECT companyID
						FROM avCustomField
						WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
						)
					)
				AND customFieldID <> <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">;
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<!--- CUSTOM FIELD VALUES --->
<cffunction Name="selectCustomFieldListForTarget" Access="public" Output="No" ReturnType="query" Hint="Selects custom fields for a given target type">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="string" Required="Yes">
	<cfargument Name="customFieldStatus" Type="numeric" Required="No">
	<cfargument Name="customFieldTargetStatus" Type="numeric" Required="No">

	<cfset var qry_selectCustomFieldListForTarget = QueryNew("blank")>

	<cfquery Name="qry_selectCustomFieldListForTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avCustomFieldTarget.customFieldID, avCustomFieldTarget.primaryTargetID,  avCustomFieldTarget.customFieldTargetStatus, avCustomFieldTarget.customFieldTargetOrder,
			avCustomField.customFieldName, avCustomField.customFieldTitle, avCustomField.customFieldType, avCustomField.customFieldFormType, avCustomField.customFieldStatus
		FROM avCustomFieldTarget, avCustomField
		WHERE avCustomFieldTarget.customFieldID = avCustomField.customFieldID
			AND avCustomField.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND avCustomFieldTarget.primaryTargetID IN (<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "customFieldTargetStatus") and ListFind("0,1", Arguments.customFieldTargetStatus)>
				AND avCustomField.customFieldStatus = <cfqueryparam Value="#Arguments.customFieldStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "customFieldTargetStatus") and ListFind("0,1", Arguments.customFieldTargetStatus)>
				AND avCustomFieldTarget.customFieldTargetStatus = <cfqueryparam Value="#Arguments.customFieldTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY primaryTargetID, customFieldTargetOrder
	</cfquery>

	<cfreturn qry_selectCustomFieldListForTarget>
</cffunction>

</cfcomponent>
