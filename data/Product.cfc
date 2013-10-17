<cfcomponent DisplayName="Product" Hint="Manages inserting, updating, deleting and viewing products">

<cffunction name="maxlength_Product" access="public" output="no" returnType="struct">
	<cfset var maxlength_Product = StructNew()>

	<cfset maxlength_Product.productName = 255>
	<cfset maxlength_Product.productID_custom = 50>
	<cfset maxlength_Product.productCode = 20>
	<cfset maxlength_Product.templateFilename = 50>
	<cfset maxlength_Product.productPrice = 4>
	<cfset maxlength_Product.productWeight = 2>

	<cfreturn maxlength_Product>
</cffunction>

<cffunction Name="insertProduct" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new product. Returns productID.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_manager" Type="numeric" Required="No" Default="0">
	<cfargument Name="vendorID" Type="numeric" Required="No" Default="0">
	<cfargument Name="productCode" Type="string" Required="No" Default="">
	<cfargument Name="productName" Type="string" Required="Yes">
	<cfargument Name="productPrice" Type="numeric" Required="Yes">
	<cfargument Name="productPriceCallForQuote" Type="numeric" Required="No" Default="0">
	<cfargument Name="productWeight" Type="numeric" Required="No" Default="0">
	<cfargument Name="productStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="productListedOnSite" Type="numeric" Required="No" Default="1">
	<cfargument Name="productHasSpec" Type="numeric" Required="No" Default="0">
	<cfargument Name="productCanBePurchased" Type="numeric" Required="No" Default="1">
	<cfargument Name="productDisplayChildren" Type="numeric" Required="No" Default="0">
	<cfargument Name="productHasImage" Type="numeric" Required="No" Default="0">
	<cfargument Name="productHasCustomPrice" Type="numeric" Required="No" Default="0">
	<cfargument Name="productViewCount" Type="numeric" Required="No" Default="0">
	<cfargument Name="productInBundle" Type="numeric" Required="No" Default="0">
	<cfargument Name="productIsBundle" Type="numeric" Required="No" Default="0">
	<cfargument Name="productIsRecommended" Type="numeric" Required="No" Default="0">
	<cfargument Name="productHasRecommendation" Type="numeric" Required="No" Default="0">
	<cfargument Name="productIsDateRestricted" Type="numeric" Required="No" Default="0">
	<cfargument Name="productIsDateAvailable" Type="numeric" Required="No" Default="1">
	<cfargument Name="productID_custom" Type="string" Required="No" Default="">
	<cfargument Name="templateFilename" Type="string" Required="No" Default="">
	<cfargument Name="productCatalogPageNumber" Type="numeric" Required="No" Default="0">
	<cfargument Name="productID_parent" Type="numeric" Required="No" Default="0">
	<cfargument Name="productChildType" Type="numeric" Required="No" Default="0">
	<cfargument Name="productHasChildren" Type="numeric" Required="No" Default="0">
	<cfargument Name="productChildOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="productChildSeparate" Type="numeric" Required="No" Default="0">
	<cfargument Name="productInWarehouse" Type="numeric" Required="No" Default="0">
	<cfargument Name="productHasParameter" Type="numeric" Required="No" Default="0">
	<cfargument Name="productHasParameterException" Type="numeric" Required="No" Default="0">
	<cfargument Name="productIsExported" Type="string" Required="No" Default="">
	<cfargument Name="productDateExported" Type="string" Required="No" Default="">

	<cfset var qry_insertProduct = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Product" method="maxlength_Product" returnVariable="maxlength_Product" />

	<cfquery Name="qry_insertProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avProduct
		(
			companyID, userID_author, userID_manager, vendorID, productCode, productName, productPrice, productPriceCallForQuote,
			productWeight, productStatus, productListedOnSite, productHasSpec, productCanBePurchased, productDisplayChildren,
			productHasImage, productHasCustomPrice, productViewCount, productInBundle, productIsBundle, productIsBundleChanged,
			productIsRecommended, productHasRecommendation, productIsDateRestricted, productIsDateAvailable, productID_custom,
			templateFilename, productCatalogPageNumber, productID_parent, productChildType, productHasChildren, productChildOrder,
			productChildSeparate, productInWarehouse, productHasParameter, productHasParameterException, productIsExported,
			productDateExported, productDateCreated, productDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_manager#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.vendorID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Product.productCode#">,
			<cfqueryparam Value="#Arguments.productName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Product.productName#">,
			<cfqueryparam Value="#Arguments.productPrice#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.productPriceCallForQuote#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productWeight#" cfsqltype="cf_sql_decimal" Scale="#maxlength_Product.productWeight#">,
			<cfqueryparam Value="#Arguments.productStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productListedOnSite#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productHasSpec#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productCanBePurchased#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productDisplayChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productHasImage#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productHasCustomPrice#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productViewCount#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productInBundle#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productIsBundle#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productIsRecommended#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productHasRecommendation#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productIsDateRestricted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productIsDateAvailable#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Product.productID_custom#">,
			<cfqueryparam Value="#Arguments.templateFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Product.templateFilename#">,
			<cfqueryparam Value="#Arguments.productCatalogPageNumber#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.productID_parent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productChildType#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.productHasChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productChildOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.productChildSeparate#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productInWarehouse#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productHasParameter#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productHasParameterException#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not ListFind("0,1", Arguments.productIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.productIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.productDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.productDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "productID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertProduct.primaryKeyID>
</cffunction>

<cffunction Name="updateProduct" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing product. Returns True.">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="userID_manager" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="numeric" Required="No">
	<cfargument Name="productCode" Type="string" Required="No">
	<cfargument Name="productName" Type="string" Required="No">
	<cfargument Name="productPrice" Type="numeric" Required="No">
	<cfargument Name="productPriceCallForQuote" Type="numeric" Required="No">
	<cfargument Name="productWeight" Type="numeric" Required="No">
	<cfargument Name="productStatus" Type="numeric" Required="No">
	<cfargument Name="productListedOnSite" Type="numeric" Required="No">
	<cfargument Name="productHasSpec" Type="numeric" Required="No">
	<cfargument Name="productCanBePurchased" Type="numeric" Required="No">
	<cfargument Name="productDisplayChildren" Type="numeric" Required="No">
	<cfargument Name="productHasImage" Type="numeric" Required="No">
	<cfargument Name="productHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="productViewCount" Type="numeric" Required="No">
	<cfargument Name="productInBundle" Type="numeric" Required="No">
	<cfargument Name="productIsBundle" Type="numeric" Required="No">
	<cfargument Name="productIsBundleChanged" Type="numeric" Required="No">
	<cfargument Name="productIsRecommended" Type="numeric" Required="No">
	<cfargument Name="productHasRecommendation" Type="numeric" Required="No">
	<cfargument Name="productIsDateRestricted" Type="numeric" Required="No">
	<cfargument Name="productIsDateAvailable" Type="numeric" Required="No">
	<cfargument Name="productID_custom" Type="string" Required="No">
	<cfargument Name="templateFilename" Type="string" Required="No">
	<cfargument Name="productCatalogPageNumber" Type="numeric" Required="No">
	<cfargument Name="productID_parent" Type="numeric" Required="No">
	<cfargument Name="productChildType" Type="numeric" Required="No">
	<cfargument Name="productHasChildren" Type="numeric" Required="No">
	<cfargument Name="productChildOrder" Type="numeric" Required="No">
	<cfargument Name="productChildSeparate" Type="numeric" Required="No">
	<cfargument Name="productInWarehouse" Type="numeric" Required="No">
	<cfargument Name="productHasParameter" Type="numeric" Required="No">
	<cfargument Name="productHasParameterException" Type="numeric" Required="No">
	<cfargument Name="productIsExported" Type="string" Required="No">
	<cfargument Name="productDateExported" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Product" method="maxlength_Product" returnVariable="maxlength_Product" />

	<cfquery Name="qry_updateProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProduct
		SET
			<cfif StructKeyExists(Arguments, "userID_manager")>userID_manager = <cfqueryparam Value="#Arguments.userID_manager#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "vendorID")>vendorID = <cfqueryparam Value="#Arguments.vendorID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "productCode")>productCode = <cfqueryparam Value="#Arguments.productCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Product.productCode#">,</cfif>
			<cfif StructKeyExists(Arguments, "productName")>productName = <cfqueryparam Value="#Arguments.productName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Product.productName#">,</cfif>
			<cfif StructKeyExists(Arguments, "productPrice")>productPrice = <cfqueryparam Value="#Arguments.productPrice#" cfsqltype="cf_sql_money">,</cfif>
			<cfif StructKeyExists(Arguments, "productPriceCallForQuote")>productPriceCallForQuote = <cfqueryparam Value="#Arguments.productPriceCallForQuote#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productWeight")>productWeight = <cfqueryparam Value="#Arguments.productWeight#" cfsqltype="cf_sql_decimal" Scale="#maxlength_Product.productWeight#">,</cfif>
			<cfif StructKeyExists(Arguments, "productStatus")>
				productStatus = <cfqueryparam Value="#Arguments.productStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfif Arguments.productStatus is 1 and Not StructKeyExists(Arguments, "productIsBundleChanged")>
					productIsBundleChanged = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				</cfif>
			</cfif>
			<cfif StructKeyExists(Arguments, "productListedOnSite")>productListedOnSite = <cfqueryparam Value="#Arguments.productListedOnSite#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productHasSpec")>productHasSpec = <cfqueryparam Value="#Arguments.productHasSpec#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productCanBePurchased")>productCanBePurchased = <cfqueryparam Value="#Arguments.productCanBePurchased#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productDisplayChildren")>productDisplayChildren = <cfqueryparam Value="#Arguments.productDisplayChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productHasImage")>productHasImage = <cfqueryparam Value="#Arguments.productHasImage#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productHasCustomPrice")>productHasCustomPrice = <cfqueryparam Value="#Arguments.productHasCustomPrice#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productViewCount")>productViewCount = <cfqueryparam Value="#Arguments.productViewCount#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "productInBundle")>productInBundle = <cfqueryparam Value="#Arguments.productInBundle#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productIsBundle")>productIsBundle = <cfqueryparam Value="#Arguments.productIsBundle#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productIsBundleChanged")>productIsBundleChanged = <cfqueryparam Value="#Arguments.productIsBundleChanged#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productIsRecommended")>productIsRecommended = <cfqueryparam Value="#Arguments.productIsRecommended#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productHasRecommendation")>productHasRecommendation = <cfqueryparam Value="#Arguments.productHasRecommendation#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productIsDateRestricted")>productIsDateRestricted = <cfqueryparam Value="#Arguments.productIsDateRestricted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productIsDateAvailable")>productIsDateAvailable = <cfqueryparam Value="#Arguments.productIsDateAvailable#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productID_custom")>productID_custom = <cfqueryparam Value="#Arguments.productID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Product.productID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "templateFilename")>templateFilename = <cfqueryparam Value="#Arguments.templateFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Product.templateFilename#">,</cfif>
			<cfif StructKeyExists(Arguments, "productCatalogPageNumber")>productCatalogPageNumber = <cfqueryparam Value="#Arguments.productCatalogPageNumber#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "productID_parent")>productID_parent = <cfqueryparam Value="#Arguments.productID_parent#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "productChildType")>productChildType = <cfqueryparam Value="#Arguments.productChildType#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "productHasChildren")>productHasChildren = <cfqueryparam Value="#Arguments.productHasChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productChildOrder")>productChildOrder = <cfqueryparam Value="#Arguments.productChildOrder#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "productChildSeparate")>productChildSeparate = <cfqueryparam Value="#Arguments.productChildSeparate#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productInWarehouse")>productInWarehouse = <cfqueryparam Value="#Arguments.productInWarehouse#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productHasParameter")>productHasParameter = <cfqueryparam Value="#Arguments.productHasParameter#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productHasParameterException")>productHasParameterException = <cfqueryparam Value="#Arguments.productHasParameterException#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productIsExported")>productIsExported = <cfif Not ListFind("0,1", Arguments.productIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.productIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "productDateExported")>productDateExported = <cfif Not IsDate(Arguments.productDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.productDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			productDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkProductPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check Company Permission for Existing Product">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_checkProductPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.productID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkProductPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT companyID
			FROM avProduct
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfif qry_checkProductPermission.RecordCount is 0 or qry_checkProductPermission.RecordCount is not ListLen(Arguments.productID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectProduct" Access="public" Output="No" ReturnType="query" Hint="Select Existing Product">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="returnProductLanguage" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnUserInfo" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectProduct = QueryNew("blank")>
	<cfset var qry_selectProductAndLanguage = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.productID)>
		<cfset Arguments.productID = 0>
	</cfif>

	<cfif Arguments.returnProductLanguage is False>
		<cfquery Name="qry_selectProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT avProduct.productID, avProduct.companyID, avProduct.userID_author, avProduct.userID_manager, avProduct.vendorID, avProduct.productCode,
				avProduct.productName, avProduct.productPrice, avProduct.productPriceCallForQuote, avProduct.productWeight, avProduct.productStatus,
				avProduct.productListedOnSite, avProduct.productHasSpec, avProduct.productCanBePurchased, avProduct.productDisplayChildren,
				avProduct.productHasImage, avProduct.productHasCustomPrice, avProduct.productViewCount, avProduct.productInBundle,
				avProduct.productIsBundle, avProduct.productIsBundleChanged, avProduct.productIsRecommended, avProduct.productHasRecommendation,
				avProduct.productIsDateRestricted, avProduct.productIsDateAvailable, avProduct.productID_custom, avProduct.templateFilename,
				avProduct.productCatalogPageNumber, avProduct.productID_parent, avProduct.productChildType, avProduct.productChildOrder,
				avProduct.productChildSeparate, avProduct.productHasChildren, avProduct.productInWarehouse, avProduct.productHasParameter,
				avProduct.productHasParameterException, avProduct.productIsExported, avProduct.productDateExported,
				avProduct.productDateCreated, avProduct.productDateUpdated
				<cfif Arguments.returnUserInfo is True>
					, Author.firstName AS firstName_author, Author.lastName AS lastName_author, Author.username AS username_author, Author.email AS email_author,
					Manager.firstName AS firstName_manager, Manager.lastName AS lastName_manager, Manager.username AS username_manager, Manager.email AS email_manager
				</cfif>
			FROM avProduct
				<cfif Arguments.returnUserInfo is True>
					LEFT OUTER JOIN avUser AS Author ON avProduct.userID_author = Author.userID
					LEFT OUTER JOIN avUser AS Manager ON avProduct.userID_manager = Manager.userID
				</cfif>
			WHERE avProduct.productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn qry_selectProduct>
	<cfelse>
		<cfquery Name="qry_selectProductAndLanguage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT avProduct.productID, avProduct.companyID, avProduct.userID_author, avProduct.userID_manager,
				avProduct.vendorID, avProduct.productCode, avProduct.productName, avProduct.productPrice,
				avProduct.productPriceCallForQuote, avProduct.productWeight, avProduct.productStatus,
				avProduct.productListedOnSite, avProduct.productHasSpec, avProduct.productCanBePurchased,
				avProduct.productDisplayChildren, avProduct.productHasImage, avProduct.productHasCustomPrice,
				avProduct.productViewCount, avProduct.productInBundle, avProduct.productIsBundle,
				avProduct.productIsBundleChanged, avProduct.productIsRecommended, avProduct.productHasRecommendation,
				avProduct.productIsDateRestricted, avProduct.productIsDateAvailable, avProduct.productID_custom,
				avProduct.templateFilename, avProduct.productCatalogPageNumber, avProduct.productID_parent,
				avProduct.productChildType, avProduct.productChildOrder, avProduct.productChildSeparate,
				avProduct.productHasChildren, avProduct.productInWarehouse, avProduct.productHasParameter,
				avProduct.productHasParameterException, avProduct.productIsExported, avProduct.productDateExported,
				avProduct.productDateCreated, avProduct.productDateUpdated,
				avProductLanguage.productLanguageStatus, avProductLanguage.userID,
				avProductLanguage.productLanguageName, avProductLanguage.productLanguageLineItemName,
				avProductLanguage.productLanguageLineItemDescription, avProductLanguage.productLanguageLineItemDescriptionHtml,
				avProductLanguage.productLanguageSummary, avProductLanguage.productLanguageSummaryHtml,
				avProductLanguage.productLanguageDescription, avProductLanguage.productLanguageDescriptionHtml,
				avProductLanguage.productLanguageDateCreated, avProductLanguage.productLanguageDateUpdated
			FROM avProduct, avProductLanguage
			WHERE avProduct.productID = avProductLanguage.productID
				AND avProduct.productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND avProductLanguage.languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">
				AND avProductLanguage.productLanguageStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		</cfquery>

		<cfreturn qry_selectProductAndLanguage>
	</cfif>
</cffunction>

<cffunction Name="selectProductIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects product via custom ID and returns productID if exists, 0 if not exists, and -1 if multiple products have the same productID_custom.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="productID_custom" Type="string" Required="Yes">

	<cfset var qry_selectProductIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectProductIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productID
		FROM avProduct
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND productID_custom IN (<cfqueryparam Value="#Arguments.productID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectProductIDViaCustomID.RecordCount is 0 or qry_selectProductIDViaCustomID.RecordCount lt ListLen(Arguments.productID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectProductIDViaCustomID.RecordCount gt ListLen(Arguments.productID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectProductIDViaCustomID.productID)>
	</cfif>
</cffunction>

<cffunction Name="selectProductSummary" Access="public" Output="No" ReturnType="query" Hint="Select Existing Product Summary">
	<cfargument Name="productID" Type="numeric" Required="Yes">

	<cfset var qry_selectProductSummary = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Product" method="selectProduct" returnVariable="qry_selectProduct">
		<cfinvokeargument name="productID" value="#Arguments.productID#">
	</cfinvoke>

	<cfquery Name="qry_selectProductSummary" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			(SELECT COUNT(targetID) FROM avImage WHERE primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("productID")#" cfsqltype="cf_sql_integer"> AND targetID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer"> AND imageStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND imageIsThumbnail = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS productImageCount,
			(SELECT COUNT(targetID) FROM avImage WHERE primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("productID")#" cfsqltype="cf_sql_integer"> AND targetID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer"> AND imageStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND imageIsThumbnail = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS productThumbnailCount,
			(SELECT COUNT(productID_target) FROM avProductRecommend WHERE productID_target = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer"> AND productRecommendStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS productRecommendsCount,
			(SELECT COUNT(productID_recommend) FROM avProductRecommend WHERE productID_recommend = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer"> AND productRecommendStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS productRecommendedCount,
			<cfif qry_selectProduct.productIsBundle is 0>
				(SELECT COUNT(avProductBundleProduct.productID) FROM avProductBundleProduct, avProductBundle WHERE avProductBundleProduct.productBundleID = avProductBundle.productBundleID AND avProductBundle.productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer"> AND avProductBundle.productBundleStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS productInBundleCount,
			</cfif>
			<cfif qry_selectProduct.productID_parent is not 0>
				(SELECT productName FROM avProduct WHERE productID = <cfqueryparam Value="#qry_selectProduct.productID_parent#" cfsqltype="cf_sql_integer">) AS parentProductName,
			</cfif>
			(SELECT COUNT(productID) FROM avPrice WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer"> AND priceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS productCustomPriceCount
	</cfquery>

	<cfreturn qry_selectProductSummary>
</cffunction>

<cffunction Name="selectProductManagerList" Access="public" Output="No" ReturnType="query" Hint="Select Existing Product Managers">
	<cfargument Name="companyID" Type="numeric" Required="No">

	<cfset var qry_selectProductManagerList = QueryNew("blank")>

	<cfquery Name="qry_selectProductManagerList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT DISTINCT(avProduct.userID_manager), avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avUser, avProduct
		WHERE avUser.userID = avProduct.userID_manager
			AND avProduct.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
		GROUP BY avProduct.userID_manager, avUser.lastName, avUser.firstName, avUser.userID_custom
		ORDER BY avUser.lastName, avUser.firstName
	</cfquery>

	<cfreturn qry_selectProductManagerList>
</cffunction>

<cffunction Name="switchProductChildOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch product child order">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productChildOrder_direction" Type="string" Required="Yes">
	<cfargument Name="productID_child" Type="numeric" Required="Yes">

	<cfset var qry_selectProductChildOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchProductChildOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProduct
		SET productChildOrder = productChildOrder 
			<cfif Arguments.productChildOrder_direction is "moveChildProductDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE productID = <cfqueryparam Value="#Arguments.productID_child#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avProduct INNER JOIN avProduct AS avProduct2
			SET avProduct.productChildOrder = avProduct.productChildOrder 
				<cfif Arguments.productChildOrder_direction is "moveChildProductDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avProduct.productChildOrder = avProduct.productChildOrder
				AND avProduct.productID_parent = avProduct2.productID_parent
				AND avProduct.productID_parent = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				AND avProduct.productID <> <cfqueryparam Value="#Arguments.productID_child#" cfsqltype="cf_sql_integer">
				AND avProduct2.productID = <cfqueryparam Value="#Arguments.productID_child#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avProduct
			SET 
			WHERE productID_parent = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				AND productID <> <cfqueryparam Value="#Arguments.productID_child#" cfsqltype="cf_sql_integer">
				AND productChildOrder = (SELECT productChildOrder FROM avProduct WHERE productID = <cfqueryparam Value="#Arguments.productID_child#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>


<!--- functions for viewing list of products --->
<cffunction Name="selectProductList" Access="public" ReturnType="query" Hint="Select list of products">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="categoryID_sub" Type="numeric" Required="No">
	<cfargument Name="categoryID_multiple" Type="numeric" Required="No">
	<cfargument Name="categoryID_list" Type="string" Required="No">
	<cfargument Name="userID_manager" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="numeric" Required="No">
	<cfargument Name="productStatus" Type="numeric" Required="No">
	<cfargument Name="productHasImage" Type="numeric" Required="No">
	<cfargument Name="productListedOnSite" Type="numeric" Required="No">
	<cfargument Name="productHasSpec" Type="numeric" Required="No">
	<cfargument Name="productCanBePurchased" Type="numeric" Required="No">
	<cfargument Name="productID_parent" Type="numeric" Required="No">
	<cfargument Name="productInBundle" Type="numeric" Required="No">
	<cfargument Name="productIsBundle" Type="numeric" Required="No">
	<cfargument Name="productIsRecommended" Type="numeric" Required="No">
	<cfargument Name="productHasRecommendation" Type="numeric" Required="No">
	<cfargument Name="productIsDateRestricted" Type="numeric" Required="No">
	<cfargument Name="productIsDateAvailable" Type="numeric" Required="No">
	<cfargument Name="productHasChildren" Type="numeric" Required="No">
	<cfargument Name="productHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="productPriceCallForQuote" Type="numeric" Required="No">
	<cfargument Name="productCatalogPageNumber" Type="string" Required="No">
	<cfargument Name="productPrice" Type="numeric" Required="No">
	<cfargument Name="productPrice_min" Type="numeric" Required="No">
	<cfargument Name="productPrice_max" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="productName" Type="string" Required="No">
	<cfargument Name="productID_custom" Type="string" Required="No">
	<cfargument Name="productCode" Type="string" Required="No">
	<cfargument Name="productLanguageSummary" Type="string" Required="No">
	<cfargument Name="productLanguageDescription" Type="string" Required="No">
	<cfargument Name="templateFilename" Type="string" Required="No">
	<cfargument Name="productInWarehouse" Type="numeric" Required="No">
	<cfargument Name="productWeight" Type="numeric" Required="No">
	<cfargument Name="productWeight_min" Type="numeric" Required="No">
	<cfargument Name="productWeight_max" Type="numeric" Required="No">
	<cfargument Name="productHasParameter" Type="numeric" Required="No">
	<cfargument Name="productHasParameterException" Type="numeric" Required="No">
	<cfargument Name="productID_not" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="numeric" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="productIsExported" Type="string" Required="No">
	<cfargument Name="productDateExported_from" Type="string" Required="No">
	<cfargument Name="productDateExported_to" Type="string" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="no" default="productName">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="displayProductCategoryOrder" Type="boolean" Required="No">

	<cfset var queryParameters_orderBy = "avProduct.productName">
	<cfset var queryParameters_orderBy_noTable = "productName">
	<cfset var displayOr = False>
	<cfset var qry_selectProductList = QueryNew("blank")>

	<cfif StructKeyExists(Arguments, "displayProductCategoryOrder") and Arguments.displayProductCategoryOrder is True and StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerPositive(Arguments.categoryID)>
		<cfset Arguments.displayProductCategoryOrder = True>
	<cfelse>
		<cfset Arguments.displayProductCategoryOrder = False>
	</cfif>	

	<cfswitch expression="#Arguments.queryOrderBy#">
	 <cfcase value="productID,vendorID,productCode,productName,productPrice,productWeight,productViewCount,templateFilename,productCatalogPageNumber,productChildOrder,productDateUpdated"><cfset queryParameters_orderBy = "avProduct.#Arguments.queryOrderBy#"></cfcase>
	 <cfcase value="productID_d,vendorID_d,productCode_d,productName_d,productPrice_d,productWeight_d,productViewCount_d,templateFilename_d,productCatalogPageNumber_d,productChildOrder_d,productDateUpdated_d"><cfset queryParameters_orderBy = "avProduct.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	 <cfcase value="userID_author"><cfset queryParameters_orderBy = "avProduct.userID_author"></cfcase>
	 <cfcase value="userID_author_d"><cfset queryParameters_orderBy = "avProduct.userID_author DESC"></cfcase>
	 <cfcase value="userID_manager"><cfset queryParameters_orderBy = "avProduct.userID_manager"></cfcase>
	 <cfcase value="userID_manager_d"><cfset queryParameters_orderBy = "avProduct.userID_manager DESC"></cfcase>
	 <cfcase value="productID_custom"><cfset queryParameters_orderBy = "avProduct.productID_custom"></cfcase>
	 <cfcase value="productID_custom_d"><cfset queryParameters_orderBy = "avProduct.productID_custom DESC"></cfcase>
	 <cfcase value="productDateCreated"><cfset queryParameters_orderBy = "avProduct.productID"></cfcase>
	 <cfcase value="productDateCreated_d"><cfset queryParameters_orderBy = "avProduct.productID DESC"></cfcase>
	 <cfcase value="productID_parent"><cfset queryParameters_orderBy = "avProduct.productID_parent"></cfcase>
	 <cfcase value="productID_parent_d"><cfset queryParameters_orderBy = "avProduct.productID_parent DESC"></cfcase>
	 <cfcase value="productStatus,productListedOnSite,productHasSpec,productCanBePurchased"><cfset queryParameters_orderBy = "avProduct.#Arguments.queryOrderBy# DESC, avProduct.productName"></cfcase>
	 <cfcase value="productStatus_d,productListedOnSite_d,productHasSpec_d,productCanBePurchased_d"><cfset queryParameters_orderBy = "avProduct.#ListFirst(Arguments.queryOrderBy, '_')#, avProduct.productName"></cfcase>
	 <cfcase value="productCategoryOrder,productCategoryOrder_d">
		<cfif StructKeyExists(Arguments, "displayProductCategoryOrder") and Arguments.displayProductCategoryOrder is False>
			<cfset queryParameters_orderBy = "avProduct.productName">
		<cfelseif Arguments.queryOrderBy is "productCategoryOrder">
			<cfset queryParameters_orderBy = "avProductCategory.productCategoryOrder">
		<cfelse>
			<cfset queryParameters_orderBy = "avProductCategory.productCategoryOrder DESC">
		</cfif>
	 </cfcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avProductCategory,avProduct">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectProductList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avProduct.productID, avProduct.companyID, avProduct.userID_author, avProduct.userID_manager, avProduct.vendorID,
			avProduct.productCode, avProduct.productName, avProduct.productPrice, avProduct.productPriceCallForQuote,
			avProduct.productWeight, avProduct.productStatus, avProduct.productListedOnSite, avProduct.productHasImage,
			avProduct.productHasCustomPrice, avProduct.productHasSpec, avProduct.productCanBePurchased,
			avProduct.productDisplayChildren, avProduct.productChildType, avProduct.productViewCount, avProduct.productInBundle,
			avProduct.productIsBundle, avProduct.productIsRecommended, avProduct.productHasRecommendation, avProduct.productIsDateRestricted,
			avProduct.productIsDateAvailable, avProduct.productID_custom, avProduct.templateFilename, avProduct.productCatalogPageNumber,
			avProduct.productID_parent, avProduct.productHasChildren, avProduct.productChildOrder, avProduct.productChildSeparate,
			avProduct.productInWarehouse, avProduct.productHasParameter, avProduct.productHasParameterException,
			avProduct.productIsExported, avProduct.productDateExported, avProduct.productDateCreated, avProduct.productDateUpdated
			<cfif Arguments.displayProductCategoryOrder is True>, avProductCategory.productCategoryOrder, avProductCategory.productCategoryStatus</cfif>
		FROM avProduct
			<cfif StructKeyExists(Arguments, "searchText")>LEFT OUTER JOIN avProductLanguage ON avProduct.productID = avProductLanguage.productID AND avProductLanguage.productLanguageStatus = 1</cfif>
			<cfif Arguments.displayProductCategoryOrder is True>INNER JOIN avProductCategory ON avProduct.productID = avProductCategory.productID</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectProductList.cfm">
			<cfif Arguments.displayProductCategoryOrder is True>AND avProductCategory.categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "queryFirstLetter") and Arguments.queryFirstLetter is not "">
				<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
					AND Left(avProduct.productName, 1) < 'a'
				<cfelse><!--- letter --->
					AND (Left(avProduct.productName, 1) >= '#UCase(Arguments.queryFirstLetter)#' OR Left(avProduct.productName, 1) >= '#LCase(Arguments.queryFirstLetter)#')
				</cfif>
			</cfif>
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectProductList>
</cffunction>

<cffunction Name="selectProductCount" Access="public" ReturnType="numeric" Hint="Select total number of products in list">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="categoryID_sub" Type="numeric" Required="No">
	<cfargument Name="categoryID_multiple" Type="numeric" Required="No">
	<cfargument Name="categoryID_list" Type="string" Required="No">
	<cfargument Name="userID_manager" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="numeric" Required="No">
	<cfargument Name="productStatus" Type="numeric" Required="No">
	<cfargument Name="productHasImage" Type="numeric" Required="No">
	<cfargument Name="productListedOnSite" Type="numeric" Required="No">
	<cfargument Name="productHasSpec" Type="numeric" Required="No">
	<cfargument Name="productCanBePurchased" Type="numeric" Required="No">
	<cfargument Name="productID_parent" Type="numeric" Required="No">
	<cfargument Name="productInBundle" Type="numeric" Required="No">
	<cfargument Name="productIsBundle" Type="numeric" Required="No">
	<cfargument Name="productIsRecommended" Type="numeric" Required="No">
	<cfargument Name="productHasRecommendation" Type="numeric" Required="No">
	<cfargument Name="productIsDateRestricted" Type="numeric" Required="No">
	<cfargument Name="productIsDateAvailable" Type="numeric" Required="No">
	<cfargument Name="productHasChildren" Type="numeric" Required="No">
	<cfargument Name="productHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="productPriceCallForQuote" Type="numeric" Required="No">
	<cfargument Name="productCatalogPageNumber" Type="string" Required="No">
	<cfargument Name="productPrice" Type="numeric" Required="No">
	<cfargument Name="productPrice_min" Type="numeric" Required="No">
	<cfargument Name="productPrice_max" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="productName" Type="string" Required="No">
	<cfargument Name="productID_custom" Type="string" Required="No">
	<cfargument Name="productCode" Type="string" Required="No">
	<cfargument Name="productLanguageSummary" Type="string" Required="No">
	<cfargument Name="productLanguageDescription" Type="string" Required="No">
	<cfargument Name="templateFilename" Type="string" Required="No">
	<cfargument Name="productInWarehouse" Type="numeric" Required="No">
	<cfargument Name="productWeight" Type="numeric" Required="No">
	<cfargument Name="productWeight_min" Type="numeric" Required="No">
	<cfargument Name="productWeight_max" Type="numeric" Required="No">
	<cfargument Name="productHasParameter" Type="numeric" Required="No">
	<cfargument Name="productHasParameterException" Type="numeric" Required="No">
	<cfargument Name="productID_not" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="numeric" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="productIsExported" Type="string" Required="No">
	<cfargument Name="productDateExported_from" Type="string" Required="No">
	<cfargument Name="productDateExported_to" Type="string" Required="No">

	<cfset var displayOr = False>
	<cfset var qry_selectProductCount = QueryNew("blank")>

	<cfquery Name="qry_selectProductCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(avProduct.productID) AS totalRecords
		FROM avProduct
		<cfif StructKeyExists(Arguments, "searchText")>
			LEFT OUTER JOIN avProductLanguage ON avProduct.productID = avProductLanguage.productID AND avProductLanguage.productLanguageStatus = 1
		</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectProductList.cfm">
	</cfquery>

	<cfreturn qry_selectProductCount.totalRecords>
</cffunction>

<cffunction Name="selectProductList_alphabet" Access="public" ReturnType="query" Hint="Select the first letter in value of field by which list of products is ordered">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="categoryID_sub" Type="numeric" Required="No">
	<cfargument Name="categoryID_multiple" Type="numeric" Required="No">
	<cfargument Name="categoryID_list" Type="string" Required="No">
	<cfargument Name="userID_manager" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="numeric" Required="No">
	<cfargument Name="productStatus" Type="numeric" Required="No">
	<cfargument Name="productHasImage" Type="numeric" Required="No">
	<cfargument Name="productListedOnSite" Type="numeric" Required="No">
	<cfargument Name="productHasSpec" Type="numeric" Required="No">
	<cfargument Name="productCanBePurchased" Type="numeric" Required="No">
	<cfargument Name="productID_parent" Type="numeric" Required="No">
	<cfargument Name="productInBundle" Type="numeric" Required="No">
	<cfargument Name="productIsBundle" Type="numeric" Required="No">
	<cfargument Name="productIsRecommended" Type="numeric" Required="No">
	<cfargument Name="productHasRecommendation" Type="numeric" Required="No">
	<cfargument Name="productIsDateRestricted" Type="numeric" Required="No">
	<cfargument Name="productIsDateAvailable" Type="numeric" Required="No">
	<cfargument Name="productHasChildren" Type="numeric" Required="No">
	<cfargument Name="productHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="productPriceCallForQuote" Type="numeric" Required="No">
	<cfargument Name="productCatalogPageNumber" Type="string" Required="No">
	<cfargument Name="productPrice" Type="numeric" Required="No">
	<cfargument Name="productPrice_min" Type="numeric" Required="No">
	<cfargument Name="productPrice_max" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="productName" Type="string" Required="No">
	<cfargument Name="productID_custom" Type="string" Required="No">
	<cfargument Name="productCode" Type="string" Required="No">
	<cfargument Name="productLanguageSummary" Type="string" Required="No">
	<cfargument Name="productLanguageDescription" Type="string" Required="No">
	<cfargument Name="templateFilename" Type="string" Required="No">
	<cfargument Name="productInWarehouse" Type="numeric" Required="No">
	<cfargument Name="productWeight" Type="numeric" Required="No">
	<cfargument Name="productWeight_min" Type="numeric" Required="No">
	<cfargument Name="productWeight_max" Type="numeric" Required="No">
	<cfargument Name="productHasParameter" Type="numeric" Required="No">
	<cfargument Name="productHasParameterException" Type="numeric" Required="No">
	<cfargument Name="productID_not" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="numeric" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="productIsExported" Type="string" Required="No">
	<cfargument Name="productDateExported_from" Type="string" Required="No">
	<cfargument Name="productDateExported_to" Type="string" Required="No">

	<cfset var displayOr = False>
	<cfset var qry_selectProductList_alphabet = QueryNew("blank")>

	<cfquery Name="qry_selectProductList_alphabet" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Distinct(Left(avProduct.productName, 1)) AS firstLetter
		FROM avProduct
		<cfif StructKeyExists(Arguments, "searchText")>
			LEFT OUTER JOIN avProductLanguage ON avProduct.productID = avProductLanguage.productID AND avProductLanguage.productLanguageStatus = 1
		</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectProductList.cfm">
		ORDER BY firstLetter
	</cfquery>

	<cfreturn qry_selectProductList_alphabet>
</cffunction>

<cffunction Name="selectProductList_alphabetPage" Access="public" ReturnType="numeric" Hint="Select page which includes the first record where the first letter in value of field by which list of products is ordered">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="categoryID_sub" Type="numeric" Required="No">
	<cfargument Name="categoryID_multiple" Type="numeric" Required="No">
	<cfargument Name="categoryID_list" Type="string" Required="No">
	<cfargument Name="userID_manager" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="numeric" Required="No">
	<cfargument Name="productStatus" Type="numeric" Required="No">
	<cfargument Name="productHasImage" Type="numeric" Required="No">
	<cfargument Name="productListedOnSite" Type="numeric" Required="No">
	<cfargument Name="productHasSpec" Type="numeric" Required="No">
	<cfargument Name="productCanBePurchased" Type="numeric" Required="No">
	<cfargument Name="productID_parent" Type="numeric" Required="No">
	<cfargument Name="productInBundle" Type="numeric" Required="No">
	<cfargument Name="productIsBundle" Type="numeric" Required="No">
	<cfargument Name="productIsRecommended" Type="numeric" Required="No">
	<cfargument Name="productHasRecommendation" Type="numeric" Required="No">
	<cfargument Name="productIsDateRestricted" Type="numeric" Required="No">
	<cfargument Name="productIsDateAvailable" Type="numeric" Required="No">
	<cfargument Name="productHasChildren" Type="numeric" Required="No">
	<cfargument Name="productHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="productPriceCallForQuote" Type="numeric" Required="No">
	<cfargument Name="productCatalogPageNumber" Type="string" Required="No">
	<cfargument Name="productPrice" Type="numeric" Required="No">
	<cfargument Name="productPrice_min" Type="numeric" Required="No">
	<cfargument Name="productPrice_max" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="productName" Type="string" Required="No">
	<cfargument Name="productID_custom" Type="string" Required="No">
	<cfargument Name="productCode" Type="string" Required="No">
	<cfargument Name="productLanguageSummary" Type="string" Required="No">
	<cfargument Name="productLanguageDescription" Type="string" Required="No">
	<cfargument Name="templateFilename" Type="string" Required="No">
	<cfargument Name="productInWarehouse" Type="numeric" Required="No">
	<cfargument Name="productWeight" Type="numeric" Required="No">
	<cfargument Name="productWeight_min" Type="numeric" Required="No">
	<cfargument Name="productWeight_max" Type="numeric" Required="No">
	<cfargument Name="productHasParameter" Type="numeric" Required="No">
	<cfargument Name="productHasParameterException" Type="numeric" Required="No">
	<cfargument Name="productID_not" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="numeric" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="productIsExported" Type="string" Required="No">
	<cfargument Name="productDateExported_from" Type="string" Required="No">
	<cfargument Name="productDateExported_to" Type="string" Required="No">
	<cfargument Name="queryFirstLetter" Type="string" Required="Yes">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="Yes">

	<cfset var displayOr = False>
	<cfset var qry_selectProductList_alphabetPage = QueryNew("blank")>

	<cfquery Name="qry_selectProductList_alphabetPage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(avProduct.productID) AS recordCountBeforeAlphabet
		FROM avProduct
		<cfif StructKeyExists(Arguments, "searchText")>
			LEFT OUTER JOIN avProductLanguage ON avProduct.productID = avProductLanguage.productID AND avProductLanguage.productLanguageStatus = 1
		</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectProductList.cfm">
			<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
				AND Left(avProduct.productName, 1) < 'a'
			<cfelse><!--- letter --->
				AND (Left(avProduct.productName, 1) < '#UCase(Arguments.queryFirstLetter)#' OR Left(avProduct.productName, 1) < '#LCase(Arguments.queryFirstLetter)#')
			</cfif>
	</cfquery>

	<cfreturn 1 + (qry_selectProductList_alphabetPage.recordCountBeforeAlphabet \ Arguments.queryDisplayPerPage)>
</cffunction>
<!--- /functions for viewing list of products --->

<!--- Update Export Status --->
<cffunction Name="updateProductIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether product records have been exported. Returns True.">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="productIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.productID) or (Arguments.productIsExported is not "" and Not ListFind("0,1", Arguments.productIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateProductIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avProduct
			SET productIsExported = <cfif Not ListFind("0,1", Arguments.productIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.productIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				productDateExported = <cfif Not ListFind("0,1", Arguments.productIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>

