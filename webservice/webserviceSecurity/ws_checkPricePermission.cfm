<cfif Not ListFind(Arguments.useCustomIDFieldList, "priceID") and Not ListFind(Arguments.useCustomIDFieldList, "priceID_custom")>
	<cfif Arguments.priceID is 0 or Not Application.fn_IsIntegerList(Arguments.priceID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Price" Method="checkPricePermission" ReturnVariable="isPricePermission">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="priceID" Value="#Arguments.priceID#">
		</cfinvoke>

		<cfif isPricePermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.priceID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.priceID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectPriceIDViaCustomID" ReturnVariable="priceIDViaCustomID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="priceID_custom" Value="#Arguments.priceID_custom#">
	</cfinvoke>

	<cfset returnValue = priceIDViaCustomID>
</cfif>

