<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_newsletter#">
<cfcase value="saveNewsletter">Newsletter successfully saved!</cfcase>
<cfcase value="sendNewsletter">Newsletter successfully sent!</cfcase>
<cfcase value="updateNewsletter">Newsletter successfully updated!</cfcase>
<cfcase value="deleteNewsletter">Newsletter successfully deleted.</cfcase>
<cfcase value="insertNewsletterSubscriber">Newsletter subscriber successfully added!</cfcase>
<cfcase value="updateNewsletterSubscriber">Newsletter subscriber successfully updated!</cfcase>
<cfcase value="deleteNewsletterSubscriber">Newsletter subscriber deleted.</cfcase>
<cfcase value="updateNewsletterSubscriberIsExported">Export status of newsletter subscriber records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
