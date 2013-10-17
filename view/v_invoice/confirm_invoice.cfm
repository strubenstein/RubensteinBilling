<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_invoice#">
<cfcase value="insertInvoice">Purchase/invoice successfully added!<br>You may add line items below.</cfcase>
<cfcase value="updateInvoice">Purchase/invoice successfully updated!</cfcase>
<cfcase value="insertInvoiceLineItem">Line item successfully added to purchase/invoice!</cfcase>
<cfcase value="updateInvoiceLineItem">Line item successfully updated.</cfcase>
<cfcase value="insertInvoiceLineItemStep">Line item successfully added to purchase/invoice!<br>Note: The custom price selected uses the step method for volume discounts.<br>Multiple line items were therefore created to reflect the appropriate quantity at each price level.</cfcase>
<cfcase value="updateInvoiceLineItemStep">Line item successfully updated.<br>Note: The custom price selected uses the step method for volume discounts.<br>Multiple line items were therefore created to reflect the appropriate quantity at each price level.</cfcase>
<cfcase value="updateInvoiceLineItemStatus">Line item is now inactive.<br>The invoice totals have been updated accordingly.</cfcase>
<cfcase value="updateInvoiceIsExported">Export status of invoice records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
