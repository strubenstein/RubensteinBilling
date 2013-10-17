<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewSubscription", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_subscription.viewSubscription>
<cfelse>
	<cfset Arguments.subscriptionID = Application.objWebServiceSecurity.ws_checkSubscriptionPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriptionID, Arguments.subscriptionID_custom, Arguments.useCustomIDFieldList)>
	<cfif ListLen(Arguments.subscriptionID) is 1 and Arguments.subscriptionID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_subscription.invalidSubscription>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscription" ReturnVariable="qry_selectSubscriptionList">
			<cfinvokeargument Name="subscriptionID" Value="#Arguments.subscriptionID#">
		</cfinvoke>

		<!--- add subscription parameters --->
		<cfinclude template="wsact_addSubscriptionParameterColumns.cfm">

		<!--- add subscription user(s) --->
		<cfinclude template="wsact_addSubscriptionUserColumns.cfm">

		<cfset returnValue = qry_selectSubscriptionList>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

