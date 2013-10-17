<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_task#">
<cfcase value="invalidTask">You did not specify a valid task.</cfcase>
<cfcase value="noTask">You must specify a valid task.</cfcase>
<cfcase value="invalidAction">You did not specify a valid task action.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this task function.</cfcase>
<cfcase value="updateTaskForOthers">You do not have permission to update tasks for other users.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>