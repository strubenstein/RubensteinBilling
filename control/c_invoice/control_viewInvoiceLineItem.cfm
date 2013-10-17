
<!--- 
4 options:
- Add a new line item with an existing product
- Add a new line item based on an existing line item (copy)
- Add a new line item with a "custom" product that does not exist
- Update an existing line item, using the same product

If new line item, let user choose between custom product and existing product.
--->

<cfset URL.productID = qry_selectInvoiceLineItem.productID>

<cfset Variables.displayProductParameter = False>
<cfset Variables.displayProductParameterException = False>
<cfset Variables.displayCustomPrice = False>
<cfset Variables.displayCustomPriceVolumeDiscount = False>
<cfset Variables.displayPriceQuantityMaximumPerCustomer = False>
<cfset Variables.displayPriceQuantityMaximumAllCustomers = False>
<!--- 
<cfset Variables.productID_customPriceRow = StructNew()>
<cfset Variables.productID_customPriceAmount = StructNew()>
--->

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewVendor,viewProduct,listPrices,viewInvoiceLineItem,viewUser")>

<!--- select product --->
<cfif URL.productID is not 0>
	<cfinclude template="act_insertInvoiceLineItem_getProduct.cfm">
	<cfinclude template="act_insertInvoiceLineItem_getPrices.cfm">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
	<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	<cfinvokeargument Name="invoiceLineItemID" Value="#URL.invoiceLineItemID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemUser" ReturnVariable="qry_selectInvoiceLineItemUser">
	<cfinvokeargument Name="invoiceLineItemID" Value="#URL.invoiceLineItemID#">
	<cfinvokeargument Name="returnUserFields" Value="True">
</cfinvoke>

<cfinclude template="../../include/function/fn_DisplayPrice.cfm">

<cfinclude template="../../view/v_invoice/dsp_selectInvoiceLineItem.cfm">
