<cfif Not ListFind(Arguments.useCustomIDFieldList, "payflowID") and Not ListFind(Arguments.useCustomIDFieldList, "payflowID_custom")>
	<cfif Arguments.payflowID is 0 or Not Application.fn_IsIntegerList(Arguments.payflowID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="checkPayflowPermission" ReturnVariable="isPayflowPermission">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="payflowID" Value="#Arguments.payflowID#">
		</cfinvoke>

		<cfif isPayflowPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.payflowID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.payflowID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="selectPayflowIDViaCustomID" ReturnVariable="payflowIDViaCustomID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="payflowID_custom" Value="#Arguments.payflowID_custom#">
	</cfinvoke>

	<cfset returnValue = payflowIDViaCustomID>
</cfif>

