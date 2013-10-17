<cfparam Name="URL.primaryTargetID" Default="0">
<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplateList" ReturnVariable="qry_selectContactTemplateList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="returnContactTemplateMessage" Value="False">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.ContactTemplate" method="maxlength_ContactTemplate" returnVariable="maxlength_ContactTemplate" />
<cfinclude template="formParam_insertUpdateContactTemplate.cfm">

<cfinclude template="../../view/v_contactTemplate/lang_insertUpdateContactTemplate.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitContactTemplate")>
	<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
	<cfinclude template="formValidate_insertUpdateContactTemplate.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif Form.primaryTargetID is qry_selectContactTemplate.primaryTargetID>
			<cfset Variables.templateOrder = 0>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectMaxContactTemplateOrder" ReturnVariable="maxContactTemplateOrder">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="primaryTargetID" Value="#Form.primaryTargetID#">
			</cfinvoke>

			<cfset Variables.templateOrder = maxContactTemplateOrder + 1>
			<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="updateContactTemplateOrder" ReturnVariable="isContactTemplateOrderUpdated">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="contactTemplateID" Value="#URL.contactTemplateID#">
				<cfinvokeargument Name="primaryTargetID" Value="#qry_selectContactTemplate.primaryTargetID#">
				<cfinvokeargument Name="contactTemplateOrder" Value="#qry_selectContactTemplate.contactTemplateOrder#">
				<cfinvokeargument Name="contactTemplateOrder_direction" Value="up">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="updateContactTemplate" ReturnVariable="isContactTemplateUpdated">
			<cfinvokeargument Name="contactTemplateID" Value="#URL.contactTemplateID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="primaryTargetID" Value="#Form.primaryTargetID#">
			<cfif Variables.templateOrder is not 0>
				<cfinvokeargument Name="contactTemplateOrder" Value="#Variables.templateOrder#">
			</cfif>
			<cfinvokeargument Name="contactTemplateStatus" Value="#Form.contactTemplateStatus#">
			<cfinvokeargument Name="contactTemplateName" Value="#Form.contactTemplateName#">
			<cfinvokeargument Name="contactTemplateHtml" Value="#Form.contactTemplateHtml#">
			<cfinvokeargument Name="contactTemplateFromName" Value="#Form.contactTemplateFromName#">
			<cfinvokeargument Name="contactTemplateReplyTo" Value="#Form.contactTemplateReplyTo#">
			<cfinvokeargument Name="contactTemplateCC" Value="#Form.contactTemplateCC#">
			<cfinvokeargument Name="contactTemplateBCC" Value="#Form.contactTemplateBCC#">
			<cfinvokeargument Name="contactTemplateSubject" Value="#Form.contactTemplateSubject#">
			<cfinvokeargument Name="contactTemplateMessage" Value="#Form.contactTemplateMessage#">
		</cfinvoke>

		<cflocation url="index.cfm?method=contactTemplate.#Variables.doAction#&contactTemplateID=#URL.contactTemplateID#&confirm_contactTemplate=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formSubmitValue = Variables.lang_insertUpdateContactTemplate.formSubmitValue_update>
<cfset Variables.formAction = "index.cfm?method=contactTemplate.#Variables.doAction#&contactTemplateID=#URL.contactTemplateID#">
<cfinclude template="../../view/v_contactTemplate/form_insertUpdateContactTemplate.cfm">
