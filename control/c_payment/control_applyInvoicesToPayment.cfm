<cfif qry_selectPayment.paymentStatus is not 1 or qry_selectPayment.paymentApproved is not 1>
	<cflocation url="index.cfm?method=#URL.control#.viewPayment#Variables.urlParameters#&paymentID=#URL.paymentID#&error_payment=#Variables.doAction#_status" AddToken="No">
</cfif>

<!--- add invoice(s) to designated payment --->
<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentList" ReturnVariable="qry_selectInvoicePaymentList">
	<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
	<cfinvokeargument Name="returnInvoiceFields" Value="False">
	<cfinvokeargument Name="returnPaymentFields" Value="False">
</cfinvoke>

<cfset Form.invoiceID_not = ValueList(qry_selectInvoicePaymentList.invoiceID)>

<cfset Variables.sumInvoicePaymentAmountForPayment = 0>
<cfloop Query="qry_selectInvoicePaymentList">
	<cfset Variables.sumInvoicePaymentAmountForPayment = Variables.sumInvoicePaymentAmountForPayment + qry_selectInvoicePaymentList.invoicePaymentAmount>
</cfloop>

<cfif Variables.sumInvoicePaymentAmountForPayment gte qry_selectPayment.paymentAmount>
	<cflocation url="index.cfm?method=#URL.control#.viewPayment#Variables.urlParameters#&paymentID=#URL.paymentID#&error_payment=#Variables.doAction#_applied" AddToken="No">
</cfif>

<cfif IsDefined("URL.submitInvoicePayment") and IsDefined("URL.invoiceID") and Application.fn_IsIntegerPositive(URL.invoiceID)>
	<!--- validate all invoices in list that not already added and valid for company --->
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	</cfinvoke>

	<cfif qry_selectInvoice.RecordCount is not ListLen(URL.invoiceID)><!--- invoice does not exist --->
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&paymentID=#URL.paymentID#&error_payment=#Variables.doAction#_exist" AddToken="No">
	<cfelseif qry_selectInvoice.companyID_author is not Session.companyID_author><!--- invoice does not belong to company --->
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&paymentID=#URL.paymentID#&error_payment=#Variables.doAction#_valid" AddToken="No">
	<cfelseif ListFind(Form.invoiceID_not, URL.invoiceID)><!--- this invoice has already been added for this payment --->
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&paymentID=#URL.paymentID#&error_payment=#Variables.doAction#_not" AddToken="No">
	<cfelseif qry_selectInvoice.invoicePaid is 1><!--- invoice is already fully paid --->
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&paymentID=#URL.paymentID#&error_payment=#Variables.doAction#_paid" AddToken="No">
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentAmountTotal" ReturnVariable="qry_selectInvoicePaymentAmountTotal">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	</cfinvoke>

	<cfif Not IsNumeric(qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)>
		<cfset Variables.invoiceTotalRemaining = qry_selectInvoice.invoiceTotal>
	<cfelse>
		<cfset Variables.invoiceTotalRemaining = qry_selectInvoice.invoiceTotal - qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount>
	</cfif>

	<cfif Variables.invoiceTotalRemaining lte 0>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
			<cfinvokeargument Name="invoicePaid" Value="1">
			<cfinvokeargument Name="invoiceDatePaid" Value="#CreateODBCDateTime(Now())#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&error_payment=#Variables.doAction#_paid" AddToken="No">
	</cfif>

	<cfset Variables.invoicePaymentAmount = Min(Variables.invoiceTotalRemaining, qry_selectPayment.paymentAmount - Variables.sumInvoicePaymentAmountForPayment)>

	<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="insertInvoicePayment" ReturnVariable="isInvoicePaymentInserted">
		<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="invoicePaymentManual" Value="1">
		<cfinvokeargument Name="invoicePaymentAmount" Value="#Variables.invoicePaymentAmount#">
	</cfinvoke>

	<cfif Variables.invoicePaymentAmount gte Variables.invoiceTotalRemaining>
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
		<cfinvokeargument name="primaryTargetKey" value="paymentID">
		<cfinvokeargument name="targetID" value="#URL.paymentID#">
	</cfinvoke>

	<cfif (Variables.sumInvoicePaymentAmountForPayment + Variables.invoicePaymentAmount) gte qry_selectPayment.paymentAmount>
		<cflocation url="index.cfm?method=#URL.control#.listInvoicesForPayment#Variables.urlParameters#&paymentID=#URL.paymentID#&confirm_payment=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&paymentID=#URL.paymentID#&confirm_payment=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.insertInvoicePaymentAction = Variables.formAction & "&submitInvoicePayment=True&paymentID=#URL.paymentID#">

<cfset Form.invoicePaid = 0>
<cfset Variables.doAction = "listInvoices">
<cfset Variables.doControl = "invoice">
<cfinclude template="../control.cfm">

