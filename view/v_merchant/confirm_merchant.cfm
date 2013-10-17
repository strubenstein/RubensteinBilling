<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_merchant#">
<cfcase value="insertMerchant">Merchant processor successfully created!</cfcase>
<cfcase value="updateMerchant">Merchant processor successfully created!</cfcase>
<cfcase value="insertMerchantAccount">Merchant account successfully updated!</cfcase>
<cfcase value="updateMerchantAccount">Merchant account successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>