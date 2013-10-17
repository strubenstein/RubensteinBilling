<cfif Not IsDefined("Variables.wslang_subscription")>
	<cfinclude template="wslang_subscription.cfm">
</cfif>

<cfif Not ListFind("0,1", Arguments.subscriberNotifyEmail) or Not ListFind("0,1", Arguments.subscriberNotifyEmailHtml)
		or Not ListFind("0,1", Arguments.subscriberNotifyPdf) or Not ListFind("0,1", Arguments.subscriberNotifyDoc)
		or Not Application.fn_IsIntegerNonNegative(Arguments.addressID) or Not Application.fn_IsIntegerNonNegative(Arguments.phoneID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_subscription.notificationOptions>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.SubscriberNotify" Method="insertSubscriberNotify" ReturnVariable="isSubscriberNotifyInserted">
		<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
		<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		<cfinvokeargument Name="subscriberNotifyStatus" Value="1">
		<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
		<cfinvokeargument Name="userID_cancel" Value="0">
		<cfinvokeargument Name="addressID" Value="#Arguments.addressID#">
		<cfinvokeargument Name="subscriberNotifyEmail" Value="#Arguments.subscriberNotifyEmail#">
		<cfinvokeargument Name="subscriberNotifyEmailHtml" Value="#Arguments.subscriberNotifyEmailHtml#">
		<cfinvokeargument Name="subscriberNotifyPdf" Value="#Arguments.subscriberNotifyPdf#">
		<cfinvokeargument Name="subscriberNotifyDoc" Value="#Arguments.subscriberNotifyDoc#">
		<cfinvokeargument Name="phoneID" Value="#Arguments.phoneID#">
	</cfinvoke>

	<!--- check for trigger --->
	<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
		<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
		<cfinvokeargument name="doAction" value="insertSubscriberNotify">
		<cfinvokeargument name="isWebService" value="True">
		<cfinvokeargument name="doControl" value="subscription">
		<cfinvokeargument name="primaryTargetKey" value="subscriberID">
		<cfinvokeargument name="targetID" value="#Arguments.subscriberID#">
	</cfinvoke>

	<cfset returnValue = True>
</cfif>

