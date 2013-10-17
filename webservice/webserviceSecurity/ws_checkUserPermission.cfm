<cfif Not ListFind(Arguments.useCustomIDFieldList, "userID") and Not ListFind(Arguments.useCustomIDFieldList, "userID_custom")>
	<cfif Arguments.userID is 0 or Not Application.fn_IsIntegerList(Arguments.userID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.User" Method="checkUserPermission" ReturnVariable="isUserPermission">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="userID" Value="#Arguments.userID#">
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerPositive(Arguments.companyID)>
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
			</cfif>
		</cfinvoke>

		<cfif isUserPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.userID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.userID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserIDViaCustomID" ReturnVariable="userIDViaCustomID">
		<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="userID_custom" Value="#Arguments.userID_custom#">
		<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerPositive(Arguments.companyID)>
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		</cfif>
	</cfinvoke>

	<cfset returnValue = userIDViaCustomID>
</cfif>

