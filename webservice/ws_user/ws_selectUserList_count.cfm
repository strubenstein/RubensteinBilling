<cfinclude template="wslang_user.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listUsers", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_user.listUsers>
<cfelse>
	<cfinclude template="wsact_selectUserList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

	<cfset returnValue = qryTotalRecords>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

