<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("newsletterID")>

<cfset URL.contactID = qry_selectNewsletter.contactID>

<cfset Form.queryDisplayPerPage = 0>
<cfset Form.queryPage = 0>

<cfinvoke Component="#Application.billingMapping#data.Contact" Method="selectContact" ReturnVariable="qry_selectContact">
	<cfinvokeargument Name="contactID" Value="#qry_selectNewsletter.contactID#">
</cfinvoke>

<!--- cannot update if already sent; redirect to view --->
<cfif IsDate(qry_selectContact.contactDateSent)>
	<cflocation url="index.cfm?method=#URL.control#.viewNewsletter&newsletterID=#URL.newsletterID#&error_newsletter=updateNewsletter" AddToken="No">	
</cfif>

<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectAdminUser">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.Newsletter" method="maxlength_Newsletter" returnVariable="maxlength_Newsletter" />
<cfinclude template="formParam_insertUpdateNewsletter.cfm">
<cfinclude template="../../view/v_newsletter/lang_insertUpdateNewsletter.cfm">

<cfinvoke component="#Application.billingMapping#data.Contact" method="maxlength_Contact" returnVariable="maxlength_Contact" />
<cfinclude template="../c_contact/formParam_insertUpdateContact.cfm">

<!--- determine which subscribers to send newsletter to --->
<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfinclude template="formParam_newsletterCriteria.cfm">
</cfif>
<cfinclude template="control_listNewsletterSubscribers.cfm">

<cfif IsDefined("Form.isFormSubmitted") and (IsDefined("Form.submitContactSend") or IsDefined("Form.submitContactSave"))>
	<cfinclude template="formValidate_insertUpdateNewsletter.cfm">

	<cfset Form.contactTo = "info@agreedis.org">
	<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
	<cfinclude template="../../view/v_contact/lang_insertUpdateContact.cfm">
	<cfinclude template="../c_contact/formValidate_insertUpdateContact.cfm">
	<cfset Form.contactTo = "">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfset Variables.newsletterCriteria = Replace(Variables.queryViewAction, "index.cfm?method=#URL.method#&", "", "ONE")>

		<cfinvoke Component="#Application.billingMapping#data.Newsletter" Method="updateNewsletter" ReturnVariable="isNewsletterUpdated">
			<cfinvokeargument Name="newsletterID" Value="#URL.newsletterID#">
			<cfif IsDefined("Form.submitContactSend")>
				<cfinvokeargument Name="newsletterRecipientCount" Value="#qryTotalRecords#">
			</cfif>
			<cfinvokeargument Name="newsletterDescription" Value="#Form.newsletterDescription#">
			<cfinvokeargument Name="newsletterCriteria" Value="#Variables.newsletterCriteria#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Contact" Method="updateContact" ReturnVariable="isContactUpdated">
			<cfinvokeargument Name="contactID" Value="#URL.contactID#">
			<cfinvokeargument Name="contactSubject" Value="#Form.contactSubject#">
			<cfinvokeargument Name="contactMessage" Value="#Form.contactMessage#">
			<cfinvokeargument Name="contactHtml" Value="#Form.contactHtml#">
			<cfinvokeargument Name="contactFromName" Value="#Form.contactFromName#">
			<cfinvokeargument Name="contactReplyTo" Value="#Form.contactReplyTo#">
			<cfinvokeargument Name="contactID_custom" Value="#Form.contactID_custom#">
			<cfif IsDefined("Form.submitContactSend")>
				<cfinvokeargument Name="contactDateSent" Value="#CreateODBCDateTime(Now())#">
			</cfif>
		</cfinvoke>

		<cfif IsDefined("Form.submitContactSend")>
			<cfinclude template="email_newsletter.cfm">
			<cflocation url="index.cfm?method=#URL.control#.viewNewsletter&newsletterID=#URL.newsletterID#&confirm_newsletter=sendNewsletter" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=#URL.control#.updateNewsletter&newsletterID=#URL.newsletterID#&confirm_newsletter=saveNewsletter" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfset Variables.formName = "insertNewsletter">
<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction#&newsletterID=#URL.newsletterID#">
<cfset Variables.formSubmitValue_send = Variables.lang_insertUpdateNewsletter.formSubmitValue_send>
<cfset Variables.formSubmitValue_save = Variables.lang_insertUpdateNewsletter.formSubmitValue_save>
<cfset Variables.formSubmitValue_reset = Variables.lang_insertUpdateNewsletter.formSubmitValue_reset>

<cfinclude template="../../view/v_newsletter/form_insertUpdateNewsletter.cfm">

