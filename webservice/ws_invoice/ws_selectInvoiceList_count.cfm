<cfinclude template="wslang_invoice.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listInvoices", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_invoice.listInvoices>
<cfelse>
	<cfinclude template="wsact_selectInvoiceList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

	<cfset returnValue = qryTotalRecords>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

