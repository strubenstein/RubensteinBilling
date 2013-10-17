<cfcomponent DisplayName="NewsletterSubscriber" Hint="Manages creating, updating, viewing and managing newsletter subscribers">

<cffunction name="maxlength_NewsletterSubscriber" access="public" output="no" returnType="struct">
	<cfset var maxlength_NewsletterSubscriber = StructNew()>

	<cfset maxlength_NewsletterSubscriber.newsletterSubscriberEmail = 100>

	<cfreturn maxlength_NewsletterSubscriber>
</cffunction>

<cffunction Name="insertNewsletterSubscriber" Access="public" Output="No" ReturnType="string" Hint="Inserts newsletter subscriber into database and returns whether subscriber is existingUser, existingSubscriber or newSubscriber.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="cobrandID" Type="numeric" Required="No" Default="0">
	<cfargument Name="affiliateID" Type="numeric" Required="No" Default="0">
	<cfargument Name="newsletterSubscriberEmail" Type="string" Required="Yes">
	<cfargument Name="newsletterSubscriberStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="newsletterSubscriberHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="newsletterSubscriberIsExported" Type="string" Required="No" Default="">
	<cfargument Name="newsletterSubscriberDateExported" Type="string" Required="No" Default="">

	<cfset var qry_checkUserNewsletterStatus = checkUserNewsletterStatus(Arguments.companyID_author, Trim(Arguments.newsletterSubscriberEmail))>
	<cfset var qry_selectNewsletterSubscriberList = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.NewsletterSubscriber" method="maxlength_NewsletterSubscriber" returnVariable="maxlength_NewsletterSubscriber" />

	<cfif qry_checkUserNewsletterStatus.RecordCount is not 0><!--- update existing user --->
		<cfloop Query="qry_checkUserNewsletterStatus">
			<cfinvoke Component="#Application.billingMapping#data.User" Method="updateUser" ReturnVariable="isUserUpdated">
				<cfinvokeargument Name="userID" Value="#qry_checkUserNewsletterStatus.userID#">
				<cfinvokeargument Name="userNewsletterStatus" Value="#Arguments.newsletterSubscriberStatus#">
				<cfinvokeargument Name="userNewsletterHtml" Value="#Arguments.newsletterSubscriberHtml#">
			</cfinvoke>
		</cfloop>

		<cfreturn "existingUser">

	<cfelse><!--- check if new or existing subscriber --->
		<cfinvoke component="#Application.billingMapping#data.NewsletterSubscriber" method="selectNewsletterSubscriberList" returnVariable="qry_selectNewsletterSubscriberList">
			<cfinvokeargument name="companyID_author" value="#Arguments.companyID_author#">
			<cfinvokeargument name="newsletterSubscriberEmail" value="#Arguments.newsletterSubscriberEmail#">
		</cfinvoke>

		<cfif qry_selectNewsletterSubscriberList.RecordCount is not 0><!--- update existing subscriber --->
			<cfset updateNewsletterSubscriber(Arguments.companyID_author, qry_selectNewsletterSubscriberList.newsletterSubscriberID, Arguments.newsletterSubscriberStatus, Arguments.newsletterSubscriberHtml)>
			<cfreturn "existingSubscriber">
		<cfelse><!--- insert new subscriber --->
			<cfquery Name="qry_insertNewsletterSubscriber" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				INSERT INTO avNewsletterSubscriber
				(
					companyID_author, newsletterSubscriberEmail, newsletterSubscriberStatus, newsletterSubscriberHtml,
					userID, cobrandID, affiliateID, newsletterSubscriberIsExported, newsletterSubscriberDateExported,
					newsletterSubscriberDateCreated, newsletterSubscriberDateUpdated
				)
				VALUES
				(
					<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#Trim(Arguments.newsletterSubscriberEmail)#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_NewsletterSubscriber.newsletterSubscriberEmail#">,
					<cfqueryparam Value="#Arguments.newsletterSubscriberStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					<cfqueryparam Value="#Arguments.newsletterSubscriberHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer">,
					<cfif Not ListFind("0,1", Arguments.newsletterSubscriberIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.newsletterSubscriberIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
					<cfif Not IsDate(Arguments.newsletterSubscriberDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.newsletterSubscriberDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
					#Application.billingSql.sql_nowDateTime#,
					#Application.billingSql.sql_nowDateTime#
				)
			</cfquery>

			<cfreturn "newSubscriber">
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="updateNewsletterSubscriber" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing newsletter subscriber. Returns True.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="newsletterSubscriberID" Type="numeric" Required="No">
	<cfargument Name="newsletterSubscriberStatus" Type="numeric" Required="No">
	<cfargument Name="newsletterSubscriberHtml" Type="numeric" Required="No">
	<cfargument Name="newsletterSubscriberEmail" Type="string" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="numeric" Required="No">
	<cfargument Name="affiliateID" Type="numeric" Required="No">
	<cfargument Name="newsletterSubscriberIsExported" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberDateExported" Type="string" Required="No">

	<cfif Not IsDefined("maxlength_NewsletterSubscriber")>
		<cfinvoke component="#Application.billingMapping#data.NewsletterSubscriber" method="maxlength_NewsletterSubscriber" returnVariable="maxlength_NewsletterSubscriber" />
	</cfif>

	<cfquery Name="qry_updateNewsletterSubscriber" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avNewsletterSubscriber
		SET
			<cfif StructKeyExists(Arguments, "newsletterSubscriberStatus") and ListFind("0,1", Arguments.newsletterSubscriberStatus)>newsletterSubscriberStatus = <cfqueryparam Value="#Arguments.newsletterSubscriberStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "newsletterSubscriberHtml") and ListFind("0,1", Arguments.newsletterSubscriberHtml)>newsletterSubscriberHtml = <cfqueryparam Value="#Arguments.newsletterSubscriberHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerNonNegative(Arguments.cobrandID)>cobrandID = <cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerNonNegative(Arguments.affiliateID)>affiliateID = <cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "newsletterSubscriberIsExported") and (Arguments.newsletterSubscriberIsExported is "" or ListFind("0,1", Arguments.newsletterSubscriberIsExported))>newsletterSubscriberIsExported = <cfif Not ListFind("0,1", Arguments.newsletterSubscriberIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.newsletterSubscriberIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "newsletterSubscriberDateExported") and (Arguments.newsletterSubscriberDateExported is "" or IsDate(Arguments.newsletterSubscriberDateExported))>newsletterSubscriberDateExported = <cfif Not IsDate(Arguments.newsletterSubscriberDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.newsletterSubscriberDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			newsletterSubscriberDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "newsletterSubscriberID") and Application.fn_IsIntegerNonNegative(Arguments.newsletterSubscriberID)>
				AND newsletterSubscriberID = <cfqueryparam Value="#Arguments.newsletterSubscriberID#" cfsqltype="cf_sql_integer">
			<cfelseif StructKeyExists(Arguments, "newsletterSubscriberEmail") and Trim(Arguments.newsletterSubscriberEmail) is not "">
				AND newsletterSubscriberEmail = <cfqueryparam Value="#Arguments.newsletterSubscriberEmail#" cfsqltype="cf_sql_varchar">
			<cfelse>
				AND newsletterSubscriberID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkNewsletterSubscriberPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that company has permission for existing newsletter subscriber">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="newsletterSubscriberID" Type="numeric" Required="Yes">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">

	<cfset var qry_checkNewsletterSubscriberPermission = QueryNew("blank")>

	<cfquery Name="qry_checkNewsletterSubscriberPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT newsletterSubscriberID
		FROM avNewsletterSubscriber
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND newsletterSubscriberID = <cfqueryparam Value="#Arguments.newsletterSubscriberID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)
					and StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>
				AND (cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					OR affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
			<cfelseif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>
				AND cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfelseif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>
				AND affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
	</cfquery>

	<cfif qry_checkNewsletterSubscriberPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="deleteNewsletterSubscriber" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing newsletter subscriber">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="newsletterSubscriberID" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberEmail" Type="string" Required="No">

	<cfquery Name="qry_deleteNewsletterSubscriber" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avNewsletterSubscriber
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "newsletterSubscriberID") and Application.fn_IsIntegerNonNegative(Arguments.newsletterSubscriberID)>
				AND newsletterSubscriberID = <cfqueryparam Value="#Arguments.newsletterSubscriberID#" cfsqltype="cf_sql_integer">
			<cfelseif StructKeyExists(Arguments, "newsletterSubscriberEmail") and Trim(Arguments.newsletterSubscriberEmail) is not "">
				AND newsletterSubscriberEmail = <cfqueryparam Value="#Arguments.newsletterSubscriberEmail#" cfsqltype="cf_sql_varchar">
			<cfelse>
				AND newsletterSubscriberID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectNewsletterSubscriber" Access="public" Output="No" ReturnType="query" Hint="Select existing newsletter subscriber">
	<cfargument Name="newsletterSubscriberID" Type="numeric" Required="No">

	<cfset var qry_selectNewsletterSubscriber = QueryNew("blank")>

	<cfquery Name="qry_selectNewsletterSubscriber" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT newsletterSubscriberID, newsletterSubscriberEmail, userID, cobrandID, newsletterSubscriberStatus, affiliateID, newsletterSubscriberHtml, 
			newsletterSubscriberIsExported, newsletterSubscriberDateExported, newsletterSubscriberDateCreated, newsletterSubscriberDateUpdated
		FROM avNewsletterSubscriber
		WHERE newsletterSubscriberID = <cfqueryparam Value="#Arguments.newsletterSubscriberID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectNewsletterSubscriber>
</cffunction>

<cffunction Name="checkUserNewsletterStatus" Access="public" Output="No" ReturnType="query" Hint="Select existing registered user with same email as newsletter subscriber">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="email" Type="string" Required="Yes">

	<cfset var qry_checkUserNewsletterStatus = QueryNew("blank")>

	<cfquery Name="qry_checkUserNewsletterStatus" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUser.userID, avUser.userNewsletterStatus, avUser.userNewsletterHtml, avUser.email
		FROM avUser, avCompany
		WHERE avUser.companyID = avCompany.companyID
			AND avCompany.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND avUser.email = <cfqueryparam Value="#Arguments.email#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfreturn qry_checkUserNewsletterStatus>
</cffunction>

<cffunction name="selectNewsletterSubscriberList" access="public" output="no" returnType="query" hint="Selects existing newsletter subscribers">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="newsletterSubscriberID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberStatus" Type="numeric" Required="No">
	<cfargument Name="newsletterSubscriberHtml" Type="numeric" Required="No">
	<cfargument Name="newsletterSubscriberEmail" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberDateCreated_from" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberDateCreated_to" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberDateUpdated_from" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberDateUpdated_to" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberDateType" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberDateFrom" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberDateTo" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberRegistered" Type="numeric" Required="No">
	<cfargument Name="newsletterSubscriberIsExported" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberDateExported_from" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberDateExported_to" Type="string" Required="No">
	<!--- user parameters --->
	<cfargument Name="userNewsletterStatus" Type="numeric" Required="No">
	<cfargument Name="userNewsletterHtml" Type="numeric" Required="No">
	<cfargument Name="email" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="companyHasMultipleUsers" Type="numeric" Required="No">
	<cfargument Name="userIsInMyCompany" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomID" Type="numeric" Required="No">
	<cfargument Name="userHasCustomID" Type="numeric" Required="No">
	<!--- general parameters --->
	<cfargument Name="queryOrderBy" Type="string" Required="No" default="newsletterSubscriberID_d">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="returnNewsletterSubscribers" Type="boolean" Required="No" default="True">
	<cfargument Name="returnUsers" Type="boolean" Required="No" default="True">

	<cfset var queryParameters_orderBy = "avNewsletterSubscriber.newsletterSubscriberID DESC">
	<cfset var queryParameters_orderBy_noTable = "newsletterSubscriberID DESC">
	<cfset var qry_selectNewsletterSubscriberList = QueryNew("blank")>
	<cfset var queryDateField = "">
	<cfset var isFirstDate = True>

	<cfswitch expression="#Arguments.queryOrderBy#">
	 <cfcase value="newsletterSubscriberID,newsletterSubscriberEmail,newsletterSubscriberDateExported,newsletterSubscriberDateUpdated,cobrandID,affiliateID"><cfset queryParameters_orderBy = "avNewsletterSubscriber.#Arguments.queryOrderBy#"></cfcase>
	 <cfcase value="newsletterSubscriberID_d,newsletterSubscriberEmail_d,newsletterSubscriberDateExported_d,newsletterSubscriberDateUpdated_d,cobrandID_d,affiliateID_d"><cfset queryParameters_orderBy = "avNewsletterSubscriber.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	 <cfcase value="newsletterSubscriberStatus"><cfset queryParameters_orderBy = "avNewsletterSubscriber.newsletterSubscriberStatus DESC, avNewsletterSubscriber.newsletterSubscriberID DESC"></cfcase>
	 <cfcase value="newsletterSubscriberStatus_d"><cfset queryParameters_orderBy = "avNewsletterSubscriber.newsletterSubscriberStatus, avNewsletterSubscriber.newsletterSubscriberID DESC"></cfcase>
	 <cfcase value="newsletterSubscriberDateCreated"><cfset queryParameters_orderBy = "avNewsletterSubscriber.newsletterSubscriberID"></cfcase>
	 <cfcase value="newsletterSubscriberDateCreated_d"><cfset queryParameters_orderBy = "avNewsletterSubscriber.newsletterSubscriberID DESC"></cfcase>
	 <cfcase value="email"><cfset queryParameters_orderBy = "newsletterSubscriberEmail"></cfcase>
	 <cfcase value="email_d"><cfset queryParameters_orderBy = "newsletterSubscriberEmail DESC"></cfcase>
	 <cfcase value="dateSubscribed"><cfset queryParameters_orderBy = "newsletterSubscriberDateCreated"></cfcase>
	 <cfcase value="dateSubscribed_d"><cfset queryParameters_orderBy = "newsletterSubscriberDateCreated DESC"></cfcase>
	 <cfcase value="html"><cfset queryParameters_orderBy = "newsletterSubscriberHtml DESC"></cfcase>
	 <cfcase value="html_d"><cfset queryParameters_orderBy = "newsletterSubscriberHtml"></cfcase>
	 <cfcase value="status"><cfset queryParameters_orderBy = "newsletterSubscriberStatus DESC"></cfcase>
	 <cfcase value="status_d"><cfset queryParameters_orderBy = "newsletterSubscriberStatus"></cfcase>
	 <cfcase value="lastName"><cfset queryParameters_orderBy = "lastName, firstName"></cfcase>
	 <cfcase value="lastName_d"><cfset queryParameters_orderBy = "lastName DESC, firstName DESC"></cfcase>
	 <cfcase value="companyName"><cfset queryParameters_orderBy = "companyName"></cfcase>
	 <cfcase value="companyName_d"><cfset queryParameters_orderBy = "companyName DESC"></cfcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avUser,avCompany,avNewsletterSubscriber">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectNewsletterSubscriberList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif Arguments.returnNewsletterSubscribers is True>
			SELECT 
				<cfif Application.billingDatabase is "MSSQLServer">
					* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
				</cfif>
				avNewsletterSubscriber.newsletterSubscriberID, avNewsletterSubscriber.newsletterSubscriberEmail,
				avNewsletterSubscriber.newsletterSubscriberStatus, avNewsletterSubscriber.newsletterSubscriberHtml,
				avNewsletterSubscriber.cobrandID, avNewsletterSubscriber.affiliateID,
				avNewsletterSubscriber.userID, avNewsletterSubscriber.newsletterSubscriberDateCreated,
				avNewsletterSubscriber.newsletterSubscriberIsExported, avNewsletterSubscriber.newsletterSubscriberDateExported,
				NULL AS firstName, NULL AS lastName, NULL as userID_custom,
				0 AS companyID, NULL AS companyName, NULL as companyID_custom
			FROM avNewsletterSubscriber
			WHERE 
				<cfinclude template="dataShared/qryWhere_selectNewsletterSubscriberList.cfm">
		</cfif>
		<cfif Arguments.returnNewsletterSubscribers is True and Arguments.returnUsers is True>
			UNION
		</cfif>
		<cfif Arguments.returnUsers is True>
			SELECT 
				<cfif Application.billingDatabase is "MSSQLServer">
					* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
				</cfif>
				0 AS newsletterSubscriberID, avUser.email AS newsletterSubscriberEmail,
				avUser.userNewsletterStatus AS newsletterSubscriberStatus, avUser.userNewsletterHtml AS newsletterSubscriberHtml,
				avCompany.cobrandID, avCompany.affiliateID,
				avUser.userID, avUser.userDateCreated AS newsletterSubscriberDateCreated,
				NULL AS newsletterSubscriberIsExported, NULL AS newsletterSubscriberDateExported,
				avUser.firstName, avUser.lastName, avUser.userID_custom,
				avCompany.companyID, avCompany.companyName, avCompany.companyID_custom
			FROM avUser, avCompany
			WHERE avUser.companyID = avCompany.companyID
				AND <cfinclude template="dataShared/qryWhere_selectNewsletterSubscriberList_user.cfm">
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

	<cfreturn qry_selectNewsletterSubscriberList>
</cffunction>

<cffunction Name="selectNewsletterSubscriberCount" Access="public" ReturnType="numeric" Hint="Select total number of newsletter subscribers in list.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="newsletterSubscriberID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberStatus" Type="numeric" Required="No">
	<cfargument Name="newsletterSubscriberHtml" Type="numeric" Required="No">
	<cfargument Name="newsletterSubscriberEmail" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberDateCreated_from" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberDateCreated_to" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberDateUpdated_from" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberDateUpdated_to" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberDateType" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberDateFrom" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberDateTo" Type="date" Required="No">
	<cfargument Name="newsletterSubscriberRegistered" Type="numeric" Required="No">
	<cfargument Name="newsletterSubscriberIsExported" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberDateExported_from" Type="string" Required="No">
	<cfargument Name="newsletterSubscriberDateExported_to" Type="string" Required="No">
	<!--- user parameters --->
	<cfargument Name="userNewsletterStatus" Type="numeric" Required="No">
	<cfargument Name="userNewsletterHtml" Type="numeric" Required="No">
	<cfargument Name="email" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="companyHasMultipleUsers" Type="numeric" Required="No">
	<cfargument Name="userIsInMyCompany" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomID" Type="numeric" Required="No">
	<cfargument Name="userHasCustomID" Type="numeric" Required="No">
	<!--- general parameters --->
	<cfargument Name="returnNewsletterSubscribers" Type="boolean" Required="No" default="True">
	<cfargument Name="returnUsers" Type="boolean" Required="No" default="True">

	<cfset var totalCount = 0>
	<cfset var qry_selectNewsletterSubscriberCount = QueryNew("blank")>
	<cfset var queryDateField = "">
	<cfset var isFirstDate = True>

	<cfquery Name="qry_selectNewsletterSubscriberCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif Arguments.returnNewsletterSubscribers is True>
			SELECT COUNT(newsletterSubscriberID) AS totalRecords
			FROM avNewsletterSubscriber
			WHERE 
				<cfinclude template="dataShared/qryWhere_selectNewsletterSubscriberList.cfm">
		</cfif>
		<cfif Arguments.returnNewsletterSubscribers is True and Arguments.returnUsers is True>
			UNION
		</cfif>
		<cfif Arguments.returnUsers is True>
			SELECT COUNT(avUser.userID) AS totalRecords
			FROM avUser, avCompany
			WHERE avUser.companyID = avCompany.companyID
				AND <cfinclude template="dataShared/qryWhere_selectNewsletterSubscriberList_user.cfm">
		</cfif>
	</cfquery>

	<cfloop Query="qry_selectNewsletterSubscriberCount">
		<cfset totalCount = totalCount + qry_selectNewsletterSubscriberCount.totalRecords>
	</cfloop>

	<cfreturn totalCount>
</cffunction>

<!--- Update Export Status --->
<cffunction Name="updateNewsletterSubscriberIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether newsletter subscriber records have been exported. Returns True.">
	<cfargument Name="newsletterSubscriberID" Type="string" Required="Yes">
	<cfargument Name="newsletterSubscriberIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.newsletterSubscriberID) or (Arguments.newsletterSubscriberIsExported is not "" and Not ListFind("0,1", Arguments.newsletterSubscriberIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateNewsletterSubscriberIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avNewsletterSubscriber
			SET newsletterSubscriberIsExported = <cfif Not ListFind("0,1", Arguments.newsletterSubscriberIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.newsletterSubscriberIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				newsletterSubscriberDateExported = <cfif Not ListFind("0,1", Arguments.newsletterSubscriberIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE newsletterSubscriberID IN (<cfqueryparam Value="#Arguments.newsletterSubscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>

