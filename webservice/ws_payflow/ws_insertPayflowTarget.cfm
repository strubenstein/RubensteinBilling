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
		<!--- payflow(s) is validated in included file --->
		<cfinclude template="wsact_insertPayflowTarget.cfm">
	</cfif><!--- valid target --->
</cfif><!--- /user is logged in --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

