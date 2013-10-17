<cfif IsDefined("URL.subscriptionID") or ListFind("viewSubscription,updateSubscription,updateSubscriptionStatus,moveSubscriptionUp,moveSubscriptionDown", Variables.doAction)>
	<cfset Variables.subscriberActionView = "index.cfm?method=#URL.control#.viewSubscriber&subscriberID=#URL.subscriberID#">
	<cfif URL.subscriberID is 0>
		<cflocation url="#Variables.subscriptionActionList#&error_subscription=noSubscriber" AddToken="No">
	<cfelseif Not IsDefined("URL.subscriptionID")>
		<cfif Variables.doAction is not "insertSubscription">
			<cflocation url="#Variables.subscriberActionView#&error_subscription=noSubscription" AddToken="No">
		</cfif>
	<cfelseif Not Application.fn_IsIntegerPositive(URL.subscriptionID)>
		<cflocation url="#Variables.subscriberActionView#&error_subscription=invalidSubscription" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscription" ReturnVariable="qry_selectSubscription">
			<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
			<cfinvokeargument Name="subscriptionID" Value="#URL.subscriptionID#">
		</cfinvoke>

		<cfif qry_selectSubscription.RecordCount is not 1 or qry_selectSubscription.subscriberID is not URL.subscriberID>
			<cflocation url="#Variables.subscriberActionView#&error_subscription=invalidSubscription" AddToken="No">
		<cfelseif Variables.doAction is "updateSubscription" and qry_selectSubscription.subscriptionStatus is 0>
			<cflocation url="#Variables.subscriberActionView#&error_subscription=updateInactiveSubscription" AddToken="No">
		</cfif>
	</cfif>
</cfif>
