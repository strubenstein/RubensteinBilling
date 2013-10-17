<cfset Variables.lang_insertUpdateTemplate = StructNew()>

<cfset Variables.lang_insertUpdateTemplate.formSubmitValue_insert = "Add Template">
<cfset Variables.lang_insertUpdateTemplate.formSubmitValue_update = "Update Template">
<cfset Variables.lang_insertUpdateTemplate.formSubmitValue_copy = "Copy Template">

<cfset Variables.lang_insertUpdateTemplate.templateType = "You did not select a valid template type.">
<cfset Variables.lang_insertUpdateTemplate.templateStatus = "You did not select a valid status for this template.">
<cfset Variables.lang_insertUpdateTemplate.templateName_blank = "The template name cannot be blank.">
<cfset Variables.lang_insertUpdateTemplate.templateName_maxlength = "The tmeplate name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateTemplate.templateName_unique = "The template name is already being used by another template of this type.">
<cfset Variables.lang_insertUpdateTemplate.templateFilename_blank = "The template filename cannot be blank.">
<cfset Variables.lang_insertUpdateTemplate.templateFilename_cfm = "The template filename must end with &quot;.cfm&quot;.">
<cfset Variables.lang_insertUpdateTemplate.templateFilename_maxlength = "The template filename may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateTemplate.templateFilename_valid = "You did not enter a valid filename for the template.">
<cfset Variables.lang_insertUpdateTemplate.templateFilename_fileExists = "The template with the filename you specified does not exist.">
<cfset Variables.lang_insertUpdateTemplate.templateFilename_unique = "The template filename you specified is already being used by another template.">
<cfset Variables.lang_insertUpdateTemplate.templateDescription = "The template description may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">

<cfset Variables.lang_insertUpdateTemplate.errorTitle_insert = "The template could not be added for the following reason(s):">
<cfset Variables.lang_insertUpdateTemplate.errorTitle_update = "The template could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdateTemplate.errorHeader = "">
<cfset Variables.lang_insertUpdateTemplate.errorFooter = "">
