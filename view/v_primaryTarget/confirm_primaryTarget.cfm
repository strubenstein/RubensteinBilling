<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_primaryTarget#">
<cfcase value="insertPrimaryTarget">Primary target successfully added!</cfcase>
<cfcase value="updatePrimaryTarget">Primary target topic successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
