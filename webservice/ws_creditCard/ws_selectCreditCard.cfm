<cfinclude template="wslang_creditCard.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewCreditCard", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_creditCard.viewCreditCard>
<cfelseif Not Application.fn_IsIntegerList(Arguments.creditCardID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_creditCard.creditCardID>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
		<cfinvokeargument Name="creditCardID" Value="#Arguments.creditCardID#">
		<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
		<cfinvokeargument Name="returnCompanyFields" Value="True">
	</cfinvoke>

	<cfif qry_selectCreditCardList.RecordCount is not ListLen(Arguments.creditCardID)>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_creditCard.creditCardID>
	<cfelse>
		<cfset returnValue = qry_selectCreditCardList>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">


