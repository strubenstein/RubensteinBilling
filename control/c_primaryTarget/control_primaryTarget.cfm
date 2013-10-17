<cfparam Name="URL.primaryTargetID" Default="0">

<cfinclude template="security_primaryTarget.cfm">
<cfinclude template="../../view/v_primaryTarget/nav_primaryTarget.cfm">
<cfif IsDefined("URL.confirm_primaryTarget")>
	<cfinclude template="../../view/v_primaryTarget/confirm_primaryTarget.cfm">
</cfif>
<cfif IsDefined("URL.error_primaryTarget")>
	<cfinclude template="../../view/v_primaryTarget/error_primaryTarget.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listPrimaryTargets">
	<cfinclude template="control_listPrimaryTargets.cfm">
</cfcase>

<cfcase value="insertPrimaryTarget,updatePrimaryTarget">
	<cfinclude template="control_insertUpdatePrimaryTarget.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_primaryTarget = "invalidAction">
	<cfinclude template="../../view/v_primaryTarget/error_primaryTarget.cfm">
</cfdefaultcase>
</cfswitch>