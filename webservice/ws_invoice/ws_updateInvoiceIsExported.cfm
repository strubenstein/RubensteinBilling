<cfinclude template="wslang_invoice.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("exportInvoices", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_invoice.exportInvoices>
<cfelse>
	<cfset Arguments.invoiceID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.invoiceID, Arguments.invoiceID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.invoiceID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_invoice.invalidInvoice>
	<cfelseif Arguments.invoiceIsExported is not "" and Not ListFind("0,1", Arguments.invoiceIsExported)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_invoice.exportOption>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoiceIsExported" ReturnVariable="isInvoiceExported">
			<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
			<cfinvokeargument Name="invoiceIsExported" Value="#Arguments.invoiceIsExported#">
		</cfinvoke>

		<cfset returnValue = True>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">


