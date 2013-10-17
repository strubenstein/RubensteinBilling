<cfset URL.error_shopping = "">

<cfif Not IsDefined("URL.invoiceID") or Not Application.fn_IsIntegerPositive(URL.invoiceID)>
	<cfset URL.error_shopping = "invalidInvoice">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="checkInvoicePermission" ReturnVariable="isInvoicePermission">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		<cfinvokeargument Name="invoiceClosed" Value="1">
	</cfinvoke>

	<cfif isInvoicePermission is False>
		<cfset URL.error_shopping = "invalidInvoice">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectPurchase">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectPurchaseLineItemList">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
			<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
		</cfinvoke>

		<!--- get payment credits --->
		<cfset Variables.displayPaymentCredits = False>
		<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="selectInvoicePaymentCreditList" ReturnVariable="qry_selectInvoicePaymentCreditList">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
			<cfinvokeargument Name="returnInvoiceFields" Value="False">
			<cfinvokeargument Name="returnPaymentCreditFields" Value="True">
		</cfinvoke>
		<cfif qry_selectInvoicePaymentCreditList.RecordCount is not 0>
			<cfset Variables.displayPaymentCredits = True>
		</cfif>

		<cfinclude template="../../../view/v_shopping/v_shoppingAccount/dsp_selectPurchase.cfm">
	</cfif>
</cfif>

<cfif URL.error_shopping is not "">
	<cfinclude template="../../../view/v_shopping/error_shopping.cfm">
</cfif>