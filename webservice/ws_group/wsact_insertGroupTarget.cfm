<!--- 
INPUT:
Variables.primaryTargetKey
Variables.targetID
--->

<!--- validate statusID or statusID_custom for this company/target --->
<cfif Not IsDefined("Variables.wslang_group")>
	<cfinclude template="wslang_group.cfm">
</cfif>

<cfif Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey) is 0>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_group.invalidTargetType>
<cfelseif Not Application.fn_IsIntegerPositive(Arguments.targetID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_group.invalidTarget>
<cfelse>
	<cfset Arguments.groupID = Application.objWebServiceSecurity.ws_checkGroupPermission(qry_selectWebServiceSession.companyID_author, Arguments.groupID, Arguments.groupID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.groupID is 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_group.invalidGroup>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Group" Method="insertGroupTarget" ReturnVariable="isGroupTargetInserted">
			<cfinvokeargument Name="groupID" Value="#Arguments.groupID#">
			<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)#">
			<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
			<cfinvokeargument Name="userID" Value="#qry_selectWebServiceSession.userID#">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID#">
			<cfinvokeargument Name="groupTargetStatus" Value="1">
			<cfinvokeargument Name="isSubmitttedFromGroupControl" Value="False">
		</cfinvoke>

		<cfset returnValue = True>
	</cfif><!--- /groups are ok --->
</cfif><!--- /primary target is ok --->

