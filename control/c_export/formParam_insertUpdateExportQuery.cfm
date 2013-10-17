<cfif Variables.doAction is "updateExportQuery" and IsDefined("qry_selectExportQuery")>
	<cfparam Name="Form.exportQueryName" Default="#qry_selectExportQuery.exportQueryName#">
	<cfparam Name="Form.exportQueryTitle" Default="#qry_selectExportQuery.exportQueryTitle#">
	<cfparam Name="Form.exportQueryDescription" Default="#qry_selectExportQuery.exportQueryDescription#">
	<cfparam Name="Form.exportQueryOrder" Default="#qry_selectExportQuery.exportQueryOrder#">
	<cfparam Name="Form.exportQueryStatus" Default="#qry_selectExportQuery.exportQueryStatus#">
</cfif>

<cfparam Name="Form.exportQueryName" Default="">
<cfparam Name="Form.exportQueryTitle" Default="">
<cfparam Name="Form.exportQueryDescription" Default="">
<cfparam Name="Form.exportQueryOrder" Default="0">
<cfparam Name="Form.exportQueryStatus" Default="1">

