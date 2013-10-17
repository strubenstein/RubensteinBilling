<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_contactTemplate#">
<cfcase value="insertContactTemplate">Contact management template successfully added!<br>You may add another contact management template below.</cfcase>
<cfcase value="updateContactTemplate">Contact management template successfully updated!</cfcase>
<cfcase value="moveContactTemplateUp,moveContactTemplateDown">Contact management template successfully moved.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
