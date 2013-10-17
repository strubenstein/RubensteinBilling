<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_creditCard#">
<cfcase value="invalidCreditCard">You did not specify a valid credit card.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="invalidUser">You did not specify a valid user.</cfcase>
<cfcase value="noCreditCard">You did not specify a valid credit card.</cfcase>
<cfcase value="invalidAction">You did not specify a valid credit card function.</cfcase>
<cfcase value="invalidCreditCardStatus">You cannot update an archived version of a credit card.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>