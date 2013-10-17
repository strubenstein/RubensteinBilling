<!--- <cfset lang_listTasks = StructNew()> --->
<!--- <cfset lang_listTasks_title = StructNew()> --->

<cfset lang_listTasks_title.taskDateScheduled = "Task<br>Date">
<cfset lang_listTasks_title.agentLastName = "Assigned<br>To">
<cfset lang_listTasks_title.targetCompanyName = "Task<br>Target">
<cfset lang_listTasks_title.taskMessage = "Task Description">
<cfset lang_listTasks_title.authorLastName = "Created<br>By">
<cfset lang_listTasks_title.taskDateCreated = "Date<br>Created">
<cfset lang_listTasks_title.taskStatus = "Task<br>Status">
<cfset lang_listTasks_title.taskCompleted = "Completed?">
<cfset lang_listTasks_title.updateTask = "Action">

<cfset lang_listTasks.userID_agent = "You did not select a valid user who is supposed to perform this task.">
<cfset lang_listTasks.userID_author = "You did not select a valid user who created this task.">
<cfset lang_listTasks.taskDateCreated_from = "You did not select a valid &quot;from&quot; date for when the task was created.">
<cfset lang_listTasks.taskDateCreated_to = "You did not select a valid &quot;to&quot; date for when the task was created.">
<cfset lang_listTasks.taskDateUpdated_from = "You did not select a valid &quot;from&quot; date for when the task was completed.">
<cfset lang_listTasks.taskDateUpdated_to = "You did not select a valid &quot;to&quot; date for when the task was completed.">
<cfset lang_listTasks.taskDateScheduled_from = "You did not select a valid &quot;from&quot; date for when the task was scheduled to be completed.">
<cfset lang_listTasks.taskDateScheduled_to = "You did not select a valid &quot;to&quot; date for when the task was scheduled to be completed.">
<cfset lang_listTasks.taskDateTo = "The &quot;from&quot; date you selected cannot be after the &quot;to&quot; date you selected.">
<cfset lang_listTasks.taskStatus = "You did not select a valid option for whether the task is being ignored.">
<cfset lang_listTasks.taskCompleted = "You did not select a valid option for whether the task has been completed.">
<cfset lang_listTasks.taskAll = "You did not select a valid option for whether to view all tasks.">
<cfset lang_listTasks.taskAllForThisUser = "You did not select a valid option for whether to view all tasks for this user.">
<cfset lang_listTasks.taskAllForThisCompany = "You did not select a valid option for whether to view all tasks for this company.">
<cfset lang_listTasks.queryDisplayPerPage = "You did not select a valid number of messages to display per page.">
<cfset lang_listTasks.queryPage = "You did not select a valid results page number.">

<cfset lang_listTasks.errorTitle = "The tasks could not be listed for the following reason(s):">
<cfset lang_listTasks.errorHeader = "">
<cfset lang_listTasks.errorFooter = "">
