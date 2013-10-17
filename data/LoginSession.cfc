<cfcomponent displayName="LoginSession" hint="Manages queries for LoginSession table">

<cffunction name="insertLoginSession" access="public" output="no" returnType="numeric" hint="Inserts new session record and returns loginSessionID">
	<cfargument name="userID" type="numeric" required="Yes">

	<cfset var qry_insertLoginSession = QueryNew("blank")>

	<cfquery Name="qry_insertLoginSession" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avLoginSession
		SET loginSessionCurrent = 0
		WHERE userID = <cfqueryparam value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			AND loginSessionCurrent = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;

		INSERT INTO avLoginSession (userID, loginSessionDateBegin, loginSessionDateEnd, loginSessionTimeout, loginSessionCurrent)
		VALUES
		(
			<cfqueryparam value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			NULL,
			<cfqueryparam value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "loginSessionID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertLoginSession.primaryKeyID>
</cffunction>

<cffunction name="updateLoginSession" access="public" output="no" returnType="boolean">
	<cfargument name="loginSessionID" type="numeric" required="Yes">
	<cfargument name="loginSessionDateEnd" type="string" required="No">
	<cfargument name="loginSessionTimeout" type="numeric" required="No">
	<cfargument name="loginSessionCurrent" type="numeric" required="No">

	<cfquery Name="qry_updateLoginSession" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avLoginSession
		SET <cfif StructKeyExists(Arguments, "loginSessionDateEnd")>loginSessionDateEnd = <cfif Not IsDate(Arguments.loginSessionDateEnd)>NULL<cfelse><cfqueryparam value="#CreateODBCDateTime(Arguments.loginSessionDateEnd)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfloop index="field" list="loginSessionTimeout,loginSessionCurrent"><cfif StructKeyExists(Arguments, field)>#field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif></cfloop>
			userID = userID
		WHERE loginSessionID = <cfqueryparam value="#Arguments.loginSessionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction name="updateLoginSessionDateEnd" access="public" output="no" returnType="boolean">
	<cfargument name="userID" type="numeric" required="No">
	<cfargument name="loginSessionID" type="numeric" required="No" default="0">
	<cfargument name="loginSessionTimeout" type="numeric" required="No" default="0">

	<cfquery Name="qry_updateLoginSessionDateEnd" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avLoginSession
		SET loginSessionDateEnd = GetDate(),
			loginSessionTimeout = <cfqueryparam value="#Arguments.loginSessionTimeout#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE loginSessionDateEnd IS NULL
			AND loginSessionCurrent = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerPositive(Arguments.userID)>
				AND userID = <cfqueryparam value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(Arguments, "loginSessionID") and Arguments.loginSessionID is not 0>
				AND loginSessionID = <cfqueryparam value="#Arguments.loginSessionID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction name="selectLoginSession" access="public" output="no" returnType="query">
	<cfargument name="loginSessionID" type="numeric" required="Yes">

	<cfset var qry_selectLoginSession = QueryNew("blank")>

	<cfquery Name="qry_selectLoginSession" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT loginSessionID, userID, loginSessionDateBegin, loginSessionDateEnd, loginSessionTimeout, loginSessionCurrent
		FROM avLoginSession
		WHERE loginSessionID = <cfqueryparam value="#Arguments.loginSessionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectLoginSession>
</cffunction>

<cffunction name="selectLoginSessionList" access="public" output="no" returnType="query">
	<cfargument name="loginSessionID" type="string" required="no">
	<cfargument name="userID" type="string" required="no">
	<cfargument name="companyID" type="string" required="no">
	<cfargument name="loginSessionTimeout" type="string" required="no">
	<cfargument name="loginSessionCurrent" type="string" required="no">
	<cfargument name="loginSessionDateBegin_from" type="date" required="no">
	<cfargument name="loginSessionDateBegin_to" type="date" required="no">
	<cfargument name="loginSessionDateEndIsNull" type="boolean" required="no">
	<cfargument name="returnUserInfo" type="boolean" required="no" default="False">

	<cfset var qry_selectLoginSessionList = QueryNew("blank")>

	<cfif Arguments.returnUserInfo is False and (StructKeyExists(Arguments, "companyID") or StructKeyExists(Arguments, "userType"))>
		<cfset Arguments.returnUserInfo = True>
	</cfif>

	<cfquery Name="qry_selectLoginSessionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avLoginSession.loginSessionID, avLoginSession.userID, avLoginSession.loginSessionDateBegin, avLoginSession.loginSessionDateEnd,
			avLoginSession.loginSessionTimeout, avLoginSession.loginSessionCurrent
			<cfif Arguments.returnUserInfo is True>, avUser.username, avUser.firstName, avUser.lastName, avUser.email</cfif>
		FROM avLoginSession
			<cfif Arguments.returnUserInfo is True>INNER JOIN avUser ON avLoginSession.userID = avUser.userID</cfif>
		WHERE avLoginSession.loginSessionID <> 0
			<cfloop index="field" list="loginSessionID,userID"><cfif StructKeyExists(Arguments, field)> AND avLoginSession.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
			<cfloop index="field" list="loginSessionTimeout,loginSessionCurrent"><cfif StructKeyExists(Arguments, field)> AND avLoginSession.#field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif></cfloop>
			<cfif StructKeyExists(Arguments, "companyID")> AND avUser.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" list="yes">) </cfif>
			<cfif StructKeyExists(Arguments, "loginSessionDateEndIsNull")>AND avLoginSession.loginSessionDateEnd <cfif Arguments.loginSessionDateEndIsNull is True> IS NULL <cfelse> IS NOT NULL </cfif></cfif>
			<cfif StructKeyExists(Arguments, "loginSessionDateBegin_from") and StructKeyExists(Arguments, "loginSessionDateBegin_to")>
				AND avLoginSession.loginSessionDateBegin BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments.loginSessionDateBegin_from)#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments.loginSessionDateBegin_to)#" cfsqltype="cf_sql_timestamp">
			  <cfelseif StructKeyExists(Arguments, "loginSessionDateBegin_from")>
			  	AND avLoginSession.loginSessionDateBegin >= <cfqueryparam value="#CreateODBCDateTime(Arguments.loginSessionDateBegin_from)#" cfsqltype="cf_sql_timestamp">
			  <cfelseif StructKeyExists(Arguments, "loginSessionDateBegin_to")>
			  	AND avLoginSession.loginSessionDateBegin <= <cfqueryparam value="#CreateODBCDateTime(Arguments.loginSessionDateBegin_to)#" cfsqltype="cf_sql_timestamp">
			</cfif>
		ORDER BY <cfif Arguments.returnUserInfo is True>avUser.lastName,<cfelse>avLoginSession.userID,</cfif>
			avLoginSession.loginSessionID DESC
	</cfquery>

	<cfreturn qry_selectLoginSessionList>
</cffunction>

<cffunction name="selectLoginSessionCompanyList" access="public" output="no" returnType="query">
	<cfargument name="companyID" type="numeric" required="no">
	<cfargument name="userStatus" type="numeric" required="no">
	<cfargument name="loginSessionDateBegin_from" type="date" required="no">
	<cfargument name="loginSessionDateBegin_to" type="date" required="no">
	<cfargument name="loginSessionDateEndIsNull" type="boolean" required="no">
	<cfargument name="returnAllUsers" type="boolean" required="no" default="True" hint="If false, do not return users who have never logged in">
	<cfargument name="queryOrderBy" type="string" required="no" default="lastName">

	<cfset var qry_selectLoginSessionCompanyList = QueryNew("blank")>

	<cfquery Name="qry_selectLoginSessionCompanyList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUser.userID, avUser.username, avUser.firstName, avUser.lastName, avUser.email,
			avLoginSession.loginSessionID, avLoginSession.loginSessionDateBegin, avLoginSession.loginSessionDateEnd,
			avLoginSession.loginSessionTimeout, avLoginSession.loginSessionCurrent
		FROM avUser
			<cfif Arguments.returnAllUsers is True>
				LEFT OUTER JOIN avLoginSession ON avUser.userID = avLoginSession.userID
					AND avLoginSession.loginSessionCurrent = 1
			<cfelse>
				INNER JOIN avLoginSession ON avUser.userID = avLoginSession.userID
					AND avLoginSession.loginSessionCurrent = 1
			</cfif>
		WHERE avUser.companyID = <cfqueryparam value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "userStatus") and ListFind("0,1", Arguments.userStatus)>
				AND avUser.userStatus = <cfqueryparam value="#Arguments.userStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "loginSessionDateEndIsNull")>AND avLoginSession.loginSessionDateEnd <cfif Arguments.loginSessionDateEndIsNull is True> IS NULL <cfelse> IS NOT NULL </cfif></cfif>
			<cfif StructKeyExists(Arguments, "loginSessionDateBegin_from") and StructKeyExists(Arguments, "loginSessionDateBegin_to")>
				AND avLoginSession.loginSessionDateBegin BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments.loginSessionDateBegin_from)#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments.loginSessionDateBegin_to)#" cfsqltype="cf_sql_timestamp">
			  <cfelseif StructKeyExists(Arguments, "loginSessionDateBegin_from")>
			  	AND avLoginSession.loginSessionDateBegin >= <cfqueryparam value="#CreateODBCDateTime(Arguments.loginSessionDateBegin_from)#" cfsqltype="cf_sql_timestamp">
			  <cfelseif StructKeyExists(Arguments, "loginSessionDateBegin_to")>
			  	AND avLoginSession.loginSessionDateBegin <= <cfqueryparam value="#CreateODBCDateTime(Arguments.loginSessionDateBegin_to)#" cfsqltype="cf_sql_timestamp">
			</cfif>
		ORDER BY 
			<cfswitch expression="#Arguments.queryOrderBy#">
			<cfcase value="lastName">avUser.lastName, avUser.firstName</cfcase>
			<cfcase value="lastName_d">avUser.lastName DESC, avUser.firstName DESC</cfcase>
			<cfcase value="loginSessionDateBegin">avLoginSession.loginSessionDateBegin, avUser.lastName, avUser.firstName</cfcase>
			<cfcase value="loginSessionDateBegin_d">avLoginSession.loginSessionDateBegin DESC, avUser.lastName, avUser.firstName</cfcase>
			<cfdefaultcase>avUser.lastName, avUser.firstName</cfdefaultcase>
			</cfswitch>
	</cfquery>

	<cfreturn qry_selectLoginSessionCompanyList>
</cffunction>

</cfcomponent>
