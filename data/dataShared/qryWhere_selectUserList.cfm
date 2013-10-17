<cfoutput>
<cfif StructKeyExists(Arguments, "companyID_author")>
	AND (
	<cfswitch Expression="#Arguments.returnMyCompanyUsersOnly#">
	<cfcase value="1"><!--- only display users IN my company --->avCompany.companyID IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">)</cfcase>
	<cfcase value="0"><!--- only display users NOT in my company --->avCompany.companyID NOT IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">) AND avCompany.companyID_author IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">)</cfcase>
	<cfdefaultcase><!--- display all users --->avCompany.companyID IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">) OR avCompany.companyID_author IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">)</cfdefaultcase>
	</cfswitch>
	<cfif Arguments.returnMyCompanyUsersOnly is not 1 and Arguments.companyID_author is Application.billingSuperuserCompanyID>OR avCompany.companyPrimary = 1</cfif>
	)
</cfif>
<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID) and Arguments.method is not "user.listUsers">AND avUserCompany.companyID IN (<cfqueryparam value="#Arguments.companyID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfloop index="field" list="userID_author,userID_manager"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avUser.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
<cfloop index="field" list="cobrandID,affiliateID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avCompany.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>AND avUser.userID IN (<cfqueryparam value="#Arguments.userID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "userID_not") and Application.fn_IsIntegerList(Arguments.userID_not)>AND avUser.userID NOT IN (<cfqueryparam value="#Arguments.userID_not#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfloop Index="field" List="companyIsAffiliate,companyIsCobrand,companyIsVendor,companyIsCustomer,companyIsTaxExempt"><cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avCompany.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif></cfloop>
<cfif Arguments.returnCompanyFields is True><cfloop Index="field" List="companyName,companyDBA,companyURL,companyID_custom"><cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not ""> AND avCompany.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar"> </cfif></cfloop></cfif>
<cfloop Index="field" List="userStatus,userNewsletterStatus,userNewsletterHtml,userEmailVerified"><cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avUser.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif></cfloop>
<cfloop Index="field" List="userID_custom,username,firstName,lastName,email,jobTitle,jobDepartment,jobDivision"><cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not ""> AND avUser.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar"> </cfif></cfloop>
<cfloop Index="field" List="username,email"><cfif StructKeyExists(Arguments, "#field#_list") and Arguments["#field#_list"] is not ""> AND avUser.#field# IN (<cfqueryparam value="#Arguments['#field#_list']#" cfsqltype="cf_sql_varchar" list="yes">) </cfif></cfloop>
<cfif StructKeyExists(Arguments, "userEmailVerifyCode") and Trim(Arguments.userEmailVerifyCode) is not "">AND avUser.userEmailVerifyCode = <cfqueryparam value="#Arguments.userEmailVerifyCode#" cfsqltype="cf_sql_varchar"></cfif>
<cfif StructKeyExists(Arguments, "userHasCustomID") and ListFind("0,1", Arguments.userHasCustomID)>AND avUser.userID_custom <cfif Arguments.userHasCustomID is 0> = '' <cfelse> <> '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "userIsPrimaryContact") and ListFind("0,1", Arguments.userIsPrimaryContact)>AND avUser.userID <cfif Arguments.userIsPrimaryContact is 0> <> <cfelse> = </cfif> avCompany.userID</cfif>
<cfif StructKeyExists(Arguments, "companyPrimary") and ListFind("0,1", Arguments.companyPrimary)>AND avCompany.companyPrimary = <cfqueryparam value="#Arguments.companyPrimary#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
<cfif StructKeyExists(Arguments, "statusID") and Application.fn_IsIntegerList(Arguments.statusID)>
	AND avUser.userID <cfif Arguments.statusID is 0>NOT</cfif> IN (SELECT targetID FROM avStatusHistory WHERE primaryTargetID = #Application.fn_GetPrimaryTargetID("userID")# <cfif Arguments.statusID is not 0>AND statusID IN (<cfqueryparam value="#Arguments.statusID#" cfsqltype="cf_sql_integer" list="yes">)</cfif> AND statusHistoryStatus = 1)
</cfif>
<cfif StructKeyExists(Arguments, "groupID") and Application.fn_IsIntegerList(Arguments.groupID)>
	<cfif Arguments.groupID is 0>
		AND avUser.userID NOT IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("userID")#)
	<cfelse>
		AND avUser.userID <cfif Arguments.method is "group.insertGroupUser"> NOT </cfif> IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("userID")# AND groupID IN (<cfqueryparam value="#Arguments.groupID#" cfsqltype="cf_sql_integer" list="yes">))
	</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "userIsActiveSubscriber") and ListFind("0,1", Arguments.userIsActiveSubscriber)>
	AND avUser.userID <cfif Arguments.userIsActiveSubscriber is 0> NOT </cfif> IN (SELECT userID FROM avSubscriber WHERE companyID_author IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">) AND subscriberStatus = 1)
</cfif>
<cfif StructKeyExists(Arguments, "vendorID") and Application.fn_IsIntegerList(Arguments.vendorID)>
	AND avUserCompany.companyID IN (SELECT companyID FROM avVendor <cfif Arguments.vendorID is not -1>WHERE vendorID IN (<cfqueryparam value="#Arguments.vendorID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>)
</cfif>
<cfif StructKeyExists(Arguments, "userIsProductManager") and ListFind("0,1", Arguments.userIsProductManager)>
	AND avUser.userID <cfif Arguments.userIsProductManager is 0>NOT</cfif> IN (SELECT userID_manager FROM avProduct WHERE companyID IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">) AND userID_manager > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">)
</cfif>
<cfif StructKeyExists(Arguments, "languageID")>AND avUser.languageID = <cfqueryparam value="#Arguments.languageID#" cfsqltype="cf_sql_varchar"></cfif>
<cfif (StructKeyExists(Arguments, "city") and Trim(Arguments.city) is not "") or (StructKeyExists(Arguments, "state") and Trim(Arguments.state) is not "") or (StructKeyExists(Arguments, "county") and Trim(Arguments.county) is not "") or (StructKeyExists(Arguments, "zipCode") and Trim(Arguments.zipCode) is not "") or (StructKeyExists(Arguments, "country") and Trim(Arguments.country) is not "") or (StructKeyExists(Arguments, "regionID") and Application.fn_IsIntegerList(Arguments.regionID))>
	AND avUser.userID IN (SELECT userID FROM avAddress WHERE addressStatus = 1 AND (addressID = 0
	<cfif StructKeyExists(Arguments, "city") and Trim(Arguments.city) is not "">OR city IN (<cfqueryparam value="#Arguments.city#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
	<cfif StructKeyExists(Arguments, "state") and Trim(Arguments.state) is not "">OR state IN (<cfqueryparam value="#Arguments.state#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
	<cfif StructKeyExists(Arguments, "county") and Trim(Arguments.county) is not "">OR county IN (<cfqueryparam value="#Arguments.county#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
	<cfif StructKeyExists(Arguments, "zipCode") and Trim(Arguments.zipCode) is not "">OR zipCode IN (<cfqueryparam value="#Arguments.zipCode#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
	<cfif StructKeyExists(Arguments, "country") and Trim(Arguments.country) is not "">OR country IN (<cfqueryparam value="#Arguments.country#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
	<cfif StructKeyExists(Arguments, "regionID") and Application.fn_IsIntegerList(Arguments.regionID)>OR regionID IN (<cfqueryparam value="#Arguments.regionID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
	))
</cfif>
<cfif StructKeyExists(Arguments, "searchText") and Trim(Arguments.searchText) is not "" and StructKeyExists(Arguments, "searchField") and (ListFind(Arguments.searchField, "companyName") or ListFind(Arguments.searchField, "companyDBA") or ListFind(Arguments.searchField, "companyID_custom") or ListFind(Arguments.searchField, "username") or ListFind(Arguments.searchField, "firstName") or ListFind(Arguments.searchField, "userID_custom") or ListFind(Arguments.searchField, "lastName") or ListFind(Arguments.searchField,"email") or ListFind(Arguments.searchField, "jobTitle") or ListFind(Arguments.searchField, "jobDepartment") or ListFind(Arguments.searchField, "jobDivision"))>
	AND (avUser.userID = 0
		<cfloop Index="field" List="#Arguments.searchField#">
			<cfswitch Expression="#field#">
			<cfcase value="companyName,companyDBA,companyID_custom"><cfif Arguments.returnCompanyFields is True>OR avCompany.#field# LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar"></cfif></cfcase>
			<cfcase value="username,firstName,lastName,email,jobTitle,jobDepartment,jobDivision,userID_custom">OR avUser.#field# LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar"></cfcase>
			</cfswitch>
		</cfloop>
		)
</cfif>
<cfif StructKeyExists(Arguments, "userHasCustomPricing") and ListFind("0,1", Arguments.userHasCustomPricing)>
	<cfif Arguments.userHasCustomPricing is 1>
		AND (
			avUser.userID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("userID")#)
			OR avUser.userID IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("userID")# AND groupID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("groupID")#))
			OR avUserCompany.companyID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("companyID")#)
			OR avUserCompany.companyID IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("companyID")# AND groupID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("groupID")#))
			)
	<cfelse>
		AND avUser.userID NOT IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("userID")#)
		AND avUser.userID NOT IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("userID")# AND groupID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("groupID")#))
		AND avUserCompany.companyID NOT IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("companyID")#)
		AND avUserCompany.companyID NOT IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("companyID")# AND groupID IN (SELECT targetID FROM avPriceTarget WHERE priceTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("groupID")#))
	</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "commissionID") and Application.fn_IsIntegerPositive(Arguments.commissionID)>AND avUser.userID IN (SELECT targetID FROM avCommissionTarget WHERE commissionTargetStatus = 1  AND primaryTargetID = #Application.fn_GetPrimaryTargetID("userID")# AND commissionID = <cfqueryparam value="#Arguments.commissionID#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "commissionID_not") and Application.fn_IsIntegerPositive(Arguments.commissionID_not)>AND avUser.userID NOT IN (SELECT targetID FROM avCommissionTarget WHERE commissionTargetStatus = 1 AND primaryTargetID = #Application.fn_GetPrimaryTargetID("userID")#  AND commissionID = <cfqueryparam value="#Arguments.commissionID_not#" cfsqltype="cf_sql_integer">)</cfif>
<cfif StructKeyExists(Arguments, "userIsExported") and (Arguments.userIsExported is "" or ListFind("0,1", Arguments.userIsExported))>AND avUser.userIsExported <cfif Arguments.userIsExported is "">IS NULL<cfelse>= <cfqueryparam value="#Arguments.userIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
<cfif StructKeyExists(Arguments, "userDateExported_from") and IsDate(Arguments.userDateExported_from)>AND avUser.userDateExported >= <cfqueryparam value="#CreateODBCDateTime(Arguments.userDateExported_from)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "userDateExported_to") and IsDate(Arguments.userDateExported_to)>AND avUser.userDateExported <= <cfqueryparam value="#CreateODBCDateTime(Arguments.userDateExported_to)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "userIsLoggedIn") and ListFind("0,1", Arguments.userIsLoggedIn)>AND avUser.userID <cfif Arguments.userIsLoggedIn is 1> IN <cfelse> NOT IN </cfif> (SELECT userID FROM avLoginSession WHERE loginSessionCurrent = 1 AND loginSessionDateEnd IS NULL)</cfif>
<cfif StructKeyExists(Arguments, "userDateCreated_from") and StructKeyExists(Arguments, "userDateCreated_to")>
	AND avUser.userDateCreated BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments.userDateCreated_from)#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments.userDateCreated_to)#" cfsqltype="cf_sql_timestamp">
  <cfelseif StructKeyExists(Arguments, "userDateCreated_from")>
  	AND avUser.userDateCreated >= <cfqueryparam value="#CreateODBCDateTime(Arguments.userDateCreated_from)#" cfsqltype="cf_sql_timestamp">
  <cfelseif StructKeyExists(Arguments, "userDateCreated_to")>
  	AND avUser.userDateCreated <= <cfqueryparam value="#CreateODBCDateTime(Arguments.userDateCreated_to)#" cfsqltype="cf_sql_timestamp">
</cfif>
</cfoutput>
