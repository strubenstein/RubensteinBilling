<cfif IsDefined("URL.newsletterID") and IsDefined("qry_selectNewsletter")>
	<cfparam Name="Form.newsletterDescription" Default="#qry_selectNewsletter.newsletterDescription#">
	<cfparam Name="Form.contactID" Default="#qry_selectNewsletter.contactID#">
	<cfparam Name="Form.newsletterRecipientCount" Default="#qry_selectNewsletter.newsletterRecipientCount#">
	<cfparam Name="Form.newsletterCriteria" Default="#qry_selectNewsletter.newsletterCriteria#">
</cfif>

<cfparam Name="Form.newsletterDescription" Default="">
<cfparam Name="Form.contactID" Default="">
<cfparam Name="Form.newsletterRecipientCount" Default="">
<cfparam Name="Form.newsletterCriteria" Default="">

