<cfcomponent DisplayName="ProductDate" Hint="Manages dates products are available">

<cffunction Name="insertProductDate" Access="public" Output="No" ReturnType="boolean" Hint="Insert designated dates product is available">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productDateBegin" Type="date" Required="Yes">
	<cfargument Name="productDateEnd" Type="string" Required="No">
	<cfargument Name="productDateStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="userID" Type="numeric" Required="Yes">

	<cfquery Name="qry_insertProductDate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avProductDate
		(
			productID, productDateBegin, productDateEnd, productDateStatus,
			userID, productDateDateCreated, productDateDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productDateBegin#" cfsqltype="cf_sql_timestamp">,
			<cfif Not StructKeyExists(Arguments, "productDateEnd") or Not IsDate(Arguments.productDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.productDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.productDateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateProductDate" Access="public" Output="No" ReturnType="boolean" Hint="Update designated dates product is available">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productDateID" Type="numeric" Required="Yes">
	<cfargument Name="productDateBegin" Type="string" Required="No">
	<cfargument Name="productDateEnd" Type="string" Required="No">
	<cfargument Name="productDateStatus" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfquery Name="qry_updateProductDate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductDate
		SET 
			<cfif StructKeyExists(Arguments, "productDateBegin")>productDateBegin = <cfif Not IsDate(Arguments.productDateBegin)>NULL<cfelse><cfqueryparam Value="#Arguments.productDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "productDateEnd")>productDateEnd =  <cfif Not IsDate(Arguments.productDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.productDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "productDateStatus") and ListFind("0,1", Arguments.productDateStatus)>productDateStatus = <cfqueryparam Value="#Arguments.productDateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			productDateDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productDateID = <cfqueryparam Value="#Arguments.productDateID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectProductDateList" Access="public" Output="No" ReturnType="query" Hint="Select designated dates product is available">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productDateBegin" Type="date" Required="No">
	<cfargument Name="productDateBegin_operator" Type="string" Required="No">
	<cfargument Name="productDateEnd" Type="date" Required="No">
	<cfargument Name="productDateEnd_operator" Type="string" Required="No">
	<cfargument Name="productDateStatus" Type="numeric" Required="No">

	<cfset var qry_selectProductDateList = QueryNew("blank")>

	<cfquery Name="qry_selectProductDateList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productDateID, productDateBegin, productDateEnd, productDateStatus,
			userID, productDateDateCreated, productDateDateUpdated
		FROM avProductDate
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "productDateStatus") and ListFind("0,1", Arguments.productDateStatus)>
				AND productDateStatus = <cfqueryparam Value="#Arguments.productDateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "productDateBegin") and StructKeyExists(Arguments, "productDateBegin_operator")>
				AND productDateBegin #Arguments.productDateBegin_operator# <cfqueryparam Value="#Arguments.productDateBegin#" cfsqltype="cf_sql_timestamp">,
			</cfif>
			<cfif StructKeyExists(Arguments, "productDateEnd") and StructKeyExists(Arguments, "productDateEnd_operator")>
				AND productDateEnd #Arguments.productDateEnd_operator# <cfqueryparam Value="#Arguments.productDateEnd#" cfsqltype="cf_sql_timestamp">,
			</cfif>
		ORDER BY productDateBegin
	</cfquery>

	<cfreturn qry_selectProductDateList>
</cffunction>

<cffunction Name="deleteProductDate" Access="public" Output="No" ReturnType="boolean" Hint="Delete designated dates product is available">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productDateID" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.productDateID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_deleteProductDate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			DELETE FROM avProductDate
			WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				AND productDateID IN (<cfqueryparam Value="#Arguments.productDateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>
</cfcomponent>

