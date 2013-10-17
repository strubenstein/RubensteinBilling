<cfif URL.templateID is not 0 and IsDefined("qry_selectTemplate")>
	<cfif Variables.doAction is not "copyTemplate">
		<cfparam Name="Form.templateName" Default="#qry_selectTemplate.templateName#">
	</cfif>
	<cfparam Name="Form.templateFilename" Default="#qry_selectTemplate.templateFilename#">
	<cfparam Name="Form.templateType" Default="#qry_selectTemplate.templateType#">
	<cfparam Name="Form.templateDescription" Default="#qry_selectTemplate.templateDescription#">
	<cfparam Name="Form.templateStatus" Default="#qry_selectTemplate.templateStatus#">
</cfif>

<cfparam Name="Form.templateName" Default="">
<cfparam Name="Form.templateFilename" Default=".cfm">
<cfparam Name="Form.templateType" Default="Product">
<cfparam Name="Form.templateDescription" Default="">
<cfparam Name="Form.templateStatus" Default="1">
