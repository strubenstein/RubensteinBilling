<cfset Variables.lang_insertUpdateStatus = StructNew()>

<cfset Variables.lang_insertUpdateStatus.formSubmitValue_insert = "Add Status">
<cfset Variables.lang_insertUpdateStatus.formSubmitValue_update = "Update Status">

<cfset Variables.lang_insertUpdateStatus.statusOrder = "You did not select a valid order for this status option.">
<cfset Variables.lang_insertUpdateStatus.statusStatus = "You did not select a valid status for this status option.">
<cfset Variables.lang_insertUpdateStatus.statusDisplayToCustomer = "You did not select a valid option for whether this status option should be displayed to customers.">
<cfset Variables.lang_insertUpdateStatus.statusDescription_maxlength = "The status description may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateStatus.statusName_blank = "The internal status name cannot be blank.">
<cfset Variables.lang_insertUpdateStatus.statusName_maxlength = "The internal status name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateStatus.statusName_unique = "The internal status name is already being used by another status option.">
<cfset Variables.lang_insertUpdateStatus.statusTitle_blank = "The public status name cannot be blank.">
<cfset Variables.lang_insertUpdateStatus.statusTitle_maxlength = "The public status name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateStatus.statusID_custom_maxlength = "The custom status ID name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateStatus.statusID_custom_unique = "The custom status ID is already being used by another status option.">

<cfset Variables.lang_insertUpdateStatus.errorTitle_insert = "The status option could not be added for the following reason(s):">
<cfset Variables.lang_insertUpdateStatus.errorTitle_update = "The status option could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdateStatus.errorHeader = "">
<cfset Variables.lang_insertUpdateStatus.errorFooter = "">
