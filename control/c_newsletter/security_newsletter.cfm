<cfif Not Application.fn_IsIntegerNonNegative(URL.newsletterID)>
	<cflocation url="index.cfm?method=newsletter.listNewsletters&error_newsletter=invalidNewsletter" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.newsletterSubscriberID)>
	<cflocation url="index.cfm?method=newsletter.listNewsletterSubscriberss&error_newsletter=invalidNewsletterSubscriber" AddToken="No">
<cfelseif URL.newsletterID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Newsletter" Method="checkNewsletterPermission" ReturnVariable="isNewsletterPermission">
		<cfinvokeargument Name="newsletterID" Value="#URL.newsletterID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isNewsletterPermission is True>
		<cfinvoke Component="#Application.billingMapping#data.Newsletter" Method="selectNewsletter" ReturnVariable="qry_selectNewsletter">
		<cfinvokeargument Name="newsletterID" Value="#URL.newsletterID#">
		</cfinvoke>
	<cfelse>
		<cflocation url="index.cfm?method=newsletter.listNewsletters&error_newsletter=invalidNewsletter" AddToken="No">
	</cfif>
<cfelseif URL.newsletterSubscriberID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.NewsletterSubscriber" Method="checkNewsletterSubscriberPermission" ReturnVariable="isNewsletterSubscriberPermission">
		<cfinvokeargument Name="newsletterSubscriberID" Value="#URL.newsletterSubscriberID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfif Session.companyID is not Session.companyID_author>
			<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID_list#">
			<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID_list#">
		</cfif>
	</cfinvoke>

	<cfif isNewsletterSubscriberPermission is True>
		<cfinvoke Component="#Application.billingMapping#data.NewsletterSubscriber" Method="selectNewsletterSubscriber" ReturnVariable="qry_selectNewsletterSubscriber">
		<cfinvokeargument Name="newsletterSubscriberID" Value="#URL.newsletterSubscriberID#">
		</cfinvoke>
	<cfelse>
		<cflocation url="index.cfm?method=newsletter.listNewsletterSubscribers&error_newsletter=invalidNewsletterSubscriber" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listNewsletters,insertNewsletter,listNewsletterSubscribers,insertNewsletterSubscriber", Variables.doAction)>
	<cfif Not FindNoCase("Subscribers", Variables.doAction)>
		<cflocation url="index.cfm?method=newsletter.listNewsletters&error_newsletter=noNewsletter" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=newsletter.listNewsletterSubscribers&error_newsletter=noNewsletterSubscriber" AddToken="No">
	</cfif>
</cfif>
