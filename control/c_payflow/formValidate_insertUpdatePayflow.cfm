<cfset errorMessage_fields = StructNew()>

<cfif Variables.doAction is "insertPayflow">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.payflowOrder) or Form.payflowOrder gt qry_selectPayflowList.RecordCount>
		<cfset errorMessage_fields.payflowOrder = Variables.lang_insertUpdatePayflow.payflowOrder>
	</cfif>
</cfif>

<cfloop Index="field" List="payflowStatus,payflowInvoiceSend,payflowReceiptSend,payflowRejectNotifyCustomer,payflowRejectNotifyAdmin,payflowRejectTask">
	<cfif Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_insertUpdatePayflow[field]>
	</cfif>
</cfloop>

<cfif Not ListFind("0,1", Form.payflowDefault)>
	<cfset errorMessage_fields.payflowDefault = Variables.lang_insertUpdatePayflow.payflowDefault_valid>
<cfelseif Form.payflowDefault is 1 and Form.payflowStatus is 0>
	<cfset errorMessage_fields.payflowDefault = Variables.lang_insertUpdatePayflow.payflowDefault_status>
<cfelseif Form.payflowDefault is 0>
	<cfif qry_selectPayflowList.RecordCount lte 1>
		<cfset errorMessage_fields.payflowDefault = Variables.lang_insertUpdatePayflow.payflowDefault_required>
	<cfelse>
		<!--- <cfset Variables.payflowRow = ListFind(ValueList(qry_selectPayflowList.payflowDefault), 1)> --->
		<cfset Variables.payflowRow = 0>
		<cfloop Query="qry_selectPayflowList">
			<cfif qry_selectPayflowList.payflowDefault is 1>
				<cfset Variables.payflowRow = CurrentRow>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfif Variables.payflowRow is 0><!--- no other defaults; so this must be --->
			<cfset errorMessage_fields.payflowDefault = Variables.lang_insertUpdatePayflow.payflowDefault_required>
		<!--- this is the default; cannot be turned off --->
		<cfelseif Variables.doAction is "updatePayflow" and qry_selectPayflowList.payflowID[Variables.payflowRow] is URL.payflowID>
			<cfset errorMessage_fields.payflowDefault = Variables.lang_insertUpdatePayflow.payflowDefault_change>
		</cfif>
	</cfif>
</cfif>

<cfif Trim(Form.payflowName) is "">
	<cfset errorMessage_fields.payflowName = Variables.lang_insertUpdatePayflow.payflowName_blank>
<cfelseif Len(Form.payflowOrder) gt maxlength_Payflow.payflowName>
	<cfset errorMessage_fields.payflowName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayflow.payflowName_maxlength, "<<MAXLENGTH>>", maxlength_Payment.payflowName, "ALL"), "<<LEN>>", Len(Form.payflowName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="checkPayflowNameIsUnique" ReturnVariable="isPayflowNameUnique">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="payflowName" Value="#Form.payflowName#">
		<cfif Variables.doAction is "updatePayflow">
			<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
		</cfif>
	</cfinvoke>

	<cfif isPayflowNameUnique is False>
		<cfset errorMessage_fields.payflowName = Variables.lang_insertUpdatePayflow.payflowName_unique>
	</cfif>
</cfif>

<cfif Form.payflowID_custom is not "">
	<cfif Len(Form.payflowID_custom) gt maxlength_Payflow.payflowID_custom>
		<cfset errorMessage_fields.payflowID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayflow.payflowID_custom_maxlength, "<<MAXLENGTH>>", maxlength_Payment.payflowID_custom, "ALL"), "<<LEN>>", Len(Form.payflowID_custom), "ALL")>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="checkPayflowID_customIsUnique" ReturnVariable="isPayflowID_customUnique">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
			<cfinvokeargument Name="payflowID_custom" Value="#Form.payflowID_custom#">
			<cfif Variables.doAction is "updatePayflow">
				<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
			</cfif>
		</cfinvoke>

		<cfif isPayflowID_customUnique is False>
			<cfset errorMessage_fields.payflowID_custom = Variables.lang_insertUpdatePayflow.payflowID_custom_unique>
		</cfif>
	</cfif>
</cfif>

<cfif Len(Form.payflowDescription) gt maxlength_Payflow.payflowDescription>
	<cfset errorMessage_fields.payflowDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayflow.payflowDescription_maxlength, "<<MAXLENGTH>>", maxlength_Payment.payflowDescription, "ALL"), "<<LEN>>", Len(Form.payflowDescription), "ALL")>
</cfif>

<cfif Form.payflowInvoiceSend is 0>
	<cfset Form.payflowInvoiceDaysFromSubscriberDate = "">
<cfelseif Form.payflowInvoiceDaysFromSubscriberDate is not "" and (Not Application.fn_IsIntegerNonNegative(Form.payflowInvoiceDaysFromSubscriberDate) or Form.payflowInvoiceDaysFromSubscriberDate gt 255)>
	<cfset errorMessage_fields.payflowInvoiceDaysFromSubscriberDate = Variables.lang_insertUpdatePayflow.payflowInvoiceDaysFromSubscriberDate_valid>
</cfif>

<cfif Form.payflowChargeDaysFromSubscriberDate is "">
	<cfset Form.payflowChargeDaysFromSubscriberDate = 0>
<cfelseif Not Application.fn_IsIntegerNonNegative(Form.payflowChargeDaysFromSubscriberDate) or Form.payflowChargeDaysFromSubscriberDate gt 255>
	<cfset errorMessage_fields.payflowChargeDaysFromSubscriberDate = Variables.lang_insertUpdatePayflow.payflowChargeDaysFromSubscriberDate_valid>
<!--- 
<cfelseif IsNumeric(Form.payflowInvoiceDaysFromSubscriberDate) and Form.payflowChargeDaysFromSubscriberDate lt Form.payflowInvoiceDaysFromSubscriberDate>
	<cfset errorMessage_fields.payflowChargeDaysFromSubscriberDate = Variables.lang_insertUpdatePayflow.payflowChargeDaysFromSubscriberDate_invoice>
--->
</cfif>

<cfif Form.payflowRejectRescheduleDays is not "" and (Not Application.fn_IsIntegerNonNegative(Form.payflowRejectRescheduleDays) or Form.payflowRejectRescheduleDays gt 255)>
	<cfset errorMessage_fields.payflowRejectRescheduleDays = Variables.lang_insertUpdatePayflow.payflowRejectRescheduleDays_valid>
</cfif>

<cfif Form.payflowRejectMaximum_company is not "" and (Not Application.fn_IsIntegerNonNegative(Form.payflowRejectMaximum_company) or Form.payflowRejectMaximum_company gt 255)>
	<cfset errorMessage_fields.payflowRejectMaximum_company = Variables.lang_insertUpdatePayflow.payflowRejectMaximum_company_valid>
</cfif>

<cfif Form.payflowRejectMaximum_subscriber is not "">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.payflowRejectMaximum_subscriber) or Form.payflowRejectMaximum_subscriber gt 255>
		<cfset errorMessage_fields.payflowRejectMaximum_subscriber = Variables.lang_insertUpdatePayflow.payflowRejectMaximum_subscriber_valid>
	<cfelseif IsNumeric(Form.payflowRejectMaximum_company) and Form.payflowRejectMaximum_subscriber gt Form.payflowRejectMaximum_company>
		<cfset errorMessage_fields.payflowRejectMaximum_subscriber = Variables.lang_insertUpdatePayflow.payflowRejectMaximum_subscriber_company>
	</cfif>
</cfif>

<cfif Form.payflowRejectMaximum_invoice is not "">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.payflowRejectMaximum_invoice) or Form.payflowRejectMaximum_invoice gt 255>
		<cfset errorMessage_fields.payflowRejectMaximum_invoice = Variables.lang_insertUpdatePayflow.payflowRejectMaximum_invoice_valid>
	<cfelseif IsNumeric(Form.payflowRejectMaximum_company) and Form.payflowRejectMaximum_invoice gt Form.payflowRejectMaximum_company>
		<cfset errorMessage_fields.payflowRejectMaximum_invoice = Variables.lang_insertUpdatePayflow.payflowRejectMaximum_invoice_company>
	<cfelseif IsNumeric(Form.payflowRejectMaximum_subscriber) and Form.payflowRejectMaximum_invoice gt Form.payflowRejectMaximum_subscriber>
		<cfset errorMessage_fields.payflowRejectMaximum_invoice = Variables.lang_insertUpdatePayflow.payflowRejectMaximum_invoice_subscriber>
	</cfif>
</cfif>

<cfif Form.templateID is not 0 and Not ListFind(ValueList(qry_selectTemplateList.templateID), Form.templateID)>
	<cfset errorMessage_fields.templateID = Variables.lang_insertUpdatePayflow.templateID>
</cfif>

<cfif Trim(Form.payflowEmailFromName) is "">
	<cfset errorMessage_fields.payflowEmailFromName = Variables.lang_insertUpdatePayflow.payflowEmailFromName_blank>
<cfelseif Len(Form.payflowEmailFromName) gt maxlength_Payflow.payflowEmailFromName>
	<cfset errorMessage_fields.payflowEmailFromName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayflow.payflowEmailFromName_maxlength, "<<MAXLENGTH>>", maxlength_Payment.payflowEmailFromName, "ALL"), "<<LEN>>", Len(Form.payflowEmailFromName), "ALL")>
</cfif>

<cfif Len(Form.payflowEmailSubject) gt maxlength_Payflow.payflowEmailSubject>
	<cfset errorMessage_fields.payflowEmailSubject = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayflow.payflowEmailSubject_maxlength, "<<MAXLENGTH>>", maxlength_Payment.payflowEmailSubject, "ALL"), "<<LEN>>", Len(Form.payflowEmailSubject), "ALL")>
</cfif>

<cfif Trim(Form.payflowEmailReplyTo) is "">
	<cfset errorMessage_fields.payflowEmailReplyTo = Variables.lang_insertUpdatePayflow.payflowEmailReplyTo_blank>
<cfelseif Len(Form.payflowEmailReplyTo) gt maxlength_Payflow.payflowEmailReplyTo>
	<cfset errorMessage_fields.payflowEmailReplyTo = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayflow.payflowEmailReplyTo_maxlength, "<<MAXLENGTH>>", maxlength_Payment.payflowEmailReplyTo, "ALL"), "<<LEN>>", Len(Form.payflowEmailReplyTo), "ALL")>
<cfelseif Not fn_IsValidEmail(Form.payflowEmailReplyTo)>
	<cfset errorMessage_fields.payflowEmailReplyTo = Variables.lang_insertUpdatePayflow.payflowEmailReplyTo_valid>
</cfif>

<cfif Len(Form.payflowEmailCC) gt maxlength_Payflow.payflowEmailCC>
	<cfset errorMessage_fields.payflowEmailCC = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayflow.payflowEmailCC_maxlength, "<<MAXLENGTH>>", maxlength_Payment.payflowEmailCC, "ALL"), "<<LEN>>", Len(Form.payflowEmailCC), "ALL")>
<cfelseif Form.payflowEmailCC is not "">
	<cfloop Index="thisEmail" List="#Form.payflowEmailCC#" Delimiters=",">
		<cfif Not fn_IsValidEmail(thisEmail)>
			<cfset errorMessage_fields.payflowEmailCC = Variables.lang_insertUpdatePayflow.payflowEmailCC_valid>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Len(Form.payflowEmailBCC) gt maxlength_Payflow.payflowEmailBCC>
	<cfset errorMessage_fields.payflowEmailBCC = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayflow.payflowEmailBCC_maxlength, "<<MAXLENGTH>>", maxlength_Payment.payflowEmailBCC, "ALL"), "<<LEN>>", Len(Form.payflowEmailBCC), "ALL")>
<cfelseif Form.payflowEmailBCC is not "">
	<cfloop Index="thisEmail" List="#Form.payflowEmailBCC#" Delimiters=",">
		<cfif Not fn_IsValidEmail(thisEmail)>
			<cfset errorMessage_fields.payflowEmailBCC = Variables.lang_insertUpdatePayflow.payflowEmailBCC_valid>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
	<cfloop Index="field" List="payflowInvoiceDaysFromSubscriberDate,payflowChargeDaysFromSubscriberDate,payflowRejectRescheduleDays,payflowRejectMaximum_company,payflowRejectMaximum_invoice,payflowRejectMaximum_subscriber">
		<cfif Not IsNumeric(Form[field])>
			<cfset Form[field] = 0>
		</cfif>
	</cfloop>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertPayflow">
		<cfset errorMessage_title = Variables.lang_insertUpdatePayflow.errorTitle_insert>
	<cfelse><!--- updatePayflow --->
		<cfset errorMessage_title = Variables.lang_insertUpdatePayflow.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdatePayflow.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdatePayflow.errorFooter>
</cfif>
