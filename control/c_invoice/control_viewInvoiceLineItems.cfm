<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
	<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	<cfif Variables.doAction is not "viewInvoiceLineItemsAll">
		<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
	</cfif>
</cfinvoke>

<cfinclude template="../../view/v_invoice/lang_viewInvoiceLineItems.cfm">

<cfif qry_selectInvoice.invoiceClosed is 0>
	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewVendor,viewProduct,listPrices,insertInvoiceLineItem,updateInvoiceLineItem,viewInvoiceLineItem,moveInvoiceLineItemUp,moveInvoiceLineItemDown,updateInvoiceLineItemStatus")>
<cfelse>
	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewVendor,viewProduct,listPrices,viewInvoiceLineItem")>
</cfif>

<cfset Variables.invoiceLineItemColumnList = Variables.lang_viewInvoiceLineItems_title.invoiceLineItemOrder>
<cfset Variables.totalColspan = 8>

<cfset Variables.displayProductID_custom = False>
<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectInvoiceLineItemList.invoiceLineItemProductID_custom))>
	<cfset Variables.invoiceLineItemColumnList = Variables.invoiceLineItemColumnList & "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemProductID_custom>
	<cfset Variables.displayProductID_custom = True>
	<cfset Variables.totalColspan = Variables.totalColspan + 2>
</cfif>

<!--- get vendor information, if necessary --->
<cfset Variables.displayVendor = False>
<cfif REFind("[1-9]", ValueList(qry_selectInvoiceLineItemList.vendorID))>
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		<cfinvokeargument Name="vendorID" Value="#ValueList(qry_selectInvoiceLineItemList.vendorID)#">
	</cfinvoke>

	<cfif qry_selectVendorList.RecordCount is not 0>
		<cfset Variables.invoiceLineItemColumnList = Variables.invoiceLineItemColumnList & "^" & Variables.lang_viewInvoiceLineItems_title.vendorName>
		<cfset Variables.displayVendor = True>
		<cfset Variables.totalColspan = Variables.totalColspan + 2>
	</cfif>
</cfif>

<cfset Variables.invoiceLineItemColumnList = Variables.invoiceLineItemColumnList & "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemName>

<cfset Variables.displayBundle = False>
<cfif REFindNoCase("[1|y|t]", ValueList(qry_selectInvoiceLineItemList.invoiceLineItemProductIsBundle)) or REFindNoCase("[1|y|t]", ValueList(qry_selectInvoiceLineItemList.invoiceLineItemProductInBundle))>
	<cfset Variables.invoiceLineItemColumnList = Variables.invoiceLineItemColumnList & "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemProductIsBundle>
	<cfset Variables.displayBundle = True>
	<cfset Variables.totalColspan = Variables.totalColspan + 2>
</cfif>

<cfset Variables.invoiceLineItemColumnList = Variables.invoiceLineItemColumnList
		& "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemPriceNormal
		& "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemPriceUnit
		& "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemQuantity
		& "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemSubTotal
		& "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemDiscount
		& "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemTotalTax
		& "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemTotal>

<cfif Variables.doAction is "viewInvoiceLineItemsAll" or ListFind(Variables.permissionActionList, "updateInvoiceLineItemStatus")>
	<cfset Variables.invoiceLineItemColumnList = Variables.invoiceLineItemColumnList & "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemStatus>
</cfif>
<!--- 
<cfif Variables.doAction is "viewInvoiceLineItemsAll">
	<cfset Variables.invoiceLineItemColumnList = Variables.invoiceLineItemColumnList & "^" & Variables.lang_viewInvoiceLineItems_title.invoiceLineItemDateUpdated & "^" & Variables.lang_viewInvoiceLineItems_title.userID_cancel>
<cfelseif ListFind(Variables.permissionActionList, "moveInvoiceLineItemUp") and ListFind(Variables.permissionActionList, "moveInvoiceLineItemDown")>
--->
<cfif Variables.doAction is not "viewInvoiceLineItemsAll" and ListFind(Variables.permissionActionList, "moveInvoiceLineItemUp") and ListFind(Variables.permissionActionList, "moveInvoiceLineItemDown")>
	<cfset Variables.invoiceLineItemColumnList = Variables.invoiceLineItemColumnList & "^" & Variables.lang_viewInvoiceLineItems_title.switchInvoiceLineItemOrder>
</cfif>
<cfif ListFind(Variables.permissionActionList, "insertInvoiceLineItem") or ListFind(Variables.permissionActionList, "viewInvoiceLineItem") or ListFind(Variables.permissionActionList, "updateInvoiceLineItem")>
	<cfset Variables.invoiceLineItemColumnList = Variables.invoiceLineItemColumnList & "^" & Variables.lang_viewInvoiceLineItems_title.viewInvoiceLineItem>
</cfif>

<cfset Variables.invoiceLineItemColumnCount = DecrementValue(2 * ListLen(Variables.invoiceLineItemColumnList, "^"))>

<!--- include productParameterExceptionID, parameters --->

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">

<cfinclude template="../../view/v_invoice/dsp_selectInvoiceLineItemList.cfm">

