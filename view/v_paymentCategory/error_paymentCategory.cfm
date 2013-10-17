<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_paymentCategory#">
<cfcase value="invalidPaymentCategory">You did not specify a valid payment category.</cfcase>
<cfcase value="noPaymentCategory">You must specify a valid payment category.</cfcase>
<cfcase value="invalidAction">You did not specify a valid payment category function.</cfcase>
<cfcase value="invalidPaymentCategoryType">You did not specify a valid payment category type.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>