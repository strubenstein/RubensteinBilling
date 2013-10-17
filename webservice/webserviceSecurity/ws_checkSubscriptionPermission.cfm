<cfif Not ListFind(Arguments.useCustomIDFieldList, "subscriptionID") and Not ListFind(Arguments.useCustomIDFieldList, "subscriptionID_custom")>
	<cfif Arguments.subscriptionID is 0 or Not Application.fn_IsIntegerList(Arguments.subscriptionID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="checkSubscriptionPermission" ReturnVariable="isSubscriptionPermission">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="subscriptionID" Value="#Arguments.subscriptionID#">
		</cfinvoke>

		<cfif isSubscriptionPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.subscriptionID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.subscriptionID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionIDViaCustomID" ReturnVariable="subscriptionIDViaCustomID">
		<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="subscriptionID_custom" Value="#Arguments.subscriptionID_custom#">
	</cfinvoke>

	<cfset returnValue = subscriptionIDViaCustomID>
</cfif>

