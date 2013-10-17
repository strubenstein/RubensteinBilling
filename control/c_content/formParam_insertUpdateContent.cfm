<cfif Variables.doAction is "updateContent">
	<cfparam Name="Form.contentName" Default="#qry_selectContent.contentName#">
	<cfparam Name="Form.contentCode" Default="#qry_selectContent.contentCode#">
	<cfparam Name="Form.contentDescription" Default="#qry_selectContent.contentDescription#">
	<cfparam Name="Form.contentOrder" Default="#qry_selectContent.contentOrder#">
	<cfparam Name="Form.contentStatus" Default="#qry_selectContent.contentStatus#">
	<cfparam Name="Form.contentType" Default="#qry_selectContent.contentType#">
	<cfparam Name="Form.contentMaxlength" Default="#qry_selectContent.contentMaxlength#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.contentHtmlOk" Default="#qry_selectContent.contentHtmlOk#">
		<cfparam Name="Form.contentRequired" Default="#qry_selectContent.contentRequired#">
	</cfif>
	<cfparam Name="Form.contentCategoryID" Default="#qry_selectContent.contentCategoryID#">
	<cfparam Name="Form.contentFilename" Default="#qry_selectContent.contentFilename#">
</cfif>

<cfparam Name="Form.contentName" Default="">
<cfparam Name="Form.contentCode" Default="">
<cfparam Name="Form.contentDescription" Default="">
<cfparam Name="Form.contentOrder" Default="0">
<cfparam Name="Form.contentStatus" Default="1">
<cfparam Name="Form.contentType" Default="">
<cfparam Name="Form.contentTypeOther" Default="">
<cfparam Name="Form.contentMaxlength" Default="">
<cfparam Name="Form.contentHtmlOk" Default="0">
<cfparam Name="Form.contentRequired" Default="0">
<cfparam Name="Form.contentCategoryID" Default="#URL.contentCategoryID#">
<cfparam Name="Form.contentFilename" Default="">

<cfif Form.contentMaxlength is 0>
	<cfset Form.contentMaxlength = "">
</cfif>
