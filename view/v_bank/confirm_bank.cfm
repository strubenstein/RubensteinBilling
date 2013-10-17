<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_bank#">
<cfcase value="insertBank">Bank information successfully added!<br>You may add another bank listing below for this user/company.</cfcase>
<cfcase value="updateBank">Bank information successfully updated!<br>The previous version of this bank has been archived.</cfcase>
<cfcase value="deleteBank">Bank information deleted.</cfcase>
<cfcase value="updateBankStatus0">Bank information has been archived.</cfcase>
<cfcase value="updateBankStatus1">Bank information is now active again.</cfcase>
<cfcase value="updateBankRetain0">Bank information is no longer being retained.</cfcase>
<cfcase value="updateBankRetain1">Bank information is now being retained again.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
