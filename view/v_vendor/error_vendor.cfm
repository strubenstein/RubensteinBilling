<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_vendor#">
<cfcase value="invalidVendor">You did not specify a valid vendor.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="noVendor">You did not specify a valid vendor.</cfcase>
<cfcase value="invalidAction">You did not specify a valid vendor function.</cfcase>
<cfcase value="listCompanyVendors">To view the list of vendors for a particular company, you must first select the company via Companies.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>