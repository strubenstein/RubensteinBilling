<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_newsletter#">
<cfcase value="invalidNewsletter">You did not specify a valid newsletter.</cfcase>
<cfcase value="noNewsletter">You must specify a valid newsletter for this action.</cfcase>
<cfcase value="noNewsletterSubscriber">You must specify a valid newsletter subscriber for this action.</cfcase>
<cfcase value="invalidNewsletterSubscriber">You did not specify a valid newsletter subscriber.</cfcase>
<cfcase value="invalidAction">You did not specify a valid newsletter function.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this newsletter function.</cfcase>
<cfcase value="updateNewsletter">You cannot update a newsletter that has already been sent.<br>You may view the newsletter below.</cfcase>
<cfcase value="deleteNewsletter">You cannot delete a newsletter that has already been sent.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>