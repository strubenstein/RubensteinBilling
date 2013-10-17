<cfcomponent DisplayName="Trigger" Hint="Manages actions for which a trigger should be activated">

<cffunction name="maxlength_TriggerAction" access="public" output="no" returnType="struct">
	<cfset var maxlength_TriggerAction = StructNew()>

	<cfset maxlength_TriggerAction.triggerAction = 50>
	<cfset maxlength_TriggerAction.triggerActionControl = 50>
	<cfset maxlength_TriggerAction.triggerActionDescription = 255>

	<cfreturn maxlength_TriggerAction>
</cffunction>

<!--- Trigger Action --->
<cffunction Name="insertTriggerAction" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new trigger action. Returns True.">
	<cfargument Name="triggerAction" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="triggerActionControl" Type="string" Required="Yes">
	<cfargument Name="triggerActionDescription" Type="string" Required="Yes">
	<cfargument Name="triggerActionStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="triggerActionSuperuserOnly" Type="numeric" Required="No" Default="0">
	<cfargument Name="triggerActionOrder" Type="numeric" Required="No" Default="0">

	<cfset var qry_selectTriggerActionOrder = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.TriggerAction" method="maxlength_TriggerAction" returnVariable="maxlength_TriggerAction" />

	<cftransaction>
	<cfquery Name="qry_insertTriggerAction" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avTriggerAction
		(
			triggerAction, userID, triggerActionControl, triggerActionDescription, triggerActionStatus,
			triggerActionSuperuserOnly, triggerActionOrder, triggerActionDateCreated, triggerActionDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_TriggerAction.triggerAction#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.triggerActionControl#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_TriggerAction.triggerActionControl#">,
			<cfqueryparam Value="#Arguments.triggerActionDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_TriggerAction.triggerActionDescription#">,
			<cfqueryparam Value="#Arguments.triggerActionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.triggerActionSuperuserOnly#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.triggerActionOrder#" cfsqltype="cf_sql_smallint">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfif Arguments.triggerActionOrder gt 0>
		<cfquery Name="qry_updateTriggerActionOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avTriggerAction
			SET triggerActionOrder = triggerActionOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE triggerActionOrder >= <cfqueryparam Value="#Arguments.triggerActionOrder#" cfsqltype="cf_sql_smallint">
				AND triggerAction <> <cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar">
		</cfquery>
	<cfelse>
		<cfquery Name="qry_selectTriggerActionOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT MAX(triggerActionOrder) AS maxTriggerActionOrder
			FROM avTriggerAction
		</cfquery>

		<cfquery Name="qry_updateTriggerActionOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avTriggerAction
			SET triggerActionOrder = 
				<cfif Not Application.fn_IsIntegerPositive(qry_selectTriggerActionOrder.maxTriggerActionOrder)>
					<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
				<cfelse>
					<cfqueryparam Value="#IncrementValue(qry_selectTriggerActionOrder.maxTriggerActionOrder)#" cfsqltype="cf_sql_smallint">
				</cfif>
			WHERE triggerAction = <cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cfif>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="updateTriggerAction" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing trigger action. Returns True.">
	<cfargument Name="triggerAction" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="triggerActionControl" Type="string" Required="No">
	<cfargument Name="triggerActionDescription" Type="string" Required="No">
	<cfargument Name="triggerActionStatus" Type="numeric" Required="No">
	<cfargument Name="triggerActionSuperuserOnly" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.TriggerAction" method="maxlength_TriggerAction" returnVariable="maxlength_TriggerAction" />

	<cfquery Name="qry_updateTriggerAction" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avTriggerAction
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "triggerActionControl")>triggerActionControl = <cfqueryparam Value="#Arguments.triggerActionControl#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_TriggerAction.triggerActionControl#">,</cfif>
			<cfif StructKeyExists(Arguments, "triggerActionDescription")>triggerActionDescription = <cfqueryparam Value="#Arguments.triggerActionDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_TriggerAction.triggerActionDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "triggerActionStatus") and ListFind("0,1", Arguments.triggerActionStatus)>triggerActionStatus = <cfqueryparam Value="#Arguments.triggerActionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "triggerActionSuperuserOnly") and ListFind("0,1", Arguments.triggerActionSuperuserOnly)>triggerActionSuperuserOnly = <cfqueryparam Value="#Arguments.triggerActionSuperuserOnly#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			triggerActionDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE triggerAction = <cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkTriggerActionIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check that trigger action is unique">
	<cfargument Name="triggerAction" Type="string" Required="Yes">

	<cfset var qry_checkTriggerActionIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkTriggerActionIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT triggerAction
		FROM avTriggerAction
		WHERE triggerAction = <cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfif qry_checkTriggerActionIsUnique.RecordCount is not 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="switchTriggerActionOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing trigger actions">
	<cfargument Name="triggerAction" Type="string" Required="Yes">
	<cfargument Name="triggerActionOrder_direction" Type="string" Required="Yes">

	<cfset var qry_selectTriggerActionOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchTriggerActionOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avTriggerAction
		SET triggerActionOrder = triggerActionOrder 
			<cfif Arguments.triggerActionOrder_direction is "moveTriggerActionDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE TriggerAction = <cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avTriggerAction INNER JOIN avTriggerAction AS avTriggerAction2
			SET avTriggerAction.triggerActionOrder = avTriggerAction.triggerActionOrder 
				<cfif Arguments.triggerActionOrder_direction is "moveTriggerActionDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avTriggerAction.triggerActionOrder = avTriggerAction2.triggerActionOrder
				AND avTriggerAction.triggerAction <> <cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar">
				AND avTriggerAction2.triggerAction = <cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar">;
		<cfelse>
			UPDATE avTriggerAction
			SET triggerActionOrder = triggerActionOrder 
				<cfif Arguments.triggerActionOrder_direction is "moveTriggerActionDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE triggerAction <> <cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar">
				AND triggerActionOrder = (SELECT triggerActionOrder FROM avTriggerAction WHERE triggerAction = <cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectTriggerAction" Access="public" Output="No" ReturnType="query" Hint="Selects existing trigger action">
	<cfargument Name="triggerAction" Type="numeric" Required="Yes">

	<cfset var qry_selectTriggerAction = QueryNew("blank")>

	<cfquery Name="qry_selectTriggerAction" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID, triggerActionControl, triggerActionDescription, triggerActionStatus,
			triggerActionOrder, triggerActionSuperuserOnly, triggerActionDateCreated, triggerActionDateUpdated
		FROM avTriggerAction
		WHERE triggerAction = <cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfreturn qry_selectTriggerAction>
</cffunction>

<cffunction Name="selectTriggerActionList" Access="public" Output="No" ReturnType="query" Hint="Selects list of existing trigger actions">
	<cfargument Name="triggerAction" Type="string" Required="No">
	<cfargument Name="triggerActionControl" Type="string" Required="No">
	<cfargument Name="triggerActionStatus" Type="numeric" Required="No">
	<cfargument Name="triggerActionSuperuserOnly" Type="numeric" Required="No">

	<cfset var qry_selectTriggerActionList = QueryNew("blank")>

	<cfquery Name="qry_selectTriggerActionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT triggerAction, userID, triggerActionControl, triggerActionDescription, triggerActionStatus,
			triggerActionOrder, triggerActionSuperuserOnly, triggerActionDateCreated, triggerActionDateUpdated
		FROM avTriggerAction
		WHERE userID >= <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="triggerAction,triggerActionControl">
				<cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">
					AND #field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfloop Index="field" List="triggerActionSuperuserOnly,triggerActionStatus">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND #field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
		ORDER BY triggerActionOrder
	</cfquery>

	<cfreturn qry_selectTriggerActionList>
</cffunction>

</cfcomponent>
