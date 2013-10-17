<!---
INPUT:
merchantAccountID_custom
paymentType
creditCardName
creditCardNumber
creditCardAVS
creditCardExpirationMonth
creditCardExpirationYear
address
address2
city
state
zipCode
paymentAmount
paymentID

OUTPUT:
paymentApproved
paymentMessage
paymentID_custom
--->


<cftry>
<!--- process via bluepay --->

<cfif Variables.paymentIsRefund is 1>
	<cfset Variables.paymentApproved = 0>
	<cfset Variables.paymentMessage = "No support for remote refund/credit transaction.">
<cfelse>
	<cfset Variables.transaction_type = "sale">

	<cfset Variables.ccExpiration = Attributes.creditCardExpirationMonth & "/" & Right(Attributes.creditCardExpirationYear, 2)>

	<!--- https://bluepay.onlinedatacorp.com/test/bluepaylitetest.asp --->
	<cfhttp Method="Post" URL="https://bluepay.onlinedatacorp.com/prod/bluepaylite.asp">
	<cfhttpparam Type="FormField" Name="MERCHANT" Value="#Variables.merchantAccountID_custom#">
	<cfhttpparam Type="FormField" Name="TRANSACTION_TYPE" Value="#Variables.transaction_type#">
	<cfhttpparam Type="FormField" Name="CC_NUM" Value="#Variables.creditCardNumber#">
	<cfhttpparam Type="FormField" Name="CVCCVV2" Value="#Variables.creditCardCVC#">
	<cfhttpparam Type="FormField" Name="CC_EXPIRES" Value="#Variables.ccExpiration#">
	<cfhttpparam Type="FormField" Name="AMOUNT" Value="#Variables.paymentAmount#">
	<cfhttpparam Type="FormField" Name="Order_ID" Value="#Attributes.paymentID#">
	<cfhttpparam Type="FormField" Name="NAME" Value="#Variables.creditCardName#">
	<cfhttpparam Type="FormField" Name="Addr1" Value="#Variables.address#">
	<cfhttpparam Type="FormField" Name="Addr2" Value="#Trim(Variables.address2)#">
	<cfhttpparam Type="FormField" Name="CITY" Value="#Variables.city#">
	<cfhttpparam Type="FormField" Name="STATE" Value="#Variables.state#">
	<cfhttpparam Type="FormField" Name="ZIPCODE" Value="#Variables.zipCode#">
	<cfhttpparam Type="FormField" Name="APPROVED_URL" Value="">
	<cfhttpparam Type="FormField" Name="DECLINED_URL" Value="">
	<cfhttpparam Type="FormField" Name="MISSING_URL" Value="">
	</cfhttp>

	<cfset Variables.merchantResponse = CFHTTP.FileContent>

	<!--- Analyze reseponse to determine whether payment was approved, error message, and returned ID --->
	<cfif FindNoCase("APPROVED", Variables.merchantResponse)>
		<cfset Variables.paymentApproved = 1>
	<cfelseif FindNoCase("DECLINED", Variables.merchantResponse)>
		<cfset Variables.paymentApproved = 0>
		<cfset Variables.paymentMessage = Variables.merchantResponse>
	<cfelseif FindNoCase("MISSING", Variables.merchantResponse)>
		<cfset Variables.paymentApproved = 0>
		<cfset Variables.paymentMessage = Variables.merchantResponse>
	<cfelse>
		<cfset Variables.paymentApproved = 0>
		<cfset Variables.paymentMessage = Variables.merchantResponse>
	</cfif>
</cfif>

<cfcatch type="ANY">
	<cfset Variables.paymentMessage = Variables.paymentMessage & "<br>Caught processing error: #CFCATCH.message#, exception type: #CFCATCH.TYPE#">
</cfcatch>
</cftry>

