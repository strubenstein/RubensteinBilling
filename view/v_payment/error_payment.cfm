<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_payment#">
<cfcase value="invalidPayment">You did not specify a valid payment.</cfcase>
<cfcase value="noPayment">You must specify a valid payment.</cfcase>
<cfcase value="invalidPaymentRefund">You did not specify a valid refund.</cfcase>
<cfcase value="noPaymentRefund">You must specify a valid refund.</cfcase>
<cfcase value="invalidAction">You did not specify a valid payment/refund function.</cfcase>
<cfcase value="insertPayment">To add a payment, you must first select the company or invoice the payment applies to.</cfcase>
<cfcase value="insertPaymentRefund">To add a refund, you must first select the company the refund applies to.</cfcase>
<cfcase value="noInvoice">You did not specify a valid invoice for this action.</cfcase>
<cfcase value="applyPaymentsToInvoice_exist">The payment you selected to add to this invoice does not exist.</cfcase>
<cfcase value="applyPaymentsToInvoice_not">The payment you selected to add to this invoice has already been added to this invoice.</cfcase>
<cfcase value="applyPaymentsToInvoice_valid">The payment you selected to add to this invoice is not a valid payment.</cfcase>
<cfcase value="applyPaymentsToInvoice_status">The payment you selected to add to this invoice is inactive or was not approved.</cfcase>
<cfcase value="applyPaymentsToInvoice_applied">The payment you selected to add to this invoice has already been fully applied.</cfcase>
<cfcase value="applyInvoicesToPayment_exist">The invoice you selected to add to this payment does not exist.</cfcase>
<cfcase value="applyInvoicesToPayment_not">The invoice you selected to add to this payment has already been added to this payment.</cfcase>
<cfcase value="applyInvoicesToPayment_valid">The invoice you selected to add to this payment is not a valid invoice.</cfcase>
<cfcase value="applyInvoicesToPayment_status">The payment must be active and approved to be applied to an invoice.</cfcase>
<cfcase value="applyInvoicesToPayment_applied">The payment has already been fully applied.</cfcase>
<cfcase value="applyInvoicesToPayment_paid">The invoice you selected to add to this payment is already fully paid.</cfcase>
<cfcase value="deleteInvoicePayment">You did not select a valid invoice/payment combination to delete.</cfcase>
<cfcase value="invoiceAlreadyPaid">This invoice is already fully paid.<br>There is no need to process a payment for it.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>