<cfset Variables.lang_insertCustomFieldValues = StructNew()>

<cfset Variables.lang_insertCustomFieldValues.customFieldVarcharValue_maxlength = "Custom field ##<<COUNT>> must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertCustomFieldValues.customFieldBitValue_valid = "The value for custom field ##<<COUNT>> was not a valid True/False value.">
<cfset Variables.lang_insertCustomFieldValues.customFieldIntegerValue_valid = "The value for custom field ##<<COUNT>> was not an integer.">
<cfset Variables.lang_insertCustomFieldValues.customFieldFloatValue_valid = "The value for custom field ##<<COUNT>> was not a number.">
<cfset Variables.lang_insertCustomFieldValues.customFieldDecimalValue_maxlength = "Custom field ##<<COUNT>> may have a maximum of <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertCustomFieldValues.customFieldDateTimeValue_valid = "The value for custom field ##<<COUNT>> was not a valid date/time value.">
<cfset Variables.lang_insertCustomFieldValues.customFieldOptionID_singleValid = "The selected response for custom field ##<<COUNT>> was not a valid response for that question.">
<cfset Variables.lang_insertCustomFieldValues.customFieldOptionID_multipleValid = "A selected response for custom field ##<<COUNT>> was not a valid response for that question.">

<cfset Variables.lang_insertCustomFieldValues.errorTitle = "The custom field could not be updated for the following reason(s):">
<cfset Variables.lang_insertCustomFieldValues.errorHeader = "">
<cfset Variables.lang_insertCustomFieldValues.errorFooter = "">
