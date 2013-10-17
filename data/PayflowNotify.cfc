<cfcomponent DisplayName="PayflowNotify" Hint="Manages which customer user to notify for each payflow method">

<cffunction name="maxlength_PayflowNotify" access="public" output="no" returnType="struct">
	<cfset var maxlength_PayflowNotify = StructNew()>

	<cfset maxlength_PayflowNotify.payflowNotifyType = 50>

	<cfreturn maxlength_PayflowNotify>
</cffunction>

<!--- Payflow Notify - admin notification --->
<cffunction Name="insertPayflowNotify" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new payflow user notification method. Returns True.">
	<cfargument Name="payflowID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="payflowNotifyStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="payflowNotifyType" Type="string" Required="No" Default="">
	<cfargument Name="payflowNotifyTask" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowNotifyEmail" Type="numeric" Required="No" Default="0">
	<!--- <cfargument Name="payflowNotifyWeb" Type="numeric" Required="No" Default="0"> --->

	<cfinvoke component="#Application.billingMapping#data.PayflowNotify" method="maxlength_PayflowNotify" returnVariable="maxlength_PayflowNotify" />

	<cfquery Name="qry_insertPayflowNotify" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPayflowNotify
		(
			payflowID, userID, payflowNotifyStatus, payflowNotifyType, payflowNotifyTask,
			payflowNotifyEmail, <!--- payflowNotifyWeb, ---> payflowNotifyDateCreated, payflowNotifyDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.payflowNotifyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowNotifyType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PayflowNotify.payflowNotifyType#">,
			<cfqueryparam Value="#Arguments.payflowNotifyTask#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowNotifyEmail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<!--- <cfqueryparam Value="#Arguments.payflowNotifyWeb#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> --->
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updatePayflowNotify" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing payflow user notification method. Returns True.">
	<cfargument Name="payflowNotifyID" Type="numeric" Required="Yes">
	<cfargument Name="payflowNotifyStatus" Type="numeric" Required="No">
	<cfargument Name="payflowNotifyType" Type="string" Required="No">
	<cfargument Name="payflowNotifyTask" Type="numeric" Required="No">
	<cfargument Name="payflowNotifyEmail" Type="numeric" Required="No">
	<!--- <cfargument Name="payflowNotifyWeb" Type="numeric" Required="No"> --->

	<cfinvoke component="#Application.billingMapping#data.PayflowNotify" method="maxlength_PayflowNotify" returnVariable="maxlength_PayflowNotify" />

	<cfquery Name="qry_updatePayflowNotify" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPayflowNotify
		SET
			<cfif StructKeyExists(Arguments, "payflowNotifyStatus") and ListFind("0,1", Arguments.payflowNotifyStatus)>payflowNotifyStatus = <cfqueryparam Value="#Arguments.payflowNotifyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowNotifyType")>payflowNotifyType = <cfqueryparam Value="#Arguments.payflowNotifyType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PayflowNotify.payflowNotifyType#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowNotifyTask") and ListFind("0,1", Arguments.payflowNotifyTask)>payflowNotifyTask = <cfqueryparam Value="#Arguments.payflowNotifyTask#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowNotifyEmail") and ListFind("0,1", Arguments.payflowNotifyEmail)>payflowNotifyEmail = <cfqueryparam Value="#Arguments.payflowNotifyEmail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<!--- <cfif StructKeyExists(Arguments, "payflowNotifyWeb") and ListFind("0,1", Arguments.payflowNotifyWeb)>payflowNotifyWeb = <cfqueryparam Value="#Arguments.payflowNotifyWeb#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif> --->
			payflowNotifyDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE payflowNotifyID = <cfqueryparam Value="#Arguments.payflowNotifyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPayflowNotify" Access="public" Output="No" ReturnType="query" Hint="Select user notification method for payflow.">
	<cfargument Name="payflowNotifyID" Type="numeric" Required="Yes">

	<cfset var qry_selectPayflowNotify = QueryNew("blank")>

	<cfquery Name="qry_selectPayflowNotify" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT payflowID, userID, payflowNotifyStatus, payflowNotifyType,
			payflowNotifyTask, payflowNotifyEmail, <!--- payflowNotifyWeb, --->
			payflowNotifyDateCreated, payflowNotifyDateUpdated
		FROM avPayflowNotify
		WHERE payflowNotifyID = <cfqueryparam Value="#Arguments.payflowNotifyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectPayflowNotify>
</cffunction>

<cffunction Name="selectPayflowNotifyList" Access="public" Output="No" ReturnType="query" Hint="Select user notification method for payflow(s).">
	<cfargument Name="payflowNotifyID" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="payflowNotifyStatus" Type="numeric" Required="No">

	<cfset var qry_selectPayflowNotifyList = QueryNew("blank")>

	<cfquery Name="qry_selectPayflowNotifyList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT payflowNotifyID, payflowID, userID, payflowNotifyStatus, payflowNotifyType,
			payflowNotifyTask, payflowNotifyEmail, <!--- payflowNotifyWeb, --->
			payflowNotifyDateCreated, payflowNotifyDateUpdated
		FROM avPayflowNotify
		WHERE payflowNotifyID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "payflowNotifyID") and Application.fn_IsIntegerList(Arguments.payflowNotifyID)>AND payflowNotifyID IN (<cfqueryparam Value="#Arguments.payflowNotifyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "payflowID") and Application.fn_IsIntegerList(Arguments.payflowID)>AND payflowID IN (<cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>AND userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "payflowNotifyStatus") and ListFind("0,1", Arguments.payflowNotifyStatus)>AND payflowNotifyStatus = <cfqueryparam Value="#Arguments.payflowNotifyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
	</cfquery>

	<cfreturn qry_selectPayflowNotifyList>
</cffunction>

<cffunction Name="deletePayflowNotify" Access="public" Output="No" ReturnType="boolean" Hint="Delete notification options for payflow(s).">
	<cfargument Name="payflowID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.userID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_deletePayflowNotify" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			DELETE FROM avPayflowNotify
			WHERE payflowID = <cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">
				AND userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>
