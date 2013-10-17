<cfoutput>
avInvoice.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
<cfif StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerList(Arguments.invoiceID)>AND avInvoice.invoiceID IN (<cfqueryparam value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID) and StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
	AND (avInvoice.companyID IN (<cfqueryparam value="#Arguments.companyID#" cfsqltype="cf_sql_integer" list="yes">) OR avInvoice.userID IN (<cfqueryparam value="#Arguments.userID#" cfsqltype="cf_sql_integer" list="yes">))
<cfelseif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID)>
	AND avInvoice.companyID IN (<cfqueryparam value="#Arguments.companyID#" cfsqltype="cf_sql_integer" list="yes">)
<cfelseif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
	AND avInvoice.userID IN (<cfqueryparam value="#Arguments.userID#" cfsqltype="cf_sql_integer" list="yes">)
</cfif>
<cfif StructKeyExists(Arguments, "invoiceDateType") and Arguments.invoiceDateType is not "" and ((StructKeyExists(Arguments, "invoiceDateFrom") and IsDate(Arguments.invoiceDateFrom)) or (StructKeyExists(Arguments, "invoiceDateTo") and IsDate(Arguments.invoiceDateTo)))>
	<cfloop Index="iDate" List="#Arguments.invoiceDateType#">
		<cfif ListFind("invoiceDateCreated,invoiceDateClosed,shippingDateSent,invoiceDateCompleted,invoiceDateUpdated,invoiceDatePaid,invoiceDateDue,paymentDateScheduled,invoiceDateExported", iDate)>
			<cfswitch expression="#iDate#">
			<cfcase value="shippingDateSent">AND avInvoice.invoiceID IN (SELECT avShippingInvoice.invoiceID FROM avShippingInvoice, avShipping WHERE avShippingInvoice.shippingID = avShipping.shippingID AND avShippingInvoice.invoiceID = avInvoice.invoiceID AND avShipping.shippingDateSent</cfcase>
			<cfcase value="paymentDateScheduled">AND avInvoice.invoiceID IN (SELECT avInvoicePayment.invoiceID FROM avInvoicePayment, avPayment WHERE avInvoicePayment.paymentID = avPayment.paymentID AND avInvoicePayment.invoiceID = avInvoice.invoiceID AND avPayment.paymentDateScheduled</cfcase>
			<cfdefaultcase>AND avInvoice.#iDate#</cfdefaultcase>
			</cfswitch>
			<cfif StructKeyExists(Arguments, "invoiceDateFrom") and IsDate(Arguments.invoiceDateFrom) and StructKeyExists(Arguments, "invoiceDateTo") and IsDate(Arguments.invoiceDateTo)>
				BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments.invoiceDateFrom)#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments.invoiceDateTo)#" cfsqltype="cf_sql_timestamp">
			<cfelseif StructKeyExists(Arguments, "invoiceDateFrom") and IsDate(Arguments.invoiceDateFrom)>
				>= <cfqueryparam value="#CreateODBCDateTime(Arguments.invoiceDateFrom)#" cfsqltype="cf_sql_timestamp">
			<cfelse><!--- StructKeyExists(Arguments, "invoiceDateTo") and IsDate(Arguments.invoiceDateTo) --->
				<= <cfqueryparam value="#CreateODBCDateTime(Arguments.invoiceDateTo)#" cfsqltype="cf_sql_timestamp">
			</cfif>
			<cfif ListFind("paymentDateScheduled,shippingDateSent", iDate)>)</cfif>
		</cfif>
	</cfloop>
</cfif>
<cfloop Index="field" List="invoiceDatePaid,invoiceDateClosed,invoiceDateCompleted,invoiceDateDue,invoiceDateCreated,invoiceDateExported">
	<cfif StructKeyExists(Arguments, "#field#_from") and IsDate(Arguments["#field#_from"])>AND avInvoice.#field# >= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp"></cfif>
	<cfif StructKeyExists(Arguments, "#field#_to") and IsDate(Arguments["#field#_to"])>AND avInvoice.#field# <= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp"></cfif>
</cfloop>
<cfloop Index="field" List="invoiceTotal,invoiceTotalLineItem,invoiceTotalPaymentCredit,invoiceTotalShipping,invoiceTotalTax">
	<cfif StructKeyExists(Arguments, "#field#_min") and IsNumeric(Arguments["#field#_min"])>AND avInvoice.#field# >= <cfqueryparam value="#Arguments['#field#_from']#" cfsqltype="cf_sql_money"></cfif>
	<cfif StructKeyExists(Arguments, "#field#_max") and IsNumeric(Arguments["#field#_max"])>AND avInvoice.#field# <= <cfqueryparam value="#Arguments['#field#_from']#" cfsqltype="cf_sql_money"></cfif>
</cfloop>
<cfloop Index="field" List="invoiceClosed,invoiceStatus,invoiceManual,invoiceCompleted,invoiceSent"><cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avInvoice.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif></cfloop>
<cfloop Index="field" List="invoicePaid,invoiceShipped"><cfif StructKeyExists(Arguments, field) and Arguments[field] is 1>AND avInvoice.#field# = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"><cfelseif StructKeyExists(Arguments, field) and (Arguments[field] is "" or Arguments[field] is 0)> AND (avInvoice.#field# = 0 OR avInvoice.#field# IS NULL) </cfif></cfloop>
<cfif StructKeyExists(Arguments, "invoiceHasInstructions") and ListFind("0,1", Arguments.invoiceHasInstructions)>AND avInvoice.invoiceInstructions IS <cfif Arguments.invoiceHasInstructions is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "invoiceHasCustomID") and ListFind("0,1", Arguments.invoiceHasCustomID)>AND avInvoice.invoiceID_custom <cfif Arguments.invoiceHasCustomID is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>AND avCompany.affiliateID IN (<cfqueryparam value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>AND avCompany.cobrandID IN (<cfqueryparam value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "statusID") and Application.fn_IsIntegerList(Arguments.statusID)>AND avInvoice.invoiceID <cfif Arguments.statusID is 0>NOT</cfif> IN (SELECT targetID FROM avStatusHistory WHERE primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('invoiceID')#" cfsqltype="cf_sql_integer"> <cfif Arguments.statusID is not 0>AND statusID IN (<cfqueryparam value="#Arguments.statusID#" cfsqltype="cf_sql_integer" list="yes">)</cfif> AND statusHistoryStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)</cfif>
<cfif StructKeyExists(Arguments, "invoiceShippingMethod")>AND avInvoice.invoiceShippingMethod = <cfqueryparam value="#Arguments.invoiceShippingMethod#" cfsqltype="cf_sql_varchar"></cfif>
<cfif StructKeyExists(Arguments, "invoiceHasCustomPrice") and ListFind("0,1", Arguments.invoiceHasCustomPrice)>AND avInvoice.invoiceID IN (SELECT avInvoiceLineItem.invoiceID FROM avInvoice, avInvoiceLineItem WHERE avInvoice.invoiceID = avInvoiceLineItem.invoiceID AND avInvoice.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"> AND avInvoiceLineItem.invoiceLineItemStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND avInvoiceLineItem.priceID <cfif Arguments.invoiceHasCustomPrice is 0> = 0 <cfelse> <> 0 </cfif>)</cfif>
<cfif StructKeyExists(Arguments, "invoiceHasMultipleItems") and ListFind("0,1", Arguments.invoiceHasMultipleItems)>AND avInvoice.invoiceID IN (SELECT avInvoice.invoiceID FROM avInvoice, avInvoiceLineItem WHERE avInvoice.invoiceID = avInvoiceLineItem.invoiceID AND avInvoice.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"> AND avInvoiceLineItem.invoiceLineItemStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> GROUP BY avInvoice.invoiceID HAVING COUNT(avInvoiceLineItem.invoiceID) <cfif Arguments.invoiceHasMultipleItems is 0> <= 1 <cfelse> > 1 </cfif>)</cfif>
<cfif StructKeyExists(Arguments, "subscriberID") and Application.fn_IsIntegerList(Arguments.subscriberID)>AND avInvoice.subscriberID <cfif Arguments.subscriberID is 0> = 0 <cfelseif Arguments.subscriberID is -1> <> 0 <cfelse> IN (#Arguments.subscriberID#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfif>
<cfif StructKeyExists(Arguments, "invoiceID_not") and Application.fn_IsIntegerList(Arguments.invoiceID_not)>AND avInvoice.invoiceID NOT IN (<cfqueryparam value="#Arguments.invoiceID_not#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "payflowID") and Application.fn_IsIntegerList(Arguments.payflowID)>AND avInvoice.invoiceID IN (SELECT invoiceID FROM avPayflowInvoice WHERE payflowID IN (<cfqueryparam value="#Arguments.payflowID#" cfsqltype="cf_sql_integer" list="yes">) AND payflowInvoiceStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)</cfif>
<cfif StructKeyExists(Arguments, "productID") and Arguments.productID is not 0 and Application.fn_IsIntegerList(Arguments.productID)>AND avInvoice.invoiceID IN (SELECT avInvoice.invoiceID FROM avInvoice, avInvoiceLineItem WHERE avInvoice.invoiceID = avInvoiceLineItem.invoiceID AND avInvoice.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"> AND avInvoiceLineItem.invoiceLineItemStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND productID IN (<cfqueryparam value="#Arguments.productID#" cfsqltype="cf_sql_integer" list="yes">))</cfif>
<cfif StructKeyExists(Arguments, "priceID") and Arguments.priceID is not 0 and Application.fn_IsIntegerList(Arguments.priceID)>AND avInvoice.invoiceID IN (SELECT avInvoice.invoiceID FROM avInvoice, avInvoiceLineItem WHERE avInvoice.invoiceID = avInvoiceLineItem.invoiceID AND avInvoice.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"> AND avInvoiceLineItem.invoiceLineItemStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND priceID IN (<cfqueryparam value="#Arguments.priceID#" cfsqltype="cf_sql_integer" list="yes">))</cfif>
<cfif StructKeyExists(Arguments, "invoiceHasPaymentCredit") and ListFind("0,1", Arguments.invoiceHasPaymentCredit)>AND avInvoice.invoiceTotalPaymentCredit <cfif Arguments.invoiceHasPaymentCredit is 1> <> 0 <cfelse> = 0 </cfif></cfif>
<cfif StructKeyExists(Arguments, "invoiceIsExported") and (Arguments.invoiceIsExported is "" or ListFind("0,1", Arguments.invoiceIsExported))>AND avInvoice.invoiceIsExported <cfif Arguments.invoiceIsExported is "">IS NULL<cfelse>= <cfqueryparam value="#Arguments.invoiceIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
</cfoutput>
