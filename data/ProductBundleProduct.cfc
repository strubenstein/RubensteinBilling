<cfcomponent DisplayName="ProductBundleProduct" Hint="Manages product bundles">

<cffunction name="maxlength_ProductBundleProduct" access="public" output="no" returnType="struct">
	<cfset var maxlength_ProductBundleProduct = StructNew()>

	<cfset maxlength_ProductBundleProduct.productBundleProductQuantity = 4>

	<cfreturn maxlength_ProductBundleProduct>
</cffunction>

<cffunction Name="insertProductBundleProduct" Access="public" Output="No" ReturnType="boolean" Hint="Add Product to Product Bundle">
	<cfargument Name="productBundleID" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productBundleProductOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="productBundleQuantity" Type="numeric" Required="No" Default="1">

	<cfif Arguments.productBundleProductOrder is 0>
		<cfset Arguments.productBundleProductOrder = 1 + selectProductBundleProductOrderMax(Arguments.productBundleID)>
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.ProductBundleProduct" method="maxlength_ProductBundleProduct" returnVariable="maxlength_ProductBundleProduct" />

	<cfquery Name="qry_insertProductBundleProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avProductBundleProduct
		(
			productBundleID, productID, productBundleProductOrder, productBundleProductQuantity
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.productBundleID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productBundleProductOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.productBundleProductQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_ProductBundleProduct.productBundleProductQuantity#">
		);

		UPDATE avProduct
		SET productInBundle = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">;
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectProductBundleProductOrderMax" Access="public" Output="No" ReturnType="numeric" Hint="Select Maximum Order in Product Bundle">
	<cfargument Name="productBundleID" Type="numeric" Required="Yes">

	<cfset var qry_selectProductBundleProductOrderMax = QueryNew("blank")>

	<cfquery Name="qry_selectProductBundleProductOrderMax" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Max(productBundleProductOrder) AS productBundleProductOrderMax
		FROM avProductBundleProduct
		WHERE productBundleID = <cfqueryparam Value="#Arguments.productBundleID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif Not IsNumeric(qry_selectProductBundleProductOrderMax.productBundleProductOrderMax)>
		<cfreturn 0>
	<cfelse>
		<cfreturn qry_selectProductBundleProductOrderMax.productBundleProductOrderMax>
	</cfif>
</cffunction>

<cffunction Name="selectProductBundleList" Access="public" Output="No" ReturnType="query" Hint="Select Bundles that Include Product">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="productBundleStatus" Type="numeric" Required="No" Default="1">

	<cfset var qry_selectProductBundleList = QueryNew("blank")>

	<cfquery Name="qry_selectProductBundleList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avProductBundleProduct.productBundleID, avProductBundleProduct.productBundleProductQuantity,
			avProductBundle.productID, avProductBundle.productBundleDateCreated,
			avProduct.productName, avProduct.productPrice, avProduct.productID_custom,
			avProduct.productStatus, avProduct.productListedOnSite
		FROM avProductBundleProduct, avProductBundle, avProduct
		WHERE avProductBundleProduct.productBundleID = avProductBundle.productBundleID
			AND avProductBundle.productID = avProduct.productID
			AND avProductBundle.productBundleStatus = <cfqueryparam Value="#Arguments.productBundleStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avProductBundleProduct.productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
		ORDER BY avProduct.productName
	</cfquery>

	<cfreturn qry_selectProductBundleList>
</cffunction>

<cffunction Name="selectProductBundleProductList" Access="public" Output="No" ReturnType="query" Hint="Select Products Included in Product Bundle">
	<cfargument Name="productBundleID" Type="string" Required="Yes">

	<cfset var qry_selectProductBundleProductList = QueryNew("blank")>

	<cfif Not IsNumeric(Arguments.productBundleID) and Not Application.fn_IsIntegerList(Arguments.productBundleID)>
		<cfset Arguments.productBundleID = 0>
	</cfif>

	<cfquery Name="qry_selectProductBundleProductList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avProductBundleProduct.productBundleID, avProductBundleProduct.productID,
			avProductBundleProduct.productBundleProductOrder, avProductBundleProduct.productBundleProductQuantity,
			avProduct.productName, avProduct.productPrice, avProduct.productID_custom,
			avProduct.productStatus, avProduct.productListedOnSite
		FROM avProductBundleProduct, avProduct
		WHERE avProductBundleProduct.productID = avProduct.productID
			AND avProductBundleProduct.productBundleID IN (<cfqueryparam Value="#Arguments.productBundleID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		ORDER BY avProductBundleProduct.productBundleID DESC, avProductBundleProduct.productBundleProductOrder
	</cfquery>

	<cfreturn qry_selectProductBundleProductList>
</cffunction>

<cffunction Name="updateProductBundleProduct" Access="public" Output="No" ReturnType="boolean" Hint="Update Product Bundle">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productBundleID" Type="numeric" Required="Yes">
	<cfargument Name="productBundleProductOrder" Type="numeric" Required="No">
	<cfargument Name="productBundleProductQuantity" Type="numeric" Required="No">

	<cfif StructKeyExists(Arguments, "productBundleProductOrder") or StructKeyExists(Arguments, "productBundleProductQuantity")>
		<cfinvoke component="#Application.billingMapping#data.ProductBundleProduct" method="maxlength_ProductBundleProduct" returnVariable="maxlength_ProductBundleProduct" />

		<cfquery Name="qry_updateProductBundleProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avProductBundleProduct
			SET 
				<cfif StructKeyExists(Arguments, "productBundleProductOrder")>
					productBundleProductOrder = <cfqueryparam Value="#Arguments.productBundleProductOrder#" cfsqltype="cf_sql_smallint">
					<cfif StructKeyExists(Arguments, "productBundleProductQuantity")>,</cfif>
				</cfif>
				<cfif StructKeyExists(Arguments, "productBundleProductQuantity")>
					productBundleProductQuantity = <cfqueryparam Value="#Arguments.productBundleProductQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_ProductBundleProduct.productBundleProductQuantity#">
				</cfif>
			WHERE productBundleID = <cfqueryparam Value="#Arguments.productBundleID#" cfsqltype="cf_sql_integer">
				AND productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="copyProductBundleProduct" Access="public" Output="No" ReturnType="boolean" Hint="Copy Products in Product Bundle to new Bundle Version">
	<cfargument Name="productBundleID_old" Type="numeric" Required="Yes">
	<cfargument Name="productBundleID_new" Type="numeric" Required="Yes">

	<cfquery Name="qry_copyProductBundleProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avProductBundleProduct
		(
			productBundleID, productID, productBundleProductOrder, productBundleProductQuantity
		)
		SELECT 
			<cfqueryparam Value="#Arguments.productBundleID_new#" cfsqltype="cf_sql_integer">,
			productID,
			productBundleProductOrder,
			productBundleProductQuantity
		FROM avProductBundleProduct
		WHERE productBundleID = <cfqueryparam Value="#Arguments.productBundleID_old#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="deleteProductBundleProduct" Access="public" Output="No" ReturnType="boolean" Hint="Remove Product from Product Bundle">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productBundleID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteProductBundleProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductBundleProduct
		SET productBundleProductOrder = productBundleProductOrder - <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE productBundleID = <cfqueryparam Value="#Arguments.productBundleID#" cfsqltype="cf_sql_integer">
			AND productBundleProductOrder > 
				(
				SELECT productBundleProductOrder
				FROM avProductBundleProduct
				WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
					AND productBundleID = <cfqueryparam Value="#Arguments.productBundleID#" cfsqltype="cf_sql_integer">
				);

		DELETE FROM avProductBundleProduct
		WHERE productBundleID = <cfqueryparam Value="#Arguments.productBundleID#" cfsqltype="cf_sql_integer">
			AND productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">;

		UPDATE avProduct
		SET productInBundle = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productID NOT IN 
				(
				SELECT avProductBundleProduct.productID
				FROM avProductBundleProduct, avProductBundle
				WHERE avProductBundleProduct.productBundleID = avProductBundle.productBundleID
					AND avProductBundle.productBundleStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND avProductBundleProduct.productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				);
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
