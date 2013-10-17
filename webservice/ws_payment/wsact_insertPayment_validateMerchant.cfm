<cfset theMerchantAccountID = 0>
<cfset theBankID = 0>
<cfset theCreditCardID = 0>

<cfif Not IsDefined("Variables.wslang_payment")>
	<cfinclude template="wslang_payment.cfm">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="selectMerchantAccountList" ReturnVariable="qry_selectMerchantAccountList">
	<cfinvokeargument Name="companyID" Value="#qry_selectWebServiceSession.companyID_author#">
	<cfinvokeargument Name="merchantAccountStatus" Value="1">
	<cfinvokeargument Name="returnMerchantFields" Value="True">
</cfinvoke>

<!--- if paying via merchant account, validate merchant account, credit card and/or bank account --->
<cfif returnValue is 0 and Arguments.processPaymentViaMerchantAccount is True>
	<!--- validate merchant account --->
	<cfif qry_selectMerchantAccountList.RecordCount is 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_payment.noMerchantAccount>
	<cfelseif qry_selectMerchantAccountList.RecordCount gt 1>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_payment.multipleMerchantAccount>
	<cfelse>
		<cfset theMerchantAccountID = qry_selectMerchantAccountList.merchantAccountID>
	</cfif>

	<!--- select bank and credit card accounts for customer --->
	<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
		<cfinvokeargument Name="companyID" Value="#theCompanyID#">
		<cfinvokeargument Name="bankStatus" Value="1">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
		<cfinvokeargument Name="companyID" Value="#theCompanyID#">
		<cfinvokeargument Name="creditCardStatus" Value="1">
	</cfinvoke>

	<!--- use subscriber credit card? --->
	<cfif theSubscriberID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="selectSubscriberPaymentList" ReturnVariable="qry_selectSubscriberPaymentList">
			<cfinvokeargument Name="subscriberID" Value="#theSubscriberID#">
			<cfinvokeargument Name="subscriberPaymentStatus" Value="1">
			<cfinvokeargument Name="selectCreditCardInfo" Value="True">
		</cfinvoke>

		<cfif qry_selectSubscriberPaymentList.bankID is not 0>
			<cfif ListFind(ValueList(qry_selectBankList.bankID), qry_selectSubscriberPaymentList.bankID)>
				<cfset theBankID = qry_selectSubscriberPaymentList.bankID>
			<cfelse>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_payment.inactiveBank>
			</cfif>
		<cfelseif qry_selectSubscriberPaymentList.creditCardID is not 0>
			<cfif ListFind(ValueList(qry_selectCreditCardList.creditCardID), qry_selectSubscriberPaymentList.creditCardID)>
				<cfset theCreditCardID = qry_selectSubscriberPaymentList.creditCardID>
			<cfelse>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_payment.inactiveCreditCard>
			</cfif>
		</cfif>
	</cfif><!--- /use subscriber credit card? --->

	<!--- validate and select bank or credit card if not using subscriber payment method --->
	<cfif returnValue is 0 and theBankID is 0 and theCreditCardID is 0>
		<cfif qry_selectBankList.RecordCount is 0 and qry_selectCreditCardList.RecordCount is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_payment.noBankOrCreditCard>
		<cfelseif qry_selectBankList.RecordCount is 1 and qry_selectCreditCardList.RecordCount is 1>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_payment.bothBankAndCreditCard>
		<cfelseif qry_selectBankList.RecordCount gt 1>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_payment.multipleBank>
		<cfelseif qry_selectCreditCardList.RecordCount gt 1>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_payment.multipleCreditCard>
		<cfelseif qry_selectBankList.RecordCount is 1>
			<cfset theBankID = qry_selectBankList.bankID>
		<cfelse><!--- qry_selectCreditCardList.RecordCount is 1 --->
			<cfset theCreditCardID = qry_selectCreditCardList.creditCardID>
		</cfif>
	</cfif><!--- validate and select bank or credit card --->
</cfif><!--- /if paying via merchant account, validate merchant account, credit card and/or bank account --->

<cfif theBankID is not 0 and ListFind("bank,credit card", Arguments.paymentMethod)>
	<cfset Arguments.paymentMethod = "bank">
<cfelseif theCreditCardID is not 0 and ListFind("bank,credit card", Arguments.paymentMethod)>
	<cfset Arguments.paymentMethod = "creditCard">
</cfif>

