<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_contact#">
<cfcase value="sendContact">Message successfully sent!</cfcase>
<cfcase value="saveContact">Message successfully saved. It may be sent later at any time.</cfcase>
<cfcase value="updateContact">Message successfully updated!</cfcase>
<cfcase value="updateContactStatus1">Message status updated to resolved/closed.</cfcase>
<cfcase value="updateContactStatus0">Message status updated to open/unresolved.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
