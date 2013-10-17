<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listSubscribers", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_subscription.listSubscribers>
<cfelse>
	<cfinclude template="wsact_selectSubscriberList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberList" ReturnVariable="qry_selectSubscriberList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Arguments.queryOrderBy#">
		<cfif StructKeyExists(Arguments, "queryDisplayPerPage") and Application.fn_IsIntegerPositive(Arguments.queryDisplayPerPage)>
			<cfinvokeargument Name="queryDisplayPerPage" Value="#Arguments.queryDisplayPerPage#">
		</cfif>
		<cfif StructKeyExists(Arguments, "queryPage") and Application.fn_IsIntegerPositive(Arguments.queryPage)>
			<cfinvokeargument Name="queryPage" Value="#Arguments.queryPage#">
		<cfelseif StructKeyExists(Arguments, "queryDisplayPerPage") and Application.fn_IsIntegerPositive(Arguments.queryDisplayPerPage)>
			<cfinvokeargument Name="queryPage" Value="1">
		</cfif>
	</cfinvoke>

	<!--- add payment fields to subscriber query --->
	<cfinclude template="wsact_selectSubscriberPayment.cfm">

	<cfset returnValue = qry_selectSubscriberList>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

