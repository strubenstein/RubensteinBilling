<cfinclude template="formParam_insertUpdateTemplate.cfm">
<cfinvoke component="#Application.billingMapping#data.Template" method="maxlength_Template" returnVariable="maxlength_Template" />
<cfinclude template="../../view/v_template/lang_insertUpdateTemplate.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitTemplate")>
	<cfinclude template="formValidate_insertUpdateTemplate.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Template" Method="updateTemplate" ReturnVariable="isTemplateUpdated">
			<cfinvokeargument Name="templateID" Value="#URL.templateID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="templateName" Value="#Form.templateName#">
			<cfinvokeargument Name="templateFilename" Value="#Form.templateFilename#">
			<cfinvokeargument Name="templateDescription" Value="#Form.templateDescription#">
			<cfinvokeargument Name="templateStatus" Value="#Form.templateStatus#">
		</cfinvoke>

		<cfif Form.templateFilename is not qry_selectTemplate.templateFilename>
			<cfinvoke Component="#Application.billingMapping#data.Template" Method="updateTemplateFilename" ReturnVariable="isTemplateFilenameUpdated">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="templateType" Value="#qry_selectTemplate.templateType#">
				<cfinvokeargument Name="templateFilename_old" Value="#qry_selectTemplate.templateFilename#">
				<cfinvokeargument Name="templateFilename_new" Value="#Form.templateFilename#">
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=template.updateTemplate&templateID=#URL.templateID#&confirm_template=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = Variables.doURL & "&templateID=" & URL.templateID>
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateTemplate.formSubmitValue_update>
<cfinclude template="../../view/v_template/form_insertUpdateTemplate.cfm">
