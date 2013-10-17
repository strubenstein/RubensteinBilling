<cfoutput>
<p class="SubTitle">Welcome #qry_selectAdminMain_user.firstName# #qry_selectAdminMain_user.lastName#<cfif qry_selectAdminMain_user.companyName is not ""> of #qry_selectAdminMain_user.companyName#</cfif></p>

<!--- 
Tasks
Contact Mgmt by Topic
Invoices
	Open
	##/$ yesterday/today/tomorrow/this week/last week/next week
	Awaiting non-automated payment
Subscriptions
	## Processed yesterday/today/tomorrow/this week/last week/next week
	Waiting for quantities
Payments/Credits/Refunds
	Payments: ##/$, accepted, rejected, scheduled
	Credits: ##/$ created, used
	Refunds: ##/$, accepted, rejected, scheduled
--->

<!--- select open tasks for the user from today or earlier --->
<cfif ListFind(Variables.permissionActionList, "listTasks") or ListFind(Variables.permissionActionList, "listContacts")>
	<cfif (ListFind(Variables.permissionActionList, "listTasks") and qry_selectAdminMain_task.RecordCount is not 0)
			or (ListFind(Variables.permissionActionList, "listContacts") and qry_selectAdminMain_contact.RecordCount is not 0)>
		<p><table border="0" cellspacing="2" cellpadding="2"><tr class="MainText" align="center" valign="top">
	</cfif>

	<cfif ListFind(Variables.permissionActionList, "listTasks") and qry_selectAdminMain_task.RecordCount is not 0>
		<td>
			<b>## of Tasks Not Yet Completed</b><br>
			<cfset Variables.chartQuery = "qry_selectAdminMain_task">
			<cfinclude template="#Variables.chartFile#">
		</td>
		<td width="30">&nbsp;</td>
	</cfif>

	<cfif ListFind(Variables.permissionActionList, "listContacts") and qry_selectAdminMain_contact.RecordCount is not 0>
		<td>
			<table border="0" cellspacing="0" cellpadding="3" class="TableText">
			<tr class="TableHeader"><td colspan="2">Open Contact Management Tickets by Topic</td></tr>
			<cfloop Query="qry_selectAdminMain_contact">
				<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
				<td>
					<cfif Application.fn_IsUserAuthorized("listContacts")>
						<a href="index.cfm?method=contact.listContacts&contactStatus=0&contactByCustomer=1&contactTopicID=#qry_selectAdminMain_contact.contactTopicID#" class="plainlink">#qry_selectAdminMain_contact.contactTopicName#</a></td>
					<cfelse>
						#qry_selectAdminMain_contact.contactTopicName#
					</cfif>
				<td>#qry_selectAdminMain_contact.contactCount#</td>
				</tr>
			</cfloop>
			</table>
		</td>
	</cfif>

	<cfif (ListFind(Variables.permissionActionList, "listTasks") and qry_selectAdminMain_task.RecordCount is not 0)
			or (ListFind(Variables.permissionActionList, "listContacts") and qry_selectAdminMain_contact.RecordCount is not 0)>
		</tr></table></p>
	</cfif>
</cfif>

<cfif ListFind(Variables.permissionActionList, "listSubscribers")>
	<cfif qry_selectAdminMain_subscriberProcessed.RecordCount is not 0 or qry_selectAdminMain_subscriberScheduled.RecordCount is not 0 or qry_selectAdminMain_subscriberQuantity.RecordCount is not 0>
		<p><table border="0" cellspacing="2" cellpadding="2"><tr class="MainText" align="center" valign="top">
	</cfif>

	<!--- Subscribers processed within the past week --->
	<cfif qry_selectAdminMain_subscriberProcessed.RecordCount is not 0>
		<td>
			<b>## of Subscribers Processed in Last 7 Days</b><br>
			<cfset Variables.chartQuery = "qry_selectAdminMain_subscriberProcessed">
			<cfinclude template="#Variables.chartFile#">
		</td>
		<td width="30">&nbsp;</td>
	</cfif>

	<!--- Subscribers scheduled to be processed within the coming week --->
	<cfif qry_selectAdminMain_subscriberScheduled.RecordCount is not 0>
		<td>
			<b>## of Subscribers Scheduled in Next 7 Days</b><br>
			<cfset Variables.chartQuery = "qry_selectAdminMain_subscriberScheduled">
			<cfinclude template="#Variables.chartFile#">
		</td>
		<td width="30">&nbsp;</td>
	</cfif>

	<!--- Subscribers waiting for final quantities to be processed --->
	<cfif qry_selectAdminMain_subscriberQuantity.RecordCount is not 0>
		<td>
			<b>## of Subscribers Awaiting Quantities</b><br>
			<cfset Variables.chartQuery = "qry_selectAdminMain_subscriberQuantity">
			<cfinclude template="#Variables.chartFile#">
		</td>
	</cfif>

	<cfif qry_selectAdminMain_subscriberProcessed.RecordCount is not 0 or qry_selectAdminMain_subscriberScheduled.RecordCount is not 0 or qry_selectAdminMain_subscriberQuantity.RecordCount is not 0>
		</tr></table></p>
	</cfif>
</cfif>

<cfif ListFind(Variables.permissionActionList, "listPayments")>
	<cfif qry_selectAdminMain_paymentSuccess.RecordCount is not 0 or qry_selectAdminMain_paymentReject.RecordCount is not 0 or qry_selectAdminMain_paymentScheduled.RecordCount is not 0>
		<p><table border="0" cellspacing="2" cellpadding="2"><tr class="MainText" align="center" valign="top">
	</cfif>

	<!--- Payments successfully processed within the past week --->
	<cfif qry_selectAdminMain_paymentSuccess.RecordCount is not 0>
		<td>
			<b>Amount and ## of Payments Approved In Last 7 Days</b><br>
			<cfset Variables.chartQuery = "qry_selectAdminMain_paymentSuccess">
			<cfinclude template="#Variables.chartFile#">
		</td>
		<td width="30">&nbsp;</td>
	</cfif>

	<!--- Payments rejected within the past week --->
	<cfif qry_selectAdminMain_paymentReject.RecordCount is not 0>
		<td>
			<b>Amount and ## of Payments Rejected In Last 7 Days</b><br>
			<cfset Variables.chartQuery = "qry_selectAdminMain_paymentReject">
			<cfinclude template="#Variables.chartFile#">
		</td>
		<td width="30">&nbsp;</td>
	</cfif>

	<!--- Payments scheduled to be made within the coming week --->
	<cfif qry_selectAdminMain_paymentScheduled.RecordCount is not 0>
		<td>
			<b>Amount and ## of Scheduled Payments In Next 7 Days</b><br>
			<cfset Variables.chartQuery = "qry_selectAdminMain_paymentScheduled">
			<cfinclude template="#Variables.chartFile#">
		</td>
	</cfif>

	<cfif qry_selectAdminMain_paymentSuccess.RecordCount is not 0 or qry_selectAdminMain_paymentReject.RecordCount is not 0 or qry_selectAdminMain_paymentScheduled.RecordCount is not 0>
		</tr></table></p>
	</cfif>
</cfif>

<cfif ListFind(Variables.permissionActionList, "listPaymentRefunds") or ListFind(Variables.permissionActionList, "listPaymentCredits")>
	<cfif (ListFind(Variables.permissionActionList, "listPaymentRefunds") and qry_selectAdminMain_paymentRefund.RecordCount is not 0)
			 or (ListFind(Variables.permissionActionList, "listPaymentCredits") and (qry_selectAdminMain_paymentCreditCreated.RecordCount is not 0 or qry_selectAdminMain_paymentCreditProcessed.RecordCount is not 0))>
		<p><table border="0" cellspacing="2" cellpadding="2"><tr class="MainText" align="center" valign="top">
	</cfif>

	<!--- Refunds processed within the past week --->
	<cfif ListFind(Variables.permissionActionList, "listPaymentRefunds") and qry_selectAdminMain_paymentRefund.RecordCount is not 0>
		<td>
			<cfset Variables.chartQuery = "qry_selectAdminMain_paymentRefund">
			<cfinclude template="#Variables.chartFile#">
		</td>
		<td width="30">&nbsp;</td>
	</cfif>

	<!--- Credits created within the past week --->
	<cfif ListFind(Variables.permissionActionList, "listPaymentCredits") and qry_selectAdminMain_paymentCreditCreated.RecordCount is not 0>
		<td>
			<cfset Variables.chartQuery = "qry_selectAdminMain_paymentCreditCreated">
			<cfinclude template="#Variables.chartFile#">
		</td>
		<td width="30">&nbsp;</td>
	</cfif>

	<!--- Credits processed within the past week --->
	<cfif ListFind(Variables.permissionActionList, "listPaymentCredits") and qry_selectAdminMain_paymentCreditProcessed.RecordCount is not 0>
		<td>
			<cfset Variables.chartQuery = "qry_selectAdminMain_paymentCreditProcessed">
			<cfinclude template="#Variables.chartFile#">
		</td>
	</cfif>

	<cfif (ListFind(Variables.permissionActionList, "listPaymentRefunds") and qry_selectAdminMain_paymentRefund.RecordCount is not 0)
			 or (ListFind(Variables.permissionActionList, "listPaymentCredits") and (qry_selectAdminMain_paymentCreditCreated.RecordCount is not 0 or qry_selectAdminMain_paymentCreditProcessed.RecordCount is not 0))>
		</tr></table></p>
	</cfif>
</cfif>

<cfif ListFind(Variables.permissionActionList, "listInvoices")>
	<cfif qry_selectAdminMain_invoice.RecordCount is not 0 or qry_selectAdminMain_invoiceUnpaid.RecordCount is not 0>
		<p><table border="0" cellspacing="2" cellpadding="2"><tr class="MainText" align="center" valign="top">
	</cfif>

	<!--- select invoices closed in last 7 days --->
	<cfif qry_selectAdminMain_invoice.RecordCount is not 0>
		<td>
			<b>Amount and ## of Invoices Closed in Last 7 Days</b><br>
			<cfset Variables.chartQuery = "qry_selectAdminMain_invoice">
			<cfinclude template="#Variables.chartFile#">
		</td>
		<td width="30">&nbsp;</td>
	</cfif>

	<!--- select ## of closed invoices that are not paid --->
	<cfif qry_selectAdminMain_invoiceUnpaid.RecordCount is not 0>
		<td>
			<b>Amount and ## of Unpaid Invoices From Last 7 Days</b><br>
			<cfset Variables.chartQuery = "qry_selectAdminMain_invoiceUnpaid">
			<cfinclude template="#Variables.chartFile#">
		</td>
	</cfif>

	<cfif qry_selectAdminMain_invoice.RecordCount is not 0 or qry_selectAdminMain_invoiceUnpaid.RecordCount is not 0>
		</tr></table></p>
	</cfif>
</cfif>
</cfoutput>
