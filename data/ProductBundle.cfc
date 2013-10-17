<cfcomponent DisplayName="ProductBundle" Hint="Manages product bundles">

<cffunction Name="insertProductBundle" Access="public" Output="No" ReturnType="numeric" Hint="Add Product Bundle">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">

	<cfset var qry_insertProductBundle = QueryNew("blank")>
	<cfset var productBundleVersion = selectProductBundleVersionMax(Arguments.productID) + 1>

	<cfquery Name="qry_insertProductBundle" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductBundle
		SET productBundleStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			productBundleDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productBundleStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;

		INSERT INTO avProductBundle
		(
			productID, productBundleVersion, productBundleStatus, userID,
			productBundleDateCreated, productBundleDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#productBundleVersion#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "productBundleID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertProductBundle.primaryKeyID>
</cffunction>

<cffunction Name="selectProductBundleVersionMax" Access="public" Output="No" ReturnType="numeric" Hint="Select Maximum Version of Product Bundle">
	<cfargument Name="productID" Type="numeric" Required="Yes">

	<cfset var qry_selectProductBundleVersionMax = QueryNew("blank")>

	<cfquery Name="qry_selectProductBundleVersionMax" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Max(productBundleVersion) AS productBundleVersionMax
		FROM avProductBundle
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif Not IsNumeric(qry_selectProductBundleVersionMax.productBundleVersionMax)>
		<cfreturn 0>
	<cfelse>
		<cfreturn qry_selectProductBundleVersionMax.productBundleVersionMax>
	</cfif>
</cffunction>

<cffunction Name="selectProductBundle" Access="public" Output="No" ReturnType="query" Hint="Select Product Bundle">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productBundleID" Type="numeric" Required="No">
	<cfargument Name="productBundleVersion" Type="numeric" Required="No">
	<cfargument Name="productBundleStatus" Type="numeric" Required="No">

	<cfset var qry_selectProductBundle = QueryNew("blank")>

	<cfquery Name="qry_selectProductBundle" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productBundleID, productBundleVersion, productBundleStatus,
			userID, productBundleDateCreated, productBundleDateUpdated
		FROM avProductBundle
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "productBundleID")>AND productBundleID = <cfqueryparam Value="#Arguments.productBundleID#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "productBundleVersion")>AND productBundleVersion = <cfqueryparam Value="#Arguments.productBundleVersion#" cfsqltype="cf_sql_smallint"></cfif>
			<cfif StructKeyExists(Arguments, "productBundleStatus") and ListFind("0,1", Arguments.productBundleStatus)>AND productBundleStatus = <cfqueryparam Value="#Arguments.productBundleStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		ORDER BY productBundleStatus DESC, productBundleVersion DESC
	</cfquery>

	<cfreturn qry_selectProductBundle>
</cffunction>

<cffunction Name="checkProductIsBundleChanged" Access="public" Output="No" ReturnType="numeric" Hint="Determine if first change to product bundle. If so, make new version.">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productBundleID" Type="numeric" Required="Yes">
	<cfargument Name="productIsBundleChanged" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">

	<!--- 
	Material changes to a bundle include:
		- Adding a new product
		- Updating quantity of existing product
		- Removing a product
	Switching product order in bundle is not considered a material change.
	--->

	<cfset var currentProductBundleID = 0>

	<cfif Arguments.productIsBundleChanged is 1><!--- Bundle has already changed. Return current bundle version. --->
		<cfreturn Arguments.productBundleID>
	<cfelse><!--- This is the first product added to the bundle or first change to existing bundle. --->
		<!--- Update product to reflect bundle has been changed --->
		<cfquery Name="qry_updateProductIsBundleChanged" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avProduct
			SET productIsBundleChanged = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<!--- Create new bundle --->
		<cfset currentProductBundleID = insertProductBundle(Arguments.productID, Arguments.userID)>

		<cfif Arguments.productBundleID is not 0><!--- First change to existing bundle. Copy existing bundle and create new version. --->
			<cfinvoke Component="#Application.billingMapping#data.ProductBundleProduct" Method="copyProductBundleProduct" ReturnVariable="isProductBundleProductCopied">
				<cfinvokeargument Name="productBundleID_old" Value="#Arguments.productBundleID#">
				<cfinvokeargument Name="productBundleID_new" Value="#currentProductBundleID#">
			</cfinvoke>
		</cfif>

		<cfreturn currentProductBundleID>
	</cfif>
</cffunction>

</cfcomponent>
