<cfinclude template="wslang_bank.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("selectBank", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_bank.viewBank>
<cfelseif Not Application.fn_IsIntegerList(Arguments.bankID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_bank.bankID>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
		<cfinvokeargument Name="bankID" Value="#Arguments.bankID#">
		<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
		<cfinvokeargument Name="returnCompanyFields" Value="True">
	</cfinvoke>

	<cfif qry_selectBankList.RecordCount is not ListLen(Arguments.bankID)>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_bank.bankID>
	<cfelse>
		<cfset returnValue = qry_selectBankList>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

