<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_merchant#">
<cfcase value="invalidCompany">You did not specify a valid company for this merchant.<br>You may create a generic merchant below.</cfcase>
<cfcase value="invalidMerchant">You did not specify a valid merchant processor.</cfcase>
<cfcase value="noMerchant">You did not specify a merchant processor.</cfcase>
<cfcase value="invalidMerchantAccount">You did not specify a valid merchant account.</cfcase>
<cfcase value="noMerchantAccount">You did not specify a merchant account.</cfcase>
<cfcase value="invalidAction">You did not specify a valid merchant account function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>