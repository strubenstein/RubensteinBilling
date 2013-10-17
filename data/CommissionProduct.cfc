<cfcomponent DisplayName="CommissionProduct" Hint="Manages commissions that apply to products">

<!--- avCommissionProduct --->
<cffunction Name="insertCommissionProduct" Access="public" Output="No" ReturnType="boolean" Hint="Enables commission to be charged for products. Returns True.">
	<cfargument Name="commissionID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="commissionProductChildren" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionProductStatus" Type="numeric" Required="No" Default="1">

	<cfquery Name="qry_insertCommissionProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCommissionProduct
		(
			commissionID, productID, userID, commissionProductChildren, commissionProductStatus,
			commissionProductDateCreated, commissionProductDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.commissionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.commissionProductChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionProductStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateCommissionProduct" Access="public" Output="No" ReturnType="boolean" Hint="Update commission product. Returns True.">
	<cfargument Name="commissionProductID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="commissionProductStatus" Type="numeric" Required="No">

	<cfquery Name="qry_updateCommissionProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCommissionProduct
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "commissionProductChildren") and ListFind("0,1", Arguments.commissionProductChildren)>commissionProductChildren = <cfqueryparam Value="#Arguments.commissionProductChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "commissionProductStatus") and ListFind("0,1", Arguments.commissionProductStatus)>commissionProductStatus = <cfqueryparam Value="#Arguments.commissionProductStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			commissionProductDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE commissionProductID = <cfqueryparam Value="#Arguments.commissionProductID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="copyCommissionProduct" Access="public" Output="No" ReturnType="boolean" Hint="Copy commission product(s) when copy/update commission. Returns True.">
	<cfargument Name="commissionID_old" Type="numeric" Required="Yes">
	<cfargument Name="commissionID_new" Type="numeric" Required="Yes">

	<cfquery Name="qry_copyCommissionProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCommissionProduct
		(
			commissionID, productID, userID, commissionProductChildren, commissionProductStatus,
			commissionProductDateCreated, commissionProductDateUpdated
		)
		SELECT
			<cfqueryparam Value="#Arguments.commissionID_new#" cfsqltype="cf_sql_integer">,
			productID, userID, commissionProductChildren, commissionProductStatus,
			commissionProductDateCreated, commissionProductDateUpdated
		FROM avCommissionProduct
		WHERE commissionID = <cfqueryparam Value="#Arguments.commissionID_old#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectCommissionProduct" Access="public" Output="No" ReturnType="query" Hint="Select commission product(s).">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="commissionProductChildren" Type="numeric" Required="No">
	<cfargument Name="commissionProductStatus" Type="numeric" Required="No">

	<cfset var qry_selectCommissionProduct = QueryNew("blank")>
	<cfset var isAllFormFieldsOk = False>

	<cfif (StructKeyExists(Arguments, "commissionID") and Application.fn_IsIntegerList(Arguments.commissionID)) or (StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID))>
		<cfset isAllFormFieldsOk = True>
	<cfelse>
		<cfset Arguments.commissionID = 0>
		<cfset Arguments.productID = 0>
	</cfif>

	<cfquery Name="qry_selectCommissionProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT commissionProductID, commissionID, productID, userID, commissionProductStatus,
			commissionProductChildren, commissionProductDateCreated, commissionProductDateUpdated
		FROM avCommissionProduct
		WHERE commissionProductID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="commissionProductID,commissionID,productID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND #field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfloop Index="field" List="commissionProductChildren,commissionProductStatus">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND #field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
	</cfquery>

	<cfreturn qry_selectCommissionProduct>
</cffunction>

</cfcomponent>

