<cfcomponent displayName="ViewStatusHistory" hint="Manages viewing current and history of custom status for a target">

<cffunction name="viewStatusCurrent" access="public" output="yes" returnType="boolean" hint="Displays current status of a target">
	<cfargument name="primaryTargetKey" type="string" required="yes">
	<cfargument name="targetID" type="numeric" required="yes">

	<cfset var primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
	<cfset var returnValue = False>

	<cfinvoke Component="#Application.billingMapping#data.StatusHistory" Method="selectStatusHistory" ReturnVariable="qry_selectStatusHistory">
		<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
		<cfinvokeargument Name="statusHistoryStatus" Value="1">
	</cfinvoke>

	<cfinclude Template="../../view/v_status/dsp_viewStatusCurrent.cfm">
	<cfif qry_selectStatusHistory.RecordCount is not 0>
		<cfset returnValue = True>
	</cfif>

	<cfreturn returnValue>
</cffunction>

<cffunction name="viewStatusHistory" access="public" output="yes" returnType="boolean" hint="Displays status history of a target">
	<cfargument name="primaryTargetKey" type="string" required="yes">
	<cfargument name="targetID" type="numeric" required="yes">

	<cfset var primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
	<cfset var returnValue = False>

	<cfinvoke Component="#Application.billingMapping#data.StatusHistory" Method="selectStatusHistory" ReturnVariable="qry_selectStatusHistory">
		<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
	</cfinvoke>

	<cfinclude Template="../../view/v_status/dsp_viewStatusHistory.cfm">

	<cfif qry_selectStatusHistory.RecordCount is not 0>
		<cfset returnValue = True>
	</cfif>

	<cfreturn returnValue>
</cffunction>

</cfcomponent>