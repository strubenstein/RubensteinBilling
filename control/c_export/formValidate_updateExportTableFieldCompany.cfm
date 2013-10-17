<cfset errorMessage_fields = StructNew()>

<cfset Variables.companyXmlName = Form["exportTableFieldCompanyXmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"]>
<cfset Variables.companyTabName = Form["exportTableFieldCompanyTabName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"]>
<cfset Variables.companyHtmlName = Form["exportTableFieldCompanyHtmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"]>
<cfset Variables.fieldName = qry_selectExportTableFieldCompanyList.exportTableFieldName>

<!--- validate that xml field name is unique? --->
<cfif Variables.companyXmlName is not "">
	<cfif Len(Variables.companyXmlName) gt maxlength_ExportTableFieldCompany.exportTableFieldCompanyXmlName>
		<cfset errorMessage_fields["exportTableFieldCompanyXmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_updateExportTableFieldCompany.exportTableFieldCompanyXmlName_maxlength, "<<MAXLENGTH>>", maxlength_ExportTableFieldCompany.exportTableFieldCompanyXmlName, "ALL"), "<<LEN>>", Len(Variables.companyXmlName), "ALL"), "<<FIELD>>", Variables.fieldName, "ALL")>
	<cfelseif REFindNoCase("[^A-Za-z0-9_]", Variables.companyXmlName) or Not REFindNoCase("[A-Za-z]", Left(Variables.companyXmlName, 1))>
		<cfset errorMessage_fields["exportTableFieldCompanyXmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"] = ReplaceNoCase(Variables.lang_updateExportTableFieldCompany.exportTableFieldCompanyXmlName_valid, "<<FIELD>>", Variables.fieldName, "ALL")>
	</cfif>
</cfif>

<cfif Len(Variables.companyTabName) gt maxlength_ExportTableFieldCompany.exportTableFieldCompanyTabName>
	<cfset errorMessage_fields["exportTableFieldCompanyTabName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_updateExportTableFieldCompany.exportTableFieldCompanyTabName_maxlength, "<<MAXLENGTH>>", maxlength_ExportTableFieldCompany.exportTableFieldCompanyTabName, "ALL"), "<<LEN>>", Len(Variables.companyTabName), "ALL"), "<<FIELD>>", Variables.fieldName, "ALL")>
</cfif>

<cfif Len(Variables.companyHtmlName) gt maxlength_ExportTableFieldCompany.exportTableFieldCompanyHtmlName>
	<cfset errorMessage_fields["exportTableFieldCompanyHtmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_updateExportTableFieldCompany.exportTableFieldCompanyHtmlName_maxlength, "<<MAXLENGTH>>", maxlength_ExportTableFieldCompany.exportTableFieldCompanyHtmlName, "ALL"), "<<LEN>>", Len(Variables.companyHtmlName), "ALL"), "<<FIELD>>", Variables.fieldName, "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_updateExportTableFieldCompany.errorTitle>
	<cfset errorMessage_header = Variables.lang_updateExportTableFieldCompany.errorHeader>
	<cfset errorMessage_footer = Variables.lang_updateExportTableFieldCompany.errorFooter>
</cfif>

