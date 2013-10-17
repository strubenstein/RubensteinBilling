<cfinclude template="formParam_insertUpdateTemplate.cfm">
<cfinvoke component="#Application.billingMapping#data.Template" method="maxlength_Template" returnVariable="maxlength_Template" />
<cfinclude template="../../view/v_template/lang_insertUpdateTemplate.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitTemplate")>
	<cfinclude template="formValidate_insertUpdateTemplate.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Template" Method="insertTemplate" ReturnVariable="templateID">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="templateName" Value="#Form.templateName#">
			<cfinvokeargument Name="templateFilename" Value="#Form.templateFilename#">
			<cfinvokeargument Name="templateType" Value="#Form.templateType#">
			<cfinvokeargument Name="templateDescription" Value="#Form.templateDescription#">
			<cfinvokeargument Name="templateStatus" Value="#Form.templateStatus#">
		</cfinvoke>

		<cflocation url="index.cfm?method=template.listTemplates&confirm_template=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = Variables.doURL>
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateTemplate.formSubmitValue_insert>
<cfinclude template="../../view/v_template/form_insertUpdateTemplate.cfm">
