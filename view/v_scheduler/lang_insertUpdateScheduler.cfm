<cfset Variables.lang_insertUpdateScheduler = StructNew()>

<cfset Variables.lang_insertUpdateScheduler.formSubmitValue_insert = "Add Scheduled Task">
<cfset Variables.lang_insertUpdateScheduler.formSubmitValue_update = "Update Scheduled Task">

<cfset Variables.lang_insertUpdateScheduler.companyID = "You did not select a valid company for which this task was created.">
<cfset Variables.lang_insertUpdateScheduler.schedulerStatus = "You did not select a valid status.">
<cfset Variables.lang_insertUpdateScheduler.schedulerName_blank = "The scheduled task name cannot be blank.">
<cfset Variables.lang_insertUpdateScheduler.schedulerName_maxlength = "The scheduled task name must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateScheduler.schedulerName_unique = "The scheduled task name is already being used by another task.">
<cfset Variables.lang_insertUpdateScheduler.schedulerURL_blank = "The scheduled task URL cannot be blank.">
<cfset Variables.lang_insertUpdateScheduler.schedulerURL_server = "The scheduled task URL must be the same URL as this server.">
<cfset Variables.lang_insertUpdateScheduler.schedulerURL_valid = "The scheduled task URL was not a valid URL.">
<cfset Variables.lang_insertUpdateScheduler.schedulerURL_cfm = "The scheduled task URL must be a ColdFusion file.">
<cfset Variables.lang_insertUpdateScheduler.schedulerURL_maxlength = "The scheduled task URL must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateScheduler.schedulerURL_exist = "The scheduled task URL does not exist on this server.">
<cfset Variables.lang_insertUpdateScheduler.schedulerDescription_maxlength = "The scheduled task description must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateScheduler.schedulerRequestTimeOut_valid = "You did not enter a valid number for the timeout value.">
<cfset Variables.lang_insertUpdateScheduler.schedulerRequestTimeOut_maximum = "The timeout value cannot be greater than 500 seconds.">
<cfset Variables.lang_insertUpdateScheduler.schedulerInterval_method_valid = "You did not select a valid interval method.">
<cfset Variables.lang_insertUpdateScheduler.schedulerInterval_hours_valid = "The hours interval was not a valid number.">
<cfset Variables.lang_insertUpdateScheduler.schedulerInterval_hours_maximum = "The hours interval cannot be greater than 23.">
<cfset Variables.lang_insertUpdateScheduler.schedulerInterval_minutes_valid = "The minutes interval was not a valid number.">
<cfset Variables.lang_insertUpdateScheduler.schedulerInterval_minutes_maximum = "The minutes interval cannot be greater than 59.">
<cfset Variables.lang_insertUpdateScheduler.schedulerInterval_seconds_valid = "The seconds interval was not a valid number.">
<cfset Variables.lang_insertUpdateScheduler.schedulerInterval_seconds_maximum = "The seconds interval cannot be greater than 59.">
<cfset Variables.lang_insertUpdateScheduler.schedulerInterval_zero = "The interval cannot be zero seconds.">
<cfset Variables.lang_insertUpdateScheduler.schedulerDateEnd = "The end date must be after the begin date.">

<cfset Variables.lang_insertUpdateScheduler.errorTitle_insert = "The scheduled task could not be created for the following reason(s):">
<cfset Variables.lang_insertUpdateScheduler.errorTitle_update = "The scheduled task could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdateScheduler.errorHeader = "">
<cfset Variables.lang_insertUpdateScheduler.errorFooter = "">

