<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="selectPayflowList" ReturnVariable="qry_selectPayflowList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplateList" ReturnVariable="qry_selectTemplateList">
	<cfinvokeargument Name="companyID" Value="0,#Session.companyID_author#">
	<cfinvokeargument Name="templateType" Value="Invoice">
	<cfinvokeargument Name="returnTemplateXML" Value="False">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.Payflow" method="maxlength_Payflow" returnVariable="maxlength_Payflow" />
<cfinclude template="formParam_insertUpdatePayflow.cfm">
<cfinclude template="../../view/v_payflow/lang_insertUpdatePayflow.cfm">
<cfinclude template="../../include/function/fn_IsValidEmail.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPayflow")>
	<cfinclude template="formValidate_insertUpdatePayflow.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif Form.payflowDefault is 1>
			<!--- <cfset Variables.payflowRow = ListFind(ValueList(qry_selectPayflowList.payflowDefault), 1)> --->
			<cfset Variables.payflowRow = 0>
			<cfloop Query="qry_selectPayflowList">
				<cfif qry_selectPayflowList.payflowDefault is 1>
					<cfset Variables.payflowRow = CurrentRow>
					<cfbreak>
				</cfif>
			</cfloop>

			<cfif Variables.payflowRow is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="updatePayflow" ReturnVariable="isPayflowUpdated">
					<cfinvokeargument Name="payflowID" Value="#qry_selectPayflowList.payflowID[Variables.payflowRow]#">
					<cfinvokeargument Name="payflowDefault" Value="0">
				</cfinvoke>
			</cfif>
		</cfif>

		<cfif Variables.doAction is "insertPayflow">
			<cfset Variables.incrementPayflowOrder = False>
			<cfif qry_selectPayflowList.RecordCount is 0>
				<cfset Variables.payflowOrder = 1>
			<cfelseif Form.payflowOrder is 0>
				<cfset Variables.payflowOrder = qry_selectPayflowList.RecordCount + 1>
			<cfelse>
				<cfset Variables.incrementPayflowOrder = True>
				<cfset Variables.payflowOrder = Form.payflowOrder>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="insertPayflow" ReturnVariable="newPayflowID">
				<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="payflowName" Value="#Form.payflowName#">
				<cfinvokeargument Name="payflowID_custom" Value="#Form.payflowID_custom#">
				<cfinvokeargument Name="payflowDefault" Value="#Form.payflowDefault#">
				<cfinvokeargument Name="payflowStatus" Value="#Form.payflowStatus#">
				<cfinvokeargument Name="payflowInvoiceSend" Value="#Form.payflowInvoiceSend#">
				<cfinvokeargument Name="payflowReceiptSend" Value="#Form.payflowReceiptSend#">
				<cfinvokeargument Name="payflowInvoiceDaysFromSubscriberDate" Value="#Form.payflowInvoiceDaysFromSubscriberDate#">
				<cfinvokeargument Name="payflowChargeDaysFromSubscriberDate" Value="#Form.payflowChargeDaysFromSubscriberDate#">
				<cfinvokeargument Name="payflowRejectNotifyCustomer" Value="#Form.payflowRejectNotifyCustomer#">
				<cfinvokeargument Name="payflowRejectNotifyAdmin" Value="#Form.payflowRejectNotifyAdmin#">
				<cfinvokeargument Name="payflowRejectRescheduleDays" Value="#Form.payflowRejectRescheduleDays#">
				<cfinvokeargument Name="payflowRejectMaximum_company" Value="#Form.payflowRejectMaximum_company#">
				<cfinvokeargument Name="payflowRejectMaximum_invoice" Value="#Form.payflowRejectMaximum_invoice#">
				<cfinvokeargument Name="payflowRejectMaximum_subscriber" Value="#Form.payflowRejectMaximum_subscriber#">
				<cfinvokeargument Name="payflowRejectTask" Value="#Form.payflowRejectTask#">
				<cfinvokeargument Name="payflowDescription" Value="#Form.payflowDescription#">
				<cfinvokeargument Name="payflowOrder" Value="#Variables.payflowOrder#">
				<cfinvokeargument Name="incrementPayflowOrder" Value="#Variables.incrementPayflowOrder#">
				<cfinvokeargument Name="templateID" Value="#Form.templateID#">
				<cfinvokeargument Name="payflowEmailFromName" Value="#Form.payflowEmailFromName#">
				<cfinvokeargument Name="payflowEmailReplyTo" Value="#Form.payflowEmailReplyTo#">
				<cfinvokeargument Name="payflowEmailSubject" Value="#Form.payflowEmailSubject#">
				<cfinvokeargument Name="payflowEmailCC" Value="#Form.payflowEmailCC#">
				<cfinvokeargument Name="payflowEmailBCC" Value="#Form.payflowEmailBCC#">
			</cfinvoke>

			<cflocation url="index.cfm?method=payflow.listPayflows&confirm_payflow=#Variables.doAction#" AddToken="No">

		<cfelse><!--- update --->
			<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="updatePayflow" ReturnVariable="isPayflowUpdated">
				<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="payflowName" Value="#Form.payflowName#">
				<cfinvokeargument Name="payflowID_custom" Value="#Form.payflowID_custom#">
				<cfinvokeargument Name="payflowDefault" Value="#Form.payflowDefault#">
				<cfinvokeargument Name="payflowStatus" Value="#Form.payflowStatus#">
				<cfinvokeargument Name="payflowInvoiceSend" Value="#Form.payflowInvoiceSend#">
				<cfinvokeargument Name="payflowReceiptSend" Value="#Form.payflowReceiptSend#">
				<cfinvokeargument Name="payflowInvoiceDaysFromSubscriberDate" Value="#Form.payflowInvoiceDaysFromSubscriberDate#">
				<cfinvokeargument Name="payflowChargeDaysFromSubscriberDate" Value="#Form.payflowChargeDaysFromSubscriberDate#">
				<cfinvokeargument Name="payflowRejectNotifyCustomer" Value="#Form.payflowRejectNotifyCustomer#">
				<cfinvokeargument Name="payflowRejectNotifyAdmin" Value="#Form.payflowRejectNotifyAdmin#">
				<cfinvokeargument Name="payflowRejectRescheduleDays" Value="#Form.payflowRejectRescheduleDays#">
				<cfinvokeargument Name="payflowRejectMaximum_company" Value="#Form.payflowRejectMaximum_company#">
				<cfinvokeargument Name="payflowRejectMaximum_invoice" Value="#Form.payflowRejectMaximum_invoice#">
				<cfinvokeargument Name="payflowRejectMaximum_subscriber" Value="#Form.payflowRejectMaximum_subscriber#">
				<cfinvokeargument Name="payflowRejectTask" Value="#Form.payflowRejectTask#">
				<cfinvokeargument Name="payflowDescription" Value="#Form.payflowDescription#">
				<cfinvokeargument Name="templateID" Value="#Form.templateID#">
				<cfinvokeargument Name="payflowEmailFromName" Value="#Form.payflowEmailFromName#">
				<cfinvokeargument Name="payflowEmailReplyTo" Value="#Form.payflowEmailReplyTo#">
				<cfinvokeargument Name="payflowEmailSubject" Value="#Form.payflowEmailSubject#">
				<cfinvokeargument Name="payflowEmailCC" Value="#Form.payflowEmailCC#">
				<cfinvokeargument Name="payflowEmailBCC" Value="#Form.payflowEmailBCC#">
			</cfinvoke>

			<cflocation url="index.cfm?method=payflow.updatePayflow&payflowID=#URL.payflowID#&confirm_payflow=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPayflow">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePayflow.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePayflow.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_payflow/form_insertUpdatePayflow.cfm">
