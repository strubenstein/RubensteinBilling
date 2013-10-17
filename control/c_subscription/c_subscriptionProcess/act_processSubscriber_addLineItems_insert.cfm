<!--- For each line item to add to invoice for this subscription, insert line item and product parameters. --->
<cfloop Index="count" From="1" To="#ArrayLen(Variables.lineItemArray)#">
	<!--- insert line item --->
	<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="insertInvoiceLineItem" ReturnVariable="newInvoiceLineItemID">
		<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
		<cfinvokeargument Name="subscriptionID" Value="#qry_selectSubscriptionList.subscriptionID[Variables.thisSubscriptionRow]#">
		<cfinvokeargument Name="productParameterExceptionID" Value="#qry_selectSubscriptionList.productParameterExceptionID[Variables.thisSubscriptionRow]#">
		<cfinvokeargument Name="productID" Value="#qry_selectSubscriptionList.productID[Variables.thisSubscriptionRow]#">
		<cfinvokeargument Name="categoryID" Value="#qry_selectSubscriptionList.categoryID[Variables.thisSubscriptionRow]#">
		<cfinvokeargument Name="invoiceLineItemName" Value="#qry_selectSubscriptionList.subscriptionName[Variables.thisSubscriptionRow]#">
		<cfinvokeargument Name="invoiceLineItemDescription" Value="#qry_selectSubscriptionList.subscriptionDescription[Variables.thisSubscriptionRow]#">
		<cfinvokeargument Name="invoiceLineItemDescriptionHtml" Value="#qry_selectSubscriptionList.subscriptionDescriptionHtml[Variables.thisSubscriptionRow]#">
		<cfinvokeargument Name="regionID" Value="#qry_selectSubscriptionList.regionID[Variables.thisSubscriptionRow]#">
		<cfinvokeargument Name="invoiceLineItemProductID_custom" Value="#qry_selectSubscriptionList.subscriptionProductID_custom[Variables.thisSubscriptionRow]#">
		<cfinvokeargument Name="priceID" Value="#Variables.invoiceLineItem_priceID#">
		<cfinvokeargument Name="priceStageID" Value="#Variables.invoiceLineItem_priceStageID#">
		<cfinvokeargument Name="invoiceLineItemPriceNormal" Value="#Variables.invoiceLineItem_priceNormal#">
		<cfinvokeargument Name="invoiceLineItemDateBegin" Value="#Variables.invoiceLineItemDateBegin#">
		<cfinvokeargument Name="invoiceLineItemDateEnd" Value="#Variables.invoiceLineItemDateEnd#">
		<cfinvokeargument Name="priceVolumeDiscountID" Value="#Variables.lineItemArray[count].priceVolumeDiscountID#">
		<cfinvokeargument Name="invoiceLineItemQuantity" Value="#Variables.lineItemArray[count].quantity#">
		<cfinvokeargument Name="invoiceLineItemPriceUnit" Value="#Variables.lineItemArray[count].priceUnit#">
		<cfinvokeargument Name="invoiceLineItemSubTotal" Value="#Variables.lineItemArray[count].subTotal#">
		<cfinvokeargument Name="invoiceLineItemDiscount" Value="#Variables.lineItemArray[count].discount#">
		<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
		<cfinvokeargument Name="invoiceLineItemOrder" Value="0">
		<cfinvokeargument Name="invoiceLineItemTotalTax" Value="0">
		<cfinvokeargument Name="invoiceLineItemManual" Value="0">
		<cfinvokeargument Name="invoiceLineItemID_trend" Value="0">
		<cfinvokeargument Name="invoiceLineItemID_parent" Value="0">
		<cfinvokeargument Name="userID_author" Value="0">
		<cfinvokeargument Name="isUpdateInvoiceTotal" Value="False">
		<cfinvokeargument Name="userID" Value="0">
	</cfinvoke>

	<!--- if any product parameters, insert into invoice --->
	<cfif Variables.productParameterOptionID_list is not "">
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="insertInvoiceLineItemParameter" ReturnVariable="isInvoiceLineItemParameterInserted">
			<cfinvokeargument Name="invoiceLineItemID" Value="#newInvoiceLineItemID#">
			<cfinvokeargument Name="productParameterOptionID" Value="#qry_selectSubscriptionParameterList.productParameterOptionID#">
		</cfinvoke>
	</cfif>
</cfloop>
