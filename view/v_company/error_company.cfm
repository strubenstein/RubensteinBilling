<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_company#">
<cfcase value="noCompany">You did not specify a valid company.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="invalidAction">You did not select a valid company function.</cfcase>
<cfcase value="invalidSelfAction">You do not have permission to perform this function for your own company.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>