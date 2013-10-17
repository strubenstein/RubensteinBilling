<cfparam Name="Form.exportQueryFieldCompanyXmlStatus" Default="">
<cfparam Name="Form.exportQueryFieldCompanyTabStatus" Default="">
<cfparam Name="Form.exportQueryFieldCompanyHtmlStatus" Default="">

<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfloop Query="qry_selectExportQueryFieldCompanyList">
		<cfif qry_selectExportQueryFieldCompanyList.exportQueryFieldCompanyXmlStatus is 1>
			<cfset Form.exportQueryFieldCompanyXmlStatus = ListAppend(Form.exportQueryFieldCompanyXmlStatus, qry_selectExportQueryFieldCompanyList.exportQueryFieldID)>
		</cfif>
		<cfif qry_selectExportQueryFieldCompanyList.exportQueryFieldCompanyTabStatus is 1>
			<cfset Form.exportQueryFieldCompanyTabStatus = ListAppend(Form.exportQueryFieldCompanyTabStatus, qry_selectExportQueryFieldCompanyList.exportQueryFieldID)>
		</cfif>
		<cfif qry_selectExportQueryFieldCompanyList.exportQueryFieldCompanyHtmlStatus is 1>
			<cfset Form.exportQueryFieldCompanyHtmlStatus = ListAppend(Form.exportQueryFieldCompanyHtmlStatus, qry_selectExportQueryFieldCompanyList.exportQueryFieldID)>
		</cfif>
	</cfloop>

	<cfloop Query="qry_selectExportQueryFieldList">
		<cfif Not ListFind(ValueList(qry_selectExportQueryFieldCompanyList.exportQueryFieldID), qry_selectExportQueryFieldList.exportQueryFieldID)>
			<cfif qry_selectExportQueryFieldList.exportTableFieldXmlStatus is 1>
				<cfset Form.exportQueryFieldCompanyXmlStatus = ListAppend(Form.exportQueryFieldCompanyXmlStatus, qry_selectExportQueryFieldList.exportQueryFieldID)>
			</cfif>
			<cfif qry_selectExportQueryFieldList.exportTableFieldTabStatus is 1>
				<cfset Form.exportQueryFieldCompanyTabStatus = ListAppend(Form.exportQueryFieldCompanyTabStatus, qry_selectExportQueryFieldList.exportQueryFieldID)>
			</cfif>
			<cfif qry_selectExportQueryFieldList.exportTableFieldHtmlStatus is 1>
				<cfset Form.exportQueryFieldCompanyHtmlStatus = ListAppend(Form.exportQueryFieldCompanyHtmlStatus, qry_selectExportQueryFieldList.exportQueryFieldID)>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
