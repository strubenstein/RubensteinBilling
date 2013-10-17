<cfparam Name="URL.triggerAction" Default="">
<cfinclude template="security_trigger.cfm">

<cfinclude template="../../view/v_trigger/nav_trigger.cfm">
<cfif IsDefined("URL.confirm_trigger")>
	<cfinclude template="../../view/v_trigger/confirm_trigger.cfm">
</cfif>
<cfif IsDefined("URL.error_trigger")>
	<cfinclude template="../../view/v_trigger/error_trigger.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listTriggerActions">
	<cfinclude template="control_listTriggerActions.cfm">
</cfcase>

<cfcase value="insertTriggerAction,updateTriggerAction">
	<cfinclude template="control_insertUpdateTriggerAction.cfm">
</cfcase>

<cfcase value="moveTriggerActionUp,moveTriggerActionDown">
	<cfinvoke Component="#Application.billingMapping#data.TriggerAction" Method="switchTriggerActionOrder" ReturnVariable="isTriggerActionMoved">
		<cfinvokeargument Name="triggerAction" Value="#URL.triggerAction#">
		<cfinvokeargument Name="triggerActionOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=trigger.listTriggerActions&confirm_trigger=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="insertTrigger,updateTrigger">
	<cfinclude template="control_insertUpdateTrigger.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_trigger = "invalidAction">
	<cfinclude template="../../view/v_trigger/error_trigger.cfm">
</cfdefaultcase>
</cfswitch>

