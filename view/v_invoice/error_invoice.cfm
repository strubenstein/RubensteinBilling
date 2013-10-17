<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_invoice#">
<cfcase value="invalidInvoice">You did not specify a valid purchase/invoice.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="invalidUser">You did not specify a valid user.</cfcase>
<cfcase value="noInvoice">You did not specify a valid purchase/invoice.</cfcase>
<cfcase value="invalidAction">You did not specify a valid purchase/invoice function.</cfcase>
<cfcase value="insertInvoice">To create a new invoice, you must start at a company or user.</cfcase>
<cfcase value="noInvoiceLineItem">You did not specify a line item for this purchase/invoice.</cfcase>
<cfcase value="invalidInvoiceLineItem">You did not specify a valid line item for this purchase/invoice.</cfcase>
<cfcase value="invalidProduct">You did not select a valid product for the new line item.</cfcase>
<cfcase value="updateInactiveLineItem">You cannot update a line item that is already inactive.</cfcase>
<cfcase value="invoiceIsClosed">This invoice is closed. You may not make any changes to it.</cfcase>
<cfcase value="viewInvoiceTemplate">You do not have any invoice templates that can be used to view this invoice.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>