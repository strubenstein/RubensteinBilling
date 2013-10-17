<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_bank#">
<cfcase value="invalidBank">You did not specify a valid bank.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="invalidUser">You did not specify a valid user.</cfcase>
<cfcase value="noBank">You did not specify a valid bank.</cfcase>
<cfcase value="invalidAction">You did not specify a valid bank function.</cfcase>
<cfcase value="invalidBankStatus">You cannot update an archived version of a bank.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>