<cfset Variables.formAction = "index.cfm?method=#URL.method#">

<cfset Variables.importStepList = "upload,match,insert,download">
<cfparam Name="URL.importStep" Default="upload">

<cfinclude template="formParam_uploadImportFile.cfm">
<cfinclude template="../../view/v_import/lang_uploadImportFile.cfm">

<cfif URL.importStep is "upload">
	<cfset Variables.displayUploadForm = True>
	<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitImportUpload")>
		<cfinclude template="formValidate_uploadImportFile.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfinclude template="../../view/error_formValidation.cfm">
		<cfelse>
			<cfset Variables.displayUploadForm = False>
			<cfset Form.importFile = Variables.realFileName>
			<cfset URL.importStep = "match">
		</cfif>
	</cfif>

	<cfif Variables.displayUploadForm is True>
		<cfset Variables.formAction = Variables.formAction & "&importStep=" & URL.importStep>
		<cfset Variables.formSubmitValue = Variables.lang_uploadImportFile.formSubmitValue>
		<cfinclude template="../../view/v_import/form_uploadImportFile.cfm">
	</cfif>
<cfelse>
	<cfinclude template="formValidate_uploadImportFile.cfm">
</cfif>

<cfif URL.importStep is "match">
	<cfset Variables.displayMatchForm = True>

	<cfif isAllFormFieldsOk is False>
		<cfset Variables.displayMatchForm = False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID(Form.primaryTargetKey)>

		<!--- select list of custom fields --->
		<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="selectCustomFieldListForTarget" ReturnVariable="qry_selectCustomFieldListForTarget">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
			<cfinvokeargument Name="customFieldStatus" Value="1">
			<cfinvokeargument Name="customFieldTargetStatus" Value="1">
			<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		</cfinvoke>

		<cfinclude template="../../view/v_import/var_matchImportFields.cfm">
		<cfif qry_selectCustomFieldListForTarget.RecordCount is not 0>
			<cfset Variables.importFieldList_value = ListAppend(Variables.importFieldList_value, " ")>
			<cfset Variables.importFieldList_label = ListAppend(Variables.importFieldList_label, "-- CUSTOM FIELDS --")>

			<cfloop Query="qry_selectCustomFieldListForTarget">
				<cfif REFind("[A-Za-z]", Left(qry_selectCustomFieldListForTarget.customFieldName, 1)) and Not REFind("[^A-Za-z0-9_]", qry_selectCustomFieldListForTarget.customFieldName)>
					<cfset Variables.importFieldList_value = ListAppend(Variables.importFieldList_value, "customField_" & qry_selectCustomFieldListForTarget.customFieldName)>
					<cfset Variables.importFieldList_label = ListAppend(Variables.importFieldList_label, qry_selectCustomFieldListForTarget.customFieldTitle)>
				</cfif>
			</cfloop>
		</cfif>

		<cfinclude template="formParam_matchImportFields.cfm">
		<cfinclude template="../../view/v_import/lang_matchImportFields.cfm">

		<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitImportMatch")>
			<cfinclude template="formValidate_matchImportFields.cfm">

			<cfif isAllFormFieldsOk is False>
				<cfinclude template="../../view/error_formValidation.cfm">
			<cfelse>
				<cfset Variables.displayMatchForm = False>
				<cfset URL.importStep = "insert">
				<cfinclude template="act_importData_default.cfm">
				<cfinclude template="act_importData_loop.cfm">
				<cfinclude template="act_importData_file.cfm">

				<cfinclude template="../../view/v_import/dsp_importResult.cfm">
			</cfif>
		</cfif>

		<cfif Variables.displayMatchForm is True>
			<cfset Variables.formAction = Variables.formAction & "&importStep=" & URL.importStep>
			<cfset Variables.formSubmitValue = Variables.lang_matchImportFields.formSubmitValue>
			<cfinclude template="../../view/v_import/form_matchImportFields.cfm">
		</cfif>
	</cfif>
</cfif>
