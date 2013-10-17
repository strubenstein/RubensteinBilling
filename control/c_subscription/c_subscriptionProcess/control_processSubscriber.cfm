<!--- 
drop avPayflowInvoice and move to avSubscriberProcess.payflowID instead?
drop avInvoice?
	invoiceDatePaid
	invoiceDateDue
avPriceStage
	? priceStageID_custom?


priceQuantityMinimumPerOrder, priceQuantityMaximumAllCustomers, priceQuantityMaximumPerCustomer
priceAppliedStatus

This file is designed to process the subscriptions of an individual subscriber, potentially within a loop of subscribers.
Input:
	Variables.subscriberID

If process is interrupted while generating invoice, how do we know where to re-start?
	- Need to distinguish between existing line items from manually-created invoice and new subscription line items
	- Flag line items with bit field that is updated when invoice is closed?
	Could use invoiceLineItemStatus along with subscriptionID!


1. Select subscriptions, parameters and parameter exceptions
	Any subscriptions to process in this billing period?
		NO - STOP
		Yes - Continue
2. Any variable-quantity subscriptions?
		NO - Continue
		YES - Are all quantities finalized?
			NO - Stop until all quantities are finalized.
			YES - Continue
3. Select subscriber information (if it does not exist?)
4. Determine payflow method: companyID, groupID or default
5. Generate invoice
	Does company/subscriber have existing open invoice?
		NO - Create new invoice
		YES - Use existing invoice
6. Select custom prices
7. Loop thru subscriptions to add line items
	Full or pro-rated amount
	Quantity
		Fixed
		Variable
	Price
		Fixed
		Custom price
			Single stage
			Multiple stages
			Expires
			Maximum number of quantity/times applied
		Product parameter exception premium/discount
	Product parameters, exception
- 8. Invoice taxes
8. Payment credits that apply to this invoice
9. Close invoice
10. Update subscriptions: ended, number of times applied, next process date
		- End date
		- Maximum number of times applied
11. Update subscriber: next process date
? 12. Update subscriber process: current=0, status
13. Send invoice due date
14. Payment
	- Pay by credit card or check?
		YES - Process or schedule payment
15. Documents
	- Generate invoice?
	- Generate receipt?
16. Notification
	- Send invoice?
	- Send receipt?
	- Text, html or attachment
	- Fax?
17. Salesforce/affiliate/cobrand commission

DEFAULT VARIABLES:
Variables.subscriberID
Variables.subscriberProcessID
Variables.invoiceID

invoiceCompleted?
If no subscriptions, reset next process date for next subscription?

--->

<cfset Variables.isSubscriptionOkToProcess = True>

<!--- 3. Select subscriber information --->
<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
	<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
</cfinvoke>

<cfif qry_selectSubscriber.RecordCount is not 1>
	<cfset Variables.isSubscriptionOkToProcess = False>
</cfif>

<cfif Variables.isSubscriptionOkToProcess is True>
	<!--- 1. Select subscriptions to be processed today. if no subscriptions, STOP --->
	<cfinclude template="act_processSubscriber_getSubscriptions.cfm">
</cfif>

<!--- subscriber has subscriptions that need to be processed --->
<cfif Variables.isSubscriptionOkToProcess is True>
	<!--- If any variable-quantity subscriptions, are all quantities entered? If yes, continue. If not, STOP. --->
	<cfinclude template="act_processSubscriber_checkProcessID.cfm">
	<!--- OUTPUT: Variables.subscriberProcessID --->

	<cfif IsDate(qry_selectSubscriber.subscriberDateProcessLast)>
		<cfset Variables.billingPeriodDateBegin = qry_selectSubscriber.subscriberDateProcessLast>
	<cfelse>
		<cfset Variables.billingPeriodDateBegin = DateAdd("m", -1, Now())>
	</cfif>
	<cfset Variables.billingPeriodDateBegin = CreateDateTime(Year(Variables.billingPeriodDateBegin), Month(Variables.billingPeriodDateBegin), Day(Variables.billingPeriodDateBegin), 00, 00, 00)>

	<cfif IsDate(qry_selectSubscriber.subscriberDateProcessNext)>
		<cfset Variables.billingPeriodDateEnd = DateAdd("d", -1, qry_selectSubscriber.subscriberDateProcessNext)>
	<cfelse>
		<cfset Variables.billingPeriodDateEnd = DateAdd("d", -1, Now())>
	</cfif>
	<cfset Variables.billingPeriodDateBegin = CreateDateTime(Year(Variables.billingPeriodDateBegin), Month(Variables.billingPeriodDateBegin), Day(Variables.billingPeriodDateBegin), 23, 59, 59)>

	<!--- 2. If any variable-quantity subscriptions, are all quantities entered? If yes, continue. If not, STOP. --->
	<cfinclude template="act_processSubscriber_variableQuantity.cfm">
	<!--- OUTPUT: Query quantities for variable-quantity subscriptions --->
</cfif>

<!--- subscriber has subscriptions that need to be processed AND all variable-quantity subscriptions have been received --->
<cfif Variables.isSubscriptionOkToProcess is True>
	<!--- 4. Determine customer payflow method and thus whether to generate invoice --->
	<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="selectPayflowForCompany" ReturnVariable="qry_selectPayflow">
		<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID#">
	</cfinvoke>
	<cfif qry_selectPayflow.RecordCount is 0>
		<cfset Variables.payflowID = 0>
	<cfelse>
		<cfset Variables.payflowID = qry_selectPayflow.payflowID>
	</cfif>

	<!--- 5. Check whether an open invoice exists. if so, use it. not, create it. --->
	<cfinclude template="act_processSubscriber_determineInvoice.cfm">
	<!--- OUTPUT: Variables.invoiceID --->

	<!--- If subscriber process does not exist, create it. otherwise update with new invoiceID. --->
	<cfinclude template="act_processSubscriber_checkProcessID2.cfm">
	<!--- OUTPUT: Variables.subscriberProcessID (if created) --->

	<!--- 6. Select custom prices for subscriptions --->
	<cfinclude template="act_processSubscriber_getPrices.cfm">

	<!--- 7. Loop thru subscriptions to add line items to invoice --->
	<!--- Note: Unlike other files, this includes multiple files. --->
	<cfinclude template="act_processSubscriber_addLineItems.cfm">

	<!--- 8. Determine taxes for invoice and each line item. --->

	<!--- Update invoice totals before checking for payment credits --->
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoiceTotal" ReturnVariable="currentInvoiceTotal">
		<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
	</cfinvoke>

	<!--- 8. Determine payment credits to apply to this invoice. --->
	<cfinclude template="act_processSubscriber_paymentCredit.cfm">

	<!--- 9. Close invoice and update totals --->
	<cfinclude template="act_processSubscriber_closeInvoice.cfm">

	<!--- 10. Update subscriptions: ended, number of times applied, next process date --->
	<cfinclude template="act_processSubscriber_completedSubscriptions.cfm">

	<!--- 11. Update subscriber: ended, number of times applied, next process date --->
	<cfinclude template="act_processSubscriber_updateSubscriber.cfm">

	<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="updateSubscriberProcess" ReturnVariable="isSubscriberProcessUpdated">
		<cfinvokeargument Name="subscriberProcessID" Value="#Variables.subscriberProcessID#">
		<cfinvokeargument Name="subscriberProcessStatus" Value="1">
		<!--- subscriberProcessCurrent --->
	</cfinvoke>

	<!--- 13. Set invoice due date --->
	<cfif Variables.payflowID is not 0>
		<cfset Variables.invoiceDateDue = DateAdd("d", qry_selectPayflow.payflowChargeDaysFromSubscriberDate, Now())>

		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
			<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
			<cfinvokeargument Name="invoicePaid" Value="1">
			<cfinvokeargument Name="invoiceDateDue" Value="#Variables.invoiceDateDue#">
		</cfinvoke>
	</cfif>

	<!--- 14. If paying by credit card or check, pay now or schedule payment --->
	<cfinclude template="act_processSubscriber_processPayment.cfm">

	<!--- 15. Generate invoice via template --->
	<cfif Variables.payflowID is not 0 and qry_selectPayflow.templateID is not 0>
		<cfinclude template="act_processSubscriber_generateInvoiceTemplate.cfm">

		<!--- 16. Send invoice to customer via email --->
		<cfif Variables.payflowID is not 0 and qry_selectPayflow.payflowInvoiceSend is 1>
			<cfinclude template="act_processSubscriber_notifySubscriber.cfm">
		</cfif>
	</cfif>

	<!--- 17. Determine sales commissions for salesperson, affiliate and cobrand. --->
	<!--- Happens automatically when invoice is marked as paid (invoicePaid = 1) --->

	<!--- check for trigger --->
	<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
		<cfinvokeargument name="companyID" value="#Session.companyID#">
		<cfinvokeargument name="doAction" value="processSubscriber">
		<cfinvokeargument name="isWebService" value="False">
		<cfinvokeargument name="doControl" value="subscription">
		<cfinvokeargument name="primaryTargetKey" value="subscriberID">
		<cfinvokeargument name="targetID" value="#Variables.subscriberID#">
	</cfinvoke>
</cfif>

