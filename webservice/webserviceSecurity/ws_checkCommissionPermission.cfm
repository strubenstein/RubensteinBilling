<cfif Not ListFind(Arguments.useCustomIDFieldList, "commissionID") and Not ListFind(Arguments.useCustomIDFieldList, "commissionID_custom")>
	<cfif Arguments.commissionID is 0 or Not Application.fn_IsIntegerList(Arguments.commissionID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Commission" Method="checkCommissionPermission" ReturnVariable="isCommissionPermission">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="commissionID" Value="#Arguments.commissionID#">
		</cfinvoke>

		<cfif isCommissionPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.commissionID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.commissionID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Commission" Method="selectCommissionIDViaCustomID" ReturnVariable="commissionIDViaCustomID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="commissionID_custom" Value="#Arguments.commissionID_custom#">
	</cfinvoke>

	<cfset returnValue = commissionIDViaCustomID>
</cfif>
