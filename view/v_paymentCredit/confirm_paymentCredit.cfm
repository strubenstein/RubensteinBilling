<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_paymentCredit#">
<cfcase value="insertPaymentCredit">Payment credit successfully added!</cfcase>
<cfcase value="updatePaymentCredit">Payment credit successfully updated!</cfcase>
<cfcase value="applyInvoicesToPaymentCredit">Invoice(s) successfully added to payment credit!</cfcase>
<cfcase value="applyPaymentCreditsToInvoice">Payment credit successfully added to invoice(s)!</cfcase>
<cfcase value="updateInvoicePaymentCredit">Payment credit text for invoice successfully updated.</cfcase>
<cfcase value="deleteInvoicePaymentCredit">Payment credit removed from invoice.</cfcase>
<cfcase value="updatePaymentCreditIsExported">Export status of payment credit records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
