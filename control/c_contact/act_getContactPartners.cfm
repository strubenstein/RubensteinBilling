<cfset Variables.displayPartners = False>
<cfset Variables.displayAffiliate = False>
<cfset Variables.displayCobrand = False>
<cfset Variables.displaySalesperson = False>
<cfset Variables.displayVendor = False>
<cfset Variables.userID_list = "">
<cfset Variables.userEmailStruct = StructNew()>
<cfset Variables.displayUserEmail = False>

<cfset Variables.primaryTargetKey = Application.fn_GetPrimaryTargetKey(Variables.primaryTargetID)>
<cfif ListFind("userID,companyID,invoiceID", Variables.primaryTargetKey)>
	<cfif Variables.primaryTargetKey is not "companyID">
		<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
			<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
		</cfinvoke>
	</cfif>

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

		<cfset Variables.displayPartners = True>
		<cfset Variables.displayAffiliate = True>
		<cfset Variables.userID_list = ListAppend(Variables.userID_list, qry_selectAffiliateList.userID)>
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

		<cfset Variables.displayPartners = True>
		<cfset Variables.displayCobrand = True>
		<cfset Variables.userID_list = ListAppend(Variables.userID_list, qry_selectCobrandList.userID)>
	</cfif>

	<!--- get salesperson(s) --->
	<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerList" ReturnVariable="qry_selectCommissionCustomerList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
	</cfinvoke>

	<cfif qry_selectCommissionCustomerList.RecordCount is not 0>
		<cfset Variables.displayPartners = True>
		<cfset Variables.displaySalesperson = False>
		<cfset Variables.userID_list = ListAppend(Variables.userID_list, ValueList(qry_selectCommissionCustomerList.targetID))>
	</cfif>

	<!--- if invoice, get vendor(s) --->
	<cfif Variables.primaryTargetKey is not "invoiceID">
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		</cfinvoke>

		<cfset Variables.vendorID_list = ValueList(qry_selectInvoiceLineItemList.vendorID)>
		<cfif REFind("[1-9]", Variables.vendorID_list)>
			<cfset Variables.displayPartners = True>
			<cfset Variables.displayVendor = True>
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

	<cfif REFind("[1-9]", Variables.userID_list)>
		<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUserList">
			<cfinvokeargument Name="userID" Value="#Variables.userID_list#">
		</cfinvoke>

		<cfloop Query="qry_selectUserList">
			<cfif qry_selectUserList.email is not "">
				<cfset Variables.displayUserEmail = False>
				<cfset Variables.userEmailStruct["user#qry_selectUserList.userID#"] = qry_selectUserList.email>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

