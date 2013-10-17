<cfif Len(Form.companyName) gt maxlength_Company.companyName>
	<cfset errorMessage_fields.companyName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCompany.companyName, "<<MAXLENGTH>>", maxlength_Company.companyName, "ALL"), "<<LEN>>", Len(Form.companyName), "ALL")>
</cfif>

<!--- 
<cfif Form.companyDirectory is "">

<cfelseif REFindNoCase("[^A-Za-z0-9_]", Form.companyDirectory)>
	<cfset errorMessage_fields.userID = Variables.lang_insertUpdateCompany.companyDirectory_valid>
<cfelseif Len(Form.companyDirectory) gt maxlength_Company.companyDirectory>
	<cfset errorMessage_fields.companyDirectory = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCompany.companyDirectory_maxlength, "<<MAXLENGTH>>", maxlength_Company.companyDirectory, "ALL"), "<<LEN>>", Len(Form.companyDirectory), "ALL")>
<cfelseif DirectoryExists(Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & Form.companyDirectory)>
	<cfset errorMessage_fields.userID = Variables.lang_insertUpdateCompany.companyDirectory_unique>
</cfif>
--->

<cfif Trim(Form.username) is "">
	<cfset errorMessage_fields.username = Variables.lang_insertUpdateUser.username_blank>
<cfelseif Len(Form.username) gt maxlength_User.username>
	<cfset errorMessage_fields.username = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.username_maxlength, "<<MAXLENGTH>>", maxlength_User.username, "ALL"), "<<LEN>>", Len(Form.username), "ALL")>
</cfif>

<cfif Trim(Form.password) is "" and Variables.doAction is "insertUser">
	<cfset errorMessage_fields.password = Variables.lang_insertUpdateUser.password_blank>
<cfelseif Form.password is not Form.passwordVerify>
	<cfset errorMessage_fields.passwordVerify = Variables.lang_insertUpdateUser.password_verify>
<cfelseif Len(Form.password) gt maxlength_User.password_decrypted>
	<cfset errorMessage_fields.password = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.password_maxlength, "<<MAXLENGTH>>", maxlength_User.password_decrypted, "ALL"), "<<LEN>>", Len(Form.password), "ALL")>
</cfif>

<cfif Len(Form.firstName) gt maxlength_User.firstName>
	<cfset errorMessage_fields.firstName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.firstName, "<<MAXLENGTH>>", maxlength_User.firstName, "ALL"), "<<LEN>>", Len(Form.firstName), "ALL")>
</cfif>
<cfif Len(Form.lastName) gt maxlength_User.lastName>
	<cfset errorMessage_fields.lastName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.lastName, "<<MAXLENGTH>>", maxlength_User.lastName, "ALL"), "<<LEN>>", Len(Form.lastName), "ALL")>
</cfif>

<cfif Form.email is not "" and Not fn_IsValidEmail(Form.email)>
	<cfset errorMessage_fields.email = Variables.lang_insertUpdateUser.email_valid>
<cfelseif Len(Form.email) gt maxlength_User.email>
	<cfset errorMessage_fields.email = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateUser.email_maxlength, "<<MAXLENGTH>>", maxlength_User.email, "ALL"), "<<LEN>>", Len(Form.email), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_insertUpdateUser.errorTitle_insert>
	<cfset errorMessage_header = Variables.lang_insertUpdateUser.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateUser.errorFooter>
</cfif>
