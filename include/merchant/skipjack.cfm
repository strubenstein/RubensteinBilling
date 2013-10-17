<cftry>

<cfset Variables.orderString = Variables.paymentID & "~" & "Payment" & "~" & Variables.paymentAmount & "~1~N~||">

<!--- insert code here for skipjack --->
<cfhttp Method="POST" URL="https://www.skipjackic.com/scripts/EvolvCC.dll?Authorize"> 
<cfhttpparam Name="serialnumber" TYPE="FormField" Value="#Variables.merchantAccountID_custom#">
<cfhttpparam Name="transactionamount" TYPE="FormField" Value="#Variables.paymentAmount#">
<cfhttpparam Name="orderstring" TYPE="FormField" Value="#Variables.orderString#">
<cfhttpparam Name="ordernumber" TYPE="FormField" value= "#Variables.paymentID#">
<!--- 
<cfhttpparam Name="shiptoname" TYPE="FormField" Value="">
 <cfhttpparam Name="shiptoStreetaddress" TYPE="FormField" Value="">
<cfhttpparam Name="shiptostreetaddress2" TYPE="FormField"  Value="">
<cfhttpparam Name="ShiptoCity" TYPE="FormField" Value="">
<cfhttpparam Name="ShiptoState" TYPE="FormField" Value="">
<cfhttpparam Name="ShiptoZipcode" TYPE="FormField" Value=""> 
<cfhttpparam Name="shiptophone" TYPE="FormField" Value="">
<cfhttpparam Name="country" TYPE="FormField" Value="">
<cfhttpparam Name="phone" TYPE="FormField" Value="">
<cfhttpparam Name="email" TYPE="FormField" Value="">
--->
<cfhttpparam Name="name" TYPE="FormField" Value="#Variables.creditCardName#">
<cfhttpparam Name="streetaddress" TYPE="FormField"  Value="#Variables.address#">
<cfhttpparam Name="streetaddress2" TYPE="FormField"  Value="#Trim(Variables.address2)#">
<cfhttpparam Name="city" TYPE="FormField" Value="#Variables.city#">
<cfhttpparam Name="state" TYPE="FormField" Value="#Variables.state#">
<cfhttpparam Name="zipcode" TYPE="FormField" Value="#Variables.zipCode#">
<cfhttpparam Name="accountnumber" TYPE="FormField" Value="#Variables.creditCardNumber#">
<cfhttpparam Name="month" TYPE="FormField" Value="#Variables.creditCardExpirationMonth#">
<cfhttpparam Name="year" TYPE="FormField" Value="#Right(Variables.creditCardExpirationYear, 2)#">
</cfhttp>
<!---
#Variables.creditCardCVC#
 --->

<cfset Variables.merchantResponse = CFHTTP.FileContent>

<cfset ValList="-AUTHCODE,-szSerialNumber,-szTransactionAmount,-szAuthorizationDeclinedMessage,-szAVSResponseCode,-szAVSResponseMessage,-szOrderNumber,-szAuthorizationResponseCode,-szReturnCode">
<cfset VarList="strAuthCode,strSerialNumber,strTransactionAmount,strAuthorizationDeclinedMessage,strAVSResponseCode,strAVSResponseMessage,strOrderNumber,strAuthorizationResponseCode,strReturnCode">

<cfset loopCount = 0>
<cfloop Index="Val_Name" List="#ValList#">
	<cfset loopCount = IncrementValue(loopCount)>
	<cfset length = Len(Val_Name)>
	<cfset start = FindNoCase(Val_Name, CFHTTP.FileContent, 1) + length + 1>
	<cfset end = FindNoCase("-->", CFHTTP.FileContent, start) - start>
	<cfset Var_Name = ListGetAt(VarList, loopCount, ",")>
	<cfset a = SetVariable(Var_name, Mid(CFHTTP.FileContent, start, end))>
</cfloop>

<!--- Analyze reseponse to determine whether payment was approved, error message, and returned ID --->
<cfif strAuthorizationResponseCode is not "">
	<cfset Variables.paymentApproved = 1>
<cfelse>
	<cfset Variables.paymentApproved = 0>
	<cfset Variables.paymentMessage = Variables.merchantResponse>
</cfif>

<cfcatch type="ANY">
	<cfset Variables.paymentMessage = Variables.paymentMessage & "<br>Caught processing error: #CFCATCH.message#, exception type: #CFCATCH.TYPE#">
</cfcatch>
</cftry>
