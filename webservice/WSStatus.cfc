<cfcomponent DisplayName="WSStatus" Hint="Manages all custom status web services">

<!--- change permission to target instead of status --->
<cffunction Name="selectStatusHistory" Access="remote" Output="No" ReturnType="query" Hint="Selects current custom status for target.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="primaryTargetKey" Type="string">
	<cfargument Name="targetID" Type="numeric">
	<cfargument Name="targetID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var isUserAuthorized = False>
	<cfset var targetUseCustomIDFieldList = "">

	<cfset Variables.statusHistoryStatus = 1>
	<cfinclude template="ws_status/ws_selectStatusHistory.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
