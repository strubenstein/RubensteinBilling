<cfcomponent DisplayName="SubscriberProcess" Hint="Manages periodic processing of subscribers and subscriptions">

<cffunction Name="insertSubscriberProcess" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new subscriber process. Returns subscriberProcessID.">
	<cfargument Name="subscriberID" Type="numeric" Required="Yes">
	<cfargument Name="subscriberProcessDate" Type="date" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberProcessExistingInvoice" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberProcessCurrent" Type="numeric" Required="No" Default="1">
	<cfargument Name="subscriberProcessStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberProcessAllQuantitiesEntered" Type="numeric" Required="No" Default="0">

	<cfset var qry_insertSubscriberProcess = QueryNew("blank")>

	<cfquery Name="qry_insertSubscriberProcess" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif Arguments.subscriberProcessCurrent is 1>
			UPDATE avSubscriberProcess
			SET subscriberProcessCurrent = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			WHERE subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">
				AND subscriberProcessCurrent = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;
		</cfif>

		INSERT INTO avSubscriberProcess
		(
			subscriberID, subscriberProcessDate, invoiceID, subscriberProcessExistingInvoice, subscriberProcessCurrent,
			subscriberProcessStatus, subscriberProcessAllQuantitiesEntered, subscriberProcessDateCreated, subscriberProcessDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriberProcessDate#" cfsqltype="cf_sql_timestamp">,
			<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriberProcessExistingInvoice#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriberProcessCurrent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriberProcessStatus#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.subscriberProcessAllQuantitiesEntered#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "subscriberProcessID", "ALL")#;
	</cfquery>

	<cfif Arguments.subscriberProcessAllQuantitiesEntered is 1>
		<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="updateSubscriptionProcess_rollup" ReturnVariable="isSubscriptionProcessRolledUp">
			<cfinvokeargument Name="subscriberProcessID" Value="#qry_insertSubscriberProcess.primaryKeyID#">
		</cfinvoke>
	</cfif>

	<cfreturn qry_insertSubscriberProcess.primaryKeyID>
</cffunction>

<cffunction Name="updateSubscriberProcess" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing subscriber process. Returns True.">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="Yes">
	<cfargument Name="subscriberProcessDate" Type="date" Required="No">
	<cfargument Name="invoiceID" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessExistingInvoice" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessCurrent" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessAllQuantitiesEntered" Type="numeric" Required="No">

	<cfquery Name="qry_updateSubscriberProcess" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avSubscriberProcess
		SET
			<cfif StructKeyExists(Arguments, "subscriberProcessDate") and IsDate(Arguments.subscriberProcessDate)>subscriberProcessDate = <cfqueryparam Value="#Arguments.subscriberProcessDate#" cfsqltype="cf_sql_timestamp">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerNonNegative(Arguments.invoiceID)>invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberProcessExistingInvoice") and ListFind("0,1", Arguments.subscriberProcessExistingInvoice)>subscriberProcessExistingInvoice = <cfqueryparam Value="#Arguments.subscriberProcessExistingInvoice#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberProcessCurrent") and ListFind("0,1", Arguments.subscriberProcessCurrent)>subscriberProcessCurrent = <cfqueryparam Value="#Arguments.subscriberProcessCurrent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberProcessStatus") and Application.fn_IsIntegerNonNegative(Arguments.subscriberStatus) and Arguments.subscriberStatus lte 255>subscriberProcessStatus = <cfqueryparam Value="#Arguments.subscriberProcessStatus#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberProcessAllQuantitiesEntered") and ListFind("0,1", Arguments.subscriberProcessAllQuantitiesEntered)>subscriberProcessAllQuantitiesEntered = <cfqueryparam Value="#Arguments.subscriberProcessAllQuantitiesEntered#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			subscriberProcessDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE subscriberProcessID = <cfqueryparam Value="#Arguments.subscriberProcessID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif StructKeyExists(Arguments, "subscriberProcessAllQuantitiesEntered") and Arguments.subscriberProcessAllQuantitiesEntered is 1>
		<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="updateSubscriptionProcess_rollup" ReturnVariable="isSubscriptionProcessRolledUp">
			<cfinvokeargument Name="subscriberProcessID" Value="#Arguments.subscriberProcessID#">
		</cfinvoke>
	</cfif>

	<cfreturn True>
</cffunction>

<cffunction Name="selectSubscriberProcess" Access="public" Output="No" ReturnType="query" Hint="Select existing subscriber process.">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="Yes">

	<cfset var qry_selectSubscriberProcess = QueryNew("blank")>

	<cfquery Name="qry_selectSubscriberProcess" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT subscriberID, subscriberProcessDate, invoiceID, subscriberProcessExistingInvoice,
			subscriberProcessCurrent, subscriberProcessStatus, subscriberProcessAllQuantitiesEntered,
			subscriberProcessDateCreated, subscriberProcessDateUpdated
		FROM avSubscriberProcess
		WHERE subscriberProcessID = <cfqueryparam Value="#Arguments.subscriberProcessID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectSubscriberProcess>
</cffunction>

<cffunction Name="selectSubscriberProcessList" Access="public" Output="No" ReturnType="query" Hint="Select existing subscriber processes.">
	<cfargument Name="subscriberProcessID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="subscriberProcessDate" Type="date" Required="No">
	<cfargument Name="subscriberProcessDate_from" Type="string" Required="No">
	<cfargument Name="subscriberProcessDate_to" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="subscriberProcessExistingInvoice" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessCurrent" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessStatus" Type="string" Required="No">
	<cfargument Name="subscriberProcessAllQuantitiesEntered" Type="numeric" Required="No">

	<cfset var qry_selectSubscriberProcessList = QueryNew("blank")>

	<cfquery Name="qry_selectSubscriberProcessList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT subscriberProcessID, subscriberID, subscriberProcessDate, subscriberProcessExistingInvoice,
			invoiceID, subscriberProcessCurrent, subscriberProcessStatus, subscriberProcessAllQuantitiesEntered,
			subscriberProcessDateCreated, subscriberProcessDateUpdated
		FROM avSubscriberProcess
		WHERE subscriberProcessID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="subscriberProcessID,subscriberID,invoiceID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND #field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfloop Index="field" List="subscriberProcessExistingInvoice,subscriberProcessCurrent,subscriberProcessAllQuantitiesEntered">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND #field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "subscriberProcessStatus") and Application.fn_IsIntegerList(Arguments.subscriberProcessStatus)>
				AND subscriberProcessStatus IN (<cfqueryparam Value="#Arguments.subscriberProcessStatus#" cfsqltype="cf_sql_tinyint" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriberProcessDate") and IsDate(Arguments.subscriberProcessDate)>
				AND subscriberProcessDate BETWEEN
				<cfqueryparam Value="#CreateODBCDateTime(CreateDateTime(Year(Arguments.subscriberProcessDate), Month(Arguments.subscriberProcessDate), Day(Arguments.subscriberProcessDate), 0, 00, 00))#" cfsqltype="cf_sql_timestamp">
				AND
				<cfqueryparam Value="#CreateODBCDateTime(CreateDateTime(Year(Arguments.subscriberProcessDate), Month(Arguments.subscriberProcessDate), Day(Arguments.subscriberProcessDate), 23, 59, 00))#" cfsqltype="cf_sql_timestamp">
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriberProcessDate_from") and IsDate(Arguments.subscriberProcessDate_from)>
				AND subscriberProcessDate >= <cfqueryparam Value="#CreateODBCDateTime(Arguments.subscriberProcessDate_from)#" cfsqltype="cf_sql_timestamp">
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriberProcessDate_to") and IsDate(Arguments.subscriberProcessDate_to)>
				AND subscriberProcessDate <= <cfqueryparam Value="#CreateODBCDateTime(Arguments.subscriberProcessDate_to)#" cfsqltype="cf_sql_timestamp">
			</cfif>
		ORDER BY subscriberID, subscriberProcessDate
	</cfquery>

	<cfreturn qry_selectSubscriberProcessList>
</cffunction>

</cfcomponent>
