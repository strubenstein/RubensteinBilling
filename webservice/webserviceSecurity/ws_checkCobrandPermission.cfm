<cfif Not ListFind(Arguments.useCustomIDFieldList, "cobrandID") and Not ListFind(Arguments.useCustomIDFieldList, "cobrandID_custom")>
	<cfif Arguments.cobrandID is 0 or Not Application.fn_IsIntegerList(Arguments.cobrandID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="checkCobrandPermission" ReturnVariable="isCobrandPermission">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="cobrandID" Value="#Arguments.cobrandID#">
		</cfinvoke>

		<cfif isCobrandPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.cobrandID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.cobrandID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandIDViaCustomID" ReturnVariable="cobrandIDViaCustomID">
		<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="cobrandID_custom" Value="#Arguments.cobrandID_custom#">
	</cfinvoke>

	<cfset returnValue = cobrandIDViaCustomID>
</cfif>

