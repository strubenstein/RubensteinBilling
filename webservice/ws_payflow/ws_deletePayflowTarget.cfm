<cfinclude template="wslang_payflow.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelse>
	<!--- validate target and action permission --->
	<cfinclude template="wsact_validatePayflowTarget.cfm">

	<cfif Arguments.targetID is 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_payflow.invalidTarget>
	<cfelseif Not isUserAuthorized>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_payflow.noTargetPermission>
	<cfelse>
		<cfset Arguments.payflowID = Application.objWebServiceSecurity.ws_checkPayflowPermission(qry_selectWebServiceSession.companyID_author, Arguments.payflowID, Arguments.payflowID_custom, Arguments.useCustomIDFieldList)>

		<cfif Arguments.payflowID is 0>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_payflow.invalidPayflow>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="updatePayflowTarget" ReturnVariable="isPayflowTargetUpdated">
				<cfinvokeargument Name="userID" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="payflowTargetStatus" Value="0">
				<cfinvokeargument Name="payflowID" Value="#Arguments.payflowID#">
				<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)#">
				<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
			</cfinvoke>

			<cfset returnValue = True>
		</cfif><!--- valid payflow(s) --->
	</cfif><!--- valid target --->
</cfif><!--- /user is logged in --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

