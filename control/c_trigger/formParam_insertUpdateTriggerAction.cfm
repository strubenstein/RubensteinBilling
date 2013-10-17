<cfif URL.triggerAction is not "" and IsDefined("qry_selectTriggerAction")>
	<cfparam Name="Form.triggerActionStatus" Default="#qry_selectTriggerAction.triggerActionStatus#">
	<cfparam Name="Form.triggerActionControl_select" Default="#qry_selectTriggerAction.triggerActionControl#">
	<cfparam Name="Form.triggerActionDescription" Default="#qry_selectTriggerAction.triggerActionDescription#">
	<cfparam Name="Form.triggerActionOrder" Default="#qry_selectTriggerAction.triggerActionOrder#">
	<cfparam Name="Form.triggerActionSuperuserOnly" Default="#qry_selectTriggerAction.triggerActionSuperuserOnly#">
	<cfparam Name="Form.triggerAction" Default="#qry_selectTriggerAction.triggerAction#">
</cfif>

<cfparam Name="Form.triggerAction" Default="">
<cfparam Name="Form.triggerActionSuperuserOnly" Default="0">
<cfparam Name="Form.triggerActionStatus" Default="1">
<cfparam Name="Form.triggerActionControl_text" Default="">
<cfparam Name="Form.triggerActionControl_select" Default="">
<cfparam Name="Form.triggerActionDescription" Default="">
<cfparam Name="Form.triggerActionOrder" Default="0">

