<!--- 
Type: 
	S = Sale/Payment
	A = Authorization
	C = credit
	D = delayed capture
	V = void
	F = voice authorization
Method:
	CC = credit card
	ECHECK = Telecheck
AVS:
	Not used in test mode
	Separate Y, N, or X is returned for the customer’s street number and ZIP code.
		Y = match
		N = no match
		X = cardholder’s bank does not support AVS.

	No - Transaction is accepted regardless of AVS response
	Full - Accept transaction only if a value of YY is returned (Y for street number and Y for ZIP code).
	Medium - Accept transaction only if at least one Y is returned (NY, XY, YN, or YX)
	Light - Accept the transaction for all return values except NN.

	Results in "Silent Post" if voided because of AVS:
		RESPMSG = AVSDECLINED
		Result = 0

CSC Code:
	Y = The submitted value matches the data on file.
	N = The submitted value does not match the data on file.
	X = The cardholder’s bank does not support this service.

	No - Default. Approve the transaction regardless of response
	Full - Accept the transaction only if Y is returned.
	Light - Accept the transaction only if Y or X is returned.

--->

<cftry>

<cfif Variables.paymentIsRefund is 1>
	<cfset Variables.TRXTYPE = "C">
<cfelse>
	<cfset Variables.TRXTYPE = "S">
</cfif>

<!--- test-payflow.verisign.com --->
<CFX_PAYFLOWPRO
	QUERY="qry_payflowPro" 
	HOSTADDRESS="payflow.verisign.com" 
	HOSTPORT="443" 
	TIMEOUT="30"
	USER="#Variables.merchantAccountUsername#"
	PWD="#Variables.merchantAccountPassword#"
	PARTNER="#Variables.merchantAccountID_custom#"
	TRXTYPE="#Variables.TRXTYPE#"
	TENDER="C"
	ACCT="#Variables.creditCardNumber#"
	EXPDATE="#Variables.creditCardExpirationMonth##Right(Variables.creditCardExpirationYear, 2)#"
	AMT="#Variables.paymentAmount#"
	COMMENT1=""
	COMMENT2=""
	STREET="#Variables.address#"
	ZIP="#Variables.zipCode#"
	PARMLIST=""
	PROXYADDRESS=""
	PROXYPORT=""
	PROXYLOGON=""
	PROXYPASSWORD=""
	CERTPATH= "C:\CFXJava\certs"> 

<cfset Variables.merchantResponse = qry_payflowPro>

<cfif qry_payflowPro.RESULT is 0>
	<cfset Variables.paymentApproved = 1>
<cfelseif qry_payflowPro.RESULT is 12>
	<cfset Variables.paymentApproved = 0>
	<cfset Variables.paymentMessage = qry_payflowPro.respmsg>
<cfelse>
	<cfset Variables.paymentApproved = 0>
	<cfset Variables.paymentMessage = qry_payflowPro.respmsg>
</cfif>

<cfcatch type="ANY">
	<cfset Variables.paymentMessage = Variables.paymentMessage & "<br>Caught processing error: #CFCATCH.message#, exception type: #CFCATCH.TYPE#">
</cfcatch>
</cftry>
