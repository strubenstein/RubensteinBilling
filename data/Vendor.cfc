<cfcomponent DisplayName="Vendor" Hint="Manages inserting, updating, deleting and viewing vendors">

<cffunction name="maxlength_Vendor" access="public" output="no" returnType="struct">
	<cfset var maxlength_Vendor = StructNew()>

	<cfset maxlength_Vendor.vendorCode = 25>
	<cfset maxlength_Vendor.vendorDescription = 2000>
	<cfset maxlength_Vendor.vendorURL = 100>
	<cfset maxlength_Vendor.vendorName = 255>
	<cfset maxlength_Vendor.vendorImage = 100>
	<cfset maxlength_Vendor.vendorID_custom = 50>

	<cfreturn maxlength_Vendor>
</cffunction>

<cffunction Name="insertVendor" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new Vendor. Returns vendorID.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="vendorCode" Type="string" Required="No" Default="">
	<cfargument Name="vendorDescription" Type="string" Required="No" Default="">
	<cfargument Name="vendorDescriptionHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="vendorDescriptionDisplay" Type="numeric" Required="No" Default="0">
	<cfargument Name="vendorURL" Type="string" Required="No" Default="">
	<cfargument Name="vendorURLdisplay" Type="numeric" Required="No" Default="0">
	<cfargument Name="vendorName" Type="string" Required="Yes">
	<cfargument Name="vendorImage" Type="string" Required="No" Default="">
	<cfargument Name="vendorStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="vendorID_custom" Type="string" Required="No" Default="">
	<cfargument Name="vendorIsExported" Type="string" Required="No" Default="">
	<cfargument Name="vendorDateExported" Type="string" Required="No" Default="">

	<cfset var qry_insertVendor = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Vendor" method="maxlength_Vendor" returnVariable="maxlength_Vendor" />

	<cfquery Name="qry_insertVendor" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avVendor
		(
			companyID, userID, companyID_author, userID_author, vendorCode, vendorDescription, vendorDescriptionHtml,
			vendorDescriptionDisplay, vendorURL, vendorURLdisplay, vendorName, vendorImage, vendorStatus, vendorID_custom,
			vendorIsExported, vendorDateExported, vendorDateCreated, vendorDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.vendorCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorCode#">,
			<cfqueryparam Value="#Arguments.vendorDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorDescription#">,
			<cfqueryparam Value="#Arguments.vendorDescriptionHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.vendorDescriptionDisplay#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.vendorURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorURL#">,
			<cfqueryparam Value="#Arguments.vendorURLdisplay#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.vendorName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorName#">,
			<cfqueryparam Value="#Arguments.vendorImage#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorImage#">,
			<cfqueryparam Value="#Arguments.vendorStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.vendorID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorID_custom#">,
			<cfif Not ListFind("0,1", Arguments.vendorIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.vendorIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.vendorDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.vendorDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "vendorID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertVendor.primaryKeyID>
</cffunction>

<cffunction Name="updateVendor" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing vendor. Returns True.">
	<cfargument Name="vendorID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="vendorCode" Type="string" Required="No">
	<cfargument Name="vendorDescription" Type="string" Required="No">
	<cfargument Name="vendorDescriptionHtml" Type="numeric" Required="No">
	<cfargument Name="vendorDescriptionDisplay" Type="numeric" Required="No">
	<cfargument Name="vendorURL" Type="string" Required="No">
	<cfargument Name="vendorURLdisplay" Type="numeric" Required="No">
	<cfargument Name="vendorName" Type="string" Required="No">
	<cfargument Name="vendorImage" Type="string" Required="No">
	<cfargument Name="vendorStatus" Type="numeric" Required="No">
	<cfargument Name="vendorID_custom" Type="string" Required="No">
	<cfargument Name="vendorIsExported" Type="string" Required="No">
	<cfargument Name="vendorDateExported" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Vendor" method="maxlength_Vendor" returnVariable="maxlength_Vendor" />

	<cfquery Name="qry_updateVendor" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avVendor
		SET 
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorCode")>vendorCode = <cfqueryparam Value="#Arguments.vendorCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorCode#">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorDescription")>vendorDescription = <cfqueryparam Value="#Arguments.vendorDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorDescriptionHtml") and ListFind("0,1", Arguments.vendorDescriptionHtml)>vendorDescriptionHtml = <cfqueryparam Value="#Arguments.vendorDescriptionHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorDescriptionDisplay") and ListFind("0,1", Arguments.vendorDescriptionDisplay)>vendorDescriptionDisplay = <cfqueryparam Value="#Arguments.vendorDescriptionDisplay#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorURL")>vendorURL = <cfqueryparam Value="#Arguments.vendorURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorURL#">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorURLdisplay") and ListFind("0,1", Arguments.vendorURLdisplay)>vendorURLdisplay = <cfqueryparam Value="#Arguments.vendorURLdisplay#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorName")>vendorName = <cfqueryparam Value="#Arguments.vendorName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorName#">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorImage")>vendorImage = <cfqueryparam Value="#Arguments.vendorImage#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorImage#">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorStatus") and ListFind("0,1", Arguments.vendorStatus)>vendorStatus = <cfqueryparam Value="#Arguments.vendorStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorID_custom")>vendorID_custom = <cfqueryparam Value="#Arguments.vendorID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Vendor.vendorID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorIsExported") and (Arguments.vendorIsExported is "" or ListFind("0,1", Arguments.vendorIsExported))>vendorIsExported = <cfif Not ListFind("0,1", Arguments.vendorIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.vendorIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "vendorDateExported") and (Arguments.vendorDateExported is "" or IsDate(Arguments.vendorDateExported))>vendorDateExported = <cfif Not IsDate(Arguments.vendorDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.vendorDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			vendorDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE vendorID = <cfqueryparam Value="#Arguments.vendorID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkVendorPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check Company Permission for Existing Vendor">
	<cfargument Name="vendorID" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">

	<cfset var qry_checkVendorPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.vendorID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkVendorPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT vendorID, companyID, companyID_author
			FROM avVendor
			WHERE vendorID IN (<cfqueryparam Value="#Arguments.vendorID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND (companyID = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
					OR companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">)
		</cfquery>

		<cfif qry_checkVendorPermission.RecordCount is 0 or qry_checkVendorPermission.RecordCount is not ListLen(Arguments.vendorID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="checkVendorCodeIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check vendor code is unique for all company vendors">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="vendorCode" Type="string" Required="Yes">
	<cfargument Name="vendorID" Type="numeric" Required="No">

	<cfset var qry_checkVendorCodeIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkVendorCodeIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT vendorID
		FROM avVendor
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND vendorCode = <cfqueryparam Value="#Arguments.vendorCode#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "vendorID") and Application.fn_IsIntegerNonNegative(Arguments.vendorID)>
				AND vendorID <> <cfqueryparam Value="#Arguments.vendorID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkVendorCodeIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectVendorIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects vendorID of existing vendor via custom ID and returns vendorID(s) if exists, 0 if not exists, and -1 if multiple vendors have the same vendorID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="vendorID_custom" Type="string" Required="Yes">

	<cfset var qry_selectVendorIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectVendorIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT vendorID
		FROM avVendor
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND vendorID_custom IN (<cfqueryparam Value="#Arguments.vendorID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectVendorIDViaCustomID.RecordCount is 0 or qry_selectVendorIDViaCustomID.RecordCount lt ListLen(Arguments.vendorID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectVendorIDViaCustomID.RecordCount gt ListLen(Arguments.vendorID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectVendorIDViaCustomID.vendorID)>
	</cfif>
</cffunction>

<cffunction Name="selectVendor" Access="public" Output="No" ReturnType="query" Hint="Select Existing Vendor">
	<cfargument Name="vendorID" Type="string" Required="Yes">
	<cfargument Name="returnVendorDescription" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectVendor = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.vendorID)>
		<cfset Arguments.vendorID = 0>
	</cfif>

	<cfquery Name="qry_selectVendor" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT vendorID, companyID, userID, companyID_author, userID_author, vendorCode,
			vendorDescriptionDisplay, vendorURL, vendorURLdisplay, vendorName, vendorImage,
			vendorStatus, vendorID_custom, vendorIsExported, vendorDateExported, vendorDateCreated, vendorDateUpdated
			<cfif Arguments.returnVendorDescription is True>, vendorDescription, vendorDescriptionHtml</cfif>
		FROM avVendor
		WHERE vendorID IN (<cfqueryparam Value="#Arguments.vendorID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectVendor>
</cffunction>


<!--- functions for viewing list of vendors --->
<cffunction Name="selectVendorList" Access="public" ReturnType="query" Hint="Select list of vendors">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="vendorStatus" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="vendorHasCode" Type="numeric" Required="No">
	<cfargument Name="vendorHasCustomID" Type="numeric" Required="No">
	<cfargument Name="vendorNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="vendorHasUser" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="vendorName" Type="string" Required="No">
	<cfargument Name="vendorCode" Type="string" Required="No">
	<cfargument Name="vendorURL" Type="string" Required="No">
	<cfargument Name="vendorID_custom" Type="string" Required="No">
	<cfargument Name="vendorDescription" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="vendorID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="vendorIsExported" Type="string" Required="No">
	<cfargument Name="vendorDateExported_from" Type="string" Required="No">
	<cfargument Name="vendorDateExported_to" Type="string" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="No" Default="vendorName">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="queryFirstLetter" Type="string" Required="No" Default="">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="No" Default="">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnVendorDescription" Type="boolean" Required="No" Default="False">

	<cfset var queryParameters_orderBy = "avVendor.vendorName">
	<cfset var queryParameters_orderBy_noTable = "vendorName">
	<cfset var qry_selectVendorList = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfswitch expression="#Arguments.queryOrderBy#">
	<cfcase value="vendorName,vendorCode,vendorURL,vendorDateUpdated"><cfset queryParameters_orderBy = "avVendor.#Arguments.queryOrderBy#"></cfcase>
	<cfcase value="vendorName_d,vendorCode_d,vendorURL_d,vendorDateUpdated_d"><cfset queryParameters_orderBy = "avVendor.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	<cfcase value="vendorStatus"><cfset queryParameters_orderBy = "avVendor.vendorStatus DESC, avVendor.vendorName"></cfcase>
	<cfcase value="vendorStatus_d"><cfset queryParameters_orderBy = "avVendor.vendorStatus, avVendor.vendorName"></cfcase>
	<cfcase value="vendorID_custom"><cfset queryParameters_orderBy = "avVendor.vendorID_custom"></cfcase>
	<cfcase value="vendorID_custom_d"><cfset queryParameters_orderBy = "avVendor.vendorID_custom DESC"></cfcase>
	<cfcase value="vendorDateCreated"><cfset queryParameters_orderBy = "avVendor.vendorID"></cfcase>
	<cfcase value="vendorDateCreated_d"><cfset queryParameters_orderBy = "avVendor.vendorID DESC"></cfcase>
	<cfcase value="companyName,companyName_d,lastName,lastName_d">
		<cfif Arguments.returnCompanyFields is False>
			<cfset queryParameters_orderBy = "avVendor.vendorName">
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
	<cfloop index="table" list="avUser,avCompany,avVendor">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectVendorList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avVendor.vendorID, avVendor.companyID, avVendor.userID, avVendor.companyID_author, avVendor.userID_author,
			avVendor.vendorCode, avVendor.vendorDescriptionDisplay, avVendor.vendorURL, avVendor.vendorURLdisplay,
			avVendor.vendorName, avVendor.vendorImage, avVendor.vendorStatus, avVendor.vendorID_custom,
			avVendor.vendorIsExported, avVendor.vendorDateExported, avVendor.vendorDateCreated, avVendor.vendorDateUpdated
			<cfif Arguments.returnVendorDescription is True>, avVendor.vendorDescription, avVendor.vendorDescriptionHtml</cfif>
			<cfif Arguments.returnCompanyFields is True>, avCompany.companyName, avCompany.companyID_custom, avCompany.companyDBA, avCompany.companyStatus</cfif>
			<cfif Arguments.returnUserFields is True>, avUser.firstName, avUser.lastName, avUser.userID_custom, avUser.userStatus</cfif>
		FROM avVendor
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avVendor.companyID = avCompany.companyID</cfif>
			<cfif Arguments.returnUserFields is True>LEFT OUTER JOIN avUser ON avVendor.userID = avUser.userID</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectVendorList.cfm">
			<cfif StructKeyExists(Arguments, "queryFirstLetter") and Arguments.queryFirstLetter is not "" and StructKeyExists(Arguments, "queryFirstLetter_field") and Arguments.queryFirstLetter_field is not "">
				<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
					AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
				<cfelse><!--- letter --->
					AND (Left(#Arguments.queryFirstLetter_field#, 1) >= '#UCase(Arguments.queryFirstLetter)#'
						OR Left(#Arguments.queryFirstLetter_field#, 1) >= '#LCase(Arguments.queryFirstLetter)#')
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

	<cfreturn qry_selectVendorList>
</cffunction>

<cffunction Name="selectVendorCount" Access="public" ReturnType="numeric" Hint="Select total number of vendors in list">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="vendorStatus" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="vendorHasCode" Type="numeric" Required="No">
	<cfargument Name="vendorHasCustomID" Type="numeric" Required="No">
	<cfargument Name="vendorNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="vendorHasUser" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="vendorName" Type="string" Required="No">
	<cfargument Name="vendorCode" Type="string" Required="No">
	<cfargument Name="vendorURL" Type="string" Required="No">
	<cfargument Name="vendorID_custom" Type="string" Required="No">
	<cfargument Name="vendorDescription" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="vendorID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="vendorIsExported" Type="string" Required="No">
	<cfargument Name="vendorDateExported_from" Type="string" Required="No">
	<cfargument Name="vendorDateExported_to" Type="string" Required="No">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectVendorList_count = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfquery Name="qry_selectVendorList_count" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(avVendor.vendorID) AS totalRecords
		FROM avVendor
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avVendor.companyID = avCompany.companyID</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectVendorList.cfm">
	</cfquery>

	<cfreturn qry_selectVendorList_count.totalRecords>
</cffunction>

<cffunction Name="selectVendorList_alphabet" Access="public" ReturnType="query" Hint="Select the first letter in value of field by which list of vendors is ordered">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="vendorStatus" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="vendorHasCode" Type="numeric" Required="No">
	<cfargument Name="vendorHasCustomID" Type="numeric" Required="No">
	<cfargument Name="vendorNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="vendorHasUser" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="vendorName" Type="string" Required="No">
	<cfargument Name="vendorCode" Type="string" Required="No">
	<cfargument Name="vendorURL" Type="string" Required="No">
	<cfargument Name="vendorID_custom" Type="string" Required="No">
	<cfargument Name="vendorDescription" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="vendorID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="vendorIsExported" Type="string" Required="No">
	<cfargument Name="vendorDateExported_from" Type="string" Required="No">
	<cfargument Name="vendorDateExported_to" Type="string" Required="No">
	<cfargument Name="alphabetField" Type="string" Required="Yes">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectVendorList_alphabet = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfquery Name="qry_selectVendorList_alphabet" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Distinct(Left(#Arguments.alphabetField#, 1)) AS firstLetter
		FROM avVendor
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avVendor.companyID = avCompany.companyID</cfif>
			<cfif Arguments.returnUserFields is True>LEFT OUTER JOIN avUser ON avVendor.userID = avUser.userID</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectVendorList.cfm">
		ORDER BY firstLetter
	</cfquery>

	<cfreturn qry_selectVendorList_alphabet>
</cffunction>

<cffunction Name="selectVendorList_alphabetPage" Access="public" ReturnType="numeric" Hint="Select page which includes the first record where the first letter in value of field by which list of vendors is ordered">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="vendorStatus" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="vendorHasCode" Type="numeric" Required="No">
	<cfargument Name="vendorHasCustomID" Type="numeric" Required="No">
	<cfargument Name="vendorNameIsCompanyName" Type="numeric" Required="No">
	<cfargument Name="vendorHasUser" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="vendorName" Type="string" Required="No">
	<cfargument Name="vendorCode" Type="string" Required="No">
	<cfargument Name="vendorURL" Type="string" Required="No">
	<cfargument Name="vendorID_custom" Type="string" Required="No">
	<cfargument Name="vendorDescription" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="vendorID_not" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_not" Type="string" Required="No">
	<cfargument Name="vendorIsExported" Type="string" Required="No">
	<cfargument Name="vendorDateExported_from" Type="string" Required="No">
	<cfargument Name="vendorDateExported_to" Type="string" Required="No">
	<cfargument Name="queryFirstLetter" Type="string" Required="Yes">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="Yes">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="Yes">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectVendorList_alphabetPage = QueryNew("blank")>
	<cfset var displayOr = False>

	<cfquery Name="qry_selectVendorList_alphabetPage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(avVendor.vendorID) AS recordCountBeforeAlphabet
		FROM avVendor
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avVendor.companyID = avCompany.companyID</cfif>
			<cfif Arguments.returnUserFields is True>LEFT OUTER JOIN avUser ON avVendor.userID = avUser.userID</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectVendorList.cfm">
			<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
				AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
			<cfelse><!--- letter --->
				AND (Left(#Arguments.queryFirstLetter_field#, 1) < '#UCase(Arguments.queryFirstLetter)#'
					OR Left(#Arguments.queryFirstLetter_field#, 1) < '#LCase(Arguments.queryFirstLetter)#')
			</cfif>
	</cfquery>

	<cfreturn 1 + (qry_selectVendorList_alphabetPage.recordCountBeforeAlphabet \ Arguments.queryDisplayPerPage)>
</cffunction>
<!--- /functions for viewing list of vendors --->

<!--- Update Export Status --->
<cffunction Name="updateVendorIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether vendor records have been exported. Returns True.">
	<cfargument Name="vendorID" Type="string" Required="Yes">
	<cfargument Name="vendorIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.vendorID) or (Arguments.vendorIsExported is not "" and Not ListFind("0,1", Arguments.vendorIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateVendorIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avVendor
			SET vendorIsExported = <cfif Not ListFind("0,1", Arguments.vendorIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.vendorIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				vendorDateExported = <cfif Not ListFind("0,1", Arguments.vendorIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE vendorID IN (<cfqueryparam Value="#Arguments.vendorID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>
