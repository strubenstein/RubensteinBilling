<cfset Variables.lang_listPaymentCredits = StructNew()>
<cfset Variables.lang_listPaymentCredits_title = StructNew()>

<cfset Variables.lang_listPaymentCredits_title.paymentCreditID_custom = "Custom<br>ID">
<cfset Variables.lang_listPaymentCredits_title.paymentCreditName = "Credit<br>Line Item Text">
<cfset Variables.lang_listPaymentCredits_title.targetCompanyName = "Company<br>Name">
<cfset Variables.lang_listPaymentCredits_title.paymentCreditAmount = "Payment<br>Amount">
<cfset Variables.lang_listPaymentCredits_title.paymentCreditAppliedMaximum = "## Times<br>Applied">
<cfset Variables.lang_listPaymentCredits_title.paymentCreditDateBegin = "Begin<br>Date">
<cfset Variables.lang_listPaymentCredits_title.paymentCreditDateBegin = "Expire<br>Date">
<cfset Variables.lang_listPaymentCredits_title.paymentDateCreated = "Date<br>Created">
<cfset Variables.lang_listPaymentCredits_title.viewPaymentCredit = "Manage">
<cfset Variables.lang_listPaymentCredits_title.applyPaymentCreditsToInvoice = "Add to<br>Invoice">
<cfset Variables.lang_listPaymentCredits_title.listPaymentCredits = "Manage">

<cfset Variables.lang_listPaymentCredits.paymentCreditHasCustomID = "You did not select a valid option for whether the payment credit has a custom ID.">
<cfset Variables.lang_listPaymentCredits.paymentCreditHasDescription = "You did not select a valid option for whether the payment credit has a description.">
<cfset Variables.lang_listPaymentCredits.paymentCreditHasName = "You did not select a valid option for whether the payment credit has a name.">
<cfset Variables.lang_listPaymentCredits.paymentCreditStatus = "You did not select a valid option for whether the payment credit is active.">

<cfset Variables.lang_listPaymentCredits.paymentCreditApplied = "You did not select a valid option for whether the payment credit has been applied.">
<cfset Variables.lang_listPaymentCredits.paymentCreditHasBeginDate = "You did not select a valid option for whether the payment credit has a designated begin date.">
<cfset Variables.lang_listPaymentCredits.paymentCreditHasEndDate = "You did not select a valid option for whether the payment credit has a designated expiration date.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAppliedMaximumMultiple = "You did not select a valid option for whether the payment credit will be applied multiple times.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAppliedCountMultiple = "You did not select a valid option for whether the payment credit has been applied multiple times.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAppliedRemaining = "You did not select a valid option for whether any payment credits are remaining.">
<cfset Variables.lang_listPaymentCredits.paymentCreditRollover = "You did not select a valid option for whether the credit should roll-over to future invoices.">
<cfset Variables.lang_listPaymentCredits.paymentCreditCompleted = "You did not select a valid option for whether the credit has been fully used.">
<cfset Variables.lang_listPaymentCredits.paymentCreditHasRolledOver = "You did not select a valid option for whether the credit has rolled over between invoices.">

<cfset Variables.lang_listPaymentCredits.paymentCreditAmount = "The payment credit amount must be a positive number.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAmount_min = "The minimum payment credit amount must be a positive number.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAmount_max = "The maximum payment credit amount must be a positive number.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAppliedMaximum = "The maximum number of times the payment credit should be applied must be a positive number.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAppliedMaximum_min = "The minimum value of the maximum number of times the payment credit should be applied must be a positive number.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAppliedMaximum_max = "The maximum value of the maximum number of times the payment credit should be applied must be a positive number.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAppliedCount = "The number of times the payment credit has been applied must be a positive number.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAppliedCount_min = "The minimum value of times the payment credit has been applied must be a positive number.">
<cfset Variables.lang_listPaymentCredits.paymentCreditAppliedCount_max = "The maximum value of times the payment credit has been applied must be a positive number.">

<cfset Variables.lang_listPaymentCredits.userID_author = "You did not select a valid user(s) who recorded the payment.">
<cfset Variables.lang_listPaymentCredits.invoiceID = "You did not select a valid purchase/invoice(s).">
<cfset Variables.lang_listPaymentCredits.paymentCategoryID = "You did not select a valid payment category.">

<cfset Variables.lang_listPaymentCredits.paymentCreditDateCreated_from = "You did not enter a valid begin date for the date the payment credit was created.">
<cfset Variables.lang_listPaymentCredits.paymentCreditDateCreated_to = "You did not enter a valid end date for the date the payment credit was created.">
<cfset Variables.lang_listPaymentCredits.paymentCreditDateUpdated_from = "You did not enter a valid begin date for the date the payment credit was last updated.">
<cfset Variables.lang_listPaymentCredits.paymentCreditDateUpdated_to = "You did not enter a valid end date for the date the payment credit was last updated.">
<cfset Variables.lang_listPaymentCredits.paymentCreditDateBegin_from = "You did not enter a valid begin date for the date the payment credit begins.">
<cfset Variables.lang_listPaymentCredits.paymentCreditDateBegin_to = "You did not enter a valid end date for the date the payment credit begins.">

<cfset Variables.lang_listPaymentCredits.paymentCreditDateTo = "The end date must be after the begin date.">
<cfset Variables.lang_listPaymentCredits.affiliateID = "You did not select a valid affiliate.">
<cfset Variables.lang_listPaymentCredits.cobrandID = "You did not select a valid cobrand.">
<cfset Variables.lang_listPaymentCredits.queryDisplayPerPage = "You did not enter a valid number of payment credits to display per page.">
<cfset Variables.lang_listPaymentCredits.queryPage = "You did not enter a valid page number.">
<cfset Variables.lang_listPaymentCredits.paymentCreditIsExported = "You did not select a valid export status.">

<cfset Variables.lang_listPaymentCredits.errorTitle = "The payment credits could not be listed for the following reason(s):">
<cfset Variables.lang_listPaymentCredits.errorHeader = "">
<cfset Variables.lang_listPaymentCredits.errorFooter = "">
