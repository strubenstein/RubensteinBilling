<cfset Variables.lang_insertCommissionCustomer = StructNew()>

<cfset Variables.lang_insertCommissionCustomer.targetID_valid = "You did not select a valid salesperson.">
<cfset Variables.lang_insertCommissionCustomer.commissionCustomerPercent_numeric = "The percentage must be a valid number between 0 and 100.">
<cfset Variables.lang_insertCommissionCustomer.commissionCustomerPercent_maxlength = "The percentage may have a maximum of <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertCommissionCustomer.commissionCustomerPrimary = "You did not select a valid option for whether this salesperson is the primary salesperson.">
<cfset Variables.lang_insertCommissionCustomer.commissionCustomerDescription_maxlength = "The description must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertCommissionCustomer.commissionCustomerDateBegin_valid = "You did not enter a valid begin date.">
<cfset Variables.lang_insertCommissionCustomer.commissionCustomerDateBegin_past = "The begin date cannot be before today.">
<cfset Variables.lang_insertCommissionCustomer.commissionCustomerDateEnd_valid = "You did not enter a valid end date.">
<cfset Variables.lang_insertCommissionCustomer.commissionCustomerDateEnd_past = "The end date cannot be before today.">
<cfset Variables.lang_insertCommissionCustomer.commissionCustomerDateEnd_begin = "The end date cannot be before the begin date.">
<cfset Variables.lang_insertCommissionCustomer.userID = "You did not select a valid contact for this customer.">
<cfset Variables.lang_insertCommissionCustomer.subscriberID = "You did not select a valid subscriber for this customer.">

<cfset Variables.lang_insertCommissionCustomer.formSubmitValue_insert = "Add Salesperson Commission">
<cfset Variables.lang_insertCommissionCustomer.formSubmitValue_update = "Update Salesperson Commission">

<cfset Variables.lang_insertCommissionCustomer.errorTitle_insert = "The salesperson commission record could not be added for the following reason(s):">
<cfset Variables.lang_insertCommissionCustomer.errorTitle_update = "The salesperson commission record could not be updated for the following reason(s):">
<cfset Variables.lang_insertCommissionCustomer.errorHeader = "">
<cfset Variables.lang_insertCommissionCustomer.errorFooter = "">
