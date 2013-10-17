<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_trigger#">
<cfcase value="invalidAction">You did not specify a valid trigger function.</cfcase>
<cfcase value="noTriggerAction">You did not specify a trigger action.</cfcase>
<cfcase value="invalidTriggerAction">You did not specify a valid trigger action.</cfcase>
<cfcase value="insertTrigger">There is already a valid trigger for this action.</cfcase>
<cfcase value="updateTrigger">There is not a valid trigger for this action.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>