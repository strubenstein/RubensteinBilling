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
		<!--- determine order and whether to increment/decrement existing orders --->
		<cfif Form.contactTemplateOrder is 0>
			<cfset Variables.templateOrder = maxContactTemplateOrder + 1>
		<cfelse>
			<cfset Variables.templateOrder = Form.contactTemplateOrder>
			<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="updateContactTemplateOrder" ReturnVariable="isContactTemplateOrderUpdated">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="primaryTargetID" Value="#Form.primaryTargetID#">
				<cfinvokeargument Name="contactTemplateOrder" Value="#Variables.templateOrder#">
				<cfinvokeargument Name="contactTemplateOrder_direction" Value="down">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="insertContactTemplate" ReturnVariable="isContactTemplateInserted">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="languageID" Value="">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="primaryTargetID" Value="#Form.primaryTargetID#">
			<cfinvokeargument Name="contactTemplateOrder" Value="#Variables.templateOrder#">
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

		<cflocation url="index.cfm?method=contactTemplate.#Variables.doAction#&confirm_contactTemplate=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=contactTemplate.#Variables.doAction#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateContactTemplate.formSubmitValue_insert>
<cfinclude template="../../view/v_contactTemplate/form_insertUpdateContactTemplate.cfm">
