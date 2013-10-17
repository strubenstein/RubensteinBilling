<cfset Variables.isMessageSent = False>
<cfset Variables.isProductCallForQuote = False>

<!--- ID of internal topic used to identify "contactus" submissions --->
<cfset Variables.primaryTargetID = 0>
<cfset Variables.targetID = 0>

<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="selectContactTopicList" ReturnVariable="qry_selectContactTopicList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="contactTemplateStatus" Value="1">
</cfinvoke>

<!--- default required fields, contactTopicID and contactTemplateID based on form submitted --->
<cfset Variables.contactTopicID = 0>
<cfset Variables.contactTemplateID = 0>
<cfset Variables.customFieldTarget_list = "">
<cfset Variables.customFieldName_list = "">
<cfset Variables.requiredFields = "firstName,lastName,email">

<!--- determine required fields, contactTopicID and contactTemplateID based on form submitted --->
<!--- <cfinclude template="act_determineContactIDs.cfm"> --->

<cfinclude template="formParam_contactus.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitContact")>
	<!--- match email address? --->
	<cfinclude template="../../../include/function/fn_IsValidEmail.cfm">
	<cfinclude template="../../../view/v_shopping/v_contactForm/lang_contactus.cfm">

	<cfinvoke component="#Application.billingMapping#data.User" method="maxlength_User" returnVariable="maxlength_User" />
	<cfinvoke component="#Application.billingMapping#data.Company" method="maxlength_Company" returnVariable="maxlength_Company" />
	<cfinvoke component="#Application.billingMapping#data.Address" method="maxlength_Address" returnVariable="maxlength_Address" />
	<cfinvoke component="#Application.billingMapping#data.Phone" method="maxlength_Phone" returnVariable="maxlength_Phone" />
	<cfinvoke component="#Application.billingMapping#data.Contact" method="maxlength_Contact" returnVariable="maxlength_Contact" />
	<cfinclude template="formValidate_contactus.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<!--- If topic is hard-coded for a form, use it. Otherwise, let customer choose. --->
		<cfset Variables.contactTopicID = Form.contactTopicID>

		<cfif Session.userID is not 0><!--- existing user (if logged in or via matching email address) --->
			<cfinclude template="act_getLoggedInUser.cfm">
		<cfelse><!--- NOT logged in user --->
			<cfset Variables.insertPhone = True>
			<cfset Variables.insertAddress = True>
			<cfinclude template="act_insertNewUser.cfm">
		</cfif>

		<!--- determine who to notify for this contactTopicID --->
		<cfif Variables.contactTopicID is not 0>
			<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="selectContactTopic" ReturnVariable="qry_selectContactTopic">
				<cfinvokeargument Name="contactTopicID" Value="#Variables.contactTopicID#">
			</cfinvoke>
		</cfif>

		<!--- determine next order in contact management --->
		<cfinvoke Component="#Application.billingMapping#data.Contact" Method="generateContactTicket" ReturnVariable="Variables.contactID_custom">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="contactDateSent" Value="#Now()#">
		</cfinvoke>

		<!--- request template for this contactTemplateID --->
		<cfset Variables.theContactSubject = "">
		<cfset Variables.theContactMessage = "">

		<cfif Variables.contactTemplateID is not 0>
			<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplate" ReturnVariable="qry_selectContactTemplate">
				<cfinvokeargument Name="contactTemplateID" Value="#Variables.contactTemplateID#">
			</cfinvoke>

			<!--- populate fields in email --->
			<cfset Variables.theContactSubject = qry_selectContactTemplate.contactTemplateSubject>
			<cfset Variables.theContactSubject = ReplaceNoCase(Variables.theContactSubject, "<<contactID_custom>>", Variables.contactID_custom, "ALL")>

			<cfset Variables.theContactMessage = qry_selectContactTemplate.contactTemplateMessage>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<contactID_custom>>", Variables.contactID_custom, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<firstName>>", Form.firstName, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<lastName>>", Form.lastName, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<email>>", Form.email, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<companyName>>", Form.companyName, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<phoneAreaCode>>", Form.phoneAreaCode, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<phoneNumber>>", Form.phoneNumber, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<phoneExtension>>", Form.phoneExtension, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<address>>", Form.address, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<city>>", Form.city, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<state>>", Form.state, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<zipCode>>", Form.zipCode, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<country>>", Form.country, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<contactSubject>>", Form.contactSubject, "ALL")>
			<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<contactMessage>>", Form.contactMessage, "ALL")>

			<!--- if call for quote, populate product fields --->
			<cfif Variables.isProductCallForQuote is True>
				<cfinclude template="act_populateProductCallForQuote.cfm">
			</cfif>
		</cfif>

		<!--- if custom fields exist, insert custom fields and populate fields --->
		<cfif Variables.customFieldName_list is not ""><!--- custom fields --->
			<cfinclude template="act_populateCustomFields.cfm">
		</cfif>

		<!--- insert contact --->
		<cfinvoke Component="#Application.billingMapping#data.Contact" Method="insertContact" ReturnVariable="contactID">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="contactStatus" Value="0">
			<cfinvokeargument Name="userID_author" Value="0">
			<cfinvokeargument Name="companyID_target" Value="#Variables.companyID#">
			<cfinvokeargument Name="userID_target" Value="#Variables.userID#">
			<cfinvokeargument Name="contactID_custom" Value="#Variables.contactID_custom#">
			<cfinvokeargument Name="contactTopicID" Value="#Variables.contactTopicID#">
			<cfinvokeargument Name="contactSubmittedByUser" Value="1">
			<cfinvokeargument Name="contactSubject" Value="#Form.contactSubject#">
			<cfif Variables.theContactMessage is "">
				<cfinvokeargument Name="contactMessage" Value="#Form.contactMessage#">
			<cfelse>
				<cfinvokeargument Name="contactMessage" Value="#Variables.theContactMessage#">
			</cfif>
			<cfinvokeargument Name="contactEmail" Value="1">
			<cfinvokeargument Name="contactByCustomer" Value="1">
			<cfinvokeargument Name="contactFromName" Value="#Form.firstName# #Form.lastName#">
			<cfinvokeargument Name="contactReplyTo" Value="#Form.email#">
			<cfinvokeargument Name="contactID_custom" Value="#Variables.contactID_custom#">
			<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
			<cfif Variables.contactTemplateID is not 0>
				<cfinvokeargument Name="contactTo" Value="#qry_selectContactTopic.contactTopicEmail#">
			</cfif>
			<cfinvokeargument Name="contactTemplateID" Value="#Variables.contactTemplateID#">
			<cfinvokeargument Name="contactDateSent" Value="#CreateODBCDateTime(Now())#">
		</cfinvoke>

		<!--- notify appropriate user --->
		<cfif Variables.contactTopicID is not 0 and qry_selectContactTopic.contactTopicEmail is not "">
			<cfinclude template="../../../include/function/fn_Email.cfm">
			<cfif Variables.contactTemplateID is 0>
				<cfinclude template="email_contactNoticeToClient_default.cfm">
			<cfelse>
				<cfinclude template="email_contactNoticeToClient.cfm">
			</cfif>
		</cfif>

		<!--- display confirmation message --->
		<cfset Variables.isMessageSent = True>
	</cfif>
</cfif>
