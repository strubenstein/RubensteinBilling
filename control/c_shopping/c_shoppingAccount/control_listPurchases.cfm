<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList" ReturnVariable="qry_selectPurchaseList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
	<cfinvokeargument Name="invoiceClosed" Value="1">
	<cfinvokeargument Name="queryOrderBy" Value="invoiceDateClosed_d">
	<cfinvokeargument Name="queryDisplayPerPage" Value="1">
	<cfinvokeargument Name="queryPage" Value="1">
</cfinvoke>

<cfif qry_selectPurchaseList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Shipping" Method="selectShippingList" ReturnVariable="qry_selectShippingList">
		<cfinvokeargument Name="invoiceID" Value="#ValueList(qry_selectPurchaseList.invoiceID)#">
		<cfinvokeargument Name="shippingStatus" Value="1">
		<cfinvokeargument Name="shippingSent" Value="1">
	</cfinvoke>
</cfif>

<cfinclude template="../../../include/function/fn_trackShipping.cfm">
<cfinclude template="../../../view/v_shopping/v_shoppingAccount/dsp_selectPurchaseList.cfm">
