<cfcomponent DisplayName="PayflowInvoice" Hint="Manages which payflow method is used to process each invoice">

<!--- Payflow Invoice - payflow method used for each invoice --->
<cffunction Name="insertPayflowInvoice" Access="public" Output="No" ReturnType="boolean" Hint="Records which payflow is used for an invoice. Returns True.">
	<cfargument Name="payflowID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="payflowInvoiceStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="payflowInvoiceCompleted" Type="numeric" Required="No" Default="1">
	<cfargument Name="payflowInvoiceManual" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_insertPayflowInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPayflowInvoice
		(
			payflowID, invoiceID, payflowInvoiceStatus, payflowInvoiceCompleted,
			payflowInvoiceManual, userID, payflowInvoiceDateCreated, payflowInvoiceDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.payflowInvoiceStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowInvoiceCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowInvoiceManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updatePayflowInvoice" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing payflow setting for invoice. Returns True.">
	<cfargument Name="payflowInvoiceID" Type="numeric" Required="Yes">
	<cfargument Name="payflowInvoiceStatus" Type="numeric" Required="No">
	<cfargument Name="payflowInvoiceCompleted" Type="numeric" Required="No">
	<cfargument Name="payflowInvoiceManual" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfquery Name="qry_updatePayflowInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPayflowInvoice
		SET
			<cfif StructKeyExists(Arguments, "payflowInvoiceStatus") and ListFind("0,1", Arguments.payflowInvoiceStatus)>payflowInvoiceStatus = <cfqueryparam Value="#Arguments.payflowInvoiceStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowInvoiceCompleted") and ListFind("0,1", Arguments.payflowInvoiceCompleted)>payflowInvoiceCompleted = <cfqueryparam Value="#Arguments.payflowInvoiceCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowInvoiceManual") and ListFind("0,1", Arguments.payflowInvoiceManual)>payflowInvoiceManual = <cfqueryparam Value="#Arguments.payflowInvoiceManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			payflowInvoiceDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE payflowInvoiceID = <cfqueryparam Value="#Arguments.payflowInvoiceID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPayflowInvoice" Access="public" Output="No" ReturnType="query" Hint="Select payflow info for invoice. Returns True.">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">

	<cfset var qry_selectPayflowInvoice = QueryNew("blank")>

	<cfquery Name="qry_selectPayflowInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT payflowInvoiceID, payflowID, payflowInvoiceStatus, payflowInvoiceCompleted,
			payflowInvoiceManual, userID, payflowInvoiceDateCreated, payflowInvoiceDateUpdated
		FROM avPayflowInvoice
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
			AND payflowInvoiceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>

	<cfreturn qry_selectPayflowInvoice>
</cffunction>

<cffunction Name="selectPayflowInvoiceList" Access="public" Output="No" ReturnType="query" Hint="Select payflow method for invoice(s). Returns True.">
	<cfargument Name="payflowInvoiceID" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="payflowInvoiceStatus" Type="numeric" Required="No">
	<cfargument Name="payflowInvoiceCompleted" Type="numeric" Required="No">
	<cfargument Name="payflowInvoiceManual" Type="numeric" Required="No">

	<cfset var qry_selectPayflowInvoiceList = QueryNew("blank")>

	<cfquery Name="qry_selectPayflowInvoiceList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT payflowInvoiceID, payflowID, invoiceID, payflowInvoiceStatus, payflowInvoiceCompleted,
			payflowInvoiceManual, userID, payflowInvoiceDateCreated, payflowInvoiceDateUpdated
		FROM avPayflowInvoice
		WHERE payflowInvoiceID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "payflowInvoiceID") and Application.fn_IsIntegerList(Arguments.payflowInvoiceID)>AND payflowInvoiceID IN (<cfqueryparam Value="#Arguments.payflowInvoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "payflowID") and Application.fn_IsIntegerList(Arguments.payflowID)>AND payflowID IN (<cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerList(Arguments.invoiceID)>AND invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "payflowInvoiceStatus") and ListFind("0,1", Arguments.payflowInvoiceStatus)>AND payflowInvoiceStatus = <cfqueryparam Value="#Arguments.payflowInvoiceStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "payflowInvoiceCompleted") and ListFind("0,1", Arguments.payflowInvoiceCompleted)>AND payflowInvoiceCompleted = <cfqueryparam Value="#Arguments.payflowInvoiceCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "payflowInvoiceManual") and ListFind("0,1", Arguments.payflowInvoiceManual)>AND payflowInvoiceManual = <cfqueryparam Value="#Arguments.payflowInvoiceManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
	</cfquery>

	<cfreturn qry_selectPayflowInvoiceList>
</cffunction>

</cfcomponent>
