<cfloop Query="qry_selectStatusTargetList">
	<cfparam Name="Form.statusTargetExportXmlName#qry_selectStatusTargetList.primaryTargetID#" Default="#qry_selectStatusTargetList.statusTargetExportXmlName#">
	<cfparam Name="Form.statusTargetExportTabName#qry_selectStatusTargetList.primaryTargetID#" Default="#qry_selectStatusTargetList.statusTargetExportTabName#">
	<cfparam Name="Form.statusTargetExportHtmlName#qry_selectStatusTargetList.primaryTargetID#" Default="#qry_selectStatusTargetList.statusTargetExportHtmlName#">

	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.statusTargetExportXmlStatus#qry_selectStatusTargetList.primaryTargetID#" Default="#qry_selectStatusTargetList.statusTargetExportXmlStatus#">
		<cfparam Name="Form.statusTargetExportTabStatus#qry_selectStatusTargetList.primaryTargetID#" Default="#qry_selectStatusTargetList.statusTargetExportTabStatus#">
		<cfparam Name="Form.statusTargetExportHtmlStatus#qry_selectStatusTargetList.primaryTargetID#" Default="#qry_selectStatusTargetList.statusTargetExportHtmlStatus#">
	<cfelse>
		<cfparam Name="Form.statusTargetExportXmlStatus#qry_selectStatusTargetList.primaryTargetID#" Default="0">
		<cfparam Name="Form.statusTargetExportTabStatus#qry_selectStatusTargetList.primaryTargetID#" Default="0">
		<cfparam Name="Form.statusTargetExportHtmlStatus#qry_selectStatusTargetList.primaryTargetID#" Default="0">
	</cfif>
</cfloop>

