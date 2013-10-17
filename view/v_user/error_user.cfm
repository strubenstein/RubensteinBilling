<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_user#">
<cfcase value="invalidUser">You did not specify a valid user.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="noUser">You did not specify a valid user.</cfcase>
<cfcase value="invalidAction">You did not specify a valid user function.</cfcase>
<cfcase value="listCommissions,viewCommissionCustomer,listSalesCommissions">The selected user is not a user in your company and thus is not eligible to receive sales commissions.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>