<!--- 
Create array used to store 
Multiple line items are necessary for custom pricing where pricing is applied in step fashion
	OR price partially expires during this billing period
--->
<cfset Variables.lineItemArray = ArrayNew(1)>

<!--- for each subscription, determine list of applicable price stages for this billing period --->
<cfinclude template="act_processSubscription_priceStage.cfm">

<!--- determine length of billing period for this subscriber --->
<!--- 
<cfif Not IsDate(qry_selectSubscriber.subscriberDateProcessLast)>
	<cfset Variables.thisSubscriberBillingPeriodLength = DateDiff("d", qry_selectSubscriber.subscriberDateCreated, qry_selectSubscriber.subscriberDateProcessNext)>
<cfelse>
	<cfset Variables.thisSubscriberBillingPeriodLength = DateDiff("d", qry_selectSubscriber.subscriberDateProcessLast, qry_selectSubscriber.subscriberDateProcessNext)>
</cfif>
--->

<!--- Loop thru subscriptions to add line items to invoice --->
<cfloop Query="qry_selectSubscriptionList">
	<!--- Track current subscription row to retrieve subscription info while within inner loops --->
	<cfset Variables.thisSubscriptionRow = qry_selectSubscriptionList.CurrentRow>
	<cfset Variables.thisSubscriptionID = qry_selectSubscriptionList.subscriptionID>

	<!--- determine whether subscription has any product parameters. if so, create list --->
	<!--- determine if there is a price premium because of a parameter exception --->
	<cfinclude template="act_processSubscriber_addLineItems_parameter.cfm">

	<!--- for each subscription, loop thru price stage that applies to this billing period --->
	<cfloop Index="loopPriceStageID" List="#subscriptionID_priceStageIDList["subscription#Variables.thisSubscriptionID#"]#">
		<cfif loopPriceStageID is 0>
			<cfset Variables.priceStageRow = 0>
		<cfelse>
			<cfset Variables.priceStageRow = priceStageStruct["priceStage#loopPriceStageID#"].priceStageRow>
		</cfif>

		<!--- Determine line item quantity for this price stage --->
		<cfinclude template="act_processSubscriber_addLineItems_quantity.cfm">

		<!--- Determine whether to pro-rate subscription --->
		<cfinclude template="act_processSubscriber_addLineItems_proRate.cfm">

		<!--- clear our line item array for each new subscription / price stage --->
		<cfset temp = ArrayClear(Variables.lineItemArray)>

		<cfset Variables.theSubscriptionTax = 0>
		<cfset Variables.theSubscriptionDiscount = qry_selectSubscriptionList.subscriptionDiscount[Variables.thisSubscriptionRow]>

		<cfset Variables.lineItemArray[1] = StructNew()>
		<cfset Variables.lineItemArray[1].quantity = Variables.thisSubscriptionQuantity * Variables.proRatePercentage>
		<cfset Variables.lineItemArray[1].priceUnit = qry_selectSubscriptionList.subscriptionPriceUnit[Variables.thisSubscriptionRow] + Variables.productParameterExceptionPricePremium>
		<cfset Variables.lineItemArray[1].subTotal = Variables.lineItemArray[1].priceUnit * Variables.lineItemArray[1].quantity>
		<cfset Variables.lineItemArray[1].discount = qry_selectSubscriptionList.subscriptionDiscount[Variables.thisSubscriptionRow]>
		<cfset Variables.lineItemArray[1].totalTax = 0>
		<cfset Variables.lineItemArray[1].priceVolumeDiscountID = 0>

		<cfset Variables.invoiceLineItem_priceID = qry_selectSubscriptionList.priceID[Variables.thisSubscriptionRow]>
		<cfset Variables.invoiceLineItem_priceNormal = qry_selectSubscriptionList.subscriptionPriceNormal[Variables.thisSubscriptionRow]>
		<cfset Variables.invoiceLineItem_priceStageID = loopPriceStageID>
		<cfif loopPriceStageID is not 0>
			<cfset Variables.invoiceLineItemDateBegin = priceStageStruct["priceStage#loopPriceStageID#"].priceStageDateBegin>
			<cfset Variables.invoiceLineItemDateEnd = priceStageStruct["priceStage#loopPriceStageID#"].priceStageDateEnd>
		<cfelse>
			<cfset Variables.invoiceLineItemDateBegin = Variables.subscriptionBillingDateBegin>
			<cfset Variables.invoiceLineItemDateEnd = Variables.subscriptionBillingDateEnd>
		</cfif>

		<!--- 
		Custom price
			Single stage
			Multiple stages
			Expires: IGNORED FOR NOW
			Maximum number of quantity/times applied: IGNORED FOR NOW
			Product parameter exception premium/discount

			priceQuantityMinimumPerOrder, priceQuantityMaximumAllCustomers, priceQuantityMaximumPerCustomer
			priceAppliedStatus

			priceDateBegin, priceDateEnd priceStageInterval, priceStageIntervalType,
		--->

		<!--- if rolls up to another subscription --->
		<cfif qry_selectSubscriptionList.subscriptionID_rollup[Variables.thisSubscriptionRow] is not 0>
			<cfset Variables.lineItemArray[1].priceUnit = 0>
			<cfset Variables.lineItemArray[1].subTotal = 0>
			<cfset Variables.lineItemArray[1].discount = 0>

		<!--- if custom price: --->
		<cfelseif loopPriceStageID is not 0>
			<!--- not volume discount --->
			<cfif qry_selectPriceList.priceStageVolumeDiscount[Variables.priceStageRow] is 0>
				<cfinclude template="act_processSubscriber_addLineItems_priceSimple.cfm">

			<!--- volume discount, but not step method --->
			<cfelseif qry_selectPriceList.priceStageVolumeStep[Variables.priceStageRow] is 0>
				<cfinclude template="act_processSubscriber_addLineItems_priceVolume.cfm">

			<!--- volume discount with step method --->
			<cfelse>
				<cfinclude template="act_processSubscriber_addLineItems_priceStep.cfm">
			</cfif>
		</cfif>

		<!--- insert invoice line items --->
		<cfinclude template="act_processSubscriber_addLineItems_insert.cfm">
	</cfloop><!--- /loop thru each price stage of subscription that applies to this billing period --->
</cfloop><!--- loop thru each subscription --->
