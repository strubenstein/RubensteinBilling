<cfinclude template="wslang_subscriptionProcess.cfm">
<cfinclude template="../../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listSubscribers", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_subscriptionProcess.listSubscribers>
<cfelseif Not IsDate(Arguments.subscriberDateProcessNext) and Arguments.subscriberDateProcessNext is not "">
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_subscriptionProcess.subscriberDateProcessNext>
<cfelse>
	<cfloop Index="field" List="subscriberProcessAllQuantitiesEntered">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberList" ReturnVariable="qry_selectSubscriberList">
		<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
		<cfinvokeargument Name="subscriberDateProcessNext" Value="#Arguments.subscriberDateProcessNext#">
		<cfif ListFind("0,1", Arguments.subscriberProcessAllQuantitiesEntered)>
			<cfinvokeargument Name="subscriberProcessAllQuantitiesEntered" Value="#Arguments.subscriberProcessAllQuantitiesEntered#">
		</cfif>
		<cfinvokeargument Name="queryOrderBy" Value="subscriberName">
		<cfinvokeargument Name="queryDisplayPerPage" Value="0">
		<cfinvokeargument Name="queryPage" Value="0">
	</cfinvoke>

	<cfset returnValue = qry_selectSubscriberList>
</cfif>

<cfinclude template="../../webserviceSession/wsact_updateWebServiceSession.cfm">

