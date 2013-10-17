<cfif Not ListFind(Arguments.useCustomIDFieldList, "statusID") and Not ListFind(Arguments.useCustomIDFieldList, "statusID_custom")>
	<cfif Arguments.statusID is 0 or Not Application.fn_IsIntegerList(Arguments.statusID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfset primaryTargetID = 0>
		<cfif StructKeyExists(Arguments, "primaryTargetKey") and Trim(Arguments.primaryTargetKey) is not "">
			<cfset primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Status" Method="checkStatusPermission" ReturnVariable="isStatusPermission">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
			<cfif Application.fn_IsIntegerPositive(primaryTargetID)>
				<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
			</cfif>
		</cfinvoke>

		<cfif isStatusPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.statusID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.statusID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfset primaryTargetID = 0>
	<cfif StructKeyExists(Arguments, "primaryTargetKey") and Trim(Arguments.primaryTargetKey) is not "">
		<cfset primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusIDViaCustomID" ReturnVariable="statusIDViaCustomID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
		<cfif Application.fn_IsIntegerPositive(primaryTargetID)>
			<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
		</cfif>
	</cfinvoke>

	<cfset returnValue = statusIDViaCustomID>
</cfif>

