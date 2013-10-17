<cfset Form.creditCardID = 0>
<cfset Form.bankID = 0>
<cfset Form.invoiceTotalLineItem = "">
<cfset Form.invoiceTotalTax = "">
<cfset Form.invoiceTotalPaymentCredit = "">
<cfset Form.invoiceTotal = "">

<cfif Not IsDefined("fn_ConvertTo24HourFormat")>
	<cfinclude template="../../include/function/fn_datetime.cfm">
</cfif>

<cfif Not IsDate(Arguments.invoiceDateDue)>
	<cfset Form.invoiceDateDue_date = "">
	<cfset Form.invoiceDateDue_hh = "12">
	<cfset Form.invoiceDateDue_mm = "00">
	<cfset Form.invoiceDateDue_tt = "am">
<cfelse>
	<cfset hour_ampm = fn_ConvertFrom24HourFormat(Hour(Arguments.invoiceDateDue))>
	<cfset Form.invoiceDateDue_date = DateFormat(Arguments.invoiceDateDue, 'mm/dd/yyyy')>
	<cfset Form.invoiceDateDue_hh = ListFirst(hour_ampm, '|')>
	<cfset Form.invoiceDateDue_mm = Minute(Arguments.invoiceDateDue)>
	<cfset Form.invoiceDateDue_tt = ListLast(hour_ampm, '|')>
</cfif>

<cfif Arguments.addressID_billing is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectBillingAddressList">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfif Arguments.userID is not 0>
			<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		</cfif>
		<cfinvokeargument Name="addressTypeBilling" Value="1">
		<cfinvokeargument Name="addressStatus" Value="1">
	</cfinvoke>
</cfif>

<cfif Arguments.addressID_shipping is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectShippingAddressList">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfif Arguments.userID is not 0>
			<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		</cfif>
		<cfinvokeargument Name="addressTypeShipping" Value="1">
		<cfinvokeargument Name="addressStatus" Value="1">
	</cfinvoke>
</cfif>

<cfset Variables.displayCompanyList = False>
<cfset URL.control = "invoice">
<cfset Variables.invoiceDateFieldList = "invoiceDateDue"><!--- invoiceDatePaid,invoiceDateClosed,invoiceDateCompleted --->

<cfinclude template="../../control/c_invoice/formParam_insertUpdateInvoice.cfm">
<cfinvoke component="#Application.billingMapping#data.Invoice" method="maxlength_Invoice" returnVariable="maxlength_Invoice" />
<cfinclude template="../../view/v_shipping/var_shippingMethodList.cfm">
<cfinclude template="../../view/v_invoice/lang_insertUpdateInvoice.cfm">
<cfinclude template="../../control/c_invoice/formValidate_insertUpdateInvoice.cfm">

