<cfif Not IsDefined("Variables.wslang_subscription")>
	<cfinclude template="wslang_subscription.cfm">
</cfif>

<cfset Variables.doAction = "insertSubscriber">
<cfset Variables.displayCompanyList = False>
<cfset URL.subscriberID = 0>

<!--- 
qry_selectUserCompanyList_company.userID
qry_selectBankList.bankID
qry_selectCreditCardList.creditCardID
qry_selectBillingAddressList.addressID 2
--->

<cfif Not IsDefined("fn_FormValidateDateTime")>
	<cfinclude template="../../include/function/fn_datetime.cfm">
</cfif>
<cfset Variables.subscriberDateFieldList = "subscriberDateProcessNext,subscriberDateProcessLast">

<cfset isAllFormFieldsOk = True>
<cfif IsDate(Arguments.subscriberDateProcessNext)>
	<cfset hour_ampm = fn_ConvertFrom24HourFormat(Hour(Arguments.subscriberDateProcessNext))>
	<cfset Form.subscriberDateProcessNext_date = DateFormat(Arguments.subscriberDateProcessNext, 'mm/dd/yyyy')>
	<cfset Form.subscriberDateProcessNext_hh = ListFirst(hour_ampm, '|')>
	<cfset Form.subscriberDateProcessNext_mm = Minute(Arguments.subscriberDateProcessNext)>
	<cfset Form.subscriberDateProcessNext_tt = ListLast(hour_ampm, '|')>
<cfelseif Arguments.subscriberDateProcessNext is "">
	<cfset Form.subscriberDateProcessNext_date = "">
	<cfset Form.subscriberDateProcessNext_hh = "12">
	<cfset Form.subscriberDateProcessNext_mm = "00">
	<cfset Form.subscriberDateProcessNext_tt = "am">
<cfelse>
	<cfset returnValue = -1>
	<cfset isAllFormFieldsOk = False>
	<cfset returnError = Variables.wslang_subscription.subscriberDateProcessNext>
</cfif>

<cfif isAllFormFieldsOk is True>
	<cfset URL.control = "">
	<cfset URL.userID = Arguments.userID>
	<cfinvoke component="#Application.billingMapping#data.Subscriber" method="maxlength_Subscriber" returnVariable="maxlength_Subscriber" />
	<cfinclude template="../../control/c_subscription/formParam_insertUpdateSubscriber.cfm">
	<cfinclude template="../../view/v_subscription/lang_insertUpdateSubscriber.cfm">
	<cfinclude template="../../control/c_subscription/formValidate_insertUpdateSubscriber.cfm">
</cfif>

<cfif isAllFormFieldsOk is False>
	<cfset returnValue = -1>
	<cfif Not IsDefined("errorMessage_fields")>
		<cfset returnError = Variables.wslang_subscription.subscriberOptions>
	<cfelse>
		<cfset returnError = "">
		<cfloop Collection="#errorMessage_fields#" Item="field">
			<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
		</cfloop>
	</cfif>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="insertSubscriber" ReturnVariable="newSubscriberID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
		<cfinvokeargument Name="userID_cancel" Value="0">
		<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
		<cfinvokeargument Name="subscriberName" Value="#Arguments.subscriberName#">
		<cfinvokeargument Name="subscriberID_custom" Value="#Arguments.subscriberID_custom#">
		<cfinvokeargument Name="subscriberStatus" Value="#Arguments.subscriberStatus#">
		<cfinvokeargument Name="subscriberCompleted" Value="0">
		<cfinvokeargument Name="subscriberDateProcessNext" Value="#Arguments.subscriberDateProcessNext#">
		<cfinvokeargument Name="subscriberDateProcessLast" Value="">
		<cfinvokeargument Name="addressID_billing" Value="#Arguments.addressID_billing#">
		<cfinvokeargument Name="addressID_shipping" Value="#Arguments.addressID_shipping#">
	</cfinvoke>

	<cfset returnValue = newSubscriberID>

	<cfif Arguments.creditCardID is not 0 or Arguments.bankID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="insertSubscriberPayment" ReturnVariable="isSubscriberPaymentInserted">
			<cfinvokeargument Name="subscriberID" Value="#newSubscriberID#">
			<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
			<cfinvokeargument Name="userID_cancel" Value="0">
			<cfinvokeargument Name="subscriberPaymentStatus" Value="1">
			<cfif Arguments.subscriberPaymentViaCreditCard is True and Arguments.creditCardID is not 0>
				<cfinvokeargument Name="creditCardID" Value="#Arguments.creditCardID#">
				<cfinvokeargument Name="bankID" Value="0">
			<cfelse>
				<cfinvokeargument Name="creditCardID" Value="0">
				<cfinvokeargument Name="bankID" Value="#Arguments.bankID#">
			</cfif>
		</cfinvoke>
	</cfif>
</cfif>

