<cfswitch expression="#Variables.chartQuery#">
<cfcase value="qry_selectAdminMain_task">
	<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="index.cfm?method=task.listTasks&taskStatus=1&taskCompleted=0">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_task" ItemColumn="taskDateScheduled" ValueColumn="countTask" SeriesColor="purple" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_subscriberProcessed">
	<cfchart Format="flash" ChartHeight="125" xAxisTitle="" yAxisTitle="" URL="index.cfm?method=subscriber.listSubscribers">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_subscriberProcessed" ItemColumn="subscriberProcessDate" ValueColumn="countSubscriberProcess" SeriesColor="red" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_subscriberScheduled">
	<cfchart Format="flash" ChartHeight="125" xAxisTitle="Subscriber Process Date" yAxisTitle="## Subscribers" URL="index.cfm?method=subscriber.listSubscribers">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_subscriberScheduled" ItemColumn="subscriberDateProcessNext" ValueColumn="countSubscriber" SeriesColor="red" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_subscriberQuantity">
	<cfchart Format="flash" ChartHeight="125" xAxisTitle="Subscriber Process Date" yAxisTitle="## Subscribers" URL="index.cfm?method=subscriber.listSubscribers">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_subscriberQuantity" ItemColumn="subscriberProcessDate" ValueColumn="countSubscriberProcess" SeriesColor="red" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_paymentSuccess">
	<cfchart Format="flash" ChartHeight="150" xAxisTitle="" yAxisTitle="" LabelFormat="currency" URL="index.cfm?method=payment.listPayments">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentSuccess" ItemColumn="paymentDateReceived" ValueColumn="sumPaymentAmount" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
	<br>
	<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="index.cfm?method=payment.listPayments">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentSuccess" ItemColumn="paymentDateReceived" ValueColumn="countPayment" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_paymentReject">
	<cfchart Format="flash" ChartHeight="150" xAxisTitle="" yAxisTitle="" LabelFormat="currency" URL="index.cfm?method=payment.listPayments">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentReject" ItemColumn="paymentDateReceived" ValueColumn="sumPaymentAmount" SeriesColor="yellow" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
	<br>
	<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="index.cfm?method=payment.listPayments">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentReject" ItemColumn="paymentDateReceived" ValueColumn="countPayment" SeriesColor="yellow" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_paymentScheduled">
	<cfchart Format="flash" ChartHeight="150" xAxisTitle="" yAxisTitle="" LabelFormat="currency" URL="index.cfm?method=payment.listPayments">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentScheduled" ItemColumn="paymentDateReceived" ValueColumn="sumPaymentAmount" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
	<br>
	<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="index.cfm?method=payment.listPayments">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentScheduled" ItemColumn="paymentDateReceived" ValueColumn="countPayment" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_paymentRefund">
	<cfchart Format="flash" ChartHeight="150" xAxisTitle="Refund Date" yAxisTitle="$ of Refunds" LabelFormat="currency" URL="index.cfm?method=payment.listPaymentRefunds">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentRefund" ItemColumn="paymentDateReceived" ValueColumn="sumPaymentAmount" SeriesColor="red" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
	<br>
	<cfchart Format="flash" ChartHeight="100" xAxisTitle="Refund Date" yAxisTitle="## of Refunds" URL="index.cfm?method=payment.listPaymentRefunds">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentRefund" ItemColumn="paymentDateReceived" ValueColumn="countPayment" SeriesColor="red" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_paymentCreditCreated">
	<cfchart Format="flash" ChartHeight="150" xAxisTitle="Date Credit Created" yAxisTitle="$ of Credits" LabelFormat="currency" URL="index.cfm?method=payment.listPaymentCredits">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentCreditCreated" ItemColumn="paymentCreditDateCreated" ValueColumn="sumPaymentCreditAmount" SeriesColor="red" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
	<br>
	<cfchart Format="flash" ChartHeight="100" xAxisTitle="Date Credit Created" yAxisTitle="## of Credits" URL="index.cfm?method=payment.listPaymentCredits">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentCreditCreated" ItemColumn="paymentCreditDateCreated" ValueColumn="countPaymentCredit" SeriesColor="red" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_paymentCreditProcessed">
	<cfchart Format="flash" ChartHeight="150" xAxisTitle="" yAxisTitle="" LabelFormat="currency" URL="index.cfm?method=paymentCredit.listPaymentCredits">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentCreditProcessed" ItemColumn="invoicePaymentCreditDate" ValueColumn="sumInvoicePaymentCreditAmount" SeriesColor="red" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
	<br>
	<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="index.cfm?method=paymentCredit.listPaymentCredits">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_paymentCreditProcessed" ItemColumn="invoicePaymentCreditDate" ValueColumn="countInvoicePaymentCredit" SeriesColor="red" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_invoice">
	<cfchart Format="flash" ChartHeight="150" xAxisTitle="" yAxisTitle="" LabelFormat="currency" URL="index.cfm?method=invoice.listInvoices&invoiceClosed=1&invoiceDateFrom_date=#DateFormat(DateAdd('d', -7, Now()), 'mm/dd/yyyy')#">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_invoice" ItemColumn="invoiceDateClosed" ValueColumn="invoiceTotalLineItemSum" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
	<br>
	<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="index.cfm?method=invoice.listInvoices&invoiceClosed=1&invoiceDateFrom_date=#DateFormat(DateAdd('d', -7, Now()), 'mm/dd/yyyy')#">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_invoice" ItemColumn="invoiceDateClosed" ValueColumn="countInvoice" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
<cfcase value="qry_selectAdminMain_invoiceUnpaid">
	<cfchart Format="flash" ChartHeight="150" xAxisTitle="" yAxisTitle="" LabelFormat="currency" URL="index.cfm?method=invoice.listInvoices&invoiceClosed=1&invoiceDateFrom_date=#DateFormat(DateAdd('d', -7, Now()), 'mm/dd/yyyy')#">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_invoiceUnpaid" ItemColumn="invoiceDateClosed" ValueColumn="invoiceTotalLineItemSum" SeriesColor="purple" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
	<br>
	<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="index.cfm?method=invoice.listInvoices&invoiceClosed=1&invoiceDateFrom_date=#DateFormat(DateAdd('d', -7, Now()), 'mm/dd/yyyy')#">
		<cfchartseries Type="bar" Query="qry_selectAdminMain_invoiceUnpaid" ItemColumn="invoiceDateClosed" ValueColumn="countInvoice" SeriesColor="red" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfcase>
</cfswitch>

