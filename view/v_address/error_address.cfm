<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_address#">
<cfcase value="invalidAddress">You did not specify a valid address.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="invalidUser">You did not specify a valid user.</cfcase>
<cfcase value="noAddress">You did not specify a valid address.</cfcase>
<cfcase value="invalidAction">You did not specify a valid address function.</cfcase>
<cfcase value="invalidAddressStatus">You cannot update an archived version of an address.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>