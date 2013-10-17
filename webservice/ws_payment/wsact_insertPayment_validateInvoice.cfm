<cfset theInvoiceID = 0>
<cfset invoiceTotalUnpaid = 0>

<cfif Not IsDefined("Variables.wslang_payment")>
	<cfinclude template="wslang_payment.cfm">
</cfif>

<!--- validate invoiceID(s) if necessary --->
<cfif returnValue is 0 and (ListFind(Arguments.useCustomIDFieldList, "invoiceID") or ListFind(Arguments.useCustomIDFieldList, "invoiceID_custom") or (Arguments.invoiceID is not 0 and Arguments.invoiceID is not ""))>
	<cfset Arguments.invoiceID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.invoiceID, Arguments.invoiceID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.invoiceID is 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_payment.invalidInvoice>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoiceList">
			<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
		</cfinvoke>

		<!--- loop thru invoices to calculate total, validate all are for same companyID/subscriberID and they are not fully paid --->
		<cfloop Query="qry_selectInvoiceList">
			<cfif qry_selectInvoiceList.CurrentRow gt 1 and qry_selectInvoiceList.companyID is not qry_selectInvoiceList.companyID[qry_selectInvoiceList.CurrentRow - 1]><!--- not all for same company --->
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_payment.multipleCompany>
			<cfelseif qry_selectInvoiceList.CurrentRow gt 1 and qry_selectInvoiceList.subscriberID is not qry_selectInvoiceList.subscriberID[qry_selectInvoiceList.CurrentRow - 1]><!--- not all for same company --->
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_payment.multipleSubscriber>
			<cfelseif theCompanyID is not 0 and qry_selectInvoiceList.companyID is not theCompanyID>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_payment.notInvoiceCompany>
			<cfelseif theSubscriberID is not 0 and qry_selectInvoiceList.subscriberID is not theSubscriberID>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_payment.notInvoiceSubscriber>
			<cfelseif Variables.doAction is "insertPayment">
				<cfif qry_selectInvoiceList.invoicePaid is 1><!--- already paid; return error --->
					<cfset returnValue = -1>
					<cfset returnError = Variables.wslang_payment.invoicePaid>
				<cfelseif qry_selectInvoiceList.invoicePaid is ""><!--- not paid --->
					<cfset invoiceTotalUnpaid = invoiceTotalUnpaid + qry_selectInvoiceList.invoiceTotal>
				<cfelse><!--- partially paid --->
					<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentAmountTotal" ReturnVariable="qry_selectInvoicePaymentAmountTotal">
						<cfinvokeargument Name="invoiceID" Value="#qry_selectInvoiceList.invoiceID#">
					</cfinvoke>

					<cfif IsNumeric(qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)>
						<cfset invoiceTotalUnpaid = invoiceTotalUnpaid + qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount>
					</cfif>
				</cfif>
			</cfif>
		</cfloop><!--- /loop thru invoices --->

		<!--- set companyID and subscriberID to invoice values if necessary --->
		<cfif returnValue is 0>
			<cfset theInvoiceID = Arguments.invoiceID>
			<cfif theCompanyID is 0>
				<cfset theCompanyID = qry_selectInvoiceList.companyID[1]>
			</cfif>
			<cfif theSubscriberID is 0>
				<cfset theSubscriberID = qry_selectInvoiceList.subscriberID[1]>
			</cfif>
		</cfif><!--- /set companyID and subscriberID to invoice values if necessary --->
	</cfif><!--- /invoiceID(s) is valid --->
</cfif><!--- /validate invoiceID(s) if necessary --->

