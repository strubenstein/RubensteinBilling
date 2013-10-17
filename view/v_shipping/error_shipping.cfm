<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_shipping#">
<cfcase value="invalidShipping">You did not specify a valid shipping record.</cfcase>
<cfcase value="invalidInvoice">You did not specify a valid purchase/invoice.</cfcase>
<cfcase value="noShipping">You did not specify a valid shipping record.</cfcase>
<cfcase value="invalidAction">You did not specify a valid shipping function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>