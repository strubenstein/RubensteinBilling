<cfcomponent DisplayName="Cobrand" Hint="Manages creating, updating, managing and viewing cobrands">

<cffunction name="maxlength_Cobrand" access="public" output="no" returnType="struct">
	<cfset var maxlength_Cobrand = StructNew()>

	<cfset maxlength_Cobrand.cobrandName = 255>
	<cfset maxlength_Cobrand.cobrandCode = 50>
	<cfset maxlength_Cobrand.cobrandImage = 100>
	<cfset maxlength_Cobrand.cobrandURL = 100>
	<cfset maxlength_Cobrand.cobrandTitle = 100>
	<cfset maxlength_Cobrand.cobrandDomain = 100>
	<cfset maxlength_Cobrand.cobrandDirectory = 50>
	<cfset maxlength_Cobrand.cobrandID_custom = 50>

	<cfreturn maxlength_Cobrand>
</cffunction>

<cffunction Name="insertCobrand" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new cobrand into database and returns cobrandID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="cobrandName" Type="string" Required="No" Default="">
	<cfargument Name="cobrandCode" Type="string" Required="No" Default="">
	<cfargument Name="cobrandURL" Type="string" Required="No" Default="">
	<cfargument Name="cobrandStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="cobrandImage" Type="string" Required="No" Default="">
	<cfargument Name="cobrandTitle" Type="string" Required="No" Default="">
	<cfargument Name="cobrandDomain" Type="string" Required="No" Default="">
	<cfargument Name="cobrandDirectory" Type="string" Required="No" Default="">
	<cfargument Name="cobrandID_custom" Type="string" Required="No" Default="">
	<cfargument Name="cobrandIsExported" Type="string" Required="No" Default="">
	<cfargument Name="cobrandDateExported" Type="string" Required="No" Default="">

	<cfset var qry_insertCobrand = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Cobrand" method="maxlength_Cobrand" returnVariable="maxlength_Cobrand" />

	<cfquery Name="qry_insertCobrand" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCobrand
		(
			companyID, userID, userID_author, companyID_author, cobrandName, cobrandCode, cobrandStatus,
			cobrandImage, cobrandURL, cobrandTitle, cobrandDomain, cobrandDirectory, cobrandID_custom,
			cobrandIsExported, cobrandDateExported, cobrandDateCreated, cobrandDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.cobrandName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandName#">,
			<cfqueryparam Value="#Arguments.cobrandCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandCode#">,
			<cfqueryparam Value="#Arguments.cobrandStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.cobrandImage#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandImage#">,
			<cfqueryparam Value="#Arguments.cobrandURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandURL#">,
			<cfqueryparam Value="#Arguments.cobrandTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandTitle#">,
			<cfqueryparam Value="#Arguments.cobrandDomain#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandDomain#">,
			<cfqueryparam Value="#Arguments.cobrandDirectory#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandDirectory#">,
			<cfqueryparam Value="#Arguments.cobrandID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandID_custom#">,
			<cfif Not ListFind("0,1", Arguments.cobrandIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.cobrandIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.cobrandDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.cobrandDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "cobrandID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertCobrand.primaryKeyID>
</cffunction>

<cffunction Name="updateCobrand" Access="public" Output="No" ReturnType="boolean" Hint="Update existing cobrands">
	<cfargument Name="cobrandID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="cobrandName" Type="string" Required="No">
	<cfargument Name="cobrandCode" Type="string" Required="No">
	<cfargument Name="cobrandURL" Type="string" Required="No">
	<cfargument Name="cobrandStatus" Type="numeric" Required="No">
	<cfargument Name="cobrandImage" Type="string" Required="No">
	<cfargument Name="cobrandTitle" Type="string" Required="No">
	<cfargument Name="cobrandDomain" Type="string" Required="No">
	<cfargument Name="cobrandDirectory" Type="string" Required="No">
	<cfargument Name="cobrandID_custom" Type="string" Required="No">
	<cfargument Name="cobrandIsExported" Type="string" Required="No">
	<cfargument Name="cobrandDateExported" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Cobrand" method="maxlength_Cobrand" returnVariable="maxlength_Cobrand" />

	<cfquery Name="qry_updateCobrand" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCobrand
		SET
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerNonNegative(Arguments.companyID)>companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandName")>cobrandName = <cfqueryparam Value="#Arguments.cobrandName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandName#">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandCode")>cobrandCode = <cfqueryparam Value="#Arguments.cobrandCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandCode#">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandStatus") and ListFind("0,1", Arguments.cobrandStatus)>cobrandStatus = <cfqueryparam Value="#Arguments.cobrandStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandImage")>cobrandImage = <cfqueryparam Value="#Arguments.cobrandImage#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandImage#">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandURL")>cobrandURL = <cfqueryparam Value="#Arguments.cobrandURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandURL#">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandTitle")>cobrandTitle = <cfqueryparam Value="#Arguments.cobrandTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandTitle#">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandDomain")>cobrandDomain = <cfqueryparam Value="#Arguments.cobrandDomain#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandDomain#">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandDirectory")>cobrandDirectory = <cfqueryparam Value="#Arguments.cobrandDirectory#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandDirectory#">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandID_custom")>cobrandID_custom = <cfqueryparam Value="#Arguments.cobrandID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandIsExported") and (Arguments.cobrandIsExported is "" or ListFind("0,1", Arguments.cobrandIsExported))>cobrandIsExported = <cfif Not ListFind("0,1", Arguments.cobrandIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.cobrandIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandDateExported") and (Arguments.cobrandDateExported is "" or IsDate(Arguments.cobrandDateExported))>cobrandDateExported = <cfif Not IsDate(Arguments.cobrandDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.cobrandDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			cobrandDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE cobrandID = <cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectCobrand" Access="public" Output="No" ReturnType="query" Hint="Selects existing cobrand">
	<cfargument Name="cobrandID" Type="string" Required="Yes">

	<cfset var qry_selectCobrand = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.cobrandID)>
		<cfset Arguments.cobrandID = 0>
	</cfif>

	<cfquery Name="qry_selectCobrand" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT cobrandID, companyID, userID, userID_author, companyID_author, cobrandName,
			cobrandCode, cobrandStatus, cobrandImage, cobrandURL, cobrandTitle, cobrandDomain,
			cobrandDirectory, cobrandID_custom, cobrandIsExported, cobrandDateExported,
			cobrandDateCreated, cobrandDateUpdated
		FROM avCobrand
		WHERE cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectCobrand>
</cffunction>

<cffunction Name="selectCobrandIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects cobrandID of existing cobrand via custom ID and returns cobrandID(s) if exists, 0 if not exists, and -1 if multiple cobrands have the same cobrandID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="cobrandID_custom" Type="string" Required="Yes">

	<cfset var qry_selectCobrandIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectCobrandIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT cobrandID
		FROM avCobrand
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND cobrandID_custom IN (<cfqueryparam Value="#Arguments.cobrandID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectCobrandIDViaCustomID.RecordCount is 0 or qry_selectCobrandIDViaCustomID.RecordCount lt ListLen(Arguments.cobrandID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectCobrandIDViaCustomID.RecordCount gt ListLen(Arguments.cobrandID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectCobrandIDViaCustomID.cobrandID)>
	</cfif>
</cffunction>

<cffunction Name="checkCobrandPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for cobrand(s)">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="cobrandID" Type="string" Required="Yes">

	<cfset var qry_checkCobrandPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.cobrandID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkCobrandPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT userID_author, companyID_author
			FROM avCobrand
			WHERE cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
				<cfif Arguments.userID_author is not 0>
					AND userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">
				</cfif>
		</cfquery>

		<cfif qry_checkCobrandPermission.RecordCount is 0 or qry_checkCobrandPermission.RecordCount is not ListLen(Arguments.cobrandID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="checkCobrandCodeIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Validate cobrand code is unique">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="cobrandCode" Type="string" Required="Yes">
	<cfargument Name="cobrandID" Type="numeric" Required="No">

	<cfset var qry_checkCobrandCodeIsUnique = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Cobrand" method="maxlength_Cobrand" returnVariable="maxlength_Cobrand" />

	<cfquery Name="qry_checkCobrandCodeIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT cobrandID
		FROM avCobrand
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND cobrandCode = <cfqueryparam Value="#Arguments.cobrandCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Cobrand.cobrandCode#">
			<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerNonNegative(Arguments.cobrandID)>
				AND cobrandID <> <cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkCobrandCodeIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<!--- functions for viewing list of cobrands --->
<cffunction Name="selectCobrandList" Access="public" ReturnType="query" Hint="Select list of cobrands">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="cobrandStatus" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="cobrandHasCode" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomID" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCommission" Type="numeric" Required="No">
	<cfargument Name="cobrandNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="cobrandHasUser" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomer" Type="numeric" Required="No">
	<cfargument Name="cobrandHasActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="cobrandName" Type="string" Required="No">
	<cfargument Name="cobrandCode" Type="string" Required="No">
	<cfargument Name="cobrandURL" Type="string" Required="No">
	<cfargument Name="cobrandID_custom" Type="string" Required="No">
	<cfargument Name="cobrandTitle" Type="string" Required="No">
	<cfargument Name="cobrandDomain" Type="string" Required="No">
	<cfargument Name="cobrandDirectory" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="cobrandID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="cobrandIsExported" Type="string" Required="No">
	<cfargument Name="cobrandDateExported_from" Type="string" Required="No">
	<cfargument Name="cobrandDateExported_to" Type="string" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="no" default="cobrandName">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="queryFirstLetter" Type="string" Required="No" Default="">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="No" Default="">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectCobrandList = QueryNew("blank")>
	<cfset var queryParameters_orderBy = "avCobrand.cobrandName">
	<cfset var queryParameters_orderBy_noTable = "cobrandName">
	<cfset var displayOr = False>

	<cfswitch expression="#Arguments.queryOrderBy#">
	<cfcase value="cobrandName,cobrandCode,cobrandURL,cobrandDateUpdated,cobrandTitle,cobrandDomain,cobrandDirectory"><cfset queryParameters_orderBy = "avCobrand.#Arguments.queryOrderBy#"></cfcase>
	<cfcase value="cobrandName_d,cobrandCode_d,cobrandURL_d,cobrandDateUpdated_d,cobrandTitle_d,cobrandDomain_d,cobrandDirectory_d"><cfset queryParameters_orderBy = "avCobrand.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	<cfcase value="cobrandStatus"><cfset queryParameters_orderBy = "avCobrand.cobrandStatus DESC, avCobrand.cobrandName"></cfcase>
	<cfcase value="cobrandStatus_d"><cfset queryParameters_orderBy = "avCobrand.cobrandStatus, avCobrand.cobrandName"></cfcase>
	<cfcase value="cobrandID_custom"><cfset queryParameters_orderBy = "avCobrand.cobrandID_custom"></cfcase>
	<cfcase value="cobrandID_custom_d"><cfset queryParameters_orderBy = "avCobrand.cobrandID_custom DESC"></cfcase>
	<cfcase value="cobrandDateCreated"><cfset queryParameters_orderBy = "avCobrand.cobrandID"></cfcase>
	<cfcase value="cobrandDateCreated_d"><cfset queryParameters_orderBy = "avCobrand.cobrandID DESC"></cfcase>
	<cfcase value="companyName,companyName_d,lastName,lastName_d">
		<cfif Arguments.returnCompanyFields is False>
			<cfset queryParameters_orderBy = "avCobrand.cobrandName">
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
	<cfloop index="table" list="avUser,avCompany,avCobrand">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectCobrandList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avCobrand.cobrandID, avCobrand.companyID, avCobrand.userID, avCobrand.userID_author,
			avCobrand.companyID_author, avCobrand.cobrandName, avCobrand.cobrandCode,
			avCobrand.cobrandStatus, avCobrand.cobrandImage, avCobrand.cobrandURL, avCobrand.cobrandTitle,
			avCobrand.cobrandDomain, avCobrand.cobrandDirectory, avCobrand.cobrandID_custom,
			avCobrand.cobrandIsExported, avCobrand.cobrandDateExported,
			avCobrand.cobrandDateCreated, avCobrand.cobrandDateUpdated
			<cfif Arguments.returnCompanyFields is True>, avCompany.companyName, avCompany.companyID_custom, avCompany.companyDBA, avCompany.companyStatus</cfif>
			<cfif Arguments.returnUserFields is True>, avUser.firstName, avUser.lastName, avUser.userID_custom, avUser.userStatus</cfif>
		FROM avCobrand
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avCobrand.companyID = avCompany.companyID</cfif>
			<cfif Arguments.returnUserFields is True>LEFT OUTER JOIN avUser ON avCobrand.userID = avUser.userID</cfif>
		WHERE
			<cfinclude template="dataShared/qryWhere_selectCobrandList.cfm">
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

	<cfreturn qry_selectCobrandList>
</cffunction>

<cffunction Name="selectCobrandCount" Access="public" ReturnType="numeric" Hint="Select total number of cobrands in list">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="cobrandStatus" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="cobrandHasCode" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomID" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCommission" Type="numeric" Required="No">
	<cfargument Name="cobrandNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="cobrandHasUser" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomer" Type="numeric" Required="No">
	<cfargument Name="cobrandHasActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="cobrandName" Type="string" Required="No">
	<cfargument Name="cobrandCode" Type="string" Required="No">
	<cfargument Name="cobrandURL" Type="string" Required="No">
	<cfargument Name="cobrandID_custom" Type="string" Required="No">
	<cfargument Name="cobrandTitle" Type="string" Required="No">
	<cfargument Name="cobrandDomain" Type="string" Required="No">
	<cfargument Name="cobrandDirectory" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="cobrandID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="cobrandIsExported" Type="string" Required="No">
	<cfargument Name="cobrandDateExported_from" Type="string" Required="No">
	<cfargument Name="cobrandDateExported_to" Type="string" Required="No">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectCobrandList_count = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfquery Name="qry_selectCobrandList_count" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(avCobrand.cobrandID) AS totalRecords
		FROM avCobrand
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avCobrand.companyID = avCompany.companyID</cfif>
		WHERE
			<cfinclude template="dataShared/qryWhere_selectCobrandList.cfm">
	</cfquery>

	<cfreturn qry_selectCobrandList_count.totalRecords>
</cffunction>

<cffunction Name="selectCobrandList_alphabet" Access="public" ReturnType="query" Hint="Select the first letter in value of field by which list of cobrands is ordered">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="cobrandStatus" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="cobrandHasCode" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomID" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCommission" Type="numeric" Required="No">
	<cfargument Name="cobrandNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="cobrandHasUser" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomer" Type="numeric" Required="No">
	<cfargument Name="cobrandHasActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="cobrandName" Type="string" Required="No">
	<cfargument Name="cobrandCode" Type="string" Required="No">
	<cfargument Name="cobrandURL" Type="string" Required="No">
	<cfargument Name="cobrandID_custom" Type="string" Required="No">
	<cfargument Name="cobrandTitle" Type="string" Required="No">
	<cfargument Name="cobrandDomain" Type="string" Required="No">
	<cfargument Name="cobrandDirectory" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="cobrandID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="cobrandIsExported" Type="string" Required="No">
	<cfargument Name="cobrandDateExported_from" Type="string" Required="No">
	<cfargument Name="cobrandDateExported_to" Type="string" Required="No">
	<cfargument Name="alphabetField" Type="string" Required="Yes">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectCobrandList_alphabet = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfquery Name="qry_selectCobrandList_alphabet" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Distinct(Left(#Arguments.alphabetField#, 1)) AS firstLetter
		FROM avCobrand
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avCobrand.companyID = avCompany.companyID</cfif>
			<cfif Arguments.returnUserFields is True>LEFT OUTER JOIN avUser ON avCobrand.userID = avUser.userID</cfif>
		WHERE
			<cfinclude template="dataShared/qryWhere_selectCobrandList.cfm">
		ORDER BY firstLetter
	</cfquery>

	<cfreturn qry_selectCobrandList_alphabet>
</cffunction>

<cffunction Name="selectCobrandList_alphabetPage" Access="public" ReturnType="numeric" Hint="Select page which includes the first record where the first letter in value of field by which list of cobrands is ordered">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="cobrandStatus" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="cobrandHasCode" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomID" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCommission" Type="numeric" Required="No">
	<cfargument Name="cobrandNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="cobrandHasUser" Type="numeric" Required="No">
	<cfargument Name="cobrandHasCustomer" Type="numeric" Required="No">
	<cfargument Name="cobrandHasActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="cobrandName" Type="string" Required="No">
	<cfargument Name="cobrandCode" Type="string" Required="No">
	<cfargument Name="cobrandURL" Type="string" Required="No">
	<cfargument Name="cobrandID_custom" Type="string" Required="No">
	<cfargument Name="cobrandTitle" Type="string" Required="No">
	<cfargument Name="cobrandDomain" Type="string" Required="No">
	<cfargument Name="cobrandDirectory" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="cobrandID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="cobrandIsExported" Type="string" Required="No">
	<cfargument Name="cobrandDateExported_from" Type="string" Required="No">
	<cfargument Name="cobrandDateExported_to" Type="string" Required="No">
	<cfargument Name="queryFirstLetter" Type="string" Required="Yes">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="Yes">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="Yes">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectCobrandList_alphabetPage = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfquery Name="qry_selectCobrandList_alphabetPage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(avCobrand.cobrandID) AS recordCountBeforeAlphabet
		FROM avCobrand
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avCobrand.companyID = avCompany.companyID</cfif>
			<cfif Arguments.returnUserFields is True>LEFT OUTER JOIN avUser ON avCobrand.userID = avUser.userID</cfif>
		WHERE
			<cfinclude template="dataShared/qryWhere_selectCobrandList.cfm">
			<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
				AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
			<cfelse><!--- letter --->
				AND (Left(#Arguments.queryFirstLetter_field#, 1) < '#UCase(Arguments.queryFirstLetter)#'
					OR Left(#Arguments.queryFirstLetter_field#, 1) < '#LCase(Arguments.queryFirstLetter)#')
			</cfif>
	</cfquery>

	<cfreturn 1 + (qry_selectCobrandList_alphabetPage.recordCountBeforeAlphabet \ Arguments.queryDisplayPerPage)>
</cffunction>
<!--- /functions for viewing list of cobrands --->

<!--- Update Export Status --->
<cffunction Name="updateCobrandIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether cobrand records have been exported. Returns True.">
	<cfargument Name="cobrandID" Type="string" Required="Yes">
	<cfargument Name="cobrandIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.cobrandID) or (Arguments.cobrandIsExported is not "" and Not ListFind("0,1", Arguments.cobrandIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateCobrandIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avCobrand
			SET cobrandIsExported = <cfif Not ListFind("0,1", Arguments.cobrandIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.cobrandIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				cobrandDateExported = <cfif Not ListFind("0,1", Arguments.cobrandIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>
		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>
