<cfcomponent displayName="LoginAttempt" hint="Manages queries for LoginAttempt table">

<cffunction Name="selectLoginAttempt" Access="public" Output="No" ReturnType="query" Hint="Selects existing failed login attempts for a given username.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="loginAttemptUsername" Type="string" Required="Yes">

	<cfset var qry_selectLoginAttempt = QueryNew("blank")>

	<cfquery Name="qry_selectLoginAttempt" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT loginAttemptID, loginAttemptCount, loginAttemptDateCreated, loginAttemptDateUpdated
		FROM avLoginAttempt
		WHERE loginAttemptUsername = <cfqueryparam Value="#Arguments.loginAttemptUsername#" cfsqltype="cf_sql_varchar">
			<cfif Application.fn_IsIntegerPositive(Arguments.companyID_author)>
				AND companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_smallint">
			</cfif>
		ORDER BY loginAttemptID DESC
	</cfquery>

	<cfreturn qry_selectLoginAttempt>
</cffunction>

<cffunction Name="selectLoginAttemptList" Access="public" Output="No" ReturnType="query" Hint="Selects existing failed login attempts for a given company.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">

	<cfset var qry_selectLoginAttemptList = QueryNew("blank")>

	<cfquery Name="qry_selectLoginAttemptList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avLoginAttempt.loginAttemptID, avLoginAttempt.loginAttemptUsername, avLoginAttempt.loginAttemptCount,
			avLoginAttempt.loginAttemptDateCreated, avLoginAttempt.loginAttemptDateUpdated,
			avCompany.companyID, avCompany.companyName, avUser.username, avUser.userID, avUser.firstName,
			avUser.lastName, avUser.userID_custom, avUser.email
		FROM avLoginAttempt
			LEFT OUTER JOIN avCompany ON avLoginAttempt.companyID_author = avCompany.companyID_author AND avCompany.companyPrimary = 1
			LEFT OUTER JOIN avUser ON avCompany.companyID = avUser.companyID AND avLoginAttempt.loginAttemptUsername = avUser.username
		WHERE avLoginAttempt.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_smallint">
		ORDER BY avLoginAttempt.loginAttemptUsername
	</cfquery>

	<cfreturn qry_selectLoginAttemptList>
</cffunction>

<cffunction Name="insertLoginAttempt" Access="public" Output="No" ReturnType="boolean" Hint="Inserts a failed login attempt for a username.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="loginAttemptUsername" Type="string" Required="Yes">

	<cfquery Name="qry_insertLoginAttempt" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avLoginAttempt
		(
			companyID_author, loginAttemptUsername, loginAttemptCount, loginAttemptDateCreated, loginAttemptDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.loginAttemptUsername#" cfsqltype="cf_sql_varchar" Maxlength="255">,
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateLoginAttempt" Access="public" Output="No" ReturnType="boolean" Hint="Increments counter of failed login attempts for a username.">
	<cfargument Name="loginAttemptID" Type="numeric" Required="Yes">

	<cfquery Name="qry_updateLoginAttempt" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avLoginAttempt
		SET loginAttemptCount = loginAttemptCount + <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">,
			loginAttemptDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE loginAttemptID = <cfqueryparam Value="#Arguments.loginAttemptID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="deleteLoginAttempt" Access="public" Output="No" ReturnType="boolean" Hint="Deletes failed login attempt record upon successful login.">
	<cfargument Name="loginAttemptID" Type="numeric" Required="Yes">
	<cfargument Name="loginAttemptUsername" Type="string" Required="No">
	<cfargument Name="companyID_author" Type="numeric" Required="No">

	<cfquery Name="qry_deleteLoginAttempt" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avLoginAttempt
		WHERE loginAttemptID = <cfqueryparam Value="#Arguments.loginAttemptID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "loginAttemptUsername") and Trim(Arguments.loginAttemptUsername) is not ""
					and StructKeyExists(Arguments, "companyID_author") and Application.fn_IsIntegerPositive(Arguments.companyID_author)>
				OR (companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
					AND loginAttemptUsername = <cfqueryparam Value="#Arguments.loginAttemptUsername#" cfsqltype="cf_sql_varchar">)
			</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>