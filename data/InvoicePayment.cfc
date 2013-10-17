<cfcomponent DisplayName="InvoicePayment" Hint="Manages creating, viewing and managing payments">

<cffunction Name="insertInvoicePayment" Access="public" Output="No" ReturnType="boolean" Hint="Inserts record that payment applies to invoice. Returns True.">
	<cfargument Name="paymentID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoicePaymentManual" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoicePaymentAmount" Type="numeric" Required="No" Default="0">
	<!--- <cfargument Name="determineInvoicePaymentAmount" Type="boolean" Required="No" Default="False"> --->

	<cfquery Name="qry_insertInvoicePayment" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avInvoicePayment
		(
			invoiceID, paymentID, invoicePaymentManual, userID, invoicePaymentAmount, invoicePaymentDate
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoicePaymentManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoicePaymentAmount#" cfsqltype="cf_sql_money">,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectInvoicePaymentAmountTotal" Access="public" ReturnType="query" Hint="For a given invoice or payment, select how much is paid/applied.">
	<cfargument Name="invoiceID" Type="numeric" Required="No">
	<cfargument Name="paymentID" Type="numeric" Required="No">

	<cfset var qry_selectInvoicePaymentAmountTotal = QueryNew("blank")>
	<cfset var ignore = True>

	<cfif (StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerPositive(Arguments.invoiceID))
			or (StructKeyExists(Arguments, "paymentID") and Application.fn_IsIntegerPositive(Arguments.paymentID))>
		<cfset ignore = True>
	<cfelse>
		<cfset Arguments.invoiceID = 0>
	</cfif>

	<cfquery Name="qry_selectInvoicePaymentAmountTotal" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT SUM(avInvoicePayment.invoicePaymentAmount) AS sumInvoicePaymentAmount
		FROM avInvoicePayment, avPayment
		WHERE avInvoicePayment.paymentID = avPayment.paymentID
			<cfif StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerList(Arguments.invoiceID)>
				AND avInvoicePayment.invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "paymentID") and Application.fn_IsIntegerList(Arguments.paymentID)>
				AND avInvoicePayment.paymentID IN (<cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			AND avPayment.paymentApproved = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avPayment.paymentStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>

	<cfreturn qry_selectInvoicePaymentAmountTotal>
</cffunction>

<cffunction Name="selectInvoicePayment" Access="public" Output="No" ReturnType="query" Hint="Selects invoice payment record.">
	<cfargument Name="paymentID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">

	<cfset var qry_selectInvoicePayment = QueryNew("blank")>

	<cfquery Name="qry_selectInvoicePayment" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT invoicePaymentManual, userID, invoicePaymentAmount, invoicePaymentDate
		FROM avInvoicePayment
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
			AND paymentID = <cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectInvoicePayment>
</cffunction>

<cffunction Name="selectInvoicePaymentList" Access="public" Output="No" ReturnType="query" Hint="Selects invoice payment records for an invoice(s) and/or payment(s).">
	<cfargument Name="paymentID" Type="string" Required="No" Default="0">
	<cfargument Name="invoiceID" Type="string" Required="No" Default="0">
	<cfargument Name="returnInvoiceFields" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnPaymentFields" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectInvoicePaymentList = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.paymentID)>
		<cfset Arguments.paymentID = 0>
	</cfif>

	<cfif Not Application.fn_IsIntegerList(Arguments.invoiceID)>
		<cfset Arguments.invoiceID = 0>
	</cfif>

	<cfquery Name="qry_selectInvoicePaymentList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avInvoicePayment.invoiceID, avInvoicePayment.paymentID,
			avInvoicePayment.invoicePaymentManual, avInvoicePayment.invoicePaymentAmount,
			avInvoicePayment.invoicePaymentDate, avInvoicePayment.userID AS invoicePaymentUserID,
			avUser.firstName, avUser.lastName, avUser.userID_custom
			<cfif Arguments.returnPaymentFields is True>
				, avPayment.userID AS paymentUserID, avPayment.companyID AS paymentCompanyID, avPayment.userID_author, avPayment.companyID_author,
				avPayment.paymentManual, avPayment.creditCardID, avPayment.bankID, avPayment.merchantAccountID,
				avPayment.paymentCheckNumber, avPayment.paymentID_custom, avPayment.paymentStatus, avPayment.paymentApproved,
				avPayment.paymentAmount, avPayment.paymentDescription, avPayment.paymentMessage, avPayment.paymentMethod,
				avPayment.paymentProcessed, avPayment.paymentDateReceived, avPayment.paymentDateScheduled,
				avPayment.paymentCategoryID, avPayment.paymentIsRefund, avPayment.paymentID_refund, avPayment.subscriberID,
				avPayment.subscriberProcessID, avPayment.paymentDateCreated, avPayment.paymentDateUpdated
			</cfif>
			<cfif Arguments.returnInvoiceFields is True>
				, avInvoice.userID AS invoiceUserID, avInvoice.companyID AS invoiceCompanyID, avInvoice.invoiceDateClosed,
				avInvoice.invoiceTotal, avInvoice.invoiceTotalTax, avInvoice.invoiceTotalLineItem,
				avInvoice.invoiceTotalPaymentCredit, avInvoice.invoiceTotalShipping, avInvoice.invoiceID_custom, 
				avInvoice.invoicePaid, avInvoice.invoiceDatePaid, avInvoice.invoiceDateCreated, avInvoice.invoiceDateUpdated
				<cfif Arguments.returnPaymentFields is False>, avInvoice.subscriberID</cfif>
			</cfif>
		FROM avInvoicePayment
			LEFT OUTER JOIN avUser ON avInvoicePayment.userID = avUser.userID
			<cfif Arguments.returnPaymentFields is True>
				LEFT OUTER JOIN avPayment ON avInvoicePayment.paymentID = avPayment.paymentID
			</cfif>
			<cfif Arguments.returnInvoiceFields is True>
				LEFT OUTER JOIN avInvoice ON avInvoicePayment.invoiceID = avInvoice.invoiceID
			</cfif>
		WHERE 
		<cfif Arguments.paymentID is not 0 and Arguments.invoiceID is not 0>
			avInvoicePayment.invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND avInvoicePayment.paymentID IN (<cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			ORDER BY avInvoicePayment.invoiceID
		<cfelseif Arguments.paymentID is not 0>
			avInvoicePayment.paymentID IN (<cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			ORDER BY avInvoicePayment.paymentID
		<cfelseif Arguments.invoiceID is not 0>
			avInvoicePayment.invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			ORDER BY avInvoicePayment.invoiceID
		<cfelse>
			avInvoicePayment.invoiceID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			AND avInvoicePayment.paymentID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
		</cfif>
	</cfquery>

	<cfreturn qry_selectInvoicePaymentList>
</cffunction>

<cffunction Name="deleteInvoicePayment" Access="public" Output="No" ReturnType="boolean" Hint="Delete record that payment applies to invoice. Returns True.">
	<cfargument Name="paymentID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteInvoicePayment" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avInvoicePayment
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
			AND paymentID = <cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
