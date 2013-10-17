<cfcomponent DisplayName="PaymentCredit" Hint="Manages creating, viewing and managing payment credits">

<cffunction name="maxlength_PaymentCredit" access="public" output="no" returnType="struct">
	<cfset var maxlength_PaymentCredit = StructNew()>

	<cfset maxlength_PaymentCredit.paymentCreditID_custom = 50>
	<cfset maxlength_PaymentCredit.paymentCreditDescription = 255>
	<cfset maxlength_PaymentCredit.paymentCreditName = 255>
	<cfset maxlength_PaymentCredit.paymentCreditAmount = 2>

	<cfreturn maxlength_PaymentCredit>
</cffunction>

<cffunction Name="insertPaymentCredit" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new payment credit and returns paymentCreditID">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="paymentCreditAmount" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentCreditStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentCreditName" Type="string" Required="No" Default="">
	<cfargument Name="paymentCreditID_custom" Type="string" Required="No" Default="">
	<cfargument Name="paymentCreditDescription" Type="string" Required="No" Default="">
	<cfargument Name="paymentCreditDateBegin" Type="string" Required="No" Default="">
	<cfargument Name="paymentCreditDateEnd" Type="string" Required="No" Default="">
	<cfargument Name="paymentCreditAppliedMaximum" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentCreditAppliedCount" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentCategoryID" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentCreditRollover" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberID" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentCreditCompleted" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentCreditIsExported" Type="string" Required="No" Default="">
	<cfargument Name="paymentCreditDateExported" Type="string" Required="No" Default="">
	<cfargument Name="paymentCreditNegativeInvoice" Type="numeric" Required="No" Default="0">

	<cfset var qry_insertPaymentCredit = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.PaymentCredit" method="maxlength_PaymentCredit" returnVariable="maxlength_PaymentCredit" />

	<cfquery Name="qry_insertPaymentCredit" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPaymentCredit
		(
			userID, companyID, userID_author, companyID_author, paymentCreditAmount, paymentCreditStatus,
			paymentCreditName, paymentCreditID_custom, paymentCreditDescription, paymentCreditDateBegin,
			paymentCreditDateEnd, paymentCreditAppliedMaximum, paymentCreditAppliedCount, paymentCategoryID,
			paymentCreditRollover, subscriberID, paymentCreditCompleted, paymentCreditNegativeInvoice,
			paymentCreditIsExported, paymentCreditDateExported, paymentCreditDateCreated, paymentCreditDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.paymentCreditAmount#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.paymentCreditStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.paymentCreditName#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCredit.paymentCreditName#">,
			<cfqueryparam Value="#Arguments.paymentCreditID_custom#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCredit.paymentCreditID_custom#">,
			<cfqueryparam Value="#Arguments.paymentCreditDescription#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCredit.paymentCreditDescription#">,
			<cfif Not IsDate(Arguments.paymentCreditDateBegin)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentCreditDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not IsDate(Arguments.paymentCreditDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentCreditDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.paymentCreditAppliedMaximum#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.paymentCreditAppliedCount#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.paymentCreditRollover#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.paymentCreditCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.paymentCreditNegativeInvoice#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not ListFind("0,1", Arguments.paymentCreditIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentCreditIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.paymentCreditDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.paymentCreditDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "paymentCreditID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertPaymentCredit.primaryKeyID>
</cffunction>

<cffunction Name="updatePaymentCredit" Access="public" Output="No" ReturnType="boolean" Hint="Update existing payment credit and returns True">
	<cfargument Name="paymentCreditID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAmount" Type="numeric" Required="No">
	<cfargument Name="paymentCreditStatus" Type="numeric" Required="No">
	<cfargument Name="paymentCreditName" Type="string" Required="No">
	<cfargument Name="paymentCreditID_custom" Type="string" Required="No">
	<cfargument Name="paymentCreditDescription" Type="string" Required="No">
	<cfargument Name="paymentCreditDateBegin" Type="string" Required="No">
	<cfargument Name="paymentCreditDateEnd" Type="string" Required="No">
	<cfargument Name="paymentCreditAppliedMaximum" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedCount" Type="numeric" Required="No">
	<cfargument Name="paymentCategoryID" Type="numeric" Required="No">
	<cfargument Name="paymentCreditRollover" Type="numeric" Required="No">
	<cfargument Name="subscriberID" Type="numeric" Required="No">
	<cfargument Name="paymentCreditCompleted" Type="numeric" Required="No">
	<cfargument Name="paymentCreditIsExported" Type="string" Required="No">
	<cfargument Name="paymentCreditDateExported" Type="string" Required="No">
	<cfargument Name="paymentCreditNegativeInvoice" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.PaymentCredit" method="maxlength_PaymentCredit" returnVariable="maxlength_PaymentCredit" />

	<cfquery Name="qry_updatePaymentCredit" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPaymentCredit
		SET 
			<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditAmount") and IsNumeric(Arguments.paymentCreditAmount)>paymentCreditAmount = <cfqueryparam Value="#Arguments.paymentCreditAmount#" cfsqltype="cf_sql_money">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditID_custom")>paymentCreditID_custom = <cfqueryparam Value="#Arguments.paymentCreditID_custom#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCredit.paymentCreditID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditStatus") and ListFind("0,1", Arguments.paymentCreditStatus)>paymentCreditStatus = <cfqueryparam Value="#Arguments.paymentCreditStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditName")>paymentCreditName = <cfqueryparam Value="#Arguments.paymentCreditName#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCredit.paymentCreditName#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditDescription")>paymentCreditDescription = <cfqueryparam Value="#Arguments.paymentCreditDescription#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCredit.paymentCreditDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditDateBegin")>paymentCreditDateBegin = <cfif Not IsDate(Arguments.paymentCreditDateBegin)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentCreditDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditDateEnd")>paymentCreditDateEnd = <cfif Not IsDate(Arguments.paymentCreditDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentCreditDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditAppliedMaximum") and Application.fn_IsIntegerNonNegative(Arguments.paymentCreditAppliedMaximum)>paymentCreditAppliedMaximum = <cfqueryparam Value="#Arguments.paymentCreditAppliedMaximum#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditAppliedCount") and Application.fn_IsIntegerNonNegative(Arguments.paymentCreditAppliedCount)>paymentCreditAppliedCount = <cfqueryparam Value="#Arguments.paymentCreditAppliedCount#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryID") and Application.fn_IsIntegerNonNegative(Arguments.paymentCategoryID)>paymentCategoryID = <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditRollover") and ListFind("0,1", Arguments.paymentCreditRollover)>paymentCreditRollover = <cfqueryparam Value="#Arguments.paymentCreditRollover#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberID") and Application.fn_IsIntegerNonNegative(Arguments.subscriberID)>subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditCompleted") and ListFind("0,1", Arguments.paymentCreditCompleted)>paymentCreditCompleted = <cfqueryparam Value="#Arguments.paymentCreditCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditNegativeInvoice") and ListFind("0,1", Arguments.paymentCreditNegativeInvoice)>paymentCreditNegativeInvoice = <cfqueryparam Value="#Arguments.paymentCreditNegativeInvoice#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditIsExported") and (Arguments.paymentCreditIsExported is "" or ListFind("0,1", Arguments.paymentCreditIsExported))>paymentCreditIsExported = <cfif Not ListFind("0,1", Arguments.paymentCreditIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentCreditIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditDateExported") and (Arguments.paymentCreditDateExported is "" or IsDate(Arguments.paymentCreditDateExported))>paymentCreditDateExported = <cfif Not IsDate(Arguments.paymentCreditDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.paymentCreditDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			paymentCreditDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE paymentCreditID = <cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPaymentCredit" Access="public" Output="No" ReturnType="query" Hint="Selects existing payment credit(s)">
	<cfargument Name="paymentCreditID" Type="string" Required="Yes">

	<cfset var qry_selectPaymentCredit = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.paymentCreditID)>
		<cfset Arguments.paymentCreditID = 0>
	</cfif>

	<cfquery Name="qry_selectPaymentCredit" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avPaymentCredit.paymentCreditID, avPaymentCredit.userID, avPaymentCredit.companyID, avPaymentCredit.userID_author,
			avPaymentCredit.companyID_author, avPaymentCredit.paymentCreditAmount, avPaymentCredit.paymentCreditStatus,
			avPaymentCredit.paymentCreditName, avPaymentCredit.paymentCreditID_custom, avPaymentCredit.paymentCreditDescription,
			avPaymentCredit.paymentCreditDateBegin, avPaymentCredit.paymentCreditDateEnd, avPaymentCredit.paymentCreditAppliedMaximum,
			avPaymentCredit.paymentCreditAppliedCount, avPaymentCredit.paymentCategoryID, avPaymentCredit.paymentCreditRollover,
			avPaymentCredit.paymentCreditNegativeInvoice, avPaymentCredit.subscriberID, avPaymentCredit.paymentCreditCompleted,
			avPaymentCredit.paymentCreditDateCreated, avPaymentCredit.paymentCreditDateUpdated,
			avPaymentCredit.paymentCreditIsExported, avPaymentCredit.paymentCreditDateExported,
			AuthorUser.firstName AS authorFirstName, AuthorUser.lastName AS authorLastName, AuthorUser.userID_custom AS authorUserID_custom,
			TargetUser.firstName AS targetFirstName, TargetUser.lastName AS targetLastName, TargetUser.userID_custom AS targetUserID_custom,
			TargetCompany.companyName AS targetCompanyName, TargetCompany.companyID_custom AS targetCompanyID_custom,
			avSubscriber.subscriberName, avSubscriber.subscriberID_custom
		FROM avPaymentCredit
			LEFT OUTER JOIN avUser AS AuthorUser ON avPaymentCredit.userID_author = AuthorUser.userID
			LEFT OUTER JOIN avUser AS TargetUser ON avPaymentCredit.userID = TargetUser.userID
			LEFT OUTER JOIN avCompany AS TargetCompany ON avPaymentCredit.companyID = TargetCompany.companyID
			LEFT OUTER JOIN avSubscriber ON avPaymentCredit.subscriberID = avSubscriber.subscriberID
		WHERE avPaymentCredit.paymentCreditID IN (<cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectPaymentCredit>
</cffunction>

<cffunction Name="checkPaymentCreditPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for payment credit">
	<cfargument Name="paymentCreditID" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">

	<cfset var qry_checkPaymentCreditPermission = QueryNew("blank")>

	<cfquery Name="qry_checkPaymentCreditPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID_author, userID, companyID
		FROM avPaymentCredit
		WHERE paymentCreditID = <cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer">
			AND companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkPaymentCreditPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectPaymentCreditList" Access="public" ReturnType="query" Hint="Select list of payment credits">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="paymentCreditID" Type="string" Required="No">
	<cfargument Name="paymentCreditID_not" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="userID_approved" Type="string" Required="No">
	<cfargument Name="paymentCreditStatus" Type="numeric" Required="No">
	<cfargument Name="paymentCreditName" Type="string" Required="No">
	<cfargument Name="paymentCreditHasName" Type="numeric" Required="No">
	<cfargument Name="paymentCreditID_custom" Type="string" Required="No">
	<cfargument Name="paymentCreditHasCustomID" Type="numeric" Required="No">
	<cfargument Name="paymentCreditDescription" Type="string" Required="No">
	<cfargument Name="paymentCreditHasDescription" Type="numeric" Required="No">
	<cfargument Name="paymentCreditApplied" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAmount" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAmount_min" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAmount_max" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedMaximum" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedMaximum_min" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedMaximum_max" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedCount" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedCount_min" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedCount_max" Type="numeric" Required="No">
	<cfargument Name="paymentCreditDateBegin" Type="date" Required="No">
	<cfargument Name="paymentCreditDateBegin_from" Type="date" Required="No">
	<cfargument Name="paymentCreditDateBegin_to" Type="date" Required="No">
	<cfargument Name="paymentCreditDateEnd" Type="date" Required="No">
	<cfargument Name="paymentCreditDateEnd_from" Type="date" Required="No">
	<cfargument Name="paymentCreditDateEnd_to" Type="date" Required="No">
	<cfargument Name="paymentCreditDateCreated_from" Type="date" Required="No">
	<cfargument Name="paymentCreditDateCreated_to" Type="date" Required="No">
	<cfargument Name="paymentCreditDateUpdated_from" Type="date" Required="No">
	<cfargument Name="paymentCreditDateUpdated_to" Type="date" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="paymentCreditHasBeginDate" Type="numeric" Required="No">
	<cfargument Name="paymentCreditHasEndDate" Type="numeric" Required="No">
	<cfargument Name="paymentCreditDateType" Type="string" Required="No">
	<cfargument Name="paymentCreditDateFrom" Type="date" Required="No">
	<cfargument Name="paymentCreditDateTo" Type="date" Required="No">
	<cfargument Name="paymentCreditAppliedMaximumMultiple" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedCountMultiple" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedRemaining" Type="numeric" Required="No">
	<cfargument Name="paymentCategoryID" Type="string" Required="No">
	<cfargument Name="paymentCreditRollover" Type="numeric" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="paymentCreditCompleted" Type="numeric" Required="No">
	<cfargument Name="paymentCreditHasRolledOver" Type="numeric" Required="No">
	<!--- creditCardType,group,company status,subscriber status --->
	<cfargument Name="paymentCreditIsExported" Type="string" Required="No">
	<cfargument Name="paymentCreditDateExported_from" Type="string" Required="No">
	<cfargument Name="paymentCreditDateExported_to" Type="string" Required="No">
	<cfargument Name="paymentCreditNegativeInvoice" Type="numeric" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="no" default="paymentCreditID">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">

	<cfset var queryParameters_orderBy = "avPaymentCredit.paymentCreditID">
	<cfset var queryParameters_orderBy_noTable = "paymentCreditID">
	<cfset var displayOr = False>
	<cfset var paymentCreditDateClause = "">
	<cfset var qry_selectPaymentCreditList = QueryNew("blank")>

	<cfswitch expression="#Arguments.queryOrderBy#">
	 <cfcase value="paymentCreditID,paymentCreditAmount,paymentCreditDateUpdated,userID,companyID,paymentCreditStatus,paymentCreditDescription,paymentCreditDateBegin,paymentCreditDateEnd,paymentCreditAppliedMaximum,paymentCreditAppliedCount,paymentCategoryID,subscriberID,paymentCreditRollover,paymentCreditNegativeInvoice">
	 	<cfset queryParameters_orderBy = "avPaymentCredit.#Arguments.queryOrderBy#">
	 </cfcase>
	 <cfcase value="paymentCreditID_d,paymentCreditAmount_d,paymentCreditDateUpdated_d,userID_d,companyID_d,paymentCreditStatus_d,paymentCreditDescription_d,paymentCreditDateBegin_d,paymentCreditDateEnd_d,paymentCreditAppliedMaximum_d,paymentCreditAppliedCount_d,paymentCategoryID_d,subscriberID_d,paymentCreditRollover_d,paymentCreditNegativeInvoice_d">
	 	<cfset queryParameters_orderBy = "avPaymentCredit.#ListFirst(Arguments.queryOrderBy, '_')# DESC">
	 </cfcase>
	 <cfcase value="paymentCreditID_custom"><cfset queryParameters_orderBy = "avPaymentCredit.paymentCreditID_custom"></cfcase>
	 <cfcase value="paymentCreditID_custom_d"><cfset queryParameters_orderBy = "avPaymentCredit.paymentCreditID_custom DESC"></cfcase>
	 <cfcase value="paymentCreditDateCreated"><cfset queryParameters_orderBy = "avPaymentCredit.paymentCreditID"></cfcase>
	 <cfcase value="paymentCreditDateCreated_d"><cfset queryParameters_orderBy = "avPaymentCredit.paymentCreditID DESC"></cfcase>
	 <cfcase value="userID_author"><cfset queryParameters_orderBy = "avPaymentCredit.userID_author"></cfcase>
	 <cfcase value="userID_author_d"><cfset queryParameters_orderBy = "avPaymentCredit.userID_author DESC"></cfcase>
	 <cfcase value="authorLastName"><cfset queryParameters_orderBy = "AuthorUser.authorLastName, AuthorUser.authorFirstName"></cfcase>
	 <cfcase value="authorLastName_d"><cfset queryParameters_orderBy = "AuthorUser.authorLastName DESC, AuthorUser.authorFirstName DESC"></cfcase>
	 <cfcase value="targetLastName"><cfset queryParameters_orderBy = "TargetUser.targetLastName, TargetUser.targetFirstName"></cfcase>
	 <cfcase value="targetLastName_d"><cfset queryParameters_orderBy = "TargetUser.targetLastName DESC, TargetUser.targetFirstName DESC"></cfcase>
	 <cfcase value="targetCompanyName"><cfset queryParameters_orderBy = "TargetCompany.targetCompanyName, avSubscriber.subscriberName"></cfcase>
	 <cfcase value="targetCompanyName_d"><cfset queryParameters_orderBy = "TargetCompany.targetCompanyName DESC, avSubscriber.subscriberName DESC"></cfcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avUser,avCompany,avPaymentCredit">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectPaymentCreditList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avPaymentCredit.paymentCreditID, avPaymentCredit.userID, avPaymentCredit.companyID, avPaymentCredit.userID_author,
			avPaymentCredit.companyID_author, avPaymentCredit.paymentCreditAmount, avPaymentCredit.paymentCreditStatus,
			avPaymentCredit.paymentCreditName, avPaymentCredit.paymentCreditID_custom, avPaymentCredit.paymentCreditDescription,
			avPaymentCredit.paymentCreditDateBegin, avPaymentCredit.paymentCreditDateEnd, avPaymentCredit.paymentCreditAppliedMaximum,
			avPaymentCredit.paymentCreditAppliedCount, avPaymentCredit.paymentCategoryID, avPaymentCredit.paymentCreditRollover,
			avPaymentCredit.paymentCreditNegativeInvoice, avPaymentCredit.subscriberID, avPaymentCredit.paymentCreditCompleted,
			avPaymentCredit.paymentCreditDateCreated, avPaymentCredit.paymentCreditDateUpdated,
			avPaymentCredit.paymentCreditIsExported, avPaymentCredit.paymentCreditDateExported,
			AuthorUser.firstName AS authorFirstName, AuthorUser.lastName AS authorLastName, AuthorUser.userID_custom AS authorUserID_custom,
			TargetUser.firstName AS targetFirstName, TargetUser.lastName AS targetLastName, TargetUser.userID_custom AS targetUserID_custom,
			TargetCompany.companyName AS targetCompanyName, TargetCompany.companyID_custom AS targetCompanyID_custom,
			avSubscriber.subscriberName, avSubscriber.subscriberID_custom
			<!--- , avPaymentCategory.paymentCategoryName --->
		FROM avPaymentCredit
			LEFT OUTER JOIN avUser AS AuthorUser ON avPaymentCredit.userID_author = AuthorUser.userID
			LEFT OUTER JOIN avUser AS TargetUser ON avPaymentCredit.userID = TargetUser.userID
			LEFT OUTER JOIN avCompany AS TargetCompany ON avPaymentCredit.companyID = TargetCompany.companyID
			LEFT OUTER JOIN avSubscriber ON avPaymentCredit.subscriberID = avSubscriber.subscriberID
			<!--- LEFT OUTER JOIN avPaymentCategory ON avPayment.paymentCategoryID = avPaymentCategory.paymentCategoryID --->
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectPaymentCreditList.cfm">
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectPaymentCreditList>
</cffunction>

<cffunction Name="selectPaymentCreditCount" Access="public" ReturnType="numeric" Hint="Select total number of payment credits in list">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="paymentCreditID" Type="string" Required="No">
	<cfargument Name="paymentCreditID_not" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="userID_approved" Type="string" Required="No">
	<cfargument Name="paymentCreditStatus" Type="numeric" Required="No">
	<cfargument Name="paymentCreditName" Type="string" Required="No">
	<cfargument Name="paymentCreditHasName" Type="numeric" Required="No">
	<cfargument Name="paymentCreditID_custom" Type="string" Required="No">
	<cfargument Name="paymentCreditHasCustomID" Type="numeric" Required="No">
	<cfargument Name="paymentCreditDescription" Type="string" Required="No">
	<cfargument Name="paymentCreditHasDescription" Type="numeric" Required="No">
	<cfargument Name="paymentCreditApplied" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAmount" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAmount_min" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAmount_max" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedMaximum" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedMaximum_min" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedMaximum_max" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedCount" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedCount_min" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedCount_max" Type="numeric" Required="No">
	<cfargument Name="paymentCreditDateBegin" Type="date" Required="No">
	<cfargument Name="paymentCreditDateBegin_from" Type="date" Required="No">
	<cfargument Name="paymentCreditDateBegin_to" Type="date" Required="No">
	<cfargument Name="paymentCreditDateEnd" Type="date" Required="No">
	<cfargument Name="paymentCreditDateEnd_from" Type="date" Required="No">
	<cfargument Name="paymentCreditDateEnd_to" Type="date" Required="No">
	<cfargument Name="paymentCreditDateCreated_from" Type="date" Required="No">
	<cfargument Name="paymentCreditDateCreated_to" Type="date" Required="No">
	<cfargument Name="paymentCreditDateUpdated_from" Type="date" Required="No">
	<cfargument Name="paymentCreditDateUpdated_to" Type="date" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="paymentCreditHasBeginDate" Type="numeric" Required="No">
	<cfargument Name="paymentCreditHasEndDate" Type="numeric" Required="No">
	<cfargument Name="paymentCreditDateType" Type="string" Required="No">
	<cfargument Name="paymentCreditDateFrom" Type="date" Required="No">
	<cfargument Name="paymentCreditDateTo" Type="date" Required="No">
	<cfargument Name="paymentCreditAppliedMaximumMultiple" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedCountMultiple" Type="numeric" Required="No">
	<cfargument Name="paymentCreditAppliedRemaining" Type="numeric" Required="No">
	<cfargument Name="paymentCategoryID" Type="string" Required="No">
	<cfargument Name="paymentCreditRollover" Type="numeric" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="paymentCreditCompleted" Type="numeric" Required="No">
	<cfargument Name="paymentCreditHasRolledOver" Type="numeric" Required="No">
	<!--- creditCardType,group,company status,subscriber status --->
	<cfargument Name="paymentCreditIsExported" Type="string" Required="No">
	<cfargument Name="paymentCreditDateExported_from" Type="string" Required="No">
	<cfargument Name="paymentCreditDateExported_to" Type="string" Required="No">
	<cfargument Name="paymentCreditNegativeInvoice" Type="numeric" Required="No">

	<cfset var displayOr = False>
	<cfset var paymentCreditDateClause = "">
	<cfset var qry_selectPaymentCreditCount = QueryNew("blank")>

	<cfquery Name="qry_selectPaymentCreditCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(paymentCreditID) AS totalRecords
		FROM avPaymentCredit
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectPaymentCreditList.cfm">
	</cfquery>

	<cfreturn qry_selectPaymentCreditCount.totalRecords>
</cffunction>

<cffunction Name="selectPaymentCreditAuthorList" Access="public" ReturnType="query" Hint="Select users who have created a payment credit">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">

	<cfset var qry_selectPaymentCreditAuthorList = QueryNew("blank")>

	<cfquery Name="qry_selectPaymentCreditAuthorList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT DISTINCT(avPaymentCredit.userID_author), avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avUser, avPaymentCredit
		WHERE avUser.userID = avPaymentCredit.userID_author
			AND avPaymentCredit.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
		GROUP BY avPaymentCredit.userID_author, avUser.lastName, avUser.firstName, avUser.userID_custom
		ORDER BY avUser.lastName, avUser.firstName
	</cfquery>

	<cfreturn qry_selectPaymentCreditAuthorList>
</cffunction>

<!--- Update Export Status --->
<cffunction Name="updatePaymentCreditIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether payment credit records have been exported. Returns True.">
	<cfargument Name="paymentCreditID" Type="string" Required="Yes">
	<cfargument Name="paymentCreditIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.paymentCreditID) or (Arguments.paymentCreditIsExported is not "" and Not ListFind("0,1", Arguments.paymentCreditIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updatePaymentCreditIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avPaymentCredit
			SET paymentCreditIsExported = <cfif Not ListFind("0,1", Arguments.paymentCreditIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentCreditIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				paymentCreditDateExported = <cfif Not ListFind("0,1", Arguments.paymentCreditIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE paymentCreditID IN (<cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>

