<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_address#">
<cfcase value="insertAddress">Address successfully added!<br>You may add another address listing below for this user/company.</cfcase>
<cfcase value="updateAddress">Address successfully updated!<br>The previous version of this address has been archived.</cfcase>
<cfcase value="updateAddressStatus0">Address is no longer active.</cfcase>
<cfcase value="updateAddressStatus1">Address is now active again.</cfcase>
<cfcase value="updateAddressTypeBilling0">Address is no longer a billing address.</cfcase>
<cfcase value="updateAddressTypeBilling1">Address is now billing address.</cfcase>
<cfcase value="updateAddressTypeShipping0">Address is no longer a shipping address.</cfcase>
<cfcase value="updateAddressTypeShipping1">Address is now a shipping address.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
