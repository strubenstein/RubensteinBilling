<!--- enable price if after begin date (and not already enabled) --->
<cfquery Name="qry_checkPriceDateBegin" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avPrice
	SET priceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	WHERE priceStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND priceDateBegin <= #Application.billingSql.sql_nowDateTime#
		AND (priceDateEnd IS NULL OR priceDateEnd >= #Application.billingSql.sql_nowDateTime#)
		AND priceIsParent = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
</cfquery>

<!--- disable price if after end date (and not already disabled) --->
<cfquery Name="qry_checkPriceDateEnd" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avPrice
	SET priceStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	WHERE priceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND priceDateEnd IS NOT NULL
		AND priceDateEnd <= #Application.billingSql.sql_nowDateTime#
</cfquery>

<!--- disable price if maximum quantity has been reached (and not already disabled) --->
<cfquery Name="qry_checkPriceQuantityMaximumAllCustomers" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avPrice
	SET priceStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	WHERE priceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND productID <> 0
		AND priceQuantityMaximumAllCustomers > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
		AND priceQuantityMaximumAllCustomers <=
			(
			SELECT Sum(avInvoiceLineItem.invoiceLineItemQuantity)
			FROM avInvoiceLineItem, avInvoice
			WHERE avInvoiceLineItem.invoiceID = avInvoice.invoiceID
				AND avInvoiceLineItem.productID  = avPrice.productID
				AND avInvoiceLineItem.priceID = avPrice.priceID
				AND avInvoice.invoiceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND avInvoice.invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			)
</cfquery>
