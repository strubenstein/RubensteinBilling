<cfset Arguments.paymentCategoryID = Application.objWebServiceSecurity.ws_checkPaymentCategoryPermission(qry_selectWebServiceSession.companyID_author, Arguments.paymentCategoryID, Arguments.paymentCategoryID_custom, Arguments.useCustomIDFieldList)>

<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryList" ReturnVariable="qry_selectPaymentCategoryList">
	<cfinvokeargument Name="companyID" Value="#qry_selectWebServiceSession.companyID_author#">
	<cfif Variables.doAction is "insertPayment">
		<cfinvokeargument Name="paymentCategoryType" Value="payment">
	<cfelse>
		<cfinvokeargument Name="paymentCategoryType" Value="refund">
	</cfif>
</cfinvoke>

<cfset Form = Arguments>
<cfset Form.merchantAccountID = theMerchantAccountID>
<cfset Form.paymentMethod_select = Arguments.paymentMethod>
<cfset URL.paymentID = 0>
<cfset URL.control = "payment">

<cfif Arguments.paymentCheckNumber is 0>
	<cfset Arguments.paymentCheckNumber = "">
</cfif>

<cfswitch expression="#Arguments.paymentMethod#">
<cfcase value="cash,barter,services"><cfset doNothing = True></cfcase>
<cfcase value="check"><cfset Form.paymentCheckNumber_check = Arguments.paymentCheckNumber></cfcase>
<cfcase value="certified check"><cfset Form.paymentCheckNumber_certified = Arguments.paymentCheckNumber></cfcase>
<cfcase value="cashier check"><cfset Form.paymentCheckNumber_cashier = Arguments.paymentCheckNumber></cfcase>
<cfcase value="credit card">
	<cfif theCreditCardID is 0>
		<cfset Form.paymentMethod_select = "credit card">
	<cfelse>
		<cfset Form.paymentMethod_select = "creditCard" & theCreditCardID>
	</cfif>
</cfcase>
<cfcase value="bank">
	<cfif theBankID is 0>
		<cfset Form.paymentMethod_select = "bank">
	<cfelse>
		<cfset Form.paymentMethod_select = "bank" & theBankID>
	</cfif>
</cfcase>
<cfdefaultcase>
	<cfset Form.paymentMethod_select = "other">
	<cfset Form.paymentMethod_text = Arguments.paymentMethod>
</cfdefaultcase>
</cfswitch>

<cfif Not IsDefined("fn_FormValidateDateTime")>
	<cfinclude template="../../include/function/fn_datetime.cfm">
</cfif>

<cfset Variables.updatePaymentFieldList = "">
<cfinclude template="../../view/v_payment/var_paymentMethodList.cfm">
<cfinclude template="../../control/c_payment/formParam_insertUpdatePayment.cfm">
<cfinvoke component="#Application.billingMapping#data.Payment" method="maxlength_Payment" returnVariable="maxlength_Payment" />

<cfinclude template="../../view/v_payment/lang_insertUpdatePayment.cfm">
<cfinclude template="../../control/c_payment/formValidate_insertUpdatePayment.cfm">

<cfset theMerchantAccountID = 0>
<cfset theInvoiceID = 0>
<cfset theBankID = 0>
<cfset theCreditCardID = 0>

<cfif IsDate(Arguments.paymentDateReceived)>
	<cfset Form.paymentDateReceived_date = DateFormat(Arguments.paymentDateReceived, "mm/dd/yyyy")>
	<cfset Form.paymentDateReceived_hh = TimeFormat(Arguments.paymentDateReceived, "hh")>
	<cfset Form.paymentDateReceived_mm = TimeFormat(Arguments.paymentDateReceived, "mm")>
	<cfset Form.paymentDateReceived_tt = TimeFormat(Arguments.paymentDateReceived, "tt")>
</cfif>

<cfif IsDate(Arguments.paymentDateScheduled)>
	<cfset Form.paymentDateScheduled_date = DateFormat(Arguments.paymentDateScheduled, "mm/dd/yyyy")>
	<cfset Form.paymentDateScheduled_hh = TimeFormat(Arguments.paymentDateScheduled, "hh")>
	<cfset Form.paymentDateScheduled_mm = TimeFormat(Arguments.paymentDateScheduled, "mm")>
	<cfset Form.paymentDateScheduled_tt = TimeFormat(Arguments.paymentDateScheduled, "tt")>
</cfif>
