<cfcomponent DisplayName="SalesCommission" Hint="Manages the processing of sales commissions">

<cffunction name="maxlength_SalesCommission" access="public" output="no" returnType="struct">
	<cfset var maxlength_SalesCommission = StructNew()>

	<cfset maxlength_SalesCommission.salesCommissionAmount = 4>
	<cfset maxlength_SalesCommission.salesCommissionBasisTotal = 4>
	<cfset maxlength_SalesCommission.salesCommissionBasisQuantity = 4>

	<cfreturn maxlength_SalesCommission>
</cffunction>

<!--- SalesCommission --->
<cffunction Name="insertSalesCommission" Access="public" Output="No" ReturnType="numeric" Hint="Inserts sales commission. Returns True.">
	<cfargument Name="commissionID" Type="numeric" Required="No" Default="0">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="salesCommissionAmount" Type="numeric" Required="No" Default="0">
	<cfargument Name="salesCommissionFinalized" Type="numeric" Required="No" Default="0">
	<cfargument Name="salesCommissionDateFinalized" Type="string" Required="No" Default="">
	<cfargument Name="salesCommissionPaid" Type="string" Required="No" Default="">
	<cfargument Name="salesCommissionDatePaid" Type="string" Required="No" Default="">
	<cfargument Name="salesCommissionStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="salesCommissionManual" Type="numeric" Required="No" Default="0">
	<cfargument Name="salesCommissionDateBegin" Type="string" Required="No" Default="">
	<cfargument Name="salesCommissionDateEnd" Type="string" Required="No" Default="">
	<cfargument Name="salesCommissionBasisTotal" Type="numeric" Required="No" Default="0">
	<cfargument Name="salesCommissionBasisQuantity" Type="numeric" Required="No" Default="0">
	<cfargument Name="salesCommissionCalculatedAmount" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionStageID" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionVolumeDiscountID" Type="numeric" Required="No" Default="0">
	<cfargument Name="salesCommissionIsExported" Type="string" Required="No" Default="">
	<cfargument Name="salesCommissionDateExported" Type="string" Required="No" Default="">

	<cfset var qry_insertSalesCommission = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.SalesCommission" method="maxlength_SalesCommission" returnVariable="maxlength_SalesCommission" />

	<cfquery Name="qry_insertSalesCommission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avSalesCommission
		(
			commissionID, primaryTargetID, targetID, userID_author, companyID_author, salesCommissionAmount, salesCommissionFinalized,
			salesCommissionDateFinalized, salesCommissionPaid, salesCommissionDatePaid, salesCommissionStatus, salesCommissionManual,
			salesCommissionDateBegin, salesCommissionDateEnd, salesCommissionBasisTotal, salesCommissionBasisQuantity,
			salesCommissionCalculatedAmount, commissionStageID, commissionVolumeDiscountID, salesCommissionIsExported,
			salesCommissionDateExported, salesCommissionDateCreated, salesCommissionDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.commissionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.salesCommissionAmount#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.salesCommissionFinalized#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "salesCommissionDateFinalized") or Not IsDate(Arguments.salesCommissionDateFinalized)>NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionDateFinalized#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not ListFind("0,1", Arguments.salesCommissionPaid)>NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionPaid#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not StructKeyExists(Arguments, "salesCommissionDatePaid") or Not IsDate(Arguments.salesCommissionDatePaid)>NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionDatePaid#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.salesCommissionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.salesCommissionManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "salesCommissionDateBegin") or Not IsDate(Arguments.salesCommissionDateBegin)>NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not StructKeyExists(Arguments, "salesCommissionDateEnd") or Not IsDate(Arguments.salesCommissionDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.salesCommissionBasisTotal#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.salesCommissionBasisQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_SalesCommission.salesCommissionBasisQuantity#">,
			<cfqueryparam Value="#Arguments.salesCommissionCalculatedAmount#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.commissionStageID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.commissionVolumeDiscountID#" cfsqltype="cf_sql_integer">,
			<cfif Not ListFind("0,1", Arguments.salesCommissionIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.salesCommissionDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.salesCommissionDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "salesCommissionID", "ALL")#
	</cfquery>

	<cfreturn qry_insertSalesCommission.primaryKeyID>
</cffunction>

<cffunction Name="updateSalesCommission" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing sales commission. Returns True.">
	<cfargument Name="salesCommissionID" Type="string" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="salesCommissionFinalized" Type="numeric" Required="No">
	<cfargument Name="salesCommissionDateFinalized" Type="string" Required="No">
	<cfargument Name="salesCommissionPaid" Type="string" Required="No">
	<cfargument Name="salesCommissionDatePaid" Type="string" Required="No">
	<cfargument Name="salesCommissionStatus" Type="numeric" Required="No">
	<cfargument Name="salesCommissionIsExported" Type="string" Required="No">
	<cfargument Name="salesCommissionDateExported" Type="string" Required="No">

	<cfif Not Application.fn_IsIntegerList(Arguments.salesCommissionID)>
		<cfreturn False>
	<cfelse>
		<cfinvoke component="#Application.billingMapping#data.SalesCommission" method="maxlength_SalesCommission" returnVariable="maxlength_SalesCommission" />

		<cfquery Name="qry_updateSalesCommission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSalesCommission
			SET
				<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,</cfif>
				<cfif StructKeyExists(Arguments, "salesCommissionStatus") and ListFind("0,1", Arguments.salesCommissionStatus)>salesCommissionStatus = <cfqueryparam Value="#Arguments.salesCommissionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
				<cfif StructKeyExists(Arguments, "salesCommissionFinalized") and (Arguments.salesCommissionFinalized is "" or ListFind("0,1", Arguments.salesCommissionFinalized))>salesCommissionFinalized = <cfif Arguments.salesCommissionFinalized is "">NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionFinalized#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
				<cfif StructKeyExists(Arguments, "salesCommissionDateFinalized") and (Arguments.salesCommissionDateFinalized is "" or IsDate(Arguments.salesCommissionDateFinalized))>salesCommissionDateFinalized = <cfif Arguments.salesCommissionDateFinalized is "">NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionDateFinalized#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
				<cfif StructKeyExists(Arguments, "salesCommissionPaid") and (Arguments.salesCommissionPaid is "" or ListFind("0,1", Arguments.salesCommissionPaid))>salesCommissionPaid = <cfif Arguments.salesCommissionPaid is "">NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionPaid#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
				<cfif StructKeyExists(Arguments, "salesCommissionDatePaid") and (Arguments.salesCommissionDatePaid is "" or IsDate(Arguments.salesCommissionDatePaid))>salesCommissionDatePaid = <cfif Arguments.salesCommissionDatePaid is "">NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionDatePaid#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
				<cfif StructKeyExists(Arguments, "salesCommissionIsExported") and (Arguments.salesCommissionIsExported is "" or ListFind("0,1", Arguments.salesCommissionIsExported))>salesCommissionIsExported = <cfif Not ListFind("0,1", Arguments.salesCommissionIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
				<cfif StructKeyExists(Arguments, "salesCommissionDateExported") and (Arguments.salesCommissionDateExported is "" or IsDate(Arguments.salesCommissionDateExported))>salesCommissionDateExported = <cfif Not IsDate(Arguments.salesCommissionDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.salesCommissionDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
				salesCommissionDateUpdated = #Application.billingSql.sql_nowDateTime#
			WHERE salesCommissionID IN (<cfqueryparam Value="#Arguments.salesCommissionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="checkSalesCommissionPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check sales commission permission for company">
	<cfargument Name="salesCommissionID" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">

	<cfset var qry_checkSalesCommissionPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.salesCommissionID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkSalesCommissionPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT salesCommissionID
			FROM avSalesCommission
			WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
				AND salesCommissionID IN (<cfqueryparam Value="#Arguments.salesCommissionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfif qry_checkSalesCommissionPermission.RecordCount is 0 or qry_checkSalesCommissionPermission.RecordCount is not ListLen(Arguments.salesCommissionID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectSalesCommission" Access="public" Output="No" ReturnType="query" Hint="Select existing sales commission">
	<cfargument Name="salesCommissionID" Type="string" Required="Yes">

	<cfset var qry_selectSalesCommission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.salesCommissionID)>
		<cfset Arguments.salesCommissionID = 0>
	</cfif>

	<cfquery Name="qry_selectSalesCommission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT salesCommissionID, commissionID, primaryTargetID, targetID, userID_author, companyID_author,
			salesCommissionAmount, salesCommissionFinalized, salesCommissionDateFinalized,
			salesCommissionPaid, salesCommissionDatePaid, salesCommissionStatus, salesCommissionManual,
			salesCommissionDateBegin, salesCommissionDateEnd, salesCommissionBasisTotal,
			salesCommissionBasisQuantity, salesCommissionCalculatedAmount, commissionStageID,
			commissionVolumeDiscountID, salesCommissionIsExported, salesCommissionDateExported,
			salesCommissionDateCreated, salesCommissionDateUpdated
		FROM avSalesCommission
		WHERE salesCommissionID IN (<cfqueryparam Value="#Arguments.salesCommissionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectSalesCommission>
</cffunction>

<!--- functions for viewing list of sales commissions --->
<cffunction Name="selectSalesCommissionList" Access="public" ReturnType="query" Hint="Select list of sales commissions">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="numeric" Required="No">
	<cfargument Name="salesCommissionAmount_min" Type="numeric" Required="No">
	<cfargument Name="salesCommissionAmount_max" Type="numeric" Required="No">
	<cfargument Name="salesCommissionFinalized" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFinalized_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFinalized_to" Type="string" Required="No">
	<cfargument Name="salesCommissionPaid" Type="string" Required="No">
	<cfargument Name="salesCommissionDatePaid_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDatePaid_to" Type="string" Required="No">
	<cfargument Name="salesCommissionStatus" Type="string" Required="No">
	<cfargument Name="salesCommissionManual" Type="string" Required="No">
	<cfargument Name="salesCommissionDateType" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFrom" Type="string" Required="No">
	<cfargument Name="salesCommissionDateTo" Type="string" Required="No">
	<cfargument Name="salesCommissionDateBegin_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateBegin_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateEnd_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateEnd_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateCreated_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateCreated_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateUpdated_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateUpdated_to" Type="string" Required="No">
	<cfargument Name="salesCommissionBasisTotal_min" Type="numeric" Required="No">
	<cfargument Name="salesCommissionBasisTotal_max" Type="numeric" Required="No">
	<cfargument Name="salesCommissionID" Type="string" Required="No">
	<cfargument Name="commissionStageID" Type="string" Required="No">
	<cfargument Name="commissionVolumeDiscountID" Type="string" Required="No">

	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="salesCommissionIsExported" Type="string" Required="No">
	<cfargument Name="salesCommissionDateExported_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateExported_to" Type="string" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="no" default="salesCommissionDateFinalized">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="queryFirstLetter" Type="string" Required="No" Default="">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="No" Default="">
	<cfargument Name="returnTargetName" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnSalesCommissionSum" Type="boolean" Required="No" Default="False">

	<cfset var dateClause = "">
	<cfset var displayAnd = True>
	<cfset var fieldList = "">
	<cfset var queryParameters_orderBy = "avSalesCommission.salesCommissionDateFinalized">
	<cfset var queryParameters_orderBy_noTable = "salesCommissionDateFinalized">
	<cfset var qry_selectSalesCommissionList = QueryNew("blank")>

	<cfswitch expression="#Arguments.queryOrderBy#">
	 <cfcase value="commissionID,primaryTargetID,salesCommissionAmount,salesCommissionID,salesCommissionPaid,salesCommissionDateFinalized,salesCommissionDatePaid,salesCommissionBasisTotal,salesCommissionBasisQuantity,salesCommissionDateBegin,salesCommissionDateEnd,salesCommissionDateUpdated">
		<cfset queryParameters_orderBy = "avSalesCommission.#Arguments.queryOrderBy#">
	 </cfcase>
	 <cfcase value="commissionID_d,primaryTargetID_d,salesCommissionAmount_d,salesCommissionID_d,salesCommissionPaid_d,salesCommissionDateFinalized_d,salesCommissionDatePaid_d,salesCommissionBasisTotal_d,salesCommissionBasisQuantity_d,salesCommissionDateBegin_d,salesCommissionDateEnd_d,salesCommissionDateUpdated_d">
		<cfset queryParameters_orderBy = "avSalesCommission.#ListFirst(Arguments.queryOrderBy, '_')# DESC">
	 </cfcase>
	 <cfcase value="salesCommissionDateCreated"><cfset queryParameters_orderBy = "avSalesCommission.salesCommissionID"></cfcase>
	 <cfcase value="salesCommissionDateCreated_d"><cfset queryParameters_orderBy = "avSalesCommission.salesCommissionID DESC"></cfcase>
	 <cfcase value="userID_author"><cfset queryParameters_orderBy = "avSalesCommission.userID_author"></cfcase>
	 <cfcase value="userID_author_d"><cfset queryParameters_orderBy = "avSalesCommission.userID_author DESC"></cfcase>
	 <cfcase value="targetName"><cfset queryParameters_orderBy = "targetName"></cfcase>
	 <cfcase value="targetName_d"><cfset queryParameters_orderBy = "targetName DESC"></cfcase>
	 <cfcase value="commissionName,commissionDescription,commissionDateUpdated"><cfset queryParameters_orderBy = "avCommission.#Arguments.queryOrderBy#"></cfcase>
	 <cfcase value="commissionName_d,commissionDescription_d,commissionDateUpdated_d"><cfset queryParameters_orderBy = "avCommission.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	 <cfcase value="commissionID_custom"><cfset queryParameters_orderBy = "avCommission.commissionID_custom"></cfcase>
	 <cfcase value="commissionID_custom_d"><cfset queryParameters_orderBy = "avCommission.commissionID_custom DESC"></cfcase>
	 <cfcase value="commissionStatus"><cfset queryParameters_orderBy = "avCommission.commissionStatus DESC, avCommission.commissionName"></cfcase>
	 <cfcase value="commissionStatus_d"><cfset queryParameters_orderBy = "avCommission.commissionStatus, avCommission.commissionName DESC"></cfcase>
	 <cfcase value="commissionHasMultipleStages"><cfset queryParameters_orderBy = "avCommission.commissionHasMultipleStages DESC, avCommission.commissionName"></cfcase>
	 <cfcase value="commissionHasMultipleStages_d"><cfset queryParameters_orderBy = "avCommission.commissionHasMultipleStages, avCommission.commissionName DESC"></cfcase>
	 <cfcase value="commissionDateCreated"><cfset queryParameters_orderBy = "avCommission.commissionID"></cfcase>
	 <cfcase value="commissionDateCreated_d"><cfset queryParameters_orderBy = "avCommission.commissionID DESC"></cfcase>
	 <cfcase value="lastName"><cfset queryParameters_orderBy = "avUser.lastName, avUser.firstName"></cfcase>
	 <cfcase value="lastName_d"><cfset queryParameters_orderBy = "avUser.lastName DESC, avUser.firstName DESC"></cfcase>
	 <cfcase value="userID_custom"><cfset queryParameters_orderBy = "avUser.userID_custom"></cfcase>
	 <cfcase value="userID_custom_d"><cfset queryParameters_orderBy = "avUser.userID_custom DESC"></cfcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avUser,avCommission,avSalesCommission">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectSalesCommissionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif StructKeyExists(Arguments, "returnSalesCommissionSum") and Arguments.returnSalesCommissionSum is True>
				avSalesCommission.primaryTargetID, avSalesCommission.targetID, SUM(salesCommissionAmount) AS salesCommissionAmount
			<cfelse>
				<cfif Application.billingDatabase is "MSSQLServer">
					* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
				</cfif>
				avSalesCommission.primaryTargetID, avSalesCommission.targetID, avSalesCommission.salesCommissionAmount,
				avSalesCommission.salesCommissionID, avSalesCommission.commissionID, avSalesCommission.userID_author,
				avSalesCommission.salesCommissionFinalized, avSalesCommission.salesCommissionDateFinalized,
				avSalesCommission.salesCommissionPaid, avSalesCommission.salesCommissionDatePaid,
				avSalesCommission.salesCommissionStatus, avSalesCommission.salesCommissionManual,
				avSalesCommission.salesCommissionBasisTotal, avSalesCommission.salesCommissionBasisQuantity,
				avSalesCommission.salesCommissionDateBegin, avSalesCommission.salesCommissionDateEnd, avSalesCommission.commissionStageID,
				avSalesCommission.commissionVolumeDiscountID, avSalesCommission.salesCommissionCalculatedAmount,
				avSalesCommission.salesCommissionIsExported, avSalesCommission.salesCommissionDateExported,
				avSalesCommission.salesCommissionDateCreated, avSalesCommission.salesCommissionDateUpdated,
				avUser.firstName, avUser.lastName, avUser.userID_custom,
				avCommission.commissionName, avCommission.commissionID_custom, avCommission.commissionStatus,
				avCommission.commissionPeriodOrInvoiceBased, avCommission.commissionHasMultipleStages,
				avCommission.commissionDescription, avCommission.commissionDateCreated, avCommission.commissionDateUpdated
			</cfif>
			<cfif StructKeyExists(Arguments, "returnTargetName") and Arguments.returnTargetName is True>
				,
				CASE avSalesCommission.primaryTargetID
				WHEN 0 THEN ''
				WHEN #Application.fn_GetPrimaryTargetID("userID")# THEN (SELECT #PreserveSingleQuotes(Application.billingSql.concatLastFirstName)# FROM avUser WHERE avUser.userID = avSalesCommission.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("companyID")# THEN (SELECT companyName FROM avCompany WHERE avCompany.companyID = avSalesCommission.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("cobrandID")# THEN (SELECT cobrandName FROM avCobrand WHERE avCobrand.cobrandID = avSalesCommission.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("affiliateID")# THEN (SELECT affiliateName FROM avAffiliate WHERE avAffiliate.affiliateID = avSalesCommission.targetID)
				WHEN #Application.fn_GetPrimaryTargetID("vendorID")# THEN (SELECT vendorName FROM avVendor WHERE avVendor.vendorID = avSalesCommission.targetID)
				ELSE NULL
				END
				AS targetName
			</cfif>
		FROM avSalesCommission
			LEFT JOIN avCommission ON avSalesCommission.commissionID = avCommission.commissionID
			LEFT JOIN avUser ON avSalesCommission.userID_author = avUser.userID
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectSalesCommissionList.cfm">
			<cfif StructKeyExists(Arguments, "queryFirstLetter") and Arguments.queryFirstLetter is not "" and Arguments.queryFirstLetter_field is not "">
				<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
					AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
				<cfelse><!--- letter --->
					AND (Left(#Arguments.queryFirstLetter_field#, 1) >= '#UCase(Arguments.queryFirstLetter)#' OR Left(#Arguments.queryFirstLetter_field#, 1) >= '#LCase(Arguments.queryFirstLetter)#')
				</cfif>
			</cfif>
		<cfif StructKeyExists(Arguments, "returnSalesCommissionSum") and Arguments.returnSalesCommissionSum is True>
			GROUP BY avSalesCommission.primaryTargetID, avSalesCommission.targetID
			ORDER BY 
				<cfif ListFind("targetName,targetName DESC,avSalesCommission.salesCommissionAmount,avSalesCommission.salesCommissionAmount DESC", Arguments.queryParameters_orderBy)>
					#queryParameters_orderBy#
				<cfelse>
					targetName
				</cfif>
		<cfelseif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectSalesCommissionList>
</cffunction>

<cffunction Name="selectSalesCommissionCount" Access="public" ReturnType="numeric" Hint="Select total number of sales commissions in list">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="numeric" Required="No">
	<cfargument Name="salesCommissionAmount_min" Type="numeric" Required="No">
	<cfargument Name="salesCommissionAmount_max" Type="numeric" Required="No">
	<cfargument Name="salesCommissionFinalized" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFinalized_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFinalized_to" Type="string" Required="No">
	<cfargument Name="salesCommissionPaid" Type="string" Required="No">
	<cfargument Name="salesCommissionDatePaid_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDatePaid_to" Type="string" Required="No">
	<cfargument Name="salesCommissionStatus" Type="string" Required="No">
	<cfargument Name="salesCommissionManual" Type="string" Required="No">
	<cfargument Name="salesCommissionDateType" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFrom" Type="string" Required="No">
	<cfargument Name="salesCommissionDateTo" Type="string" Required="No">
	<cfargument Name="salesCommissionDateBegin_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateBegin_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateEnd_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateEnd_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateCreated_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateCreated_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateUpdated_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateUpdated_to" Type="string" Required="No">
	<cfargument Name="salesCommissionBasisTotal_min" Type="numeric" Required="No">
	<cfargument Name="salesCommissionBasisTotal_max" Type="numeric" Required="No">
	<cfargument Name="salesCommissionID" Type="string" Required="No">
	<cfargument Name="commissionStageID" Type="string" Required="No">
	<cfargument Name="commissionVolumeDiscountID" Type="string" Required="No">

	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="salesCommissionIsExported" Type="string" Required="No">
	<cfargument Name="salesCommissionDateExported_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateExported_to" Type="string" Required="No">

	<cfset var dateClause = "">
	<cfset var displayAnd = True>
	<cfset var fieldList = "">
	<cfset var qry_selectSalesCommissionCount = QueryNew("blank")>

	<cfquery Name="qry_selectSalesCommissionCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(avSalesCommission.salesCommissionID) AS totalRecords
		FROM avSalesCommission
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectSalesCommissionList.cfm">
	</cfquery>

	<cfreturn qry_selectSalesCommissionCount.totalRecords>
</cffunction>

<cffunction Name="selectSalesCommissionList_alphabet" Access="public" ReturnType="query" Hint="Select the first letter in value of field by which list of sales commissions is ordered">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="numeric" Required="No">
	<cfargument Name="salesCommissionAmount_min" Type="numeric" Required="No">
	<cfargument Name="salesCommissionAmount_max" Type="numeric" Required="No">
	<cfargument Name="salesCommissionFinalized" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFinalized_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFinalized_to" Type="string" Required="No">
	<cfargument Name="salesCommissionPaid" Type="string" Required="No">
	<cfargument Name="salesCommissionDatePaid_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDatePaid_to" Type="string" Required="No">
	<cfargument Name="salesCommissionStatus" Type="string" Required="No">
	<cfargument Name="salesCommissionManual" Type="string" Required="No">
	<cfargument Name="salesCommissionDateType" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFrom" Type="string" Required="No">
	<cfargument Name="salesCommissionDateTo" Type="string" Required="No">
	<cfargument Name="salesCommissionDateBegin_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateBegin_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateEnd_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateEnd_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateCreated_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateCreated_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateUpdated_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateUpdated_to" Type="string" Required="No">
	<cfargument Name="salesCommissionBasisTotal_min" Type="numeric" Required="No">
	<cfargument Name="salesCommissionBasisTotal_max" Type="numeric" Required="No">
	<cfargument Name="salesCommissionID" Type="string" Required="No">
	<cfargument Name="commissionStageID" Type="string" Required="No">
	<cfargument Name="commissionVolumeDiscountID" Type="string" Required="No">

	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="salesCommissionIsExported" Type="string" Required="No">
	<cfargument Name="salesCommissionDateExported_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateExported_to" Type="string" Required="No">

	<cfargument Name="alphabetField" Type="string" Required="Yes">

	<cfset var dateClause = "">
	<cfset var displayAnd = True>
	<cfset var fieldList = "">
	<cfset var qry_selectSalesCommissionList_alphabet = QueryNew("blank")>

	<cfquery Name="qry_selectSalesCommissionList_alphabet" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Distinct(Left(#Arguments.alphabetField#, 1)) AS firstLetter
		FROM avSalesCommission
			LEFT JOIN avCommission ON avSalesCommission.commissionID = avCommission.commissionID
			LEFT JOIN avUser ON avSalesCommission.userID_author = avUser.userID
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectSalesCommissionList.cfm">
	</cfquery>

	<cfreturn qry_selectSalesCommissionList_alphabet>
</cffunction>

<cffunction Name="selectSalesCommissionList_alphabetPage" Access="public" ReturnType="numeric" Hint="Select page which includes the first record where the first letter in value of field by which list of sales commissions is ordered">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="numeric" Required="No">
	<cfargument Name="salesCommissionAmount_min" Type="numeric" Required="No">
	<cfargument Name="salesCommissionAmount_max" Type="numeric" Required="No">
	<cfargument Name="salesCommissionFinalized" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFinalized_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFinalized_to" Type="string" Required="No">
	<cfargument Name="salesCommissionPaid" Type="string" Required="No">
	<cfargument Name="salesCommissionDatePaid_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDatePaid_to" Type="string" Required="No">
	<cfargument Name="salesCommissionStatus" Type="string" Required="No">
	<cfargument Name="salesCommissionManual" Type="string" Required="No">
	<cfargument Name="salesCommissionDateType" Type="string" Required="No">
	<cfargument Name="salesCommissionDateFrom" Type="string" Required="No">
	<cfargument Name="salesCommissionDateTo" Type="string" Required="No">
	<cfargument Name="salesCommissionDateBegin_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateBegin_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateEnd_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateEnd_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateCreated_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateCreated_to" Type="string" Required="No">
	<cfargument Name="salesCommissionDateUpdated_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateUpdated_to" Type="string" Required="No">
	<cfargument Name="salesCommissionBasisTotal_min" Type="numeric" Required="No">
	<cfargument Name="salesCommissionBasisTotal_max" Type="numeric" Required="No">
	<cfargument Name="salesCommissionID" Type="string" Required="No">
	<cfargument Name="commissionStageID" Type="string" Required="No">
	<cfargument Name="commissionVolumeDiscountID" Type="string" Required="No">

	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="salesCommissionIsExported" Type="string" Required="No">
	<cfargument Name="salesCommissionDateExported_from" Type="string" Required="No">
	<cfargument Name="salesCommissionDateExported_to" Type="string" Required="No">

	<cfargument Name="queryFirstLetter" Type="string" Required="Yes">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="Yes">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="Yes">

	<cfset var dateClause = "">
	<cfset var displayAnd = True>
	<cfset var fieldList = "">
	<cfset var qry_selectSalesCommissionList_alphabetPage = QueryNew("blank")>

	<cfquery Name="qry_selectSalesCommissionList_alphabetPage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(avSalesCommission.salesCommissionID) AS salesCommissionCountBeforeAlphabet
		FROM avSalesCommission
			LEFT JOIN avCommission ON avSalesCommission.commissionID = avCommission.commissionID
			LEFT JOIN avUser ON avSalesCommission.userID_author = avUser.userID
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectSalesCommissionList.cfm">
			<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
				AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
			<cfelse><!--- letter --->
				AND (Left(#Arguments.queryFirstLetter_field#, 1) < '#UCase(Arguments.queryFirstLetter)#'
					OR Left(#Arguments.queryFirstLetter_field#, 1) < '#LCase(Arguments.queryFirstLetter)#')
			</cfif>
	</cfquery>

	<cfreturn 1 + (qry_selectSalesCommissionList_alphabetPage.salesCommissionCountBeforeAlphabet \ Arguments.queryDisplayPerPage)>
</cffunction>
<!--- /functions for viewing list of sales commissions --->

<cffunction Name="deleteSalesCommission" Access="public" Output="No" ReturnType="boolean" Hint="Deletes invoice / sales commission record(s).">
	<cfargument Name="salesCommissionID" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="salesCommissionFinalized" Type="numeric" Required="No">

	<cfset var displayAnd = False>

	<cfif (StructKeyExists(Arguments, "salesCommissionID") and Application.fn_IsIntegerList(Arguments.salesCommissionID)) or (StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerList(Arguments.invoiceID)) or (StructKeyExists(Arguments, "invoiceLineItemID") and Application.fn_IsIntegerList(Arguments.invoiceLineItemID))>
		<cfquery Name="qry_deleteSalesCommission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			DELETE FROM avSalesCommission
			WHERE 
				<cfif StructKeyExists(Arguments, "salesCommissionFinalized") and ListFind("0,1", Arguments.salesCommissionFinalized)>
					salesCommissionFinalized = <cfqueryparam Value="#Arguments.salesCommissionFinalized#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND 
				</cfif>
				<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerPositive(Arguments.primaryTargetID) and StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerList(Arguments.targetID)>
					primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer"> AND 
					targetID IN (<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">) AND 
				</cfif>
				salesCommissionID IN 
					(
					SELECT salesCommissionID
					FROM avSalesCommissionInvoice
					WHERE 
					<cfloop Index="field" List="salesCommissionID,invoiceID,invoiceLineItemID">
						<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
							<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
							#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
						</cfif>
					</cfloop>
					);

			<cfset displayAnd = False>
			DELETE FROM avSalesCommissionInvoice
			WHERE
			<cfloop Index="field" List="salesCommissionID,invoiceID,invoiceLineItemID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
					#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>;
		</cfquery>

		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectVendorProductList" Access="public" Output="No" ReturnType="query" Hint="Selects vendors of products for invoice line items or subscriptions.">
	<cfargument Name="invoiceID" Type="numeric" Required="No">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="No">
	<cfargument Name="subscriberID" Type="numeric" Required="No">
	<cfargument Name="subscriptionID" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="numeric" Required="No">

	<cfset var qry_selectVendorProductList = QueryNew("blank")>

	<cfif (StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerPositive(Arguments.invoiceID)) xor (StructKeyExists(Arguments, "subscriberID") and Application.fn_IsIntegerPositive(Arguments.subscriberID))>
		<cfquery Name="qry_selectVendorProductList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfif StructKeyExists(Arguments, "subscriberID")>
				SELECT avProduct.productName, avProduct.productID_custom, avProduct.vendorID,
					avVendor.vendorName, avVendor.vendorID_custom,
					avSubscription.productID, avSubscription.subscriptionID AS invoiceLineItemID,
					avSubscription.subscriptionOrder AS invoiceLineItemOrder, avSubscription.subscriptionName AS invoiceLineItemName
				FROM avProduct, avVendor, avSubscription
				WHERE avSubscription.productID = avProduct.productID
					AND avProduct.vendorID = avVendor.vendorID
					AND avSubscription.subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">
					<cfif StructKeyExists(Arguments, "subscriptionID") and Application.fn_IsIntegerPositive(Arguments.subscriptionID)>
						AND avSubscription.subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
					<cfelse>
						AND avSubscription.subscriptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					</cfif>
					<cfif StructKeyExists(Arguments, "vendorID") and Application.fn_IsIntegerPositive(Arguments.vendorID)>
						AND avProduct.vendorID = <cfqueryparam Value="#Arguments.vendorID#" cfsqltype="cf_sql_integer">
					</cfif>
				ORDER BY avVendor.vendorName
			<cfelse><!--- StructKeyExists(Arguments, "invoiceID") --->
				SELECT avProduct.productName, avProduct.productID_custom, avProduct.vendorID,
					avVendor.vendorName, avVendor.vendorID_custom,
					avInvoiceLineItem.productID, avInvoiceLineItem.invoiceLineItemID,
					avInvoiceLineItem.invoiceLineItemOrder, avInvoiceLineItem.invoiceLineItemName
				FROM avProduct, avVendor, avInvoiceLineItem
				WHERE avInvoiceLineItem.productID = avProduct.productID
					AND avProduct.vendorID = avVendor.vendorID
					AND avInvoiceLineItem.invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
					<cfif StructKeyExists(Arguments, "invoiceLineItemID") and Application.fn_IsIntegerPositive(Arguments.invoiceLineItemID)>
						AND avInvoiceLineItem.invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">
					<cfelse>
						AND avInvoiceLineItem.invoiceLineItemStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					</cfif>
					<cfif StructKeyExists(Arguments, "vendorID") and Application.fn_IsIntegerPositive(Arguments.vendorID)>
						AND avProduct.vendorID = <cfqueryparam Value="#Arguments.vendorID#" cfsqltype="cf_sql_integer">
					</cfif>
				ORDER BY avVendor.vendorName
			</cfif>
		</cfquery>

		<cfreturn qry_selectVendorProductList>
	<cfelse>
		<cfreturn QueryNew("error")>
	</cfif>
</cffunction>

<!--- Update Export Status --->
<cffunction Name="updateSalesCommissionIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether sales commission records have been exported. Returns True.">
	<cfargument Name="salesCommissionID" Type="string" Required="Yes">
	<cfargument Name="salesCommissionIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.salesCommissionID) or (Arguments.salesCommissionIsExported is not "" and Not ListFind("0,1", Arguments.salesCommissionIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateSalesCommissionIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSalesCommission
			SET salesCommissionIsExported = <cfif Not ListFind("0,1", Arguments.salesCommissionIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.salesCommissionIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				salesCommissionDateExported = <cfif Not ListFind("0,1", Arguments.salesCommissionIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE salesCommissionID IN (<cfqueryparam Value="#Arguments.salesCommissionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>