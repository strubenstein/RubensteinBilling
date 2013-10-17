<cfcomponent DisplayName="UserCompany" Hint="Manages creating, updating, viewing and managing company users">

<cffunction Name="insertUserCompany" Access="public" Output="No" ReturnType="boolean" Hint="Insert user to give permission for a company">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userCompanyStatus" Type="numeric" Required="No" Default="1">

	<cfquery Name="qry_insertUserCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avUserCompany (userID, companyID, userCompanyStatus, userCompanyDateCreated, userCompanyDateUpdated)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateUserCompany" Access="public" Output="No" ReturnType="boolean" Hint="Update user permission for a company">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userCompanyStatus" Type="numeric" Required="Yes">

	<cfquery Name="qry_updateUserCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avUserCompany
		SET	userCompanyStatus = <cfqueryparam Value="#Arguments.userCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			userCompanyDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectUserCompanyList_user" Access="public" Output="No" ReturnType="query" Hint="Select companies for which user has permission">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userCompanyStatus" Type="numeric" Required="No">

	<cfset var qry_selectUserCompanyList_user = QueryNew("blank")>

	<cfquery Name="qry_selectUserCompanyList_user" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUserCompany.companyID, avUserCompany.userCompanyStatus, avUserCompany.userCompanyDateCreated, avUserCompany.userCompanyDateUpdated,
			avCompany.companyName, avCompany.companyID_custom, avCompany.companyStatus
		FROM avUserCompany, avCompany
		WHERE avUserCompany.companyID = avCompany.companyID
			AND avUserCompany.userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "userCompanyStatus")>AND avUserCompany.userCompanyStatus = <cfqueryparam Value="#Arguments.userCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		ORDER BY avCompany.companyName
	</cfquery>

	<cfreturn qry_selectUserCompanyList_user>
</cffunction>

<cffunction Name="selectUserCompanyList_company" Access="public" Output="No" ReturnType="query" Hint="Select users which are part of or have permission for this company">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userCompanyStatus" Type="numeric" Required="No">
	<cfargument Name="userIsPrimaryContact" Type="boolean" Required="No" Default="False">
	<cfargument Name="userStatus" Type="numeric" Required="No">

	<cfset var qry_selectUserCompanyList_company = QueryNew("blank")>

	<cfquery Name="qry_selectUserCompanyList_company" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUserCompany.userID, avUserCompany.userCompanyStatus,
			avUserCompany.userCompanyDateCreated, avUserCompany.userCompanyDateUpdated,
			avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom, avUser.userStatus
		FROM avUserCompany, avUser
			<cfif Arguments.userIsPrimaryContact is True>, avCompany</cfif>
		WHERE avUserCompany.userID = avUser.userID
			<cfif Arguments.userIsPrimaryContact is True>
				AND avUserCompany.companyID = avCompany.companyID
				AND avUserCompany.userID = avCompany.userID
			</cfif>
			AND avUserCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "userCompanyStatus") and ListFind("0,1", Arguments.userCompanyStatus)>
				AND avUserCompany.userCompanyStatus = <cfqueryparam Value="#Arguments.userCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "userStatus") and ListFind("0,1", Arguments.userStatus)>
				AND avUser.userStatus = <cfqueryparam value="#Arguments.userStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY avUser.lastName, avUser.firstName
	</cfquery>

	<cfreturn qry_selectUserCompanyList_company>
</cffunction>

</cfcomponent>