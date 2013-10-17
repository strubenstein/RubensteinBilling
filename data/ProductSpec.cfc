<cfcomponent DisplayName="ProductSpec" Hint="Manages creating, viewing and updating product specifications">

<cffunction name="maxlength_ProductSpec" access="public" output="no" returnType="struct">
	<cfset var maxlength_ProductSpec = StructNew()>

	<cfset maxlength_ProductSpec.productSpecName = 100>
	<cfset maxlength_ProductSpec.productSpecValue = 100>
	<cfset maxlength_ProductSpec.languageID = 5>

	<cfreturn maxlength_ProductSpec>
</cffunction>

<cffunction Name="insertProductSpec" Access="public" Output="No" ReturnType="boolean" Hint="Insert product specifications">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="productSpecList" Type="array" Required="Yes">

	<cfset var productSpecVersion = 0>

	<cfif ArrayLen(Arguments.productSpecList) is 0>
		<cfreturn False>
	<cfelse>
		<cfset productSpecVersion = selectProductSpecVersionMax(Arguments.productID) + 1>
		<cfinvoke component="#Application.billingMapping#data.ProductSpec" method="maxlength_ProductSpec" returnVariable="maxlength_ProductSpec" />

		<cfquery Name="qry_insertProductSpec" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfloop Index="count" From="1" To="#ArrayLen(Arguments.productSpecList)#">
				INSERT INTO avProductSpec
				(
					productID, productSpecName, productSpecValue, productSpecOrder, productSpecStatus, productSpecVersion,
					productSpecHasImage, languageID, userID, productSpecDateCreated, productSpecDateUpdated
				)
				VALUES
				(
					<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#Arguments.productSpecList[count].productSpecName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductSpec.productSpecName#">,
					<cfqueryparam Value="#Arguments.productSpecList[count].productSpecValue#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductSpec.productSpecValue#">,
					<cfqueryparam Value="#count#" cfsqltype="cf_sql_tinyint">,
					<cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					<cfqueryparam Value="#productSpecVersion#" cfsqltype="cf_sql_smallint">,
					<cfqueryparam Value="#Arguments.productSpecList[count].productSpecHasImage#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					<cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductSpec.languageID#">,
					<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
					#Application.billingSql.sql_nowDateTime#,
					#Application.billingSql.sql_nowDateTime#
				);
			</cfloop>
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="updateProductSpec" Access="public" Output="No" ReturnType="boolean" Hint="Update product specification status">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">

	<cfquery Name="qry_updateProductSpec" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductSpec
		SET productSpecStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			productSpecDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">
			AND productSpecStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectProductSpecList" Access="public" Output="No" ReturnType="query" Hint="Select product specs">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="productSpecVersion" Type="numeric" Required="No">
	<cfargument Name="productSpecStatus" Type="numeric" Required="No">

	<cfset var qry_selectProductSpecList = QueryNew("blank")>

	<cfquery Name="qry_selectProductSpecList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productID, productSpecID, productSpecName, productSpecValue, productSpecOrder,
			productSpecStatus, productSpecVersion, productSpecHasImage,
			languageID, userID, productSpecDateCreated, productSpecDateUpdated
		FROM avProductSpec
		WHERE productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "productSpecStatus") and ListFind("0,1", Arguments.productSpecStatus)>
				AND productSpecStatus = <cfqueryparam Value="#Arguments.productSpecStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "languageID")>
				AND languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif StructKeyExists(Arguments, "productSpecVersion") and IsNumeric(Arguments.productSpecVersion)>
				AND productSpecVersion = <cfqueryparam Value="#Arguments.productSpecVersion#" cfsqltype="cf_sql_smallint">
			</cfif>
		ORDER BY productID, productSpecVersion DESC, productSpecOrder
	</cfquery>

	<cfreturn qry_selectProductSpecList>
</cffunction>

<cffunction Name="selectProductSpecVersionMax" Access="public" Output="No" ReturnType="numeric" Hint="Select next version number of specs for product">
	<cfargument Name="productID" Type="numeric" Required="Yes">

	<cfset var qry_selectProductSpecVersionMax = QueryNew("blank")>

	<cfquery Name="qry_selectProductSpecVersionMax" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT MAX(productSpecVersion) AS maxProductSpecVersion
		FROM avProductSpec
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_selectProductSpecVersionMax.RecordCount is 0 or Not IsNumeric(qry_selectProductSpecVersionMax.maxProductSpecVersion)>
		<cfreturn 0>
	<cfelse>
		<cfreturn qry_selectProductSpecVersionMax.maxProductSpecVersion>
	</cfif>
</cffunction>

<cffunction Name="selectProductSpecNameList" Access="public" Output="No" ReturnType="query" Hint="Select existing spec names for all products">
	<cfargument Name="companyID" Type="numeric" Required="No">
	<cfargument Name="productID_parent" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="numeric" Required="No">

	<cfset var queryParameterList = "">
	<cfset var queryOrderList = "">
	<cfset var qry_selectProductSpecNameList = QueryNew("blank")>

	<cfif StructKeyExists(Arguments, "companyID") and Arguments.companyID is not 0 and Application.fn_IsIntegerList(Arguments.companyID)>
		<cfset queryParameterList = ListAppend(queryParameterList, "companyID")>
		<cfset queryOrderList = ListAppend(queryOrderList, 4)>
	</cfif>

	<cfif StructKeyExists(Arguments, "productID_parent") and Arguments.productID_parent is not 0 and Application.fn_IsIntegerList(Arguments.productID_parent)>
		<cfset queryParameterList = ListAppend(queryParameterList, "productID_parent")>
		<cfset queryOrderList = ListAppend(queryOrderList, 2)>
	</cfif>

	<cfif StructKeyExists(Arguments, "productID") and Arguments.productID is not 0 and Application.fn_IsIntegerList(Arguments.productID)>
		<cfset queryParameterList = ListAppend(queryParameterList, "productID")>
		<cfset queryOrderList = ListAppend(queryOrderList, 1)>
	</cfif>

	<cfif StructKeyExists(Arguments, "vendorID") and Arguments.vendorID is not 0 and Application.fn_IsIntegerList(Arguments.vendorID)>
		<cfset queryParameterList = ListAppend(queryParameterList, "vendorID")>
		<cfset queryOrderList = ListAppend(queryOrderList, 3)>
	</cfif>

	<cfif queryParameterList is "">
		<cfset qry_selectProductSpecNameList = QueryNew("specType,productSpecName")>
	<cfelse>
		<cfquery Name="qry_selectProductSpecNameList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfloop Index="count" From="1" To="#ListLen(queryParameterList)#">
				<cfif count gt 1>UNION</cfif>
				SELECT DISTINCT(avProductSpec.productSpecName),
					'#ListGetAt(queryOrderList, count)#_#ListGetAt(queryParameterList, count)#' AS specType
				FROM avProductSpec, avProduct
				WHERE avProductSpec.productID = avProduct.productID
				<cfswitch expression="#ListGetAt(queryParameterList, count)#">
				<cfcase value="companyID">
					AND avProduct.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfcase>
				<cfcase value="productID_parent">
					AND avProduct.productID_parent IN (<cfqueryparam Value="#Arguments.productID_parent#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfcase>
				<cfcase value="productID">
					AND avProduct.productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfcase>
				<cfcase value="vendorID">
					AND avProduct.vendorID IN (<cfqueryparam Value="#Arguments.vendorID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfcase>
				</cfswitch>
			</cfloop>
			ORDER BY specType, productSpecName
		</cfquery>
	</cfif>

	<cfreturn qry_selectProductSpecNameList>
</cffunction>
</cfcomponent>

