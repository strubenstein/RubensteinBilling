<cfif Not ListFind(Arguments.useCustomIDFieldList, "companyID") and Not ListFind(Arguments.useCustomIDFieldList, "companyID_custom")>
	<cfif Arguments.companyID is 0 or Not Application.fn_IsIntegerList(Arguments.companyID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Company" Method="checkCompanyPermission" ReturnVariable="isCompanyPermission">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		</cfinvoke>

		<cfif isCompanyPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.companyID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.companyID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompanyIDViaCustomID" ReturnVariable="companyIDViaCustomID">
		<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="companyID_custom" Value="#Arguments.companyID_custom#">
	</cfinvoke>

	<cfset returnValue = companyIDViaCustomID>
</cfif>
