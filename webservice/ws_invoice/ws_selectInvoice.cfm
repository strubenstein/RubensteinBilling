<cfinclude template="wslang_invoice.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewInvoice", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_invoice.viewInvoice>
<cfelse>
	<cfset Arguments.invoiceID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.invoiceID, Arguments.invoiceID_custom, Arguments.useCustomIDFieldList)>

	<cfif ListLen(Arguments.invoiceID) is 1 and Arguments.invoiceID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_invoice.invalidInvoice>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
			<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
		</cfinvoke>

		<cfset returnValue = qry_selectInvoice>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

