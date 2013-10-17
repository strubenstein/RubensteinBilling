<cfset Variables.lang_insertUpdateCustomField = StructNew()>

<cfset Variables.lang_insertUpdateCustomField.customFieldStatus = "You did not select a valid option for the current status of this custom field.">
<cfset Variables.lang_insertUpdateCustomField.customFieldType = "You did not select a valid field type for this custom field.">
<cfset Variables.lang_insertUpdateCustomField.customFieldFormType = "You did not select a valid form type for this custom field.">
<cfset Variables.lang_insertUpdateCustomField.customFieldName_blank = "The name of the custom field cannot be blank.">
<cfset Variables.lang_insertUpdateCustomField.customFieldName_maxlength = "The custom field name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCustomField.customFieldName_unique = "The custom field name is already being used by another field.">
<cfset Variables.lang_insertUpdateCustomField.customFieldTitle_blank = "The custom field title cannot be blank.">
<cfset Variables.lang_insertUpdateCustomField.customFieldTitle_maxlength = "The custom field title may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCustomField.customFieldDescription = "The custom field description may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCustomField.primaryTargetID_valid = "You selected a invalid target.">
<cfset Variables.lang_insertUpdateCustomField.customFieldExportXml = "You did not select a valid option for whether to include this custom field in the XML export file.">
<cfset Variables.lang_insertUpdateCustomField.customFieldExportTab = "You did not select a valid option for whether to include this custom field in the tab-delimited export file.">
<cfset Variables.lang_insertUpdateCustomField.customFieldExportHtml = "You did not select a valid option for whether to display this custom field in the browser version.">
<cfset Variables.lang_insertUpdateCustomField.customFieldInternal = "You did not select a valid option for whether this is an internai field.">

<cfset Variables.lang_insertUpdateCustomField.customFieldOption_blank = "You chose a form type that suggests the field value will be selected, but did not enter any custom field options.">
<cfset Variables.lang_insertUpdateCustomField.customFieldOptionLabel_maxlength = "Custom field option label ##<<COUNT>> must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCustomField.customFieldOptionValue_maxlength = "Custom field option value ##<<COUNT>> must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCustomField.customFieldOptionValue_bit = "Custom field option value ##<<COUNT>> was not a valid value of True/False or 0/1.">
<cfset Variables.lang_insertUpdateCustomField.customFieldOptionValue_datetime = "Custom field option value ##<<COUNT>> was not a valid date/time value.">
<cfset Variables.lang_insertUpdateCustomField.customFieldOptionValue_decimal = "Custom field option value ##<<COUNT>> was not a number.">
<cfset Variables.lang_insertUpdateCustomField.customFieldOptionValue_decimalMaxlength = "Custom field option value ##<<COUNT>> may have a maximum of <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdateCustomField.customFieldOptionValue_varcharMaxlength = "Custom field option value ##<<COUNT>> must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCustomField.customFieldOptionValue_int = "Custom field option value ##<<COUNT>> was not an integer.">

<cfset Variables.lang_insertUpdateCustomField.formSubmitValue_insert = "Create Custom Field">
<cfset Variables.lang_insertUpdateCustomField.formSubmitValue_update = "Update Custom Field">

<cfset Variables.lang_insertUpdateCustomField.errorTitle_insert = "The custom field could not be created for the following reason(s):">
<cfset Variables.lang_insertUpdateCustomField.errorTitle_update = "The custom field could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdateCustomField.errorHeader = "">
<cfset Variables.lang_insertUpdateCustomField.errorFooter = "">
