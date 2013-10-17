<cfparam Name="URL.templateID" Default="0">

<cfinclude template="security_template.cfm">
<cfinclude template="../../view/v_template/nav_template.cfm">
<cfif IsDefined("URL.confirm_template")>
	<cfinclude template="../../view/v_template/confirm_template.cfm">
</cfif>
<cfif IsDefined("URL.error_template")>
	<cfinclude template="../../view/v_template/error_template.cfm">
</cfif>

<cfinclude template="../../view/v_template/var_templateTypeList.cfm">

<cfswitch expression="#Variables.doAction#">
<cfcase value="listTemplates">
	<cfinclude template="control_listTemplates.cfm">
</cfcase>

<cfcase value="insertTemplate">
	<cfinclude template="control_insertTemplate.cfm">
</cfcase>

<cfcase value="updateTemplate">
	<cfinclude template="control_updateTemplate.cfm">
</cfcase>

<cfcase value="viewTemplateSample">
	<cfinclude template="control_viewTemplateSample.cfm">
</cfcase>

<cfcase value="updateTemplateDefault">
	<cfinclude template="control_updateTemplateDefault.cfm">
</cfcase>

<cfcase value="copyTemplate">
	<cfinclude template="control_copyTemplate.cfm">
</cfcase>

<cfcase value="customizeTemplate">
	<cfif FileExists(GetDirectoryFromPath(GetCurrentTemplatePath()) & Application.billingFilePathSlash & "act_customizeTemplate_" & qry_selectTemplate.templateFilename)>
		<cfinclude template="act_customizeTemplate_#qry_selectTemplate.templateFilename#">
	<cfelse>
		<cfset URL.error_template = Variables.doAction>
		<cfinclude template="../../view/v_template/error_template.cfm">
	</cfif>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_template = "invalidAction">
	<cfinclude template="../../view/v_template/error_template.cfm">
</cfdefaultcase>
</cfswitch>