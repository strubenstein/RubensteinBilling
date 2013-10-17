<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_task#">
<cfcase value="insertTask">Task successfully added!</cfcase>
<cfcase value="updateTask">Task successfully updated!</cfcase>
<cfcase value="deleteTask">Task deleted.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
