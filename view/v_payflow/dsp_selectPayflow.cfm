<cfoutput>
<cfif qry_selectPayflow.payflowDefault is 1>
	<p class="MainText"><b>This is the default subscription processing method for all companies unless otherwise specified via group or company setting.</b></p>
</cfif>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td><cfif qry_selectPayflow.payflowStatus is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<tr>
	<td>Name: </td>
	<td>#qry_selectPayflow.payflowName#</td>
</tr>
<cfif qry_selectPayflow.payflowID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectPayflow.payflowID_custom#</td>
	</tr>
</cfif>
<cfif qry_selectPayflow.payflowDescription is not "">
	<tr valign="top">
		<td>Description: </td>
		<td>#qry_selectPayflow.payflowDescription#</td>
	</tr>
</cfif>
<tr valign="top">
	<td>Invoice: </td>
	<td>
		<cfif qry_selectPayflow.payflowInvoiceSend is 0>
			Invoice is not sent.
		<cfelseif qry_selectPayflow.payflowInvoiceDaysFromSubscriberDate is 0>
			Invoice is sent on subscriber processing date.
		<cfelse>
			Invoice is sent #qry_selectPayflow.payflowInvoiceDaysFromSubscriberDate# days after subscriber processing date.
		</cfif>
	</td>
</tr>
<tr valign="top">
	<td>Process Payment: </td>
	<td>
		<cfif qry_selectPayflow.payflowReceiptSend is 0>
			Receipt is not sent to customer.<br>
		<cfelse>
			Receipt is sent to customer if payment is successful (via customer-specified method).<br>
		</cfif>
		<cfif qry_selectPayflow.payflowChargeDaysFromSubscriberDate is 0>
			Payment is processed and/or due on subscriber processing date.
		<cfelse>
			Payment is processed and/or due #qry_selectPayflow.payflowChargeDaysFromSubscriberDate# days after subscriber processing date.
		</cfif>
	</td>
</tr>
<cfif qry_selectPayflow.templateID is not 0>
	<tr>
		<td>Invoice/Receipt Template: </td>
		<td>#qry_selectTemplate.templateName#</td>
	</tr>
</cfif>
<tr>
	<td>Email From: </td>
	<td>#qry_selectPayflow.payflowEmailFromName#</td>
</tr>
<tr>
	<td>Email Reply-To: </td>
	<td>#qry_selectPayflow.payflowEmailReplyTo#</td>
</tr>
<tr>
	<td>Email Subject: </td>
	<td>#qry_selectPayflow.payflowEmailSubject#</td>
</tr>
<cfif qry_selectPayflow.payflowEmailCC is not "">
	<tr>
		<td>Email CC: </td>
		<td>#qry_selectPayflow.payflowEmailCC#</td>
	</tr>
</cfif>
<cfif qry_selectPayflow.payflowEmailBCC is not "">
	<tr>
		<td>Email BCC: </td>
		<td>#qry_selectPayflow.payflowEmailBCC#</td>
	</tr>
</cfif>
<!--- 
<tr valign="top">
	<td>If Rejection: </td>
	<td>
		<cfif qry_selectPayflow.payflowRejectRescheduleDays is 0>
			Payment is not automatically re-scheduled.<br>
		<cfelse>
			Payment is re-scheduled for #qry_selectPayflow.payflowRejectRescheduleDays# days later.<br>
		</cfif>
		<cfif qry_selectPayflow.payflowRejectNotifyCustomer is 1>
			Notify customer (via customer-specified method)<br>
		</cfif>
		<cfif qry_selectPayflow.payflowRejectNotifyAdmin is 1>
			Notify designated admin user(s) (via user-specified method)<br>
		</cfif>
		<cfif qry_selectPayflow.payflowRejectTask is 1>
			Create <i>task</i> for designated admin user(s)<br>
		</cfif>
	</td>
</tr>
<tr><td colspan="2">Maximum rejections before manual action should be taken:</td></tr>
<tr>
	<td>Per Invoice: </td>
	<td><cfif qry_selectPayflow.payflowRejectMaximum_invoice is 0>No Limit<cfelse>#qry_selectPayflow.payflowRejectMaximum_invoice#</cfif> (for each invoice)</td>
</tr>
<tr>
	<td>Per Subscriber: </td>
	<td><cfif qry_selectPayflow.payflowRejectMaximum_subscriber is 0>No Limit<cfelse>#qry_selectPayflow.payflowRejectMaximum_subscriber#</cfif> (for all invoices processed for this customer subscriber setting)</td>
</tr>
<tr>
	<td>Per Customer: </td>
	<td><cfif qry_selectPayflow.payflowRejectMaximum_company is 0>No Limit<cfelse>#qry_selectPayflow.payflowRejectMaximum_company#</cfif> (for all invoices processed for this customer)</td>
</tr>
--->
</table>
</cfoutput>
