<cfif Not ListFind(Arguments.useCustomIDFieldList, "paymentCategoryID") and Not ListFind(Arguments.useCustomIDFieldList, "paymentCategoryID_custom")>
	<cfif Arguments.paymentCategoryID is 0 or Not Application.fn_IsIntegerList(Arguments.paymentCategoryID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="checkPaymentCategoryPermission" ReturnVariable="isPaymentCategoryPermission">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="paymentCategoryID" Value="#Arguments.paymentCategoryID#">
		</cfinvoke>

		<cfif isPaymentCategoryPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.paymentCategoryID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.paymentCategoryID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryIDViaCustomID" ReturnVariable="paymentCategoryIDViaCustomID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="paymentCategoryID_custom" Value="#Arguments.paymentCategoryID_custom#">
	</cfinvoke>

	<cfset returnValue = paymentCategoryIDViaCustomID>
</cfif>

