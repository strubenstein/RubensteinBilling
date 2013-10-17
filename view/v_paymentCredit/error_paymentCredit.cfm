<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_paymentCredit#">
<cfcase value="invalidPaymentCredit">You did not specify a valid payment credit.</cfcase>
<cfcase value="noPaymentCredit">You must specify a valid payment credit.</cfcase>
<cfcase value="invalidAction">You did not specify a valid payment credit function.</cfcase>
<cfcase value="insertPaymentCredit">To add a payment credit, you must first select the company or invoice the payment credit applies to.</cfcase>
<cfcase value="noInvoice">You did not specify a valid invoice for this action.</cfcase>
<cfcase value="applyPaymentCreditsToInvoice_exist">The payment credit(s) you selected to add to this invoice does not exist.</cfcase>
<cfcase value="applyPaymentCreditsToInvoice_not">The payment credit(s) you selected to add to this invoice has already been added to this invoice.</cfcase>
<cfcase value="applyPaymentCreditsToInvoice_valid">The payment credit(s) you selected to add to this invoice is not a valid payment credit.</cfcase>
<cfcase value="applyInvoicesToPaymentCredit_exist">The invoice(s) you selected to add to this payment credit does not exist.</cfcase>
<cfcase value="applyInvoicesToPaymentCredit_not">The invoice(s) you selected to add to this payment credit has already been added to this payment.</cfcase>
<cfcase value="applyInvoicesToPaymentCredit_valid">The invoice(s) you selected to add to this payment credit is not a valid invoice.</cfcase>
<cfcase value="deleteInvoicePaymentCredit">You did not select a valid invoice/payment credit combination to delete.</cfcase>
<cfcase value="updateInvoicePaymentCredit">You did not select a valid invoice/payment credit combination to update.</cfcase>
<cfcase value="updateInvoicePaymentCredit_form">You did not submit a valid form to update the payment credit text for this invoice.</cfcase>
<cfcase value="updateInvoicePaymentCredit_maxlength">The updated payment credit text for this invoice must be 255 characters or less.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>