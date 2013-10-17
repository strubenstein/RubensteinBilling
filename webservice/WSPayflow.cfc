<cfcomponent DisplayName="WSPayflow" Hint="Manages all subscription processing methods (payflow) web services">

<cffunction Name="insertPayflowTarget" Access="remote" Output="No" ReturnType="boolean" Hint="Inserts target into payflow(s). Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="payflowID" Type="numeric">
	<cfargument Name="payflowID_custom" Type="string">
	<cfargument Name="primaryTargetKey" Type="string">
	<cfargument Name="targetID" Type="numeric">
	<cfargument Name="targetID_custom" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var targetUseCustomIDFieldList = "">
	<cfset var isUserAuthorized = False>

	<cfinclude template="ws_payflow/ws_insertPayflowTarget.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="deletePayflowTarget" Access="remote" Output="No" ReturnType="boolean" Hint="Removes target from payflow(s). Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="payflowID" Type="numeric">
	<cfargument Name="payflowID_custom" Type="string">
	<cfargument Name="primaryTargetKey" Type="string">
	<cfargument Name="targetID" Type="numeric">
	<cfargument Name="targetID_custom" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var targetUseCustomIDFieldList = "">
	<cfset var isUserAuthorized = False>

	<cfinclude template="ws_payflow/ws_deletePayflowTarget.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
