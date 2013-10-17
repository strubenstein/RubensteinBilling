<cfif Not ListFind(Arguments.useCustomIDFieldList, "productID") and Not ListFind(Arguments.useCustomIDFieldList, "productID_custom")>
	<cfif Arguments.productID is 0 or Not Application.fn_IsIntegerList(Arguments.productID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="checkProductPermission" ReturnVariable="isProductPermission">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="productID" Value="#Arguments.productID#">
		</cfinvoke>

		<cfif isProductPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.productID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.productID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductIDViaCustomID" ReturnVariable="productIDViaCustomID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="productID_custom" Value="#Arguments.productID_custom#">
	</cfinvoke>

	<cfset returnValue = productIDViaCustomID>
</cfif>

