<cfif Not ListFind(Arguments.useCustomIDFieldList, "paymentID") and Not ListFind(Arguments.useCustomIDFieldList, "paymentID_custom")>
	<cfif Arguments.paymentID is 0 or Not Application.fn_IsIntegerList(Arguments.paymentID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payment" Method="checkPaymentPermission" ReturnVariable="isPaymentPermission">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="paymentID" Value="#Arguments.paymentID#">
		</cfinvoke>

		<cfif isPaymentPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.paymentID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.paymentID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPaymentIDViaCustomID" ReturnVariable="paymentIDViaCustomID">
		<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="paymentID_custom" Value="#Arguments.paymentID_custom#">
	</cfinvoke>

	<cfset returnValue = paymentIDViaCustomID>
</cfif>
