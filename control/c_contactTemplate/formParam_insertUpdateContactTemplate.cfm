<cfif Variables.doAction is "updateContactTemplate" and IsDefined("qry_selectContactTemplate")>
	<cfparam Name="Form.primaryTargetID" Default="#qry_selectContactTemplate.primaryTargetID#">
	<cfparam Name="Form.contactTemplateName" Default="#qry_selectContactTemplate.contactTemplateName#">
	<cfparam Name="Form.contactTemplateHtml" Default="#qry_selectContactTemplate.contactTemplateHtml#">
	<cfparam Name="Form.contactTemplateFromName" Default="#qry_selectContactTemplate.contactTemplateFromName#">
	<cfparam Name="Form.contactTemplateReplyTo" Default="#qry_selectContactTemplate.contactTemplateReplyTo#">
	<cfparam Name="Form.contactTemplateCC" Default="#qry_selectContactTemplate.contactTemplateCC#">
	<cfparam Name="Form.contactTemplateBCC" Default="#qry_selectContactTemplate.contactTemplateBCC#">
	<cfparam Name="Form.contactTemplateSubject" Default="#qry_selectContactTemplate.contactTemplateSubject#">
	<cfparam Name="Form.contactTemplateMessage" Default="#qry_selectContactTemplate.contactTemplateMessage#">
	<cfparam Name="Form.contactTemplateOrder" Default="#qry_selectContactTemplate.contactTemplateOrder#">
	<cfparam Name="Form.contactTemplateStatus" Default="#qry_selectContactTemplate.contactTemplateStatus#">
</cfif>

<cfparam Name="Form.primaryTargetID" Default="#URL.primaryTargetID#">
<cfparam Name="Form.contactTemplateName" Default="">
<cfparam Name="Form.contactTemplateHtml" Default="0">
<cfparam Name="Form.contactTemplateFromName" Default="">
<cfparam Name="Form.contactTemplateReplyTo" Default="">
<cfparam Name="Form.contactTemplateBCC" Default="">
<cfparam Name="Form.contactTemplateCC" Default="">
<cfparam Name="Form.contactTemplateSubject" Default="">
<cfparam Name="Form.contactTemplateMessage" Default="">
<cfparam Name="Form.contactTemplateOrder" Default="0">
<cfparam Name="Form.contactTemplateStatus" Default="1">

