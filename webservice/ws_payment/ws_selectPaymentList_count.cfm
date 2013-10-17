
<cfinclude template="wslang_payment.cfm">
<cfif Not ListFind(Arguments.searchFieldList, "paymentIsRefund")>
	<cfset doAction = "listPayments">
<cfelse>
	<cfswitch expression="#Arguments.paymentIsRefund#">
	<cfcase value="0"><!--- payment ---><cfset doAction = "listPayments"></cfcase>
	<cfcase value="1"><!--- refund ---><cfset doAction = "listPaymentRefunds"></cfcase>
	<cfdefaultcase><!--- both ---><cfset doAction = "listPayments"></cfdefaultcase>
	</cfswitch>
</cfif>

<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS(doAction, qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_payment.listPayments>
<cfelse>
	<cfinclude template="wsact_selectPaymentList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPaymentCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

	<cfset returnValue = qryTotalRecords>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

