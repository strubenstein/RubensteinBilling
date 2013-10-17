<!--- 
SALES COMMISSIONS
1. Select invoice & related information (line items, company, subscriber)
	- Create new line item query that combines related line items created via step pricing
		Match via subscriptionID OR productID/priceID/manual/order
2. Select targets that are eligible to receive sales commission for this invoice
	- Affiliate
	- Cobrand
	- User(s) (within begin/end date of invoiceDateClosed)
	- Vendor(s) (for line items only)
3. Loop thru each potential target individually
4. Select commission plans for target
	- Applies to target
	- Within begin/end dates
	- Applies to invoice OR products line items via:
		- product
		- parent product
		- category
		- parent category
	If vendor, apply only to vendor products, not entire invoice.
5. For target, determine invoice total for commission calcuation purposes:
	- Do not include line items that have their own commission plans
	- Sum line items of existing products and custom products separately
6. Delete old sales commissions related to this invoice for target, including invoice- and period-based
7. Loop thru commission plans to calculate sales commission
8. Determine commission stage(s) for each commission plan:
	Invoice-Based
		Invoice-Level
			subscriber invoice: Stage 1 begins at subscriberDateCreated
			non-subscriber invoice: Use stage 1
		Line Item-Level
			subscription: Stage 1 begins at subscriptionDateBegin
			manual line item: Use stage 1
	Period-Based
		Stage 1 begins at date salesperson was created:
			userDateCreated
			affiliateDateCreated
			cobrandDateCreated
			vendorDateCreated
			companyDateCreated
9. Calculate sales commission
	Straight percentage
	Straight dollar value
	Minimum/maximum (regardless of method)
	Volume Discount
		- Based on revenue or quantity
		- Step or straight
		- Total commission (step only)
10. Update commissionAppliedStatus = 1 for commissions that are newly applied
--->

<!--- Select invoice, company and subscriber information --->
<cfinclude template="act_calculateSalesCommission_getInvoice.cfm">

<!--- Determine targets potentially eligible to receive sales commission for this invoice --->
<cfinclude template="act_calculateSalesCommission_getTargets.cfm">

<!--- loop thru possible commission targets --->
<cfif commissionTargetList is not "">
	<cfinclude template="act_calculateSalesCommission_affCobUser.cfm">
</cfif>

<cfif vendorList is not "">
	<!--- vendors do not get percentage of custom products, only their own --->
	<cfset invoiceTotalCustomProducts = 0>
	<cfset invoiceQuantityCustomProducts = 0>

	<!--- vendors get 100% of commission --->
	<cfset salesCommissionCustomerPercent = 1>

	<cfinclude template="act_calculateSalesCommission_vendor.cfm">
</cfif>

<!--- Update commissionAppliedStatus = 1 for commissions that are newly applied --->
<cfif commissionID_appliedList is not "">
	<cfquery Name="qry_updateCommissionAppliedStatus" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCommission
		SET commissionAppliedStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE commissionAppliedStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND commissionID IN (<cfqueryparam Value="#commissionID_appliedList#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>
</cfif>

