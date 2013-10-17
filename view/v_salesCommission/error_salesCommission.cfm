<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_salesCommission#">
<cfcase value="invalidSalesCommission">You did not specify a valid sales commission.</cfcase>
<cfcase value="invalidAction">You did not specify a valid sales commission function.</cfcase>
<cfcase value="insertSalesCommission">To add a commission, you must start from the individual invoice or the recipient.</cfcase>
<cfcase value="viewSalesCommission,viewSalesCommissionAll">To view the sales commission settings, you must start from the individual invoice.</cfcase>
<cfcase value="updateSalesCommission">You did not submit a valid form to update the sales commission.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>