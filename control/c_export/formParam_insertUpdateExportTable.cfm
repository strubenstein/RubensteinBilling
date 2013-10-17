<cfif Variables.doAction is "updateExportTable" and IsDefined("qry_selectExportTable")>
	<cfparam Name="Form.primaryTargetID" Default="#qry_selectExportTable.primaryTargetID#">
	<cfparam Name="Form.exportTableName" Default="#qry_selectExportTable.exportTableName#">
	<cfparam Name="Form.exportTableDescription" Default="#qry_selectExportTable.exportTableDescription#">
	<cfparam Name="Form.exportTableOrder" Default="#qry_selectExportTable.exportTableOrder#">
	<cfparam Name="Form.exportTableStatus" Default="#qry_selectExportTable.exportTableStatus#">
</cfif>

<cfparam Name="Form.primaryTargetID" Default="0">
<cfparam Name="Form.exportTableName" Default="">
<cfparam Name="Form.exportTableDescription" Default="">
<cfparam Name="Form.exportTableOrder" Default="0">
<cfparam Name="Form.exportTableStatus" Default="1">

