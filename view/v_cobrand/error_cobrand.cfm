<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_cobrand#">
<cfcase value="invalidCobrand">You did not specify a valid cobrand.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="noCobrand">You did not specify a valid cobrand.</cfcase>
<cfcase value="invalidAction">You did not specify a valid cobrand function.</cfcase>
<cfcase value="listCompanyCobrands">To view the list of cobrands for a particular company, you must first select the company via Companies.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>