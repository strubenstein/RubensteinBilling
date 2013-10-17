<cfset errorMessage_fields = StructNew()>

<cfif Form.cobrandID is not 0 and Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
	<cfset errorMessage_fields.cobrandID = Variables.lang_insertUpdateNewsletterSubscriber.cobrandID_valid>
</cfif>

<cfif Form.affiliateID is not 0 and Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
	<cfset errorMessage_fields.affiliateID = Variables.lang_insertUpdateNewsletterSubscriber.affiliateID_valid>
</cfif>

<cfif Not ListFind("0,1", Form.newsletterSubscriberStatus)>
	<cfset errorMessage_fields.newsletterSubscriberStatus = Variables.lang_insertUpdateNewsletterSubscriber.newsletterSubscriberStatus>
</cfif>

<cfif Not ListFind("0,1", Form.newsletterSubscriberHtml)>
	<cfset errorMessage_fields.newsletterSubscriberHtml = Variables.lang_insertUpdateNewsletterSubscriber.newsletterSubscriberHtml>
</cfif>

<cfif Variables.doAction is "insertNewsletterSubscriber"><!--- allow multiple email addresses --->
	<cfset Form.newsletterSubscriberEmail = Trim(Replace(Form.newsletterSubscriberEmail, Chr(10), ",", "ALL"))>
	<cfloop Index="email" List="#Form.newsletterSubscriberEmail#" Delimiters=",#Chr(10)#">
		<cfif Not fn_IsValidEmail(Trim(email))>
			<cfset errorMessage_fields.newsletterSubscriberEmail = Variables.lang_insertUpdateNewsletterSubscriber.newsletterSubscriberEmail_validMultiple & "<br>" & email>
			<cfbreak>
		<cfelseif Len(email) gt maxlength_NewsletterSubscriber.newsletterSubscriberEmail>
			<cfset errorMessage_fields.newsletterSubscriberEmail = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateNewsletterSubscriber.newsletterSubscriberEmail_maxlengthMultiple, "<<MAXLENGTH>>", maxlength_NewsletterSubscriber.newsletterSubscriberEmail, "ALL"), "<<LEN>>", Len(email), "ALL") & "<br>" & email>
			<cfbreak>
		</cfif>
	</cfloop>
<cfelseif Trim(Form.newsletterSubscriberEmail) is not "" and Not fn_IsValidEmail(Form.newsletterSubscriberEmail)>
	<cfset errorMessage_fields.newsletterSubscriberEmail = Variables.lang_insertUpdateNewsletterSubscriber.newsletterSubscriberEmail_valid>
<cfelseif Len(Form.newsletterSubscriberEmail) gt maxlength_NewsletterSubscriber.newsletterSubscriberEmail>
	<cfset errorMessage_fields.newsletterSubscriberEmail = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateNewsletterSubscriber.newsletterSubscriberEmail_maxlength, "<<MAXLENGTH>>", maxlength_NewsletterSubscriber.newsletterSubscriberEmail, "ALL"), "<<LEN>>", Len(Form.newsletterSubscriberEmail), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.newsletterSubscriberID is 0>
		<cfset errorMessage_title = Variables.lang_insertUpdateNewsletterSubscriber.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateNewsletterSubscriber.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateNewsletterSubscriber.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateNewsletterSubscriber.errorFooter>
</cfif>

