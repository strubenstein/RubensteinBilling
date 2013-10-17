<cfinvoke component="#Application.billingMapping#data.NewsletterSubscriber" method="maxlength_NewsletterSubscriber" returnVariable="maxlength_NewsletterSubscriber" />
<cfinclude template="formParam_insertUpdateNewsletterSubscriber.cfm">
<cfinclude template="../../view/v_newsletter/lang_insertUpdateNewsletterSubscriber.cfm">

<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCobrandList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#"><!--- companyID --->
	<cfif Session.companyID is not Session.companyID_author><!--- if cobrand user is logged in --->
		<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID_list#">
	</cfif>
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectAffiliateList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#"><!--- companyID --->
	<cfif Session.companyID is not Session.companyID_author><!--- if cobrand user is logged in --->
		<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID_list#">
	</cfif>
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitNewsletterSubscriber")>
	<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
	<cfinclude template="formValidate_insertUpdateNewsletterSubscriber.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- 
		If email and cobrand did not change, ok
		If did changed, update if:
			- delete existing subscriber
			- insert (which tests for existing email)
		--->

		<cfif Form.newsletterSubscriberEmail is qry_selectNewsletterSubscriber.newsletterSubscriberEmail and Form.cobrandID is qry_selectNewsletterSubscriber.cobrandID>
			<cfinvoke Component="#Application.billingMapping#data.NewsletterSubscriber" Method="updateNewsletterSubscriber" ReturnVariable="isNewsletterSubscriberUpdated">
				<cfinvokeargument Name="newsletterSubscriberID" Value="#URL.newsletterSubscriberID#">
				<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
				<cfinvokeargument Name="newsletterSubscriberEmail" Value="#Form.newsletterSubscriberEmail#">
				<cfinvokeargument Name="cobrandID" Value="#Form.cobrandID#">
				<cfinvokeargument Name="affiliateID" Value="#Form.affiliateID#">
				<cfinvokeargument Name="newsletterSubscriberStatus" Value="#Form.newsletterSubscriberStatus#">
				<cfinvokeargument Name="newsletterSubscriberHtml" Value="#Form.newsletterSubscriberHtml#">
			</cfinvoke>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.NewsletterSubscriber" Method="updateNewsletterSubscriber" ReturnVariable="isNewsletterSubscriberUpdated">
				<cfinvokeargument Name="newsletterSubscriberID" Value="#URL.newsletterSubscriberID#">
				<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
				<cfinvokeargument Name="newsletterSubscriberStatus" Value="0">
			</cfinvoke>

			<cfinvoke Component="#Application.billingMapping#data.NewsletterSubscriber" Method="insertNewsletterSubscriber" ReturnVariable="isNewsletterSubscriberUpdated">
				<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
				<cfinvokeargument Name="newsletterSubscriberEmail" Value="#Form.newsletterSubscriberEmail#">
				<cfinvokeargument Name="cobrandID" Value="#Form.cobrandID#">
				<cfinvokeargument Name="affiliateID" Value="#Form.affiliateID#">
				<cfinvokeargument Name="newsletterSubscriberStatus" Value="#Form.newsletterSubscriberStatus#">
				<cfinvokeargument Name="newsletterSubscriberHtml" Value="#Form.newsletterSubscriberHtml#">
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=newsletter.listNewsletterSubscribers&confirm_newsletter=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=#URL.method#&newsletterSubscriberID=#URL.newsletterSubscriberID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateNewsletterSubscriber.formSubmitValue_update>
<cfinclude template="../../view/v_newsletter/form_insertUpdateNewsletterSubscriber.cfm">
