<cfset Variables.lang_insertPayflowTarget = StructNew()>
<cfset Variables.lang_insertPayflowTarget_title = StructNew()>

<cfset Variables.lang_insertPayflowTarget.formSubmitValue = "Update Subscription Processing">
<cfset Variables.lang_insertPayflowTarget_title.payflowOrder = "##">
<cfset Variables.lang_insertPayflowTarget_title.payflowName = "Subscription Processing<br>Method Name">
<cfset Variables.lang_insertPayflowTarget_title.payflowID_custom = "Custom ID">
<cfset Variables.lang_insertPayflowTarget_title.payflowDefault = "Default">
<cfset Variables.lang_insertPayflowTarget_title.payflowStatus = "Status">
<cfset Variables.lang_insertPayflowTarget_title.payflowID = "Use This<br>Method?">
<cfset Variables.lang_insertPayflowTarget_title.payflowDateBegin = "Begin Date<br>(= today if blank)">
<cfset Variables.lang_insertPayflowTarget_title.payflowDateEnd = "End Date<br>(optional)">

<cfset Variables.lang_insertPayflowTarget.payflowTargetDateBegin_valid = "For subscription processing method ##<<COUNT>>, you did not enter a valid begin date.">
<cfset Variables.lang_insertPayflowTarget.payflowTargetDateBegin_repeat = "For subscription processing method ##<<COUNT>>, the begin date cannot be repeated.">
<cfset Variables.lang_insertPayflowTarget.payflowTargetDateEnd_repeatNull = "For subscription processing method ##<<COUNT>>, only one end date may be blank.">
<cfset Variables.lang_insertPayflowTarget.payflowTargetDateEnd_valid = "For subscription processing method ##<<COUNT>>, you did not enter a valid end date.">
<cfset Variables.lang_insertPayflowTarget.payflowTargetDateEnd_begin = "For subscription processing method ##<<COUNT>>, the end date is before the begin date.">
<cfset Variables.lang_insertPayflowTarget.payflowTargetDateEnd_repeat = "For subscription processing method ##<<COUNT>>, the end date cannot be repeated.">
<cfset Variables.lang_insertPayflowTarget.payflowTargetDateEnd_afterNull = "For subscription processing method ##<<COUNT>>, the begin date comes after another begin/end date combination where the end date is blank.">
<cfset Variables.lang_insertPayflowTarget.payflowTargetDateEnd_chrono = "At least one begin date is before the end date of a previous subscription processing method.">

<cfset Variables.lang_insertPayflowTarget.errorTitle = "The subscription processing method(s) used could not be updated for the following reason(s):">
<cfset Variables.lang_insertPayflowTarget.errorHeader = "">
<cfset Variables.lang_insertPayflowTarget.errorFooter = "">

