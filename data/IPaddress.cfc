<cfcomponent DisplayName="IPaddress" Hint="Manages inserting, updating, deleting and viewing IP addresses company will use for login">

<cffunction name="maxlength_IPaddress" access="public" output="no" returnType="struct">
	<cfset var maxlength_IPaddress = StructNew()>

	<cfset maxlength_IPaddress.IPaddress = 25>
	<cfset maxlength_IPaddress.IPaddress_max = 25>

	<cfreturn maxlength_IPaddress>
</cffunction>

<cffunction Name="insertIPaddress" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new IP address. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="IPaddress" Type="string" Required="Yes">
	<cfargument Name="IPaddress_max" Type="string" Required="No" Default="">
	<cfargument Name="IPaddressBrowser" Type="numeric" Required="No" Default="0">
	<cfargument Name="IPaddressWebService" Type="numeric" Required="No" Default="0">

	<cfinvoke component="#Application.billingMapping#data.IPaddress" method="maxlength_IPaddress" returnVariable="maxlength_IPaddress" />

	<cfquery Name="qry_insertIPaddress" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avIPaddress
		(
			companyID, userID, IPaddress, IPaddress_max, IPaddressBrowser,
			IPaddressWebService, IPaddressDateCreated, IPaddressDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.IPaddress#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_IPaddress.IPaddress#">,
			<cfqueryparam Value="#Arguments.IPaddress_max#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_IPaddress.IPaddress_max#">,
			<cfqueryparam Value="#Arguments.IPaddressBrowser#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.IPaddressWebService#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateIPaddress" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing IP address. Returns True.">
	<cfargument Name="IPaddressID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="IPaddress" Type="string" Required="No">
	<cfargument Name="IPaddress_max" Type="string" Required="No">
	<cfargument Name="IPaddressBrowser" Type="numeric" Required="No">
	<cfargument Name="IPaddressWebService" Type="numeric" Required="No">
	
	<cfinvoke component="#Application.billingMapping#data.IPaddress" method="maxlength_IPaddress" returnVariable="maxlength_IPaddress" />

	<cfquery Name="qry_updateIPaddress" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avIPaddress
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>
				userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif StructKeyExists(Arguments, "IPaddress")>
				IPaddress = <cfqueryparam Value="#Arguments.IPaddress#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_IPaddress.IPaddress#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "IPaddress_max")>
				IPaddress_max = <cfqueryparam Value="#Arguments.IPaddress_max#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_IPaddress.IPaddress_max#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "IPaddressBrowser") and ListFind("0,1", Arguments.IPaddressBrowser)>
				IPaddressBrowser = <cfqueryparam Value="#Arguments.IPaddressBrowser#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "IPaddressWebService") and ListFind("0,1", Arguments.IPaddressWebService)>
				IPaddressWebService = <cfqueryparam Value="#Arguments.IPaddressWebService#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			IPaddressDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE IPaddressID = <cfqueryparam Value="#Arguments.IPaddressID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectIPaddress" Access="public" Output="No" ReturnType="query" Hint="Select existing IP address.">
	<cfargument Name="IPaddressID" Type="numeric" Required="Yes">

	<cfset var qry_selectIPaddress = QueryNew("blank")>

	<cfquery Name="qry_selectIPaddress" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID, userID, IPaddress, IPaddress_max,
			IPaddressBrowser, IPaddressWebService, IPaddressDateCreated, IPaddressDateUpdated
		FROM avIPaddress
		WHERE IPaddressID = <cfqueryparam Value="#Arguments.IPaddressID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectIPaddress>
</cffunction>

<cffunction Name="checkIPaddressPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that company has permission for existing IP address.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="IPaddressID" Type="numeric" Required="Yes">

	<cfset var qry_checkIPaddressPermission = QueryNew("blank")>

	<cfquery Name="qry_checkIPaddressPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID
		FROM avIPaddress
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND IPaddressID = <cfqueryparam Value="#Arguments.IPaddressID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkIPaddressPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectIPaddressList" Access="public" Output="No" ReturnType="query" Hint="Select existing IP addresses.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="IPaddressBrowser" Type="numeric" Required="No">
	<cfargument Name="IPaddressWebService" Type="numeric" Required="No">
	<cfargument Name="IPaddress" Type="string" Required="No">

	<cfset var qry_selectIPaddressList = QueryNew("blank")>

	<cfquery Name="qry_selectIPaddressList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT IPaddressID, companyID, userID, IPaddress, IPaddress_max,
			IPaddressBrowser, IPaddressWebService, IPaddressDateCreated, IPaddressDateUpdated
		FROM avIPaddress
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="IPaddressBrowser,IPaddressWebService">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND #field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "IPaddress") and Trim(Arguments.IPaddress) is not "">
				AND (
					IPaddress = <cfqueryparam Value="#Arguments.IPaddress#" cfsqltype="cf_sql_varchar">
					OR
						(
						IPaddress_max <> ''
						AND IPaddress <= <cfqueryparam Value="#Arguments.IPaddress#" cfsqltype="cf_sql_varchar">
						AND IPaddress_max >= <cfqueryparam Value="#Arguments.IPaddress#" cfsqltype="cf_sql_varchar">
						)
					)
			</cfif>
	</cfquery>

	<cfreturn qry_selectIPaddressList>
</cffunction>

<cffunction Name="deleteIPaddress" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing IP address">
	<cfargument Name="IPaddressID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteIPaddress" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avIPaddress
		WHERE IPaddressID = <cfqueryparam Value="#Arguments.IPaddressID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>

