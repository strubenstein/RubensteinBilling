<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_payflow#">
<cfcase value="insertPayflow">Subscription processing method successfully added!</cfcase>
<cfcase value="updatePayflow">Subscription processing method successfully updated!</cfcase>
<cfcase value="insertPayflowTemplate">Template options for subscription processing method successfully updated!</cfcase>
<cfcase value="insertPayflowGroup">Subscription processing method(s) for this group successfully updated!</cfcase>
<cfcase value="insertPayflowCompany">Subscription processing method(s) for this company successfully updated!</cfcase>
<cfcase value="insertPayflowNotify">New user successfully added to be notified for subscription processing method.</cfcase>
<cfcase value="updatePayflowNotify">User notification options successfully updated for subscription processing method.</cfcase>
<cfcase value="insertPayflowTarget">Subscription processing method(s) for this target successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
