<cfcomponent DisplayName="WSGroup" Hint="Manages all group web services">

<cffunction Name="insertGroupTarget" Access="remote" Output="No" ReturnType="boolean" Hint="Inserts target into group(s). Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="groupID" Type="string">
	<cfargument Name="groupID_custom" Type="string">
	<cfargument Name="primaryTargetKey" Type="string">
	<cfargument Name="targetID" Type="numeric">
	<cfargument Name="targetID_custom" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var isUserAuthorized = False>

	<cfinclude template="ws_group/ws_insertGroupTarget.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="deleteGroupTarget" Access="remote" Output="No" ReturnType="boolean" Hint="Removes target from group(s). Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="groupID" Type="numeric">
	<cfargument Name="groupID_custom" Type="string">
	<cfargument Name="primaryTargetKey" Type="string">
	<cfargument Name="targetID" Type="numeric">
	<cfargument Name="targetID_custom" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var isUserAuthorized = False>

	<cfinclude template="ws_group/ws_deleteGroupTarget.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
