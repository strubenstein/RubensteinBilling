<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewSubscriptions", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_subscription.viewSubscriptions>
<cfelse>
	<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
	<cfif ListLen(Arguments.subscriberID) is 1 and Arguments.subscriberID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_subscription.invalidSubscriber>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList">
			<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
			<cfinvokeargument Name="subscriptionStatus" Value="1">
		</cfinvoke>

		<!--- add subscription parameters --->
		<cfinclude template="wsact_addSubscriptionParameterColumns.cfm">

		<!--- add subscription user(s) --->
		<cfinclude template="wsact_addSubscriptionUserColumns.cfm">

		<cfset returnValue = qry_selectSubscriptionList>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

