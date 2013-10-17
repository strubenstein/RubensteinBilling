<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_paymentCategory#">
<cfcase value="insertPaymentCategory">Payment category successfully added!<br>You may add another payment category below.</cfcase>
<cfcase value="updatePaymentCategory">Payment category option successfully updated!</cfcase>
<cfcase value="movePaymentCategoryUp,movePaymentCategoryDown">Payment category successfully moved.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
