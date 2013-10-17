<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_price#">
<cfcase value="invalidPrice">You did not specify a valid custom pricing option.</cfcase>
<cfcase value="bothProductAndCategory">The price cannot apply to both a category and a product.</cfcase>
<cfcase value="controlCategory">To specify a category price, you must start at the category page.</cfcase>
<cfcase value="controlProduct">To specify a product price, you must start at the product page.</cfcase>
<cfcase value="invalidTarget">You did not select a valid price target to change the status of.</cfcase>
<cfcase value="invalidTargetStatus0">The price target you selected is already disabled.</cfcase>
<cfcase value="invalidTargetStatus1">The price target you selected is already active.</cfcase>
<cfcase value="invalidAction">You did not specify a valid price function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>