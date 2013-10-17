<cfset Variables.lang_listInvoices = StructNew()>
<cfset Variables.lang_listInvoices_title = StructNew()>

<cfset Variables.lang_listInvoices_title.invoiceID_custom = "ID">
<cfset Variables.lang_listInvoices_title.companyName = "Company">
<cfset Variables.lang_listInvoices_title.lastName = "Contact<br>Person">
<cfset Variables.lang_listInvoices_title.invoiceTotal = "Total<br>Amount">
<cfset Variables.lang_listInvoices_title.invoiceClosed = "Processing<br>Status">
<cfset Variables.lang_listInvoices_title.invoicePaid = "Payment<br>Status">
<cfset Variables.lang_listInvoices_title.invoiceShippingMethod = "Shipping<br>Method">
<cfset Variables.lang_listInvoices_title.invoiceShipped = "Shipped">
<cfset Variables.lang_listInvoices_title.invoiceDateCreated = "Date<br>Created">
<cfset Variables.lang_listInvoices_title.viewInvoice = "Manage">
<cfset Variables.lang_listInvoices_title.applyInvoicesToPayment_text = "Add to<br>Payment">
<cfset Variables.lang_listInvoices_title.viewInvoice_text = "Manage">

<cfset Variables.lang_listInvoices.invoiceDateTo = "The end date must be after the begin date.">
<cfset Variables.lang_listInvoices.invoiceTotal_min = "The minimum total purchase amount was not a valid number.">
<cfset Variables.lang_listInvoices.invoiceTotal_max = "The maximum total purchase amount was not a valid number.">
<cfset Variables.lang_listInvoices.invoiceTotal_minMax = "The maximum total purchase amount was not greater than the minimum total purchase amount.">
<cfset Variables.lang_listInvoices.invoiceShippingMethod = "You did not select a valid option for the shipping method.">
<cfset Variables.lang_listInvoices.invoiceClosed = "You did not select a valid option for whether the purchase has been completed and submitted by the customer.">
<cfset Variables.lang_listInvoices.invoicePaid = "You did not select a valid option for whether the purchase has been paid for.">
<cfset Variables.lang_listInvoices.invoiceStatus = "You did not select a valid option for whether the purchase is active.">
<cfset Variables.lang_listInvoices.invoiceShipped = "You did not select a valid option for whether the purchase has been shipped.">
<cfset Variables.lang_listInvoices.invoiceCompleted = "You did not select a valid option for whether all processing has been completed for this purchase.">
<cfset Variables.lang_listInvoices.invoiceManual = "You did not select a valid option for whether the invoice was created manually.">
<cfset Variables.lang_listInvoices.invoiceSent = "You did not select a valid option for whether the invoice has been sent to the customer.">
<cfset Variables.lang_listInvoices.invoiceHasMultipleItems = "You did not select a valid option for whether the purchase included multiple items.">
<cfset Variables.lang_listInvoices.invoiceHasCustomPrice = "You did not select a valid option for whether the purchase used a custom price.">
<cfset Variables.lang_listInvoices.invoiceHasCustomID = "You did not select a valid option for whether the purchase has a custom order ID.">
<cfset Variables.lang_listInvoices.invoiceHasInstructions = "You did not select a valid option for whether the purchase has special instructions.">
<cfset Variables.lang_listInvoices.invoiceHasPaymentCredit = "You did not select a valid option for whether the purchase has payment credit(s).">
<cfset Variables.lang_listInvoices.statusID = "You did not select a valid custom status.">
<cfset Variables.lang_listInvoices.affiliateID = "You did not select a valid affiliate.">
<cfset Variables.lang_listInvoices.cobrandID = "You did not select a valid cobrand.">
<cfset Variables.lang_listInvoices.queryDisplayPerPage = "You did not enter a valid number of purchases to display per page.">
<cfset Variables.lang_listInvoices.queryPage = "You did not enter a valid page number.">
<cfset Variables.lang_listInvoices.invoiceIsExported = "You did not select a valid export status.">

<cfset Variables.lang_listInvoices.errorTitle = "The purchases/invoices could not be listed for the following reason(s):">
<cfset Variables.lang_listInvoices.errorHeader = "">
<cfset Variables.lang_listInvoices.errorFooter = "">

