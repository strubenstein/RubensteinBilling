<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_salesCommission#">
<cfcase value="insertSalesCommission">Sales commission(s) successfully added for invoice.<br>You may add another sales commission below.</cfcase>
<cfcase value="updateSalesCommission">Sales commission(s) successfully updated.</cfcase>
<cfcase value="updateSalesCommissionPaidViaList">Sales commission(s) successfully marked as paid.</cfcase>
<cfcase value="updateSalesCommissionIsExported">Export status of sales commission records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>