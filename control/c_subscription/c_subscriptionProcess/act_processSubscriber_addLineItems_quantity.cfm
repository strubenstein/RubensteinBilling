<!--- Determine line item quantity for this price stage --->
<!--- if subscription quantity does not vary, use default quantity --->
<cfif qry_selectSubscriptionList.subscriptionQuantityVaries[Variables.thisSubscriptionRow] is 0>
	<cfset Variables.thisSubscriptionQuantity = qry_selectSubscriptionList.subscriptionQuantity[Variables.thisSubscriptionRow]>
	<cfset Variables.subProcRow = 0>
<cfelse>
	<cfset Variables.subProcRow = ListFind(ValueList(qry_selectSubscriptionProcessList.subscriptionID_priceStageID), Variables.thisSubscriptionID & "_" & loopPriceStageID)>
	<!--- if no quantity specified for this subscription / price stage or specified value is blank, use default subscription quantity --->
	<cfif Variables.subProcRow is 0 or Not IsNumeric(qry_selectSubscriptionProcessList.subscriptionProcessQuantity[Variables.subProcRow])>
		<cfset Variables.thisSubscriptionQuantity = qry_selectSubscriptionList.subscriptionQuantity[Variables.thisSubscriptionRow]>
	<cfelse>
		<cfset Variables.thisSubscriptionQuantity = qry_selectSubscriptionProcessList.subscriptionProcessQuantity[Variables.subProcRow]>
	</cfif>
</cfif>

