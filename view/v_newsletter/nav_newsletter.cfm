<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Newsletter: </span>
<cfif Application.fn_IsUserAuthorized("listNewsletters")><a href="index.cfm?method=newsletter.listNewsletters" title="List existing newsletters" class="SubNavLink<cfif Variables.doAction is "listNewsletters">On</cfif>">List Existing Newsletters</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertNewsletter")> | <a href="index.cfm?method=newsletter.insertNewsletter"  title="Create/send new newsletter" class="SubNavLink<cfif Variables.doAction is "insertNewsletter">On</cfif>">Create Newsletter</a></cfif>
<cfif Application.fn_IsUserAuthorized("listNewsletterSubscribers")> | <a href="index.cfm?method=newsletter.listNewsletterSubscribers" title="List existing newsletter subscribers" class="SubNavLink<cfif Variables.doAction is "listNewsletterSubscribers">On</cfif>">List Existing Newsletter Subscribers</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertNewsletterSubscriber")> | <a href="index.cfm?method=newsletter.insertNewsletterSubscriber" title="Create new newsletter subscriber" class="SubNavLink<cfif Variables.doAction is "insertNewsletterSubscriber">On</cfif>">Add Newsletter Subscriber</a></cfif>
</div><br>
</cfoutput>

