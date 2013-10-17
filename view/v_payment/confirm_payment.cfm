<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_payment#">
<cfcase value="insertPayment">Payment successfully added!</cfcase>
<cfcase value="insertPayment_approve">Payment successfully added.<br>The payment was successfully processed.</cfcase>
<cfcase value="insertPayment_reject">Payment successfully added. <font class="ErrorMessage">The payment was rejected.<br>The error message is listed in the payment details below.</font></cfcase>
<cfcase value="updatePayment">Payment successfully updated!</cfcase>
<cfcase value="updatePayment_approve">Payment successfully updated.<br>The payment was successfully processed.</cfcase>
<cfcase value="updatePayment_reject">Payment successfully updated. <font class="ErrorMessage">The payment was rejected.<br>The error message is listed in the payment details below.</font></cfcase>
<cfcase value="applyInvoicesToPayment">Invoice(s) successfully added to payment!</cfcase>
<cfcase value="applyPaymentsToInvoice">Payment successfully added to invoice(s)!</cfcase>
<cfcase value="deleteInvoicePayment">Payment removed from invoice.</cfcase>
<cfcase value="insertPaymentRefund">Refund successfully added!</cfcase>
<cfcase value="insertPaymentRefund_approve">Refund successfully added.<br>The refund was successfully processed.</cfcase>
<cfcase value="insertPaymentRefund_reject">Refund successfully added. <font class="ErrorMessage">The refund was rejected.<br>The error message is listed in the refund details below.</font></cfcase>
<cfcase value="updatePaymentRefund">Refund successfully updated!</cfcase>
<cfcase value="updatePaymentRefund_approve">Refund successfully updated.<br>The refund was successfully processed.</cfcase>
<cfcase value="updatePaymentRefund_reject">Refund successfully updated. <font class="ErrorMessage">The refund was rejected.<br>The error message is listed in the refund details below.</font></cfcase>
<cfcase value="updatePaymentIsExported">Export status of payment/refund records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
