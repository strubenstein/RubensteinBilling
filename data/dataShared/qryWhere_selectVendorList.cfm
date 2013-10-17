<cfoutput>
avVendor.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
<cfloop Index="field" List="vendorID,companyID,userID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field]) and Arguments[field] is not 0> AND avVendor.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
<cfif StructKeyExists(Arguments, "vendorID_not") and Application.fn_IsIntegerList(Arguments.vendorID_not)>AND avVendor.vendorID NOT IN (<cfqueryparam value="#Arguments.vendorID_not#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "vendorStatus") and ListFind("0,1", Arguments.vendorStatus)>AND avVendor.vendorStatus = <cfqueryparam value="#Arguments.vendorStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
<cfloop Index="field" List="vendorName,vendorCode,vendorURL,vendorID_custom,vendorDescription"><cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not ""> AND avVendor.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar"> </cfif></cfloop>
<cfif StructKeyExists(Arguments, "vendorHasCode") and ListFind("0,1", Arguments.vendorHasCode)>AND avVendor.vendorCode <cfif Arguments.vendorHasCode is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "vendorHasCustomID") and ListFind("0,1", Arguments.vendorHasCustomID)>AND avVendor.vendorID_custom <cfif Arguments.vendorHasCustomID is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "vendorHasUser") and ListFind("0,1", Arguments.vendorHasUser)>AND avVendor.userID <cfif Arguments.vendorHasUser is 0> = 0 <cfelse> <> 0 </cfif></cfif>
<cfif StructKeyExists(Arguments, "searchText") and Trim(Arguments.searchText) is not "" and StructKeyExists(Arguments, "searchField") and (ListFind(Arguments.searchField, "vendorName") or ListFind(Arguments.searchField, "vendorCode") or ListFind(Arguments.searchField, "vendorURL") or ListFind(Arguments.searchField, "vendorID_custom") or ListFind(Arguments.searchField, "vendorDescription"))>
	<cfset displayOr = False>
	AND (
	<cfloop Index="field" List="vendorName,vendorCode,vendorURL,vendorID_custom,vendorDescription">
		<cfif ListFind(Arguments.searchField, field)><cfif displayOr is True>OR<cfelse><cfset displayOr = True></cfif> avVendor.#field# LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar"> </cfif>
	</cfloop>
	)
</cfif>
<cfif StructKeyExists(Arguments, "vendorNameIsCompanyName") and ListFind("0,1", Arguments.vendorNameIsCompanyName)>AND avVendor.vendorName <cfif Arguments.vendorNameIsCompanyName is 1> = <cfelse> <> </cfif> avCompany.companyName</cfif>
<cfif StructKeyExists(Arguments, "groupID") and Arguments.groupID is 0>
	AND avVendor.vendorID NOT IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus= <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('vendorID')#" cfsqltype="cf_sql_integer">)
<cfelseif StructKeyExists(Arguments, "groupID") and Application.fn_IsIntegerList(Arguments.groupID)>
	AND avVendor.vendorID <cfif Arguments.method is "group.insertGroupVendor"> NOT </cfif>
	IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus= <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('vendorID')#" cfsqltype="cf_sql_integer"> AND groupID IN (<cfqueryparam value="#Arguments.groupID#" cfsqltype="cf_sql_integer" list="yes">))
</cfif>
<cfif StructKeyExists(Arguments, "statusID") and Application.fn_IsIntegerList(Arguments.statusID)>
	AND avVendor.vendorID <cfif Arguments.statusID is 0>NOT</cfif> IN (SELECT targetID FROM avStatusHistory WHERE primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('vendorID')#" cfsqltype="cf_sql_integer"> <cfif Arguments.statusID is not 0>AND statusID IN (<cfqueryparam value="#Arguments.statusID#" cfsqltype="cf_sql_integer" list="yes">)</cfif> AND statusHistoryStatus= <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)
</cfif>
<cfif StructKeyExists(Arguments, "commissionID") and Application.fn_IsIntegerPositive(Arguments.commissionID)>AND avVendor.vendorID IN (SELECT targetID FROM avCommissionTarget WHERE commissionTargetStatus= <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('vendorID')#" cfsqltype="cf_sql_integer"> AND commissionID = <cfqueryparam value="#Arguments.commissionID#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "commissionID_not") and Application.fn_IsIntegerPositive(Arguments.commissionID_not)>AND avVendor.vendorID NOT IN (SELECT targetID FROM avCommissionTarget WHERE commissionTargetStatus= <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('vendorID')#" cfsqltype="cf_sql_integer"> AND commissionID = <cfqueryparam value="#Arguments.commissionID_not#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "vendorIsExported") and (Arguments.vendorIsExported is "" or ListFind("0,1", Arguments.vendorIsExported))>AND avVendor.vendorIsExported <cfif Arguments.vendorIsExported is "">IS NULL<cfelse>= <cfqueryparam value="#Arguments.vendorIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
<cfif StructKeyExists(Arguments, "vendorDateExported_from") and IsDate(Arguments.vendorDateExported_from)>AND avVendor.vendorDateExported >= <cfqueryparam value="#CreateODBCDateTime(Arguments.vendorDateExported_from)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "vendorDateExported_to") and IsDate(Arguments.vendorDateExported_to)>AND avVendor.vendorDateExported <= <cfqueryparam value="#CreateODBCDateTime(Arguments.vendorDateExported_to)#" cfsqltype="cf_sql_timestamp"></cfif>
</cfoutput>
