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
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS(doAction, qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_payment.listPayments>
<cfelse>
	<cfinclude template="wsact_selectPaymentList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPaymentList" ReturnVariable="qry_selectPaymentList" argumentCollection="#qryParamStruct#">
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

	<cfset returnValue = qry_selectPaymentList>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

