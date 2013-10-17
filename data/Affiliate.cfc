<cfcomponent DisplayName="Affiliate" Hint="Manages creating, updating, managing and viewing affiliates">

<cffunction name="maxlength_Affiliate" access="public" output="no" returnType="struct">
	<cfset var maxlength_Affiliate = StructNew()>

	<cfset maxlength_Affiliate.affiliateName = 255>
	<cfset maxlength_Affiliate.affiliateCode = 25>
	<cfset maxlength_Affiliate.affiliateURL = 100>
	<cfset maxlength_Affiliate.affiliateID_custom = 50>

	<cfreturn maxlength_Affiliate>
</cffunction>

<cffunction Name="insertAffiliate" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new affiliate into database and returns affiliateID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="affiliateCode" Type="string" Required="No" Default="">
	<cfargument Name="affiliateName" Type="string" Required="No" Default="">
	<cfargument Name="affiliateURL" Type="string" Required="No" Default="">
	<cfargument Name="affiliateStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="affiliateID_custom" Type="string" Required="No" Default="">
	<cfargument Name="affiliateIsExported" Type="string" Required="No" Default="">
	<cfargument Name="affiliateDateExported" Type="string" Required="No" Default="">

	<cfset var qry_insertAffiliate = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Affiliate" method="maxlength_Affiliate" returnVariable="maxlength_Affiliate" />

	<cfquery Name="qry_insertAffiliate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avAffiliate
		(
			companyID, userID, userID_author, companyID_author, affiliateCode, affiliateName,
			affiliateURL, affiliateStatus, affiliateID_custom, affiliateIsExported,
			affiliateDateExported, affiliateDateCreated, affiliateDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.affiliateCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Affiliate.affiliateCode#">,
			<cfqueryparam Value="#Arguments.affiliateName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Affiliate.affiliateName#">,
			<cfqueryparam Value="#Arguments.affiliateURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Affiliate.affiliateURL#">,
			<cfqueryparam Value="#Arguments.affiliateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.affiliateID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Affiliate.affiliateID_custom#">,
			<cfif Not ListFind("0,1", Arguments.affiliateIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.affiliateIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.affiliateDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.affiliateDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "affiliateID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertAffiliate.primaryKeyID>
</cffunction>

<cffunction Name="updateAffiliate" Access="public" Output="No" ReturnType="boolean" Hint="Update existing affiliate">
	<cfargument Name="affiliateID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="affiliateCode" Type="string" Required="No">
	<cfargument Name="affiliateName" Type="string" Required="No">
	<cfargument Name="affiliateURL" Type="string" Required="No">
	<cfargument Name="affiliateStatus" Type="numeric" Required="No">
	<cfargument Name="affiliateID_custom" Type="string" Required="No">
	<cfargument Name="affiliateIsExported" Type="string" Required="No">
	<cfargument Name="affiliateDateExported" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Affiliate" method="maxlength_Affiliate" returnVariable="maxlength_Affiliate" />

	<cfquery Name="qry_updateAffiliate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avAffiliate
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "affiliateCode")>affiliateCode = <cfqueryparam Value="#Arguments.affiliateCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Affiliate.affiliateCode#">,</cfif>
			<cfif StructKeyExists(Arguments, "affiliateName")>affiliateName = <cfqueryparam Value="#Arguments.affiliateName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Affiliate.affiliateName#">,</cfif>
			<cfif StructKeyExists(Arguments, "affiliateURL")>affiliateURL = <cfqueryparam Value="#Arguments.affiliateURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Affiliate.affiliateURL#">,</cfif>
			<cfif StructKeyExists(Arguments, "affiliateStatus") and ListFind("0,1", Arguments.affiliateStatus)>affiliateStatus = <cfqueryparam Value="#Arguments.affiliateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "affiliateID_custom")>affiliateID_custom = <cfqueryparam Value="#Arguments.affiliateID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Affiliate.affiliateID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "affiliateIsExported") and (Arguments.affiliateIsExported is "" or ListFind("0,1", Arguments.affiliateIsExported))>affiliateIsExported = <cfif Not ListFind("0,1", Arguments.affiliateIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.affiliateIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "affiliateDateExported") and (Arguments.affiliateDateExported is "" or IsDate(Arguments.affiliateDateExported))>affiliateDateExported = <cfif Not IsDate(Arguments.affiliateDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.affiliateDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			affiliateDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE affiliateID = <cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectAffiliate" Access="public" Output="No" ReturnType="query" Hint="Selects existing affiliate">
	<cfargument Name="affiliateID" Type="string" Required="Yes">

	<cfset var qry_selectAffiliate = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.affiliateID)>
		<cfset Arguments.affiliateID = 0>
	</cfif>

	<cfquery Name="qry_selectAffiliate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT affiliateID, companyID, userID, userID_author, companyID_author,
			affiliateCode, affiliateName, affiliateURL, affiliateStatus,
			affiliateID_custom, affiliateIsExported, affiliateDateExported,
			affiliateDateCreated, affiliateDateUpdated
		FROM avAffiliate
		WHERE affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectAffiliate>
</cffunction>

<cffunction Name="selectAffiliateIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects affiliateID of existing affiliate via custom ID and returns affiliateID(s) if exists, 0 if not exists, and -1 if multiple affiliates have the same affiliateID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="affiliateID_custom" Type="string" Required="Yes">

	<cfset var qry_selectAffiliateIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectAffiliateIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT affiliateID
		FROM avAffiliate
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND affiliateID_custom IN (<cfqueryparam Value="#Arguments.affiliateID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectAffiliateIDViaCustomID.RecordCount is 0 or qry_selectAffiliateIDViaCustomID.RecordCount lt ListLen(Arguments.affiliateID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectAffiliateIDViaCustomID.RecordCount gt ListLen(Arguments.affiliateID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectAffiliateIDViaCustomID.affiliateID)>
	</cfif>
</cffunction>

<cffunction Name="checkAffiliatePermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for affiliate(s)">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="affiliateID" Type="string" Required="Yes">

	<cfset var qry_checkAffiliatePermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.affiliateID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkAffiliatePermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT affiliateID, companyID_author, companyID
			FROM avAffiliate
			WHERE affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND (companyID = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
					OR companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">)
		</cfquery>

		<cfif qry_checkAffiliatePermission.RecordCount is 0 or qry_checkAffiliatePermission.RecordCount is not ListLen(Arguments.affiliateID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="checkAffiliateCodeIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Validate affiliate code is unique">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="affiliateCode" Type="string" Required="Yes">
	<cfargument Name="affiliateID" Type="numeric" Required="No">

	<cfset var qry_checkAffiliateCodeIsUnique = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Affiliate" method="maxlength_Affiliate" returnVariable="maxlength_Affiliate" />

	<cfquery Name="qry_checkAffiliateCodeIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT affiliateID
		FROM avAffiliate
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND affiliateCode = <cfqueryparam Value="#Arguments.affiliateCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Affiliate.affiliateCode#">
			<cfif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerNonNegative(Arguments.affiliateID)>
				AND affiliateID <> <cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkAffiliateCodeIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<!--- functions for viewing list of affiliates --->
<cffunction Name="selectAffiliateList" Access="public" ReturnType="query" Hint="Select list of affiliates">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="affiliateStatus" Type="numeric" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="affiliateHasCode" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomID" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCommission" Type="numeric" Required="No">
	<cfargument Name="affiliateNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="affiliateHasUser" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomer" Type="numeric" Required="No">
	<cfargument Name="affiliateHasActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="affiliateName" Type="string" Required="No">
	<cfargument Name="affiliateCode" Type="string" Required="No">
	<cfargument Name="affiliateURL" Type="string" Required="No">
	<cfargument Name="affiliateID_custom" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="affiliateID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="priceID_not" Type="string" Required="No">
	<cfargument Name="affiliateIsExported" Type="string" Required="No">
	<cfargument Name="affiliateDateExported_from" Type="string" Required="No">
	<cfargument Name="affiliateDateExported_to" Type="string" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="No" default="affiliateName">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="queryFirstLetter" Type="string" Required="No" Default="">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="No" Default="">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var queryParameters_orderBy = "avAffiliate.affiliateName">
	<cfset var queryParameters_orderBy_noTable = "affiliateName">
	<cfset var qry_selectAffiliateList = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfswitch expression="#Arguments.queryOrderBy#">
	<cfcase value="affiliateID,affiliateName,affiliateCode,affiliateURL,affiliateDateUpdated"><cfset queryParameters_orderBy = "avAffiliate.#Arguments.queryOrderBy#"></cfcase>
	<cfcase value="affiliateID_d,affiliateName_d,affiliateCode_d,affiliateURL_d,affiliateDateUpdated_d"><cfset queryParameters_orderBy = "avAffiliate.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	<cfcase value="affiliateStatus"><cfset queryParameters_orderBy = "avAffiliate.affiliateStatus DESC, avAffiliate.affiliateName"></cfcase>
	<cfcase value="affiliateStatus_d"><cfset queryParameters_orderBy = "avAffiliate.affiliateStatus, avAffiliate.affiliateName"></cfcase>
	<cfcase value="affiliateID_custom"><cfset queryParameters_orderBy = "avAffiliate.affiliateID_custom"></cfcase>
	<cfcase value="affiliateID_custom_d"><cfset queryParameters_orderBy = "avAffiliate.affiliateID_custom DESC"></cfcase>
	<cfcase value="affiliateDateCreated"><cfset queryParameters_orderBy = "avAffiliate.affiliateID"></cfcase>
	<cfcase value="affiliateDateCreated_d"><cfset queryParameters_orderBy = "avAffiliate.affiliateID DESC"></cfcase>
	<cfcase value="companyName,companyName_d,lastName,lastName_d">
		<cfif Arguments.returnCompanyFields is False>
			<cfset queryParameters_orderBy = "avAffiliate.affiliateName">
		<cfelse>
			<cfswitch expression="#Arguments.queryOrderBy#">
			<cfcase value="companyName"><cfset queryParameters_orderBy = "avCompany.companyName, avCompany.companyDBA"></cfcase>
			<cfcase value="companyName_d"><cfset queryParameters_orderBy = "avCompany.companyName DESC, avCompany.companyDBA DESC"></cfcase>
			<cfcase value="lastName"><cfset queryParameters_orderBy = "avUser.lastName, avUser.firstName"></cfcase>
			<cfcase value="lastName_d"><cfset queryParameters_orderBy = "avUser.lastName DESC, avUser.firstName DESC"></cfcase>
			</cfswitch>	
		</cfif>
	</cfcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avUser,avCompany,avAffiliate">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectAffiliateList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avAffiliate.affiliateID, avAffiliate.companyID, avAffiliate.userID,
			avAffiliate.userID_author, avAffiliate.affiliateCode, avAffiliate.affiliateName,
			avAffiliate.affiliateURL, avAffiliate.affiliateStatus, avAffiliate.affiliateID_custom,
			avAffiliate.affiliateIsExported, avAffiliate.affiliateDateExported,
			avAffiliate.affiliateDateCreated, avAffiliate.affiliateDateUpdated
			<cfif Arguments.returnCompanyFields is True>, avCompany.companyName, avCompany.companyID_custom, avCompany.companyDBA, avCompany.companyStatus</cfif>
			<cfif Arguments.returnUserFields is True>, avUser.firstName, avUser.lastName, avUser.userID_custom, avUser.userStatus</cfif>
		FROM avAffiliate
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avAffiliate.companyID = avCompany.companyID</cfif>
			<cfif Arguments.returnUserFields is True>LEFT OUTER JOIN avUser ON avAffiliate.userID = avUser.userID</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectAffiliateList.cfm">
			<cfif StructKeyExists(Arguments, "queryFirstLetter") and Arguments.queryFirstLetter is not "" and StructKeyExists(Arguments, "queryFirstLetter_field") and Arguments.queryFirstLetter_field is not "">
				<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
					AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
				<cfelse><!--- letter --->
					AND (Left(#Arguments.queryFirstLetter_field#, 1) >= '#UCase(Arguments.queryFirstLetter)#' OR Left(#Arguments.queryFirstLetter_field#, 1) >= '#LCase(Arguments.queryFirstLetter)#')
				</cfif>
			</cfif>
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectAffiliateList>
</cffunction>

<cffunction Name="selectAffiliateCount" Access="public" ReturnType="numeric" Hint="Select total number of affiliates in list">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="affiliateStatus" Type="numeric" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="affiliateHasCode" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomID" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCommission" Type="numeric" Required="No">
	<cfargument Name="affiliateNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="affiliateHasUser" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomer" Type="numeric" Required="No">
	<cfargument Name="affiliateHasActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="affiliateName" Type="string" Required="No">
	<cfargument Name="affiliateCode" Type="string" Required="No">
	<cfargument Name="affiliateURL" Type="string" Required="No">
	<cfargument Name="affiliateID_custom" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="affiliateID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="priceID_not" Type="string" Required="No">
	<cfargument Name="affiliateIsExported" Type="string" Required="No">
	<cfargument Name="affiliateDateExported_from" Type="string" Required="No">
	<cfargument Name="affiliateDateExported_to" Type="string" Required="No">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectAffiliateCount = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfquery Name="qry_selectAffiliateCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(avAffiliate.affiliateID) AS totalRecords
		FROM avAffiliate
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avAffiliate.companyID = avCompany.companyID</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectAffiliateList.cfm">
	</cfquery>

	<cfreturn qry_selectAffiliateCount.totalRecords>
</cffunction>

<cffunction Name="selectAffiliateList_alphabet" Access="public" ReturnType="query" Hint="Select the first letter in value of field by which list of affiliates is ordered">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="affiliateStatus" Type="numeric" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="affiliateHasCode" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomID" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCommission" Type="numeric" Required="No">
	<cfargument Name="affiliateNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="affiliateHasUser" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomer" Type="numeric" Required="No">
	<cfargument Name="affiliateHasActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="affiliateName" Type="string" Required="No">
	<cfargument Name="affiliateCode" Type="string" Required="No">
	<cfargument Name="affiliateURL" Type="string" Required="No">
	<cfargument Name="affiliateID_custom" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="affiliateID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="priceID_not" Type="string" Required="No">
	<cfargument Name="affiliateIsExported" Type="string" Required="No">
	<cfargument Name="affiliateDateExported_from" Type="string" Required="No">
	<cfargument Name="affiliateDateExported_to" Type="string" Required="No">
	<cfargument Name="alphabetField" Type="string" Required="Yes">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectAffiliateList_alphabet = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfquery Name="qry_selectAffiliateList_alphabet" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Distinct(Left(#Arguments.alphabetField#, 1)) AS firstLetter
		FROM avAffiliate
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avAffiliate.companyID = avCompany.companyID</cfif>
			<cfif Arguments.returnUserFields is True>LEFT OUTER JOIN avUser ON avAffiliate.userID = avUser.userID</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectAffiliateList.cfm">
		ORDER BY firstLetter
	</cfquery>

	<cfreturn qry_selectAffiliateList_alphabet>
</cffunction>

<cffunction Name="selectAffiliateList_alphabetPage" Access="public" ReturnType="numeric" Hint="Select page which includes the first record where the first letter in value of field by which list of affiliates is ordered">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="affiliateStatus" Type="numeric" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="affiliateHasCode" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomID" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCommission" Type="numeric" Required="No">
	<cfargument Name="affiliateNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="affiliateHasUser" Type="numeric" Required="No">
	<cfargument Name="affiliateHasCustomer" Type="numeric" Required="No">
	<cfargument Name="affiliateHasActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="affiliateName" Type="string" Required="No">
	<cfargument Name="affiliateCode" Type="string" Required="No">
	<cfargument Name="affiliateURL" Type="string" Required="No">
	<cfargument Name="affiliateID_custom" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="affiliateID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="priceID_not" Type="string" Required="No">
	<cfargument Name="affiliateIsExported" Type="string" Required="No">
	<cfargument Name="affiliateDateExported_from" Type="string" Required="No">
	<cfargument Name="affiliateDateExported_to" Type="string" Required="No">

	<cfargument Name="queryFirstLetter" Type="string" Required="Yes">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="Yes">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="Yes">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectAffiliateList_alphabetPage = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfquery Name="qry_selectAffiliateList_alphabetPage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(avAffiliate.affiliateID) AS recordCountBeforeAlphabet
		FROM avAffiliate
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avAffiliate.companyID = avCompany.companyID</cfif>
			<cfif Arguments.returnUserFields is True>LEFT OUTER JOIN avUser ON avAffiliate.userID = avUser.userID</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectAffiliateList.cfm">
			<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
				AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
			<cfelse><!--- letter --->
				AND (Left(#Arguments.queryFirstLetter_field#, 1) < '#UCase(Arguments.queryFirstLetter)#' OR Left(#Arguments.queryFirstLetter_field#, 1) < '#LCase(Arguments.queryFirstLetter)#')
			</cfif>
	</cfquery>

	<cfreturn 1 + (qry_selectAffiliateList_alphabetPage.recordCountBeforeAlphabet \ Arguments.queryDisplayPerPage)>
</cffunction>
<!--- /functions for viewing list of affiliates --->

<!--- Update Export Status --->
<cffunction Name="updateAffiliateIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether affiliate records have been exported. Returns True.">
	<cfargument Name="affiliateID" Type="string" Required="Yes">
	<cfargument Name="affiliateIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.affiliateID) or (Arguments.affiliateIsExported is not "" and Not ListFind("0,1", Arguments.affiliateIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateAffiliateIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avAffiliate
			SET affiliateIsExported = <cfif Not ListFind("0,1", Arguments.affiliateIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.affiliateIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				affiliateDateExported = <cfif Not ListFind("0,1", Arguments.affiliateIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>
		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>

