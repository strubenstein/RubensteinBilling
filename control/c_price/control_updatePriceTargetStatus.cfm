
<cfset Variables.priceTargetRedirectURL = Replace(Variables.navPriceAction, Variables.doAction, "priceTargetList", "ONE")>
<cfset Variables.priceTargetRedirectURL = Replace(Variables.priceTargetRedirectURL, "&priceTargetID=#URL.priceTargetID#", "", "ONE")>

<cfif Not IsDefined("URL.priceTargetID") or Not Application.fn_IsIntegerPositive(URL.priceTargetID)>
	<cflocation url="#Variables.priceTargetRedirectURL#&error_price=invalidTarget" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="selectPriceTarget" ReturnVariable="qry_selectPriceTarget">
	<cfinvokeargument Name="priceID" Value="#URL.priceID#">
	<cfinvokeargument Name="priceTargetWithTargetInfo" Value="True">
</cfinvoke>

<cfset ptRow = ListFind(ValueList(qry_selectPriceTarget.priceTargetID), URL.priceTargetID)>
<cfif ptRow is 0>
	<cflocation url="#Variables.priceTargetRedirectURL#&error_price=invalidTarget" AddToken="No">
<cfelseif Variables.doAction is "priceTargetStatus0" and qry_selectPriceTarget.priceTargetStatus[ptRow] is 0>
	<cflocation url="#Variables.priceTargetRedirectURL#&error_price=invalidTargetStatus0" AddToken="No">
<cfelseif Variables.doAction is "priceTargetStatus1" and qry_selectPriceTarget.priceTargetStatus[ptRow] is 1>
	<cflocation url="#Variables.priceTargetRedirectURL#&error_price=invalidTargetStatus1" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="updatePriceTarget" ReturnVariable="isPriceTargetUpdated">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
	<cfinvokeargument Name="priceTargetID" Value="#URL.priceTargetID#">
	<cfinvokeargument Name="priceTargetStatus" Value="#Right(Variables.doAction, 1)#">
</cfinvoke>

<cflocation url="#Variables.priceTargetRedirectURL#&confirm_price=#URL.action#" AddToken="No">

