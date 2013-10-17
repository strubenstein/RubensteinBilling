<!--- validate line items that refund is related to --->
<cfif returnValue is 0 and Arguments.invoiceLineItemID is not "">
	<cfif Not Application.fn_IsIntgerList(Arguments.invoiceLineItemID)>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_payment.invalidInvoiceLineItem>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItem" ReturnVariable="qry_selectInvoiceLineItemList">
			<cfinvokeargument Name="invoiceLineItemID" Value="#Arguments.invoiceLineItemID#">
		</cfinvoke>

		<cfif qry_selectInvoiceLineItemList.RecordCount is not ListLen(Arguments.invoiceLineItemID)>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_payment.invalidInvoiceLineItem>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoiceList_lineItem">
				<cfinvokeargument Name="invoiceID" Value="#ValueList(qry_selectInvoiceLineItemList.invoiceID)#">
			</cfinvoke>

			<!--- /validate company owns customer and that line items are for same customer --->
			<cfloop Query="qry_selectInvoiceList_lineItem">
				<cfif qry_selectInvoiceList_lineItem.companyID_author is not qry_selectWebServiceSession.companyID_author>
					<cfset returnValue = -1>
					<cfset returnError = Variables.wslang_payment.noPermissionForLineItem>
				<cfelseif qry_selectInvoiceList_lineItem.companyID is not theCompanyID>
					<cfset returnValue = -1>
					<cfset returnError = Variables.wslang_payment.notCustomerLineItem>
				<cfelseif theSubscriberID is not 0 and qry_selectInvoiceList_lineItem.subscriberID is not theSubscriberID>
					<cfset returnValue = -1>
					<cfset returnError = Variables.wslang_payment.notSubscriberLineItem>
				</cfif>
			</cfloop><!--- /validate company owns customer and that line items are for same customer --->
		</cfif><!--- /line items all exist --->

		<!--- set companyID and subscriberID to invoice values if necessary --->
		<cfif returnValue is 0>
			<cfset theInvoiceID = ValueList(qry_selectInvoiceList_lineItem.invoiceID)>
			<cfif theCompanyID is 0>
				<cfset theCompanyID = qry_selectInvoiceList_lineItem.companyID[1]>
			</cfif>
			<cfif theSubscriberID is 0>
				<cfset theSubscriberID = qry_selectInvoiceList_lineItem.subscriberID[1]>
			</cfif>
		</cfif><!--- /set companyID and subscriberID to invoice values if necessary --->
	</cfif><!--- /line items are valid list of integers --->
</cfif><!--- /validate line items that refund is related to --->
