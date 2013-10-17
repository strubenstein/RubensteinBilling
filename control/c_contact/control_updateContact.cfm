<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectAdminUser">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
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
		<cfinvoke Component="#Application.billingMapping#data.Contact" Method="updateContact" ReturnVariable="isContactUpdated">
			<cfinvokeargument Name="contactID" Value="#URL.contactID#">
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
			<cfinvokeargument name="targetID" value="#URL.contactID#">
		</cfinvoke>

		<cfif IsDefined("Form.submitContactSend")>
			<cflocation url="index.cfm?method=#URL.control#.listContacts#Variables.urlParameters#&confirm_contact=sendContact" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=#URL.control#.updateContact#Variables.urlParameters#&contactID=#URL.contactID#&confirm_contact=saveContact" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction#" & Variables.urlParameters & "&contactID=" & URL.contactID>
<cfset Variables.formSubmitValue_send = Variables.lang_insertUpdateContact_title.formSubmitValue_send>
<cfset Variables.formSubmitValue_save = Variables.lang_insertUpdateContact_title.formSubmitValue_save>
<cfset Variables.formSubmitValue_reset = Variables.lang_insertUpdateContact_title.formSubmitValue_reset>
<cfinclude template="../../view/v_contact/form_insertUpdateContact.cfm">

