<cfset errorMessage_fields = StructNew()>

<cfset Form.creditCardID = 0>
<cfset Form.bankID = 0>
<cfset Form.paymentCheckNumber = 0>
<cfset Form.paymentDateReceived = "">
<cfset Form.paymentDateScheduled = "">
<cfset Form.paymentMethod = "">

<cfif Not ListFind("0,1", Form.paymentStatus)>
	<cfset errorMessage_fields.paymentStatus = Variables.lang_insertUpdatePayment.paymentStatus>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "subscriberID")>
	<cfif Form.subscriberID is not 0 and Not ListFind(ValueList(qry_selectSubscriberList.subscriberID), Form.subscriberID)>
		<cfset errorMessage_fields.subscriberID = Variables.lang_insertUpdatePayment.subscriberID>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentRefund" or ListFind(Variables.updatePaymentFieldList, "invoiceLineItemID")>
	<cfif Form.invoiceLineItemID is not "">
		<cfif displayInvoiceLineItemList is False>
			<cfset errorMessage_fields.invoiceLineItemID = Variables.lang_insertUpdatePayment.invoiceLineItemID_noInvoice>
		<cfelse>
			<cfloop Index="lineItemID" List="#Form.invoiceLineItemID#">
				<cfif Not ListFind(ValueList(qry_selectInvoiceLineItemList.invoiceLineItemID), lineItemID)>
					<cfset errorMessage_fields.invoiceLineItemID = Variables.lang_insertUpdatePayment.invoiceLineItemID_valid>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>

<cfif Variables.doAction is "insertPaymentRefund" or ListFind(Variables.updatePaymentFieldList, "subscriptionID")>
	<cfif Form.subscriptionID is not "">
		<cfif displaySubscriptionList is False>
			<cfset errorMessage_fields.subscriptionID = Variables.lang_insertUpdatePayment.subscriptionID_noSubscriber>
		<cfelse>
			<cfloop Index="subID" List="#Form.subscriptionID#">
				<cfif Not ListFind(ValueList(qry_selectInvoiceLineItemList.subscriptionID), subID)>
					<cfset errorMessage_fields.subscriptionID = Variables.lang_insertUpdatePayment.subscriptionID_valid>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>

<cfif Form.paymentApproved is not "">
	<cfif Not ListFind("0,1", Form.paymentApproved)>
		<cfset errorMessage_fields.paymentApproved = Variables.lang_insertUpdatePayment.paymentApproved_valid>
	<cfelseif Form.paymentProcessed is not 0>
		<cfset errorMessage_fields.paymentApproved = Variables.lang_insertUpdatePayment.paymentApproved_processed>
	</cfif>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentID_custom")>
	<cfif Len(Form.paymentID_custom) gt maxlength_Payment.paymentID_custom>
		<cfset errorMessage_fields.paymentID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayment.paymentID_custom_maxlength, "<<MAXLENGTH>>", maxlength_Payment.paymentID_custom, "ALL"), "<<LEN>>", Len(Form.paymentID_custom), "ALL")>
	</cfif>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentCategoryID")>
	<cfif Form.paymentCategoryID is not 0>
		<cfset payCatRow = ListFind(ValueList(qry_selectPaymentCategoryList.paymentCategoryID), Form.paymentCategoryID)>
		<cfif payCatRow is 0><!--- category does not exist --->
			<cfset errorMessage_fields.paymentCategoryID = Variables.lang_insertUpdatePayment.paymentCategoryID_valid>
		<!--- can only select inactive category if updating payment that previously selected this category (when active) --->
		<cfelseif qry_selectPaymentCategoryList.paymentCategoryStatus[payCatRow] is 0 and (ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or Not IsDefined("qry_selectPaymentCredit") or Form.paymentCategoryID is not qry_selectPayment.paymentCategoryID)>
			<cfset errorMessage_fields.paymentCategoryID = Variables.lang_insertUpdatePayment.paymentCategoryID_inactive>
		</cfif>
	</cfif>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentDescription")>
	<cfif Len(Form.paymentDescription) gt maxlength_Payment.paymentDescription>
		<cfset errorMessage_fields.paymentDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayment.paymentDescription_maxlength, "<<MAXLENGTH>>", maxlength_Payment.paymentDescription, "ALL"), "<<LEN>>", Len(Form.paymentDescription), "ALL")>
	</cfif>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentAmount")>
	<cfif Not IsNumeric(Form.paymentAmount)>
		<cfset Form.paymentAmount = "">
		<cfset errorMessage_fields.paymentAmount = Variables.lang_insertUpdatePayment.paymentAmount_numeric>
	<cfelseif Find(".", Form.paymentAmount) and Len(ListLast(Form.paymentAmount, ".")) gt maxlength_Payment.paymentAmount>
		<cfset errorMessage_fields.paymentAmount = ReplaceNoCase(Variables.lang_insertUpdatePayment.paymentAmount_maxlength, "<<MAXLENGTH>>", maxlength_Payment.paymentAmount, "ALL")>
	<cfelseif Form.paymentAmount lt 0>
		<cfset errorMessage_fields.paymentAmount = Variables.lang_insertUpdatePayment.paymentAmount_negative>
	<cfelseif Form.paymentAmount is 0 and Form.paymentProcessed is not 0>
		<cfset errorMessage_fields.paymentAmount = Variables.lang_insertUpdatePayment.paymentAmount_processed>
	</cfif>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentDateReceived")>
	<cfif Variables.doAction is "insertPayment">
		<cfset dateReceivedText = "received">
	<cfelse><!--- insertPaymentRefund --->
		<cfset dateReceivedText = "refund processed">
	</cfif>

	<cfset dateBeginResponse = fn_FormValidateDateTime("payment #dateReceivedText#", "paymentDateReceived_date", Form.paymentDateReceived_date, "paymentDateReceived_hh", Form.paymentDateReceived_hh, "paymentDateReceived_mm", Form.paymentDateReceived_mm, "paymentDateReceived_tt", Form.paymentDateReceived_tt)>
	<cfif IsDate(dateBeginResponse)>
		<cfset Form.paymentDateReceived = dateBeginResponse>
	<cfelse><!--- IsStruct(dateBeginResponse) --->
		<cfloop Collection="#dateBeginResponse#" Item="field">
			<cfset errorMessage_fields["#field#"] = StructFind(dateBeginResponse, field)>
		</cfloop>
	</cfif>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentMethod")>
	<cfswitch expression="#Form.paymentMethod_select#">
	<cfcase value="cash,barter,services,credit card,bank">
		<cfset Form.paymentMethod = Form.paymentMethod_select>
	</cfcase>

	<cfcase value="check,certified check,cashier check">
		<cfset Form.paymentMethod = Form.paymentMethod_select>
		<cfset checkVar = "paymentCheckNumber_" & ListFirst(Form.paymentMethod_select, " ")>
		<cfif IsDefined("Form.#checkVar#") and Form[checkVar] is not "" and Not Application.fn_IsIntegerPositive(Form[checkVar])>
			<cfset errorMessage_fields[checkVar] = Variables.lang_insertUpdatePayment[checkVar]>
		</cfif>
	</cfcase>

	<cfcase value="other">
		<cfif Form.paymentMethod_text is "">
			<cfset Form.paymentMethod = Form.paymentMethod_select>
		<cfelseif Len(Form.paymentMethod_text) gt maxlength_Payment.paymentMethod>
			<cfset errorMessage_fields.paymentMethod = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePayment.paymentMethod_maxlength, "<<MAXLENGTH>>", maxlength_Payment.paymentMethod, "ALL"), "<<LEN>>", Len(Form.paymentMethod_text), "ALL")>
		<cfelse>
			<cfset Form.paymentMethod = Form.paymentMethod_text>
		</cfif>
	</cfcase>

	<cfdefaultcase><!--- bankID or creditCardID --->
		<cfif Find("creditCard", Form.paymentMethod_select)>
			<cfset Form.paymentMethod = "creditCard">
			<cfloop Query="qry_selectCreditCardList">
				<cfif Form.paymentMethod_select is "creditCard#qry_selectCreditCardList.creditCardID#">
					<cfset Form.creditCardID = qry_selectCreditCardList.creditCardID>
					<cfbreak>
				</cfif>
			</cfloop>

			<cfif Form.creditCardID is 0>
				<cfset errorMessage_fields.paymentMethod = Variables.lang_insertUpdatePayment.paymentMethod_creditCard>
			</cfif>

		<cfelseif Find("bank", Form.paymentMethod_select)>
			<cfset Form.paymentMethod = "bank">
			<cfloop Query="qry_selectBankList">
				<cfif Form.paymentMethod_select is "bank#qry_selectBankList.bankID#">
					<cfset Form.bankID = qry_selectBankList.bankID>
					<cfbreak>
				</cfif>
			</cfloop>

			<cfif Form.bankID is 0>
				<cfset errorMessage_fields.paymentMethod = Variables.lang_insertUpdatePayment.paymentMethod_bank>
			</cfif>

		<cfelse>
			<cfset errorMessage_fields.paymentMethod = Variables.lang_insertUpdatePayment.paymentMethod_valid>
		</cfif>
	</cfdefaultcase>
	</cfswitch>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "merchantAccountID")>
	<cfif Form.merchantAccountID is 0>
		<cfif Form.paymentProcessed is not 0>
			<cfset errorMessage_fields.merchantAccountID = Variables.lang_insertUpdatePayment.merchantAccountID_processed>
		</cfif>
	<cfelseif Not ListFind(ValueList(qry_selectMerchantAccountList.merchantAccountID), Form.merchantAccountID)>
		<cfset errorMessage_fields.merchantAccountID = Variables.lang_insertUpdatePayment.merchantAccountID_exist>
	</cfif>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "paymentDateScheduled")>
	<cfif Form.paymentProcessed is not "" and Not ListFind("0,1", Form.paymentProcessed)>
		<cfset errorMessage_fields.paymentProcessed = Variables.lang_insertUpdatePayment.paymentProcessed_valid>
	<cfelseif Form.paymentProcessed is not 0>
		<cfif Form.merchantAccountID is 0>
			<cfset errorMessage_fields.paymentProcessed = Variables.lang_insertUpdatePayment.paymentProcessed_merchant>
		<cfelseif Form.bankID is 0 and Form.creditCardID is 0>
			<cfset errorMessage_fields.paymentProcessed = Variables.lang_insertUpdatePayment.paymentProcessed_ccBank>
		</cfif>

		<cfif Form.paymentProcessed is ""><!--- scheduled --->
			<cfset dateBeginResponse = fn_FormValidateDateTime("payment scheduled", "paymentDateScheduled_date", Form.paymentDateScheduled_date, "paymentDateScheduled_hh", Form.paymentDateScheduled_hh, "paymentDateScheduled_mm", Form.paymentDateScheduled_mm, "paymentDateScheduled_tt", Form.paymentDateScheduled_tt)>
			<cfif IsDate(dateBeginResponse)>
				<cfset Form.paymentDateScheduled = dateBeginResponse>
	
				<cfif DateCompare(Now(), Form.paymentDateScheduled) is not -1>
					<cfset errorMessage_fields.paymentDateScheduled = Variables.lang_insertUpdatePayment.paymentDateScheduled_now>
				</cfif>
			<cfelseif Not IsStruct(dateBeginResponse)>
				<cfset errorMessage_fields.paymentDateScheduled = Variables.lang_insertUpdatePayment.paymentDateScheduled_valid>
			<cfelse><!--- IsStruct(dateBeginResponse) --->
				<cfloop Collection="#dateBeginResponse#" Item="field">
					<cfset errorMessage_fields["#field#"] = StructFind(dateBeginResponse, field)>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfswitch expression="#Variables.doAction#">
	<cfcase value="insertPayment"><cfset errorMessage_title = Variables.lang_insertUpdatePayment.errorTitle_insertPayment></cfcase>
	<cfcase value="insertPaymentRefund"><cfset errorMessage_title = Variables.lang_insertUpdatePayment.errorTitle_insertPaymentRefund></cfcase>
	<cfcase value="updatePayment"><cfset errorMessage_title = Variables.lang_insertUpdatePayment.errorTitle_updatePayment></cfcase>
	<cfdefaultcase><!--- updatePaymentRefund ---><cfset errorMessage_title = Variables.lang_insertUpdatePayment.errorTitle_updatePaymentRefund></cfdefaultcase>
	</cfswitch>
	<!--- 
	<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction)>
		<cfset errorMessage_title = Variables.lang_insertUpdatePayment.errorTitle_insert>
	<cfelse><!--- updatePayment --->
		<cfset errorMessage_title = Variables.lang_insertUpdatePayment.errorTitle_update>
	</cfif>
	--->
	<cfset errorMessage_header = Variables.lang_insertUpdatePayment.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdatePayment.errorFooter>
</cfif>
