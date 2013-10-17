<cfset Variables.isMessageSent = False>
<!--- ID of internal topic used to identify "contactus" submissions --->
<cfset Variables.primaryTargetID = 0>
<cfset Variables.targetID = 0>

<!--- state options --->
<cfset Variables.selectStateOption = 123>
<cfinclude template="../../../view/v_address/var_stateList.cfm">
<cfinclude template="../../../view/v_address/act_stateList.cfm">

<cfinvoke component="#Application.billingMapping#data.User" method="maxlength_User" returnVariable="maxlength_User" />

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitApp")>
	<!--- default required fields, contactTopicID and contactTemplateID based on form submitted --->
	<cfset Variables.contactTopicID = 4>
	<cfset Variables.contactTemplateID = 4>
	<cfset Variables.contactSubject = "">
	<cfparam Name="Form.companyName" Default="">
	<cfset Variables.formTextList = "First Name,Last Name,Email,Address,City,State,Zip">
	<cfset Variables.formFieldList = "firstName,lastName,email,address,city,state,zipCode">

	<cfset Variables.contactMessage = "">
	<cfloop Index="count" From="1" To="#ListLen(Variables.formFieldList)#">
		<cfset Variables.contactMessage = Variables.contactMessage & "<br>" & ListGetAt(Variables.formTextList, count) & ": ">
		<cfparam Name="Form.#ListGetAt(Variables.formFieldList, count)#" Default="">
		<cfset Variables.contactMessage = Variables.contactMessage & Form[ListGetAt(Variables.formFieldList, count)]>
	</cfloop>

	<cfif Session.userID is not 0><!--- existing user (if logged in or via matching email address) --->
		<cfinclude template="act_getLoggedInUser.cfm">
	<cfelse><!--- NOT logged in user --->
		<cfset Variables.insertPhone = False>
		<cfset Variables.insertAddress = False>
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
		<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<contactMessage>>", Variables.contactMessage, "ALL")>
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
		<cfinvokeargument Name="contactSubject" Value="#Variables.contactSubject#">
		<cfif Variables.theContactMessage is "">
			<cfinvokeargument Name="contactMessage" Value="#Variables.contactMessage#">
		<cfelse>
			<cfinvokeargument Name="contactMessage" Value="#Variables.theContactMessage#">
		</cfif>
		<cfinvokeargument Name="contactEmail" Value="1">
		<cfinvokeargument Name="contactByCustomer" Value="1">
		<cfinvokeargument Name="contactHtml" Value="1">
		<cfinvokeargument Name="contactFromName" Value="#Form.firstName# #Form.lastName#">
		<cfinvokeargument Name="contactReplyTo" Value="#Form.email#">
		<cfinvokeargument Name="contactID_custom" Value="#Variables.contactID_custom#">
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
		<cfinvokeargument Name="contactTo" Value="#qry_selectContactTopic.contactTopicEmail#">
		<cfinvokeargument Name="contactTemplateID" Value="#Variables.contactTemplateID#">
		<cfinvokeargument Name="contactDateSent" Value="#CreateODBCDateTime(Now())#">
	</cfinvoke>

	<!--- notify appropriate user --->
	<cfif qry_selectContactTopic.contactTopicEmail is not "">
		<cfinclude template="../../../include/function/fn_Email.cfm">
		<cfinclude template="email_contactNoticeToClient.cfm">
	</cfif>

	<!--- display confirmation message --->
	<cfset Variables.isMessageSent = True>
</cfif>

