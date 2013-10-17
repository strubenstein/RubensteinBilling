<cfoutput>
avSalesCommission.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
<cfloop Index="field" List="salesCommissionID,commissionID,primaryTargetID,targetID,commissionStageID,commissionVolumeDiscountID">
	<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avSalesCommission.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif>
</cfloop>
<cfloop Index="field" List="salesCommissionAmount,salesCommissionBasisTotal">
	<cfif StructKeyExists(Arguments, "#field#_min") and IsNumeric(Arguments["#field#_min"])>AND avSalesCommission.#field# >= <cfqueryparam value="#Arguments["#field#_min"]#" cfsqltype="cf_sql_money"></cfif>
	<cfif StructKeyExists(Arguments, "#field#_max") and IsNumeric(Arguments["#field#_max"])>AND avSalesCommission.#field# <= <cfqueryparam value="#Arguments["#field#_max"]#" cfsqltype="cf_sql_money"></cfif>
</cfloop>
<cfloop Index="field" List="salesCommissionFinalized,salesCommissionStatus,salesCommissionManual">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>AND avSalesCommission.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "salesCommissionPaid") and Arguments.salesCommissionPaid is 1>
	AND avSalesCommission.salesCommissionPaid = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
 <cfelseif StructKeyExists(Arguments, "salesCommissionPaid") and (Arguments.salesCommissionPaid is "" or Arguments.salesCommissionPaid is 0)>
	AND (avSalesCommission.salesCommissionPaid = <cfqueryparam value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#"> OR avSalesCommission.salesCommissionPaid IS NULL)
</cfif>
<cfloop Index="field" List="salesCommissionDateFinalized,salesCommissionDatePaid,salesCommissionDateBegin,salesCommissionDateEnd,salesCommissionDateCreated,salesCommissionDateUpdated,salesCommissionDateExported">
	<cfif StructKeyExists(Arguments, "#field#_from") and IsDate(Arguments["#field#_from"])>AND avSalesCommission.#field# >= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp"></cfif>
	<cfif StructKeyExists(Arguments, "#field#_to") and IsDate(Arguments["#field#_to"])>AND avSalesCommission.#field# <= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp"></cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "salesCommissionDateType") and (ListFind(Arguments.salesCommissionDateType, "salesCommissionDateFinalized") or ListFind(Arguments.salesCommissionDateType, "salesCommissionDatePaid") or ListFind(Arguments.salesCommissionDateType, "salesCommissionDateBegin") or ListFind(Arguments.salesCommissionDateType, "salesCommissionDateEnd") or ListFind(Arguments.salesCommissionDateType, "salesCommissionDateCreated") or ListFind(Arguments.salesCommissionDateType, "salesCommissionDateUpdated") or ListFind(Arguments.salesCommissionDateType, "salesCommissionDateExported")) and ((StructKeyExists(Arguments, "salesCommissionDateFrom") and IsDate(Arguments.salesCommissionDateFrom)) or (StructKeyExists(Arguments, "salesCommissionDateTo") and IsDate(Arguments.salesCommissionDateTo)))>
	<cfif StructKeyExists(Arguments, "salesCommissionDateFrom") and IsDate(Arguments.salesCommissionDateFrom)>
		<cfif StructKeyExists(Arguments, "salesCommissionDateTo") and IsDate(Arguments.salesCommissionDateTo)>
			<cfset dateClause = "BETWEEN " & CreateODBCDateTime(Arguments.salesCommissionDateFrom) & " AND " & CreateODBCDateTime(Arguments.salesCommissionDateTo)>
		<cfelse>
			<cfset dateClause = ">= " & CreateODBCDateTime(Arguments.salesCommissionDateFrom)>
		</cfif>
	<cfelseif StructKeyExists(Arguments, "salesCommissionDateTo") and IsDate(Arguments.salesCommissionDateTo)>
		<cfset dateClause = "<= " & CreateODBCDateTime(Arguments.salesCommissionDateTo)>
	</cfif>

	<cfset displayAnd = True>
	<cfloop Index="field" List="salesCommissionDateFinalized,salesCommissionDatePaid,salesCommissionDateBegin,salesCommissionDateEnd,salesCommissionDateCreated,salesCommissionDateUpdated,salesCommissionDateExported">
		<cfif ListFind(Arguments.salesCommissionDateType, field)><cfif displayAnd is True> AND (<cfset displayAnd = False><cfelse> OR </cfif> avSalesCommission.#field# #dateClause# </cfif>
	</cfloop>
	<cfif displayAnd is False>)</cfif>
</cfif>
<cfloop Index="field" List="invoiceID,invoiceLineItemID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avSalesCommission.salesCommissionID IN (SELECT salesCommissionID FROM avSalesCommissionInvoice WHERE #field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">)) </cfif></cfloop>
<cfif StructKeyExists(Arguments, "statusID") and Application.fn_IsIntegerList(Arguments.statusID)>
	AND avSalesCommission.salesCommissionID <cfif Arguments.statusID is 0>NOT</cfif> 
	IN (
		SELECT targetID
		FROM avStatusHistory
		WHERE primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('salesCommissionID')#" cfsqltype="cf_sql_integer"> 
			AND statusHistoryStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			<cfif Arguments.statusID is not 0>AND statusID IN (<cfqueryparam value="#Arguments.statusID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
		)
</cfif>

<cfset fieldList = "">
<cfloop Index="field" List="companyID,userID,subscriberID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])><cfset fieldList = ListAppend(fieldList, field)></cfif></cfloop>
<cfif fieldList is not "">
	AND avSalesCommission.salesCommissionID IN
		(
		SELECT avSalesCommissionInvoice.salesCommissionID
		FROM avSalesCommissionInvoice, avInvoice
		WHERE avSalesCommissionInvoice.invoiceID = avInvoice.invoiceID
			<cfloop Index="field" List="#fieldList#"> AND avInvoice.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfloop>
		)
</cfif>
<cfset fieldList = "">
<cfloop Index="field" List="subscriptionID,priceID,categoryID,productID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])><cfset fieldList = ListAppend(fieldList, field)></cfif></cfloop>
<cfif fieldList is not "">
	AND avSalesCommission.salesCommissionID IN
		(
		SELECT avSalesCommissionInvoice.salesCommissionID
		FROM avSalesCommissionInvoice, avInvoiceLineItem
		WHERE avSalesCommissionInvoice.invoiceLineItemID = avInvoiceLineItem.invoiceLineItemID
			<cfloop Index="field" List="#fieldList#"> AND avInvoiceLineItem.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfloop>
		)
</cfif>
<cfset fieldList = "">
<cfloop Index="field" List="cobrandID,affiliateID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])><cfset fieldList = ListAppend(fieldList, field)></cfif></cfloop>
<cfif fieldList is not "">
	AND avSalesCommission.salesCommissionID IN
		(
		SELECT avSalesCommissionInvoice.salesCommissionID
		FROM avSalesCommissionInvoice, avInvoice, avCompany
		WHERE avSalesCommissionInvoice.invoiceID = avInvoice.invoiceID
			AND avInvoice.companyID = avCompany.companyID
			<cfloop Index="field" List="#fieldList#"> AND avCompany.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfloop>
		)
</cfif>
<cfif StructKeyExists(Arguments, "salesCommissionIsExported") and (Arguments.salesCommissionIsExported is "" or ListFind("0,1", Arguments.salesCommissionIsExported))>
	AND avSalesCommission.salesCommissionIsExported <cfif Arguments.salesCommissionIsExported is "">IS NULL<cfelse>= <cfqueryparam value="#Arguments.salesCommissionIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
</cfif>
</cfoutput>
