<cfif Not ListFind(Arguments.useCustomIDFieldList, "groupID") and Not ListFind(Arguments.useCustomIDFieldList, "groupID_custom")>
	<cfif Arguments.groupID is 0 or Not Application.fn_IsIntegerList(Arguments.groupID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Group" Method="checkGroupPermission" ReturnVariable="isGroupPermission">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="groupID" Value="#Arguments.groupID#">
		</cfinvoke>

		<cfif isGroupPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.groupID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.groupID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupIDViaCustomID" ReturnVariable="groupIDViaCustomID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="groupID_custom" Value="#Arguments.groupID_custom#">
	</cfinvoke>

	<cfset returnValue = groupIDViaCustomID>
</cfif>
