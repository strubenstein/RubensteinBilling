<!--- 
get manual payments that need to be processed
avPayment.paymentDateScheduled
avPayment.paymentApproved = NULL 

automated payment - is invoice paid?
	invoice completed?
--->

<cfset Variables.dateToday = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 00))>
<cfquery Name="qry_selectPaymentList" Datasource="#Application.billingDsn#" MaxRows="1" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT paymentID
	FROM avPayment
	WHERE paymentStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND paymentProcessed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND merchantAccountID <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
		AND paymentDateScheduled <= <cfqueryparam Value="#Variables.dateToday#" cfsqltype="cf_sql_timestamp">
	ORDER BY paymentDateScheduled
</cfquery>

<cfloop Query="qry_selectPaymentList">
	<cfmodule Template="../merchant/act_processPayment.cfm" paymentID="#qry_selectPaymentList.paymentID#">
	<cfif isPaymentApproved is 1><!--- payment is approved --->
		<cfquery Name="qry_selectInvoicePayment" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT invoiceID
			FROM avInvoicePayment
			WHERE paymentID = <cfqueryparam Value="#qry_selectPaymentList.paymentID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfloop Query="qry_selectInvoicePayment">
			<cfquery Name="qry_updateInvoicePaid" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				UPDATE avInvoice
				SET invoicePaid = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					invoiceDatePaid = #Application.billingSql.sql_nowDateTime#,
					invoiceDateUpdated = #Application.billingSql.sql_nowDateTime#
				WHERE invoiceID = <cfqueryparam Value="#qry_selectPaymentList.invoiceID#" cfsqltype="cf_sql_integer">
					AND invoiceTotal <= 
						(
						SELECT SUM(avInvoicePayment.invoicePaymentAmount)
						FROM avInvoicePayment, avPayment
						WHERE avInvoicePayment.paymentID = avPayment.paymentID
							AND avPayment.paymentApproved = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
							AND avInvoicePayment.invoiceID = <cfqueryparam Value="#qry_selectPaymentList.invoiceID#" cfsqltype="cf_sql_integer">
						)
			</cfquery>
		</cfloop>
	</cfif>
</cfloop>
