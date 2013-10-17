<cfset errorMessage_fields = StructNew()>

<cfif Form.paymentMethod_select is not "" >
	<cfset Form.paymentMethod = ListAppend(Form.paymentMethod, Form.paymentMethod_select)>
</cfif>
<cfif Form.paymentMethod_text is not "" >
	<cfset Form.paymentMethod = ListAppend(Form.paymentMethod, Form.paymentMethod_text)>
</cfif>

<cfif Form.paymentApproved is not "" and Not ListFind("-1,0,1", Form.paymentApproved)>
	<cfset errorMessage_fields.paymentApproved = Variables.lang_listPayments.paymentApproved>
</cfif>

<cfloop Index="field" List="#Variables.fields_boolean#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPayments[field]>
	</cfif>
</cfloop>

<cfif Form.affiliateID is not "" and Form.affiliateID is not 0>
	<cfif Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
		<cfset errorMessage_fields.affiliateID = Variables.lang_listPayments.affiliateID>
	</cfif>
</cfif>

<cfif Form.cobrandID is not "" and Form.cobrandID is not 0>
	<cfif Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
		<cfset errorMessage_fields.cobrandID = Variables.lang_listPayments.cobrandID>
	</cfif>
</cfif>

<cfif Form.paymentCategoryID is not "" and Form.paymentCategoryID is not 0>
	<cfloop Index="payCatID" List="#Form.paymentCategoryID#">
		<cfif Not ListFind(ValueList(qry_selectPaymentCategoryList.paymentCategoryID), payCatID)>
			<cfset errorMessage_fields.paymentCategoryID = Variables.lang_listPayments.paymentCategoryID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfloop Index="field" List="userID_author,invoiceID,creditCardID,bankID,merchantAccountID,paymentCheckNumber,subscriberID">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not Application.fn_IsIntegerList(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPayments[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_integer#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not Application.fn_IsIntegerNonNegative(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPayments[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_numeric#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsNumeric(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPayments[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="paymentDateReceived_from,paymentDateReceived_to,paymentDateCreated_from,paymentDateCreated_to,paymentDateUpdated_from,paymentDateUpdated_to,paymentDateScheduled_from,paymentDateScheduled_to">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsDate(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPayments[field]>
	</cfif>
</cfloop>

<cfset Form.paymentDateFrom = "">
<cfset dateBeginResponse = fn_FormValidateDateTime("begin", "paymentDateFrom_date", Form.paymentDateFrom_date, "paymentDateFrom_hh", Form.paymentDateFrom_hh, "paymentDateFrom_mm", Form.paymentDateFrom_mm, "paymentDateFrom_tt", Form.paymentDateFrom_tt)>
<cfif IsDate(dateBeginResponse)>
	<cfset Form.paymentDateFrom = dateBeginResponse>
<cfelseif IsStruct(dateBeginResponse)>
	<cfloop Collection="#dateBeginResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.paymentDateTo = "">
<cfset dateEndResponse = fn_FormValidateDateTime("end", "paymentDateTo_date", Form.paymentDateTo_date, "paymentDateTo_hh", Form.paymentDateTo_hh, "paymentDateTo_mm", Form.paymentDateTo_mm, "paymentDateTo_tt", Form.paymentDateTo_tt)>
<cfif IsDate(dateEndResponse)>
	<cfset Form.paymentDateTo = dateEndResponse>
<cfelseif IsStruct(dateEndResponse)>
	<cfloop Collection="#dateEndResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.paymentDateFrom) and IsDate(Form.paymentDateTo)
		and DateCompare(Form.paymentDateFrom, Form.paymentDateTo) is not -1>
	<cfset errorMessage_fields.paymentDateTo = Variables.lang_listPayments.paymentDateTo>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listPayments.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listPayments.queryPage>
</cfif>

<cfif Form.paymentIsExported is not "" and Not ListFind("-1,0,1", Form.paymentIsExported)>
	<cfset errorMessage_fields.paymentIsExported = Variables.lang_listPayments.paymentIsExported>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listPayments.errorTitle>
	<cfset errorMessage_header = Variables.lang_listPayments.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listPayments.errorFooter>
</cfif>

