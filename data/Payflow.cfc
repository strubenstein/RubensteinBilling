<cfcomponent DisplayName="Payflow" Hint="Manages inserting, updating, and viewing invoice and payment payflow.">

<cffunction name="maxlength_Payflow" access="public" output="no" returnType="struct">
	<cfset var maxlength_Payflow = StructNew()>

	<cfset maxlength_Payflow.payflowName = 100>
	<cfset maxlength_Payflow.payflowID_custom = 50>
	<cfset maxlength_Payflow.payflowDescription = 255>
	<cfset maxlength_Payflow.payflowEmailFromName = 100>
	<cfset maxlength_Payflow.payflowEmailReplyTo = 100>
	<cfset maxlength_Payflow.payflowEmailSubject = 100>
	<cfset maxlength_Payflow.payflowEmailCC = 255>
	<cfset maxlength_Payflow.payflowEmailBCC = 255>

	<cfreturn maxlength_Payflow>
</cffunction>

<!--- Payflow --->
<cffunction Name="insertPayflow" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new payflow method. Returns payflowID.">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="payflowName" Type="string" Required="No" Default="">
	<cfargument Name="payflowID_custom" Type="string" Required="No" Default="">
	<cfargument Name="payflowDefault" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowInvoiceSend" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowReceiptSend" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowInvoiceDaysFromSubscriberDate" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowChargeDaysFromSubscriberDate" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowRejectNotifyCustomer" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowRejectNotifyAdmin" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowRejectRescheduleDays" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowRejectMaximum_company" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowRejectMaximum_invoice" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowRejectMaximum_subscriber" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowRejectTask" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowDescription" Type="string" Required="No" Default="">
	<cfargument Name="templateID" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowEmailFromName" Type="string" Required="No" Default="">
	<cfargument Name="payflowEmailReplyTo" Type="string" Required="No" Default="">
	<cfargument Name="payflowEmailSubject" Type="string" Required="No" Default="">
	<cfargument Name="payflowEmailCC" Type="string" Required="No" Default="">
	<cfargument Name="payflowEmailBCC" Type="string" Required="No" Default="">

	<cfset var qry_insertPayflow = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Payflow" method="maxlength_Payflow" returnVariable="maxlength_Payflow" />

	<cfquery Name="qry_insertPayflow" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif Arguments.incrementPayflowOrder is True>
			UPDATE avPayflow
			SET payflowOrder = payflowOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND payflowOrder >= <cfqueryparam Value="#Arguments.payflowOrder#" cfsqltype="cf_sql_smallint">;
		</cfif>

		INSERT INTO avPayflow
		(
			companyID, userID, payflowName, payflowID_custom, payflowDefault, payflowStatus, payflowInvoiceSend,
			payflowReceiptSend, payflowInvoiceDaysFromSubscriberDate, payflowChargeDaysFromSubscriberDate,
			payflowRejectNotifyCustomer, payflowRejectNotifyAdmin, payflowRejectRescheduleDays, payflowRejectMaximum_company,
			payflowRejectMaximum_invoice, payflowRejectMaximum_subscriber, payflowRejectTask, payflowOrder,
			payflowDescription, templateID, payflowEmailFromName, payflowEmailReplyTo, payflowEmailSubject,
			payflowEmailCC, payflowEmailBCC, payflowDateCreated, payflowDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.payflowName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowName#">,
			<cfqueryparam Value="#Arguments.payflowID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowID_custom#">,
			<cfqueryparam Value="#Arguments.payflowDefault#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowInvoiceSend#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowReceiptSend#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowInvoiceDaysFromSubscriberDate#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.payflowChargeDaysFromSubscriberDate#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.payflowRejectNotifyCustomer#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowRejectNotifyAdmin#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowRejectRescheduleDays#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.payflowRejectMaximum_company#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.payflowRejectMaximum_invoice#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.payflowRejectMaximum_subscriber#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.payflowRejectTask#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.payflowDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowDescription#">,
			<cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.payflowEmailFromName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowEmailFromName#">,
			<cfqueryparam Value="#Arguments.payflowEmailReplyTo#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowEmailReplyTo#">,
			<cfqueryparam Value="#Arguments.payflowEmailSubject#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowEmailSubject#">,
			<cfqueryparam Value="#Arguments.payflowEmailCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowEmailCC#">,
			<cfqueryparam Value="#Arguments.payflowEmailBCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowEmailBCC#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "payflowID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertPayflow.primaryKeyID>
</cffunction>

<cffunction Name="updatePayflow" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing payflow. Returns True.">
	<cfargument Name="payflowID" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="payflowName" Type="string" Required="No">
	<cfargument Name="payflowDefault" Type="numeric" Required="No">
	<cfargument Name="payflowStatus" Type="numeric" Required="No">
	<cfargument Name="payflowInvoiceSend" Type="numeric" Required="No">
	<cfargument Name="payflowReceiptSend" Type="numeric" Required="No">
	<cfargument Name="payflowInvoiceDaysFromSubscriberDate" Type="numeric" Required="No">
	<cfargument Name="payflowChargeDaysFromSubscriberDate" Type="numeric" Required="No">
	<cfargument Name="payflowRejectNotifyCustomer" Type="numeric" Required="No">
	<cfargument Name="payflowRejectNotifyAdmin" Type="numeric" Required="No">
	<cfargument Name="payflowRejectRescheduleDays" Type="numeric" Required="No">
	<cfargument Name="payflowRejectMaximum_company" Type="numeric" Required="No">
	<cfargument Name="payflowRejectMaximum_invoice" Type="numeric" Required="No">
	<cfargument Name="payflowRejectMaximum_subscriber" Type="numeric" Required="No">
	<cfargument Name="payflowRejectTask" Type="numeric" Required="No">
	<cfargument Name="payflowDescription" Type="string" Required="No">
	<cfargument Name="payflowOrder" Type="numeric" Required="No">
	<cfargument Name="incrementPayflowOrder" Type="boolean" Default="False">
	<cfargument Name="templateID" Type="numeric" Required="No">
	<cfargument Name="payflowEmailFromName" Type="string" Required="No">
	<cfargument Name="payflowEmailReplyTo" Type="string" Required="No">
	<cfargument Name="payflowEmailSubject" Type="string" Required="No">
	<cfargument Name="payflowEmailCC" Type="string" Required="No">
	<cfargument Name="payflowEmailBCC" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Payflow" method="maxlength_Payflow" returnVariable="maxlength_Payflow" />

	<cfquery Name="qry_updatePayflow" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPayflow
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowName")>payflowName = <cfqueryparam Value="#Arguments.payflowName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowName#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowID_custom")>payflowID_custom = <cfqueryparam Value="#Arguments.payflowID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowDefault") and ListFind("0,1", Arguments.payflowDefault)>payflowDefault = <cfqueryparam Value="#Arguments.payflowDefault#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowStatus") and ListFind("0,1", Arguments.payflowStatus)>payflowStatus = <cfqueryparam Value="#Arguments.payflowStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowInvoiceSend") and ListFind("0,1", Arguments.payflowInvoiceSend)>payflowInvoiceSend = <cfqueryparam Value="#Arguments.payflowInvoiceSend#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowReceiptSend") and ListFind("0,1", Arguments.payflowReceiptSend)>payflowReceiptSend = <cfqueryparam Value="#Arguments.payflowReceiptSend#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowInvoiceDaysFromSubscriberDate") and Application.fn_IsIntegerNonNegative(Arguments.payflowInvoiceDaysFromSubscriberDate)>payflowInvoiceDaysFromSubscriberDate = <cfqueryparam Value="#Arguments.payflowInvoiceDaysFromSubscriberDate#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowChargeDaysFromSubscriberDate") and Application.fn_IsIntegerNonNegative(Arguments.payflowChargeDaysFromSubscriberDate)>payflowChargeDaysFromSubscriberDate = <cfqueryparam Value="#Arguments.payflowChargeDaysFromSubscriberDate#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowRejectNotifyCustomer") and ListFind("0,1", Arguments.payflowRejectNotifyCustomer)>payflowRejectNotifyCustomer = <cfqueryparam Value="#Arguments.payflowRejectNotifyCustomer#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowRejectNotifyAdmin") and ListFind("0,1", Arguments.payflowRejectNotifyAdmin)>payflowRejectNotifyAdmin = <cfqueryparam Value="#Arguments.payflowRejectNotifyAdmin#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowRejectRescheduleDays") and Application.fn_IsIntegerNonNegative(Arguments.payflowRejectRescheduleDays)>payflowRejectRescheduleDays = <cfqueryparam Value="#Arguments.payflowRejectRescheduleDays#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowRejectMaximum_company") and Application.fn_IsIntegerNonNegative(Arguments.payflowRejectMaximum_company)>payflowRejectMaximum_company = <cfqueryparam Value="#Arguments.payflowRejectMaximum_company#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowRejectMaximum_invoice") and Application.fn_IsIntegerNonNegative(Arguments.payflowRejectMaximum_invoice)>payflowRejectMaximum_invoice = <cfqueryparam Value="#Arguments.payflowRejectMaximum_invoice#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowRejectMaximum_subscriber") and Application.fn_IsIntegerNonNegative(Arguments.payflowRejectMaximum_subscriber)>payflowRejectMaximum_subscriber = <cfqueryparam Value="#Arguments.payflowRejectMaximum_subscriber#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowRejectTask") and ListFind("0,1", Arguments.payflowRejectTask)>payflowRejectTask = <cfqueryparam Value="#Arguments.payflowRejectTask#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowOrder") and Application.fn_IsIntegerNonNegative(Arguments.payflowOrder)>payflowOrder = <cfqueryparam Value="#Arguments.payflowOrder#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowDescription")>payflowDescription = <cfqueryparam Value="#Arguments.payflowDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "templateID") and Application.fn_IsIntegerNonNegative(Arguments.templateID)>templateID = <cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowEmailFromName")>payflowEmailFromName = <cfqueryparam Value="#Arguments.payflowEmailFromName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowEmailFromName#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowEmailReplyTo")>payflowEmailReplyTo = <cfqueryparam Value="#Arguments.payflowEmailReplyTo#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowEmailReplyTo#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowEmailSubject")>payflowEmailSubject = <cfqueryparam Value="#Arguments.payflowEmailSubject#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowEmailSubject#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowEmailCC")>payflowEmailCC = <cfqueryparam Value="#Arguments.payflowEmailCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowEmailCC#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowEmailBCC")>payflowEmailBCC = <cfqueryparam Value="#Arguments.payflowEmailBCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Payflow.payflowEmailBCC#">,</cfif>
			payflowDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE payflowID = <cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkPayflowPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check company permission for existing payflow(s)">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="payflowID" Type="string" Required="Yes">

	<cfset var qry_checkPayflowPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.payflowID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkPayflowPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT payflowID
			FROM avPayflow
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND payflowID IN (<cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfif qry_checkPayflowPermission.RecordCount is 0 or qry_checkPayflowPermission.RecordCount is not ListLen(Arguments.payflowID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="checkPayflowNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check payflow name is unique">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="payflowName" Type="string" Required="Yes">
	<cfargument Name="payflowID" Type="numeric" Required="No">

	<cfset var qry_checkPayflowNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkPayflowNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT payflowID
		FROM avPayflow
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND payflowName = <cfqueryparam Value="#Arguments.payflowName#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "payflowID") and Application.fn_IsIntegerPositive(Arguments.payflowID)>
				AND payflowID <> <cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkPayflowNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkPayflowID_customIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check payflow custom ID is unique">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="payflowID_custom" Type="string" Required="Yes">
	<cfargument Name="payflowID" Type="numeric" Required="No">

	<cfset var qry_checkPayflowID_customIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkPayflowID_customIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT payflowID
		FROM avPayflow
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND payflowID_custom = <cfqueryparam Value="#Arguments.payflowID_custom#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "payflowID") and Application.fn_IsIntegerPositive(Arguments.payflowID)>
				AND payflowID <> <cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkPayflowID_customIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectPayflow" Access="public" Output="No" ReturnType="query" Hint="Select existing payflow setting">
	<cfargument Name="payflowID" Type="numeric" Required="Yes">

	<cfset var qry_selectPayflow = QueryNew("blank")>

	<cfquery Name="qry_selectPayflow" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID, userID, payflowName, payflowID_custom, payflowDefault, payflowStatus,
			payflowInvoiceSend, payflowReceiptSend, payflowInvoiceDaysFromSubscriberDate,
			payflowChargeDaysFromSubscriberDate, payflowRejectNotifyCustomer, payflowRejectNotifyAdmin,
			payflowRejectRescheduleDays, payflowRejectMaximum_company, payflowRejectMaximum_invoice,
			payflowRejectMaximum_subscriber, payflowRejectTask, payflowOrder, payflowDescription,
			templateID, payflowEmailFromName, payflowEmailReplyTo, payflowEmailSubject, payflowEmailCC,
			payflowEmailBCC, payflowDateCreated, payflowDateUpdated
		FROM avPayflow
		WHERE payflowID = <cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectPayflow>
</cffunction>

<cffunction Name="selectPayflowIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects payflowID of existing payflow via custom ID and returns payflowID(s) if exists, 0 if not exists, and -1 if multiple payflows have the same payflowID_custom.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="payflowID_custom" Type="string" Required="Yes">

	<cfset var qry_selectPayflowIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectPayflowIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT payflowID
		FROM avPayflow
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND payflowID_custom IN (<cfqueryparam Value="#Arguments.payflowID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>
	
	<cfif qry_selectPayflowIDViaCustomID.RecordCount is 0 or qry_selectPayflowIDViaCustomID.RecordCount lt ListLen(Arguments.payflowID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectPayflowIDViaCustomID.RecordCount gt ListLen(Arguments.payflowID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectPayflowIDViaCustomID.payflowID)>
	</cfif>
</cffunction>

<cffunction Name="selectPayflowList" Access="public" Output="No" ReturnType="query" Hint="Select existing payflow settings">
	<cfargument Name="companyID" Type="numeric" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="payflowStatus" Type="numeric" Required="No">
	<cfargument Name="payflowID_custom" Type="string" Required="No">
	<cfargument Name="payflowTemplateType" Type="string" Required="No">
	<cfargument Name="payflowTemplateNotifyMethod" Type="string" Required="No">
	<cfargument Name="payflowTemplatePaymentMethod" Type="string" Required="No">

	<cfset var qry_selectPayflowList = QueryNew("blank")>

	<cfquery Name="qry_selectPayflowList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT payflowID, companyID, userID, payflowName, payflowID_custom, payflowDefault, payflowStatus,
			payflowInvoiceSend, payflowReceiptSend, payflowInvoiceDaysFromSubscriberDate,
			payflowChargeDaysFromSubscriberDate, payflowRejectNotifyCustomer, payflowRejectNotifyAdmin,
			payflowRejectRescheduleDays, payflowRejectMaximum_company, payflowRejectMaximum_invoice,
			payflowRejectMaximum_subscriber, payflowRejectTask, payflowOrder, payflowDescription,
			templateID, payflowEmailFromName, payflowEmailReplyTo, payflowEmailSubject, payflowEmailCC,
			payflowEmailBCC, payflowDateCreated, payflowDateUpdated
		FROM avPayflow
		WHERE payflowID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID)>AND companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "payflowID") and Application.fn_IsIntegerList(Arguments.payflowID)>AND payflowID IN (<cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "payflowStatus") and ListFind("0,1", Arguments.payflowStatus)>AND payflowStatus = <cfqueryparam Value="#Arguments.payflowStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "payflowID_custom") and Trim(Arguments.payflowID_custom) is not "">AND payflowID_custom IN (<cfqueryparam Value="#Arguments.payflowID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "payflowDefault") and ListFind("0,1", Arguments.payflowDefalt)>AND payflowDefault = <cfqueryparam Value="#Arguments.payflowDefault#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
	</cfquery>

	<cfreturn qry_selectPayflowList>
</cffunction>

<cffunction Name="switchPayflowOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing payflows">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="payflowID" Type="numeric" Required="Yes">
	<cfargument Name="payflowOrder_direction" Type="string" Required="Yes">

	<cfset var qry_selectPayflowOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchPayflowOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPayflow
		SET payflowOrder = payflowOrder 
			<cfif Arguments.payflowOrder_direction is "movePayflowDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE payflowID = <cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avPayflow
			SET payflowOrder = payflowOrder 
				<cfif Arguments.payflowOrder_direction is "movePayflowDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND payflowID <> <cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">
				AND payflowOrder = (SELECT payflowOrder FROM avPayflow WHERE payflowID = <cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">);
		<cfelse>
			UPDATE avPayflow
			SET payflowOrder = payflowOrder 
				<cfif Arguments.payflowOrder_direction is "movePayflowDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND payflowID <> <cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">
				AND payflowOrder = (SELECT payflowOrder FROM avPayflow WHERE payflowID = <cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>




</cfcomponent>
