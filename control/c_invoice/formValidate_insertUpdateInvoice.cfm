<cfset errorMessage_fields = StructNew()>

<cfif Variables.doAction is "insertInvoice">
	<cfif Form.subscriberID is not 0 and Not ListFind(ValueList(qry_selectSubscriberList.subscriberID), Form.subscriberID)>
		<cfset errorMessage_fields.subscriberID = Variables.lang_insertUpdateInvoice.subscriberID>
	</cfif>
</cfif>

<cfif Variables.displayCompanyList is True and Not ListFind(ValueList(qry_selectUserCompanyList_user.companyID), Form.companyID)>
	<cfset errorMessage_fields.companyID = Variables.lang_insertUpdateInvoice.companyID>
</cfif>

<cfif Form.userID is not 0 and Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.userID)>
	<cfset errorMessage_fields.userID = Variables.lang_insertUpdateInvoice.userID>
</cfif>

<cfif Form.invoiceTotalLineItem is not "" and Not IsNumeric(Form.invoiceTotalLineItem)>
	<cfset errorMessage_fields.invoiceTotalLineItem = Variables.lang_insertUpdateInvoice.invoiceTotalLineItem_numeric>
<cfelseif Find(".", Form.invoiceTotalLineItem) and Len(ListLast(Form.invoiceTotalLineItem, ".")) gt maxlength_Invoice.invoiceTotalLineItem>
	<cfset errorMessage_fields.invoiceTotalLineItem = ReplaceNoCase(Variables.lang_insertUpdateInvoice.invoiceTotalLineItem_maxlength, "<<MAXLENGTH>>", maxlength_Invoice.invoiceTotalLineItem, "ALL")>
</cfif>

<cfif Form.invoiceTotalTax is not "" and Not IsNumeric(Form.invoiceTotalTax)>
	<cfset errorMessage_fields.invoiceTotalTax = Variables.lang_insertUpdateInvoice.invoiceTotalTax_numeric>
<cfelseif Find(".", Form.invoiceTotalTax) and Len(ListLast(Form.invoiceTotalTax, ".")) gt maxlength_Invoice.invoiceTotalTax>
	<cfset errorMessage_fields.invoiceTotalTax = ReplaceNoCase(Variables.lang_insertUpdateInvoice.invoiceTotalTax_maxlength, "<<MAXLENGTH>>", maxlength_Invoice.invoiceTotalTax, "ALL")>
</cfif>

<cfif Form.invoiceTotalShipping is not "" and Not IsNumeric(Form.invoiceTotalShipping)>
	<cfset errorMessage_fields.invoiceTotalShipping = Variables.lang_insertUpdateInvoice.invoiceTotalShipping_numeric>
<cfelseif Find(".", Form.invoiceTotalShipping) and Len(ListLast(Form.invoiceTotalShipping, ".")) gt maxlength_Invoice.invoiceTotalShipping>
	<cfset errorMessage_fields.invoiceTotalShipping = ReplaceNoCase(Variables.lang_insertUpdateInvoice.invoiceTotalShipping_maxlength, "<<MAXLENGTH>>", maxlength_Invoice.invoiceTotalShipping, "ALL")>
</cfif>

<cfif Form.invoiceTotalPaymentCredit is not "" and Not IsNumeric(Form.invoiceTotalPaymentCredit)>
	<cfset errorMessage_fields.invoiceTotalPaymentCredit = Variables.lang_insertUpdateInvoice.invoiceTotalPaymentCredit_numeric>
<cfelseif Find(".", Form.invoiceTotalPaymentCredit) and Len(ListLast(Form.invoiceTotalPaymentCredit, ".")) gt maxlength_Invoice.invoiceTotalPaymentCredit>
	<cfset errorMessage_fields.invoiceTotalPaymentCredit = ReplaceNoCase(Variables.lang_insertUpdateInvoice.invoiceTotalPaymentCredit_maxlength, "<<MAXLENGTH>>", maxlength_Invoice.invoiceTotalPaymentCredit, "ALL")>
</cfif>

<cfif Form.invoiceTotal is not "" and Not IsNumeric(Form.invoiceTotal)>
	<cfset errorMessage_fields.invoiceTotal = Variables.lang_insertUpdateInvoice.invoiceTotal_numeric>
<cfelseif Find(".", Form.invoiceTotal) and Len(ListLast(Form.invoiceTotal, ".")) gt maxlength_Invoice.invoiceTotal>
	<cfset errorMessage_fields.invoiceTotal = ReplaceNoCase(Variables.lang_insertUpdateInvoice.invoiceTotal_maxlength, "<<MAXLENGTH>>", maxlength_Invoice.invoiceTotal, "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.invoiceStatus)>
	<cfset errorMessage_fields.invoiceStatus = Variables.lang_insertUpdateInvoice.invoiceStatus>
</cfif>

<cfif Not ListFind("0,1,2", Form.invoiceClosed)>
	<cfset errorMessage_fields.invoiceClosed = Variables.lang_insertUpdateInvoice.invoiceClosed>
</cfif>

<!--- 
<cfif Not ListFind("0,1", Form.invoiceCompleted)>
	<cfset errorMessage_fields.invoiceCompleted = Variables.lang_insertUpdateInvoice.invoiceCompleted>
</cfif>
--->

<cfif Form.invoicePaid is not "" and Not ListFind("0,1", Form.invoicePaid)>
	<cfset errorMessage_fields.invoicePaid = Variables.lang_insertUpdateInvoice.invoicePaid>
</cfif>

<cfif Not ListFind("0,1", Form.invoiceShipped) and Form.invoiceShipped is not "">
	<cfset errorMessage_fields.invoiceShipped = Variables.lang_insertUpdateInvoice.invoiceShipped>
</cfif>

<cfif Not ListFind("0,1", Form.invoiceManual)>
	<cfset errorMessage_fields.invoiceManual = Variables.lang_insertUpdateInvoice.invoiceManual>
</cfif>

<cfif Not ListFind("0,1", Form.invoiceSent)>
	<cfset errorMessage_fields.invoiceSent = Variables.lang_insertUpdateInvoice.invoiceSent>
</cfif>

<cfif Form.invoiceShippingMethod is not "" and Not ListFind(Variables.shippingMethodList_value, Form.invoiceShippingMethod)>
	<cfset errorMessage_fields.invoiceShippingMethod = Variables.lang_insertUpdateInvoice.invoiceShippingMethodList_valid>
</cfif>

<cfif Len(Form.invoiceInstructions) gt maxlength_Invoice.invoiceInstructions>
	<cfset errorMessage_fields.invoiceInstructions = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateInvoice.invoiceInstructions_maxlength, "<<MAXLENGTH>>", maxlength_Invoice.invoiceInstructions, "ALL"), "<<LEN>>", Len(Form.invoiceInstructions), "ALL")>
</cfif>

<cfif Len(Form.invoiceID_custom) gt maxlength_Invoice.invoiceID_custom>
	<cfset errorMessage_fields.invoiceID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateInvoice.invoiceID_custom, "<<MAXLENGTH>>", maxlength_Invoice.invoiceID_custom, "ALL"), "<<LEN>>", Len(Form.invoiceID_custom), "ALL")>
</cfif>

<cfloop Index="dateField" List="#Variables.invoiceDateFieldList#">
	<cfset Form[dateField] = "">
	<cfif Form["#dateField#_date"] is not "">
		<cfset dateResponse = fn_FormValidateDateTime("begin", "#dateField#_date", Form["#dateField#_date"], "#dateField#_hh", Form["#dateField#_hh"], "#dateField#_mm", Form["#dateField#_mm"], "#dateField#_tt", Form["#dateField#_tt"])>
		<cfif IsDate(dateResponse)>
			<cfset Form[dateField] = dateResponse>
		<cfelse><!--- IsStruct(dateResponse) --->
			<cfloop Collection="#dateResponse#" Item="field">
				<cfset errorMessage_fields["#field#"] = StructFind(dateResponse, field)>
			</cfloop>
		</cfif>
	</cfif>
</cfloop>

<cfif Form.addressID_billing is not 0 and Not ListFind(ValueList(qry_selectBillingAddressList.addressID), Form.addressID_billing)>
	<cfset errorMessage_fields.addressID_billing = Variables.lang_insertUpdateInvoice.addressID_billing>
</cfif>

<cfif Form.addressID_shipping is not 0 and Not ListFind(ValueList(qry_selectShippingAddressList.addressID), Form.addressID_shipping)>
	<cfset errorMessage_fields.addressID_shipping = Variables.lang_insertUpdateInvoice.addressID_shipping>
</cfif>

<cfif Form.creditCardID is not 0 and Not ListFind(ValueList(qry_selectCreditCardList.creditCardID), Form.creditCardID)>
	<cfset errorMessage_fields.creditCardID = Variables.lang_insertUpdateInvoice.creditCardID>
</cfif>

<cfif Form.bankID is not 0 and Not ListFind(ValueList(qry_selectCreditCardList.bankID), Form.bankID)>
	<cfset errorMessage_fields.bankID = Variables.lang_insertUpdateInvoice.bankID>
</cfif>

<!--- Validate custom fields and custom status if applicable (and not via web service) --->
<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
	<cfif isCustomFieldValueExist is True>
		<cfinvoke component="#objInsertCustomFieldValue#" method="formValidate_insertCustomFieldValue" returnVariable="errorMessageStruct_customField" />
		<cfif Not StructIsEmpty(errorMessageStruct_customField)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_customField)>
		</cfif>
	</cfif>

	<cfif isStatusExist is True>
		<cfinvoke component="#objInsertStatusHistory#" method="formValidate_insertStatusHistory" returnVariable="errorMessageStruct_status" />
		<cfif Not StructIsEmpty(errorMessageStruct_status)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_status)>
		</cfif>
	</cfif>
</cfif>


<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertInvoice">
		<cfset errorMessage_title = Variables.lang_insertUpdateInvoice.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateInvoice.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateInvoice.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateInvoice.errorFooter>
</cfif>
