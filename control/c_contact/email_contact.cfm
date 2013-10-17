<cfinclude template="../../include/function/fn_Email.cfm">
<cfset Variables.emailFrom = fn_EmailFrom(Form.contactFromName, Form.contactReplyTo)>
<cfset Variables.emailType = fn_EmailType(Form.contactHtml)>

<cfmail
	From="#Variables.emailFrom#"
	To="#Form.contactTo#"
	CC="#Form.contactCC#"
	BCC="#Form.contactBCC#"
	Subject="#Form.contactSubject#"
	Username="#Application.billingEmailUsername#"
	Password="#Application.billingEmailPassword#"
	Type="#Variables.emailType#">
<cfmailparam Name="Reply-To" Value="#Form.contactReplyTo#">
#Form.contactMessage#
</cfmail>

