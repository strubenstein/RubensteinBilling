<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_shipping#">
<cfcase value="insertShipping">Shipping record successfully added!</cfcase>
<cfcase value="updateShipping">Shipping record successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
