<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_scheduler#">
<cfcase value="insertScheduler">Scheduled task successfully added!</cfcase>
<cfcase value="updateScheduler">Scheduled task successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
