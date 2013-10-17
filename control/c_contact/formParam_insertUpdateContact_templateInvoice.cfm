<!--- invoice info, shipping info and shipping/billing address --->
<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectCustomerInvoice">
	<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
</cfinvoke>

<!--- invoice information --->
<cfif qry_selectCustomerInvoice.RecordCount is not 0 and FindNoCase("<<invoice", qry_selectContactTemplate.contactTemplateSubject)>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceID>>", Variables.invoiceID, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceID_custom>>", qry_selectCustomerInvoice.invoiceID_custom, "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceTotal>>", Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCustomerInvoice.invoiceTotal), "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceTotalShipping>>", Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCustomerInvoice.invoiceTotalShipping), "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceTotalLineItem>>", Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCustomerInvoice.invoiceTotalLineItem), "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceTotalTax>>", Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCustomerInvoice.invoiceTotalTax), "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceTotalPaymentCredit>>", Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCustomerInvoice.invoiceTotalPaymentCredit), "ALL")>
	<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceShippingMethod>>", qry_selectCustomerInvoice.invoiceShippingMethod, "ALL")>
	<cfif IsDate(qry_selectCustomerInvoice.invoiceDateClosed)>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceDateClosed>>", DateFormat(qry_selectCustomerInvoice.invoiceDateClosed, "mmmm dd, yyyy"), "ALL")>
	<cfelse>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceDateClosed>>", "N/A", "ALL")>
	</cfif>
	<cfif IsDate(qry_selectCustomerInvoice.invoiceDatePaid)>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceDatePaid>>", DateFormat(qry_selectCustomerInvoice.invoiceDatePaid, "mmmm dd, yyyy"), "ALL")>
	<cfelse>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceDatePaid>>", "N/A", "ALL")>
	</cfif>
	<cfif IsDate(qry_selectCustomerInvoice.invoiceDateCompleted)>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceDateCompleted>>", DateFormat(qry_selectCustomerInvoice.invoiceDateCompleted, "mmmm dd, yyyy"), "ALL")>
	<cfelse>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceDateCompleted>>", "N/A", "ALL")>
	</cfif>
	<cfif IsDate(qry_selectCustomerInvoice.invoiceDateDue)>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceDateDue>>", DateFormat(qry_selectCustomerInvoice.invoiceDateDue, "mmmm dd, yyyy"), "ALL")>
	<cfelse>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<invoiceDateDue>>", "N/A", "ALL")>
	</cfif>
</cfif>

<cfif qry_selectCustomerInvoice.RecordCount is not 0 and FindNoCase("<<invoice", qry_selectContactTemplate.contactTemplateMessage)>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceID>>", Variables.invoiceID, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceID_custom>>", qry_selectCustomerInvoice.invoiceID_custom, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceTotal>>", Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCustomerInvoice.invoiceTotal), "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceTotalShipping>>", Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCustomerInvoice.invoiceTotalShipping), "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceTotalLineItem>>", Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCustomerInvoice.invoiceTotalLineItem), "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceTotalTax>>", Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCustomerInvoice.invoiceTotalTax), "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceTotalPaymentCredit>>", Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCustomerInvoice.invoiceTotalPaymentCredit), "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceShippingMethod>>", qry_selectCustomerInvoice.invoiceShippingMethod, "ALL")>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceInstructions>>", qry_selectCustomerInvoice.invoiceInstructions, "ALL")>
	<cfif IsDate(qry_selectCustomerInvoice.invoiceDateClosed)>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceDateClosed>>", DateFormat(qry_selectCustomerInvoice.invoiceDateClosed, "mmmm dd, yyyy"), "ALL")>
	<cfelse>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceDateClosed>>", "N/A", "ALL")>
	</cfif>
	<cfif IsDate(qry_selectCustomerInvoice.invoiceDatePaid)>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceDatePaid>>", DateFormat(qry_selectCustomerInvoice.invoiceDatePaid, "mmmm dd, yyyy"), "ALL")>
	<cfelse>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceDatePaid>>", "N/A", "ALL")>
	</cfif>
	<cfif IsDate(qry_selectCustomerInvoice.invoiceDateCompleted)>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceDateCompleted>>", DateFormat(qry_selectCustomerInvoice.invoiceDateCompleted, "mmmm dd, yyyy"), "ALL")>
	<cfelse>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceDateCompleted>>", "N/A", "ALL")>
	</cfif>
	<cfif IsDate(qry_selectCustomerInvoice.invoiceDateDue)>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceDateDue>>", DateFormat(qry_selectCustomerInvoice.invoiceDateDue, "mmmm dd, yyyy"), "ALL")>
	<cfelse>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<invoiceDateDue>>", "N/A", "ALL")>
	</cfif>
</cfif>

<!--- shipment information --->
<cfif Variables.shippingID is not 0>
	<cfinclude template="formParam_insertUpdateContact_templateShipment.cfm">
</cfif>

<!--- shipping address --->
<cfif qry_selectCustomerInvoice.RecordCount is not 0 and qry_selectCustomerInvoice.addressID_shipping is not 0>
	<cfinclude template="formParam_insertUpdateContact_templateShippingAddress.cfm">
</cfif>

<!--- billing address --->
<cfif qry_selectCustomerInvoice.RecordCount is not 0 and qry_selectCustomerInvoice.addressID_billing is not 0>
	<cfinclude template="formParam_insertUpdateContact_templateBillingAddress.cfm">
</cfif>

