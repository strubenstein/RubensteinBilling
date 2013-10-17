<!--- validate statusID or statusID_custom for this company/target --->
<cfinclude template="wslang_status.cfm">
<cfif primaryTargetID is 0>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_status.invalidTargetType>
<cfelseif Not Application.fn_IsIntegerPositive(Arguments.targetID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_status.invalidTarget>
<cfelse>
	<cfif Arguments.statusID is 0 and Not ListFind(Arguments.useCustomIDFieldList, "statusID") and Not ListFind(Arguments.useCustomIDFieldList, "statusID_custom")>
		<cfset Arguments.statusID = 0>
	<cfelse>
		<cfset Arguments.statusID = Application.objWebServiceSecurity.ws_checkStatusPermission(Arguments.companyID_author, Arguments.statusID, Arguments.statusID_custom, Arguments.useCustomIDFieldList, Arguments.primaryTargetKey)>
	</cfif>

	<cfif Arguments.statusID is 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_status.customStatusOption>
	<cfelse>
		<cfinvoke component="#Application.billingMapping#data.StatusHistory" method="maxlength_StatusHistory" returnVariable="maxlength_StatusHistory" />

		<cfinvoke Component="#Application.billingMapping#data.StatusHistory" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
			<cfinvokeargument Name="userID" Value="#Arguments.userID_author#">
			<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
			<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
			<cfinvokeargument Name="statusHistoryManual" Value="1">
			<cfinvokeargument Name="statusHistoryComment" Value="#Left(Arguments.statusHistoryComment, maxlength_StatusHistory.statusHistoryComment)#">
		</cfinvoke>

		<cfset returnValue = True>
	</cfif><!--- /status is ok --->
</cfif><!--- /primary target is ok --->

