<cfset errorMessage_fields = StructNew()>

<!--- account for affiliate/cobrand/vendor later --->
<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
	<cfif Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.targetID)>
		<cfset errorMessage_fields.targetID = Variables.lang_insertCommissionCustomer.targetID_valid>
	</cfif>

	<cfif Form.userID is "">
		<cfset Form.userID = 0>
	<cfelseif Form.userID is not 0>
		<cfloop Index="theUserID" List="#Form.userID#">
			<cfif Not ListFind(ValueList(qry_selectUserCompanyList_customer.userID), theUserID)>
				<cfset errorMessage_fields.userID = Variables.lang_insertCommissionCustomer.userID>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>

	<cfif Form.subscriberID is "">
		<cfset Form.subscriberID = 0>
	<cfelseif Form.subscriberID is not 0>
		<cfloop Index="theSubscriberID" List="#Form.subscriberID#">
			<cfif Not ListFind(ValueList(qry_selectSubscriberList.subscriberID), theSubscriberID)>
				<cfset errorMessage_fields.subscriberID = Variables.lang_insertCommissionCustomer.subscriberID>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfif Not IsNumeric(Form.commissionCustomerPercent) or Form.commissionCustomerPercent lt 0 or Form.commissionCustomerPercent gt 100>
	<cfset errorMessage_fields.commissionCustomerPercent = Variables.lang_insertCommissionCustomer.commissionCustomerPercent_numeric>
<cfelseif Find(".", Form.commissionCustomerPercent) and Len(ListLast(Form.commissionCustomerPercent, ".")) gt maxlength_CommissionCustomer.commissionCustomerPercent>
	<cfset errorMessage_fields.commissionCustomerPercent = ReplaceNoCase(Variables.lang_insertCommissionCustomer.commissionCustomerPercent_maxlength, "<<MAXLENGTH>>", maxlength_CommissionCustomer.commissionCustomerPercent, "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.commissionCustomerPrimary)>
	<cfset errorMessage_fields.commissionCustomerPrimary = Variables.lang_insertCommissionCustomer.commissionCustomerPrimary>
</cfif>

<cfif Len(Form.commissionCustomerDescription) gt maxlength_CommissionCustomer.commissionCustomerDescription>
	<cfset errorMessage_fields.commissionCustomerDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertCommissionCustomer.commissionCustomerDescription_maxlength, "<<MAXLENGTH>>", maxlength_CommissionCustomer.commissionCustomerDescription, "ALL"), "<<LEN>>", Len(Form.commissionCustomerDescription), "ALL")>
</cfif>

<cfif Form.commissionCustomerDateBegin is "">
	<cfset Form.commissionCustomerDateBegin = DateFormat(Now(), "mm/dd/yyyy")>
<cfelseif Not IsDate(Form.commissionCustomerDateBegin)>
	<cfset errorMessage_fields.commissionCustomerDateBegin = Variables.lang_insertCommissionCustomer.commissionCustomerDateBegin_valid>
<!--- 
<cfelseif DateDiff("d", Now(), Form.commissionCustomerDateBegin) lt 0>
	<cfset errorMessage_fields.commissionCustomerDateBegin = Variables.lang_insertCommissionCustomer.commissionCustomerDateBegin_past>
--->
</cfif>

<cfif Form.commissionCustomerDateEnd is not "">
	<cfif Not IsDate(Form.commissionCustomerDateEnd)>
		<cfset errorMessage_fields.commissionCustomerDateEnd = Variables.lang_insertCommissionCustomer.commissionCustomerDateEnd_valid>
	<cfelseif DateDiff("d", Form.commissionCustomerDateEnd, Now()) lt 0>
		<cfset errorMessage_fields.commissionCustomerDateEnd = Variables.lang_insertCommissionCustomer.commissionCustomerDateEnd_past>
	<cfelseif IsDate(Form.commissionCustomerDateBegin) and DateCompare(Form.commissionCustomerDateBegin, Form.commissionCustomerDateEnd) is 1>
		<cfset errorMessage_fields.commissionCustomerDateEnd = Variables.lang_insertCommissionCustomer.commissionCustomerDateEnd_begin>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertCommissionCustomer">
		<cfset errorMessage_title = Variables.lang_insertCommissionCustomer.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertCommissionCustomer.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertCommissionCustomer.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertCommissionCustomer.errorFooter>
</cfif>
