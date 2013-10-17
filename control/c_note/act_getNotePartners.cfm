<cfset methodStruct.displayPartners = False>
<cfset methodStruct.displayAffiliate = False>
<cfset methodStruct.displayCobrand = False>
<cfset methodStruct.displaySalesperson = False>
<cfset methodStruct.displayVendor = False>

<cfif ListFind("userID,companyID,invoiceID", Arguments.primaryTargetKey)>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_target#">
	</cfinvoke>

	<!--- get affiliate --->
	<cfif Application.fn_IsIntegerPositive(qry_selectCompany.affiliateID)>
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectAffiliateList">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="affiliateID" Value="#qry_selectCompany.affiliateID#">
			<cfinvokeargument Name="queryOrderBy" Value="affiliateName">
			<cfinvokeargument Name="queryDisplayPerPage" Value="0">
			<cfinvokeargument Name="queryPage" Value="0">
			<cfinvokeargument Name="returnCompanyFields" Value="False">
			<cfinvokeargument Name="returnUserFields" Value="True">
		</cfinvoke>

		<cfset methodStruct.displayPartners = True>
		<cfset methodStruct.displayAffiliate = True>
	</cfif>

	<!--- get cobrand --->
	<cfif Application.fn_IsIntegerPositive(qry_selectCompany.cobrandID)>
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCobrandList">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="cobrandID" Value="#qry_selectCompany.cobrandID#">
			<cfinvokeargument Name="queryOrderBy" Value="avCobrand.cobrandName">
			<cfinvokeargument Name="queryDisplayPerPage" Value="0">
			<cfinvokeargument Name="queryPage" Value="0">
			<cfinvokeargument Name="returnCompanyFields" Value="False">
			<cfinvokeargument Name="returnUserFields" Value="True">
		</cfinvoke>

		<cfset methodStruct.displayPartners = True>
		<cfset methodStruct.displayCobrand = True>
	</cfif>

	<!--- get salesperson(s) --->
	<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerList" ReturnVariable="qry_selectCommissionCustomerList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_target#">
	</cfinvoke>

	<cfif qry_selectCommissionCustomerList.RecordCount is not 0>
		<cfset methodStruct.displayPartners = True>
		<cfset methodStruct.displaySalesperson = False>
	</cfif>

	<!--- if invoice, get vendor(s) --->
	<cfif Arguments.primaryTargetKey is not "invoiceID">
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
			<cfinvokeargument Name="invoiceID" Value="#Arguments.targetID#">
		</cfinvoke>

		<cfset methodStruct.vendorID_list = ValueList(qry_selectInvoiceLineItemList.vendorID)>
		<cfif REFind("[1-9]", methodStruct.vendorID_list)>
			<cfset methodStruct.displayPartners = True>
			<cfset methodStruct.displayVendor = True>
			<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
				<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
				<cfinvokeargument Name="vendorID" Value="#methodStruct.vendorID_list#">
				<cfinvokeargument Name="queryOrderBy" Value="vendorName">
				<cfinvokeargument Name="queryDisplayPerPage" Value="0">
				<cfinvokeargument Name="queryPage" Value="0">
				<cfinvokeargument Name="returnCompanyFields" Value="False">
				<cfinvokeargument Name="returnUserFields" Value="True">
				<cfinvokeargument Name="returnVendorDescription" Value="False">
			</cfinvoke>
		</cfif>
	</cfif>
</cfif>

