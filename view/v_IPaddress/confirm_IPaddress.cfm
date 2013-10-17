<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_IPaddress#">
<cfcase value="insertIPaddress">IP address restriction successfully added!<br>You may add another IP address restriction below.</cfcase>
<cfcase value="updateIPaddress">IP address restriction successfully updated!</cfcase>
<cfcase value="deleteIPaddress">IP address restriction deleted.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
