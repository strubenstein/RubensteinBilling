<cfif URL.payflowID is not 0 and IsDefined("qry_selectPayflow")>
	<cfparam Name="Form.payflowName" Default="#qry_selectPayflow.payflowName#">
	<cfparam Name="Form.payflowID_custom" Default="#qry_selectPayflow.payflowID_custom#">
	<cfparam Name="Form.payflowStatus" Default="#qry_selectPayflow.payflowStatus#">
	<cfparam Name="Form.payflowInvoiceDaysFromSubscriberDate" Default="#qry_selectPayflow.payflowInvoiceDaysFromSubscriberDate#">
	<cfparam Name="Form.payflowChargeDaysFromSubscriberDate" Default="#qry_selectPayflow.payflowChargeDaysFromSubscriberDate#">
	<cfparam Name="Form.payflowRejectRescheduleDays" Default="#qry_selectPayflow.payflowRejectRescheduleDays#">
	<cfparam Name="Form.payflowRejectMaximum_company" Default="#qry_selectPayflow.payflowRejectMaximum_company#">
	<cfparam Name="Form.payflowRejectMaximum_invoice" Default="#qry_selectPayflow.payflowRejectMaximum_invoice#">
	<cfparam Name="Form.payflowRejectMaximum_subscriber" Default="#qry_selectPayflow.payflowRejectMaximum_subscriber#">
	<cfparam Name="Form.payflowDescription" Default="#qry_selectPayflow.payflowDescription#">
	<cfparam Name="Form.templateID" Default="#qry_selectPayflow.templateID#">
	<cfparam Name="Form.payflowEmailFromName" Default="#qry_selectPayflow.payflowEmailFromName#">
	<cfparam Name="Form.payflowEmailReplyTo" Default="#qry_selectPayflow.payflowEmailReplyTo#">
	<cfparam Name="Form.payflowEmailSubject" Default="#qry_selectPayflow.payflowEmailSubject#">
	<cfparam Name="Form.payflowEmailCC" Default="#qry_selectPayflow.payflowEmailCC#">
	<cfparam Name="Form.payflowEmailBCC" Default="#qry_selectPayflow.payflowEmailBCC#">

	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.payflowDefault" Default="#qry_selectPayflow.payflowDefault#">
		<cfparam Name="Form.payflowInvoiceSend" Default="#qry_selectPayflow.payflowInvoiceSend#">
		<cfparam Name="Form.payflowReceiptSend" Default="#qry_selectPayflow.payflowReceiptSend#">
		<cfparam Name="Form.payflowRejectNotifyCustomer" Default="#qry_selectPayflow.payflowRejectNotifyCustomer#">
		<cfparam Name="Form.payflowRejectNotifyAdmin" Default="#qry_selectPayflow.payflowRejectNotifyAdmin#">
		<cfparam Name="Form.payflowRejectTask" Default="#qry_selectPayflow.payflowRejectTask#">
	</cfif>
</cfif>

<cfparam Name="Form.payflowName" Default="">
<cfparam Name="Form.payflowID_custom" Default="">
<cfparam Name="Form.payflowStatus" Default="1">
<cfparam Name="Form.payflowInvoiceSend" Default="0">
<cfparam Name="Form.payflowReceiptSend" Default="0">
<cfparam Name="Form.payflowInvoiceDaysFromSubscriberDate" Default="">
<cfparam Name="Form.payflowChargeDaysFromSubscriberDate" Default="">
<cfparam Name="Form.payflowRejectNotifyCustomer" Default="0">
<cfparam Name="Form.payflowRejectNotifyAdmin" Default="0">
<cfparam Name="Form.payflowRejectRescheduleDays" Default="">
<cfparam Name="Form.payflowRejectMaximum_company" Default="">
<cfparam Name="Form.payflowRejectMaximum_invoice" Default="">
<cfparam Name="Form.payflowRejectMaximum_subscriber" Default="">
<cfparam Name="Form.payflowRejectTask" Default="0">
<cfparam Name="Form.payflowOrder" Default="0">
<cfparam Name="Form.payflowDescription" Default="">
<cfparam Name="Form.payflowEmailFromName" Default="">
<cfparam Name="Form.payflowEmailReplyTo" Default="">
<cfparam Name="Form.payflowEmailSubject" Default="">
<cfparam Name="Form.payflowEmailCC" Default="">
<cfparam Name="Form.payflowEmailBCC" Default="">

<cfloop Query="qry_selectTemplateList">
	<cfif qry_selectTemplateList.templateDefault is 1>
		<cfparam Name="Form.templateID" Default="#qry_selectTemplateList.templateID#">
		<cfbreak>
	</cfif>
</cfloop>
<cfparam Name="Form.templateID" Default="0">

<cfif qry_selectPayflowList.RecordCount lte 1>
	<cfparam Name="Form.payflowDefault" Default="1">
<cfelse>
	<cfparam Name="Form.payflowDefault" Default="0">
</cfif>

<cfloop Index="field" List="payflowInvoiceDaysFromSubscriberDate,payflowChargeDaysFromSubscriberDate,payflowRejectRescheduleDays,payflowRejectMaximum_company,payflowRejectMaximum_invoice,payflowRejectMaximum_subscriber">
	<cfif Form[field] is 0>
		<cfset Form[field] = "">
	</cfif>
</cfloop>
