<!--- Check for available payment credits for this subscriber --->
<cfquery Name="qry_selectPaymentCreditList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT paymentCreditID, paymentCreditAmount, paymentCreditName, paymentCreditID_custom,
		paymentCreditAppliedMaximum, paymentCreditAppliedCount, paymentCategoryID,
		paymentCreditRollover, paymentCreditNegativeInvoice,
		(
		SELECT SUM(avInvoicePaymentCredit.invoicePaymentCreditAmount)
		FROM avInvoicePaymentCredit
		WHERE avInvoicePaymentCredit.paymentCreditID = avPaymentCredit.paymentCreditID
		) AS invoicePaymentCreditAmountTotal
	FROM avPaymentCredit
	WHERE paymentCreditStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND paymentCreditCompleted = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND subscriberID = <cfqueryparam Value="#Variables.subscriberID#" cfsqltype="cf_sql_integer">
		AND (paymentCreditDateBegin IS NULL OR paymentCreditDateBegin <= <cfqueryparam Value="#CreateODBCDateTime(Variables.billingPeriodDateEnd)#" cfsqltype="cf_sql_timestamp">)
		AND (paymentCreditDateEnd IS NULL OR paymentCreditDateEnd >= <cfqueryparam Value="#CreateODBCDateTime(Variables.billingPeriodDateBegin)#" cfsqltype="cf_sql_timestamp">)
		<cfif currentInvoiceTotal lte 0>
			AND paymentCreditNegativeInvoice = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		</cfif>
</cfquery>

<cfset Variables.newInvoiceTotal = currentInvoiceTotal>
<cfloop Query="qry_selectPaymentCreditList">
	<cfif Not IsNumeric(qry_selectPaymentCreditList.invoicePaymentCreditAmountTotal)>
		<cfset Variables.amountAvailable = qry_selectPaymentCreditList.paymentCreditAmount>
	<cfelse>
		<cfset Variables.amountAvailable = qry_selectPaymentCreditList.paymentCreditAmount - qry_selectPaymentCreditList.invoicePaymentCreditAmountTotal>
	</cfif>

	<cfif qry_selectPaymentCreditList.paymentCreditNegativeInvoice is 1>
		<cfset Variables.invoicePaymentCreditAmount = Variables.amountAvailable>
	<cfelseif Variables.amountAvailable lte Variables.newInvoiceTotal>
		<cfset Variables.invoicePaymentCreditAmount = Min(Variables.newInvoiceTotal, Variables.amountAvailable)>
	<cfelse>
		<cfset Variables.invoicePaymentCreditAmount = 0>
	</cfif>

	<cfif Variables.invoicePaymentCreditAmount gt 0>
		<cfset Variables.newInvoiceTotal = Variables.newInvoiceTotal - Variables.invoicePaymentCreditAmount>

		<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="insertInvoicePaymentCredit" ReturnVariable="isInvoicePaymentCreditInserted">
			<cfinvokeargument Name="userID" Value="0">
			<cfinvokeargument Name="invoicePaymentCreditManual" Value="0">
			<cfinvokeargument Name="paymentCreditID" Value="#qry_selectPaymentCreditList.aymentCreditID#">
			<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
			<cfinvokeargument Name="invoicePaymentCreditAmount" Value="#Variables.invoicePaymentCreditAmount#">
			<cfinvokeargument Name="invoicePaymentCreditText" Value="#qry_selectPaymentCreditList.paymentCreditName#">
			<cfif Not IsNumeric(qry_selectPaymentCreditList.invoicePaymentCreditAmountTotal) or qry_selectPaymentCreditList.invoicePaymentCreditAmountTotal is 0>
				<cfinvokeargument Name="invoicePaymentCreditRolloverPrevious" Value="0">
			<cfelse>
				<cfinvokeargument Name="invoicePaymentCreditRolloverPrevious" Value="1">
			</cfif>
			<cfif qry_selectPaymentCreditList.paymentCreditRollover is 1 and Variables.invoicePaymentCreditAmount lt Variables.amountAvailable>
				<cfinvokeargument Name="invoicePaymentCreditRolloverNext" Value="1">
			<cfelse>
				<cfinvokeargument Name="invoicePaymentCreditRolloverNext" Value="0">
			</cfif>
		</cfinvoke>
	</cfif>
</cfloop>

<!--- Update invoice totals if any payment credits --->
<cfif qry_selectPaymentCreditList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoiceTotal" ReturnVariable="currentInvoiceTotal">
		<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
	</cfinvoke>
</cfif>
