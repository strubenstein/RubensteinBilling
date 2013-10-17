<cfinclude template="wslang_group.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelse>
	<!--- validate target and action permission --->
	<cfinclude template="wsact_validateGroupTarget.cfm">

	<cfif Arguments.targetID is 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_group.invalidTarget>
	<cfelseif Not isUserAuthorized>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_group.noTargetPermission>
	<cfelse>
		<cfset Arguments.groupID = Application.objWebServiceSecurity.ws_checkGroupPermission(qry_selectWebServiceSession.companyID_author, Arguments.groupID, Arguments.groupID_custom, Arguments.useCustomIDFieldList)>

		<cfif Arguments.groupID is 0>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_group.noTargetPermission>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Group" Method="updateGroupTarget" ReturnVariable="isGroupTargetUpdated">
				<cfinvokeargument Name="userID" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="groupID" Value="#Arguments.groupID#">
				<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)#">
				<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
			</cfinvoke>

			<cfset returnValue = True>
		</cfif><!--- valid group(s) --->
	</cfif><!--- valid target --->
</cfif><!--- /user is logged in --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

