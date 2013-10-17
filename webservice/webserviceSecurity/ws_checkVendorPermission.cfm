<cfif Not ListFind(Arguments.useCustomIDFieldList, "vendorID") and Not ListFind(Arguments.useCustomIDFieldList, "vendorID_custom")>
	<cfif Arguments.vendorID is 0 or Not Application.fn_IsIntegerList(Arguments.vendorID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="checkVendorPermission" ReturnVariable="isVendorPermission">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="vendorID" Value="#Arguments.vendorID#">
		</cfinvoke>

		<cfif isVendorPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.vendorID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.vendorID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorIDViaCustomID" ReturnVariable="vendorIDViaCustomID">
		<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="vendorID_custom" Value="#Arguments.vendorID_custom#">
	</cfinvoke>

	<cfset returnValue = vendorIDViaCustomID>
</cfif>
