<cfloop Query="qry_selectExportTableFieldCompanyList">
	<cfparam Name="Form.exportTableFieldCompanyXmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#" Default="#qry_selectExportTableFieldCompanyList.exportTableFieldCompanyXmlName#">
	<cfparam Name="Form.exportTableFieldCompanyTabName#qry_selectExportTableFieldCompanyList.exportTableFieldID#" Default="#qry_selectExportTableFieldCompanyList.exportTableFieldCompanyTabName#">
	<cfparam Name="Form.exportTableFieldCompanyHtmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#" Default="#qry_selectExportTableFieldCompanyList.exportTableFieldCompanyHtmlName#">
</cfloop>