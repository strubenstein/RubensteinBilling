<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_category#">
<cfcase value="invalidCategory">You did not specify a valid category.</cfcase>
<cfcase value="invalidAction">You did not specify a valid category function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>