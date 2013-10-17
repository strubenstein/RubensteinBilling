<cfset errorMessage_fields = StructNew()>

<cfloop Index="field" List="#Variables.fields_boolean#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listSalesCommissions[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_numeric#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and (Not IsNumeric(Form[field]) or Form[field] lt 0)>
		<cfset errorMessage_fields[field] = Variables.lang_listSalesCommissions[field]>
	</cfif>
</cfloop>

<cfif IsDefined("Form.salesCommissionAmount_min") and IsNumeric(Form.salesCommissionAmount_min)
		and IsDefined("Form.salesCommissionAmount_max") and IsNumeric(Form.salesCommissionAmount_max)
		and Form.salesCommissionAmount_min gt Form.salesCommissionAmount_max>
	<cfset errorMessage_fields.salesCommissionAmount_max = Variables.lang_listSalesCommissions.salesCommissionAmount_minMax>
</cfif>

<cfif IsDefined("Form.salesCommissionBasisTotal_min") and IsNumeric(Form.salesCommissionBasisTotal_min)
		and IsDefined("Form.salesCommissionBasisTotal_max") and IsNumeric(Form.salesCommissionBasisTotal_max)
		and Form.salesCommissionBasisTotal_min gt Form.salesCommissionBasisTotal_max>
	<cfset errorMessage_fields.salesCommissionBasisTotal_max = Variables.lang_listSalesCommissions.salesCommissionBasisTotal_minMax>
</cfif>

<cfset Form.salesCommissionDateFrom = "">
<cfset dateBeginResponse = fn_FormValidateDateTime("begin", "salesCommissionDateFrom_date", Form.salesCommissionDateFrom_date, "salesCommissionDateFrom_hh", Form.salesCommissionDateFrom_hh, "salesCommissionDateFrom_mm", Form.salesCommissionDateFrom_mm, "salesCommissionDateFrom_tt", Form.salesCommissionDateFrom_tt)>
<cfif IsDate(dateBeginResponse)>
	<cfset Form.salesCommissionDateFrom = dateBeginResponse>
<cfelseif IsStruct(dateBeginResponse)>
	<cfloop Collection="#dateBeginResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.salesCommissionDateTo = "">
<cfset dateEndResponse = fn_FormValidateDateTime("end", "salesCommissionDateTo_date", Form.salesCommissionDateTo_date, "salesCommissionDateTo_hh", Form.salesCommissionDateTo_hh, "salesCommissionDateTo_mm", Form.salesCommissionDateTo_mm, "salesCommissionDateTo_tt", Form.salesCommissionDateTo_tt)>
<cfif IsDate(dateEndResponse)>
	<cfset Form.salesCommissionDateTo = dateEndResponse>
<cfelseif IsStruct(dateEndResponse)>
	<cfloop Collection="#dateEndResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.salesCommissionDateFrom) and IsDate(Form.salesCommissionDateTo)
		and DateCompare(Form.salesCommissionDateFrom, Form.salesCommissionDateTo) is not -1>
	<cfset errorMessage_fields.salesCommissionDateToFrom = Variables.lang_listSalesCommissions.salesCommissionDateToFrom>
</cfif>

<cfif IsDefined("Form.primaryTargetID") and Form.primaryTargetID is not "">
	<cfif Not Application.fn_IsIntegerList(Form.primaryTargetID)>
		<cfset errorMessage_fields.primaryTargetID = Variables.lang_listSalesCommissions.primaryTargetID_list>
	<cfelse>
		<cfloop Index="type" List="#Form.primaryTargetID#">
			<cfif Application.fn_GetPrimaryTargetKey(type) is "">
				<cfset errorMessage_fields.primaryTargetID = Variables.lang_listSalesCommissions.primaryTargetID_valid>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfif Form.affiliateID is not "" and Form.affiliateID is not 0>
	<cfloop Index="thisAffiliateID" List="#Form.affiliateID#">
		<cfif Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), thisAffiliateID)>
			<cfset errorMessage_fields.affiliateID = Variables.lang_listSalesCommissions.affiliateID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.cobrandID is not "" and Form.cobrandID is not 0>
	<cfloop Index="thisCobrandID" List="#Form.cobrandID#">
		<cfif Not ListFind(ValueList(qry_selectCobrandList.cobrandID), thisCobrandID)>
			<cfset errorMessage_fields.cobrandID = Variables.lang_listSalesCommissions.cobrandID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listSalesCommissions.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listSalesCommissions.queryPage>
</cfif>

<cfif Form.salesCommissionIsExported is not "" and Not ListFind("-1,0,1", Form.salesCommissionIsExported)>
	<cfset errorMessage_fields.salesCommissionIsExported = Variables.lang_listSalesCommissions.salesCommissionIsExported>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listSalesCommissions.errorTitle>
	<cfset errorMessage_header = Variables.lang_listSalesCommissions.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listSalesCommissions.errorFooter>
</cfif>

