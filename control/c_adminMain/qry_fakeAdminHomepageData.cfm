<!--- get user company name, first and last name --->
<cfset qry_selectAdminMain_user = QueryNew("firstName,lastName,companyName")>
<cfset temp = QueryAddRow(qry_selectAdminMain_user, 1)>
<cfset temp = QuerySetCell(qry_selectAdminMain_user, "firstName", "Demo")>
<cfset temp = QuerySetCell(qry_selectAdminMain_user, "lastName", "Dude")>
<cfset temp = QuerySetCell(qry_selectAdminMain_user, "companyName", "Billing Demo, Inc.")>

<!--- select open tasks for the user from today or earlier --->
<cfset qry_selectAdminMain_task = QueryNew("taskDateScheduled,countTask")>
<cfloop Index="count" From="4" To="0" Step="-1">
	<cfset temp = QueryAddRow(qry_selectAdminMain_task, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_task, "taskDateScheduled", DateFormat(DateAdd("d", -1 * count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_task, "countTask", (count * 2) + 1)>
</cfloop>

<!--- get contact mgmt topics with new messages submitted by customers that have not been responded to --->
<cfset qry_selectAdminMain_contact = QueryNew("contactTopicID,contactTopicName,contactCount")>

<!--- select invoices closed in last 7 days --->
<cfset qry_selectAdminMain_invoice = QueryNew("invoiceDateClosed,countInvoice,invoiceTotalLineItemSum")>
<cfloop Index="count" From="6" To="0" Step="-1">
	<cfset temp = QueryAddRow(qry_selectAdminMain_invoice, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_invoice, "invoiceDateClosed", DateFormat(DateAdd("d", -1 * count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_invoice, "countInvoice", RandRange(6,23))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_invoice, "invoiceTotalLineItemSum", RandRange(500,3000))>
</cfloop>

<!--- select ## of closed invoices that are not paid --->
<cfset qry_selectAdminMain_invoiceUnpaid = QueryNew("invoiceDateClosed,countInvoice,invoiceTotalLineItemSum")>
<cfloop Index="count" From="6" To="0" Step="-1">
	<cfset temp = QueryAddRow(qry_selectAdminMain_invoiceUnpaid, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_invoiceUnpaid, "invoiceDateClosed", DateFormat(DateAdd("d", -1 * count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_invoiceUnpaid, "countInvoice", RandRange(6,23))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_invoiceUnpaid, "invoiceTotalLineItemSum", RandRange(500,3000))>
</cfloop>

<!--- Subscribers processed within the past week --->
<cfset qry_selectAdminMain_subscriberProcessed = QueryNew("subscriberProcessDate,countSubscriberProcess")>
<cfloop Index="count" From="6" To="0" Step="-1">
	<cfset temp = QueryAddRow(qry_selectAdminMain_subscriberProcessed, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_subscriberProcessed, "subscriberProcessDate", DateFormat(DateAdd("d", -1 * count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_subscriberProcessed, "countSubscriberProcess", RandRange(3,18))>
</cfloop>

<!--- Subscribers scheduled to be processed within the coming week --->
<cfset qry_selectAdminMain_subscriberScheduled = QueryNew("subscriberDateProcessNext,countSubscriber")>
<cfloop Index="count" From="0" To="6">
	<cfset temp = QueryAddRow(qry_selectAdminMain_subscriberScheduled, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_subscriberScheduled, "subscriberDateProcessNext", DateFormat(DateAdd("d", count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_subscriberScheduled, "countSubscriber", RandRange(3,18))>
</cfloop>

<!--- Subscribers waiting for final quantities to be processed --->
<cfset qry_selectAdminMain_subscriberQuantity = QueryNew("subscriberProcessDate,countSubscriberProcess")>
<cfloop Index="count" From="2" To="0" Step="-1">
	<cfset temp = QueryAddRow(qry_selectAdminMain_subscriberQuantity, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_subscriberQuantity, "subscriberProcessDate", DateFormat(DateAdd("d", -1 * count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_subscriberQuantity, "countSubscriberProcess", RandRange(0,9))>
</cfloop>

<!--- Payments successfully processed within the past week --->
<cfset qry_selectAdminMain_paymentSuccess = QueryNew("paymentDateReceived,countPayment,sumPaymentAmount")>
<cfloop Index="count" From="6" To="0" Step="-1">
	<cfset temp = QueryAddRow(qry_selectAdminMain_paymentSuccess, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentSuccess, "paymentDateReceived", DateFormat(DateAdd("d", -1 * count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentSuccess, "countPayment", RandRange(2,23))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentSuccess, "sumPaymentAmount", RandRange(500,3000))>
</cfloop>

<!--- Payments rejected within the past week --->
<cfset qry_selectAdminMain_paymentReject = QueryNew("paymentDateReceived,countPayment,sumPaymentAmount")>
<cfloop Index="count" From="6" To="0" Step="-1">
	<cfset temp = QueryAddRow(qry_selectAdminMain_paymentReject, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentReject, "paymentDateReceived", DateFormat(DateAdd("d", -1 * count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentReject, "countPayment", RandRange(1,4))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentReject, "sumPaymentAmount", RandRange(500,3000))>
</cfloop>

<!--- Payments scheduled to be made within the coming week --->
<cfset qry_selectAdminMain_paymentScheduled = QueryNew("paymentDateReceived,countPayment,sumPaymentAmount")>
<cfloop Index="count" From="0" To="6">
	<cfset temp = QueryAddRow(qry_selectAdminMain_paymentScheduled, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentScheduled, "paymentDateReceived", DateFormat(DateAdd("d", count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentScheduled, "countPayment", RandRange(1,12))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentScheduled, "sumPaymentAmount", RandRange(250,3000))>
</cfloop>

<!--- Refunds processed within the past week --->
<cfset qry_selectAdminMain_paymentRefund = QueryNew("paymentDateReceived,countPayment,sumPaymentAmount")>
<cfloop Index="count" From="6" To="0" Step="-1">
	<cfset temp = QueryAddRow(qry_selectAdminMain_paymentReject, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentReject, "paymentDateReceived", DateFormat(DateAdd("d", -1 * count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentReject, "countPayment", RandRange(1,4))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentReject, "sumPaymentAmount", RandRange(500,3000))>
</cfloop>

<!--- Credits created within the past week --->
<cfset qry_selectAdminMain_paymentCreditCreated = QueryNew("paymentCreditDateCreated,countPaymentCredit,sumPaymentCreditAmount")>
<cfloop Index="count" From="6" To="0" Step="-1">
	<cfset temp = QueryAddRow(qry_selectAdminMain_paymentCreditCreated, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentCreditCreated, "paymentCreditDateCreated", DateFormat(DateAdd("d", -1 * count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentCreditCreated, "countPaymentCredit", RandRange(1,4))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentCreditCreated, "sumPaymentCreditAmount", RandRange(25,450))>
</cfloop>

<!--- Credits processed within the past week --->
<cfset qry_selectAdminMain_paymentCreditProcessed = QueryNew("invoicePaymentCreditDate,countInvoicePaymentCredit,sumInvoicePaymentCreditAmount")>
<cfloop Index="count" From="6" To="0" Step="-1">
	<cfset temp = QueryAddRow(qry_selectAdminMain_paymentCreditProcessed, 1)>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentCreditProcessed, "invoicePaymentCreditDate", DateFormat(DateAdd("d", -1 * count, Now()), "mm/dd"))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentCreditProcessed, "countInvoicePaymentCredit", RandRange(1,4))>
	<cfset temp = QuerySetCell(qry_selectAdminMain_paymentCreditProcessed, "sumInvoicePaymentCreditAmount", RandRange(25,450))>
</cfloop>

