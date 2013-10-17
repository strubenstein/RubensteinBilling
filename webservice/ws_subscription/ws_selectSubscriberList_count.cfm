<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listSubscribers", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_subscription.listSubscribers>
<cfelse>
	<cfinclude template="wsact_selectSubscriberList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

	<cfset returnValue = qryTotalRecords>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

