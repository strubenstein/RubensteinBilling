<cfcomponent DisplayName="ProductCategory" Hint="Manages product and category listings">

<cffunction Name="insertProductCategory" Access="public" Output="No" ReturnType="boolean" Hint="Add Product to Category">
	<cfargument Name="categoryID" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="productCategoryStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="productCategoryPrimary" Type="numeric" Required="No" Default="0">
	<cfargument Name="productCategoryOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="productCategoryPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="productCategoryDateBegin" Type="date" Required="No" Default="#CreateODBCDateTime(Now())#">
	<cfargument Name="productCategoryDateEnd" Type="string" Required="No" Default="">

	<cftransaction>
	<cfquery Name="qry_insertProductCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avProductCategory
		(
			productID, categoryID, userID, productCategoryPrimary, productCategoryStatus, productCategoryOrder, productCategoryPage,
			productCategoryDateBegin, productCategoryDateEnd, productCategoryDateCreated, productCategoryDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productCategoryPrimary#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productCategoryOrder#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productCategoryPage#" cfsqltype="cf_sql_integer">,
			<cfif Not StructKeyExists(Arguments, "productCategoryDateBegin") or Not IsDate(Arguments.productCategoryDateBegin)>#Application.billingSql.sql_nowDateTime#<cfelse><cfqueryparam Value="#Arguments.productCategoryDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not StructKeyExists(Arguments, "productCategoryDateEnd") or Not IsDate(Arguments.productCategoryDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.productCategoryDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfquery Name="qry_insertProductCategoryOrder_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT MAX(productCategoryOrder) AS maxProductCategoryOrder
		FROM avProductCategory
		WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery Name="qry_insertProductCategoryOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductCategory
		SET productCategoryOrder = <cfqueryparam Value="1" cfsqltype="cf_sql_integer"> + 
			<cfif Not IsNumeric(qry_insertProductCategoryOrder_select.maxProductCategoryOrder)>
				<cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfelse>
				<cfqueryparam Value="#qry_insertProductCategoryOrder_select.maxProductCategoryOrder#" cfsqltype="cf_sql_integer">
			</cfif>
		WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
			AND productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
	</cfquery>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="updateProductCategory" Access="public" Output="No" ReturnType="boolean" Hint="Remove Product from Category">
	<cfargument Name="categoryID" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="productCategoryStatus" Type="numeric" Required="No">
	<cfargument Name="productCategoryPrimary" Type="numeric" Required="No">
	<cfargument Name="productCategoryOrder" Type="numeric" Required="No">
	<cfargument Name="productCategoryPage" Type="numeric" Required="No">
	<cfargument Name="productCategoryDateBegin" Type="date" Required="No">
	<cfargument Name="productCategoryDateEnd" Type="string" Required="No">

	<cfquery Name="qry_updateProductCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductCategory
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "productCategoryPrimary") and ListFind("0,1", Arguments.productCategoryPrimary)>productCategoryPrimary = <cfqueryparam Value="#Arguments.productCategoryPrimary#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productCategoryStatus") and ListFind("0,1", Arguments.productCategoryStatus)>productCategoryStatus = <cfqueryparam Value="#Arguments.productCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productCategoryOrder") and Application.fn_IsIntegerNonNegative(Arguments.productCategoryOrder)>productCategoryOrder = <cfqueryparam Value="#Arguments.productCategoryOrder#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "productCategoryPage") and Application.fn_IsIntegerNonNegative(Arguments.productCategoryPage)>productCategoryPage = <cfqueryparam Value="#Arguments.productCategoryPage#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "productCategoryDateBegin") and IsDate(Arguments.productCategoryDateBegin)>productCategoryDateBegin = <cfqueryparam Value="#Arguments.productCategoryDateBegin#" cfsqltype="cf_sql_timestamp">,</cfif>
			<cfif StructKeyExists(Arguments, "productCategoryDateEnd") and (Arguments.productCategoryDateEnd is "" or IsDate(Arguments.productCategoryDateEnd))>productCategoryDateEnd = <cfif Not IsDate(Arguments.productCategoryDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.productCategoryDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			productCategoryDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectProductCategory" Access="public" Output="No" ReturnType="query" Hint="Select Categories Product is listed in">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="productCategoryStatus" Type="numeric" Required="No">
	<cfargument Name="productCategoryPrimary" Type="numeric" Required="No">
	<cfargument Name="productCategoryDate" Type="date" Required="No">

	<cfset var qry_selectProductCategory = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.productID)>
		<cfset Arguments.productID = 0>
	</cfif>

	<cfquery Name="qry_selectProductCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avProductCategory.productID, avProductCategory.categoryID, avProductCategory.productCategoryPrimary,
			avProductCategory.productCategoryStatus, avProductCategory.productCategoryOrder, avProductCategory.productCategoryPage,
			avProductCategory.userID, avProductCategory.productCategoryDateBegin, avProductCategory.productCategoryDateEnd,
			avProductCategory.productCategoryDateCreated, avProductCategory.productCategoryDateUpdated,
			avCategory.categoryTitle, avCategory.categoryLevel, avCategory.categoryOrder,
			avCategory.categoryID_parent, avCategory.categoryID_parentList
		FROM avProductCategory, avCategory
		WHERE avProductCategory.categoryID = avCategory.categoryID
			AND avProductCategory.productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "productCategoryStatus") and ListFind("0,1", Arguments.productCategoryStatus)>
				AND avProductCategory.productCategoryStatus = <cfqueryparam Value="#Arguments.productCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "productCategoryPrimary") and ListFind("0,1", Arguments.productCategoryPrimary)>
				AND avProductCategory.productCategoryPrimary = <cfqueryparam Value="#Arguments.productCategoryPrimary#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "productCategoryDate") and IsDate(Arguments.productCategoryDate)>
				AND avProductCategory.productCategoryDateBegin <= <cfqueryparam Value="#CreateODBCDateTime(Arguments.productCategoryDate)#" CFSQLType="cf_sql_timestamp">
				AND (avProductCategory.productCategoryDateEnd IS NULL OR avProductCategory.productCategoryDateEnd >= <cfqueryparam Value="#CreateODBCDateTime(Arguments.productCategoryDate)#" CFSQLType="cf_sql_timestamp">)
			</cfif>
	</cfquery>

	<cfreturn qry_selectProductCategory>
</cffunction>

<cffunction Name="selectProductCategoryList" Access="public" Output="No" ReturnType="query" Hint="Select Existing Products in a given Category">
	<cfargument Name="categoryID" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="productCategoryStatus" Type="numeric" Required="No">
	<cfargument Name="productCategoryPrimary" Type="numeric" Required="No">

	<cfset var qry_selectProductCategoryList = QueryNew("blank")>

	<cfquery Name="qry_selectProductCategoryList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avProduct.companyID, avProduct.userID_author, avProduct.userID_manager, avProduct.vendorID,
			avProduct.productCode, avProduct.productName, avProduct.productPrice, avProduct.productPriceCallForQuote,
			avProduct.productWeight, avProduct.productStatus, avProduct.productListedOnSite,
			avProduct.productHasImage, avProduct.productHasCustomPrice, avProduct.productHasSpec,
			avProduct.productHasParameter, avProduct.productHasParameterException, avProduct.productCanBePurchased,
			avProduct.productDisplayChildren, avProduct.productViewCount, avProduct.productInBundle,
			avProduct.productIsBundle, avProduct.productIsRecommended, avProduct.productHasRecommendation,
			avProduct.productIsDateRestricted, avProduct.productIsDateAvailable, avProduct.productID_custom,
			avProduct.templateFilename, avProduct.productCatalogPageNumber, avProduct.productChildType,
			avProduct.productChildSeparate, avProduct.productDateCreated, avProduct.productDateUpdated,
			avProductCategory.productCategoryPrimary, avProductCategory.productCategoryStatus,
			avProductCategory.productCategoryOrder, avProductCategory.productCategoryPage,
			avProductCategory.productCategoryDateBegin, avProductCategory.productCategoryDateEnd,
			avProductCategory.productCategoryDateCreated, avProductCategory.productCategoryDateUpdated
		FROM avProduct, avProductCategory
		WHERE avProduct.productID = avProductCategory.productID
			AND avProductCategory.categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "productCategoryStatus") and ListFind("0,1", Arguments.productCategoryStatus)>
				AND avProductCategory.productCategoryStatus = <cfqueryparam Value="#Arguments.productCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				<cfif Arguments.productCategoryStatus is 1>
					AND avProductCategory.productCategoryDateBegin <= #CreateODBCDateTime(Now())#
					AND (avProductCategory.productCategoryDateEnd IS NULL OR avProductCategory.productCategoryDateEnd > #CreateODBCDateTime(Now())#)
				</cfif>
			</cfif>
			<cfif StructKeyExists(Arguments, "productCategoryPrimary") and ListFind("0,1", Arguments.productCategoryPrimary)>
				AND avProductCategory.productCategoryPrimary = <cfqueryparam Value="#Arguments.productCategoryPrimary#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
	</cfquery>

	<cfreturn qry_selectProductCategoryList>
</cffunction>

<cffunction Name="switchProductCategoryOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch manual order of products within a category">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="Yes">
	<cfargument Name="productCategoryOrder_direction" Type="string" Required="Yes">

	<cfset var qry_selectProductCategoryOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchProductCategoryOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductCategory
		SET productCategoryOrder = productCategoryOrder 
			<cfif Arguments.productCategoryOrder_direction is "moveProductCategoryDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
			AND productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avProductCategory INNER JOIN avProductCategory AS avProductCategory2
			SET avProductCategory.productCategoryOrder = avProductCategory.productCategoryOrder 
				<cfif Arguments.productCategoryOrder_direction is "moveProductCategoryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avProductCategory.productCategoryOrder = avProductCategory2.productCategoryOrder
				AND avProductCategory.categoryID = avProductCategory2.categoryID
				AND avProductCategory.categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
				AND avProductCategory.productID <> <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				AND avProductCategory2.productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avProductCategory
			SET productCategoryOrder = productCategoryOrder 
				<cfif Arguments.productCategoryOrder_direction is "moveProductCategoryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
				AND productID <> <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				AND productCategoryOrder = (SELECT productCategoryOrder FROM avProductCategory WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer"> AND productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>