<cfset lang_insertUpdateTask = StructNew()>

<cfset lang_insertUpdateTask.formSubmitValue_insert = "Add Task">
<cfset lang_insertUpdateTask.formSubmitValue_update = "Update Task">

<cfset lang_insertUpdateTask.userID_agent = "You did not select a valid user to assign this task to.">
<cfset lang_insertUpdateTask.taskDateScheduled = "The date/time for this task must be after now.">
<cfset lang_insertUpdateTask.taskMessage_blank = "The task message cannot be blank.">
<cfset lang_insertUpdateTask.taskMessage_maxlength = "The task description may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset lang_insertUpdateTask.taskStatus = "You did not select a valid option for whether this task is still active.">
<cfset lang_insertUpdateTask.taskCompleted = "You did not select a valid option for whether this task has been completed.">

<cfset lang_insertUpdateTask.errorTitle_insert = "The task could not be added for the following reason(s):">
<cfset lang_insertUpdateTask.errorTitle_update = "The task could not be updated for the following reason(s):">
<cfset lang_insertUpdateTask.errorHeader = "">
<cfset lang_insertUpdateTask.errorFooter = "">
