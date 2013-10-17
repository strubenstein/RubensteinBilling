<cfinvoke Component="#Application.billingMapping#data.SalesCommissionInvoice" Method="selectSalesCommissionInvoice" ReturnVariable="qry_selectSalesCommissionInvoice">
	<cfinvokeargument Name="salesCommissionID" Value="#URL.salesCommissionID#">
</cfinvoke>

<!--- select commission plan info --->
<cfif qry_selectSalesCommission.commissionID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Commission" Method="selectCommission" ReturnVariable="qry_selectCommission">
		<cfinvokeargument Name="commissionID" Value="#qry_selectSalesCommission.commissionID#">
	</cfinvoke>

	<cfset Variables.commissionRow = ListFind(ValueList(qry_selectCommission.commissionStageID), qry_selectSalesCommission.commissionStageID)>
</cfif>

<cfif qry_selectSalesCommissionInvoice.RecordCount is not 0>
	<cfset Variables.invoiceID_list = "">
	<cfset Variables.invoiceLineItemID_list = "">

	<!--- select invoice, customer and line item info --->
	<cfloop Query="qry_selectSalesCommissionInvoice">
		<cfif Not ListFind(Variables.invoiceID_list, qry_selectSalesCommissionInvoice.invoiceID)>
			<cfset Variables.invoiceID_list = ListAppend(Variables.invoiceID_list, qry_selectSalesCommissionInvoice.invoiceID)>
		</cfif>
		<cfif Variables.invoiceLineItemID_list is not 0 and Not ListFind(Variables.invoiceID_list, qry_selectSalesCommissionInvoice.invoiceLineItemID)>
			<cfset Variables.invoiceLineItemID_list = ListAppend(Variables.invoiceLineItemID_list, qry_selectSalesCommissionInvoice.invoiceLineItemID)>
		</cfif>
	</cfloop>

	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoiceList">
		<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID_list#">
	</cfinvoke>

	<cfif Variables.invoiceLineItemID_list is not "" and REFind("[1-9]", Variables.invoiceLineItemID_list)>
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItem" ReturnVariable="qry_selectInvoiceLineItemList">
			<cfinvokeargument Name="invoiceLineItemID" Value="#Variables.invoiceLineItemID_list#">
		</cfinvoke>
	</cfif>
</cfif>

<!--- select target (salesperson) inf0 --->
<cfswitch expression="#Application.fn_GetPrimaryTargetKey(qry_selectSalesCommission.primaryTargetID)#">
<cfcase value="affiliateID">
	<cfset Variables.displaySalespersonColumn = False>
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliate">
		<cfinvokeargument Name="affiliateID" Value="#qry_selectSalesCommission.targetID#">
	</cfinvoke>
</cfcase>
<cfcase value="cobrandID">
	<cfset Variables.displaySalespersonColumn = False>
	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
		<cfinvokeargument Name="cobrandID" Value="#qry_selectSalesCommission.targetID#">
	</cfinvoke>
</cfcase>
<cfcase value="companyID">
	<cfset Variables.displaySalespersonColumn = True>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#qry_selectSalesCommission.targetID#">
	</cfinvoke>
</cfcase>
<cfcase value="userID">
	<cfset Variables.displaySalespersonColumn = True>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfinvokeargument Name="userID" Value="#qry_selectSalesCommission.targetID#">
	</cfinvoke>
</cfcase>
<cfcase value="vendorID">
	<cfset Variables.displaySalespersonColumn = False>
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendor" ReturnVariable="qry_selectVendor">
		<cfinvokeargument Name="vendorID" Value="#qry_selectSalesCommission.targetID#">
	</cfinvoke>
</cfcase>
</cfswitch>

<cfif qry_selectSalesCommission.salesCommissionManual is 1 and qry_selectSalesCommission.userID_author is not 0>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser_author">
		<cfinvokeargument Name="userID" Value="#qry_selectSalesCommission.userID_author#">
	</cfinvoke>
</cfif>

<cfif REFind("[1-9]", ValueList(qry_selectSalesCommissionInvoice.commissionCustomerID))>
	<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomer" ReturnVariable="qry_selectCommissionCustomer">
		<cfinvokeargument Name="commissionCustomerID" Value="#ValueList(qry_selectSalesCommissionInvoice.commissionCustomerID)#">
	</cfinvoke>
</cfif>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewUser,viewCompany,viewSubscriber,viewAffiliate,viewCobrand,viewVendor,viewInvoice,viewCommission,viewInvoice,viewProduct,updateSalesCommission")>
<cfinclude template="../../view/v_salesCommission/dsp_selectSalesCommission.cfm">
