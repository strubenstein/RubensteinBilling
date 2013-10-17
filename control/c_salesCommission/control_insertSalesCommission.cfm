<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinvoke component="#Application.billingMapping#data.SalesCommission" method="maxlength_SalesCommission" returnVariable="maxlength_SalesCommission" />
<cfinclude template="formParam_insertSalesCommission.cfm">

<cfif URL.control is "salesCommission">
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectAffiliateList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCobrandList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	</cfinvoke>

<cfelseif URL.control is "invoice">
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliateList">
		<cfinvokeargument Name="affiliateID" Value="#qry_selectCompany.affiliateID#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrandList">
		<cfinvokeargument Name="cobrandID" Value="#qry_selectCompany.cobrandID#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
	</cfinvoke>

	<cfquery Name="qry_selectInvoiceLineItemList_vendors" DBType="query">
		SELECT DISTINCT(vendorID)
		FROM qry_selectInvoiceLineItemList
		WHERE vendorID <> 0
			AND vendorID IS NOT NULL
	</cfquery>

	<cfif qry_selectInvoiceLineItemList_vendors.RecordCount is 0>
		<cfset Variables.vendorID_list = 0>
	<cfelse>
		<cfset Variables.vendorID_list = ValueList(qry_selectInvoiceLineItemList_vendors.vendorID)>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendor" ReturnVariable="qry_selectVendorList">
		<cfinvokeargument Name="vendorID" Value="#ValueList(qry_selectInvoiceLineItemList_vendors.vendorID)#">
	</cfinvoke>

	<!--- Get salesperson(s) for this company --->
	<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerList" ReturnVariable="qry_selectCommissionCustomerList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfinvokeargument Name="companyID" Value="#qry_selectCompany.companyID#">
		<cfinvokeargument Name="commissionCustomerStatus" Value="1">
	</cfinvoke>
	<cfset Variables.userID_salespersonList = ValueList(qry_selectCommissionCustomerList.targetID)>
</cfif>

<cfif ListFind("invoice,salesCommission", URL.control)>
	<!--- Get all users for company --->
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="userCompanyStatus" Value="1">
	</cfinvoke>
</cfif>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitSalesCommission")>
	<cfinclude template="../../view/v_salesCommission/lang_insertSalesCommission.cfm">
	<cfinclude template="formValidate_insertSalesCommission.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="insertSalesCommission" ReturnVariable="newSalesCommissionID">
			<cfinvokeargument Name="commissionID" Value="0">
			<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Form.primaryTargetKey)#">
			<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="salesCommissionAmount" Value="#Form.salesCommissionAmount#">
			<cfinvokeargument Name="salesCommissionFinalized" Value="1">
			<cfinvokeargument Name="salesCommissionDateFinalized" Value="#Now()#">
			<cfinvokeargument Name="salesCommissionPaid" Value="#Form.salesCommissionPaid#">
			<cfif ListFind("0,1", Form.salesCommissionPaid)>
				<cfinvokeargument Name="salesCommissionDatePaid" Value="#Now()#">
			<cfelse>
				<cfinvokeargument Name="salesCommissionDatePaid" Value="">
			</cfif>
			<cfinvokeargument Name="salesCommissionStatus" Value="1">
			<cfinvokeargument Name="salesCommissionManual" Value="1">
			<cfinvokeargument Name="salesCommissionDateBegin" Value="#Form.salesCommissionDateBegin#">
			<cfinvokeargument Name="salesCommissionDateEnd" Value="#Form.salesCommissionDateEnd#">
			<cfif Form.salesCommissionBasisTotal is "">
				<cfinvokeargument Name="salesCommissionBasisTotal" Value="0">
			<cfelse>
				<cfinvokeargument Name="salesCommissionBasisTotal" Value="#Form.salesCommissionBasisTotal#">
			</cfif>
			<cfif Form.salesCommissionBasisQuantity is "">
				<cfinvokeargument Name="salesCommissionBasisQuantity" Value="0">
			<cfelse>
				<cfinvokeargument Name="salesCommissionBasisQuantity" Value="#Form.salesCommissionBasisQuantity#">
			</cfif>
			<cfinvokeargument Name="salesCommissionCalculatedAmount" Value="#Form.salesCommissionAmount#">
			<cfinvokeargument Name="commissionStageID" Value="0">
			<cfinvokeargument Name="commissionVolumeDiscountID" Value="0">
		</cfinvoke>

		<cfif URL.control is "invoice">
			<cfinvoke Component="#Application.billingMapping#data.SalesCommissionInvoice" Method="insertSalesCommissionInvoice" ReturnVariable="isSalesCommissionInvoiceInserted">
				<cfinvokeargument Name="salesCommissionID" Value="#newSalesCommissionID#">
				<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
				<cfinvokeargument Name="invoiceLineItemID" Value="0">
				<cfinvokeargument Name="salesCommissionInvoiceAmount" Value="0">
				<cfinvokeargument Name="salesCommissionInvoiceQuantity" Value="0">
				<cfif Form.primaryTargetKey is not "userID" or URL.control is not "invoice">
					<cfinvokeargument Name="commissionCustomerID" Value="0">
				<cfelse>
					<cfset Variables.customerRow = ListFind(ValueList(qry_selectCommissionCustomerList.targetID), Form.userID)>
					<cfif Variables.customerRow is 0>
						<cfinvokeargument Name="commissionCustomerID" Value="0">
					<cfelse>
						<cfinvokeargument Name="commissionCustomerID" Value="#qry_selectCommissionCustomerList.commissionCustomerID[Variables.customerRow]#">
					</cfif>
				</cfif>
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=#URL.method#.#Variables.doAction##Variables.urlParameters#&confirm_salesCommission=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "insertSalesCommission">
<cfset Variables.formAction = "index.cfm?method=#URL.method##Variables.urlParameters#">
<cfinclude template="../../view/v_salesCommission/form_insertSalesCommission.cfm">
