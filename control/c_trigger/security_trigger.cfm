<cfif ListFind("updateTriggerAction,insertTrigger,updateTrigger,moveTriggerActionUp,moveTriggerActionDown", Variables.doAction)>
	<cfif Trim(URL.triggerAction) is "">
		<cflocation url="index.cfm?method=trigger.listTriggerActions&error_trigger=noTriggerAction" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.TriggerAction" Method="selectTriggerActionList" ReturnVariable="qry_selectTriggerAction">
			<cfinvokeargument Name="triggerAction" Value="#URL.triggerAction#">
			<cfif Session.companyID is Application.billingSuperuserCompanyID>
				<cfinvokeargument Name="permissionStatus" Value="1">
				<cfinvokeargument Name="permissionSuperuserOnly" Value="0">
			</cfif>
		</cfinvoke>

		<cfif qry_selectTriggerAction.RecordCount is 0>
			<cflocation url="index.cfm?method=trigger.listTriggerActions&error_trigger=invalidTriggerAction" AddToken="No">
		<cfelseif ListFind("insertTrigger,updateTrigger", Variables.doAction)>
			<cfinvoke Component="#Application.billingMapping#data.Trigger" Method="selectTriggerList" ReturnVariable="qry_selectTrigger">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="triggerAction" Value="#URL.triggerAction#">
			</cfinvoke>

			<cfif (Variables.doAction is "insertTrigger" and qry_selectTrigger.RecordCount is not 0)
					or (Variables.doAction is "updateTrigger" and qry_selectTrigger.RecordCount is not 1)>
				<cflocation url="index.cfm?method=trigger.listTriggerActions&error_trigger=#Variables.doAction#" AddToken="No">
			</cfif>
		</cfif>
	</cfif>
</cfif>

