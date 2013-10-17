<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("newsletterID")>

<cfparam Name="URL.newsletterID" Default="0">
<cfparam Name="URL.contactID" Default="0">
<cfparam Name="URL.contactTemplateID" Default="0">
<cfparam Name="URL.contactTopicID" Default="0">

<cfset Variables.companyID = 0>
<cfset Variables.userID = 0>
<cfset Variables.invoiceID = 0>
<cfset Form.queryDisplayPerPage = 0>
<cfset Form.queryPage = 0>

<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectAdminUser">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplateList" ReturnVariable="qry_selectContactTemplateList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="contactTemplateStatus" Value="1">
	<cfinvokeargument Name="returnContactTemplateMessage" Value="False">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.Newsletter" method="maxlength_Newsletter" returnVariable="maxlength_Newsletter" />
<cfinclude template="formParam_insertUpdateNewsletter.cfm">
<cfinclude template="../../view/v_newsletter/lang_insertUpdateNewsletter.cfm">

<cfinvoke component="#Application.billingMapping#data.Contact" method="maxlength_Contact" returnVariable="maxlength_Contact" />
<cfinclude template="../c_contact/formParam_insertUpdateContact.cfm">

<!--- determine which subscribers to send newsletter to --->
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
		<cfinvoke Component="#Application.billingMapping#data.Newsletter" Method="insertNewsletter" ReturnVariable="newNewsletterID">
			<cfinvokeargument Name="contactID" Value="0">
			<cfif IsDefined("Form.submitContactSend")>
				<cfinvokeargument Name="newsletterRecipientCount" Value="#qryTotalRecords#">
			<cfelse>
				<cfinvokeargument Name="newsletterRecipientCount" Value="0">
			</cfif>
			<cfinvokeargument Name="newsletterDescription" Value="#Form.newsletterDescription#">
			<cfinvokeargument Name="newsletterCriteria" Value="#Variables.newsletterCriteria#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Contact" Method="insertContact" ReturnVariable="newContactID">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="companyID_target" Value="0">
			<cfinvokeargument Name="userID_target" Value="0">
			<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#newNewsletterID#">
			<cfinvokeargument Name="contactSubject" Value="#Form.contactSubject#">
			<cfinvokeargument Name="contactMessage" Value="#Form.contactMessage#">
			<cfinvokeargument Name="contactHtml" Value="#Form.contactHtml#">
			<cfinvokeargument Name="contactFax" Value="0">
			<cfinvokeargument Name="contactEmail" Value="1">
			<cfinvokeargument Name="contactByCustomer" Value="0">
			<cfinvokeargument Name="contactFromName" Value="#Form.contactFromName#">
			<cfinvokeargument Name="contactReplyTo" Value="#Form.contactReplyTo#">
			<cfinvokeargument Name="contactTo" Value="">
			<cfinvokeargument Name="contactCC" Value="">
			<cfinvokeargument Name="contactBCC" Value="">
			<cfinvokeargument Name="contactTopicID" Value="0">
			<cfinvokeargument Name="contactTemplateID" Value="#Form.contactTemplateID#">
			<cfinvokeargument Name="contactID_custom" Value="#Form.contactID_custom#">
			<cfinvokeargument Name="contactID_orig" Value="0">
			<cfinvokeargument Name="contactReplied" Value="1">
			<cfinvokeargument Name="contactStatus" Value="1">
			<cfif IsDefined("Form.submitContactSend")>
				<cfinvokeargument Name="contactDateSent" Value="#CreateODBCDateTime(Now())#">
			</cfif>
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Newsletter" Method="updateNewsletter" ReturnVariable="isNewsletterUpdated">
			<cfinvokeargument Name="newsletterID" Value="#newNewsletterID#">
			<cfinvokeargument Name="contactID" Value="#newContactID#">
		</cfinvoke>

		<cfif IsDefined("Form.submitContactSend")>
			<cfinclude template="email_newsletter.cfm">
			<cflocation url="index.cfm?method=#URL.control#.viewNewsletter&newsletterID=#newNewsletterID#&confirm_newsletter=sendNewsletter" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=#URL.control#.updateNewsletter&newsletterID=#newNewsletterID#&confirm_newsletter=saveNewsletter" AddToken="No">
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
			<cfinclude template="../c_contact/formParam_insertUpdateContact_template.cfm">
		</cfif>
	</cfif>
</cfif>

<cfset Variables.formName = "insertNewsletter">
<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction#">
<cfset Variables.formSubmitValue_send = Variables.lang_insertUpdateNewsletter.formSubmitValue_send>
<cfset Variables.formSubmitValue_save = Variables.lang_insertUpdateNewsletter.formSubmitValue_save>
<cfset Variables.formSubmitValue_reset = Variables.lang_insertUpdateNewsletter.formSubmitValue_reset>

<cfinclude template="../../view/v_newsletter/form_insertUpdateNewsletter.cfm">
