<cfif Not ListFind(Arguments.useCustomIDFieldList, "invoiceID") and Not ListFind(Arguments.useCustomIDFieldList, "invoiceID_custom")>
	<cfif Arguments.invoiceID is 0 or Not Application.fn_IsIntegerList(Arguments.invoiceID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="checkInvoicePermission" ReturnVariable="isInvoicePermission">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
		</cfinvoke>

		<cfif isInvoicePermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.invoiceID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.invoiceID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceIDViaCustomID" ReturnVariable="invoiceIDViaCustomID">
		<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="invoiceID_custom" Value="#Arguments.invoiceID_custom#">
	</cfinvoke>

	<cfset returnValue = invoiceIDViaCustomID>
</cfif>
