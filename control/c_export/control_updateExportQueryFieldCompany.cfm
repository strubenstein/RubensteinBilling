<cfinvoke Component="#Application.billingMapping#data.ExportQueryField" Method="selectExportQueryFieldList" ReturnVariable="qry_selectExportQueryFieldList">
	<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.ExportQueryFieldCompany" Method="selectExportQueryFieldCompanyList" ReturnVariable="qry_selectExportQueryFieldCompanyList">
	<cfinvokeargument Name="exportQueryID" Value="#URL.exportQueryID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfinclude template="formParam_updateExportQueryFieldCompany.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitExportQueryFieldCompany")>
	<cfinclude template="../../view/v_export/lang_updateExportQueryFieldCompany.cfm">
	<cfinclude template="formValidate_updateExportQueryFieldCompany.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- 
		For each field in query:
			If field is included for all export types:
				If all export types were not previously included, delete record
			Else if all export types were previously included, insert record
			Else update record
		--->

		<cfloop Query="qry_selectExportQueryFieldList">
			<!--- was field previously included for all export types? --->
			<cfset Variables.exportQFCrow = ListFind(ValueList(qry_selectExportQueryFieldCompanyList.exportQueryFieldID), qry_selectExportQueryFieldList.exportQueryFieldID)>

			<!--- field is included for all export types --->
			<cfif ListFind(Form.exportQueryFieldCompanyXmlStatus, qry_selectExportQueryFieldList.exportQueryFieldID)
					and ListFind(Form.exportQueryFieldCompanyTabStatus, qry_selectExportQueryFieldList.exportQueryFieldID)>
					<!--- and ListFind(Form.exportQueryFieldCompanyHtmlStatus, qry_selectExportQueryFieldList.exportQueryFieldID) --->
				<!--- if field not previously included in all export types --->
				<cfif Variables.exportQFCrow is not 0>
					<cfinvoke Component="#Application.billingMapping#data.ExportQueryFieldCompany" Method="deleteExportQueryFieldCompany" ReturnVariable="isExportQueryFieldCompanyDeleted">
						<cfinvokeargument Name="exportQueryFieldID" Value="#qry_selectExportQueryFieldList.exportQueryFieldID#">
						<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
					</cfinvoke>
				</cfif>
			<cfelse>
				<!--- all export types were previously included --->
				<cfif Variables.exportQFCrow is 0>
					<cfset Variables.exportMethod = "insertExportQueryFieldCompany">
				<cfelse>
					<cfset Variables.exportMethod = "updateExportQueryFieldCompany">
				</cfif>

				<cfinvoke Component="#Application.billingMapping#data.ExportQueryFieldCompany" Method="#Variables.exportMethod#" ReturnVariable="isExportQueryFieldCompanyInserted">
					<cfinvokeargument Name="exportQueryFieldID" Value="#qry_selectExportQueryFieldList.exportQueryFieldID#">
					<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
					<cfinvokeargument Name="exportQueryFieldCompanyXmlStatus" Value="#Iif(ListFind(Form.exportQueryFieldCompanyXmlStatus, qry_selectExportQueryFieldList.exportQueryFieldID), 1, 0)#">
					<cfinvokeargument Name="exportQueryFieldCompanyTabStatus" Value="#Iif(ListFind(Form.exportQueryFieldCompanyTabStatus, qry_selectExportQueryFieldList.exportQueryFieldID), 1, 0)#">
					<cfinvokeargument Name="exportQueryFieldCompanyHtmlStatus" Value="#Iif(ListFind(Form.exportQueryFieldCompanyHtmlStatus, qry_selectExportQueryFieldList.exportQueryFieldID), 1, 0)#">
					<cfinvokeargument Name="exportQueryFieldCompanyOrder" Value="0">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
				</cfinvoke>
			</cfif>
		</cfloop>

		<cflocation url="index.cfm?method=export.#Variables.doAction#&exportQueryID=#URL.exportQueryID#&confirm_export=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("moveExportQueryFieldCompanyUp,moveExportQueryFieldCompanyDown")>

<cfset Variables.columnHeaderList = "##^Table Name^Table<br>Field Name^&quot;Select As&quot;<br>Field Name^Type">
<!--- 
<cfif Variables.doAction is "updateExportQueryFieldCompany">
	<cfif ListFind(Variables.permissionActionList, "moveExportQueryFieldCompanyUp") and ListFind(Variables.permissionActionList, "moveExportQueryFieldCompanyDown")>
		<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Switch<br>Order">
	</cfif>
</cfif>
--->
<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Include in<br>Data File^Include in<br>Display File"><!--- ^Include in<br>Browser --->

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

<cfif Variables.doAction is "listExportQueryFieldCompany">
	<cfset Variables.formAction = "">
	<cfset Variables.formSubmitValue = "">
<cfelse><!--- updateExportQueryFieldCompany --->
	<cfset Variables.formAction = "index.cfm?method=export.#Variables.doAction#&exportQueryID=#URL.exportQueryID#">
	<cfset Variables.formSubmitValue = "Update Query Field Settings">
</cfif>

<cfinclude template="../../view/v_export/form_updateExportQueryFieldCompany.cfm">
