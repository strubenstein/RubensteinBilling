<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_affiliate#">
<cfcase value="insertAffiliate">Affiliate successfully added!<br>You may add another affiliate listing below for this company.</cfcase>
<cfcase value="updateAffiliate">Affiliate successfully updated!</cfcase>
<cfcase value="updateAffiliateIsExported">Export status of affiliate records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
