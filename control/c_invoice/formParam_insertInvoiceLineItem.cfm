<cfif URL.invoiceLineItemID is not 0 and IsDefined("qry_selectInvoiceLineItem")>
	<cfparam Name="Form.invoiceLineItemName" Default="#qry_selectInvoiceLineItem.invoiceLineItemName#">
	<cfparam Name="Form.invoiceLineItemDescription" Default="#qry_selectInvoiceLineItem.invoiceLineItemDescription#">
	<cfparam Name="Form.invoiceLineItemDescriptionHtml" Default="#qry_selectInvoiceLineItem.invoiceLineItemDescriptionHtml#">
	<cfparam Name="Form.invoiceLineItemQuantity" Default="#qry_selectInvoiceLineItem.invoiceLineItemQuantity#">
	<cfparam Name="Form.invoiceLineItemPriceUnit" Default="#qry_selectInvoiceLineItem.invoiceLineItemPriceUnit#">
	<cfparam Name="Form.invoiceLineItemPriceNormal" Default="#qry_selectInvoiceLineItem.invoiceLineItemPriceNormal#">
	<cfparam Name="Form.invoiceLineItemSubTotal" Default="#qry_selectInvoiceLineItem.invoiceLineItemSubTotal#">
	<cfparam Name="Form.invoiceLineItemDiscount" Default="#qry_selectInvoiceLineItem.invoiceLineItemDiscount#">
	<cfparam Name="Form.invoiceLineItemTotal" Default="#qry_selectInvoiceLineItem.invoiceLineItemTotal#">
	<cfparam Name="Form.invoiceLineItemTotalTax" Default="#qry_selectInvoiceLineItem.invoiceLineItemTotalTax#">
	<cfparam Name="Form.invoiceLineItemStatus" Default="#qry_selectInvoiceLineItem.invoiceLineItemStatus#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.invoiceLineItemManual" Default="#qry_selectInvoiceLineItem.invoiceLineItemManual#">
	</cfif>
	<cfparam Name="Form.invoiceLineItemProductID_custom" Default="#qry_selectInvoiceLineItem.invoiceLineItemProductID_custom#">
	<cfparam Name="Form.productParameterExceptionID" Default="#qry_selectInvoiceLineItem.productParameterExceptionID#">
	<cfparam Name="Form.regionID" Default="#qry_selectInvoiceLineItem.regionID#">
	<cfparam Name="Form.priceID" Default="#qry_selectInvoiceLineItem.priceID#">
	<cfparam Name="Form.categoryID" Default="#qry_selectInvoiceLineItem.categoryID#">
	<cfparam Name="Form.invoiceLineItemOrder" Default="#qry_selectInvoiceLineItem.invoiceLineItemOrder#">

	<cfif IsDate(qry_selectInvoiceLineItem.invoiceLineItemDateBegin)>
		<cfparam Name="Form.invoiceLineItemDateBegin_date" Default="#DateFormat(qry_selectInvoiceLineItem.invoiceLineItemDateBegin, 'mm/dd/yyyy')#">
		<cfparam Name="Form.invoiceLineItemDateBegin_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectInvoiceLineItem.invoiceLineItemDateBegin)), '|')#">
		<cfparam Name="Form.invoiceLineItemDateBegin_mm" Default="#Minute(qry_selectInvoiceLineItem.invoiceLineItemDateBegin)#">
		<cfparam Name="Form.invoiceLineItemDateBegin_tt" Default="#TimeFormat(qry_selectInvoiceLineItem.invoiceLineItemDateBegin, 'tt')#">
	</cfif>

	<cfif IsDate(qry_selectInvoiceLineItem.invoiceLineItemDateEnd)>
		<cfparam Name="Form.invoiceLineItemDateEnd_date" Default="#DateFormat(qry_selectInvoiceLineItem.invoiceLineItemDateEnd, 'mm/dd/yyyy')#">
		<cfparam Name="Form.invoiceLineItemDateEnd_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectInvoiceLineItem.invoiceLineItemDateEnd)), '|')#">
		<cfparam Name="Form.invoiceLineItemDateEnd_mm" Default="#Minute(qry_selectInvoiceLineItem.invoiceLineItemDateEnd)#">
		<cfparam Name="Form.invoiceLineItemDateEnd_tt" Default="#TimeFormat(qry_selectInvoiceLineItem.invoiceLineItemDateEnd, 'tt')#">
	</cfif>

	<cfif Variables.displayProductParameter is True>
		<cfloop Query="qry_selectInvoiceLineItemParameterList">
			<cfset Variables.parameterOptionRow = ListFind(ValueList(qry_selectProductParameterOptionList.productParameterOptionID), qry_selectInvoiceLineItemParameterList.productParameterOptionID)>
			<cfif Variables.parameterOptionRow is not 0>
				<cfparam Name="Form.parameter#qry_selectProductParameterOptionList.productParameterID[Variables.parameterOptionRow]#" Default="#qry_selectInvoiceLineItemParameterList.productParameterOptionID#">
			</cfif>
		</cfloop>
	</cfif>

	<cfparam Name="Form.userID" Default="#ValueList(qry_selectInvoiceLineItemUser.userID)#">

<cfelseif Variables.doAction is "insertInvoiceLineItem" and URL.productID gt 0 and Not IsDefined("Form.isFormSubmitted")>
	<cfparam Name="Form.invoiceLineItemName" Default="#qry_selectProductLanguage.productLanguageLineItemName#">
	<cfparam Name="Form.invoiceLineItemDescription" Default="#qry_selectProductLanguage.productLanguageLineItemDescription#">
	<cfparam Name="Form.invoiceLineItemDescriptionHtml" Default="#qry_selectProductLanguage.productLanguageLineItemDescriptionHtml#">
	<cfparam Name="Form.invoiceLineItemPriceUnit" Default="#qry_selectProduct.productPrice#">
	<cfparam Name="Form.invoiceLineItemPriceNormal" Default="#qry_selectProduct.productPrice#">
	<cfparam Name="Form.invoiceLineItemProductID_custom" Default="#qry_selectProduct.productID_custom#">
</cfif>

<cfparam Name="Form.userID" Default="">
<cfparam Name="Form.invoiceLineItemName" Default="">
<cfparam Name="Form.invoiceLineItemDescription" Default="">
<cfparam Name="Form.invoiceLineItemDescriptionHtml" Default="0">
<cfparam Name="Form.invoiceLineItemQuantity" Default="1">
<cfparam Name="Form.invoiceLineItemPriceUnit" Default="0">
<cfparam Name="Form.invoiceLineItemPriceNormal" Default="0">
<cfparam Name="Form.invoiceLineItemSubTotal" Default="0">
<cfparam Name="Form.invoiceLineItemDiscount" Default="0">
<cfparam Name="Form.invoiceLineItemTotal" Default="0">
<cfparam Name="Form.invoiceLineItemTotalTax" Default="0">
<cfparam Name="Form.invoiceLineItemStatus" Default="1">
<cfparam Name="Form.invoiceLineItemManual" Default="1">
<cfparam Name="Form.invoiceLineItemProductID_custom" Default="">
<cfparam Name="Form.productParameterExceptionID" Default="0">
<cfparam Name="Form.regionID" Default="0">
<cfparam Name="Form.priceID" Default="0">
<cfparam Name="Form.categoryID" Default="0">
<cfparam Name="Form.invoiceLineItemOrder" Default="0">

<cfparam Name="Form.invoiceLineItemDateBegin_date" Default="">
<cfparam Name="Form.invoiceLineItemDateBegin_hh" Default="12">
<cfparam Name="Form.invoiceLineItemDateBegin_mm" Default="00">
<cfparam Name="Form.invoiceLineItemDateBegin_tt" Default="am">

<cfparam Name="Form.invoiceLineItemDateEnd_date" Default="">
<cfparam Name="Form.invoiceLineItemDateEnd_hh" Default="12">
<cfparam Name="Form.invoiceLineItemDateEnd_mm" Default="00">
<cfparam Name="Form.invoiceLineItemDateEnd_tt" Default="am">

<cfif Variables.displayProductParameter is True>
	<cfloop Query="qry_selectProductParameterList">
		<cfparam Name="Form.parameter#qry_selectProductParameterList.productParameterID#" Default="">
	</cfloop>
</cfif>

