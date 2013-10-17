<cfoutput>
avCompany.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
<cfif StructKeyExists(Arguments, "userNewsletterStatus") and ListFind("0,1", Arguments.userNewsletterStatus)>
	AND avUser.userNewsletterStatus = <cfqueryparam value="#Arguments.userNewsletterStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> 
<cfelseif StructKeyExists(Arguments, "newsletterSubscriberStatus") and ListFind("0,1", Arguments.newsletterSubscriberStatus)>
	AND avUser.userNewsletterStatus = <cfqueryparam value="#Arguments.newsletterSubscriberStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> 
</cfif>
<cfif StructKeyExists(Arguments, "userNewsletterHtml") and ListFind("0,1", Arguments.userNewsletterHtml)>
	AND avUser.userNewsletterHtml = <cfqueryparam value="#Arguments.userNewsletterHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
<cfelseif StructKeyExists(Arguments, "newsletterSubscriberHtml") and ListFind("0,1", Arguments.newsletterSubscriberHtml)>
	AND avUser.userNewsletterHtml = <cfqueryparam value="#Arguments.newsletterSubscriberHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
</cfif>
<cfif StructKeyExists(Arguments, "email") and Trim(Arguments.email) is not "">
	AND avUser.email <cfif ListLen(Arguments.email, ",") is 1>LIKE <cfqueryparam value="%#Arguments.email#%" cfsqltype="cf_sql_varchar"><cfelse>IN (<cfqueryparam value="#Arguments.email#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
<cfelseif StructKeyExists(Arguments, "newsletterSubscriberEmail") and Trim(Arguments.newsletterSubscriberEmail) is not "">
	AND avUser.email <cfif ListLen(Arguments.newsletterSubscriberEmail, ",") is 1>LIKE <cfqueryparam value="%#Arguments.newsletterSubscriberEmail#%" cfsqltype="cf_sql_varchar"><cfelse>IN (<cfqueryparam value="#Arguments.newsletterSubscriberEmail#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>AND avCompany.cobrandID IN (<cfqueryparam value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>AND avCompany.affiliateID IN (<cfqueryparam value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "newsletterSubscriberDateType") and Trim(Arguments.newsletterSubscriberDateType) is not "" and ((StructKeyExists(Arguments, "newsletterSubscriberDateFrom") and IsDate(Arguments.newsletterSubscriberDateFrom)) or (StructKeyExists(Arguments, "newsletterSubscriberDateTo") and IsDate(Arguments.newsletterSubscriberDateTo)))>
	<cfif StructKeyExists(Arguments, "newsletterSubscriberDateFrom") and IsDate(Arguments.newsletterSubscriberDateFrom) and StructKeyExists(Arguments, "newsletterSubscriberDateTo") and IsDate(Arguments.newsletterSubscriberDateTo)>
		<cfset queryDateField = " BETWEEN " & CreateODBCDateTime(Arguments.newsletterSubscriberDateFrom) & " AND " & CreateODBCDateTime(Arguments.newsletterSubscriberDateTo)>
	<cfelseif StructKeyExists(Arguments, "newsletterSubscriberDateFrom") and IsDate(Arguments.newsletterSubscriberDateFrom)>
		<cfset queryDateField = " >= " & CreateODBCDateTime(Arguments.newsletterSubscriberDateFrom)>
	<cfelse>
		<cfset queryDateField = " <= " & CreateODBCDateTime(Arguments.newsletterSubscriberDateTo)>
	</cfif>
	<cfif ListFind("userDateCreated,newsletterSubscriberDateCreated", Arguments.newsletterSubscriberDateType)>AND avUser.userDateCreated #queryDateField#</cfif>
	<cfif ListFind("companyDateCreated", Arguments.newsletterSubscriberDateType)>AND avCompany.companyDateCreated #queryDateField#</cfif>
	<cfif ListFind("invoiceDateClosed", Arguments.newsletterSubscriberDateType)>AND avUser.userID IN (SELECT userID FROM avInvoice WHERE companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"> AND invoiceDateClosed IS NOT NULL AND invoiceDateClosed #queryDateField#)</cfif>
	<cfif ListFind("invoiceDateClosed_first", Arguments.newsletterSubscriberDateType) or ListFind("invoiceDateClosed_last", Arguments.newsletterSubscriberDateType)>
		AND avUser.userID IN 
			(SELECT T.userID FROM
				(SELECT avUser.userID,
					(
					SELECT <cfif Application.billingDatabase is "MSSQLServer">TOP 1</cfif>
						invoiceDateClosed FROM avInvoice WHERE avInvoice.userID = avUser.userID AND invoiceDateClosed IS NOT NULL
					 ORDER BY invoiceDateClosed <cfif ListFind("invoiceDateClosed_last", Arguments.newsletterSubscriberDateType)> DESC</cfif>
					 <cfif Application.billingDatabase is "MySQL">LIMIT 1</cfif>
					 )
					AS invoiceDateClosed
				FROM avUser
				WHERE userID IN (SELECT userID FROM avInvoice WHERE companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"> AND invoiceDateClosed IS NOT NULL))
				AS T
			WHERE T.invoiceDateClosed #queryDateField#)
	</cfif>
</cfif>
<cfloop Index="field" List="companyIsCustomer,companyIsCobrand,companyIsVendor,companyIsTaxExempt,companyIsAffiliate">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avCompany.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "groupID") and Application.fn_IsIntegerList(Arguments.groupID)>
	AND (
		avUser.userID IN
			(
			SELECT targetID
			FROM avGroupTarget
			WHERE groupTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('userID')#" cfsqltype="cf_sql_integer">
				AND groupID IN (<cfqueryparam value="#Arguments.groupID#" cfsqltype="cf_sql_integer" list="yes">)
			)
		OR avCompany.companyID IN 
			(
			SELECT targetID
			FROM avGroupTarget
			WHERE groupTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">
				AND groupID IN (<cfqueryparam value="#Arguments.groupID#" cfsqltype="cf_sql_integer" list="yes">)
			)
		)
</cfif>
<cfif StructKeyExists(Arguments, "companyHasCustomPricing") and ListFind("0,1", Arguments.companyHasCustomPricing)>
	<cfif Arguments.companyHasCustomPricing is 1>
		AND (avCompany.companyID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">)
			OR avCompany.companyID IN
				(SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer"> AND groupID IN 
					(SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">)))
	<cfelse>
		AND avCompany.companyID NOT IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">)
		AND avCompany.companyID NOT IN
			(SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer"> AND groupID IN
				(SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">))
	</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "companyHasMultipleUsers") and ListFind("0,1", Arguments.companyHasMultipleUsers)>
	<cfif Arguments.companyHasMultipleUsers is 1>
		AND avCompany.companyID IN (SELECT companyID FROM avUserCompany GROUP BY companyID HAVING (COUNT(companyID) > 1))
	<cfelse>
		AND (avCompany.companyID IN (SELECT companyID FROM avUserCompany GROUP BY companyID HAVING (COUNT(companyID) = 1))
			OR avCompany.companyID NOT IN (SELECT companyID FROM avUserCompany))	
	</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "userIsInMyCompany") and ListFind("0,1", Arguments.userIsInMyCompany)>AND avCompany.companyID <cfif Arguments.userIsInMyCompany is 0> <> <cfelse> = </cfif> <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"></cfif>
<cfif StructKeyExists(Arguments, "companyHasCustomID") and ListFind("0,1", Arguments.companyHasCustomID)>AND avCompany.companyID_custom <cfif Arguments.companyHasCustomID is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "userHasCustomID") and ListFind("0,1", Arguments.userHasCustomID)>AND avUser.userID_custom <cfif Arguments.userHasCustomID is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "userHasCustomPricing") and ListFind("0,1", Arguments.userHasCustomPricing)>
	<cfif Arguments.userHasCustomPricing is 1>
		AND (
			avUser.userID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('userID')#" cfsqltype="cf_sql_integer">)
			OR avUser.userID IN
				(SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('userID')#" cfsqltype="cf_sql_integer"> AND groupID IN 
					(SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">))
			OR avUserCompany.companyID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">)
			OR avUserCompany.companyID IN
				(SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">
					AND groupID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">)))
	<cfelse>
		AND avUser.userID NOT IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('userID')#" cfsqltype="cf_sql_integer">)
		AND avUser.userID NOT IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('userID')#" cfsqltype="cf_sql_integer"> AND groupID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">))
		AND avUserCompany.companyID NOT IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">)
		AND avUserCompany.companyID NOT IN
			(SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer"> AND groupID IN 
				(SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">))
	</cfif>
</cfif>
</cfoutput>
