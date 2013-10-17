<cfcomponent DisplayName="PayflowTarget" Hint="Manages who is processed using payflow method">

<!--- Payflow Target - payflow used to process each group, company, subscriber --->
<cffunction Name="insertPayflowTarget" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new payflow target. Returns True.">
	<cfargument Name="payflowID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowTargetStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="payflowTargetDateBegin" Type="string" Required="No" Default="#CreateODBCDateTime(Now())#">
	<cfargument Name="payflowTargetDateEnd" Type="string" Required="No" Default="">

	<cfquery Name="qry_insertPayflowTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPayflowTarget
		(
			payflowID, primaryTargetID, targetID, userID, payflowTargetStatus,
			payflowTargetDateBegin, payflowTargetDateEnd, payflowTargetDateCreated,
			payflowTargetDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.payflowTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "payflowTargetDateBegin") or Not IsDate(Arguments.payflowTargetDateBegin)>#Application.billingSql.sql_nowDateTime#<cfelse><cfqueryparam Value="#Arguments.payflowTargetDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not StructKeyExists(Arguments, "payflowTargetDateEnd") or Not IsDate(Arguments.payflowTargetDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.payflowTargetDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updatePayflowTarget" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing payflow target. Returns True.">
	<cfargument Name="payflowTargetID" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="payflowTargetStatus" Type="numeric" Required="No">
	<cfargument Name="payflowTargetDateBegin" Type="string" Required="No">
	<cfargument Name="payflowTargetDateEnd" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">

	<cfif (StructKeyExists(Arguments, "payflowTargetID") and Application.fn_IsIntegerList(Arguments.payflowTargetID)) or (StructKeyExists(Arguments, "payflowID") and StructKeyExists(Arguments, "primaryTargetID") and StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerList(Arguments.payflowID) and Application.fn_IsIntegerPositive(Arguments.primaryTargetID) and Application.fn_IsIntegerList(Arguments.targetID))>
		<cfquery Name="qry_updatePayflowTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avPayflowTarget
			SET
				<cfif StructKeyExists(Arguments, "payflowTargetStatus") and ListFind("0,1", Arguments.payflowTargetStatus)>payflowTargetStatus = <cfqueryparam Value="#Arguments.payflowTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
				<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
				<cfif StructKeyExists(Arguments, "payflowTargetDateBegin") and IsDate(Arguments.payflowTargetDateBegin)>payflowTargetDateBegin = <cfqueryparam Value="#Arguments.payflowTargetDateBegin#" cfsqltype="cf_sql_timestamp">,</cfif>
				<cfif StructKeyExists(Arguments, "payflowTargetDateEnd") and (Arguments.payflowTargetDateEnd is "" or IsDate(Arguments.payflowTargetDateEnd))>payflowTargetDateEnd = <cfif Not IsDate(Arguments.payflowTargetDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.payflowTargetDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
				payflowTargetDateUpdated = #Application.billingSql.sql_nowDateTime#
			WHERE 
				<cfif StructKeyExists(Arguments, "payflowTargetID") and Application.fn_IsIntegerList(Arguments.payflowTargetID)>
					payflowTargetID = <cfqueryparam Value="#Arguments.payflowTargetID#" cfsqltype="cf_sql_integer">
				<cfelse>
					payflowTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND payflowID IN (<cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
					AND targetID IN (<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
		</cfquery>

		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectPayflowTarget" Access="public" Output="No" ReturnType="query" Hint="Select targets for payflow(s). Returns True.">
	<cfargument Name="payflowTargetID" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="payflowTargetStatus" Type="numeric" Required="No">
	<cfargument Name="payflowTargetDateBegin_from" Type="date" Required="No">
	<cfargument Name="payflowTargetDateBegin_to" Type="date" Required="No">
	<cfargument Name="payflowTargetHasEndDate" Type="numeric" Required="No">
	<cfargument Name="payflowTargetDateEnd_from" Type="string" Required="No">
	<cfargument Name="payflowTargetDateEnd_to" Type="string" Required="No">

	<cfset var qry_selectPayflowTarget = QueryNew("blank")>

	<cfquery Name="qry_selectPayflowTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT payflowTargetID, payflowID, primaryTargetID, targetID, userID,
			payflowTargetDateBegin, payflowTargetDateEnd, payflowTargetStatus,
			payflowTargetDateCreated, payflowTargetDateUpdated
		FROM avPayflowTarget
		WHERE payflowTargetID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="payflowTargetID,payflowID,targetID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND #field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerPositive(Arguments.primaryTargetID)>AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "payflowTargetStatus") and ListFind("0,1", Arguments.payflowTargetStatus)>AND payflowTargetStatus = <cfqueryparam Value="#Arguments.payflowTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "payflowTargetDateBegin_min") and IsDate(Arguments.payflowTargetDateBegin_min)>AND payflowTargetDateBegin >= <cfqueryparam Value="#Arguments.payflowTargetDateBegin_min#" cfsqltype="cf_sql_timestamp"></cfif>
			<cfif StructKeyExists(Arguments, "payflowTargetDateBegin_max") and IsDate(Arguments.payflowTargetDateBegin_max)>AND payflowTargetDateBegin <= <cfqueryparam Value="#Arguments.payflowTargetDateBegin_max#" cfsqltype="cf_sql_timestamp"></cfif>
			<cfif StructKeyExists(Arguments, "payflowTargetHasEndDate") and ListFind("0,1", Arguments.payflowTargetHasEndDate)>AND payflowTargetDateEnd IS <cfif Arguments.payflowTargetHasEndDate is 0> NOT </cfif> NULL</cfif>
			<cfif StructKeyExists(Arguments, "payflowTargetDateEnd_min") and (Arguments.payflowTargetDateEnd_min is "" or IsDate(Arguments.payflowTargetDateEnd_min))>AND payflowTargetDateEnd <cfif Not IsDate(Arguments.payflowTargetDateEnd_min)> IS NULL <cfelse> >= <cfqueryparam Value="#Arguments.payflowTargetDateEnd_min#" cfsqltype="cf_sql_timestamp"></cfif></cfif>
			<cfif StructKeyExists(Arguments, "payflowTargetDateEnd_max") and (Arguments.payflowTargetDateEnd_max is "" or IsDate(Arguments.payflowTargetDateEnd_max))>AND payflowTargetDateEnd <cfif Not IsDate(Arguments.payflowTargetDateEnd_max)> IS NULL <cfelse> <= <cfqueryparam Value="#Arguments.payflowTargetDateEnd_max#" cfsqltype="cf_sql_timestamp"></cfif></cfif>
	</cfquery>

	<cfreturn qry_selectPayflowTarget>
</cffunction>

<cffunction Name="selectPayflowForCompany" Access="public" Output="No" ReturnType="query" Hint="Determine payflow to use for a company. Returns payflow fields.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_selectPayflowForCompany = QueryNew("blank")>

	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
	</cfinvoke>

	<!--- select all payflow fields except: companyID, userID, payflowDescription, payflowDateCreated, payflowDateUpdated --->
	<cfquery Name="qry_selectPayflowForCompany" Datasource="#Application.billingDsn#" MaxRows="1" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<!--- PayflowTarget: company, affiliate or cobrand --->
		SELECT avPayflowTarget.payflowID, avPayflow.payflowName, avPayflow.payflowID_custom, avPayflow.payflowDefault, avPayflow.payflowStatus, avPayflow.payflowInvoiceSend,
			avPayflow.payflowReceiptSend, avPayflow.payflowInvoiceDaysFromSubscriberDate, avPayflow.payflowChargeDaysFromSubscriberDate, avPayflow.payflowRejectNotifyCustomer,
			avPayflow.payflowRejectNotifyAdmin, avPayflow.payflowRejectRescheduleDays, avPayflow.payflowRejectMaximum_company, avPayflow.payflowRejectMaximum_invoice,
			avPayflow.payflowRejectMaximum_subscriber, avPayflow.payflowRejectTask, avPayflow.payflowOrder, avPayflow.payflowDescription, avPayflow.templateID,
			avPayflow.payflowEmailFromName, avPayflow.payflowEmailReplyTo, avPayflow.payflowEmailSubject, avPayflow.payflowEmailCC, avPayflow.payflowEmailBCC,
			CASE avPayflowTarget.primaryTargetID
			WHEN #Application.fn_GetPrimaryTargetID("companyID")# THEN 1
			WHEN #Application.fn_GetPrimaryTargetID("affiliateID")# THEN 3
			WHEN #Application.fn_GetPrimaryTargetID("cobrandID")# THEN 5
			ELSE 7
			END
			AS payflowPriorityOrder
		FROM avPayflow, avPayflowTarget
		WHERE avPayflow.payflowID = avPayflowTarget.payflowID
			AND avPayflow.payflowStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avPayflowTarget.payflowTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avPayflowTarget.payflowTargetDateBegin <= #Application.billingSql.sql_nowDateTime#
			AND (avPayflowTarget.payflowTargetDateEnd IS NULL OR avPayflowTarget.payflowTargetDateEnd >= #Application.billingSql.sql_nowDateTime#)
			AND ((avPayflowTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("companyID")#" cfsqltype="cf_sql_integer"> AND avPayflowTarget.targetID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">)
				<cfif Application.fn_IsIntegerPositive(qry_selectCompany.affiliateID)>OR (avPayflowTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("affiliateID")#" cfsqltype="cf_sql_integer"> AND avPayflowTarget.targetID = <cfqueryparam Value="#qry_selectCompany.affiliateID#" cfsqltype="cf_sql_integer">)</cfif>
				<cfif Application.fn_IsIntegerPositive(qry_selectCompany.cobrandID)>OR (avPayflowTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("cobrandID")#" cfsqltype="cf_sql_integer"> AND avPayflowTarget.targetID = <cfqueryparam Value="#qry_selectCompany.cobrandID#" cfsqltype="cf_sql_integer">)</cfif>)
		UNION
		<!--- PayflowTarget: group via company, affiliate or cobrand --->
		SELECT avPayflowTarget.payflowID, avPayflow.payflowName, avPayflow.payflowID_custom, avPayflow.payflowDefault, avPayflow.payflowStatus, avPayflow.payflowInvoiceSend,
			avPayflow.payflowReceiptSend, avPayflow.payflowInvoiceDaysFromSubscriberDate, avPayflow.payflowChargeDaysFromSubscriberDate, avPayflow.payflowRejectNotifyCustomer,
			avPayflow.payflowRejectNotifyAdmin, avPayflow.payflowRejectRescheduleDays, avPayflow.payflowRejectMaximum_company, avPayflow.payflowRejectMaximum_invoice,
			avPayflow.payflowRejectMaximum_subscriber, avPayflow.payflowRejectTask, avPayflow.payflowOrder, avPayflow.payflowDescription, avPayflow.templateID,
			avPayflow.payflowEmailFromName, avPayflow.payflowEmailReplyTo, avPayflow.payflowEmailSubject, avPayflow.payflowEmailCC, avPayflow.payflowEmailBCC,
			CASE avPayflowTarget.primaryTargetID
			WHEN #Application.fn_GetPrimaryTargetID("companyID")# THEN 2
			WHEN #Application.fn_GetPrimaryTargetID("affiliateID")# THEN 4
			WHEN #Application.fn_GetPrimaryTargetID("cobrandID")# THEN 6
			ELSE 8
			END
			AS payflowPriorityOrder
		FROM avPayflow, avPayflowTarget, avGroupTarget
		WHERE avPayflow.payflowID = avPayflowTarget.payflowID
			AND avPayflowTarget.primaryTargetID = #Application.fn_GetPrimaryTargetID("groupID")#
			AND avPayflowTarget.targetID = avGroupTarget.groupID
			AND avPayflow.payflowStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avPayflowTarget.payflowTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avPayflowTarget.payflowTargetDateBegin <= #Application.billingSql.sql_nowDateTime#
			AND (avPayflowTarget.payflowTargetDateEnd IS NULL OR avPayflowTarget.payflowTargetDateEnd >= #Application.billingSql.sql_nowDateTime#)
			AND avGroupTarget.groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND ((avGroupTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("companyID")#" cfsqltype="cf_sql_integer"> AND avPayflowTarget.targetID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">)
				<cfif Application.fn_IsIntegerPositive(qry_selectCompany.affiliateID)>OR (avGroupTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("affiliateID")#" cfsqltype="cf_sql_integer"> AND avPayflowTarget.targetID = <cfqueryparam Value="#qry_selectCompany.affiliateID#" cfsqltype="cf_sql_integer">)</cfif>
				<cfif Application.fn_IsIntegerPositive(qry_selectCompany.cobrandID)>OR (avGroupTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("cobrandID")#" cfsqltype="cf_sql_integer"> AND avPayflowTarget.targetID = <cfqueryparam Value="#qry_selectCompany.cobrandID#" cfsqltype="cf_sql_integer">)</cfif>)
		UNION
		<!--- Payflow Default --->
		SELECT avPayflow.payflowID, avPayflow.payflowName, avPayflow.payflowID_custom, avPayflow.payflowDefault, avPayflow.payflowStatus, avPayflow.payflowInvoiceSend,
			avPayflow.payflowReceiptSend, avPayflow.payflowInvoiceDaysFromSubscriberDate, avPayflow.payflowChargeDaysFromSubscriberDate, avPayflow.payflowRejectNotifyCustomer,
			avPayflow.payflowRejectNotifyAdmin, avPayflow.payflowRejectRescheduleDays, avPayflow.payflowRejectMaximum_company, avPayflow.payflowRejectMaximum_invoice,
			avPayflow.payflowRejectMaximum_subscriber, avPayflow.payflowRejectTask, avPayflow.payflowOrder, avPayflow.payflowDescription, avPayflow.templateID,
			avPayflow.payflowEmailFromName, avPayflow.payflowEmailReplyTo, avPayflow.payflowEmailSubject, avPayflow.payflowEmailCC, avPayflow.payflowEmailBCC,
			9 AS payflowPriorityOrder
		FROM avPayflow, avCompany
		WHERE avPayflow.companyID = avCompany.companyID_author
			AND avPayflow.payflowDefault = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
		ORDER BY payflowPriorityOrder, payflowOrder
	</cfquery>

	<cfreturn qry_selectPayflowForCompany>
</cffunction>

</cfcomponent>
