<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="updateSubscription" ReturnVariable="isSubscriptionStatusUpdated">
	<cfinvokeargument Name="subscriptionID" Value="#URL.subscriptionID#">
	<cfinvokeargument Name="userID_cancel" Value="#Session.userID#">
</cfinvoke>

<cfif Not IsDefined("URL.redirectAction") or URL.redirectAction is not "viewSubscriptionsAll" or Not Application.fn_IsUserAuthorized("viewSubscriptionsAll")>
	<cfset URL.redirectAction = "viewSubscriptions">
</cfif>

<!--- check for trigger --->
<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
	<cfinvokeargument name="companyID" value="#Session.companyID#">
	<cfinvokeargument name="doAction" value="#Variables.doAction#">
	<cfinvokeargument name="isWebService" value="False">
	<cfinvokeargument name="doControl" value="#Variables.doControl#">
	<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
	<cfinvokeargument name="targetID" value="#URL.subscriptionID#">
</cfinvoke>

<cflocation url="index.cfm?method=invoice.#URL.redirectAction#&subscriptionID=#URL.subscriptionID#&confirm_subscription=#Variables.doAction#" AddToken="No">
