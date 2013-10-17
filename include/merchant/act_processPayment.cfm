<!--- 
CALLED AS A CUSTOM TAG VIA CFMODULE
Process Payment via merchant account (bank or credit card)
INPUT: paymentID
OUTPUT: isPaymentApproved

avPayment.templateID (for sending receipt when manual payment?)
--->

<cfset Variables.isPaymentInfoOk = True>
<cfset Variables.isPaymentBankOrCreditCard = "">

<cfset Caller.isPaymentApproved = 0>
<cfset Variables.paymentMessage = "">

<cfif Not IsDefined("Attributes.paymentID") or Not Application.fn_IsIntegerList(Attributes.paymentID)>
	<cfset Caller.isPaymentApproved = 0>
	<cfexit Method="exitTag">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPayment" ReturnVariable="qry_selectPayment">
		<cfinvokeargument Name="paymentID" Value="#Attributes.paymentID#">
	</cfinvoke>

	<cfif qry_selectPayment.RecordCount is not ListLen(Attributes.paymentID)>
		<cfset Caller.isPaymentApproved = 0>
		<cfset Variables.paymentMessage = "A valid payment was not specified.">
		<cfexit Method="exitTag">
	<cfelseif qry_selectPayment.paymentAmount is 0>
		<cfset Variables.isPaymentInfoOk = False>
		<cfset Caller.isPaymentApproved = 0>
		<cfset Variables.paymentMessage = "The payment amount cannot be 0.">
	</cfif>
</cfif>

<cfif qry_selectPayment.merchantAccountID is 0>
	<cfset Variables.isPaymentInfoOk = False>
	<cfset Caller.isPaymentApproved = 0>
	<cfset Variables.paymentMessage = "No merchant account was specified for this payment.">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="selectMerchantAccount" ReturnVariable="qry_selectMerchantAccount">
		<cfinvokeargument Name="merchantAccountID" Value="#qry_selectPayment.merchantAccountID#">
		<cfinvokeargument Name="returnMerchantFields" Value="True">
	</cfinvoke>

	<cfif qry_selectMerchantAccount.RecordCount is not 1 or Trim(qry_selectMerchantAccount.merchantFilename) is "">
		<cfset Variables.isPaymentInfoOk = False>
		<cfset Caller.isPaymentApproved = 0>
		<cfset Variables.paymentMessage = "The merchant account specified for this payment was not valid.">
	<cfelseif Not FileExists(Application.billingFilePath & Application.billingFilePathSlash & "include" & Application.billingFilePathSlash & "merchant" & Application.billingFilePathSlash & qry_selectMerchantAccount.merchantFilename)>
		<cfset Variables.isPaymentInfoOk = False>
		<cfset Caller.isPaymentApproved = 0>
		<cfset Variables.paymentMessage = "The merchant account specified for this payment was not valid.">
	</cfif>
</cfif>

<cfif Variables.isPaymentInfoOk is True>
	<cfif qry_selectPayment.creditCardID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCard" ReturnVariable="qry_selectCreditCard">
			<cfinvokeargument Name="creditCardID" Value="#qry_selectPayment.creditCardID#">
		</cfinvoke>

		<cfif qry_selectCreditCard.RecordCount is 1 and qry_selectMerchantAccount.merchantCreditCard is 1 and qry_selectMerchantAccount.merchantAccountCreditCard is 1>
			<cfset Variables.isPaymentBankOrCreditCard = "CreditCard">
		<cfelse>
			<cfset Variables.isPaymentInfoOk = False>
			<cfset Caller.isPaymentApproved = 0>
			<cfset Variables.paymentMessage = "The credit card to be charged for this payment was not valid.">
		</cfif>

	<cfelseif qry_selectPayment.bankID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBank" ReturnVariable="qry_selectBank">
			<cfinvokeargument Name="bankID" Value="#qry_selectPayment.bankID#">
		</cfinvoke>

		<cfif qry_selectBank.RecordCount is 1 and qry_selectMerchantAccount.merchantBank is 1 and qry_selectMerchantAccount.merchantAccountBank is 1>
			<cfset Variables.isPaymentBankOrCreditCard = "Bank">
			<cfset Variables.paymentMessage = "The bank account to be charged for this payment was not valid.">
		<cfelse>
			<cfset Variables.isPaymentInfoOk = False>
		</cfif>

	<cfelse><!--- no credit card or bank info specified --->
		<cfset Variables.isPaymentInfoOk = False>
		<cfset Caller.isPaymentApproved = 0>
		<cfset Variables.paymentMessage = "The payment did not specify a valid bank or credit card account to charge.">
	</cfif>
</cfif>

<cfif Variables.isPaymentInfoOk is False><!--- if not valid to be processed, update payment --->
	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="updatePayment" ReturnVariable="isPaymentUpdated">
		<cfinvokeargument Name="paymentID" Value="#Attributes.paymentID#">
		<cfinvokeargument Name="paymentApproved" Value="#Caller.isPaymentApproved#">
		<cfinvokeargument Name="paymentMessage" Value="#Variables.paymentMessage#">
	</cfinvoke>
<cfelse>
	<cfset Variables.paymentAmount = Application.fn_setDecimalPrecision(qry_selectPayment.paymentAmount, 2)>
	<cfset Variables.paymentIsRefund = qry_selectPayment.paymentIsRefund>
	<cfset Variables.merchantAccountID_custom = qry_selectMerchantAccount.merchantAccountID_custom>
	<cfset Variables.merchantAccountUsername = qry_selectMerchantAccount.merchantAccountUsername>
	<cfset Variables.merchantAccountPassword = qry_selectMerchantAccount.merchantAccountPassword>

	<cfif Variables.isPaymentBankOrCreditCard is "CreditCard">
		<cfset Variables.creditCardNumber = qry_selectCreditCard.creditCardNumber>
		<cfset Variables.creditCardExpirationMonth = qry_selectCreditCard.creditCardExpirationMonth>
		<cfset Variables.creditCardExpirationYear = qry_selectCreditCard.creditCardExpirationYear>
		<cfset Variables.creditCardCVC = qry_selectCreditCard.creditCardCVC>
		<cfset Variables.creditCardName = qry_selectCreditCard.creditCardName>
		<cfset Variables.address = qry_selectCreditCard.address>
		<cfset Variables.address2 = qry_selectCreditCard.address2>
		<cfset Variables.city = qry_selectCreditCard.city>
		<cfset Variables.state = qry_selectCreditCard.state>
		<cfset Variables.zipCode = qry_selectCreditCard.zipCode>
		<cfset Variables.retain = qry_selectCreditCard.creditCardRetain>
	<cfelse><!--- Bank --->
		<cfset Variables.bankAccountNumber = qry_selectBank.bankAccountNumber>
		<cfset Variables.bankRoutingNumber= qry_selectBank.bankRoutingNumber>
		<cfset Variables.bankAccountName = qry_selectBank.bankAccountName>
		<cfset Variables.bankName = qry_selectBank.bankName>
		<cfset Variables.bankCheckingOrSavings = qry_selectBank.bankCheckingOrSavings>
		<cfset Variables.bankPersonalOrCorporate = qry_selectBank.bankPersonalOrCorporate>
		<cfset Variables.address = qry_selectBank.address>
		<cfset Variables.address2 = qry_selectBank.address2>
		<cfset Variables.city = qry_selectBank.city>
		<cfset Variables.state = qry_selectBank.state>
		<cfset Variables.zipCode = qry_selectBank.zipCode>
		<cfset Variables.retain = qry_selectBank.bankRetain>
	</cfif>

	<cfset Variables.paymentApproved = 0>
	<cfset Variables.paymentMessage = "">
	<cfset Variables.paymentID_custom = "">

	<cfinclude template="#qry_selectMerchantAccount.merchantFilename#">

	<!--- Use this code when testing instead of calling the transaction file --->
	<!--- 
	<cfset Variables.paymentApproved = 1>
	<cfset Variables.paymentMessage = "">
	<cfset Variables.paymentID_custom = "">
	--->

	<cfset Caller.isPaymentApproved = Variables.paymentApproved>

	<!--- update payment status --->
	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="updatePayment" ReturnVariable="isPaymentUpdated">
		<cfinvokeargument Name="paymentID" Value="#Attributes.paymentID#">
		<cfinvokeargument Name="paymentApproved" Value="#Caller.isPaymentApproved#">
		<cfinvokeargument Name="paymentMessage" Value="#Variables.paymentMessage#">
	</cfinvoke>

	<!--- if retaining card and CVC exists, blank out CVC and indicate whether transaction was approved --->
	<cfif Variables.retain is 1 and Variables.isPaymentBankOrCreditCard is "CreditCard" and Variables.creditCardCVC is not "">
		<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="updateCreditCard" ReturnVariable="isCreditCardUpdated">
			<cfinvokeargument Name="creditCardID" Value="#qry_selectPayment.creditCardID#">
			<cfinvokeargument Name="deleteCreditCardCVC" Value="True">
			<cfinvokeargument Name="creditCardCVCstatus" Value="#Variables.paymentApproved#">
		</cfinvoke>
	</cfif>

	<cfif Variables.paymentApproved is not 1><!--- payment was rejected ---->
		<!--- send rejection? create rejection task? --->
	<cfelse><!--- if transaction successful --->
		<!--- send receipt? ---->
		<!--- notify admin? ---->

		<!---  If info should not be retained, delete --->
		<cfif Variables.retain is 0>
			<cfif Variables.isPaymentBankOrCreditCard is "CreditCard">
				<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="deleteCreditCard" ReturnVariable="isCreditCardDeleted">
					<cfinvokeargument Name="creditCardID" Value="#qry_selectPayment.creditCardID#">
				</cfinvoke>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.Bank" Method="deleteBank" ReturnVariable="isBankDeleted">
					<cfinvokeargument Name="bankID" Value="#qry_selectPayment.bankID#">
				</cfinvoke>
			</cfif>
		</cfif><!--- delete bank or credit card info? --->
	</cfif><!---- payment successful? --->
</cfif><!--- payment info is valid --->
