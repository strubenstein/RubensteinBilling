<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateSubscriptionStatus", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_subscription.updateSubscriptionStatus>
<cfelse>
	<cfset Arguments.subscriptionID = Application.objWebServiceSecurity.ws_checkSubscriptionPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriptionID, Arguments.subscriptionID_custom, Arguments.useCustomIDFieldList)>
	<cfif ListLen(Arguments.subscriptionID) is 1 and Arguments.subscriptionID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_subscription.invalidSubscription>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscription" ReturnVariable="qry_selectSubscription">
			<cfinvokeargument Name="subscriptionID" Value="#Arguments.subscriptionID#">
		</cfinvoke>

		<cfset Variables.doAction = "updateSubscriptionStatus">
		<cfloop Query="qry_selectSubscription">
			<cfif qry_selectSubscription.subscriptionStatus is 1>
				<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="updateSubscription" ReturnVariable="isSubscriptionStatusUpdated">
					<cfinvokeargument Name="subscriptionID" Value="#qry_selectSubscription.subscriptionID#">
					<cfinvokeargument Name="userID_cancel" Value="#qry_selectWebServiceSession.userID#">
				</cfinvoke>

				<!--- check for trigger --->
				<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
					<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
					<cfinvokeargument name="doAction" value="updateSubscription">
					<cfinvokeargument name="isWebService" value="True">
					<cfinvokeargument name="doControl" value="subscription">
					<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
					<cfinvokeargument name="targetID" value="#Arguments.subscriptionID#">
				</cfinvoke>
			</cfif>
		</cfloop>

		<cfset returnValue = True>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

