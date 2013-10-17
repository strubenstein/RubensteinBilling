<!--- 
	Determine whether to pro-rate subscription
	Yes if:
		Subscription should be pro-rated
		Billing period is not full interval for subscription
		Not variable quantity OR quantity is default amount
	Pro-rated amount is based on number of days in period
	If step pricing, quantities and pricing are in proportion to pro-rated amount

	Note: billing period for this bill is not billing period for subscription since subscription could be every 3 months instead of normal 1 month
--->

<cfset Variables.proRateThisSubscription = False>
<cfset Variables.proRatePercentage = 1>

<!--- Determine length of subscription billing period: If first billing period, use begin date (since last date process is null) --->
<cfif Not IsDate(qry_selectSubscriptionList.subscriptionDateProcessLast[Variables.thisSubscriptionRow])>
	<cfset Variables.subscriptionBillingDateBegin = qry_selectSubscriptionList.subscriptionDateBegin[Variables.thisSubscriptionRow]>
<cfelse>
	<cfset Variables.subscriptionBillingDateBegin = CreateODBCDateTime(Max(qry_selectSubscriptionList.subscriptionDateBegin[Variables.thisSubscriptionRow], qry_selectSubscriptionList.subscriptionDateProcessLast[Variables.thisSubscriptionRow]))>
</cfif>

<cfif Not IsDate(qry_selectSubscriptionList.subscriptionDateEnd[Variables.thisSubscriptionRow])>
	<cfset Variables.subscriptionBillingDateEnd = qry_selectSubscriptionList.subscriptionDateProcessNext[Variables.thisSubscriptionRow]>
<cfelse>
	<cfset Variables.subscriptionBillingDateEnd = CreateODBCDateTime(Min(qry_selectSubscriptionList.subscriptionDateProcessNext[Variables.thisSubscriptionRow], qry_selectSubscriptionList.subscriptionDateEnd[Variables.thisSubscriptionRow]))>
</cfif>

<!--- subscription can be pro-rated if necessary --->
<cfif qry_selectSubscriptionList.subscriptionProRate[Variables.thisSubscriptionRow] is 1>
	<!--- subscription quantity is not variable OR quantity for this billing period is default amount (i.e., not specified or blank) --->
	<cfif qry_selectSubscriptionList.subscriptionQuantityVaries[Variables.thisSubscriptionRow] is 0 or Variables.subProcRow is 0 or Not IsNumeric(qry_selectSubscriptionProcessList.subscriptionProcessQuantity[Variables.subProcRow])>
		<!--- custom price and price stage does not have a designated interval (is last/only price stage) --->
		<cfif loopPriceStageID is not 0 and qry_selectPriceList.priceStageIntervalType[Variables.priceStageRow] is not "">
			<cfset Variables.thisSubscriptionBillingPeriodLength = DateDiff(qry_selectPriceList.priceStageIntervalType[Variables.priceStageRow], priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageDateBegin, priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageDateEnd)>
			<cfif Variables.thisSubscriptionBillingPeriodLength lt qry_selectPriceList.priceStageInterval[Variables.priceStageRow]>
				<cfset Variables.proRateThisSubscription = True>
				<cfset Variables.proRatePercentage = Variables.thisSubscriptionBillingPeriodLength / qry_selectPriceList.priceStageInterval[Variables.priceStageRow]>
			</cfif>
		<cfelse>
			<cfset Variables.thisSubscriptionBillingPeriodLength = DateDiff(qry_selectSubscriptionList.subscriptionIntervalType[Variables.thisSubscriptionRow], Variables.subscriptionBillingDateBegin, Variables.subscriptionBillingDateEnd)>
			<!--- 
			<cfif Not IsDate(qry_selectSubscriptionList.subscriptionDateProcessLast[Variables.thisSubscriptionRow])>
				<cfset Variables.thisSubscriptionBillingPeriodLength = DateDiff(qry_selectSubscriptionList.subscriptionIntervalType[Variables.thisSubscriptionRow], qry_selectSubscriptionList.subscriptionDateBegin[Variables.thisSubscriptionRow], qry_selectSubscriptionList.subscriptionDateProcessNext[Variables.thisSubscriptionRow])>
			<cfelse>
				<cfset Variables.thisSubscriptionBillingPeriodLength = DateDiff(qry_selectSubscriptionList.subscriptionIntervalType[Variables.thisSubscriptionRow], qry_selectSubscriptionList.subscriptionDateProcessLast[Variables.thisSubscriptionRow], qry_selectSubscriptionList.subscriptionDateProcessNext[Variables.thisSubscriptionRow])>
			</cfif>
			--->

			<cfif Variables.thisSubscriptionBillingPeriodLength lt qry_selectSubscriptionList.subscriptionInterval[Variables.thisSubscriptionRow]>
				<cfset Variables.proRateThisSubscription = True>
				<cfset Variables.proRatePercentage = Variables.thisSubscriptionBillingPeriodLength / qry_selectSubscriptionList.subscriptionInterval[Variables.thisSubscriptionRow]>
			</cfif>
		</cfif>
	</cfif>
</cfif>
