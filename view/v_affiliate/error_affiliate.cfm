<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_affiliate#">
<cfcase value="invalidAffiliate">You did not specify a valid affiliate.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="noAffiliate">You did not specify a valid affiliate.</cfcase>
<cfcase value="invalidAction">You did not specify a valid affiliate function.</cfcase>
<cfcase value="listCompanyAffiliates">To view the list of affiliates for a particular company, you must first select the company via Companies.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>