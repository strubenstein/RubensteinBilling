<!--- Process subscriptions : Run every 5 minutes beginning at 12:00 am --->
<cfset Variables.schedulerDateBegin = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 00, 00))>
<cfset Variables.schedulerURL = Application.billingSecureUrl & "/scheduled/sched_generateSubscriptionInvoice.cfm?IamTheScheduler=True">
<cfset Variables.schedulerName = "Billing - Process Subscriptions and Generate Invoices">
<cfset Variables.schedulerInterval = 5 * 60><!--- 5 minutes --->
<cfinclude template="act_insertSchedulers.cfm">

<!--- Process scheduled payments : Run every 5 minutes beginning at 12:02 am --->
<cfset Variables.schedulerDateBegin = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 02, 00))>
<cfset Variables.schedulerURL = Application.billingSecureUrl & "/scheduled/sched_processPaymentScheduled.cfm?IamTheScheduler=True">
<cfset Variables.schedulerName = "Billing - Process Scheduled Payments">
<cfset Variables.schedulerInterval = 5 * 60><!--- 5 minutes --->
<cfinclude template="act_insertSchedulers.cfm">

<!--- Delete timed-out web services sessions : Run every 2 hours beginning at 12:15 am --->
<cfset Variables.schedulerDateBegin = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 15, 00))>
<cfset Variables.schedulerURL = Application.billingSecureUrl & "/scheduled/sched_deleteWebServiceSessions.cfm?IamTheScheduler=True">
<cfset Variables.schedulerName = "Billing - Delete Timed-Out Web Services Sessions">
<cfset Variables.schedulerInterval = 2 * 60 * 60><!--- every 2 hours --->
<cfinclude template="act_insertSchedulers.cfm">

<!--- Delete old failed login attempts from database : Run every 4 hours beginning at 12:03 am --->
<cfset Variables.schedulerDateBegin = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 03, 00))>
<cfset Variables.schedulerURL = Application.billingSecureUrl & "/scheduled/sched_deleteLoginAttempt.cfm?IamTheScheduler=True">
<cfset Variables.schedulerName = "Billing - Delete Failed Login Attempts">
<cfset Variables.schedulerInterval = 4 * 60 * 60><!--- every 4 hours --->
<cfinclude template="act_insertSchedulers.cfm">

<!--- Update product category status : Run once per day at 12:06 am --->
<cfset Variables.schedulerDateBegin = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 06, 00))>
<cfset Variables.schedulerURL = Application.billingSecureUrl & "/scheduled/sched_updateProductCategoryStatus_dateEnd.cfm?IamTheScheduler=True">
<cfset Variables.schedulerName = "Billing - Update Product Category Listing Status">
<cfset Variables.schedulerInterval = "daily">
<cfinclude template="act_insertSchedulers.cfm">

<!--- Update product availability status : Run once per day at 12:09 am --->
<cfset Variables.schedulerDateBegin = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 09, 00))>
<cfset Variables.schedulerURL = Application.billingSecureUrl & "/scheduled/sched_updateProductIsDateAvailable.cfm?IamTheScheduler=True">
<cfset Variables.schedulerName = "Billing - Update Product Date Availability Status">
<cfset Variables.schedulerInterval = "daily">
<cfinclude template="act_insertSchedulers.cfm">

<!--- Update price availability status : Run once per day at 12:12 am --->
<cfset Variables.schedulerDateBegin = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 12, 00))>
<cfset Variables.schedulerURL = Application.billingSecureUrl & "/scheduled/sched_updatePriceStatus.cfm?IamTheScheduler=True">
<cfset Variables.schedulerName = "Billing - Update Custom Price Availability Status">
<cfset Variables.schedulerInterval = "daily">
<cfinclude template="act_insertSchedulers.cfm">

<!--- Update sales commission finalized  : Run once per day at 12:22 am --->
<cfset Variables.schedulerDateBegin = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 22, 00))>
<cfset Variables.schedulerURL = Application.billingSecureUrl & "/scheduled/sched_updateSalesCommissionFinalized.cfm?IamTheScheduler=True">
<cfset Variables.schedulerName = "Billing - Update Sales Commission Finalized for Period-Based Commissions">
<cfset Variables.schedulerInterval = "daily">
<cfinclude template="act_insertSchedulers.cfm">

<!--- Delete temp files that are more than 24 hours old  : Run once per day at 12:41 am --->
<cfset Variables.schedulerDateBegin = CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 41, 00))>
<cfset Variables.schedulerURL = Application.billingSecureUrl & "/scheduled/sched_deleteTempFiles.cfm?IamTheScheduler=True">
<cfset Variables.schedulerName = "Billing - Delete Old Temp Files">
<cfset Variables.schedulerInterval = "daily">
<cfinclude template="act_insertSchedulers.cfm">

