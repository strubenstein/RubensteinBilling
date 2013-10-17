<cfif Not ListFind(Arguments.useCustomIDFieldList, "categoryID") and Not ListFind(Arguments.useCustomIDFieldList, "categoryCode")>
	<cfif Arguments.categoryID is 0 or Not Application.fn_IsIntegerList(Arguments.categoryID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Category" Method="checkCategoryPermission" ReturnVariable="isCategoryPermission">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="categoryID" Value="#Arguments.categoryID#">
		</cfinvoke>

		<cfif isCategoryPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.categoryID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.categoryCode) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryIDViaCode" ReturnVariable="categoryIDViaCode">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="categoryCode" Value="#Arguments.categoryCode#">
	</cfinvoke>

	<cfset returnValue = categoryIDViaCode>
</cfif>

