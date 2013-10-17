<cfif Variables.doAction is "updatePrimaryTarget" and IsDefined("qry_selectPrimaryTarget")>
	<cfparam Name="Form.primaryTargetTable" Default="#qry_selectPrimaryTarget.primaryTargetTable#">
	<cfparam Name="Form.primaryTargetKey" Default="#qry_selectPrimaryTarget.primaryTargetKey#">
	<cfparam Name="Form.primaryTargetName" Default="#qry_selectPrimaryTarget.primaryTargetName#">
	<cfparam Name="Form.primaryTargetDescription" Default="#qry_selectPrimaryTarget.primaryTargetDescription#">
	<cfparam Name="Form.primaryTargetStatus" Default="#qry_selectPrimaryTarget.primaryTargetStatus#">
</cfif>

<cfparam Name="Form.primaryTargetTable" Default="">
<cfparam Name="Form.primaryTargetKey" Default="">
<cfparam Name="Form.primaryTargetName" Default="">
<cfparam Name="Form.primaryTargetDescription" Default="">
<cfparam Name="Form.primaryTargetStatus" Default="1">

