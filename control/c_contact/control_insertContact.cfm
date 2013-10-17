<cfparam Name="URL.contactTemplateID" Default="0">

<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectAdminUser">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplateList" ReturnVariable="qry_selectContactTemplateList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="primaryTargetID" Value="0,#Variables.primaryTargetID#">
	<cfinvokeargument Name="contactTemplateStatus" Value="1">
	<cfinvokeargument Name="returnContactTemplateMessage" Value="False">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.Contact" method="maxlength_Contact" returnVariable="maxlength_Contact" />
<cfinclude template="formParam_insertUpdateContact.cfm">
<cfinclude template="act_getContactPartners.cfm">

<cfinclude template="../../view/v_contact/lang_insertUpdateContact.cfm">
<cfif IsDefined("Form.isFormSubmitted") and (IsDefined("Form.submitContactSend") or IsDefined("Form.submitContactSave"))>
	<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
	<cfinclude template="formValidate_insertUpdateContact.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Contact" Method="insertContact" ReturnVariable="newContactID">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfif Variables.doAction is "replyToContact" and URL.contactID is not 0>
				<cfinvokeargument Name="companyID_target" Value="#qry_selectContact.companyID_target#">
				<cfinvokeargument Name="userID_target" Value="#qry_selectContact.userID_target#">
				<cfinvokeargument Name="primaryTargetID" Value="#qry_selectContact.primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#qry_selectContact.targetID#">
			<cfelse>
				<cfinvokeargument Name="companyID_target" Value="#Variables.companyID#">
				<cfinvokeargument Name="userID_target" Value="#Variables.userID#">
				<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
			</cfif>
			<cfinvokeargument Name="contactSubject" Value="#Form.contactSubject#">
			<cfinvokeargument Name="contactMessage" Value="#Form.contactMessage#">
			<cfinvokeargument Name="contactHtml" Value="#Form.contactHtml#">
			<cfinvokeargument Name="contactFax" Value="#Form.contactFax#">
			<cfinvokeargument Name="contactEmail" Value="#Form.contactEmail#">
			<cfinvokeargument Name="contactByCustomer" Value="0">
			<cfinvokeargument Name="contactFromName" Value="#Form.contactFromName#">
			<cfinvokeargument Name="contactReplyTo" Value="#Form.contactReplyTo#">
			<cfinvokeargument Name="contactTo" Value="#Form.contactTo#">
			<cfinvokeargument Name="contactCC" Value="#Form.contactCC#">
			<cfinvokeargument Name="contactBCC" Value="#Form.contactBCC#">
			<cfinvokeargument Name="contactTopicID" Value="#Form.contactTopicID#">
			<cfinvokeargument Name="contactTemplateID" Value="#Form.contactTemplateID#">
			<cfinvokeargument Name="contactID_custom" Value="#Form.contactID_custom#">
			<cfinvokeargument Name="contactID_orig" Value="#Form.contactID_orig#">
			<cfinvokeargument Name="contactReplied" Value="#Form.contactReplied#">
			<cfinvokeargument Name="contactStatus" Value="#Form.contactStatus#">
			<cfif IsDefined("Form.submitContactSend")>
				<cfinvokeargument Name="contactDateSent" Value="#CreateODBCDateTime(Now())#">
			</cfif>
			<cfinvokeargument Name="primaryTargetID_partner" Value="#Variables.primaryTargetID_partner#">
			<cfinvokeargument Name="targetID_partner" Value="#Variables.targetID_partner#">
			<cfinvokeargument Name="userID_partner" Value="#Variables.userID_partner#">
		</cfinvoke>

		<cfif Variables.doAction is "replyToContact" and URL.contactID is not 0>
			<cfinvoke Component="#Application.billingMapping#data.Contact" Method="updateContact" ReturnVariable="isContactUpdated">
				<cfinvokeargument Name="contactID" Value="#URL.contactID#">
				<cfinvokeargument Name="contactReplied" Value="1">
				<cfif IsDefined("Form.contactStatus_orig")>
					<cfinvokeargument Name="contactStatus" Value="1">
				<cfelse>
					<cfinvokeargument Name="contactStatus" Value="0">
				</cfif>
			</cfinvoke>
		</cfif>

		<cfif IsDefined("Form.submitContactSend")>
			<cfinclude template="email_contact.cfm">
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="contactID">
			<cfinvokeargument name="targetID" value="#newContactID#">
		</cfinvoke>

		<cfif IsDefined("Form.submitContactSend")>
			<cflocation url="index.cfm?method=#URL.control#.listContacts#Variables.urlParameters#&confirm_contact=sendContact" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=#URL.control#.updateContact#Variables.urlParameters#&contactID=#newContactID#&confirm_contact=saveContact" AddToken="No">
		</cfif>
	</cfif>

<cfelseif URL.contactTemplateID is not 0>
	<cfif qry_selectContactTemplateList.RecordCount is 0 or Not ListFind(ValueList(qry_selectContactTemplateList.contactTemplateID), URL.contactTemplateID)>
		<cfset URL.contactTemplateID = 0>
		<cfset Form.contactTemplateID = 0>
	<cfelseif URL.contactTemplateID is not Form.contactTemplateID>
		<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplate" ReturnVariable="qry_selectContactTemplate">
			<cfinvokeargument Name="contactTemplateID" Value="#URL.contactTemplateID#">
		</cfinvoke>

		<cfif qry_selectContactTemplate.RecordCount is 0>
			<cfset URL.contactTemplateID = 0>
			<cfset Form.contactTemplateID = 0>
		<cfelse>
			<cfset Form.contactTemplateID = URL.contactTemplateID>
			<cfinclude template="formParam_insertUpdateContact_template.cfm">
		</cfif>
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction#" & Variables.urlParameters>
<cfif Variables.doAction is "replyToContact" and URL.contactID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&contactID=" & URL.contactID>
</cfif>

<cfset Variables.formSubmitValue_send = Variables.lang_insertUpdateContact_title.formSubmitValue_send>
<cfset Variables.formSubmitValue_save = Variables.lang_insertUpdateContact_title.formSubmitValue_save>
<cfset Variables.formSubmitValue_reset = Variables.lang_insertUpdateContact_title.formSubmitValue_reset>
<cfinclude template="../../view/v_contact/form_insertUpdateContact.cfm">

