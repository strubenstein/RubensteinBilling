<!--- 
FLOWCHART:
- Determine subscribers to process today
	- New subscribers to begin processing
	- Continue processing existing subscribers
		- Process payment
		- Generate/send invoice
		- Generate/send receipt
	- Updated billing information is now current
- Determine whether subscriber has active subscriptions
	- Validate subscriptions based on:
		- Begin date
		- End date
		- Maximum # of times to apply
		- Subscription interval
- Verify all quantities are inputted for variable-quantity subscriptions
	- What if quantity is greater than applied maximum? or price maximum?
	- Validate quantities re: maximums when entered?
	- Re-schedule processing to generate invoice after quantities are entered
	- Does subscriber quantity close on day of processing or X days before?
- Determine invoice: generate new invoice or add line items to existing open invoice
- Determine subscription price
	- Pro rate for partial subscription period
	- Flat subscription unit price
	- Parameter exception with price premium/discount
	- Custom price
		- Volume discount pricing
		- Step pricing that leads to multiple line items
		- Custom price stage
			- Within price stage
			- Last price stage continues indefinitely
			- Price completed: use normal product price instead
- Payment
- Notification
	- Customer
	- Admin
- Templates
	- Email
	- Invoice
	- Receipt
	- Store full html/text version in database
- Subscriber Processing Status options
- Manual overrides:
	- Process invoice now
	- Process payment now
	- Delay subscriber processing
	- Cancel subscriber processing



1. Select X subscribers due to be processed today or earlier
2. For each subscriber, select subscriptions due to be processed today
3. For each subscriber, check whether they have an existing open invoice
	- Yes: Add subscription(s) to existing invoice
	- No: Create new invoice
4. Add each subscription as a line item to invoice. 
5. Close invoice.

6. Send invoice to customer
7. Process customer payment
8. Send receipt to customer
9. Send receipt/notice to company
10. Update subscription to new priceStage if priceStage changed?
11. Send subscription renewal notice to customer
12. Send subscription renewal notice to company
INVOICE NOTIFICATION
AUTOMATED PAYMENT
RECEIPT NOTIFICATION
--->

<cfset Variables.dateToday = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 00))>
<cfquery Name="qry_selectSubscriberList" Datasource="#Application.billingDsn#" MaxRows="1" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT subscriberID
	FROM avSubscriber
	WHERE subscriberStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND subscriberCompleted = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND subscriberDateProcessNext <= <cfqueryparam Value="#Variables.dateToday#" cfsqltype="cf_sql_timestamp">
	ORDER BY subscriberDateProcessNext
</cfquery>

<cfif qry_selectSubscriberList.RecordCount is not 0>
	<cfloop Query="qry_selectSubscriberList">
		<cfset Variables.subscriberID = qry_selectSubscriberList.subscriberID>
		<cfinclude template="../../control/c_subscription/c_subscriptionProcess/control_processSubscriber.cfm">
	</cfloop>
</cfif>
