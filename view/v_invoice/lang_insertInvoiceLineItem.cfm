<cfset Variables.lang_insertInvoiceLineItem = StructNew()>

<cfset Variables.lang_insertInvoiceLineItem.formSubmitValue_insert = "Add Line Item">
<cfset Variables.lang_insertInvoiceLineItem.formSubmitValue_update = "Update Line Item">

<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemStatus = "You did not select a valid status for this line item.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemManual = "You did not select a valid option for whether this line item was created manually.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemOrder = "You did not select a valid order for this line item.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemQuantity_numeric = "You did not enter a valid number for the quantity.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemQuantity_negative = "You cannot enter a negative quantity.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemQuantity_maxlength = "The quantity may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemName_blank = "The line item name cannot be blank.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemName_maxlength = "The line item name must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemDescriptionHtml = "You did not select a valid option for whether the line item description is text or html.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemDescription_maxlength = "The line item description must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemProductID_custom = "The custom item ID must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertInvoiceLineItem.regionID = "You did not select a valid region.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemPriceNormal_numeric = "The normal price for this item must be a non-negative number.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemPriceNormal_maxlength = "The normal price for this item may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemDiscount_numeric = "The discount for this line item must be a non-negative number.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemDiscount_maxlength = "The discount for this line item may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemTotalTax_numeric = "The total tax for this line item must have a non-negative number.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemTotalTax_maxlength = "The total tax for this line item may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertInvoiceLineItem.categoryID = "You did not select a valid category for this product.">
<cfset Variables.lang_insertInvoiceLineItem.priceID_valid = "You did not select a valid custom price for this product.">
<cfset Variables.lang_insertInvoiceLineItem.priceID_minQuantityPerOrder = "The custom price selected requires a minimum quantity of <<QUANTITY>>.">
<cfset Variables.lang_insertInvoiceLineItem.priceID_maxQuantityPerCustomerReached = "The maximum quantity per customer (<<QUANTITY>>) for the selected custom price has already been reached for this customer.<br>Please select a different price option.">
<cfset Variables.lang_insertInvoiceLineItem.priceID_maxQuantityPerCustomerSplit = "The maximum quantity per customer (<<QUANTITY>>) for the selected custom price has only <<REMAINING>> quantity available.<br>You may use this custom price for the remaining quantity available, but you must create<br>a separate line item for the remaining <<REMAINDER>> quantity.">
<cfset Variables.lang_insertInvoiceLineItem.priceID_maxQuantityAllCustomersReached = "The maximum quantity for all customers (<<QUANTITY>>) for the selected custom price has already been reached.<br>Please select a different price option.">
<cfset Variables.lang_insertInvoiceLineItem.priceID_maxQuantityAllCustomersSplit = "The maximum quantity for all customers (<<QUANTITY>>) for the selected custom price has only <<REMAINING>> quantity available.<br>You may use this custom price for the remaining quantity available, but you must create<br>a separate line item for the remaining <<REMAINDER>> quantity.">
<cfset Variables.lang_insertInvoiceLineItem.productParameterID_required = "You did not select all required product parameters.">
<cfset Variables.lang_insertInvoiceLineItem.productParameterID_blank = "You did not select all required product parameters.">
<cfset Variables.lang_insertInvoiceLineItem.productParameterID_valid = "You did not select a valid parameter option for each product parameter.">
<cfset Variables.lang_insertInvoiceLineItem.productParameterID_excluded = "The combination of parameters you selected is not available.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemPriceUnit_numeric = "The unit price must be a non-negative number.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemPriceUnit_maxlength = "The unit price may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertInvoiceLineItem.invoiceLineItemDateEnd = "The end date must be after the begin date.">
<cfset Variables.lang_insertInvoiceLineItem.userID = "You did not select a valid contact user for this line item.">

<cfset Variables.lang_insertInvoiceLineItem.errorTitle_insert = "The line item could not be added for the following reason(s):">
<cfset Variables.lang_insertInvoiceLineItem.errorTitle_update = "The line item could not be updated for the following reason(s):">
<cfset Variables.lang_insertInvoiceLineItem.errorHeader = "">
<cfset Variables.lang_insertInvoiceLineItem.errorFooter = "">

