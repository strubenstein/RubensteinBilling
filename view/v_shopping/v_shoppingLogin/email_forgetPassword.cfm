<cfmail
	From="""Billing, Inc."" <#Application.billingErrorReplyTo#>"
	To="#Form.email#"
	Subject="Account Help Request"
	Username="#Application.billingEmailUsername#"
	Password="#Application.billingEmailPassword#"
	Type="text">
<cfmailparam Name="Reply-To" Value="#Application.billingErrorReplyTo#">
Because you forgot your password, we have generated a random password for you. This is much more secure than sending your existing password to you.

Your new password is: #Variables.newPassword#

After logging in with your new password, you may change your password by clicking on MyAccount.

</cfmail>

