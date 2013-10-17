<cfif URL.invoiceID is not 0 and IsDefined("qry_selectInvoice")>
	<cfparam Name="Form.companyID" Default="#qry_selectInvoice.companyID#">
	<cfparam Name="Form.userID" Default="#qry_selectInvoice.userID#">
	<cfparam Name="Form.invoicePaid" Default="#qry_selectInvoice.invoicePaid#">
	<cfparam Name="Form.invoiceTotal" Default="#qry_selectInvoice.invoiceTotal#">
	<cfparam Name="Form.invoiceTotalTax" Default="#qry_selectInvoice.invoiceTotalTax#">
	<cfparam Name="Form.invoiceTotalLineItem" Default="#qry_selectInvoice.invoiceTotalLineItem#">
	<cfparam Name="Form.invoiceTotalShipping" Default="#qry_selectInvoice.invoiceTotalShipping#">
	<cfparam Name="Form.invoiceTotalPaymentCredit" Default="#qry_selectInvoice.invoiceTotalPaymentCredit#">
	<cfparam Name="Form.invoiceShipped" Default="#qry_selectInvoice.invoiceShipped#">
	<cfparam Name="Form.invoiceID_custom" Default="#qry_selectInvoice.invoiceID_custom#">
	<cfparam Name="Form.invoiceShippingMethod" Default="#qry_selectInvoice.invoiceShippingMethod#">
	<cfparam Name="Form.invoiceInstructions" Default="#qry_selectInvoice.invoiceInstructions#">
	<cfparam Name="Form.invoiceStatus" Default="#qry_selectInvoice.invoiceStatus#">
	<cfparam Name="Form.addressID_shipping" Default="#qry_selectInvoice.addressID_shipping#">
	<cfparam Name="Form.addressID_billing" Default="#qry_selectInvoice.addressID_billing#">
	<cfparam Name="Form.creditCardID" Default="#qry_selectInvoice.creditCardID#">
	<cfparam Name="Form.bankID" Default="#qry_selectInvoice.bankID#">
	<cfparam Name="Form.subscriberID" Default="#qry_selectInvoice.subscriberID#">

	<cfif qry_selectInvoice.invoiceCompleted is 1>
		<cfparam Name="Form.invoiceClosed" Default="2">
	<cfelse>
		<cfparam Name="Form.invoiceClosed" Default="#qry_selectInvoice.invoiceClosed#">
	</cfif>

	<cfif Not IsDefined("Form.isFormSubmitted")>
		<!--- 
		<cfparam Name="Form.invoiceClosed" Default="#qry_selectInvoice.invoiceClosed#">
		<cfparam Name="Form.invoiceCompleted" Default="#qry_selectInvoice.invoiceCompleted#">
		--->
		<cfparam Name="Form.invoiceManual" Default="#qry_selectInvoice.invoiceManual#">
		<cfparam Name="Form.invoiceSent" Default="#qry_selectInvoice.invoiceSent#">
	</cfif>

	<cfloop Index="dateField" List="#Variables.invoiceDateFieldList#">
		<cfset Variables.thisDate = Evaluate("qry_selectInvoice.#dateField#")>
		<cfif IsDate(Variables.thisDate)>
			<cfset Variables.hour_ampm = fn_ConvertFrom24HourFormat(Hour(Variables.thisDate))>
			<cfparam Name="Form.#dateField#_date" Default="#DateFormat(Variables.thisDate, 'mm/dd/yyyy')#">
			<cfparam Name="Form.#dateField#_hh" Default="#ListFirst(Variables.hour_ampm, '|')#">
			<cfparam Name="Form.#dateField#_mm" Default="#Minute(Variables.thisDate)#">
			<cfparam Name="Form.#dateField#_tt" Default="#ListLast(Variables.hour_ampm, '|')#">
		</cfif>
	</cfloop>
</cfif>

<cfif URL.invoiceID is 0>
	<cfif URL.control is "company" and URL.userID is 0 and IsDefined("qry_selectCompany.userID")>
		<cfparam Name="Form.userID" Default="#qry_selectCompany.userID#">
	<cfelseif URL.control is "user" and URL.companyID is 0 and IsDefined("qry_selectUser.companyID")>
		<cfparam Name="Form.companyID" Default="#qry_selectUser.companyID#">
	<cfelseif URL.control is "subscription" and URL.userID is 0 and IsDefined("qry_selectSubscriber.userID") and qry_selectSubscriber.userID is not 0>
		<cfparam Name="Form.userID" Default="#qry_selectSubscriber.userID#">
	</cfif>
</cfif>

<cfparam Name="Form.companyID" Default="#URL.companyID#">
<cfparam Name="Form.userID" Default="#URL.userID#">

<cfparam Name="Form.invoiceClosed" Default="0">
<cfparam Name="Form.invoicePaid" Default="">
<cfparam Name="Form.invoiceTotal" Default="0">
<cfparam Name="Form.invoiceTotalTax" Default="0">
<cfparam Name="Form.invoiceTotalLineItem" Default="0">
<cfparam Name="Form.invoiceTotalShipping" Default="0">
<cfparam Name="Form.invoiceTotalPaymentCredit" Default="0">
<cfparam Name="Form.invoiceShipped" Default="">
<!--- <cfparam Name="Form.invoiceCompleted" Default="0"> --->
<cfparam Name="Form.invoiceID_custom" Default="">
<cfparam Name="Form.invoiceShippingMethod" Default="">
<cfparam Name="Form.invoiceInstructions" Default="">
<cfparam Name="Form.invoiceSent" Default="0">
<cfparam Name="Form.invoiceStatus" Default="1">
<cfparam Name="Form.invoiceManual" Default="1">
<cfparam Name="Form.addressID_shipping" Default="0">
<cfparam Name="Form.addressID_billing" Default="0">
<cfparam Name="Form.creditCardID" Default="0">
<cfparam Name="Form.bankID" Default="0">

<cfif IsDefined("URL.subscriberID") and Application.fn_IsIntegerPositive(URL.subscriberID)>
	<cfparam Name="Form.subscriberID" Default="#URL.subscriberID#">
<cfelse>
	<cfparam Name="Form.subscriberID" Default="0">
</cfif>

<cfloop Index="dateField" List="#Variables.invoiceDateFieldList#">
	<cfparam Name="Form.#dateField#_date" Default="">
	<cfparam Name="Form.#dateField#_hh" Default="12">
	<cfparam Name="Form.#dateField#_mm" Default="00">
	<cfparam Name="Form.#dateField#_tt" Default="am">
</cfloop>

<!--- 
regionID
languageID
--->

