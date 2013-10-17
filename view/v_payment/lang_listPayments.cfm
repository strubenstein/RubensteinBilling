<cfset Variables.lang_listPayments = StructNew()>
<cfset Variables.lang_listPayments_title = StructNew()>

<cfset Variables.lang_listPayments_title.paymentID_custom = "Custom<br>ID">
<cfset Variables.lang_listPayments_title.paymentDateReceived = "Date<br>Received">
<cfset Variables.lang_listPayments_title.refundDateReceived = "Date<br>Processed">
<cfset Variables.lang_listPayments_title.targetCompanyName = "Company<br>Name">
<cfset Variables.lang_listPayments_title.targetLastName = "Contact<br>Person">
<cfset Variables.lang_listPayments_title.paymentApproved = "Approval<br>Status">
<cfset Variables.lang_listPayments_title.paymentAmount = "<br>Amount">
<cfset Variables.lang_listPayments_title.paymentDetails = "Assorted<br>Details">
<cfset Variables.lang_listPayments_title.paymentDateScheduled = "Date<br>Scheduled">
<cfset Variables.lang_listPayments_title.viewPayment = "Manage">
<cfset Variables.lang_listPayments_title.applyPaymentsToInvoice = "Add to<br>Invoice">
<cfset Variables.lang_listPayments_title.listPaymentRefunds = "Manage">
<cfset Variables.lang_listPayments_title.listPayments = "Manage">

<cfset Variables.lang_listPayments.paymentIsScheduled = "You did not select a valid option for whether the payment was manually scheduled.">
<cfset Variables.lang_listPayments.paymentManual = "You did not select a valid option for whether the payment was recorded manually.">
<cfset Variables.lang_listPayments.paymentStatus = "You did not select a valid option for whether the payment is active.">
<cfset Variables.lang_listPayments.paymentAppliedToInvoice = "You did not select a valid option for whether the payment was applied to an invoice.">
<cfset Variables.lang_listPayments.paymentAppliedToMultipleInvoices = "You did not select a valid option for whether the payment was applied to multiple invoices.">
<cfset Variables.lang_listPayments.paymentHasCustomID = "You did not select a valid option for whether the payment has a custom ID.">
<cfset Variables.lang_listPayments.paymentHasCreditCardID = "You did not select a valid option for whether the payment was paid via credit card.">
<cfset Variables.lang_listPayments.paymentHasBankID = "You did not select a valid option for whether the payment was paid via bank/ACH transaction.">
<cfset Variables.lang_listPayments.paymentHasCheckNumber = "You did not select a valid option for whether the payment has a check number.">
<cfset Variables.lang_listPayments.paymentProcessed = "You did not select a valid option for whether the payment was processed via your merchant account.">
<cfset Variables.lang_listPayments.paymentHasDescription = "You did not select a valid option for whether the payment has a description.">
<cfset Variables.lang_listPayments.paymentHasMessage = "You did not select a valid option for whether the payment has an error message.">
<cfset Variables.lang_listPayments.paymentApproved = "You did not select a valid option for whether the payment has been approved.">
<cfset Variables.lang_listPayments.paymentIsRefund = "You did not select a valid option for whether the payment is a refund.">
<cfset Variables.lang_listPayments.paymentHasBeenRefunded = "You did not select a valid option for whether the payment has been refunded.">
<cfset Variables.lang_listPayments.paymentIsFullyApplied = "You did not select a valid option for whether the payment amount has been fully applied to invoices.">

<cfset Variables.lang_listPayments.userID_author = "You did not select a valid user(s) who recorded the payment.">
<cfset Variables.lang_listPayments.invoiceID = "You did not select a valid purchase/invoice(s).">
<cfset Variables.lang_listPayments.creditCardID = "You did not select a valid credit card account(s).">
<cfset Variables.lang_listPayments.bankID = "You did not select a valid bank account(s).">
<cfset Variables.lang_listPayments.merchantAccountID = "You did not select a valid merchant account(s).">
<cfset Variables.lang_listPayments.paymentCheckNumber = "The check number must be a positive integer (or list of integers).">
<cfset Variables.lang_listPayments.merchantAccountID = "The minimum check number must be a positive integer.">
<cfset Variables.lang_listPayments.paymentAmount = "The payment amount must be a positive number.">
<cfset Variables.lang_listPayments.paymentAmount_min = "The minimum payment amount must be a positive number.">
<cfset Variables.lang_listPayments.paymentAmount_max = "The maximum payment amount must be a positive number.">

<cfset Variables.lang_listPayments.paymentDateReceived_from = "You did not enter a valid begin date for the date the payment was received.">
<cfset Variables.lang_listPayments.paymentDateReceived_to = "You did not enter a valid end date for the date the payment was received.">
<cfset Variables.lang_listPayments.paymentDateCreated_from = "You did not enter a valid begin date for the date the payment was created.">
<cfset Variables.lang_listPayments.paymentDateCreated_to = "You did not enter a valid end date for the date the payment was created.">
<cfset Variables.lang_listPayments.paymentDateUpdated_from = "You did not enter a valid begin date for the date the payment was last updated.">
<cfset Variables.lang_listPayments.paymentDateUpdated_to = "You did not enter a valid end date for the date the payment was last updated.">
<cfset Variables.lang_listPayments.paymentDateScheduled_from = "You did not enter a valid begin date for the date the payment was scheduled.">
<cfset Variables.lang_listPayments.paymentDateScheduled_to = "You did not enter a valid end date for the date the payment was scheduled.">

<cfset Variables.lang_listPayments.paymentDateTo = "The end date must be after the begin date.">
<cfset Variables.lang_listPayments.affiliateID = "You did not select a valid affiliate.">
<cfset Variables.lang_listPayments.cobrandID = "You did not select a valid cobrand.">
<cfset Variables.lang_listPayments.paymentCategoryID = "You did not select a valid payment category.">
<cfset Variables.lang_listPayments.subscriberID = "You did not select a valid subscriber">
<cfset Variables.lang_listPayments.paymentID_refund = "You did not select a valid payment refund.">

<cfset Variables.lang_listPayments.queryDisplayPerPage = "You did not enter a valid number of payments to display per page.">
<cfset Variables.lang_listPayments.queryPage = "You did not enter a valid page number.">
<cfset Variables.lang_listPayments.paymentIsExported = "You did not select a valid export status.">

<cfset Variables.lang_listPayments.errorTitle = "The payments/refunds could not be listed for the following reason(s):">
<cfset Variables.lang_listPayments.errorHeader = "">
<cfset Variables.lang_listPayments.errorFooter = "">
