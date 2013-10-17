<cfoutput>
<cfif Arguments.companyID_author is not Application.billingSuperuserCompanyID>
	avCompany.companyID_author IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">)
<cfelseif Not StructKeyExists(Arguments, "companyPrimary")>
	(avCompany.companyID_author IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">) OR avCompany.companyPrimary = 1)
<cfelseif Arguments.companyPrimary is 1>
	avCompany.companyPrimary = 1
<cfelse>
	(avCompany.companyID_author IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">) AND avCompany.companyPrimary = 0)
</cfif>
<cfloop index="field" list="companyStatus,companyIsAffiliate,companyIsCobrand,companyIsVendor,companyIsCustomer,companyIsTaxExempt"><cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avCompany.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif></cfloop>
<cfif StructKeyExists(Arguments, "companyHasName") and ListFind("0,1", Arguments.companyHasName)>AND avCompany.companyName <cfif Arguments.companyHasName is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "companyHasDBA") and ListFind("0,1", Arguments.companyHasDBA)>AND avCompany.companyDBA <cfif Arguments.companyHasDBA is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "companyHasURL") and ListFind("0,1", Arguments.companyHasURL)>AND avCompany.companyURL <cfif Arguments.companyHasURL is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "companyHasCustomID") and ListFind("0,1", Arguments.companyHasCustomID)>AND avCompany.companyID_custom <cfif Arguments.companyHasCustomID is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "companyHasUser") and ListFind("0,1", Arguments.companyHasUser)>AND avCompany.userID <cfif Arguments.companyHasUser is 0> = 0 <cfelse> <> 0 </cfif></cfif>
<cfloop Index="field" List="companyName,companyDBA,companyURL,companyID_custom"><cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not ""> AND avCompany.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar"> </cfif></cfloop>
<cfif StructKeyExists(Arguments, "companyIsActiveSubscriber") and ListFind("0,1", Arguments.companyIsActiveSubscriber)>AND avCompany.companyID <cfif Arguments.companyIsActiveSubscriber is 0> NOT </cfif> IN (SELECT companyID FROM avSubscriber WHERE companyID_author IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">) AND subscriberStatus = 1)</cfif>
<cfif StructKeyExists(Arguments, "companyHasMultipleUsers")>
	<cfif Arguments.companyHasMultipleUsers is 1>
		AND avCompany.companyID IN (SELECT companyID FROM avUserCompany GROUP BY companyID HAVING (COUNT(companyID) > 1))
	<cfelse>
		AND (avCompany.companyID IN (SELECT companyID FROM avUserCompany GROUP BY companyID HAVING (COUNT(companyID) = 1))
			OR avCompany.companyID NOT IN (SELECT companyID FROM avUserCompany))	
	</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "groupID") and Arguments.groupID is 0>
	AND avCompany.companyID NOT IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">)
<cfelseif StructKeyExists(Arguments, "groupID") and Application.fn_IsIntegerList(Arguments.groupID)>
	AND avCompany.companyID <cfif Arguments.method is "group.insertGroupCompany"> NOT </cfif>
	IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer"> AND groupID IN (<cfqueryparam value="#Arguments.groupID#" cfsqltype="cf_sql_integer" list="yes">))
</cfif>
<cfif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>AND avCompany.affiliateID IN (<cfqueryparam value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>AND avCompany.cobrandID IN (<cfqueryparam value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "statusID") and Application.fn_IsIntegerList(Arguments.statusID)>
	AND avCompany.companyID <cfif Arguments.statusID is 0>NOT</cfif> IN 
	(SELECT targetID FROM avStatusHistory WHERE statusHistoryStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">
	<cfif Arguments.statusID is not 0> AND statusID IN (<cfqueryparam value="#Arguments.statusID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>)
</cfif>
<cfif StructKeyExists(Arguments, "companyHasCustomPricing") and ListFind("0,1", Arguments.companyHasCustomPricing)>
	<cfif Arguments.companyHasCustomPricing is 1>
		AND (
			avCompany.companyID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">)
			OR avCompany.companyID IN
				(SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">
					AND groupID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">)))
	<cfelse>
		AND avCompany.companyID NOT IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">)
		AND avCompany.companyID NOT IN
			(SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">
				AND groupID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">))
	</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "searchText") and Trim(Arguments.searchText) is not "" and StructKeyExists(Arguments, "searchField") and (ListFind(Arguments.searchField, "companyName") or ListFind(Arguments.searchField, "companyDBA") or ListFind(Arguments.searchField, "companyURL") or ListFind(Arguments.searchField, "companyID_custom"))>
	<cfset displayOr = False><cfset searchTextEscaped = Replace(Arguments.searchText, "'", "''", "ALL")>AND (
	<cfif ListFind(Arguments.searchField, "companyName")><cfset displayOr = True>avCompany.companyName LIKE <cfqueryparam value="%#searchTextEscaped#%" cfsqltype="cf_sql_varchar"></cfif>
	<cfif ListFind(Arguments.searchField, "companyDBA")><cfif displayOr is True> OR <cfelse><cfset displayOr = True></cfif>avCompany.companyDBA LIKE <cfqueryparam value="%#searchTextEscaped#%" cfsqltype="cf_sql_varchar"></cfif>
	<cfif ListFind(Arguments.searchField, "companyURL")><cfif displayOr is True> OR <cfelse><cfset displayOr = True></cfif>avCompany.companyURL LIKE <cfqueryparam value="%#searchTextEscaped#%" cfsqltype="cf_sql_varchar"></cfif>
	<cfif ListFind(Arguments.searchField, "companyID_custom")><cfif displayOr is True> OR <cfelse><cfset displayOr = True></cfif>avCompany.companyID_custom LIKE <cfqueryparam value="%#searchTextEscaped#%" cfsqltype="cf_sql_varchar"></cfif>
	)
</cfif>
<cfif StructKeyExists(Arguments, "companyID_not") and Application.fn_IsIntegerList(Arguments.companyID_not)>AND avCompany.companyID NOT IN (<cfqueryparam value="#Arguments.companyID_not#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "payflowID") and Application.fn_IsIntegerList(Arguments.payflowID)>
	AND avCompany.companyID IN 
		(
		SELECT targetID
		FROM avPayflowTarget
		WHERE payflowID IN (<cfqueryparam value="#Arguments.payflowID#" cfsqltype="cf_sql_integer" list="yes">)
			AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">
			AND payflowTargetStatus = 1
			AND payflowTargetDateBegin <= <cfqueryparam value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp">
			AND (payflowTargetDateEnd IS NULL OR payflowTargetDateEnd >= <cfqueryparam value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp">)
		)
</cfif>
<cfif (StructKeyExists(Arguments, "city") and Trim(Arguments.city) is not "") or (StructKeyExists(Arguments, "state") and Trim(Arguments.state) is not "") or (StructKeyExists(Arguments, "county") and Trim(Arguments.county) is not "") or (StructKeyExists(Arguments, "zipCode") and Trim(Arguments.zipCode) is not "") or (StructKeyExists(Arguments, "country") and Trim(Arguments.country) is not "") or (StructKeyExists(Arguments, "regionID") and Application.fn_IsIntegerList(Arguments.regionID))>
	AND avCompany.companyID IN (SELECT companyID FROM avAddress WHERE addressStatus = 1 AND (addressID = 0
	<cfif StructKeyExists(Arguments, "city") and Trim(Arguments.city) is not "">OR city IN (<cfqueryparam value="#Arguments.city#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
	<cfif StructKeyExists(Arguments, "state") and Trim(Arguments.state) is not "">OR state IN (<cfqueryparam value="#Arguments.state#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
	<cfif StructKeyExists(Arguments, "county") and Trim(Arguments.county) is not "">OR county IN (<cfqueryparam value="#Arguments.county#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
	<cfif StructKeyExists(Arguments, "zipCode") and Trim(Arguments.zipCode) is not "">OR zipCode IN (<cfqueryparam value="#Arguments.zipCode#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
	<cfif StructKeyExists(Arguments, "country") and Trim(Arguments.country) is not "">OR country IN (<cfqueryparam value="#Arguments.country#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
	<cfif StructKeyExists(Arguments, "regionID") and Application.fn_IsIntegerList(Arguments.regionID)>OR regionID IN (<cfqueryparam value="#Arguments.regionID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
	))
</cfif>
<cfif StructKeyExists(Arguments, "commissionID") and Application.fn_IsIntegerPositive(Arguments.commissionID)>
	AND avCompany.companyID IN
		(
		SELECT targetID
		FROM avCommissionTarget
		WHERE commissionTargetStatus = 1
			AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">
			AND commissionID = <cfqueryparam value="#Arguments.commissionID#" cfsqltype="cf_sql_integer">
		)
</cfif>
<cfif StructKeyExists(Arguments, "commissionID_not") and Application.fn_IsIntegerPositive(Arguments.commissionID_not)>
	AND avCompany.companyID NOT IN
		(
		SELECT targetID
		FROM avCommissionTarget
		WHERE commissionTargetStatus = 1
			AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">
			AND commissionID = <cfqueryparam value="#Arguments.commissionID_not#" cfsqltype="cf_sql_integer">
		)
</cfif>
<cfif StructKeyExists(Arguments, "companyIsExported") and (Arguments.companyIsExported is "" or ListFind("0,1", Arguments.companyIsExported))>AND avCompany.companyIsExported <cfif Arguments.companyIsExported is "">IS NULL<cfelse>= <cfqueryparam value="#Arguments.companyIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
<cfif StructKeyExists(Arguments, "companyDateExported_from") and IsDate(Arguments.companyDateExported_from)>AND avCompany.companyDateExported >= <cfqueryparam value="#CreateODBCDateTime(Arguments.companyDateExported_from)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "companyDateExported_to") and IsDate(Arguments.companyDateExported_to)>AND avCompany.companyDateExported <= <cfqueryparam value="#CreateODBCDateTime(Arguments.companyDateExported_to)#" cfsqltype="cf_sql_timestamp"></cfif>
</cfoutput>
