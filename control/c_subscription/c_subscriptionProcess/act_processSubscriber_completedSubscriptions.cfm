<!--- 
Update all subscriptions:

Increment number of times subscription has been applied.
Set last process date = next process date.
Determine whether subscription is completed.
If subscription is not completed, set next process date. If completed, next process date is null.

Set priceStageID to first price stage of next billing period.
	If subscription is completed, price stage is last stage.
--->

<cfloop Query="qry_selectSubscriptionList">
	<!--- determine whether subscription is completed. --->
	<cfset Variables.theSubscriptionCompleted = 0>
	<cfset Variables.theSubscriptionDateProcessNext = "">

	<cfif qry_selectSubscriptionList.subscriptionContinuesAfterEnd is 0>
		<!--- subscription end determined by date --->
		<cfif qry_selectSubscriptionList.subscriptionEndByDateOrAppliedMaximum is 0
				and IsDate(qry_selectSubscriptionList.subscriptionDateEnd)
				and DateCompare(qry_selectSubscriptionList.subscriptionDateEnd, qry_selectSubscriptionList.subscriptionDateProcessNext) is not 1>
			<cfset Variables.theSubscriptionCompleted = 1>
		<!--- subscription end determined by number of times applied --->
		<cfelseif qry_selectSubscriptionList.subscriptionEndByDateOrAppliedMaximum is 1
				and (qry_selectSubscriptionList.subscriptionAppliedCount + 1) is qry_selectSubscriptionList.subscriptionAppliedMaximum>
			<cfset Variables.theSubscriptionCompleted = 1>
		</cfif>
	</cfif>

	<!--- subscription continues. determine next process date --->
	<cfif Variables.theSubscriptionCompleted is 0>
		<cfset Variables.theSubscriptionDateProcessNext = DateAdd(qry_selectSubscriptionList.subscriptionIntervalType, qry_selectSubscriptionList.subscriptionInterval, qry_selectSubscriptionList.subscriptionDateProcessNext)>
	</cfif>

	<!--- determine first priceStageID for next billing period --->
	<cfif qry_selectSubscriptionList.priceID is 0>
		<cfset Variables.theNextPriceStageID = 0>
	<cfelseif Variables.theSubscriptionDateProcessNext is "">
		<cfset Variables.theNextPriceStageID = ListLast(subscriptionID_priceStageIDList["subscription#Variables.thisSubscriptionID#"])>
	<cfelse>
		<cfset Variables.thisSubscriptionID = qry_selectSubscriptionList.subscriptionID>
		<cfloop Index="loopPriceStageID" List="#subscriptionID_priceStageIDList["subscription#Variables.thisSubscriptionID#"]#">
			<!--- if price stage end date is after this subscription process date OR this is the last price stage --->
			<cfif DateCompare(priceStageStruct["priceStage#loopPriceStageID#"].priceStageDateEnd, qry_selectSubscriptionList.subscriptionDateProcessNext) is 1
					or loopPriceStageID is ListLast(subscriptionID_priceStageIDList["subscription#Variables.thisSubscriptionID#"])>
				<cfset Variables.theNextPriceStageID = loopPriceStageID>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="updateSubscription_process" ReturnVariable="isSubscriptionUpdated">
		<cfinvokeargument Name="subscriptionID" Value="#qry_selectSubscriptionList.subscriptionID#">
		<cfinvokeargument Name="incrementSubscriptionAppliedCount" Value="True">
		<cfinvokeargument Name="subscriptionDateProcessLast" Value="#qry_selectSubscriptionList.subscriptionDateProcessNext#">
		<cfinvokeargument Name="subscriptionDateProcessNext" Value="#Variables.theSubscriptionDateProcessNext#">
		<cfinvokeargument Name="subscriptionCompleted" Value="#Variables.theSubscriptionCompleted#">
		<cfinvokeargument Name="priceStageID" Value="#Variables.theNextPriceStageID#">
	</cfinvoke>
</cfloop>
