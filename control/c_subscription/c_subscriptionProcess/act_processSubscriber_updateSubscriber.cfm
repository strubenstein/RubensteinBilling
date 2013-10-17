<!--- 
Update subscriber with last process date = next process date.
Update non-completed subscriber (with non-completed subscriptions) with next process date.
Update completed subscriber (no non-completed subscriptions) with null next process date, completed.
--->

<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectMinSubscriptionDateProcessNext" ReturnVariable="minSubscriptionProcessDateNext">
	<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="updateSubscriber" ReturnVariable="isSubscriberUpdated">
	<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
	<cfinvokeargument Name="subscriberDateProcessLast" Value="#qry_selectSubscriber.subscriberDateProcessNext#">
	<cfinvokeargument Name="doNotUpdateSubscriberDateUpdated" Value="True">
	<cfif Not IsDate(minSubscriptionProcessDateNext)>
		<cfinvokeargument Name="subscriberCompleted" Value="1">
		<cfinvokeargument Name="subscriberDateProcessNext" Value="">
	<cfelse>
		<cfinvokeargument Name="subscriberCompleted" Value="0">
		<cfinvokeargument Name="subscriberDateProcessNext" Value="#minSubscriptionProcessDateNext#">
	</cfif>
</cfinvoke>

