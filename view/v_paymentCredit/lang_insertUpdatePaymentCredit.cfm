<cfset Variables.lang_insertUpdatePaymentCredit = StructNew()>

<cfset Variables.lang_insertUpdatePaymentCredit.formSubmitValue_insert = "Add Payment Credit">
<cfset Variables.lang_insertUpdatePaymentCredit.formSubmitValue_update = "Update Payment Credit">

<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditStatus = "You did not select a valid status for this payment credit.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditName_blank = "The payment name/type cannot be blank.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditName_maxlength = "The payment name/type must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditAmount_numeric = "The payment credit amount must be a number.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditAmount_maxlength = "The payment amount may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditAmount_negative = "The payment credit amount may not be negative.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditAmount_processed = "The payment credit amount cannot be zero.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditID_custom_maxlength = "The custom item ID must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditDescription_maxlength = "The description must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditAppliedMaximum_valid = "The number of times to apply this credit must be a non-negative integer.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditAppliedMaximum_count = "The number of times to apply this credit cannot be less than <<COUNT>>, which is the number of times it has already been applied.<br>To effectively end this credit, set the number of times to apply equal to the number of times it has already been applied.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditDateBegin_now = "You cannot set a payment credit to begin to occur before today.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditDateBegin_valid = "You did not enter a valid begin date.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditDateBegin_now = "You cannot set a payment credit to end before today.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditDateBegin_valid = "You did not enter a valid expiration date.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditDateBegin_begin = "The expiration date must be after the begin date.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCategoryID_valid = "You did not select a valid payment category.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCategoryID_inactive = "You cannot select an inactive payment category.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditRollover = "You did not select a valid option for whether the credit should roll-over to future invoices.">
<cfset Variables.lang_insertUpdatePaymentCredit.subscriberID = "You did not select a valid subscriber for this company.">
<cfset Variables.lang_insertUpdatePaymentCredit.invoiceLineItemID_noInvoice = "No invoice was specified from which you could select a line item.">
<cfset Variables.lang_insertUpdatePaymentCredit.invoiceLineItemID_valid = "You did not select valid line item for this invoice.">
<cfset Variables.lang_insertUpdatePaymentCredit.subscriptionID_noSubscriber = "No subscriber was specified from which you could select a subscription.">
<cfset Variables.lang_insertUpdatePaymentCredit.subscriptionID_valid = "You did not select valid subscription for this subscriber.">
<cfset Variables.lang_insertUpdatePaymentCredit.paymentCreditNegativeInvoice = "You did not select a valid option for whether the credit can create a negative invoice total.">

<cfset Variables.lang_insertUpdatePaymentCredit.errorTitle_insert = "The payment credit could not be recorded for the following reasons(s):">
<cfset Variables.lang_insertUpdatePaymentCredit.errorTitle_update = "The payment credit could not be updated for the following reasons(s):">
<cfset Variables.lang_insertUpdatePaymentCredit.errorHeader = "">
<cfset Variables.lang_insertUpdatePaymentCredit.errorFooter = "">
