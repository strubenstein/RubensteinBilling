<cfset Variables.lang_insertUpdatePaymentCategory = StructNew()>

<cfset Variables.lang_insertUpdatePaymentCategory.formSubmitValue_insert = "Add Payment Category">
<cfset Variables.lang_insertUpdatePaymentCategory.formSubmitValue_update = "Update Payment Category">

<cfset Variables.lang_insertUpdatePaymentCategory.paymentCategoryOrder = "You did not select a valid payment category order.">
<cfset Variables.lang_insertUpdatePaymentCategory.paymentCategoryStatus = "You did not select a valid payment category status.">
<cfset Variables.lang_insertUpdatePaymentCategory.paymentCategoryName_blank = "The payment category name cannot be blank.">
<cfset Variables.lang_insertUpdatePaymentCategory.paymentCategoryName_maxlength = "The payment category name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdatePaymentCategory.paymentCategoryName_unique = "The payment category name must be unique.">
<cfset Variables.lang_insertUpdatePaymentCategory.paymentCategoryTitle_maxlength = "The payment category title may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdatePaymentCategory.paymentCategoryID_custom_maxlength = "The payment category cusotm ID may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdatePaymentCategory.paymentCategoryAutoMethod_valid = "You did not select a valid payment method for which this payment category should automatically be used when processing subscriptions.">
<cfset Variables.lang_insertUpdatePaymentCategory.paymentCategoryAutoMethod_repeat = "Another payment category is already being used for payment method <<METHOD>> as the category when processing subscriptions.">

<cfset Variables.lang_insertUpdatePaymentCategory.errorTitle_insert = "The payment category could not be added for the following reason(s):">
<cfset Variables.lang_insertUpdatePaymentCategory.errorTitle_update = "The payment category could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdatePaymentCategory.errorHeader = "">
<cfset Variables.lang_insertUpdatePaymentCategory.errorFooter = "">
