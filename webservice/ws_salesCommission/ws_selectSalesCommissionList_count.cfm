<cfinclude template="wslang_salesCommission.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listSalesCommissions", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_salesCommission.listSalesCommissions>
<cfelse>
	<cfinclude template="wsact_selectSalesCommissionList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="selectSalesCommissionCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

	<cfset returnValue = qryTotalRecords>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

