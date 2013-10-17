<cfif Variables.doAction is "updateContentCategory">
	<cfparam Name="Form.contentCategoryName" Default="#qry_selectContentCategory.contentCategoryName#">
	<cfparam Name="Form.contentCategoryCode" Default="#qry_selectContentCategory.contentCategoryCode#">
	<cfparam Name="Form.contentCategoryDescription" Default="#qry_selectContentCategory.contentCategoryDescription#">
	<cfparam Name="Form.contentCategoryOrder" Default="#qry_selectContentCategory.contentCategoryOrder#">
	<cfparam Name="Form.contentCategoryStatus" Default="#qry_selectContentCategory.contentCategoryStatus#">
</cfif>

<cfparam Name="Form.contentCategoryName" Default="">
<cfparam Name="Form.contentCategoryCode" Default="">
<cfparam Name="Form.contentCategoryDescription" Default="">
<cfparam Name="Form.contentCategoryOrder" Default="0">
<cfparam Name="Form.contentCategoryStatus" Default="1">

