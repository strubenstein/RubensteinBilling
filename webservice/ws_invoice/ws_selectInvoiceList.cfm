<cfinclude template="wslang_invoice.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listInvoices", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_invoice.listInvoices>
<cfelse>
	<cfinclude template="wsact_selectInvoiceList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList" ReturnVariable="qry_selectInvoiceList" argumentCollection="#qryParamStruct#">
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

	<cfset returnValue = qry_selectInvoiceList>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

