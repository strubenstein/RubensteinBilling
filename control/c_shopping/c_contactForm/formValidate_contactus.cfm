<cfset errorMessage_fields = StructNew()>

<cfif Session.userID is 0>
	<cfif Trim(Form.firstName) is "">
		<cfset errorMessage_fields.firstName = Variables.lang_contactus.firstName_blank>
	<cfelseif Len(Form.firstName) gt maxlength_User.firstName>
		<cfset errorMessage_fields.firstName = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.firstName_maxlength, "<<MAXLENGTH>>", maxlength_User.firstName, "ALL"), "<<LEN>>", Len(Form.firstName), "ALL")>
	</cfif>

	<cfif Trim(Form.lastName) is "">
		<cfset errorMessage_fields.lastName = Variables.lang_contactus.lastName_blank>
	<cfelseif Len(Form.lastName) gt maxlength_User.lastName>
		<cfset errorMessage_fields.lastName = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.lastName_maxlength, "<<MAXLENGTH>>", maxlength_User.lastName, "ALL"), "<<LEN>>", Len(Form.lastName), "ALL")>
	</cfif>

	<cfif Trim(Form.email) is "">
		<cfset errorMessage_fields.email = Variables.lang_contactus.email_blank>
	<cfelseif Not fn_IsValidEmail(Form.email)>
		<cfset errorMessage_fields.email = Variables.lang_contactus.email_valid>
	<cfelseif Len(Form.email) gt maxlength_User.email>
		<cfset errorMessage_fields.email = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.email_maxlength, "<<MAXLENGTH>>", maxlength_User.email, "ALL"), "<<LEN>>", Len(Form.email), "ALL")>
	</cfif>

	<cfif Len(Form.companyName) gt maxlength_Company.companyName>
		<cfset errorMessage_fields.companyName = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.companyName_maxlength, "<<MAXLENGTH>>", maxlength_Company.companyName, "ALL"), "<<LEN>>", Len(Form.companyName), "ALL")>
	<cfelseif Trim(Form.companyName) is "" and ListFind(Variables.requiredFields, "companyName")>
		<cfset errorMessage_fields.companyName = Variables.lang_contactus.companyName_blank>
	</cfif>

	<cfif Form.phoneAreaCode is "">
		<cfif Trim(Form.phoneAreaCode) is "" and ListFind(Variables.requiredFields, "phoneAreaCode")>
			<cfset errorMessage_fields.phoneAreaCode = Variables.lang_contactus.phoneAreaCode_blank>
		</cfif>
	<cfelseif Not Application.fn_IsIntegerPositive(Form.phoneAreaCode)>
		<cfset errorMessage_fields.phoneAreaCode = Variables.lang_contactus.phoneAreaCode_valid>
	<cfelseif Len(Form.phoneAreaCode) gt maxlength_Phone.phoneAreaCode>
		<cfset errorMessage_fields.phoneAreaCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.phoneAreaCode_maxlength, "<<MAXLENGTH>>", maxlength_Phone.phoneAreaCode, "ALL"), "<<LEN>>", Len(Form.phoneAreaCode), "ALL")>
	</cfif>

	<cfif Form.phoneNumber is "">
		<cfif Trim(Form.phoneNumber) is "" and ListFind(Variables.requiredFields, "phoneNumber")>
			<cfset errorMessage_fields.phoneNumber = Variables.lang_contactus.phoneNumber_blank>
		</cfif>
	<cfelse>
		<cfset Form.phoneNumber = REReplace(Form.phoneNumber, "[ -]", "", "ALL")>
		<cfif Not Application.fn_IsIntegerPositive(Form.phoneNumber)>
			<cfset errorMessage_fields.phoneNumber = Variables.lang_contactus.phoneNumber_valid>
		<cfelseif Len(Form.phoneNumber) gt maxlength_Phone.phoneNumber>
			<cfset errorMessage_fields.phoneNumber = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.phoneNumber_maxlength, "<<MAXLENGTH>>", maxlength_Phone.phoneNumber, "ALL"), "<<LEN>>", Len(Form.phoneNumber), "ALL")>
		</cfif>
	</cfif>

	<cfif Trim(Form.phoneExtension) is not "" and Not Application.fn_IsIntegerPositive(Form.phoneExtension)>
		<cfset errorMessage_fields.phoneExtension = Variables.lang_contactus.phoneExtension_valid>
	<cfelseif Len(Form.phoneExtension) gt maxlength_Phone.phoneExtension>
		<cfset errorMessage_fields.phoneExtension = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.phoneExtension_maxlength, "<<MAXLENGTH>>", maxlength_Phone.phoneExtension, "ALL"), "<<LEN>>", Len(Form.phoneExtension), "ALL")>
	</cfif>

	<cfif Len(Form.address) gt maxlength_Address.address>
		<cfset errorMessage_fields.address = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.address_maxlength, "<<MAXLENGTH>>", maxlength_Address.address, "ALL"), "<<LEN>>", Len(Form.address), "ALL")>
	<cfelseif Trim(Form.address) is "" and ListFind(Variables.requiredFields, "address")>
		<cfset errorMessage_fields.address = Variables.lang_contactus.address_blank>
	</cfif>

	<cfif Len(Form.city) gt maxlength_Address.city>
		<cfset errorMessage_fields.city = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.city_maxlength, "<<MAXLENGTH>>", maxlength_Address.city, "ALL"), "<<LEN>>", Len(Form.city), "ALL")>
	<cfelseif Trim(Form.city) is "" and ListFind(Variables.requiredFields, "city")>
		<cfset errorMessage_fields.city = Variables.lang_contactus.city_blank>
	</cfif>

	<cfif Len(Form.state) gt maxlength_Address.state>
		<cfset errorMessage_fields.state = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.state_maxlength, "<<MAXLENGTH>>", maxlength_Address.state, "ALL"), "<<LEN>>", Len(Form.state), "ALL")>
	<cfelseif Trim(Form.state) is not "" and Not ListFind(Variables.selectStateList_value, Form.state)>
		<cfset errorMessage_fields.state = Variables.lang_contactus.state_valid>
	<cfelseif Trim(Form.state) is "" and ListFind(Variables.requiredFields, "state")>
		<cfset errorMessage_fields.state = Variables.lang_contactus.state_blank>
	</cfif>

	<cfif Len(Form.zipCode) gt maxlength_Address.zipCode>
		<cfset errorMessage_fields.zipCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.zipCode_maxlength, "<<MAXLENGTH>>", maxlength_Address.zipCode, "ALL"), "<<LEN>>", Len(Form.zipCode), "ALL")>
	<cfelseif Trim(Form.zipCode) is "" and ListFind(Variables.requiredFields, "zipCode")>
		<cfset errorMessage_fields.zipCode = Variables.lang_contactus.zipCode_blank>
	</cfif>

	<cfif Len(Form.country) gt maxlength_Address.country>
		<cfset errorMessage_fields.country = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.country, "<<MAXLENGTH>>", maxlength_Address.country, "ALL"), "<<LEN>>", Len(Form.country), "ALL")>
	<cfelseif Trim(Form.country) is "" and ListFind(Variables.requiredFields, "country")>
		<cfset errorMessage_fields.country = Variables.lang_contactus.country_blank>
	</cfif>
</cfif>

<cfif Len(Form.contactSubject) gt maxlength_Contact.contactSubject>
	<cfset errorMessage_fields.contactSubject = ReplaceNoCase(ReplaceNoCase(Variables.lang_contactus.contactSubject_maxlength, "<<MAXLENGTH>>", maxlength_Contact.contactSubject, "ALL"), "<<LEN>>", Len(Form.contactSubject), "ALL")>
<cfelseif Trim(Form.contactSubject) is "" and ListFind(Variables.requiredFields, "contactSubject")>
	<cfset errorMessage_fields.contactSubject = Variables.lang_contactus.contactSubject_blank>
</cfif>

<cfif Trim(Form.contactMessage) is "" and ListFind(Variables.requiredFields, "contactMessage")>
	<cfset errorMessage_fields.contactMessage = Variables.lang_contactus.contactMessage_blank>
</cfif>

<cfif Form.contactTopicID is not 0 and Not ListFind(ValueList(qry_selectContactTopicList.contactTopicID), Form.contactTopicID)>
	<cfset errorMessage_fields.contactTopicID = Variables.lang_contactus.contactTopicID>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_contactus.errorTitle>
	<cfset errorMessage_header = Variables.lang_contactus.errorHeader>
	<cfset errorMessage_footer = Variables.lang_contactus.errorFooter>
</cfif>

