<cfinvoke Component="#Application.billingMapping#data.ExportTableFieldCompany" Method="selectExportTableFieldCompanyList" ReturnVariable="qry_selectExportTableFieldCompanyList">
	<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="exportTableFieldStatus" Value="1">
</cfinvoke>

<cfinclude template="formParam_updateExportTableFieldCompany.cfm">
<cfinvoke component="#Application.billingMapping#data.ExportTableFieldCompany" method="maxlength_ExportTableFieldCompany" returnVariable="maxlength_ExportTableFieldCompany" />

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitExportTableFieldCompany")>
	<cfinclude template="../../view/v_export/lang_updateExportTableFieldCompany.cfm">
	<cfinclude template="formValidate_updateExportTableFieldCompany.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- Insert/update/delete value as necessary --->
		<cfloop Query="qry_selectExportTableFieldCompanyList">
			<cfif Form["exportTableFieldCompanyXmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"] is ""
					and Form["exportTableFieldCompanyTabName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"] is ""
					and Form["exportTableFieldCompanyHtmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"] is "">
				<!--- no custom settings: delete if necessary --->
				<cfif qry_selectExportTableFieldCompanyList.exportTableFieldCompanyStatus is not "">
					<cfinvoke Component="#Application.billingMapping#data.ExportTableFieldCompany" Method="deleteExportTableFieldCompany" ReturnVariable="isExportTableFieldCompanyDeleted">
						<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
						<cfinvokeargument Name="exportTableFieldID" Value="#qry_selectExportTableFieldCompanyList.exportTableFieldID#">
					</cfinvoke>
				</cfif>
			<cfelse>
				<!--- insert custom settings --->
				<cfif qry_selectExportTableFieldCompanyList.exportTableFieldCompanyStatus is "">
					<cfset Variables.exportMethod = "insertExportTableFieldCompany">
				<cfelse><!--- update existing custom settings --->
					<cfset Variables.exportMethod = "updateExportTableFieldCompany">
				</cfif>

				<cfinvoke Component="#Application.billingMapping#data.ExportTableFieldCompany" Method="#Variables.exportMethod#" ReturnVariable="isExportTableFieldCompanyInserted">
					<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
					<cfinvokeargument Name="exportTableFieldID" Value="#qry_selectExportTableFieldCompanyList.exportTableFieldID#">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="exportTableFieldCompanyXmlName" Value="#Form["exportTableFieldCompanyXmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"]#">
					<cfinvokeargument Name="exportTableFieldCompanyTabName" Value="#Form["exportTableFieldCompanyTabName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"]#">
					<cfinvokeargument Name="exportTableFieldCompanyHtmlName" Value="#Form["exportTableFieldCompanyHtmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"]#">
					<cfinvokeargument Name="exportTableFieldCompanyStatus" Value="1">
				</cfinvoke>
			</cfif>
		</cfloop>

		<cflocation url="index.cfm?method=export.#Variables.doAction#&exportTableID=#URL.exportTableID#&confirm_export=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<!--- indicate which tables they have customized? --->
<cfset Variables.columnHeaderList = "Field Name^Primary<br>Key?^Type^Size^XML/Tab/Excel Data File<br>Field Name^Excel/Tab-Delimited<br>Display Header"><!--- ^HTML Header --->

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

<cfset Variables.formAction = "index.cfm?method=export.#Variables.doAction#&exportTableID=#URL.exportTableID#">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">
<cfinclude template="../../view/v_export/form_updateExportTableFieldCompany.cfm">