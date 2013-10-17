<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="selectContactTopicList" ReturnVariable="qry_selectContactTopicList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.ContactTopic" method="maxlength_ContactTopic" returnVariable="maxlength_ContactTopic" />
<cfinclude template="formParam_insertUpdateContactTopic.cfm">

<cfinclude template="../../view/v_contactTopic/lang_insertUpdateContactTopic.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitContactTopic")>
	<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
	<cfinclude template="formValidate_insertUpdateContactTopic.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse><!--- update existing topic --->
		<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="updateContactTopic" ReturnVariable="isContactTopicUpdated">
			<cfinvokeargument Name="contactTopicID" Value="#URL.contactTopicID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<!--- <cfinvokeargument Name="contactTopicOrder" Value="#Variables.topicOrder#"> --->
			<cfinvokeargument Name="contactTopicStatus" Value="#Form.contactTopicStatus#">
			<cfinvokeargument Name="contactTopicName" Value="#Form.contactTopicName#">
			<cfinvokeargument Name="contactTopicTitle" Value="#Form.contactTopicTitle#">
			<cfinvokeargument Name="contactTopicEmail" Value="#Form.contactTopicEmail#">
		</cfinvoke>

		<cflocation url="index.cfm?method=contactTopic.#Variables.doAction#&contactTopicID=#URL.contactTopicID#&confirm_contactTopic=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formSubmitValue = Variables.lang_insertUpdateContactTopic.formSubmitValue_update>
<cfset Variables.formAction = "index.cfm?method=contactTopic.#Variables.doAction#&contactTopicID=#URL.contactTopicID#">

<cfinclude template="../../view/v_contactTopic/form_insertUpdateContactTopic.cfm">