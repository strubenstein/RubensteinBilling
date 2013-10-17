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
		Insert newsletter subscriber if:
			- not already a subscriber
			- not a registered user
		Update newsletter subscriber if already a subscriber (and html/status changed)
		Update user if already registered and not subscribed
		--->

		<cfloop Index="newEmail" List="#Trim(Form.newsletterSubscriberEmail)#" Delimiters=",">
			<cfinvoke Component="#Application.billingMapping#data.NewsletterSubscriber" Method="insertNewsletterSubscriber" ReturnVariable="isNewsletterSubscriberInserted">
				<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
				<cfinvokeargument Name="newsletterSubscriberEmail" Value="#Trim(newEmail)#">
				<cfinvokeargument Name="cobrandID" Value="#Form.cobrandID#">
				<cfinvokeargument Name="affiliateID" Value="#Form.affiliateID#">
				<cfinvokeargument Name="newsletterSubscriberStatus" Value="#Form.newsletterSubscriberStatus#">
				<cfinvokeargument Name="newsletterSubscriberHtml" Value="#Form.newsletterSubscriberHtml#">
			</cfinvoke>
		</cfloop>

		<cflocation url="index.cfm?method=#URL.method#&confirm_newsletter=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=#URL.method#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateNewsletterSubscriber.formSubmitValue_insert>
<cfinclude template="../../view/v_newsletter/form_insertUpdateNewsletterSubscriber.cfm">
