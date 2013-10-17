<cfinclude template="formParam_insertUpdateTemplate.cfm">
<cfinvoke component="#Application.billingMapping#data.Template" method="maxlength_Template" returnVariable="maxlength_Template" />
<cfinclude template="../../view/v_template/lang_insertUpdateTemplate.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitTemplate")>
	<cfinclude template="formValidate_insertUpdateTemplate.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Template" Method="insertTemplate" ReturnVariable="newTemplateID">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="templateName" Value="#Form.templateName#">
			<cfinvokeargument Name="templateFilename" Value="#qry_selectTemplate.templateFilename#">
			<cfinvokeargument Name="templateType" Value="#qry_selectTemplate.templateType#">
			<cfinvokeargument Name="templateDescription" Value="#Form.templateDescription#">
			<cfinvokeargument Name="templateStatus" Value="#Form.templateStatus#">
			<cfinvokeargument Name="templateXml" Value="#qry_selectTemplate.templateXml#">
		</cfinvoke>

		<cflocation url="index.cfm?method=template.customizeTemplate&templateID=#newTemplateID#&confirm_template=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = Variables.doURL & "&templateID=" & URL.templateID>
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateTemplate.formSubmitValue_copy>
<cfinclude template="../../view/v_template/form_insertUpdateTemplate.cfm">

