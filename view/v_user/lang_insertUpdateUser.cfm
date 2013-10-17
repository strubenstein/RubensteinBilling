<cfset Variables.lang_insertUpdateUser = StructNew()>

<cfset Variables.lang_insertUpdateUser.formSubmitValue_insert = "Create User">
<cfset Variables.lang_insertUpdateUser.formSubmitValue_update = "Update User">

<cfset Variables.lang_insertUpdateUser.username_blank = "The username may not be blank.">
<cfset Variables.lang_insertUpdateUser.username_maxlength = "The username may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.username_uniqueInsert = "The username <i><<USERNAME>></i> is already being used by another user.<br>Please select a different username.">
<cfset Variables.lang_insertUpdateUser.username_uniqueUpdate = "The username <i><<USERNAME>></i> is already being used by another user.<br>Please select a different username or keep the existing username.">
<cfset Variables.lang_insertUpdateUser.password_blank = "The password cannot be blank.">
<cfset Variables.lang_insertUpdateUser.password_verify = "The password was not verified correctly.">
<cfset Variables.lang_insertUpdateUser.password_maxlength = "The password may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.email_valid = "You did not enter a valid email address.">
<cfset Variables.lang_insertUpdateUser.email_maxlength = "The email address may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.userStatus = "You did not enter a valid option for the user status.">
<cfset Variables.lang_insertUpdateUser.userNewsletterStatus = "You did not enter a valid option for whether this user wants to subscribe to the newsletter.">
<cfset Variables.lang_insertUpdateUser.userNewsletterHtml = "You did not select a valid option for whether you would like to receive the newsletter in text or html format.">
<cfset Variables.lang_insertUpdateUser.salutation_select = "You cannot both select a salutation and enter a salutation.">
<cfset Variables.lang_insertUpdateUser.salutation_maxlengthSelect = "The salutation may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.salutation_maxlengthText = "The salutation may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.firstName = "The first name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.middleName = "The middle name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.lastName = "The last name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.suffix_select = "You cannot both select a suffix and enter a suffix.">
<cfset Variables.lang_insertUpdateUser.suffix_maxlengthSelect = "The suffix may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.suffix_maxlengthText = "The suffix may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.jobTitle = "The job title may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.jobDepartment_select = "You cannot both select a job department and enter a job department.">
<cfset Variables.lang_insertUpdateUser.jobDepartment_maxlengthSelect = "The job department may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.jobDepartment_maxlengthText = "The job department may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateUser.jobDivision = "The job division may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">

<cfset Variables.lang_insertUpdateUser.errorTitle_insert = "The user could not be created for the following reason(s):">
<cfset Variables.lang_insertUpdateUser.errorTitle_update = "The user could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdateUser.errorHeader = "">
<cfset Variables.lang_insertUpdateUser.errorFooter = "">
