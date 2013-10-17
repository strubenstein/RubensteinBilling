<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_contactTopic#">
<cfcase value="insertContactTopic">Contact management topic successfully added!<br>You may add another contact management topic below.</cfcase>
<cfcase value="updateContactTopic">Contact management topic successfully updated!</cfcase>
<cfcase value="moveContactTopicUp,moveContactTopicDown">Contact management topic successfully moved.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
