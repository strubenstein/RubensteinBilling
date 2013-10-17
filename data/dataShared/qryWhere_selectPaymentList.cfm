<cfoutput>
avPayment.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
<cfloop Index="field" List="affiliateID,cobrandID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND TargetCompany.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
<cfloop Index="field" List="userID_author,userID,companyID,paymentID,paymentCheckNumber,creditCardID,bankID,merchantAccountID,paymentCategoryID,subscriberID,paymentID_refund,subscriberProcessID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avPayment.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
<cfloop Index="field" List="paymentManual,paymentStatus,paymentProcessed,paymentIsRefund"><cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avPayment.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif></cfloop>
<cfif StructKeyExists(Arguments, "paymentApproved")><cfif Arguments.paymentApproved is "">AND avPayment.paymentApproved IS NULL<cfelseif ListFind("0,1", Arguments.paymentApproved)>AND avPayment.paymentApproved = <cfqueryparam value="#Arguments.paymentApproved#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentHasCreditCardID") and ListFind("0,1", Arguments.paymentHasCreditCardID)>AND avPayment.creditCardID <cfif Arguments.paymentHasCreditCardID is 0> = 0 <cfelse> <> 0 </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentHasBankID") and ListFind("0,1", Arguments.paymentHasBankID)>AND avPayment.bankID <cfif Arguments.paymentHasBankID is 0> = 0 <cfelse> <> 0 </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentHasCheckNumber") and ListFind("0,1", Arguments.paymentHasCheckNumber)>AND avPayment.paymentCheckNumber <cfif Arguments.paymentHasCheckNumber is 0> = 0 <cfelse> <> 0 </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentAmount") and IsNumeric(Arguments.paymentAmount)>AND avPayment.paymentAmount = <cfqueryparam value="#Arguments.paymentAmount#" cfsqltype="cf_sql_money"></cfif>
<cfif StructKeyExists(Arguments, "paymentAmount_min") and IsNumeric(Arguments.paymentAmount_min) and StructKeyExists(Arguments, "paymentAmount_max") and IsNumeric(Arguments.paymentAmount_max)>
	AND avPayment.paymentAmount BETWEEN <cfqueryparam value="#Arguments.paymentAmount_min#" cfsqltype="cf_sql_money"> AND <cfqueryparam value="#Arguments.paymentAmount_max#" cfsqltype="cf_sql_money">
 <cfelseif StructKeyExists(Arguments, "paymentAmount_min") and IsNumeric(Arguments.paymentAmount_min)>
	AND avPayment.paymentAmount >= <cfqueryparam value="#Arguments.paymentAmount_min#" cfsqltype="cf_sql_money">
 <cfelseif StructKeyExists(Arguments, "paymentAmount_max") and IsNumeric(Arguments.paymentAmount_max)>
	AND avPayment.paymentAmount <= <cfqueryparam value="#Arguments.paymentAmount_max#" cfsqltype="cf_sql_money">
</cfif>
<cfif StructKeyExists(Arguments, "paymentCheckNumber_min") and IsNumeric(Arguments.paymentCheckNumber_min) and StructKeyExists(Arguments, "paymentCheckNumber_max") and IsNumeric(Arguments.paymentCheckNumber_max)>
	AND avPayment.paymentCheckNumber BETWEEN <cfqueryparam value="#Arguments.paymentCheckNumber_min#" cfsqltype="cf_sql_smallint"> AND <cfqueryparam value="#Arguments.paymentCheckNumber_max#" cfsqltype="cf_sql_smallint">
 <cfelseif StructKeyExists(Arguments, "paymentCheckNumber_min") and IsNumeric(Arguments.paymentCheckNumber_min)>
	AND avPayment.paymentCheckNumber >= <cfqueryparam value="#Arguments.paymentCheckNumber_min#" cfsqltype="cf_sql_smallint">
 <cfelseif StructKeyExists(Arguments, "paymentCheckNumber_max") and IsNumeric(Arguments.paymentCheckNumber_max)>
	AND avPayment.paymentCheckNumber <= <cfqueryparam value="#Arguments.paymentCheckNumber_max#" cfsqltype="cf_sql_smallint">
</cfif>
<cfloop Index="field" List="paymentID_custom,paymentDescription,paymentMessage"><cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not ""> AND avPayment.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar"> </cfif></cfloop>
<cfif StructKeyExists(Arguments, "paymentMethod") and Trim(Arguments.paymentMethod) is not "">AND avPayment.paymentMethod IN (<cfqueryparam value="#Arguments.paymentMethod#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "searchText") and Trim(Arguments.searchText) is not "" and StructKeyExists(Arguments, "searchField") and Trim(Arguments.searchField) is not "">
	<cfset displayOr = False>
	<cfloop Index="field" List="paymentID_custom,paymentDescription,paymentMessage,paymentMethod">
		<cfif ListFind(Arguments.searchField, field)><cfif displayOr is True>OR<cfelse>AND (<cfset displayOr = True></cfif> avPayment.#field# LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar"></cfif>
	</cfloop>
	<cfif displayOr is True>)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "paymentHasCustomID") and ListFind("0,1", Arguments.paymentHasCustomID)>AND avPayment.paymentID_custom <cfif Arguments.paymentHasCustomID is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentIsScheduled") and ListFind("0,1", Arguments.paymentIsScheduled)>AND avPayment.paymentDateScheduled IS <cfif Arguments.paymentIsScheduled is 1> NOT </cfif> NULL</cfif>
<cfif StructKeyExists(Arguments, "paymentHasDescription") and ListFind("0,1", Arguments.paymentHasDescription)>AND avPayment.paymentDescription <cfif Arguments.paymentHasDescription is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentHasMessage") and ListFind("0,1", Arguments.paymentHasMessage)>AND avPayment.paymentMessage <cfif Arguments.paymentHasMessage is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentHasCreditCardType") and ListFind("0,1", Arguments.paymentHasCreditCardType)>AND avPayment.paymentCreditCardType <cfif Arguments.paymentHasCreditCardType is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfloop Index="field" List="paymentDateReceived,paymentDateScheduled,paymentDateCreated,paymentDateUpdated,paymentDateExported">
	<cfif StructKeyExists(Arguments, "#field#_from") and IsDate(Arguments["#field#_from"]) and StructKeyExists(Arguments, "#field#_to") and IsDate(Arguments["#field#_to"])>
		AND avPayment.#field# BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp">
	<cfelseif StructKeyExists(Arguments, "#field#_from") and IsDate(Arguments["#field#_from"])>
		AND avPayment.#field# >= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp">
	<cfelseif StructKeyExists(Arguments, "#field#_to") and IsDate(Arguments["#field#_to"])>
		AND avPayment.#field# <= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp">
	</cfif>
</cfloop>
<cfif ((StructKeyExists(Arguments, "paymentDateFrom") and IsDate(Arguments.paymentDateFrom)) or (StructKeyExists(Arguments, "paymentDateTo") and IsDate(Arguments.paymentDateTo))) and StructKeyExists(Arguments, "paymentDateType") and Trim(Arguments.paymentDateType) is not "">
	<cfif StructKeyExists(Arguments, "paymentDateFrom") and IsDate(Arguments.paymentDateFrom) and StructKeyExists(Arguments, "paymentDateTo") and IsDate(Arguments.paymentDateTo)>
		<cfset paymentDateClause = " BETWEEN " & CreateODBCDateTime(Arguments.paymentDateFrom) & " AND " & CreateODBCDateTime(Arguments.paymentDateTo)>
	<cfelseif StructKeyExists(Arguments, "paymentDateFrom") and IsDate(Arguments.paymentDateFrom)>
		<cfset paymentDateClause = " >= " & CreateODBCDateTime(Arguments.paymentDateFrom)>
	<cfelseif StructKeyExists(Arguments, "paymentDateTo") and IsDate(Arguments.paymentDateTo)>
		<cfset paymentDateClause = " <= " & CreateODBCDateTime(Arguments.paymentDateTo)>
	</cfif>	
	<cfset displayOr = False>
	<cfloop Index="field" List="paymentDateReceived,paymentDateScheduled,paymentDateCreated,paymentDateUpdated,paymentDateExported">
		<cfif ListFind(Arguments.paymentDateType, field)><cfif displayOr is True>OR<cfelse>AND (<cfset displayOr = True></cfif>avPayment.#field# #paymentDateClause#</cfif>
	</cfloop>
	<cfif displayOr is True>)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerList(Arguments.invoiceID)>AND avPayment.paymentID IN (SELECT paymentID FROM avInvoicePayment WHERE invoiceID IN (<cfqueryparam value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" list="yes">))</cfif>
<cfif StructKeyExists(Arguments, "paymentAppliedToInvoice") and ListFind("0,1", Arguments.paymentAppliedToInvoice)>AND avPayment.paymentID <cfif Arguments.paymentAppliedToInvoice is 0> NOT </cfif> IN (SELECT paymentID FROM avInvoicePayment WHERE companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "paymentAppliedToMultipleInvoices") and ListFind("0,1", Arguments.paymentAppliedToMultipleInvoices)>
	AND avPayment.paymentID <cfif Arguments.paymentAppliedToMultipleInvoices is 0> NOT </cfif> IN (SELECT paymentID FROM avInvoicePayment GROUP BY paymentID HAVING COUNT(paymentID) > 1)
</cfif>
<cfif StructKeyExists(Arguments, "paymentID_not") and Application.fn_IsIntegerList(Arguments.paymentID_not)>AND avPayment.paymentID NOT IN (<cfqueryparam value="#Arguments.paymentID_not#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfloop Index="field" List="productID,subscriptionID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>	AND avPayment.paymentID IN (SELECT paymentID FROM avPaymentRefundProduct WHERE #field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
<cfif StructKeyExists(Arguments, "paymentHasBeenRefunded") and ListFind("0,1", Arguments.paymentHasBeenRefunded)>AND avPayment.paymentID_refund <cfif Arguments.paymentHasBeenRefunded is 0> = 0 <cfelse> <> 0 </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentIsFullyApplied") and ListFind("0,1", Arguments.paymentIsFullyApplied)>
	<cfif Arguments.paymentIsFullyApplied is 1>
 		AND avPayment.paymentAmount <= (SELECT SUM(avInvoicePayment.invoicePaymentAmount) FROM avInvoicePayment WHERE avInvoicePayment.paymentID = avPayment.paymentID)
	<cfelse>
		AND (avPayment.paymentAmount > (SELECT SUM(avInvoicePayment.invoicePaymentAmount) FROM avInvoicePayment WHERE avInvoicePayment.paymentID = avPayment.paymentID)
			OR avPayment.paymentID NOT IN (SELECT avInvoicePayment.paymentID FROM avInvoicePayment WHERE avInvoicePayment.paymentID = avPayment.paymentID))
	 </cfif>
</cfif>
<cfif StructKeyExists(Arguments, "paymentIsExported") and (Arguments.paymentIsExported is "" or ListFind("0,1", Arguments.paymentIsExported))>AND avPayment.paymentIsExported <cfif Arguments.paymentIsExported is "">IS NULL<cfelse>= <cfqueryparam value="#Arguments.paymentIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
</cfoutput>
