<!--- add payment(s) to designated invoice --->
<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentList" ReturnVariable="qry_selectInvoicePaymentList">
	<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	<cfinvokeargument Name="returnInvoiceFields" Value="False">
	<cfinvokeargument Name="returnPaymentFields" Value="False">
</cfinvoke>

<!--- if invoice is fully paid or total payment amounts equal invoice total, stop --->
<cfif qry_selectInvoice.invoicePaid is 1>
	<cflocation url="index.cfm?method=invoice.listPaymentsForInvoice&invoiceID=#URL.invoiceID#&error_payment=invoiceAlreadyPaid" AddToken="No">
<cfelse>
	<cfset Variables.sumInvoicePaymentAmountForInvoice = 0>
	<cfloop Query="qry_selectInvoicePaymentList">
		<cfset Variables.sumInvoicePaymentAmountForInvoice = Variables.sumInvoicePaymentAmountForInvoice + qry_selectInvoicePaymentList.invoicePaymentAmount>
	</cfloop>

	<cfif Variables.sumInvoicePaymentAmountForInvoice gte qry_selectInvoice.invoiceTotal>
		<!--- if necessary, mark invoice as paid --->
		<cfif qry_selectInvoice.invoicePaid is not 1>
			<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
				<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
				<cfinvokeargument Name="invoicePaid" Value="1">
				<cfinvokeargument Name="invoiceDatePaid" Value="#CreateODBCDateTime(Now())#">
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=invoice.listPaymentsForInvoice&invoiceID=#URL.invoiceID#&error_payment=invoiceAlreadyPaid" AddToken="No">
	</cfif>
</cfif>

<cfset Form.paymentID_not = ValueList(qry_selectInvoicePaymentList.paymentID)>

<cfif IsDefined("URL.submitInvoicePayment") and IsDefined("URL.paymentID") and Application.fn_IsIntegerPositive(URL.paymentID)>
	<!--- validate all payments in list that not already added and valid for company --->
	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPayment" ReturnVariable="qry_selectPayment">
		<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
	</cfinvoke>

	<cfif qry_selectPayment.RecordCount is not ListLen(URL.paymentID)>
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&error_payment=#Variables.doAction#_exist" AddToken="No">
	<cfelseif qry_selectPayment.companyID_author is not Session.companyID_author>
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&error_payment=#Variables.doAction#_valid" AddToken="No">
	<cfelseif ListFind(Form.paymentID_not, URL.paymentID)>
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&error_payment=#Variables.doAction#_not" AddToken="No">
	<cfelseif qry_selectPayment.paymentStatus is not 1 or qry_selectPayment.paymentApproved is not 1>
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&error_payment=#Variables.doAction#_status" AddToken="No">
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentAmountTotal" ReturnVariable="qry_selectInvoicePaymentAmountTotal">
		<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
	</cfinvoke>

	<cfif Not IsNumeric(qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)>
		<cfset Variables.paymentAmountAvailable = qry_selectPayment.paymentAmount>
	<cfelse>
		<cfset Variables.paymentAmountAvailable = qry_selectPayment.paymentAmount - qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount>
	</cfif>

	<cfif Variables.paymentAmountAvailable lte 0>
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&error_payment=#Variables.doAction#_applied" AddToken="No">
	</cfif>

	<cfset Variables.invoicePaymentAmount = Min(Variables.paymentAmountAvailable, qry_selectInvoice.invoiceTotal - Variables.sumInvoicePaymentAmountForInvoice)>

	<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="insertInvoicePayment" ReturnVariable="isInvoicePaymentInserted">
		<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="invoicePaymentManual" Value="1">
		<cfinvokeargument Name="invoicePaymentAmount" Value="#Variables.invoicePaymentAmount#">
	</cfinvoke>

	<!--- if amount applied to invoice means invoice is fully paid, update paid to reflect it is paid --->
	<cfif Variables.invoicePaymentAmount gte (qry_selectInvoice.invoiceTotal - Variables.sumInvoicePaymentAmountForInvoice)>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
			<cfinvokeargument Name="invoicePaid" Value="1">
			<cfinvokeargument Name="invoiceDatePaid" Value="#CreateODBCDateTime(Now())#">
		</cfinvoke>
	</cfif>

	<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
		<cfinvokeargument name="companyID" value="#Session.companyID#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="isWebService" value="False">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="primaryTargetKey" value="invoiceID">
		<cfinvokeargument name="targetID" value="#URL.invoiceID#">
	</cfinvoke>

	<cfif Variables.invoicePaymentAmount gte (qry_selectInvoice.invoiceTotal - Variables.sumInvoicePaymentAmountForInvoice)>
		<cflocation url="index.cfm?method=#URL.control#.listPaymentsForInvoice#Variables.urlParameters#&confirm_payment=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&confirm_payment=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.insertInvoicePaymentAction = Variables.formAction & "&submitInvoicePayment=True">

<cfset URL.invoiceID = "">
<cfset Form.paymentIsFullyApplied = 0>
<cfset Form.paymentStatus = 1>
<cfset Form.paymentApproved = 1>
<cfinclude template="control_listPayments.cfm">
