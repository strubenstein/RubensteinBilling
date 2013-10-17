<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_trigger#">
<cfcase value="insertTriggerAction">Trigger action successfully added!<br>You may add another trigger action below.</cfcase>
<cfcase value="updateTriggerAction">Trigger action successfully updated!</cfcase>
<cfcase value="moveTriggerActionUp,moveTriggerActionDown">Trigger successfully moved.</cfcase>
<cfcase value="insertTrigger">Trigger successfully added!<br>You may add another trigger below.</cfcase>
<cfcase value="updateTrigger">Trigger successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
