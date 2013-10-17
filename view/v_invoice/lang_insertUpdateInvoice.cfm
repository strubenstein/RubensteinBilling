<cfset Variables.lang_insertUpdateInvoice = StructNew()>

<cfset Variables.lang_insertUpdateInvoice.formSubmitValue_insert = "Create Invoice">
<cfset Variables.lang_insertUpdateInvoice.formSubmitValue_update = "Update Invoice">

<cfset Variables.lang_insertUpdateInvoice.invoiceTotalLineItem_numeric = "You did not enter a valid number for the line item total.">
<cfset Variables.lang_insertUpdateInvoice.invoiceTotalLineItem_maxlength = "The line item total may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdateInvoice.invoiceTotalTax_numeric = "You did not enter a valid number for the tax total.">
<cfset Variables.lang_insertUpdateInvoice.invoiceTotalTax_maxlength = "The tax total may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdateInvoice.invoiceTotalShipping_numeric = "You did not enter a valid number for the shipping total.">
<cfset Variables.lang_insertUpdateInvoice.invoiceTotalShipping_maxlength = "The shipping total may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdateInvoice.invoiceTotalPaymentCredit_numeric = "You did not enter a valid number for the total credits.">
<cfset Variables.lang_insertUpdateInvoice.invoiceTotalPaymentCredit_maxlength = "The total credits may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdateInvoice.invoiceTotal_numeric = "You did not enter a valid number for the grand total.">
<cfset Variables.lang_insertUpdateInvoice.invoiceTotal_maxlength = "The grand total may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdateInvoice.invoiceStatus = "You did not select a valid option for whether the invoice is active.">
<cfset Variables.lang_insertUpdateInvoice.invoiceClosed = "You did not select a valid option for whether the invoice is opened, closed or already completed.">
<cfset Variables.lang_insertUpdateInvoice.invoicePaid = "You did not select a valid option for whether the invoice has been paid for.">
<cfset Variables.lang_insertUpdateInvoice.invoiceShipped = "You did not select a valid option for whether the invoice has shipped.">
<cfset Variables.lang_insertUpdateInvoice.invoiceManual = "You did not select a valid option for whether the invoice was created/updated manually.">
<cfset Variables.lang_insertUpdateInvoice.invoiceSent = "You did not select a valid option for whether the invoice has been sent to the customer.">
<cfset Variables.lang_insertUpdateInvoice.invoiceShippingMethodList_valid = "You did not select a valid shipping option.">
<cfset Variables.lang_insertUpdateInvoice.invoiceID_custom = "The custom purchase/invoice ID must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateInvoice.invoiceInstructions_maxlength = "The special instructions must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<!--- 
<cfset Variables.lang_insertUpdateInvoice.invoiceCompleted = "You did not select a valid option for whether the purchase has been fully processed.">
<cfset Variables.lang_insertUpdateInvoice.invoiceDateClosed = "You did not enter a valid date for when the invoice was closed.">
<cfset Variables.lang_insertUpdateInvoice.invoiceDatePaid = "You did not enter a valid date for when the invoice was paid.">
<cfset Variables.lang_insertUpdateInvoice.invoiceDateCompleted = "You did not enter a valid date for invoice was completed.">
--->
<cfset Variables.lang_insertUpdateInvoice.invoiceDateDue = "You did not enter a valid date for the invoice payment is due.">
<cfset Variables.lang_insertUpdateInvoice.userID = "You did not select a valid user as the contact person for this invoice.">
<cfset Variables.lang_insertUpdateInvoice.companyID = "You did not select a valid company as the target for this invoice.">
<cfset Variables.lang_insertUpdateInvoice.subscriberID = "You did not select a valid subscriber for the target company.">
<cfset Variables.lang_insertUpdateInvoice.addressID_billing = "You did not select a valid billing address.">
<cfset Variables.lang_insertUpdateInvoice.addressID_shipping = "You did not select a valid shipping address.">
<cfset Variables.lang_insertUpdateInvoice.creditCardID = "You did not select a valid credit card.">
<cfset Variables.lang_insertUpdateInvoice.bankID = "You did not select a valid bank account.">

<cfset Variables.lang_insertUpdateInvoice.errorTitle_insert = "The purchase/invoice could not be created for the following reason(s):">
<cfset Variables.lang_insertUpdateInvoice.errorTitle_update = "The purchase/invoice could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdateInvoice.errorHeader = "">
<cfset Variables.lang_insertUpdateInvoice.errorFooter = "">

