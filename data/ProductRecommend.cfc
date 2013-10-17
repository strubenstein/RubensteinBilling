<cfcomponent DisplayName="ProductRecommend" Hint="Manages products recommended for other products">

<cffunction Name="insertProductRecommend" Access="public" Output="No" ReturnType="boolean" Hint="Insert recommended products for product">
	<cfargument Name="productID_target" Type="numeric" Required="Yes">
	<cfargument Name="productID_recommend" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="productRecommendStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="productRecommendReverse" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_insertProductRecommend" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avProductRecommend
		(
			productID_target, productID_recommend, userID, productRecommendStatus,
			productRecommendReverse, productRecommendDateCreated, productRecommendDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productRecommendStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productRecommendReverse#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfinvoke component="#Application.billingMapping#data.ProductRecommend" Method="updateProduct_recommendTrue" ReturnVariable="isProductRecommendUpdatedTrue">
		<cfinvokeargument Name="productID_target" Value="#Arguments.productID_target#">
		<cfinvokeargument Name="productID_recommend" Value="#Arguments.productID_recommend#">
	</cfinvoke>

	<cfreturn True>
</cffunction>

<cffunction Name="insertProductRecommends_select" Access="public" Output="No" ReturnType="boolean" Hint="Insert multiple recommended products for product">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="productID_target" Type="numeric" Required="Yes">
	<cfargument Name="productID_recommend" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="productRecommendStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="productRecommendReverse" Type="numeric" Required="No" Default="0">
	<cfargument Name="productID_recommend_target" Type="string" Required="No" Default="">

	<cfset var qry_selectProductRecommended_select = QueryNew("blank")>

	<cftransaction>
	<cfquery Name="qry_selectProductRecommends_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productID_recommend
		FROM avProductRecommend
		WHERE productID_target = <cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">
			AND productID_recommend IN (<cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfquery Name="qry_insertProductRecommends_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avProductRecommend
		(
			productID_target, productID_recommend, userID, productRecommendStatus,
			productRecommendReverse, productRecommendDateCreated, productRecommendDateUpdated
		)
		SELECT
			<cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">,
			productID,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productRecommendStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		FROM avProduct
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND productID IN (<cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif qry_selectProductRecommends_select.RecordCount is not 0>
				AND productID NOT IN (<cfqueryparam Value="#ValueList(qry_selectProductRecommends_select.productID_recommend)#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>;

		UPDATE avProductRecommend
		SET productRecommendStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID_target = <cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">
			AND productID_recommend IN (<cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND productRecommendStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">;
	</cfquery>
	</cftransaction>

	<cfinvoke component="#Application.billingMapping#data.ProductRecommend" Method="updateProduct_recommendTrue" ReturnVariable="isProductRecommendUpdatedTrue">
		<cfinvokeargument Name="productID_target" Value="#Arguments.productID_target#">
		<cfinvokeargument Name="productID_recommend" Value="#Arguments.productID_recommend#">
	</cfinvoke>

	<cfreturn True>
</cffunction>

<cffunction Name="insertProductRecommended_select" Access="public" Output="No" ReturnType="boolean" Hint="Insert multiple recommended products for product">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="productID_target" Type="string" Required="Yes">
	<cfargument Name="productID_recommend" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="productRecommendStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="productRecommendReverse" Type="numeric" Required="No" Default="0">
	<cfargument Name="productID_target_recommend" Type="string" Required="No" Default="">

	<cfset var qry_selectProductRecommended_select = QueryNew("blank")>

	<cftransaction>
	<cfquery Name="qry_selectProductRecommended_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productID_target
		FROM avProductRecommend
		WHERE productID_recommend = <cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">
			AND productID_target IN (<cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>
	
	<cfquery Name="qry_insertProductRecommended_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avProductRecommend
		(
			productID_target, productID_recommend, userID, productRecommendStatus,
			productRecommendReverse, productRecommendDateCreated, productRecommendDateUpdated
		)
		SELECT
			productID,
			<cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productRecommendStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		FROM avProduct
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND productID IN (<cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif qry_selectProductRecommended_select.RecordCount is not 0>
				AND productID NOT IN (<cfqueryparam Value="#ValueList(qry_selectProductRecommended_select.productID_target)#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>;

		UPDATE avProductRecommend
		SET productRecommendStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID_recommend = <cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">
			AND productID_target IN (<cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND productRecommendStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">;
	</cfquery>
	</cftransaction>

	<cfinvoke component="#Application.billingMapping#data.ProductRecommend" Method="updateProduct_recommendTrue" ReturnVariable="isProductRecommendUpdatedTrue">
		<cfinvokeargument Name="productID_target" Value="#Arguments.productID_target#">
		<cfinvokeargument Name="productID_recommend" Value="#Arguments.productID_recommend#">
	</cfinvoke>

	<cfreturn True>
</cffunction>

<cffunction Name="updateProductRecommendsReverse" Access="public" Output="No" ReturnType="boolean" Hint="Update recommended reverse setting for product">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productID_list" Type="string" Required="Yes">

	<cfset var qry_selectProductRecommendReverse_target = QueryNew("blank")>
	<cfset var qry_selectProductRecommendReverse_recommend = QueryNew("blank")>

	<cftransaction>
	<cfquery Name="qry_selectProductRecommendReverse_target" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productID_target
		FROM avProductRecommend
		WHERE productID_recommend = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery Name="qry_updateProductRecommendReverse_target" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductRecommend
		SET productRecommendReverse = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productRecommendStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND productID_target = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productID_recommend IN (<cfqueryparam Value="#Arguments.productID_list#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif qry_selectProductRecommendReverse_target.RecordCount is not 0>
				AND productID_recommend IN (<cfqueryparam Value="#ValueList(qry_selectProductRecommendReverse_target.productID_target)#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
	</cfquery>

	<cfquery Name="qry_selectProductRecommendReverse_recommend" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productID_recommend
		FROM avProductRecommend
		WHERE productID_target = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery Name="qry_updateProductRecommendReverse_recommend" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductRecommend
		SET productRecommendReverse = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productRecommendStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND productID_recommend = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productID_target IN (<cfqueryparam Value="#Arguments.productID_list#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif qry_selectProductRecommendReverse_recommend.RecordCount is not 0>
				AND productID_target IN (<cfqueryparam Value="#ValueList(qry_selectProductRecommendReverse_recommend.productID_recommend)#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
	</cfquery>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="updateProductRecommend" Access="public" Output="No" ReturnType="boolean" Hint="Update recommended products for product">
	<cfargument Name="productID_target" Type="numeric" Required="Yes">
	<cfargument Name="productID_recommend" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="productRecommendStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="productRecommendReverse" Type="numeric" Required="No" Default="0">

	<cfset var qry_selectProduct_recommendTrue_reverse2 = QueryNew("blank")>

	<cfquery Name="qry_updateProductRecommend" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductRecommend
		SET 
			<cfif StructKeyExists(Arguments, "userID")>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "productRecommendStatus")>productRecommendStatus = <cfqueryparam Value="#Arguments.productRecommendStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productRecommendReverse")>productRecommendReverse = <cfqueryparam Value="#Arguments.productRecommendReverse#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			productRecommendDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productID_target = <cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">
			AND productID_recommend = <cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif StructKeyExists(Arguments, "productRecommendStatus")>
		<cfif Arguments.productRecommendStatus is 1>
			<cfinvoke component="#Application.billingMapping#data.ProductRecommend" Method="updateProduct_recommendTrue" ReturnVariable="isProductRecommendUpdatedTrue">
				<cfinvokeargument Name="productID_target" Value="#Arguments.productID_target#">
				<cfinvokeargument Name="productID_recommend" Value="#Arguments.productID_recommend#">
			</cfinvoke>
		<cfelse>
			<cfinvoke component="#Application.billingMapping#data.ProductRecommend" Method="updateProduct_recommendFalse" ReturnVariable="isProductRecommendUpdatedFalse">
				<cfinvokeargument Name="productID_target" Value="#Arguments.productID_target#">
				<cfinvokeargument Name="productID_recommend" Value="#Arguments.productID_recommend#">
			</cfinvoke>
		</cfif>
	</cfif>

	<cfreturn True>
</cffunction>

<cffunction Name="selectProductRecommendList" Access="public" Output="No" ReturnType="query" Hint="Select recommended products for product">
	<cfargument Name="productID_target" Type="numeric" Required="Yes">
	<cfargument Name="productID_recommend" Type="numeric" Required="Yes">
	<cfargument Name="productRecommendStatus" Type="numeric" Required="No">

	<cfset var qry_selectProductRecommendList = QueryNew("blank")>

	<cfquery Name="qry_selectProductRecommendList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avProductRecommend.productID_target, avProductRecommend.productID_recommend, avProductRecommend.userID,
			avProductRecommend.productRecommendStatus, avProductRecommend.productRecommendReverse,
			avProductRecommend.productRecommendDateCreated, avProductRecommend.productRecommendDateUpdated,
			avProduct.productID, avProduct.productName, avProduct.productCode, avProduct.productID_custom,
			avProduct.productStatus, avProduct.productListedOnSite, avProduct.productPrice, avProduct.productDateCreated
		FROM avProductRecommend, avProduct
		WHERE 
			<cfif Arguments.productID_target is not 0><!--- return products recommended for this product --->
				avProductRecommend.productID_recommend = avProduct.productID
				AND avProductRecommend.productID_target = <cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">
			<cfelse><!--- return products which recommend this product --->
				avProductRecommend.productID_target = avProduct.productID
				AND avProductRecommend.productID_recommend = <cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(Arguments, "productRecommendStatus") and ListFind("0,1", Arguments.productRecommendStatus)>
				AND avProductRecommend.productRecommendStatus = <cfqueryparam Value="#Arguments.productRecommendStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY avProduct.productName
	</cfquery>

	<cfreturn qry_selectProductRecommendList>
</cffunction>

<cffunction Name="updateProduct_recommendTrue" Access="public" Output="No" ReturnType="boolean" Hint="Updates product as recommended">
	<cfargument Name="productID_target" Type="numeric" Required="Yes">
	<cfargument Name="productID_recommend" Type="numeric" Required="Yes">

	<cfset var qry_selectProduct_recommendTrue_reverse2 = QueryNew("blank")>

	<cftransaction>
	<cfquery Name="qry_updateProduct_recommendTrue" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProduct
		SET productIsRecommended = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID IN (<cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">);
	
		UPDATE avProduct
		SET productHasRecommendation = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID IN (<cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">);
	
		UPDATE avProductRecommend
		SET productRecommendReverse = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID_target = <cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">
			AND productID_recommend = <cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">
			AND productRecommendStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;
	</cfquery>

	<cfquery Name="qry_selectProduct_recommendTrue_reverse2" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productID_recommend
		FROM avProductRecommend
		WHERE productID_target = <cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">
			AND productID_recommend = <cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">
			AND productRecommendStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>

	<cfquery Name="qry_updateProduct_recommendTrue_reverse2" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductRecommend
		SET productRecommendReverse = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID_target = <cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">
			AND productID_recommend = <cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">
			<cfif qry_selectProduct_recommendTrue_reverse2.RecordCount is not 0>
				AND productID_target IN (<cfqueryparam Value="#ValueList(qry_selectProduct_recommendTrue_reverse2.productID_recommend)#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
	</cfquery>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="updateProduct_recommendFalse" Access="public" Output="No" ReturnType="boolean" Hint="Updates product as not recommended">
	<cfargument Name="productID_target" Type="numeric" Required="Yes">
	<cfargument Name="productID_recommend" Type="numeric" Required="Yes">

	<cfquery Name="qry_updateProduct_recommendFalse" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProduct
		SET productIsRecommended = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID = <cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">
			AND productID NOT IN 
				(
				SELECT productID
				FROM avProductRecommend
				WHERE productID_recommend = <cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">
					AND productRecommendStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				);

		UPDATE avProduct
		SET productHasRecommendation = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID = <cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">
			AND productID NOT IN 
				(
				SELECT productID
				FROM avProductRecommend
				WHERE productID_target = <cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">
					AND productRecommendStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				);

		UPDATE avProductRecommend
		SET productRecommendReverse = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE productID_target = <cfqueryparam Value="#Arguments.productID_recommend#" cfsqltype="cf_sql_integer">
			AND productID_recommend = <cfqueryparam Value="#Arguments.productID_target#" cfsqltype="cf_sql_integer">;
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
