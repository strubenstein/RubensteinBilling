<cfset errorMessage_fields = StructNew()>

<cfloop Index="field" List="#Variables.fields_boolean#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPaymentCredits[field]>
	</cfif>
</cfloop>

<cfif Form.affiliateID is not "" and Form.affiliateID is not 0>
	<cfif Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
		<cfset errorMessage_fields.affiliateID = Variables.lang_listPaymentCredits.affiliateID>
	</cfif>
</cfif>

<cfif Form.cobrandID is not "" and Form.cobrandID is not 0>
	<cfif Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
		<cfset errorMessage_fields.cobrandID = Variables.lang_listPaymentCredits.cobrandID>
	</cfif>
</cfif>

<cfif Form.paymentCategoryID is not "" and Form.paymentCategoryID is not 0>
	<cfloop Index="payCatID" List="#Form.paymentCategoryID#">
		<cfif Not ListFind(ValueList(qry_selectPaymentCategoryList.paymentCategoryID), payCatID)>
			<cfset errorMessage_fields.paymentCategoryID = Variables.lang_listPaymentCredits.paymentCategoryID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfloop Index="field" List="userID_author,invoiceID">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not Application.fn_IsIntegerList(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPaymentCredits[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_integer#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not Application.fn_IsIntegerNonNegative(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPaymentCredits[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_numeric#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsNumeric(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPaymentCredits[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="paymentCreditDateBegin,paymentCreditDateBegin_from,paymentCreditDateBegin_to,paymentCreditDateEnd,paymentCreditDateEnd_from,paymentCreditDateEnd_to,paymentCreditDateCreated_from,paymentCreditDateCreated_to,paymentCreditDateUpdated_from,paymentCreditDateUpdated_to">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsDate(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPaymentCredits[field]>
	</cfif>
</cfloop>

<cfset Form.paymentCreditDateFrom = "">
<cfset dateBeginResponse = fn_FormValidateDateTime("begin", "paymentCreditDateFrom_date", Form.paymentCreditDateFrom_date, "paymentCreditDateFrom_hh", Form.paymentCreditDateFrom_hh, "paymentCreditDateFrom_mm", Form.paymentCreditDateFrom_mm, "paymentCreditDateFrom_tt", Form.paymentCreditDateFrom_tt)>
<cfif IsDate(dateBeginResponse)>
	<cfset Form.paymentCreditDateFrom = dateBeginResponse>
<cfelseif IsStruct(dateBeginResponse)>
	<cfloop Collection="#dateBeginResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.paymentCreditDateTo = "">
<cfset dateEndResponse = fn_FormValidateDateTime("end", "paymentCreditDateTo_date", Form.paymentCreditDateTo_date, "paymentCreditDateTo_hh", Form.paymentCreditDateTo_hh, "paymentCreditDateTo_mm", Form.paymentCreditDateTo_mm, "paymentCreditDateTo_tt", Form.paymentCreditDateTo_tt)>
<cfif IsDate(dateEndResponse)>
	<cfset Form.paymentCreditDateTo = dateEndResponse>
<cfelseif IsStruct(dateEndResponse)>
	<cfloop Collection="#dateEndResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.paymentCreditDateFrom) and IsDate(Form.paymentCreditDateTo)
		and DateCompare(Form.paymentCreditDateFrom, Form.paymentCreditDateTo) is not -1>
	<cfset errorMessage_fields.paymentCreditDateTo = Variables.lang_listPaymentCredits.paymentCreditDateTo>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listPaymentCredits.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listPaymentCredits.queryPage>
</cfif>

<cfif Form.paymentCreditIsExported is not "" and Not ListFind("-1,0,1", Form.paymentCreditIsExported)>
	<cfset errorMessage_fields.paymentCreditIsExported = Variables.lang_listPaymentCredits.paymentCreditIsExported>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listPaymentCredits.errorTitle>
	<cfset errorMessage_header = Variables.lang_listPaymentCredits.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listPaymentCredits.errorFooter>
</cfif>

