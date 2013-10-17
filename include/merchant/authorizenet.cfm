<cftry>
<!--- insert code here for AuthorizeNet --->
<cfif Variables.paymentIsRefund is 1>
	<cfset Variables.x_type = "CREDIT">
<cfelse>
	<cfset Variables.x_type = "AUTH_CAPTURE">
</cfif>

<!--- x_test_request = True/False --->
<cfif Variables.isPaymentBankOrCreditCard is "CreditCard">
	<!--- credit card --->
	<cfhttp Method="Post" URL="https://secure.authorize.net/gateway/transact.dll">
	<cfhttpparam Type="FormField" Name="x_version" Value="3.1">
	<cfhttpparam Type="FormField" Name="x_delim_data" Value="True">
	<cfhttpparam Type="FormField" Name="x_relay_response" Value="False">
	<cfhttpparam Type="FormField" Name="x_login" Value="#Variables.merchantAccountUsername#">
	<cfhttpparam Type="FormField" Name="x_tran_key" Value="#Variables.merchantAccountID_custom#">
	<cfhttpparam Type="FormField" Name="x_amount" Value="#Variables.paymentAmount#">
	<cfhttpparam Type="FormField" Name="x_method" Value="cc">
	<cfhttpparam Type="FormField" Name="x_card_num" Value="#Variables.creditCardNumber#">
	<cfhttpparam Type="FormField" Name="x_exp_date" Value="#Variables.creditCardExpirationMonth#/#Variables.creditCardExpirationYear#">
	<cfhttpparam Type="FormField" Name="x_card_code" Value="#Variables.creditCardCVC#">
	<cfhttpparam Type="FormField" Name="x_type" Value="#Variables.x_type#"><!--- AUTH_CAPTURE,AUTH_ONLY,CAPTURE_ONLY,CREDIT,VOID,PRIOR_AUTH_CAPTURE --->
	</cfhttp>

	<!--- 
	Attributes.paymentID
	Variables.creditCardName 
	x_firstName
	x_lastName
	x_company
	<cfhttpparam Type="FormField" Name="x_address" Value="#Variables.address#">
	<cfhttpparam Type="FormField" Name="x_city" Value="#Variables.city#">
	<cfhttpparam Type="FormField" Name="x_state" Value="#Variables.state#">
	<cfhttpparam Type="FormField" Name="x_zip" Value="#Variables.zipCode#">
	--->

<cfelse><!--- Bank --->
	<!--- x_bank_acct_type: Checking, BusinessChecking, Savings --->
	<!--- x_echeck_type: CCD,PPD,TEL,WEB --->
	<cfif Variables.bankCheckingOrSavings is 1>
		<cfset Variables.x_bank_acct_type = "Savings">
		<cfset Variables.x_echeck_type = "WEB">
	<cfelseif Variables.bankPersonalOrCorporate is 1>
		<cfset Variables.x_bank_acct_type = "BusinessChecking">
		<cfset Variables.x_echeck_type = "CCD">
	<cfelse>
		<cfset Variables.x_bank_acct_type = "Checking">
		<cfset Variables.x_echeck_type = "WEB">
	</cfif>

	<!--- echeck --->
	<cfhttp Method="Post" URL="https://secure.authorize.net/gateway/transact.dll">
	<cfhttpparam Type="FormField" Name="x_version" Value="3.1">
	<cfhttpparam Type="FormField" Name="x_delim_data" Value="True">
	<cfhttpparam Type="FormField" Name="x_relay_response" Value="False">
	<cfhttpparam Type="FormField" Name="x_login" Value="#Variables.merchantAccountUsername#">
	<cfhttpparam Type="FormField" Name="x_tran_key" Value="#Variables.merchantAccountID_custom#">
	<cfhttpparam Type="FormField" Name="x_amount" Value="#Variables.paymentAmount#">
	<cfhttpparam Type="FormField" Name="x_method" Value="echeck">
	<cfhttpparam Type="FormField" Name="x_bank_aba_code" Value="#Variables.bankRoutingNumber#">
	<cfhttpparam Type="FormField" Name="x_bank_acct_num" Value="#Variables.bankAccountNumber#">
	<cfhttpparam Type="FormField" Name="x_bank_acct_type" Value="#Variables.x_bank_acct_type#">
	<cfhttpparam Type="FormField" Name="x_bank_name" Value="#Variables.bankName#">
	<cfhttpparam Type="FormField" Name="x_bank_acct_name" Value="#Variables.bankAccountName#">
	<cfhttpparam Type="FormField" Name="x_type" Value="#Variables.x_type#"><!--- AUTH_CAPTURE,CREDIT --->
	<cfhttpparam Type="FormField" Name="x_echeck_type" Value="#Variables.x_echeck_type#">
	</cfhttp>
</cfif>

<cfset Variables.merchantResponse = CFHTTP.FileContent>

<cfswitch expression="#ListFirst(Variables.merchantResponse)#">
<cfcase value="1"><!--- Approved --->
	<cfset Variables.paymentApproved = 1>
</cfcase>
<cfcase value="2"><!--- Declined --->
	<cfset Variables.paymentApproved = 0>
	<cfset Variables.paymentMessage = Variables.merchantResponse>
</cfcase>
<cfcase value="3"><!--- Error --->
	<cfset Variables.paymentApproved = 0>
	<cfset Variables.paymentMessage = Variables.merchantResponse>
</cfcase>
</cfswitch>

<cfcatch type="ANY">
	<cfset Variables.paymentMessage = Variables.paymentMessage & "<br>Caught processing error: #CFCATCH.message#, exception type: #CFCATCH.TYPE#">
</cfcatch>
</cftry>
