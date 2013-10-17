<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_scheduler#">
<cfcase value="invalidScheduler">You did not specify a valid scheduled task.</cfcase>
<cfcase value="noScheduler">You must specify a valid scheduled task.</cfcase>
<cfcase value="invalidAction">You did not specify a valid function for scheduled tasks.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>