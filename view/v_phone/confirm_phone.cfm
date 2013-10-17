<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_phone#">
<cfcase value="insertPhone">Phone number successfully added!<br>You may add another phone number below for this user/company.</cfcase>
<cfcase value="updatePhone">Phone number successfully updated!<br>The previous version of this phone number has been archived.</cfcase>
<cfcase value="updatePhoneStatus0">Phone number is no longer active.</cfcase>
<cfcase value="updatePhoneStatus1">Phone number is now active again.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
