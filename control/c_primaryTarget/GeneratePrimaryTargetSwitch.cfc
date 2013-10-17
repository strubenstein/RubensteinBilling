<cfcomponent displayName="GeneratePrimaryTargetSwitch" hint="Generates cfscript functions for converting primaryTargetID and primaryTargetKey">

<cffunction name="generatePrimaryTargetSwitch" access="public" output="False" returnType="boolean" hint="Generates cfscript functions for converting primaryTargetID and primaryTargetKey">
	<cfset var primaryTargetSwitch = "">
	<cfset var primaryIDSwitch = "">
	<cfset var varFilename = Application.billingFilePath & Application.billingFilepathSlash & "include" & Application.billingFilepathSlash & "config" & Application.billingFilepathSlash & "fn_GetPrimaryTargetID.cfm">

	<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="selectPrimaryTargetList" ReturnVariable="qry_selectPrimaryTargetList">
		<cfinvokeargument Name="queryOrderBy" Value="primaryTargetKey">
	</cfinvoke>

	<cfloop Query="qry_selectPrimaryTargetList">
		<cfset primaryTargetSwitch = primaryTargetSwitch & Chr(10)
			& Chr(9) & "case """ & qry_selectPrimaryTargetList.primaryTargetKey & """ : "
			& "return " & qry_selectPrimaryTargetList.primaryTargetID & ";">
	</cfloop>

	<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="selectPrimaryTargetList" ReturnVariable="qry_selectPrimaryTargetList">
		<cfinvokeargument Name="queryOrderBy" Value="primaryTargetID">
	</cfinvoke>

	<cfloop Query="qry_selectPrimaryTargetList">
		<cfset primaryIDSwitch = primaryIDSwitch & Chr(10)
			& Chr(9) & "case " & qry_selectPrimaryTargetList.primaryTargetID & " : "
			& "return """ & qry_selectPrimaryTargetList.primaryTargetKey & """;">
	</cfloop>

	<cffile Action="Write" File="#varFilename#" Output="
<cfscript>
function fn_GetPrimaryTargetID (primaryTargetKey)
{
switch(primaryTargetKey)
	{#primaryTargetSwitch#
	default : return 0;
	}
}

function fn_GetPrimaryTargetKey (primaryTargetID)
{
switch(primaryTargetID)
	{#primaryIDSwitch#
	default : return """";
	}
}
</cfscript>

<cflock Scope=""Application"" Timeout=""5"">
	<cfset Application.fn_GetPrimaryTargetID = fn_GetPrimaryTargetID>
	<cfset Application.fn_GetPrimaryTargetKey = fn_GetPrimaryTargetKey>
</cflock>

">

	<cfinclude template="../../include/config/fn_GetPrimaryTargetID.cfm">

	<cfreturn True>
</cffunction>

</cfcomponent>

