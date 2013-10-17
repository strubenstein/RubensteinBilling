<cfcomponent DisplayName="CommissionCategory" Hint="Manages commissions that apply to product categories">

<!--- avCommissionCategory --->
<cffunction Name="insertCommissionCategory" Access="public" Output="No" ReturnType="boolean" Hint="Enables commission to be charged for products in category. Returns True.">
	<cfargument Name="commissionID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="Yes">
	<cfargument Name="commissionCategoryChildren" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionCategoryStatus" Type="numeric" Required="No" Default="1">

	<cfquery Name="qry_insertCommissionCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCommissionCategory
		(
			commissionID, categoryID, userID, commissionCategoryChildren, commissionCategoryStatus,
			commissionCategoryDateCreated, commissionCategoryDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.commissionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.commissionCategoryChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateCommissionCategory" Access="public" Output="No" ReturnType="boolean" Hint="Update commission category. Returns True.">
	<cfargument Name="commissionCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="commissionCategoryChildren" Type="numeric" Required="No">
	<cfargument Name="commissionCategoryStatus" Type="numeric" Required="No">

	<cfquery Name="qry_updateCommissionCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCommissionCategory
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "commissionCategoryChildren") and ListFind("0,1", Arguments.commissionCategoryChildren)>commissionCategoryChildren = <cfqueryparam Value="#Arguments.commissionCategoryChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "commissionCategoryStatus") and ListFind("0,1", Arguments.commissionCategoryStatus)>commissionCategoryStatus = <cfqueryparam Value="#Arguments.commissionCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			commissionCategoryDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE commissionCategoryID = <cfqueryparam Value="#Arguments.commissionCategoryID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="copyCommissionCategory" Access="public" Output="No" ReturnType="boolean" Hint="Copy commission category(s) when copy/update commission. Returns True.">
	<cfargument Name="commissionID_old" Type="numeric" Required="Yes">
	<cfargument Name="commissionID_new" Type="numeric" Required="Yes">

	<cfquery Name="qry_copyCommissionCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCommissionCategory
		(
			commissionID, categoryID, userID, commissionCategoryChildren, commissionCategoryStatus,
			commissionCategoryDateCreated, commissionCategoryDateUpdated
		)
		SELECT
			<cfqueryparam Value="#Arguments.commissionID_new#" cfsqltype="cf_sql_integer">,
			categoryID,
			userID,
			commissionCategoryChildren,
			commissionCategoryStatus,
			commissionCategoryDateCreated,
			commissionCategoryDateUpdated
		FROM avCommissionCategory
		WHERE commissionID = <cfqueryparam Value="#Arguments.commissionID_old#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectCommissionCategory" Access="public" Output="No" ReturnType="query" Hint="Select commission category(s).">
	<cfargument Name="commissionCategoryID" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="commissionCategoryChildren" Type="numeric" Required="No">
	<cfargument Name="commissionCategoryStatus" Type="numeric" Required="No">

	<cfset var qry_selectCommissionCategory = QueryNew("blank")>
	<cfset var isAllFormFieldsOk = False>

	<cfif (StructKeyExists(Arguments, "commissionID") and Application.fn_IsIntegerList(Arguments.commissionID)) or (StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerList(Arguments.categoryID))>
		<cfset isAllFormFieldsOk = True>
	<cfelse>
		<cfset Arguments.commissionID = 0>
		<cfset Arguments.categoryID = 0>
	</cfif>

	<cfquery Name="qry_selectCommissionCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT commissionCategoryID, commissionID, categoryID, userID, commissionCategoryStatus,
			commissionCategoryChildren, commissionCategoryDateCreated, commissionCategoryDateUpdated
		FROM avCommissionCategory
		WHERE commissionCategoryID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="commissionCategoryID,commissionID,categoryID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND #field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfloop Index="field" List="commissionCategoryChildren,commissionCategoryStatus">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND #field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
	</cfquery>

	<cfreturn qry_selectCommissionCategory>
</cffunction>

</cfcomponent>
