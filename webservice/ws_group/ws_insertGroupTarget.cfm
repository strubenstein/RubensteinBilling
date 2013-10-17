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
		<!--- group(s) is validated in included file --->
		<cfinclude template="wsact_insertGroupTarget.cfm">
	</cfif><!--- valid target --->
</cfif><!--- /user is logged in --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

