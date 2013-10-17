<cfmail
	From="""Billing, Inc."" <#Application.billingErrorReplyTo#>"
	To="#Form.email#"
	Subject="Account Help Request"
	Username="#Application.billingEmailUsername#"
	Password="#Application.billingEmailPassword#"
	Type="text">
<cfmailparam Name="Reply-To" Value="#Application.billingErrorReplyTo#">
You requested that your username be sent to you.

Your username is: #qry_checkForgetUsernameOrPassword.username#

</cfmail>

