<cfset errorMessage_fields = StructNew()>

<cfif ListFind("invoice,salesCommission", URL.control)>
	<cfswitch expression="#Form.primaryTargetKey#">
	<cfcase value="affiliateID">
		<cfif Not IsDefined("Form.affiliateID") or Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
			<cfset errorMessage_fields.affiliateID = Variables.lang_insertSalesCommission.affiliateID>
		<cfelse>
			<cfset targetID = Form.affiliateID>
		</cfif>
	</cfcase>
	<cfcase value="cobrandID">
		<cfif Not IsDefined("Form.cobrandID") or Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
			<cfset errorMessage_fields.cobrandID = Variables.lang_insertSalesCommission.cobrandID>
		<cfelse>
			<cfset targetID = Form.cobrandID>
		</cfif>
	</cfcase>
	<cfcase value="userID">
		<cfif Not IsDefined("Form.userID") or Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.userID)>
			<cfset errorMessage_fields.userID = Variables.lang_insertSalesCommission.userID>
		<cfelse>
			<cfset targetID = Form.userID>
		</cfif>
	</cfcase>
	<cfcase value="vendorID">
		<cfif Not IsDefined("Form.vendorID") or Not ListFind(ValueList(qry_selectVendorList.vendorID), Form.vendorID)>
			<cfset errorMessage_fields.vendorID = Variables.lang_insertSalesCommission.vendorID>
		<cfelse>
			<cfset targetID = Form.vendorID>
		</cfif>
	</cfcase>
	<cfdefaultcase>
		<cfset errorMessage_fields.primaryTargetKey = Variables.lang_insertSalesCommission.primaryTargetKey>
	</cfdefaultcase>
	</cfswitch>
</cfif>

	<!--- 
	<cfif ListLen(Form.primaryTargetID_targetID, "_") is not 2
			or Not Application.fn_IsIntegerPositive(ListFirst(Form.primaryTargetID_targetID, "_"))
			or Not Application.fn_IsIntegerPositive(ListLast(Form.primaryTargetID_targetID, "_"))
			or Application.fn_GetPrimaryTargetKey(ListFirst(Form.primaryTargetID_targetID, "_")) is "">
		<cfset errorMessage_fields.primaryTargetID_targetID = Variables.lang_insertSalesCommission.primaryTargetID_targetID_valid>
	<cfelse>
		<cfset Variables.thisTargetID = ListLast(Form.primaryTargetID_targetID, "_")>
		<cfswitch expression="#Application.fn_GetPrimaryTargetKey(ListFirst(Form.primaryTargetID_targetID, "_"))#">
		<cfcase value="affiliateID">
			<cfif Variables.thisTargetID is not qry_selectCompany.affiliateID>
				<cfset errorMessage_fields.primaryTargetID_targetID = Variables.lang_insertSalesCommission.primaryTargetID_targetID_affiliate>
			</cfif>
		</cfcase>
		<cfcase value="cobrandID">
			<cfif Variables.thisTargetID is not qry_selectCompany.cobrandID>
				<cfset errorMessage_fields.primaryTargetID_targetID = Variables.lang_insertSalesCommission.primaryTargetID_targetID_cobrand>
			</cfif>
		</cfcase>
		<cfcase value="userID">
			<cfif Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Variables.thisTargetID) and Not ListFind(ValueList(qry_selectCommissionCustomerList.targetID), Variables.thisTargetID)>
				<cfset errorMessage_fields.primaryTargetID_targetID = Variables.lang_insertSalesCommission.primaryTargetID_targetID_user>
			</cfif>
		</cfcase>
		<cfcase value="vendorID">
			<cfif Not ListFind(Variables.vendorID_list, Variables.thisTargetID)>
				<cfset errorMessage_fields.primaryTargetID_targetID = Variables.lang_insertSalesCommission.primaryTargetID_targetID_vendor>
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfset errorMessage_fields.primaryTargetID_targetID = Variables.lang_insertSalesCommission.primaryTargetID_targetID_type>
		</cfdefaultcase>
		</cfswitch>
	</cfif>
	--->

<cfif Not IsNumeric(Form.salesCommissionAmount)>
	<cfset errorMessage_fields.salesCommissionAmount = Variables.lang_insertSalesCommission.salesCommissionAmount_numeric>
<cfelseif Find(".", Form.salesCommissionAmount) and Len(ListLast(Form.salesCommissionAmount, ".")) gt maxlength_SalesCommission.salesCommissionAmount>
	<cfset errorMessage_fields.salesCommissionAmount = ReplaceNoCase(Variables.lang_insertSalesCommission.salesCommissionAmount_maxlength, "<<MAXLENGTH>>", maxlength_SalesCommission.salesCommissionAmount, "ALL")>
</cfif>

<cfif Form.salesCommissionDateBegin is not "">
	<cfif Not IsDate(Form.salesCommissionDateBegin)>
		<cfset errorMessage_fields.salesCommissionDateBegin = Variables.lang_insertSalesCommission.salesCommissionDateBegin>
	<cfelse>
		<cfset Form.salesCommissionDateBegin = CreateDateTime(Year(Form.salesCommissionDateBegin), Month(Form.salesCommissionDateBegin), Day(Form.salesCommissionDateBegin), 00, 00, 00)>
	</cfif>
</cfif>

<cfif Form.salesCommissionDateEnd is not "">
	<cfif Not IsDate(Form.salesCommissionDateEnd)>
		<cfset errorMessage_fields.salesCommissionDateEnd = Variables.lang_insertSalesCommission.salesCommissionDateEnd>
	<cfelse>
		<cfset Form.salesCommissionDateEnd = CreateDateTime(Year(Form.salesCommissionDateEnd), Month(Form.salesCommissionDateEnd), Day(Form.salesCommissionDateEnd), 23, 59, 00)>

		<cfif IsDate(Form.salesCommissionDateBegin) and DateCompare(Form.salesCommissionDateBegin, Form.salesCommissionDateEnd) is not -1>
			<cfset errorMessage_fields.salesCommissionDateEnd = Variables.lang_insertSalesCommission.salesCommissionDateEnd_begin>
		</cfif>
	</cfif>
</cfif>

<cfif Form.salesCommissionPaid is not "" and Not ListFind("0,1", Form.salesCommissionPaid)>
	<cfset errorMessage_fields.salesCommissionPaid = Variables.lang_insertSalesCommission.salesCommissionPaid>
</cfif>

<cfif Form.salesCommissionBasisTotal is not "">
	<cfif Not IsNumeric(Form.salesCommissionBasisTotal)>
		<cfset errorMessage_fields.salesCommissionBasisTotal = Variables.lang_insertSalesCommission.salesCommissionBasisTotal_numeric>
	<cfelseif Find(".", Form.salesCommissionBasisTotal) and Len(ListLast(Form.salesCommissionBasisTotal, ".")) gt maxlength_SalesCommission.salesCommissionBasisTotal>
		<cfset errorMessage_fields.salesCommissionBasisTotal = ReplaceNoCase(Variables.lang_insertSalesCommission.salesCommissionBasisTotal_maxlength, "<<MAXLENGTH>>", maxlength_SalesCommission.salesCommissionBasisTotal, "ALL")>
	</cfif>
</cfif>

<cfif Form.salesCommissionBasisQuantity is not "">
	<cfif Not IsNumeric(Form.salesCommissionBasisQuantity)>
		<cfset errorMessage_fields.salesCommissionBasisQuantity = Variables.lang_insertSalesCommission.salesCommissionBasisQuantity_numeric>
	<cfelseif Find(".", Form.salesCommissionBasisQuantity) and Len(ListLast(Form.salesCommissionBasisQuantity, ".")) gt maxlength_SalesCommission.salesCommissionBasisQuantity>
		<cfset errorMessage_fields.salesCommissionBasisQuantity = ReplaceNoCase(Variables.lang_insertSalesCommission.salesCommissionBasisQuantity_maxlength, "<<MAXLENGTH>>", maxlength_SalesCommission.salesCommissionBasisQuantity, "ALL")>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_insertSalesCommission.errorTitle>
	<cfset errorMessage_header = Variables.lang_insertSalesCommission.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertSalesCommission.errorFooter>
</cfif>
