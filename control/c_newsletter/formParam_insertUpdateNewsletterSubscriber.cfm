<cfif URL.newsletterSubscriberID is not 0 and IsDefined("qry_selectNewsletterSubscriber")>
	<cfparam Name="Form.cobrandID" Default="#qry_selectNewsletterSubscriber.cobrandID#">
	<cfparam Name="Form.affiliateID" Default="#qry_selectNewsletterSubscriber.affiliateID#">
	<cfparam Name="Form.newsletterSubscriberHtml" Default="#qry_selectNewsletterSubscriber.newsletterSubscriberHtml#">
	<cfparam Name="Form.newsletterSubscriberEmail" Default="#qry_selectNewsletterSubscriber.newsletterSubscriberEmail#">
	<cfparam Name="Form.newsletterSubscriberStatus" Default="#qry_selectNewsletterSubscriber.newsletterSubscriberStatus#">
</cfif>

<cfparam Name="Form.cobrandID" Default="#ListFirst(Session.cobrandID_list)#">
<cfparam Name="Form.affiliateID" Default="#ListFirst(Session.affiliateID_list)#">
<cfparam Name="Form.newsletterSubscriberHtml" Default="1">
<cfparam Name="Form.newsletterSubscriberEmail" Default="">
<cfparam Name="Form.newsletterSubscriberStatus" Default="1">

