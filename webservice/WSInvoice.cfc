<cfcomponent DisplayName="WSInvoice" Hint="Manages all invoice web services">

<cffunction Name="insertInvoice" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts new invoice. Returns invoiceID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="numeric">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="invoiceStatus" Type="boolean">
	<cfargument Name="invoiceClosed" Type="boolean">
	<cfargument Name="invoiceCompleted" Type="boolean">
	<cfargument Name="invoiceSent" Type="boolean">
	<cfargument Name="invoicePaid" Type="string">
	<cfargument Name="invoiceDateDue" Type="string">
	<cfargument Name="invoiceShipped" Type="string">
	<cfargument Name="invoiceTotalShipping" Type="numeric">
	<cfargument Name="invoiceShippingMethod" Type="string">
	<cfargument Name="invoiceInstructions" Type="string">
	<cfargument Name="addressID_shipping" Type="numeric">
	<cfargument Name="addressID_billing" Type="numeric">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var customFieldInvoice = Arguments.customField>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfset var invoice_customField = Arguments.customField>
	<cfset var invoice_statusID = Arguments.statusID>
	<cfset var invoice_statusID_custom = Arguments.statusID_custom>
	<cfset var invoice_statusHistoryComment = Arguments.statusHistoryComment>
	<cfset var invoice_useCustomIDFieldList = Arguments.useCustomIDFieldList>

	<cfset var dateResponse = "">
	<cfset var useSubscriberInfo = False>
	<cfset var qry_selectSubscriberList = QueryNew("subscriberID")>
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID")>
	<cfset var hour_ampm = "">

	<cfinclude template="ws_invoice/ws_insertInvoice.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateInvoice" Access="remote" Output="No" ReturnType="boolean" Hint="Updates existing invoice. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="invoiceID" Type="numeric">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="invoiceStatus" Type="boolean">
	<cfargument Name="invoiceClosed" Type="boolean">
	<cfargument Name="invoiceCompleted" Type="boolean">
	<cfargument Name="invoiceSent" Type="boolean">
	<cfargument Name="invoicePaid" Type="string">
	<cfargument Name="invoiceDateDue" Type="string">
	<cfargument Name="invoiceShipped" Type="string">
	<cfargument Name="invoiceTotalShipping" Type="numeric">
	<cfargument Name="invoiceShippingMethod" Type="string">
	<cfargument Name="invoiceInstructions" Type="string">
	<cfargument Name="addressID_shipping" Type="numeric">
	<cfargument Name="addressID_billing" Type="numeric">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfset var dateResponse = "">
	<cfset var useSubscriberInfo = False>
	<cfset var qry_selectSubscriberList = QueryNew("subscriberID")>
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID")>
	<cfset var hour_ampm = "">

	<cfinclude template="ws_invoice/ws_updateInvoice.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="insertInvoiceLineItem" Access="remote" Output="No" ReturnType="string" Hint="Insert line item for specified invoice. Returns invoiceLineItemID (or comma-delimited list if volume discount step pricing generates multiple line items).">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="invoiceID" Type="numeric">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="productID" Type="numeric">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="priceID" Type="numeric">
	<cfargument Name="priceID_custom" Type="string">
	<cfargument Name="invoiceLineItemName" Type="string">
	<cfargument Name="invoiceLineItemQuantity" Type="numeric">
	<cfargument Name="invoiceLineItemPriceUnit" Type="string">
	<cfargument Name="invoiceLineItemPriceNormal" Type="string">
	<cfargument Name="invoiceLineItemDiscount" Type="numeric">
	<cfargument Name="invoiceLineItemTotalTax" Type="numeric">
	<cfargument Name="invoiceLineItemProductID_custom" Type="string">
	<cfargument Name="invoiceLineItemDateBegin" Type="string">
	<cfargument Name="invoiceLineItemDateEnd" Type="string">
	<cfargument Name="invoiceLineItemDescription" Type="string">
	<cfargument Name="invoiceLineItemDescriptionHtml" Type="boolean">
	<cfargument Name="productParameter" Type="string">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">

	<cfset var returnValue = "">
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfset var invoiceLineItem_customField = Arguments.customField>
	<cfset var invoiceLineItem_statusID = Arguments.statusID>
	<cfset var invoiceLineItem_statusID_custom = Arguments.statusID_custom>
	<cfset var invoiceLineItem_statusHistoryComment = Arguments.statusHistoryComment>
	<cfset var invoiceLineItem_useCustomIDFieldList = Arguments.useCustomIDFieldList>

	<cfset var productParameterOptionID_list = "">
	<cfset var productParameterXml = "">
	<cfset var productParameterXmlCount = 0>
	<cfset var productParameterID_list = "">
	<cfset var productParameterXmlName = "">
	<cfset var productParameterXmlValue = "">
	<cfset var parameterRow = 0>
	<cfset var isOptionExist = False>

	<cfset var displayProductParameter = False>
	<cfset var displayProductParameterException = False>
	<cfset var displayCustomPrice = False>
	<cfset var displayCustomPriceVolumeDiscount = False>
	<cfset var displayPriceQuantityMaximumPerCustomer = False>
	<cfset var displayPriceQuantityMaximumAllCustomers = False>
	<cfset var productID_list = "">
	<cfset var categoryID_price = "">
	<cfset var categoryID_parentList_price = "">

	<cfset var displayPriceCode = True>
	<cfset var displayPriceName = True>
	<cfset var quantityMaximumPerCustomer = StructNew()>
	<cfset var quantityMaximumAllCustomers = StructNew()>

	<cfset var hour_ampm = "">
	<cfset var productParameterExceptionID = 0>
	<cfset var productParameterExceptionPricePremium = 0>
	<cfset var multipleLineItem_priceStageVolumeStep = False>
	<cfset var multipleLineItem_priceQuantityMaxPerCustomer = False>
	<cfset var multipleLineItem_priceQuantityMaxAllCustomers = False>

	<cfset var dateBeginResponse = "">
	<cfset var dateEndResponse = "">
	<cfset var priceRow = 0>
	<cfset var sumQuantity = 0>
	<cfset var remainderPerCustomer = 0>
	<cfset var invoiceLineItemProductID_customArray = ArrayNew(1)>
	<cfset var isParameterOption = False>
	<cfset var thisParameterID = 0>
	<cfset var thisCodeStatus = 0>
	<cfset var thisCodeOrder = 0>

	<cfset var lineItemArray = ArrayNew(1)>
	<cfset var priceStageID = 0>
	<cfset var thisPriceStageID = 0>
	<cfset var beginRow = 0>
	<cfset var counter = 1>
	<cfset var priceUnitOriginal = 0>
	<cfset var quantityOriginal = 0>
	<cfset var quantityRemaining = 0>
	<cfset var subTotalRemaining = 0>
	<cfset var quantityPrecision = 2>
	<cfset var quantityBasis = 0>
	<cfset var subTotal = 0>
	<cfset var discountRemaining = 0>
	<cfset var taxRemaining = 0>
	<cfset var thisDiscount = 0>
	<cfset var thisTax = 0>
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID")>

	<cfinclude template="ws_invoice/ws_insertInvoiceLineItem.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="insertInvoiceAndLineItem" Access="remote" Output="No" ReturnType="string" Hint="Insert line item and creates new invoice if necessary. Returns XML string of IDs.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID_invoice" Type="numeric">
	<cfargument Name="userID_invoice_custom" Type="string">
	<cfargument Name="subscriberID" Type="numeric">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="invoiceStatus" Type="boolean">
	<cfargument Name="invoiceClosed" Type="boolean">
	<cfargument Name="invoiceCompleted" Type="boolean">
	<cfargument Name="invoiceSent" Type="boolean">
	<cfargument Name="invoicePaid" Type="string">
	<cfargument Name="invoiceDateDue" Type="string">
	<cfargument Name="invoiceShipped" Type="string">
	<cfargument Name="invoiceTotalShipping" Type="numeric">
	<cfargument Name="invoiceShippingMethod" Type="string">
	<cfargument Name="invoiceInstructions" Type="string">
	<cfargument Name="addressID_shipping" Type="numeric">
	<cfargument Name="addressID_billing" Type="numeric">
	<cfargument Name="customField_invoice" Type="string">
	<cfargument Name="statusID_invoice" Type="numeric">
	<cfargument Name="statusID_invoice_custom" Type="string">
	<cfargument Name="statusHistoryComment_invoice" Type="string">
	<cfargument Name="productID" Type="numeric">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="priceID" Type="numeric">
	<cfargument Name="priceID_custom" Type="string">
	<cfargument Name="invoiceLineItemName" Type="string">
	<cfargument Name="invoiceLineItemQuantity" Type="numeric">
	<cfargument Name="invoiceLineItemPriceUnit" Type="string">
	<cfargument Name="invoiceLineItemPriceNormal" Type="string">
	<cfargument Name="invoiceLineItemDiscount" Type="numeric">
	<cfargument Name="invoiceLineItemTotalTax" Type="numeric">
	<cfargument Name="invoiceLineItemProductID_custom" Type="string">
	<cfargument Name="invoiceLineItemDateBegin" Type="string">
	<cfargument Name="invoiceLineItemDateEnd" Type="string">
	<cfargument Name="invoiceLineItemDescription" Type="string">
	<cfargument Name="invoiceLineItemDescriptionHtml" Type="boolean">
	<cfargument Name="productParameter" Type="string">
	<cfargument Name="customField_invoiceLineItem" Type="string">
	<cfargument Name="statusID_invoiceLineItem" Type="numeric">
	<cfargument Name="statusID_invoiceLineItem_custom" Type="string">
	<cfargument Name="statusHistoryComment_invoiceLineItem" Type="string">
	<cfargument Name="userID_invoiceLineItem" Type="string">
	<cfargument Name="userID_invoiceLineItem_custom" Type="string">

	<cfset var returnValue = "">
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var returnValueXml = "">
	<cfset var invoiceClosed_orig = Arguments.invoiceClosed>
	<cfset var invoiceCompleted_orig = Arguments.invoiceCompleted>

	<cfset var invoice_customField = Arguments.customField_invoice>
	<cfset var invoice_statusID = Arguments.statusID_invoice>
	<cfset var invoice_statusID_custom = Arguments.statusID_invoice_custom>
	<cfset var invoice_statusHistoryComment = Arguments.statusHistoryComment_invoice>

	<cfset var invoiceLineItem_customField = Arguments.customField_invoiceLineItem>
	<cfset var invoiceLineItem_statusID = Arguments.statusID_invoiceLineItem>
	<cfset var invoiceLineItem_statusID_custom = Arguments.statusID_invoiceLineItem_custom>
	<cfset var invoiceLineItem_statusHistoryComment = Arguments.statusHistoryComment_invoiceLineItem>
	<cfset var invoiceLineItem_useCustomIDFieldList = ReplaceNoCase(ReplaceNoCase(Arguments.useCustomIDFieldList, "statusID_invoiceLineItem", "statusID", "ALL"), "statusID_invoiceLineItem_custom", "statusID_custom", "ALL")>
	<cfset var invoice_useCustomIDFieldList = ReplaceNoCase(ReplaceNoCase(invoiceLineItem_useCustomIDFieldList, "statusID_invoice", "statusID", "ALL"), "statusID_invoice_custom", "statusID_custom", "ALL")>

	<cfset var dateResponse = "">
	<cfset var useSubscriberInfo = False>
	<cfset var qry_selectSubscriberList = QueryNew("subscriberID")>
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID")>
	<cfset var hour_ampm = "">

	<cfset var productParameterOptionID_list = "">
	<cfset var productParameterXml = "">
	<cfset var productParameterXmlCount = 0>
	<cfset var productParameterID_list = "">
	<cfset var productParameterXmlName = "">
	<cfset var productParameterXmlValue = "">
	<cfset var parameterRow = 0>
	<cfset var isOptionExist = False>

	<cfset var displayProductParameter = False>
	<cfset var displayProductParameterException = False>
	<cfset var displayCustomPrice = False>
	<cfset var displayCustomPriceVolumeDiscount = False>
	<cfset var displayPriceQuantityMaximumPerCustomer = False>
	<cfset var displayPriceQuantityMaximumAllCustomers = False>
	<cfset var productID_list = "">
	<cfset var categoryID_price = "">
	<cfset var categoryID_parentList_price = "">

	<cfset var displayPriceCode = True>
	<cfset var displayPriceName = True>
	<cfset var quantityMaximumPerCustomer = StructNew()>
	<cfset var quantityMaximumAllCustomers = StructNew()>

	<cfset var productParameterExceptionID = 0>
	<cfset var productParameterExceptionPricePremium = 0>
	<cfset var multipleLineItem_priceStageVolumeStep = False>
	<cfset var multipleLineItem_priceQuantityMaxPerCustomer = False>
	<cfset var multipleLineItem_priceQuantityMaxAllCustomers = False>

	<cfset var dateBeginResponse = "">
	<cfset var dateEndResponse = "">
	<cfset var priceRow = 0>
	<cfset var sumQuantity = 0>
	<cfset var remainderPerCustomer = 0>
	<cfset var invoiceLineItemProductID_customArray = ArrayNew(1)>
	<cfset var isParameterOption = False>
	<cfset var thisParameterID = 0>
	<cfset var thisCodeStatus = 0>
	<cfset var thisCodeOrder = 0>

	<cfset var lineItemArray = ArrayNew(1)>
	<cfset var priceStageID = 0>
	<cfset var thisPriceStageID = 0>
	<cfset var beginRow = 0>
	<cfset var counter = 1>
	<cfset var priceUnitOriginal = 0>
	<cfset var quantityOriginal = 0>
	<cfset var quantityRemaining = 0>
	<cfset var subTotalRemaining = 0>
	<cfset var quantityPrecision = 2>
	<cfset var quantityBasis = 0>
	<cfset var subTotal = 0>
	<cfset var discountRemaining = 0>
	<cfset var taxRemaining = 0>
	<cfset var thisDiscount = 0>
	<cfset var thisTax = 0>

	<cfinclude template="ws_invoice/ws_insertInvoiceAndLineItem.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectInvoice" Access="remote" Output="No" ReturnType="query" Hint="Select one or more existing invoices">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="invoiceID" Type="string">
	<cfargument Name="invoiceID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_invoice/ws_selectInvoice.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectInvoiceLineItemList" Access="remote" Output="No" ReturnType="query" Hint="Select line items from existing invoice">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="invoiceID" Type="numeric">
	<cfargument Name="invoiceID_custom" Type="string">
	<!--- export parameters via XML method? --->

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var lineItemParameterValueArray = ArrayNew(1)>
	<cfset var lineItemRow = 0>
	<cfset var parameterOptionRow = 0>
	<cfset var invoiceLineItemUserArray = ArrayNew(1)>
	<cfset var invoiceLineItemRow = 0>

	<cfinclude template="ws_invoice/ws_selectInvoiceLineItemList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectInvoiceList_count" Access="remote" Output="No" ReturnType="numeric" Hint="Returns number of invoices that meet criteria.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="statusID" Type="string">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="payflowID" Type="string">
	<cfargument Name="payflowID_custom" Type="string">
	<cfargument Name="priceID" Type="string">
	<cfargument Name="priceID_custom" Type="string">
	<cfargument Name="productID" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="invoiceDatePaid_from" Type="string">
	<cfargument Name="invoiceDatePaid_to" Type="string">
	<cfargument Name="invoiceDateClosed_from" Type="string">
	<cfargument Name="invoiceDateClosed_to" Type="string">
	<cfargument Name="invoiceDateCompleted_from" Type="string">
	<cfargument Name="invoiceDateCompleted_to" Type="string">
	<cfargument Name="invoiceDateDue_from" Type="string">
	<cfargument Name="invoiceDateDue_to" Type="string">
	<cfargument Name="invoiceDateCreated_from" Type="string">
	<cfargument Name="invoiceDateCreated_to" Type="string">
	<cfargument Name="invoicePaid" Type="boolean">
	<cfargument Name="invoiceShipped" Type="boolean">
	<cfargument Name="invoiceClosed" Type="boolean">
	<cfargument Name="invoiceCompleted" Type="boolean">
	<cfargument Name="invoiceStatus" Type="boolean">
	<cfargument Name="invoiceManual" Type="boolean">
	<cfargument Name="invoiceSent" Type="boolean">
	<cfargument Name="invoiceShippingMethod" Type="string">
	<cfargument Name="invoiceTotal_min" Type="numeric">
	<cfargument Name="invoiceTotal_max" Type="numeric">
	<cfargument Name="invoiceTotalLineItem_min" Type="numeric">
	<cfargument Name="invoiceTotalLineItem_max" Type="numeric">
	<cfargument Name="invoiceTotalPaymentCredit_min" Type="numeric">
	<cfargument Name="invoiceTotalPaymentCredit_max" Type="numeric">
	<cfargument Name="invoiceTotalShipping_min" Type="numeric">
	<cfargument Name="invoiceTotalShipping_max" Type="numeric">
	<cfargument Name="invoiceTotalTax_min" Type="numeric">
	<cfargument Name="invoiceTotalTax_max" Type="numeric">
	<cfargument Name="invoiceIsExported" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var qryParamWhere = StructNew()>

	<cfinclude template="ws_invoice/ws_selectInvoiceList_count.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectInvoiceList" Access="remote" Output="No" ReturnType="query" Hint="Select existing invoices that meet criteria. Returns query.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="statusID" Type="string">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="payflowID" Type="string">
	<cfargument Name="payflowID_custom" Type="string">
	<cfargument Name="priceID" Type="string">
	<cfargument Name="priceID_custom" Type="string">
	<cfargument Name="productID" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="invoiceDatePaid_from" Type="string">
	<cfargument Name="invoiceDatePaid_to" Type="string">
	<cfargument Name="invoiceDateClosed_from" Type="string">
	<cfargument Name="invoiceDateClosed_to" Type="string">
	<cfargument Name="invoiceDateCompleted_from" Type="string">
	<cfargument Name="invoiceDateCompleted_to" Type="string">
	<cfargument Name="invoiceDateDue_from" Type="string">
	<cfargument Name="invoiceDateDue_to" Type="string">
	<cfargument Name="invoiceDateCreated_from" Type="string">
	<cfargument Name="invoiceDateCreated_to" Type="string">
	<cfargument Name="invoicePaid" Type="boolean">
	<cfargument Name="invoiceShipped" Type="boolean">
	<cfargument Name="invoiceClosed" Type="boolean">
	<cfargument Name="invoiceCompleted" Type="boolean">
	<cfargument Name="invoiceStatus" Type="boolean">
	<cfargument Name="invoiceManual" Type="boolean">
	<cfargument Name="invoiceSent" Type="boolean">
	<cfargument Name="invoiceShippingMethod" Type="string">
	<cfargument Name="invoiceTotal_min" Type="numeric">
	<cfargument Name="invoiceTotal_max" Type="numeric">
	<cfargument Name="invoiceTotalLineItem_min" Type="numeric">
	<cfargument Name="invoiceTotalLineItem_max" Type="numeric">
	<cfargument Name="invoiceTotalPaymentCredit_min" Type="numeric">
	<cfargument Name="invoiceTotalPaymentCredit_max" Type="numeric">
	<cfargument Name="invoiceTotalShipping_min" Type="numeric">
	<cfargument Name="invoiceTotalShipping_max" Type="numeric">
	<cfargument Name="invoiceTotalTax_min" Type="numeric">
	<cfargument Name="invoiceTotalTax_max" Type="numeric">
	<cfargument Name="invoiceIsExported" Type="string">
	<cfargument Name="queryDisplayPerPage" Type="numeric">
	<cfargument Name="queryPage" Type="numeric">
	<cfargument Name="queryOrderBy" Type="string">
	<cfargument Name="queryFirstLetter" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var qryParamWhere = StructNew()>

	<cfinclude template="ws_invoice/ws_selectInvoiceList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateInvoiceIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether invoice records have been exported. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="invoiceID" Type="string" Required="Yes">
	<cfargument Name="invoiceID_custom" Type="string" Required="Yes">
	<cfargument Name="invoiceIsExported" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_invoice/ws_updateInvoiceIsExported.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
