<cfset errorMessage_fields = StructNew()>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "subscriberID")>
	<cfif Form.subscriberID is not 0 and Not ListFind(ValueList(qry_selectSubscriberList.subscriberID), Form.subscriberID)>
		<cfset errorMessage_fields.subscriberID = Variables.lang_insertUpdatePaymentCredit.subscriberID>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "invoiceLineItemID")>
	<cfif Form.invoiceLineItemID is not "">
		<cfif Variables.displayInvoiceLineItemList is False>
			<cfset errorMessage_fields.invoiceLineItemID = Variables.lang_insertUpdatePaymentCredit.invoiceLineItemID_noInvoice>
		<cfelse>
			<cfloop Index="lineItemID" List="#Form.invoiceLineItemID#">
				<cfif Not ListFind(ValueList(qry_selectInvoiceLineItemList.invoiceLineItemID), lineItemID)>
					<cfset errorMessage_fields.invoiceLineItemID = Variables.lang_insertUpdatePaymentCredit.invoiceLineItemID_valid>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "subscriptionID")>
	<cfif Form.subscriptionID is not "">
		<cfif Variables.displaySubscriptionList is False>
			<cfset errorMessage_fields.subscriptionID = Variables.lang_insertUpdatePaymentCredit.subscriptionID_noSubscriber>
		<cfelse>
			<cfloop Index="subID" List="#Form.subscriptionID#">
				<cfif Not ListFind(ValueList(qry_selectSubscriptionList.subscriptionID), subID)>
					<cfset errorMessage_fields.subscriptionID = Variables.lang_insertUpdatePaymentCredit.subscriptionID_valid>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditStatus")>
	<cfif Not ListFind("0,1", Form.paymentCreditStatus)>
		<cfset errorMessage_fields.paymentCreditStatus = Variables.lang_insertUpdatePaymentCredit.paymentCreditStatus>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditRollover")>
	<cfif Not ListFind("0,1", Form.paymentCreditRollover)>
		<cfset errorMessage_fields.paymentCreditRollover = Variables.lang_insertUpdatePaymentCredit.paymentCreditRollover>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditNegativeInvoice")>
	<cfif Not ListFind("0,1", Form.paymentCreditNegativeInvoice)>
		<cfset errorMessage_fields.paymentCreditNegativeInvoice = Variables.lang_insertUpdatePaymentCredit.paymentCreditNegativeInvoice>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCategoryID")>
	<cfif Form.paymentCategoryID is not 0>
		<cfset payCatRow = ListFind(ValueList(qry_selectPaymentCategoryList.paymentCategoryID), Form.paymentCategoryID)>
		<cfif payCatRow is 0><!--- category does not exist --->
			<cfset errorMessage_fields.paymentCategoryID = Variables.lang_insertUpdatePaymentCredit.paymentCategoryID_valid>
		<!--- can only select inactive category if updating credit that previously selected this category (when active) --->
		<cfelseif qry_selectPaymentCategoryList.paymentCategoryStatus[payCatRow] is 0 and (Variables.doAction is "insertPaymentCredit" or Not IsDefined("qry_selectPaymentCredit") or Form.paymentCategoryID is not qry_selectPaymentCredit.paymentCategoryID)>
			<cfset errorMessage_fields.paymentCategoryID = Variables.lang_insertUpdatePaymentCredit.paymentCategoryID_inactive>
		</cfif>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditName")>
	<cfif Trim(Form.paymentCreditName) is "">
		<cfset errorMessage_fields.paymentCreditName = Variables.lang_insertUpdatePaymentCredit.paymentCreditName_blank>
	<cfelseif Len(Form.paymentCreditName) gt maxlength_PaymentCredit.paymentCreditName>
		<cfset errorMessage_fields.paymentCreditName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePaymentCredit.paymentCreditName_maxlength, "<<MAXLENGTH>>", maxlength_PaymentCredit.paymentCreditName, "ALL"), "<<LEN>>", Len(Form.paymentCreditName), "ALL")>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditAmount")>
	<cfif Not IsNumeric(Form.paymentCreditAmount)>
		<cfset Form.paymentCreditAmount = "">
		<cfset errorMessage_fields.paymentCreditAmount = Variables.lang_insertUpdatePaymentCredit.paymentCreditAmount_numeric>
	<cfelseif Find(".", Form.paymentCreditAmount) and Len(ListLast(Form.paymentCreditAmount, ".")) gt maxlength_PaymentCredit.paymentCreditAmount>
		<cfset errorMessage_fields.paymentCreditAmount = ReplaceNoCase(Variables.lang_insertUpdatePaymentCredit.paymentCreditAmount_maxlength, "<<MAXLENGTH>>", maxlength_PaymentCredit.paymentCreditAmount, "ALL")>
	<cfelseif Form.paymentCreditAmount lt 0>
		<cfset errorMessage_fields.paymentCreditAmount = Variables.lang_insertUpdatePaymentCredit.paymentCreditAmount_negative>
	<cfelseif Form.paymentCreditAmount is 0>
		<cfset errorMessage_fields.paymentCreditAmount = Variables.lang_insertUpdatePaymentCredit.paymentCreditAmount_processed>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditID_custom")>
	<cfif Len(Form.paymentCreditID_custom) gt maxlength_PaymentCredit.paymentCreditID_custom>
		<cfset errorMessage_fields.paymentCreditID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePaymentCredit.paymentCreditID_custom_maxlength, "<<MAXLENGTH>>", maxlength_PaymentCredit.paymentCreditID_custom, "ALL"), "<<LEN>>", Len(Form.paymentCreditID_custom), "ALL")>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentDescriptionCredit")>
	<cfif Len(Form.paymentCreditDescription) gt maxlength_PaymentCredit.paymentCreditDescription>
		<cfset errorMessage_fields.paymentCreditDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePaymentCredit.paymentCreditDescription_maxlength, "<<MAXLENGTH>>", maxlength_PaymentCredit.paymentCreditDescription, "ALL"), "<<LEN>>", Len(Form.paymentCreditDescription), "ALL")>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditAppliedMaximum")>
	<cfif Not Application.fn_IsIntegerNonNegative(Form.paymentCreditAppliedMaximum)>
		<cfset errorMessage_fields.paymentCreditAppliedMaximum = Variables.lang_insertUpdatePaymentCredit.paymentCreditAppliedMaximum_valid>
	<cfelseif Form.paymentCreditAppliedMaximum gt 0 and Form.paymentCreditAppliedCount gt Form.paymentCreditAppliedMaximum>
		<cfset errorMessage_fields.paymentCreditAppliedMaximum = ReplaceNoCase(Variables.lang_insertUpdatePaymentCredit.paymentCreditAppliedMaximum_count, "<<COUNT>>", Form.paymentCreditAppliedCount, "ALL")>
	</cfif>
</cfif>

<cfset Form.paymentCreditDateBegin = "">
<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditDateBegin")>
	<cfif Form.paymentCreditDateBegin_date is not "">
		<cfset dateBeginResponse = fn_FormValidateDateTime("payment credit begin", "paymentCreditDateBegin_date", Form.paymentCreditDateBegin_date, "", 12, "", 00, "", "am")>
		<cfif IsDate(dateBeginResponse)>
			<cfset Form.paymentCreditDateBegin = dateBeginResponse>
			<cfif Form.paymentCreditDateBegin_date is not DateFormat(Now(), "mm/dd/yyyy") and DateCompare(Now(), Form.paymentCreditDateBegin) is not -1>
				<cfset errorMessage_fields.paymentCreditDateBegin = Variables.lang_insertUpdatePaymentCredit.paymentCreditDateBegin_now>
			</cfif>
		<cfelseif Not IsStruct(dateBeginResponse)>
			<cfset errorMessage_fields.paymentCreditDateBegin = Variables.lang_insertUpdatePaymentCredit.paymentCreditDateBegin_valid>
		<cfelse><!--- IsStruct(dateBeginResponse) --->
			<cfloop Collection="#dateBeginResponse#" Item="field">
				<cfset errorMessage_fields["#field#"] = StructFind(dateBeginResponse, field)>
			</cfloop>
		</cfif>
	</cfif>
</cfif>

<cfset Form.paymentCreditDateEnd = "">
<cfif Variables.doAction is "insertPaymentCredit" or ListFind(Variables.updatePaymentFieldList, "paymentCreditDateEnd")>
	<cfif Form.paymentCreditDateEnd_date is not "">
		<cfset dateEndResponse = fn_FormValidateDateTime("payment credit end", "paymentCreditDateEnd_date", Form.paymentCreditDateEnd_date, "", 11, "", 59, "", "pm")>
		<cfif IsDate(dateEndResponse)>
			<cfset Form.paymentCreditDateEnd = dateEndResponse>
			<cfif Form.paymentCreditDateEnd_date is not DateFormat(Now(), "mm/dd/yyyy") and DateCompare(Now(), Form.paymentCreditDateEnd) is not -1>
				<cfset errorMessage_fields.paymentCreditDateEnd = Variables.lang_insertUpdatePaymentCredit.paymentCreditDateEnd_now>
			<cfelseif IsDate(Form.paymentCreditDateBegin) and DateCompare(Form.paymentCreditDateBegin, Form.paymentCreditDateEnd) is 1>
				<cfset errorMessage_fields.paymentCreditDateEnd = Variables.lang_insertUpdatePaymentCredit.paymentCreditDateEnd_begin>
			</cfif>
		<cfelseif Not IsStruct(dateEndResponse)>
			<cfset errorMessage_fields.paymentCreditDateEnd = Variables.lang_insertUpdatePaymentCredit.paymentCreditDateEnd_valid>
		<cfelse><!--- IsStruct(dateEndResponse) --->
			<cfloop Collection="#dateEndResponse#" Item="field">
				<cfset errorMessage_fields["#field#"] = StructFind(dateEndResponse, field)>
			</cfloop>
		</cfif>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertPaymentCredit">
		<cfset errorMessage_title = Variables.lang_insertUpdatePaymentCredit.errorTitle_insert>
	<cfelse><!--- updatePaymentCredit --->
		<cfset errorMessage_title = Variables.lang_insertUpdatePaymentCredit.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdatePaymentCredit.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdatePaymentCredit.errorFooter>
</cfif>
