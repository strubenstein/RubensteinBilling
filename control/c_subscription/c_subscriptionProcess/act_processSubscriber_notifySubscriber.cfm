<cfif Not IsDefined("fn_IsValidEmail")>
	<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
</cfif>
<cfif Not IsDefined("fn_EmailFrom")>
	<cfinclude template="../../include/function/fn_Email.cfm">
</cfif>

<cfset Variables.emailFrom = fn_EmailFrom(qry_selectPayflow.payflowEmailFromName, qry_selectPayflow.payflowEmailReplyTo)>

<cfinvoke Component="#Application.billingMapping#data.SubscriberNotify" Method="selectSubscriberNotifyList" ReturnVariable="qry_selectSubscriberNotifyList">
	<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
	<cfinvokeargument Name="subscriberNotifyStatus" Value="1">
</cfinvoke>

<cfloop Query="qry_selectSubscriberNotifyList">
	<!--- subscriberNotifyEmailHtml --->
	<cfif fn_IsValidEmail(qry_selectSubscriberNotifyList.email) and qry_selectSubscriberNotifyList.subscriberNotifyEmail is 1>
<cfmail
	From="#Variables.emailFrom#"
	To="#qry_selectSubscriberNotifyList.email#"
	CC="#qry_selectPayflow.payflowEmailCC#"
	BCC="#qry_selectPayflow.payflowEmailBCC#"
	Subject="#qry_selectPayflow.payflowEmailSubject#"
	Username="#Application.billingEmailUsername#"
	Password="#Application.billingEmailPassword#"
	Type="html">
<cfmailparam Name="Reply-To" Value="#qry_selectPayflow.payflowEmailReplyTo#">
<html><body bgcolor="white" text="black" link="blue" vlink="blue" alink="purple">
#Variables.invoiceTemplateText#
</body></html>
</cfmail>
	</cfif>
</cfloop>

