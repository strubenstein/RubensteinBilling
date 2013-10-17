<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("exportSubscribers", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_subscription.exportSubscribers>
<cfelse>
	<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.subscriberID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_subscription.invalidSubscriber>
	<cfelseif Arguments.subscriberIsExported is not "" and Not ListFind("0,1", Arguments.subscriberIsExported)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_subscription.exportOption>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="updateSubscriberIsExported" ReturnVariable="isSubscriberExported">
			<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
			<cfinvokeargument Name="subscriberIsExported" Value="#Arguments.subscriberIsExported#">
		</cfinvoke>

		<cfset returnValue = True>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

