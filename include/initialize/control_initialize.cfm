<!--- 
This configuration script assumes the following steps have already bee performed:
1. Copy Billing directory to your server
2. Move importExportTemp directory to non-public directory
3. Create database
4. Create database tables
5. Create mapping
6. Create ColdFusion datasource

STEPS:
1. Set application variables
2. Insert permissions
3. Insert primary targets
4. Insert export tables, queries and fields
5. Insert content, merchants and default templates
6. Insert master company and user, assign full permissions
7. Insert scheduled scripts - request how often to run?
--->

<cfparam Name="URL.step" Default="1">
<cfif Not IsNumeric(URL.step) or URL.step lt 1 or URL.step is not Int(URL.step) or URL.step gt 8>
	<cfset URL.step = 1>
</cfif>

<cfset Variables.initializeList = "App Variables,Permissions,Targets,Export,Scheduled Scripts +,Master User">
<cfoutput>
<html><head><title>Initialize Billing</title></head><body>
<link rel="stylesheet" type="text/css" href="billing.css">

<p>
<div class="SubTitle">Initialize Billing</div>
<table border="0" cellspacing="4" cellpadding="2" class="TableText">
<tr valign="top">
	<th class="TableHeader">PROGRESS: </th>
	<cfloop Index="count" From="1" To="#ListLen(Variables.initializeList)#">
		<th bgcolor="<cfif count is URL.step>yellow<cfelseif count gt URL.step>red<cfelse>lime</cfif>">#count#. #ListGetAt(Variables.initializeList, count)#</th>
	</cfloop>
</tr>
</table>
</p>

<style type="text/css">
	.RedError {
		font-family: Arial, Helvetica, sans-serif; 
		font-size: 13px; 
		font-style: normal; 
		line-height: normal; 
		font-weight: normal; 
		color: red
	};
</style>
</cfoutput>

<cfscript>
function fn_setTextClass (field)
{
	if (Trim(field) is not "" and StructKeyExists(errorMessage_fields, field))
		return 'RedError';
	else
		return 'MainText';
}
</cfscript>

<cfif URL.step is 1>
	<cfinclude template="control_applicationVariables.cfm">
	<!--- test DSN = BillingSQL_clean --->
</cfif>

<cfif URL.step gt 1 and (Not IsDefined("Application.billingUrl") or IsDefined("URL.resetApplicationVariables"))>
	<cfinclude template="../config/var_applicationVariables.cfm">
	<cfinclude template="../config/act_setConfigVariables.cfm">
</cfif>

<cfif URL.step is 2>
	<cfoutput><p class="SubTitle">Insert Permissions Into Database</p></cfoutput>

	<cfinclude template="act_insertPermissions.cfm">
	<cfinclude template="../security/act_applicationPermissionStruct.cfm">

	<cfoutput>
	<p class="ConfirmationMessage">Permissions inserted. Step 2 successfully completed.<br>Continue to Step 3 to insert the primary targets.</p>
	<form method="get" action="initialize.cfm">
	<input type="hidden" name="step" value="3">
	<input type="submit" value="Continue to Step 3">
	</form>
	</cfoutput>
</cfif>

<cfif URL.step is 3>
	<cfoutput><p class="SubTitle">Insert Primary Targets Into Database</p></cfoutput>

	<cfinclude template="act_insertPrimaryTargets.cfm">

	<cfoutput>
	<p class="ConfirmationMessage">Primary targets inserted. Step 3 successfully completed.<br>Continue to Step 4 to insert the export options.</p>
	<form method="get" action="initialize.cfm">
	<input type="hidden" name="step" value="4">
	<input type="submit" value="Continue to Step 4">
	</form>
	</cfoutput>
</cfif>

<cfif URL.step is 4>
	<cfoutput><p class="SubTitle">Insert Export Options Into Database</p></cfoutput>

	<cfinclude template="../config/fn_GetPrimaryTargetID.cfm">
	<cfinclude template="act_insertExportTables.cfm">
	<cfinclude template="act_insertExportQueries.cfm">

	<cfoutput>
	<p class="ConfirmationMessage">Export options inserted. Step 4 successfully completed.<br>Continue to Step 5 to add the content, merchant processors, templates and scheduled scripts.</p>
	<form method="get" action="initialize.cfm">
	<input type="hidden" name="step" value="5">
	<input type="submit" value="Continue to Step 5">
	</form>
	</cfoutput>
</cfif>

<cfif URL.step is 5>
	<cfoutput><p class="SubTitle">Insert Content, Merchant Processors, Templates, Scheduled Scripts  &amp; Triggers Into Database</p></cfoutput>

	<cfinclude template="act_insertContent.cfm">
	<cfinclude template="act_insertMerchants.cfm">
	<cfinclude template="act_insertTemplates.cfm">
	<cfinclude template="control_insertSchedulers.cfm">
	<cfinclude template="act_insertTriggerActions.cfm">

	<cfoutput>
	<p class="ConfirmationMessage">Content, merchant processors, templates &amp; scheduled scripts inserted. Step 5 successfully completed.<br>Continue to Step 6 (the last step) to add the master user.</p>
	<form method="get" action="initialize.cfm">
	<input type="hidden" name="step" value="6">
	<input type="submit" value="Continue to Step 6">
	</form>
	</cfoutput>
</cfif>

<cfif URL.step is 6>
	<cfinclude template="control_masterUser.cfm">
</cfif>
</body></html>

