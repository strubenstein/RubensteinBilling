<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewSubscriber", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_subscription.viewSubscriber>
<cfelse>
	<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
	<cfif ListLen(Arguments.subscriberID) is 1 and Arguments.subscriberID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_subscription.invalidSubscriber>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriberList">
			<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
		</cfinvoke>

		<!--- add payment fields to subscriber query --->
		<cfinclude template="wsact_selectSubscriberPayment.cfm">

		<cfset returnValue = qry_selectSubscriberList>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

