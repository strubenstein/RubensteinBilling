<cfinclude template="../../include/function/fn_Email.cfm">
<cfset Variables.emailFrom = fn_EmailFrom(Form.contactFromName, Form.contactReplyTo)>
<cfset Variables.emailType = fn_EmailType(Form.contactHtml)>

<cfloop Query="qry_selectNewsletterSubscriberList">
	<cfif Trim(qry_selectNewsletterSubscriberList.newsletterSubscriberEmail) is not "">
		<cfmail
			From="#Variables.emailFrom#"
			To="#qry_selectNewsletterSubscriberList.newsletterSubscriberEmail#"
			Subject="#Form.contactSubject#"
			Username="#Application.billingEmailUsername#"
			Password="#Application.billingEmailPassword#"
			Type="#Variables.emailType#">
<cfmailparam Name="Reply-To" Value="#Form.contactReplyTo#">
#Form.contactMessage#
		</cfmail>
	</cfif>
</cfloop>

