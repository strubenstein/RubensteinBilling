<cfinclude template="wslang_invoice.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertInvoice", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_invoice.insertInvoice>
<cfelse>
	<cfloop Index="field" List="invoiceStatus,invoiceClosed,invoiceCompleted,invoiceSent,invoicePaid">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset returnValue = 0>
	<cfinclude template="wsact_insertInvoice_determineCompany.cfm">

	<!--- SENT: invoiceID_custom,invoiceStatus,invoiceClosed,invoiceSent,invoicePaid,invoiceDateDue,invoiceShipped,invoiceTotalShipping,invoiceShippingMethod,invoiceInstructions --->
	<!--- VALIDATE: companyID,userID,subscriberID,addressID_shipping,addressID_billing --->
	<!--- NOT SENT: invoiceManual,invoiceDateClosed,invoiceCompleted,invoiceDateCompleted,invoiceDatePaid,invoiceTotal,invoiceTotalLineItem,invoiceTotalPaymentCredit,invoiceTotalTax,creditCardID,bankID --->

	<cfif returnValue is 0>
		<cfinclude template="wsact_insertInvoice_validateInsert.cfm">
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

