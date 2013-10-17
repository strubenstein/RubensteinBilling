<cfparam Name="URL.newsletterID" Default="0">
<cfparam Name="URL.newsletterSubscriberID" Default="0">

<cfinclude template="security_newsletter.cfm">

<cfinclude template="../../view/v_newsletter/nav_newsletter.cfm">
<cfif IsDefined("URL.confirm_newsletter")>
	<cfinclude template="../../view/v_newsletter/confirm_newsletter.cfm">
</cfif>
<cfif IsDefined("URL.error_newsletter")>
	<cfinclude template="../../view/v_newsletter/error_newsletter.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listNewsletters">
	<cfinclude template="control_listNewsletters.cfm">
</cfcase>

<cfcase value="viewNewsletter">
	<cfinclude template="control_viewNewsletter.cfm">
</cfcase>

<cfcase value="insertNewsletter">
	<cfinclude template="control_insertNewsletter.cfm">
</cfcase>

<cfcase value="updateNewsletter">
	<cfinclude template="control_updateNewsletter.cfm">
</cfcase>

<cfcase value="listNewsletterSubscribers">
	<cfinclude template="control_listNewsletterSubscribers.cfm">
</cfcase>

<cfcase value="insertNewsletterSubscriber">
	<cfinclude template="control_insertNewsletterSubscriber.cfm">
</cfcase>

<cfcase value="updateNewsletterSubscriber">
	<cfinclude template="control_updateNewsletterSubscriber.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_newsletter = "invalidAction">
	<cfinclude template="../../view/v_newsletter/error_newsletter.cfm">
</cfdefaultcase>
</cfswitch>
