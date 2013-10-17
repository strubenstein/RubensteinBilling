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
	<cfelse>
		<!--- determine order and whether to increment/decrement existing orders --->
		<cfset Variables.incrementTopicOrder = False>
		<cfif qry_selectContactTopicList.RecordCount is 0>
			<cfset Variables.topicOrder = 1>
		<cfelseif Form.contactTopicOrder is 0>
			<cfset Variables.topicOrder = qry_selectContactTopicList.RecordCount + 1>
		<cfelse>
			<cfset Variables.topicOrder = Form.contactTopicOrder>
			<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="updateContactTopicOrder" ReturnVariable="isContactTopicOrderUpdated">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="contactTopicOrder" Value="#Variables.topicOrder#">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="insertContactTopic" ReturnVariable="isContactTopicInserted">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="languageID" Value="">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="contactTopicOrder" Value="#Variables.topicOrder#">
			<cfinvokeargument Name="contactTopicStatus" Value="#Form.contactTopicStatus#">
			<cfinvokeargument Name="contactTopicName" Value="#Form.contactTopicName#">
			<cfinvokeargument Name="contactTopicTitle" Value="#Form.contactTopicTitle#">
			<cfinvokeargument Name="contactTopicEmail" Value="#Form.contactTopicEmail#">
		</cfinvoke>

		<cflocation url="index.cfm?method=contactTopic.#Variables.doAction#&confirm_contactTopic=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=contactTopic.#Variables.doAction#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateContactTopic.formSubmitValue_insert>

<cfinclude template="../../view/v_contactTopic/form_insertUpdateContactTopic.cfm">
