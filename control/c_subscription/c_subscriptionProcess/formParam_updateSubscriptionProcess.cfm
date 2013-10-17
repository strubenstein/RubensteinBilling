<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfset Form.subscriptionProcessQuantityFinal = "">
	<cfloop Query="qry_selectSubscriptionProcessList">
		<cfparam Name="Form.subscriptionProcessQuantity#qry_selectSubscriptionProcessList.subscriptionID#_#qry_selectSubscriptionProcessList.priceStageID#" Default="#qry_selectSubscriptionProcessList.subscriptionProcessQuantity#">
		<cfif qry_selectSubscriptionProcessList.subscriptionProcessQuantityFinal is 1>
			<cfset Form.subscriptionProcessQuantityFinal = ListAppend(Form.subscriptionProcessQuantityFinal, qry_selectSubscriptionProcessList.subscriptionID & "_" & qry_selectSubscriptionProcessList.priceStageID)>
		</cfif>
	</cfloop>
</cfif>

<cfparam Name="Form.subscriptionProcessQuantityFinal" Default="">
<cfloop Query="qry_selectSubscriptionList">
	<cfset Variables.thisSubscriptionID = qry_selectSubscriptionList.subscriptionID>
	<cfloop Index="loopPriceStageID" List="#subscriptionID_priceStageIDList["subscription#Variables.thisSubscriptionID#"]#">
		<cfparam Name="Form.subscriptionProcessQuantity#Variables.thisSubscriptionID#_#loopPriceStageID#" Default="">
	</cfloop>
</cfloop>

