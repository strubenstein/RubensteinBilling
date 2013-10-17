<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_phone#">
<cfcase value="invalidPhone">You did not specify a valid phone number.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="invalidUser">You did not specify a valid user.</cfcase>
<cfcase value="noPhone">You did not specify a valid phone number.</cfcase>
<cfcase value="invalidAction">You did not specify a valid phone number function.</cfcase>
<cfcase value="invalidPhoneStatus">You cannot update an archived version of a phone number.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>