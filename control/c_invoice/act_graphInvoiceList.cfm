<cfinclude template="../../view/v_invoice/lang_graphInvoiceList.cfm">

<!--- # and $ closed by unpaid, partially paid, fully paid --->
<cfset qryParamStructTemp = StructCopy(qryParamStruct)>
<cfset qryParamStructTemp.invoiceClosed = 1>
<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_summary" ReturnVariable="qry_selectInvoiceList_paid" argumentCollection="#qryParamStructTemp#">
	<cfinvokeargument name="invoiceField" value="invoicePaid">
	<cfinvokeargument name="returnInvoiceField" value="True">
</cfinvoke>

<cfset Variables.invoicePaidArray = ArrayNew(1)>
<cfloop Query="qry_selectInvoiceList_paid">
	<cfswitch expression="#qry_selectInvoiceList_paid.invoicePaid#">
	<cfcase value="1"><cfset Variables.invoicePaidArray[CurrentRow] = Variables.lang_graphInvoiceList_title.invoicePaid_full></cfcase>
	<cfcase value="0"><cfset Variables.invoicePaidArray[CurrentRow] = Variables.lang_graphInvoiceList_title.invoicePaid_partial></cfcase>
	<cfdefaultcase><cfset Variables.invoicePaidArray[CurrentRow] = Variables.lang_graphInvoiceList_title.invoicePaid_not></cfdefaultcase>
	</cfswitch>
</cfloop>
<cfset temp = QueryAddColumn(qry_selectInvoiceList_paid, "InvoicePaidStatus", Variables.invoicePaidArray)>

<!--- # and $ by status: open, closed, completed --->
<cfset qryParamStructTemp = StructCopy(qryParamStruct)>
<cfset qryParamStructTemp.invoiceCompleted = 0>
<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_summary" ReturnVariable="qry_selectInvoiceList_closed" argumentCollection="#qryParamStructTemp#">
	<cfinvokeargument name="invoiceField" value="invoiceClosed">
	<cfinvokeargument name="returnInvoiceField" value="True">
</cfinvoke>

<cfset qryParamStructTemp = StructCopy(qryParamStruct)>
<cfset qryParamStructTemp.invoiceCompleted = 1>
<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_summary" ReturnVariable="qry_selectInvoiceList_completed" argumentCollection="#qryParamStructTemp#">
	<cfinvokeargument name="invoiceField" value="invoiceCompleted">
	<cfinvokeargument name="returnInvoiceField" value="False">
</cfinvoke>

<cfset temp = QueryAddRow(qry_selectInvoiceList_closed, 1)>
<cfset temp = QuerySetCell(qry_selectInvoiceList_closed, "invoiceClosed", 2)>
<cfset temp = QuerySetCell(qry_selectInvoiceList_closed, "countInvoice", qry_selectInvoiceList_completed.countInvoice)>
<cfset temp = QuerySetCell(qry_selectInvoiceList_closed, "sumInvoiceTotal", qry_selectInvoiceList_completed.sumInvoiceTotal)>
<cfset temp = QuerySetCell(qry_selectInvoiceList_closed, "sumInvoiceTotalTax", qry_selectInvoiceList_completed.sumInvoiceTotalLineItem)>
<cfset temp = QuerySetCell(qry_selectInvoiceList_closed, "sumInvoiceTotalPaymentCredit", qry_selectInvoiceList_completed.sumInvoiceTotalPaymentCredit)>
<cfset temp = QuerySetCell(qry_selectInvoiceList_closed, "sumInvoiceTotalShipping", qry_selectInvoiceList_completed.sumInvoiceTotalShipping)>

<cfset Variables.invoiceClosedArray = ArrayNew(1)>
<cfloop Query="qry_selectInvoiceList_closed">
	<cfswitch expression="#qry_selectInvoiceList_closed.invoiceClosed#">
	<cfcase value="0"><cfset Variables.invoiceClosedArray[CurrentRow] = Variables.lang_graphInvoiceList_title.invoiceClosed_open></cfcase>
	<cfcase value="1"><cfset Variables.invoiceClosedArray[CurrentRow] = Variables.lang_graphInvoiceList_title.invoiceClosed_closed></cfcase>
	<cfcase value="2"><cfset Variables.invoiceClosedArray[CurrentRow] = Variables.lang_graphInvoiceList_title.invoiceClosed_completed></cfcase>
	</cfswitch>
</cfloop>
<cfset temp = QueryAddColumn(qry_selectInvoiceList_closed, "InvoiceClosedStatus", Variables.invoiceClosedArray)>

<!--- # and $ by product --->
<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_product" ReturnVariable="qry_selectInvoiceList_productCount" argumentCollection="#qryParamStruct#">
	<cfinvokeargument name="queryDisplayPerPage" value="10">
	<cfinvokeargument name="queryOrderBy" value="countInvoiceLineItem_d">
</cfinvoke>

<cfset Variables.productRow = ListFind(ValueList(qry_selectInvoiceList_productCount.productID), 0)>
<cfif Variables.productRow is not 0>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_productCount, "productName", Variables.lang_graphInvoiceList_title.productName_custom, Variables.productRow)>
</cfif>

<cfif qry_selectInvoiceList_productCount.RecordCount is 10>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_product" ReturnVariable="qry_selectInvoiceList_productCountOther" argumentCollection="#qryParamStruct#">
		<cfinvokeargument name="queryDisplayPerPage" value="0">
		<cfinvokeargument name="productID_not" value="#ValueList(qry_selectInvoiceList_productCount.productID)#">
	</cfinvoke>

	<cfset temp = QueryAddRow(qry_selectInvoiceList_productCount, 1)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_productCount, "productID", 0)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_productCount, "countInvoiceLineItem", qry_selectInvoiceList_productCountOther.countInvoiceLineItem)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_productCount, "sumInvoiceLineItemTotal", qry_selectInvoiceList_productCountOther.sumInvoiceLineItemTotal)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_productCount, "productName", "(Other)")>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_product" ReturnVariable="qry_selectInvoiceList_productTotal" argumentCollection="#qryParamStruct#">
	<cfinvokeargument name="queryDisplayPerPage" value="10">
	<cfinvokeargument name="queryOrderBy" value="sumInvoiceLineItemTotal_d">
</cfinvoke>

<cfset Variables.productRow = ListFind(ValueList(qry_selectInvoiceList_productTotal.productID), 0)>
<cfif Variables.productRow is not 0>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_productTotal, "productName", Variables.lang_graphInvoiceList_title.productName_custom, Variables.productRow)>
</cfif>

<cfif qry_selectInvoiceList_productTotal.RecordCount is 10>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_product" ReturnVariable="qry_selectInvoiceList_productTotalOther" argumentCollection="#qryParamStruct#">
		<cfinvokeargument name="queryDisplayPerPage" value="0">
		<cfinvokeargument name="productID_not" value="#ValueList(qry_selectInvoiceList_productTotal.productID)#">
	</cfinvoke>

	<cfset temp = QueryAddRow(qry_selectInvoiceList_productTotal, 1)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_productTotal, "productID", 0)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_productTotal, "countInvoiceLineItem", qry_selectInvoiceList_productTotalOther.countInvoiceLineItem)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_productTotal, "sumInvoiceLineItemTotal", qry_selectInvoiceList_productTotalOther.sumInvoiceLineItemTotal)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_productTotal, "productName", Variables.lang_graphInvoiceList_title.productName_other)>
</cfif>


<!--- # and $ by billing state --->
<cfset qryParamStructTemp = StructCopy(qryParamStruct)>
<cfset qryParamStructTemp.invoiceClosed = 1>
<cfset Variables.country_list = "USA,Canada,United States,US">

<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_address" ReturnVariable="qry_selectInvoiceList_stateCount" argumentCollection="#qryParamStructTemp#">
	<cfinvokeargument name="addressField" value="state">
	<cfinvokeargument name="returnAddressField" value="True">
	<cfinvokeargument name="country" value="#Variables.country_list#">
	<cfinvokeargument name="country_isNull" value="True">
	<cfinvokeargument name="queryDisplayPerPage" value="10">
	<cfinvokeargument name="queryOrderBy" value="countInvoice_d">
</cfinvoke>

<cfloop Query="qry_selectInvoiceList_stateCount">
	<cfif qry_selectInvoiceList_stateCount.state is "">
		<cfset temp = QuerySetCell(qry_selectInvoiceList_stateCount, "state", Variables.lang_graphInvoiceList_title.state_none, CurrentRow)>
		<cfbreak>
	</cfif>
</cfloop>

<cfif qry_selectInvoiceList_stateCount.RecordCount is 10>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_address" ReturnVariable="qry_selectInvoiceList_stateCountOther" argumentCollection="#qryParamStructTemp#">
		<cfinvokeargument name="addressField" value="state">
		<cfinvokeargument name="returnAddressField" value="False">
		<cfinvokeargument name="country" value="#Variables.country_list#">
		<cfinvokeargument name="country_isNull" value="True">
		<cfinvokeargument name="queryDisplayPerPage" value="0">
		<cfinvokeargument name="state_not" value="#ValueList(qry_selectInvoiceList_stateCount.state)#">
	</cfinvoke>

	<cfset temp = QueryAddRow(qry_selectInvoiceList_stateCount, 1)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateCount, "state", Variables.lang_graphInvoiceList_title.state_other)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateCount, "countInvoice", qry_selectInvoiceList_stateCountOther.countInvoice)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateCount, "sumInvoiceTotal", qry_selectInvoiceList_stateCountOther.sumInvoiceTotal)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateCount, "sumInvoiceTotalTax", qry_selectInvoiceList_stateCountOther.sumInvoiceTotalTax)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateCount, "countInvoiceLineItem", qry_selectInvoiceList_stateCountOther.countInvoiceLineItem)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateCount, "sumInvoiceTotalLineItem", qry_selectInvoiceList_stateCountOther.sumInvoiceTotalLineItem)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateCount, "sumInvoiceTotalPaymentCredit", qry_selectInvoiceList_stateCountOther.sumInvoiceTotalPaymentCredit)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateCount, "sumInvoiceTotalShipping", qry_selectInvoiceList_stateCountOther.sumInvoiceTotalShipping)>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_address" ReturnVariable="qry_selectInvoiceList_stateTotal" argumentCollection="#qryParamStructTemp#">
	<cfinvokeargument name="addressField" value="state">
	<cfinvokeargument name="returnAddressField" value="True">
	<cfinvokeargument name="country" value="#Variables.country_list#">
	<cfinvokeargument name="country_isNull" value="True">
	<cfinvokeargument name="queryDisplayPerPage" value="10">
	<cfinvokeargument name="queryOrderBy" value="sumInvoiceTotal_d">
</cfinvoke>

<cfloop Query="qry_selectInvoiceList_stateTotal">
	<cfif qry_selectInvoiceList_stateTotal.state is "">
		<cfset temp = QuerySetCell(qry_selectInvoiceList_stateTotal, "state", Variables.lang_graphInvoiceList_title.state_none, CurrentRow)>
		<cfbreak>
	</cfif>
</cfloop>

<cfif qry_selectInvoiceList_stateTotal.RecordCount is 10>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_address" ReturnVariable="qry_selectInvoiceList_stateTotalOther" argumentCollection="#qryParamStructTemp#">
		<cfinvokeargument name="addressField" value="state">
		<cfinvokeargument name="returnAddressField" value="False">
		<cfinvokeargument name="country" value="#Variables.country_list#">
		<cfinvokeargument name="country_isNull" value="True">
		<cfinvokeargument name="queryDisplayPerPage" value="0">
		<cfinvokeargument name="state_not" value="#ValueList(qry_selectInvoiceList_stateTotal.state)#">
	</cfinvoke>

	<cfset temp = QueryAddRow(qry_selectInvoiceList_stateTotal, 1)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateTotal, "state", Variables.lang_graphInvoiceList_title.state_other)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateTotal, "countInvoice", qry_selectInvoiceList_stateTotalOther.countInvoice)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateTotal, "sumInvoiceTotal", qry_selectInvoiceList_stateTotalOther.sumInvoiceTotal)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateTotal, "sumInvoiceTotalTax", qry_selectInvoiceList_stateTotalOther.sumInvoiceTotalTax)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateTotal, "countInvoiceLineItem", qry_selectInvoiceList_stateTotalOther.countInvoiceLineItem)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateTotal, "sumInvoiceTotalLineItem", qry_selectInvoiceList_stateTotalOther.sumInvoiceTotalLineItem)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateTotal, "sumInvoiceTotalPaymentCredit", qry_selectInvoiceList_stateTotalOther.sumInvoiceTotalPaymentCredit)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_stateTotal, "sumInvoiceTotalShipping", qry_selectInvoiceList_stateTotalOther.sumInvoiceTotalShipping)>
</cfif>


<!--- # and $ by billing country --->
<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_address" ReturnVariable="qry_selectInvoiceList_countryCount" argumentCollection="#qryParamStructTemp#">
	<cfinvokeargument name="addressField" value="country">
	<cfinvokeargument name="returnAddressField" value="True">
	<cfinvokeargument name="queryDisplayPerPage" value="10">
	<cfinvokeargument name="queryOrderBy" value="countInvoice_d">
</cfinvoke>

<cfloop Query="qry_selectInvoiceList_countryCount">
	<cfif qry_selectInvoiceList_countryCount.country is "">
		<cfset temp = QuerySetCell(qry_selectInvoiceList_countryCount, "country", Variables.lang_graphInvoiceList_title.country_none, CurrentRow)>
		<cfbreak>
	</cfif>
</cfloop>

<cfif qry_selectInvoiceList_countryCount.RecordCount is 10>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_address" ReturnVariable="qry_selectInvoiceList_countryCountOther" argumentCollection="#qryParamStructTemp#">
		<cfinvokeargument name="addressField" value="country">
		<cfinvokeargument name="returnAddressField" value="False">
		<cfinvokeargument name="queryDisplayPerPage" value="0">
		<cfinvokeargument name="country_not" value="#ValueList(qry_selectInvoiceList_country.country)#">
	</cfinvoke>

	<cfset temp = QueryAddRow(qry_selectInvoiceList_countryCount, 1)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryCount, "country", Variables.lang_graphInvoiceList_title.country_other)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryCount, "countInvoice", qry_selectInvoiceList_countryCountOther.countInvoice)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryCount, "sumInvoiceTotal", qry_selectInvoiceList_countryCountOther.sumInvoiceTotal)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryCount, "sumInvoiceTotalTax", qry_selectInvoiceList_countryCountOther.sumInvoiceTotalTax)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryCount, "countInvoiceLineItem", qry_selectInvoiceList_countryCountOther.countInvoiceLineItem)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryCount, "sumInvoiceTotalLineItem", qry_selectInvoiceList_countryCountOther.sumInvoiceTotalLineItem)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryCount, "sumInvoiceTotalPaymentCredit", qry_selectInvoiceList_countryCountOther.sumInvoiceTotalPaymentCredit)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryCount, "sumInvoiceTotalShipping", qry_selectInvoiceList_countryCountOther.sumInvoiceTotalShipping)>
</cfif>


<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_address" ReturnVariable="qry_selectInvoiceList_countryTotal" argumentCollection="#qryParamStructTemp#">
	<cfinvokeargument name="addressField" value="country">
	<cfinvokeargument name="returnAddressField" value="True">
	<cfinvokeargument name="queryDisplayPerPage" value="10">
	<cfinvokeargument name="queryOrderBy" value="sumInvoiceTotal_d">
</cfinvoke>

<cfloop Query="qry_selectInvoiceList_countryTotal">
	<cfif qry_selectInvoiceList_countryTotal.country is "">
		<cfset temp = QuerySetCell(qry_selectInvoiceList_countryTotal, "country", Variables.lang_graphInvoiceList_title.country_none, CurrentRow)>
		<cfbreak>
	</cfif>
</cfloop>

<cfif qry_selectInvoiceList_countryTotal.RecordCount is 10>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList_address" ReturnVariable="qry_selectInvoiceList_countryTotalOther" argumentCollection="#qryParamStructTemp#">
		<cfinvokeargument name="addressField" value="country">
		<cfinvokeargument name="returnAddressField" value="False">
		<cfinvokeargument name="country_not" value="#ValueList(qry_selectInvoiceList_country.country)#">
		<cfinvokeargument name="queryDisplayPerPage" value="0">
	</cfinvoke>

	<cfset temp = QueryAddRow(qry_selectInvoiceList_countryTotal, 1)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryTotal, "country", Variables.lang_graphInvoiceList_title.country_other)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryTotal, "countInvoice", qry_selectInvoiceList_countryTotalOther.countInvoice)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryTotal, "sumInvoiceTotal", qry_selectInvoiceList_countryTotalOther.sumInvoiceTotal)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryTotal, "sumInvoiceTotalTax", qry_selectInvoiceList_countryTotalOther.sumInvoiceTotalTax)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryTotal, "countInvoiceLineItem", qry_selectInvoiceList_countryTotalOther.countInvoiceLineItem)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryTotal, "sumInvoiceTotalLineItem", qry_selectInvoiceList_countryTotalOther.sumInvoiceTotalLineItem)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryTotal, "sumInvoiceTotalPaymentCredit", qry_selectInvoiceList_countryTotalOther.sumInvoiceTotalPaymentCredit)>
	<cfset temp = QuerySetCell(qry_selectInvoiceList_countryTotal, "sumInvoiceTotalShipping", qry_selectInvoiceList_countryTotalOther.sumInvoiceTotalShipping)>
</cfif>

