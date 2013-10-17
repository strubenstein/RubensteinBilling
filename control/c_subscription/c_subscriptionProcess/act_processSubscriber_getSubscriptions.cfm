<!--- Select active subscriptions for this subscriber that should be processed today (or beforehand, in case it got missed) --->
<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList">
	<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
	<cfinvokeargument Name="subscriptionStatus" Value="1">
	<cfinvokeargument Name="subscriptionCompleted" Value="0">
	<cfinvokeargument Name="subscriptionDateProcessNext" Value="#Now()#">
	<cfinvokeargument Name="subscriptionDateProcessNext_before" Value="True">
</cfinvoke>

<!--- If no subscriptions to process, STOP --->
<cfif qry_selectSubscriptionList.RecordCount is 0>
	<cfset Variables.isSubscriptionOkToProcess = False>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.SubscriptionParameter" Method="selectSubscriptionParameterList" ReturnVariable="qry_selectSubscriptionParameterList">
		<cfinvokeargument Name="subscriptionID" Value="#ValueList(qry_selectSubscriptionList.subscriptionID)#">
	</cfinvoke>

	<cfif REFind("[1-9]", ValueList(qry_selectSubscriptionList.productParameterExceptionID))>
		<cfinvoke Component="#Application.billingMapping#data.ProductParameterException" Method="selectProductParameterException" ReturnVariable="qry_selectProductParameterExceptionList">
			<cfinvokeargument Name="productParameterExceptionID" Value="#ValueList(qry_selectSubscriptionList.productParameterExceptionID)#">
		</cfinvoke>
	</cfif>
</cfif>

