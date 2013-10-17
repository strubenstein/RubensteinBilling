<cfcomponent DisplayName="UserProductFavorite" Hint="Manages inserting, updating, deleting and viewing product favorites">

<cffunction name="maxlength_UserProductFavorite" access="public" output="no" returnType="struct">
	<cfset var maxlength_UserProductFavorite = StructNew()>

	<cfset maxlength_UserProductFavorite.userProductFavoriteQuantity = 4>

	<cfreturn maxlength_UserProductFavorite>
</cffunction>

<cffunction Name="insertUserProductFavorite" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new product favorite. Returns True.">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userProductFavoriteStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="userProductFavoriteQuantity" Type="numeric" Required="No" Default="1">

	<cfinvoke component="#Application.billingMapping#data.UserProductFavorite" method="maxlength_UserProductFavorite" returnVariable="maxlength_UserProductFavorite" />

	<cfset updateUserProductFavorite(Arguments.productID, Arguments.userID, 1)>

	<cfquery Name="qry_insertUserProductFavorite" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avUserProductFavorite
		(
			productID, userID, userProductFavoriteQuantity, userProductFavoriteStatus,
			userProductFavoriteDateCreated, userProductFavoriteDateUpdated
		)
		SELECT 
			productID,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userProductFavoriteQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_UserProductFavorite.userProductFavoriteQuantity#">,
			<cfqueryparam Value="#Arguments.userProductFavoriteStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		FROM avProduct
		WHERE productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND productID NOT IN 
				(
				SELECT productID
				FROM avUserProductFavorite
				WHERE userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
					AND productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateUserProductFavorite" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing product favorite. Returns True.">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userProductFavoriteStatus" Type="numeric" Required="No">
	<cfargument Name="userProductFavoriteQuantity" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.UserProductFavorite" method="maxlength_UserProductFavorite" returnVariable="maxlength_UserProductFavorite" />

	<cfquery Name="qry_updateUserProductFavorite" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avUserProductFavorite
		SET
			<cfif StructKeyExists(Arguments, "userProductFavoriteQuantity") and IsNumeric(Arguments.userProductFavoriteQuantity)>
				userProductFavoriteQuantity = <cfqueryparam Value="#Arguments.userProductFavoriteQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_UserProductFavorite.userProductFavoriteQuantity#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "userProductFavoriteStatus") and ListFind("0,1", Arguments.userProductFavoriteStatus)>
				userProductFavoriteStatus = <cfqueryparam Value="#Arguments.userProductFavoriteStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			userProductFavoriteDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectUserProductFavorite" Access="public" Output="No" ReturnType="query" Hint="Select existing favorite product for a user">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">

	<cfset var qry_selectUserProductFavorite = QueryNew("blank")>

	<cfquery Name="qry_selectUserProductFavorite" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productID, userID, userProductFavoriteStatus, userProductFavoriteQuantity, 
			userProductFavoriteDateCreated, userProductFavoriteDateUpdated
		FROM avUserProductFavorite
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectUserProductFavorite>
</cffunction>

<cffunction Name="selectProductFavoriteList" Access="public" Output="No" ReturnType="query" Hint="Select existing favorite product(s) for user(s)">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="userProductFavoriteStatus" Type="numeric" Required="No">
	<cfargument Name="languageID" Type="numeric" Required="No" Default="0">
	<cfargument Name="selectProductInfo" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectUserProductFavoriteList = QueryNew("blank")>
	<cfset var displayAnd = False>

	<cfquery Name="qry_selectUserProductFavoriteList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUserProductFavorite.productID, avUserProductFavorite.userID,
			avUserProductFavorite.userProductFavoriteStatus, avUserProductFavorite.userProductFavoriteQuantity, 
			avUserProductFavorite.userProductFavoriteDateCreated, avUserProductFavorite.userProductFavoriteDateUpdated
		<cfif Arguments.selectProductInfo is False>
			FROM avUserProductFavorite
			WHERE 
		<cfelse>
				, avProduct.productCode, avProduct.productPrice, avProduct.productWeight,
				avProduct.productHasCustomPrice, avProduct.productID_custom, avProduct.productInWarehouse,
				avProduct.productID_parent, avProduct.productIsBundle, avProductLanguage.productLanguageName,
				avProductLanguage.productLanguageLineItemName, avProductLanguage.productLanguageLineItemDescription
			FROM avUserProductFavorite, avProduct, avProductLanguage
			WHERE avUserProductFavorite.productID = avProduct.productID
				AND avProduct.productID = avProductLanguage.productID
				AND avProductLanguage.productLanguageStatus = 1
				AND avProductLanguage.languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_tinyint">
			<cfset displayAnd = True>
		</cfif>
		<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
			<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
			avUserProductFavorite.productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfif>
		<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
			<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
			avUserProductFavorite.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfif>
		<cfif StructKeyExists(Arguments, "userProductFavoriteStatus") and ListFind("0,1", Arguments.userProductFavoriteStatus)>
			<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
			avUserProductFavorite.userProductFavoriteStatus = <cfqueryparam Value="#Arguments.userProductFavoriteStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		</cfif>
		<cfif displayAnd is False>
			avUserProductFavorite.productID < 0
		</cfif>
		ORDER BY avUserProductFavorite.userProductFavoriteStatus DESC, avUserProductFavorite.userProductFavoriteDateCreated DESC
	</cfquery>

	<cfreturn qry_selectUserProductFavoriteList>
</cffunction>

<cffunction Name="deleteUserProductFavorite" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing favorite product(s) for user(s)">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="userProductFavoriteStatus" Type="numeric" Required="No">

	<cfset var displayAnd = False>

	<cfquery Name="qry_deleteUserProductFavorite" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avUserProductFavorite
		WHERE 
			<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "userProductFavoriteStatus") and ListFind("0,1", Arguments.userProductFavoriteStatus)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				userProductFavoriteStatus = <cfqueryparam Value="#Arguments.userProductFavoriteStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif displayAnd is False>
				productID < 0
			</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>

