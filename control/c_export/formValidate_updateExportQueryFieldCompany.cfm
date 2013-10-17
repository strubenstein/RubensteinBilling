<cfset errorMessage_fields = StructNew()>

<cfloop Index="exportType" List="exportQueryFieldCompanyXmlStatus,exportQueryFieldCompanyTabStatus,exportQueryFieldCompanyHtmlStatus">
	<cfset thisExportType = exportType>
	<cfloop Index="fieldID" List="#Form[exportType]#">
		<cfif Not ListFind(ValueList(qry_selectExportQueryFieldList.exportQueryFieldID), fieldID)>
			<cfset errorMessage_fields[thisExportType] = Variables.lang_updateExportQueryFieldCompany[thisExportType]>
			<cfbreak>
		</cfif>
	</cfloop>
</cfloop>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_updateExportQueryFieldCompany.errorTitle>
	<cfset errorMessage_header = Variables.lang_updateExportQueryFieldCompany.errorHeader>
	<cfset errorMessage_footer = Variables.lang_updateExportQueryFieldCompany.errorFooter>
</cfif>
