<cfoutput>
avPaymentCredit.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
<cfloop Index="field" List="affiliateID,cobrandID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND TargetCompany.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
<cfloop Index="field" List="userID_author,userID,companyID,paymentCreditID,paymentCategoryID,subscriberID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avPaymentCredit.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
<cfloop Index="field" List="paymentCreditStatus,paymentCreditRollover,paymentCreditCompleted,paymentCreditNegativeInvoice"><cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avPaymentCredit.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif></cfloop>
<cfif StructKeyExists(Arguments, "paymentCreditID_not") and Application.fn_IsIntegerList(Arguments.paymentCreditID_not)>AND avPaymentCredit.paymentCreditID NOT IN (<cfqueryparam value="#Arguments.paymentCreditID_not#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerList(Arguments.invoiceID)>AND avPaymentCredit.paymentCreditID IN (SELECT paymentCreditID FROM avInvoicePaymentCredit WHERE invoiceID IN (<cfqueryparam value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" list="yes">))</cfif>
<cfif StructKeyExists(Arguments, "paymentCreditAmount") and IsNumeric(Arguments.paymentCreditAmount)>AND avPaymentCredit.paymentCreditAmount = <cfqueryparam value="#Arguments.paymentCreditAmount#" cfsqltype="cf_sql_money"></cfif>
<cfif StructKeyExists(Arguments, "paymentCreditAmount_min") and IsNumeric(Arguments.paymentCreditAmount_min) and StructKeyExists(Arguments, "paymentCreditAmount_max") and IsNumeric(Arguments.paymentCreditAmount_max)>
	AND avPaymentCredit.paymentCreditAmount BETWEEN <cfqueryparam value="#Arguments.paymentCreditAmount_min#" cfsqltype="cf_sql_money"> AND <cfqueryparam value="#Arguments.paymentCreditAmount_max#" cfsqltype="cf_sql_money">
 <cfelseif StructKeyExists(Arguments, "paymentCreditAmount_min") and IsNumeric(Arguments.paymentCreditAmount_min)>
	AND avPaymentCredit.paymentCreditAmount >= <cfqueryparam value="#Arguments.paymentCreditAmount_min#" cfsqltype="cf_sql_money">
 <cfelseif StructKeyExists(Arguments, "paymentCreditAmount_max") and IsNumeric(Arguments.paymentCreditAmount_max)>
	AND avPaymentCredit.paymentCreditAmount <= <cfqueryparam value="#Arguments.paymentCreditAmount_max#" cfsqltype="cf_sql_money">
</cfif>
<cfloop Index="field" List="paymentCreditName,paymentCreditID_custom,paymentCreditDescription"><cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not ""> AND avPaymentCredit.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar"> </cfif></cfloop>
<cfif StructKeyExists(Arguments, "paymentCreditHasName") and ListFind("0,1", Arguments.paymentCreditHasName)>AND avPaymentCredit.paymentCreditHasName <cfif Arguments.paymentCreditHasName is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentCreditHasCustomID") and ListFind("0,1", Arguments.paymentCreditHasCustomID)>AND avPaymentCredit.paymentCreditID_custom <cfif Arguments.paymentCreditHasCustomID is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentCreditHasDescription") and ListFind("0,1", Arguments.paymentCreditHasDescription)>AND avPaymentCredit.paymentCreditDescription <cfif Arguments.paymentCreditHasDescription is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentCreditAppliedMaximum") and IsNumeric(Arguments.paymentCreditAppliedMaximum)>AND avPaymentCredit.paymentCreditAppliedMaximum = <cfqueryparam value="#Arguments.paymentCreditAppliedMaximum#" cfsqltype="cf_sql_smallint"></cfif>
<cfif StructKeyExists(Arguments, "paymentCreditAppliedMaximumMultiple") and ListFind("0,1", Arguments.paymentCreditAppliedMaximumMultiple)>AND avPaymentCredit.paymentCreditAppliedMaximum <cfif Arguments.paymentCreditAppliedMaximumMultiple is 0> = 1 <cfelse> > 1 </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentCreditApplied") and ListFind("0,1", Arguments.paymentCreditApplied)>AND avPaymentCredit.paymentCreditAppliedCount <cfif Arguments.paymentCreditApplied is 0> = 0 <cfelse> >= 1 </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentCreditAppliedCountMultiple") and ListFind("0,1", Arguments.paymentCreditAppliedCountMultiple)>AND avPaymentCredit.paymentCreditAppliedCount <cfif Arguments.paymentCreditAppliedCountMultiple is 0> = 1 <cfelse> > 1 </cfif></cfif>
<cfif StructKeyExists(Arguments, "paymentCreditAppliedRemaining") and ListFind("0,1", Arguments.paymentCreditAppliedRemaining)>AND avPaymentCredit.paymentCreditAppliedMaximum <cfif Arguments.paymentCreditAppliedRemaining is 1> > <cfelse> <= </cfif> avPaymentCredit.paymentCreditAppliedCount</cfif>
<cfif StructKeyExists(Arguments, "paymentCreditAppliedMaximum_min") and IsNumeric(Arguments.paymentCreditAppliedMaximum_min) and StructKeyExists(Arguments, "paymentCreditAppliedMaximum_max") and IsNumeric(Arguments.paymentCreditAppliedMaximum_max)>
	AND avPaymentCredit.paymentCreditAppliedMaximum BETWEEN <cfqueryparam value="#Arguments.paymentCreditAppliedMaximum_min#" cfsqltype="cf_sql_smallint"> AND <cfqueryparam value="#Arguments.paymentCreditAppliedMaximum_max#" cfsqltype="cf_sql_smallint">
 <cfelseif StructKeyExists(Arguments, "paymentCreditAppliedMaximum_min") and IsNumeric(Arguments.paymentCreditAppliedMaximum_min)>
	AND avPaymentCredit.paymentCreditAppliedMaximum >= <cfqueryparam value="#Arguments.paymentCreditAppliedMaximum_min#" cfsqltype="cf_sql_smallint">
 <cfelseif StructKeyExists(Arguments, "paymentCreditAppliedMaximum_max") and IsNumeric(Arguments.paymentCreditAppliedMaximum_max)>
	AND avPaymentCredit.paymentCreditAppliedMaximum <= <cfqueryparam value="#Arguments.paymentCreditAppliedMaximum_max#" cfsqltype="cf_sql_smallint">
</cfif>
<cfif StructKeyExists(Arguments, "paymentCreditAppliedCount") and IsNumeric(Arguments.paymentCreditAppliedCount)>AND avPaymentCredit.paymentCreditAppliedCount = <cfqueryparam value="#Arguments.paymentCreditAppliedCount#" cfsqltype="cf_sql_smallint"></cfif>
<cfif StructKeyExists(Arguments, "paymentCreditAppliedCount_min") and IsNumeric(Arguments.paymentCreditAppliedCount_min) and StructKeyExists(Arguments, "paymentCreditAppliedCount_max") and IsNumeric(Arguments.paymentCreditAppliedCount_max)>
	AND avPaymentCredit.paymentCreditAppliedCount BETWEEN <cfqueryparam value="#Arguments.paymentCreditAppliedCount_min#" cfsqltype="cf_sql_smallint"> AND <cfqueryparam value="#Arguments.paymentCreditAppliedCount_max#" cfsqltype="cf_sql_smallint">
 <cfelseif StructKeyExists(Arguments, "paymentCreditAppliedCount_min") and IsNumeric(Arguments.paymentCreditAppliedCount_min)>
	AND avPaymentCredit.paymentCreditAppliedCount >= <cfqueryparam value="#Arguments.paymentCreditAppliedCount_min#" cfsqltype="cf_sql_smallint">
 <cfelseif StructKeyExists(Arguments, "paymentCreditAppliedCount_max") and IsNumeric(Arguments.paymentCreditAppliedCount_max)>
	AND avPaymentCredit.paymentCreditAppliedCount <= <cfqueryparam value="#Arguments.paymentCreditAppliedCount_max#" cfsqltype="cf_sql_smallint">
</cfif>
<cfif StructKeyExists(Arguments, "searchText") and Trim(Arguments.searchText) is not "" and StructKeyExists(Arguments, "searchField") and Trim(Arguments.searchField) is not "">
	<cfset displayOr = False>
	<cfloop Index="field" List="paymentCreditID_custom,paymentCreditDescription,paymentCreditName"><cfif ListFind(Arguments.searchField, field)><cfif displayOr is True>OR<cfelse>AND (<cfset displayOr = True></cfif> avPaymentCredit.#field# LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar"> </cfif></cfloop>
	<cfif displayOr is True>)</cfif>
</cfif>
<cfloop Index="field" List="paymentCreditDateBegin,paymentCreditDateEnd,paymentCreditDateCreated,paymentCreditDateUpdated,paymentCreditDateExported">
	<cfif StructKeyExists(Arguments, "#field#_from") and IsDate(Arguments["#field#_from"]) and StructKeyExists(Arguments, "#field#_to") and IsDate(Arguments["#field#_to"])>
		AND avPaymentCredit.#field# BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp">
	<cfelseif StructKeyExists(Arguments, "#field#_from") and IsDate(Arguments["#field#_from"])>
		AND avPaymentCredit.#field# >= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp">
	<cfelseif StructKeyExists(Arguments, "#field#_to") and IsDate(Arguments["#field#_to"])>
		AND avPaymentCredit.#field# <= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp">
	</cfif>
</cfloop>
<cfif ((StructKeyExists(Arguments, "paymentCreditDateFrom") and IsDate(Arguments.paymentCreditDateFrom)) or (StructKeyExists(Arguments, "paymentCreditDateTo") and IsDate(Arguments.paymentCreditDateTo))) and StructKeyExists(Arguments, "paymentCreditDateType") and Trim(Arguments.paymentCreditDateType) is not "">
	<cfif StructKeyExists(Arguments, "paymentCreditDateFrom") and IsDate(Arguments.paymentCreditDateFrom) and StructKeyExists(Arguments, "paymentCreditDateTo") and IsDate(Arguments.paymentCreditDateTo)>
		<cfset paymentCreditDateClause = " BETWEEN " & CreateODBCDateTime(Arguments.paymentCreditDateFrom) & " AND " & CreateODBCDateTime(Arguments.paymentCreditDateTo)>
	<cfelseif StructKeyExists(Arguments, "paymentCreditDateFrom") and IsDate(Arguments.paymentCreditDateFrom)>
		<cfset paymentCreditDateClause = " >= " & CreateODBCDateTime(Arguments.paymentCreditDateFrom)>
	<cfelseif StructKeyExists(Arguments, "paymentCreditDateTo") and IsDate(Arguments.paymentCreditDateTo)>
		<cfset paymentCreditDateClause = " <= " & CreateODBCDateTime(Arguments.paymentCreditDateTo)>
	</cfif>
	<cfset displayOr = False>
	<cfloop Index="field" List="paymentCreditDateBegin,paymentCreditDateEnd,paymentCreditDateCreated,paymentCreditDateUpdated,paymentCreditDateExported">
		<cfif ListFind(Arguments.paymentDateType, field)><cfif displayOr is True>OR<cfelse>AND (<cfset displayOr = True></cfif> avPaymentCredit.#field# #paymentDateClause# </cfif>
	</cfloop>
	<cfif displayOr is True>)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "paymentCreditHasBeginDate") and ListFind("0,1", Arguments.paymentCreditHasBeginDate)>AND avPaymentCredit.paymentCreditDateBegin IS <cfif Arguments.paymentCreditHasBeginDate is 1> NOT </cfif> NULL</cfif>
<cfif StructKeyExists(Arguments, "paymentCreditHasEndDate") and ListFind("0,1", Arguments.paymentCreditHasEndDate)>AND avPaymentCredit.paymentCreditDateEnd IS <cfif Arguments.paymentCreditHasEndDate is 1> NOT </cfif> NULL</cfif>
<cfif StructKeyExists(Arguments, "paymentCreditHasRolledOver") and ListFind("0,1", Arguments.paymentCreditHasRolledOver)>AND avPaymentCredit.paymentCreditID <cfif Arguments.paymentCreditHasRolledOver is 1> NOT </cfif> IN (SELECT paymentCreditID FROM avInvoicePaymentCredit WHERE invoicePaymentCreditRolloverNext = 1)</cfif>
<cfloop Index="field" List="productID,subscriptionID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avPaymentCredit.paymentID IN (SELECT paymentID FROM avPaymentCreditProduct WHERE #field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
<cfif StructKeyExists(Arguments, "paymentCreditIsExported") and (Arguments.paymentCreditIsExported is "" or ListFind("0,1", Arguments.paymentCreditIsExported))>AND avPaymentCredit.paymentCreditIsExported <cfif Arguments.paymentCreditIsExported is "">IS NULL<cfelse>= <cfqueryparam value="#Arguments.paymentCreditIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
</cfoutput>
