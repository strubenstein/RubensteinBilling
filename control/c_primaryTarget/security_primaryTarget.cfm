<cfif Not Application.fn_IsIntegerNonNegative(URL.primaryTargetID)>
	<cflocation url="index.cfm?method=primaryTarget.listPrimaryTargets&error_primaryTarget=noPrimaryTarget" AddToken="No">
<cfelseif URL.primaryTargetID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="selectPrimaryTarget" ReturnVariable="qry_selectPrimaryTarget">
		<cfinvokeargument Name="primaryTargetID" Value="#URL.primaryTargetID#">
	</cfinvoke>

	<cfif qry_selectPrimaryTarget.RecordCount is 0>
		<cflocation url="index.cfm?method=primaryTarget.listPrimaryTargets&error_primaryTarget=invalidPrimaryTarget" AddToken="No">
	</cfif>
<cfelseif ListFind("updatePrimaryTarget", Variables.doAction)>
	<cflocation url="index.cfm?method=primaryTarget.listPrimaryTargets&error_primaryTarget=noPrimaryTarget" AddToken="No">
</cfif>
