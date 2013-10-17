<cfset errorMessage_fields = StructNew()>

<cfset Form.invoiceDateFrom = "">
<cfset dateBeginResponse = fn_FormValidateDateTime("begin", "invoiceDateFrom_date", Form.invoiceDateFrom_date, "invoiceDateFrom_hh", Form.invoiceDateFrom_hh, "invoiceDateFrom_mm", Form.invoiceDateFrom_mm, "invoiceDateFrom_tt", Form.invoiceDateFrom_tt)>
<cfif IsDate(dateBeginResponse)>
	<cfset Form.invoiceDateFrom = dateBeginResponse>
<cfelseif IsStruct(dateBeginResponse)>
	<cfloop Collection="#dateBeginResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.invoiceDateTo = "">
<cfset dateEndResponse = fn_FormValidateDateTime("end", "invoiceDateTo_date", Form.invoiceDateTo_date, "invoiceDateTo_hh", Form.invoiceDateTo_hh, "invoiceDateTo_mm", Form.invoiceDateTo_mm, "invoiceDateTo_tt", Form.invoiceDateTo_tt)>
<cfif IsDate(dateEndResponse)>
	<cfset Form.invoiceDateTo = dateEndResponse>
<cfelseif IsStruct(dateEndResponse)>
	<cfloop Collection="#dateEndResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.invoiceDateFrom) and IsDate(Form.invoiceDateTo)
		and DateCompare(Form.invoiceDateFrom, Form.invoiceDateTo) is not -1>
	<cfset errorMessage_fields.invoiceDateTo = Variables.lang_listInvoices.invoiceDateTo>
</cfif>

<cfif Form.affiliateID is not "" and Form.affiliateID is not 0>
	<cfif Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
		<cfset errorMessage_fields.affiliateID = Variables.lang_listInvoices.affiliateID>
	</cfif>
</cfif>

<cfif Form.cobrandID is not "" and Form.cobrandID is not 0>
	<cfif Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
		<cfset errorMessage_fields.cobrandID = Variables.lang_listInvoices.cobrandID>
	</cfif>
</cfif>

<cfif Form.statusID is not "" and Form.statusID is not 0>
	<cfif Not ListFind(ValueList(qry_selectStatusList.statusID), Form.statusID)>
		<cfset errorMessage_fields.statusID = Variables.lang_listInvoices.statusID>
	</cfif>
</cfif>

<!--- if cobrand or affiliate partner, ensure they selected at least one cobrand or affiliate --->
<cfif Session.companyID is not Session.companyID_author and Not Application.fn_IsIntegerPositive(Form.cobrandID) and Not Application.fn_IsIntegerPositive(Form.affiliateID)>
	<cfif Session.cobrandID_list is not 0>
		<cfset Form.cobrandID = Session.cobrandID_list>
	<cfelse>
		<cfset Form.affiliateID = Session.affiliateID_list>
	</cfif>
</cfif>

<cfif Form.invoiceTotal_min is not "" and Not IsNumeric(Form.invoiceTotal_min)>
	<cfset errorMessage_fields.invoiceTotal_min = Variables.lang_listInvoices.invoiceTotal_min>
</cfif>

<cfif Form.invoiceTotal_max is not "" and Not IsNumeric(Form.invoiceTotal_max)>
	<cfset errorMessage_fields.invoiceTotal_max = Variables.lang_listInvoices.invoiceTotal_max>
</cfif>

<cfif Form.invoiceTotal_min is not "" and Form.invoiceTotal_max is not "" and StructIsEmpty(errorMessage_fields)
		and Form.invoiceTotal_min gt Form.invoiceTotal_max>
	<cfset errorMessage_fields.invoiceTotal_minMax = Variables.lang_listInvoices.invoiceTotal_minMax>
</cfif>

<cfif Form.invoiceShippingMethod is not "" and Not ListFind(Variables.shippingMethodList_value, Form.invoiceShippingMethod)>
	<cfset errorMessage_fields.invoiceShippingMethod = Variables.lang_listInvoices.invoiceShippingMethod>
</cfif>

<cfif Form.invoiceClosed is not "" and Not ListFind("0,1", Form.invoiceClosed)>
	<cfset errorMessage_fields.invoiceClosed = Variables.lang_listInvoices.invoiceClosed>
</cfif>

<cfif Form.invoicePaid is not "" and Not ListFind("0,1", Form.invoicePaid)>
	<cfset errorMessage_fields.invoicePaid = Variables.lang_listInvoices.invoicePaid>
</cfif>

<cfif Form.invoiceStatus is not "" and Not ListFind("0,1", Form.invoiceStatus)>
	<cfset errorMessage_fields.invoiceStatus = Variables.lang_listInvoices.invoiceStatus>
</cfif>

<cfif Form.invoiceSent is not "" and Not ListFind("0,1", Form.invoiceSent)>
	<cfset errorMessage_fields.invoiceSent = Variables.lang_listInvoices.invoiceSent>
</cfif>

<cfif Form.invoiceManual is not "" and Not ListFind("0,1", Form.invoiceManual)>
	<cfset errorMessage_fields.invoiceManual = Variables.lang_listInvoices.invoiceManual>
</cfif>

<cfif Form.invoiceShipped is not "" and Not ListFind("0,1", Form.invoiceShipped)>
	<cfset errorMessage_fields.invoiceShipped = Variables.lang_listInvoices.invoiceShipped>
</cfif>

<cfif Form.invoiceCompleted is not "" and Not ListFind("0,1", Form.invoiceCompleted)>
	<cfset errorMessage_fields.invoiceCompleted = Variables.lang_listInvoices.invoiceCompleted>
</cfif>

<cfif Form.invoiceHasMultipleItems is not "" and Not ListFind("0,1", Form.invoiceHasMultipleItems)>
	<cfset errorMessage_fields.invoiceHasMultipleItems = Variables.lang_listInvoices.invoiceHasMultipleItems>
</cfif>

<cfif Form.invoiceHasCustomPrice is not "" and Not ListFind("0,1", Form.invoiceHasCustomPrice)>
	<cfset errorMessage_fields.invoiceHasCustomPrice = Variables.lang_listInvoices.invoiceHasCustomPrice>
</cfif>

<cfif Form.invoiceHasCustomID is not "" and Not ListFind("0,1", Form.invoiceHasCustomID)>
	<cfset errorMessage_fields.invoiceHasCustomID = Variables.lang_listInvoices.invoiceHasCustomID>
</cfif>

<cfif Form.invoiceHasInstructions is not "" and Not ListFind("0,1", Form.invoiceHasInstructions)>
	<cfset errorMessage_fields.invoiceHasInstructions = Variables.lang_listInvoices.invoiceHasInstructions>
</cfif>

<cfif Form.invoiceHasPaymentCredit is not "" and Not ListFind("0,1", Form.invoiceHasPaymentCredit)>
	<cfset errorMessage_fields.invoiceHasPaymentCredit = Variables.lang_listInvoices.invoiceHasPaymentCredit>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listInvoices.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listInvoices.queryPage>
</cfif>

<cfif Form.invoiceIsExported is not "" and Not ListFind("-1,0,1", Form.invoiceIsExported)>
	<cfset errorMessage_fields.invoiceIsExported = Variables.lang_listInvoices.invoiceIsExported>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listInvoices.errorTitle>
	<cfset errorMessage_header = Variables.lang_listInvoices.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listInvoices.errorFooter>
</cfif>

