<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_status#">
<cfcase value="insertStatus">Status option successfully added!<br>You may add another status option below.</cfcase>
<cfcase value="updateStatus">Status option successfully updated!</cfcase>
<cfcase value="moveStatusUp,moveStatusDown">Status option successfully moved.</cfcase>
<cfcase value="insertStatusHistory">Status updated for this target.</cfcase>
<cfcase value="updateStatusTarget">Status export options successfully updated.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
