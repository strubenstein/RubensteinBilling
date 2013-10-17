<cfset errorMessage_fields = StructNew()>
<!--- 
companyID
languageID
--->

<cfif Form.username is not "">
	<cfif Trim(Form.username) is "">
		<cfset errorMessage_fields.username = Variables.lang_insertUpdateUser.username_blank>
	<cfelseif Len(Form.username) gt maxlength_User.username>
		<cfset errorMessage_fields.username = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.username_maxlength, "<<MAXLENGTH>>", maxlength_User.username, "ALL"), "<<LEN>>", Len(Form.username), "ALL")>
	<cfelseif Variables.doAction is "insertUser"><!--- ensure username is unique --->
		<cfinvoke Component="#Application.billingMapping#data.User" Method="checkUsernameIsUnique" ReturnVariable="isUniqueUsername">
			<cfinvokeargument Name="username" Value="#Form.username#">
			<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
				<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfelse><!--- webservice --->
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			</cfif>
		</cfinvoke>

		<cfif isUniqueUsername is False>
			<cfset errorMessage_fields.username = ReplaceNoCase(Variables.lang_insertUpdateUser.username_uniqueInsert, "<<USERNAME>>", Form.username, "ALL")>
			<cfset Form.username = "">
		</cfif>
	<cfelse><!--- ensure usermame is unique if changed --->
		<cfinvoke Component="#Application.billingMapping#data.User" Method="checkUsernameIsUnique" ReturnVariable="isUniqueUsername">
			<cfinvokeargument Name="username" Value="#Form.username#">
			<cfinvokeargument Name="userID" Value="#URL.userID#">
			<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
				<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfelse><!--- webservice --->
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			</cfif>
		</cfinvoke>

		<cfif isUniqueUsername is False>
			<cfset errorMessage_fields.username = ReplaceNoCase(Variables.lang_insertUpdateUser.username_uniqueUpdate, "<<USERNAME>>", Form.username, "ALL")>
			<cfset Form.username = qry_selectUser.username>
		</cfif>
	</cfif>
</cfif>

<cfif Form.password is not "">
	<cfif Trim(Form.password) is "" and Variables.doAction is "insertUser">
		<cfset errorMessage_fields.password = Variables.lang_insertUpdateUser.password_blank>
	<cfelseif Form.password is not Form.passwordVerify>
		<cfset errorMessage_fields.passwordVerify = Variables.lang_insertUpdateUser.password_verify>
	<cfelseif Len(Form.password) gt maxlength_User.password_decrypted>
		<cfset errorMessage_fields.password = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.password_maxlength, "<<MAXLENGTH>>", maxlength_User.password_decrypted, "ALL"), "<<LEN>>", Len(Form.password), "ALL")>
	</cfif>
</cfif>

<cfif Form.email is not "" and Not fn_IsValidEmail(Form.email)>
	<cfset errorMessage_fields.email = Variables.lang_insertUpdateUser.email_valid>
<cfelseif Len(Form.email) gt maxlength_User.email>
	<cfset errorMessage_fields.email = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.email_maxlength, "<<MAXLENGTH>>", maxlength_User.email, "ALL"), "<<LEN>>", Len(Form.email), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.userStatus)>
	<cfset errorMessage_fields.userStatus = Variables.lang_insertUpdateUser.userStatus>
</cfif>
<cfif Not ListFind("0,1", Form.userNewsletterStatus)>
	<cfset errorMessage_fields.userNewsletterStatus = Variables.lang_insertUpdateUser.userNewsletterStatus>
</cfif>
<cfif Not ListFind("0,1", Form.userNewsletterHtml)>
	<cfset errorMessage_fields.userNewsletterHtml = Variables.lang_insertUpdateUser.userNewsletterHtml>
</cfif>

<cfif Form.salutation_select is not "" and Form.salutation_text is not "">
	<cfset errorMessage_fields.salutation = Variables.lang_insertUpdateUser.salutation_select>
<cfelseif Form.salutation_select is not "">
	<cfif Len(Form.salutation_select) gt maxlength_User.salutation>
		<cfset errorMessage_fields.salutation = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.salutation_maxlengthSelect, "<<MAXLENGTH>>", maxlength_User.salutation, "ALL"), "<<LEN>>", Len(Form.salutation_select), "ALL")>
	<cfelse>
		<cfset Form.salutation = Form.salutation_select>
	</cfif>
<cfelseif Len(Form.salutation_text) gt maxlength_User.salutation>
	<cfset errorMessage_fields.salutation = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.salutation_maxlengthText, "<<MAXLENGTH>>", maxlength_User.salutation, "ALL"), "<<LEN>>", Len(Form.salutation_text), "ALL")>
<cfelse>
	<cfset Form.salutation = Form.salutation_text>
</cfif>

<cfif Len(Form.firstName) gt maxlength_User.firstName>
	<cfset errorMessage_fields.firstName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.firstName, "<<MAXLENGTH>>", maxlength_User.firstName, "ALL"), "<<LEN>>", Len(Form.firstName), "ALL")>
</cfif>
<cfif Len(Form.middleName) gt maxlength_User.middleName>
	<cfset errorMessage_fields.middleName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.middleName, "<<MAXLENGTH>>", maxlength_User.middleName, "ALL"), "<<LEN>>", Len(Form.middleName), "ALL")>
</cfif>
<cfif Len(Form.lastName) gt maxlength_User.lastName>
	<cfset errorMessage_fields.lastName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.lastName, "<<MAXLENGTH>>", maxlength_User.lastName, "ALL"), "<<LEN>>", Len(Form.lastName), "ALL")>
</cfif>

<cfif Form.suffix_select is not "" and Form.suffix_text is not "">
	<cfset errorMessage_fields.suffix = Variables.lang_insertUpdateUser.suffix_select>
<cfelseif Form.suffix_select is not "">
	<cfif Len(Form.suffix_select) gt maxlength_User.suffix>
		<cfset errorMessage_fields.suffix = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.suffix_maxlengthSelect, "<<MAXLENGTH>>", maxlength_User.suffix, "ALL"), "<<LEN>>", Len(Form.suffix_select), "ALL")>
	<cfelse>
		<cfset Form.suffix = Form.suffix_select>
	</cfif>
<cfelseif Len(Form.suffix_text) gt maxlength_User.suffix>
	<cfset errorMessage_fields.suffix = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.suffix_maxlengthText, "<<MAXLENGTH>>", maxlength_User.suffix, "ALL"), "<<LEN>>", Len(Form.suffix_text), "ALL")>
<cfelse>
	<cfset Form.suffix = Form.suffix_text>
</cfif>

<cfif Len(Form.jobTitle) gt maxlength_User.jobTitle>
	<cfset errorMessage_fields.jobTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.jobTitle, "<<MAXLENGTH>>", maxlength_User.jobTitle, "ALL"), "<<LEN>>", Len(Form.jobTitle), "ALL")>
</cfif>

<cfif Form.jobDepartment_select is not "" and Form.jobDepartment_text is not "">
	<cfset errorMessage_fields.jobDepartment = Variables.lang_insertUpdateUser.jobDepartment_select>
<cfelseif Form.jobDepartment_select is not "">
	<cfif Len(Form.jobDepartment_select) gt maxlength_User.jobDepartment>
		<cfset errorMessage_fields.jobDepartment = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.jobDepartment_maxlengthSelect, "<<MAXLENGTH>>", maxlength_User.jobDepartment, "ALL"), "<<LEN>>", Len(Form.jobDepartment_select), "ALL")>
	<cfelse>
		<cfset Form.jobDepartment = Form.jobDepartment_select>
	</cfif>
<cfelseif Len(Form.jobDepartment_text) gt maxlength_User.jobDepartment>
	<cfset errorMessage_fields.jobDepartment = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.jobDepartment_maxlengthText, "<<MAXLENGTH>>", maxlength_User.jobDepartment, "ALL"), "<<LEN>>", Len(Form.jobDepartment_text), "ALL")>
<cfelse>
	<cfset Form.jobDepartment = Form.jobDepartment_text>
</cfif>

<cfif Len(Form.jobDivision) gt maxlength_User.jobDivision>
	<cfset errorMessage_fields.jobDivision = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.jobDivision, "<<MAXLENGTH>>", maxlength_User.jobDivision, "ALL"), "<<LEN>>", Len(Form.jobDivision), "ALL")>
</cfif>

<!--- Validate custom fields and custom status if applicable (and not via web service) --->
<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
	<cfif isCustomFieldValueExist is True>
		<cfinvoke component="#objInsertCustomFieldValue#" method="formValidate_insertCustomFieldValue" returnVariable="errorMessageStruct_customField" />
		<cfif Not StructIsEmpty(errorMessageStruct_customField)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_customField)>
		</cfif>
	</cfif>

	<cfif isStatusExist is True>
		<cfinvoke component="#objInsertStatusHistory#" method="formValidate_insertStatusHistory" returnVariable="errorMessageStruct_status" />
		<cfif Not StructIsEmpty(errorMessageStruct_status)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_status)>
		</cfif>
	</cfif>
</cfif>

<cfif Form.userEmailVerified is not "" and Not ListFind("0,1", Form.userEmailVerified)>
	<cfset errorMessage_fields.userEmailVerified = Variables.lang_insertUpdateUser.userEmailVerified>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertUser">
		<cfset errorMessage_title = Variables.lang_insertUpdateUser.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateUser.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateUser.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateUser.errorFooter>
</cfif>
