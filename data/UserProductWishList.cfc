<cfcomponent DisplayName="UserProductWishList" Hint="Manages inserting, updating, deleting and viewing product WishLists">

<cffunction name="maxlength_UserProductWishList" access="public" output="no" returnType="struct">
	<cfset var maxlength_UserProductWishList = StructNew()>

	<cfset maxlength_UserProductWishList.userProductWishListQuantity = 4>
	<cfset maxlength_UserProductWishList.userProductWishListComment = 255>

	<cfreturn maxlength_UserProductWishList>
</cffunction>

<cffunction Name="insertUserProductWishList" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new product WishList. Returns True.">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userProductWishListStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="userProductWishListQuantity" Type="numeric" Required="No" Default="1">
	<cfargument Name="userProductWishListFulfilled" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="No" Default="0">
	<cfargument Name="userProductWishListComment" Type="string" Required="No" Default="">
	<cfargument Name="userProductWishListRating" Type="numeric" Required="No" Default="0">
	<cfargument Name="addressID" Type="numeric" Required="No" Default="0">

	<cfinvoke component="#Application.billingMapping#data.UserProductWishList" method="maxlength_UserProductWishList" returnVariable="maxlength_UserProductWishList" />
	<cfset updateUserProductWishList(Arguments.productID, Arguments.userID, 1)>

	<cfquery Name="qry_insertUserProductWishList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avUserProductWishList
		(
			productID, userID, userProductWishListQuantity, userProductWishListStatus, userProductWishListFulfilled,
			invoiceLineItemID, userProductWishListComment, userProductWishListRating, addressID,
			userProductWishListDateCreated, userProductWishListDateUpdated
		)
		SELECT 
			productID,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userProductWishListQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_UserProductWishList.userProductWishListQuantity#">,
			<cfqueryparam Value="#Arguments.userProductWishListStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userProductWishListFulfilled#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userProductWishListComment#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_UserProductWishList.userProductWishListComment#">,
			<cfqueryparam Value="#Arguments.userProductWishListRating#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		FROM avProduct
		WHERE productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND productID NOT IN 
				(
				SELECT productID
				FROM avUserProductWishList
				WHERE userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
					AND productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateUserProductWishList" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing product WishList. Returns True.">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userProductWishListStatus" Type="numeric" Required="No">
	<cfargument Name="userProductWishListQuantity" Type="numeric" Required="No">
	<cfargument Name="userProductWishListFulfilled" Type="numeric" Required="No">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="No">
	<cfargument Name="userProductWishListComment" Type="string" Required="No">
	<cfargument Name="userProductWishListRating" Type="numeric" Required="No">
	<cfargument Name="addressID" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.UserProductWishList" method="maxlength_UserProductWishList" returnVariable="maxlength_UserProductWishList" />

	<cfquery Name="qry_updateUserProductWishList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avUserProductWishList
		SET
			<cfif StructKeyExists(Arguments, "userProductWishListQuantity") and IsNumeric(Arguments.userProductWishListQuantity)>
				userProductWishListQuantity = <cfqueryparam Value="#Arguments.userProductWishListQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_UserProductWishList.userProductWishListQuantity#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "userProductWishListStatus") and ListFind("0,1", Arguments.userProductWishListStatus)>
				userProductWishListStatus = <cfqueryparam Value="#Arguments.userProductWishListStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "userProductWishListFulfilled") and ListFind("0,1", Arguments.userProductWishListFulfilled)>
				userProductWishListFulfilled = <cfqueryparam Value="#Arguments.userProductWishListFulfilled#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "invoiceLineItemID") and Application.fn_IsIntegerNonNegative(Arguments.invoiceLineItemID)>
				invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif StructKeyExists(Arguments, "userProductWishListComment")>
				userProductWishListComment = <cfqueryparam Value="#Arguments.userProductWishListComment#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_UserProductWishList.userProductWishListComment#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "userProductWishListRating") and Application.fn_IsIntegerNonNegative(Arguments.userProductWishListRating)>
				userProductWishListRating = <cfqueryparam Value="#Arguments.userProductWishListRating#" cfsqltype="cf_sql_tinyint">,
			</cfif>
			<cfif StructKeyExists(Arguments, "addressID") and Application.fn_IsIntegerNonNegative(Arguments.addressID)>
				addressID = <cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer">,
			</cfif>
			userProductWishListDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectUserProductWishList" Access="public" Output="No" ReturnType="query" Hint="Select existing WishList product for a user">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">

	<cfset var qry_selectUserProductWishList = QueryNew("blank")>

	<cfquery Name="qry_selectUserProductWishList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productID, userID, userProductWishListStatus, userProductWishListQuantity, 
			userProductWishListFulfilled, invoiceLineItemID, userProductWishListComment,
			userProductWishListRating, addressID, userProductWishListDateCreated,
			userProductWishListDateUpdated
		FROM avUserProductWishList
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectUserProductWishList>
</cffunction>

<cffunction Name="selectProductWishListList" Access="public" Output="No" ReturnType="query" Hint="Select existing WishList product(s) for user(s)">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="userProductWishListStatus" Type="numeric" Required="No">
	<cfargument Name="userProductWishListFulfilled" Type="numeric" Required="No">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="languageID" Type="numeric" Required="No" Default="0">
	<cfargument Name="selectProductInfo" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectUserProductWishListList = QueryNew("blank")>
	<cfset var displayAnd = False>

	<cfquery Name="qry_selectUserProductWishListList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUserProductWishList.productID, avUserProductWishList.userID, avUserProductWishList.userProductWishListStatus,
			avUserProductWishList.userProductWishListQuantity, avUserProductWishList.userProductWishListFulfilled,
			avUserProductWishList.invoiceLineItemID, avUserProductWishList.userProductWishListComment,
			avUserProductWishList.userProductWishListRating, avUserProductWishList.addressID,
			avUserProductWishList.userProductWishListDateCreated, avUserProductWishList.userProductWishListDateUpdated
		<cfif Arguments.selectProductInfo is False>
			FROM avUserProductWishList
			WHERE 
		<cfelse>
				, avProduct.productCode, avProduct.productPrice, avProduct.productWeight,
				avProduct.productHasCustomPrice, avProduct.productID_custom, avProduct.productInWarehouse,
				avProduct.productID_parent, avProduct.productIsBundle, avProductLanguage.productLanguageName,
				avProductLanguage.productLanguageLineItemName, avProductLanguage.productLanguageLineItemDescription
			FROM avUserProductWishList, avProduct, avProductLanguage
			WHERE avUserProductWishList.productID = avProduct.productID
				AND avProduct.productID = avProductLanguage.productID
				AND avProductLanguage.productLanguageStatus = 1
				AND avProductLanguage.languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_tinyint">
			<cfset displayAnd = True>
		</cfif>
		<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
			<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
			avUserProductWishList.productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfif>
		<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
			<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
			avUserProductWishList.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfif>
		<cfif StructKeyExists(Arguments, "userProductWishListStatus") and ListFind("0,1", Arguments.userProductWishListStatus)>
			<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
			avUserProductWishList.userProductWishListStatus = <cfqueryparam Value="#Arguments.userProductWishListStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		</cfif>
		<cfif StructKeyExists(Arguments, "userProductWishListFulfilled") and ListFind("0,1", Arguments.userProductWishListFulfilled)>
			<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
			avUserProductWishList.userProductWishListFulfilled = <cfqueryparam Value="#Arguments.userProductWishListFulfilled#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		</cfif>
		<cfif StructKeyExists(Arguments, "invoiceLineItemID") and Application.fn_IsIntegerList(Arguments.invoiceLineItemID)>
			<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
			avUserProductWishList.invoiceLineItemID IN (<cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfif>
		<cfif displayAnd is False>
			avUserProductWishList.productID < 0
		</cfif>
		ORDER BY avUserProductWishList.userProductWishListStatus DESC, avUserProductWishList.userProductWishListDateCreated DESC
	</cfquery>

	<cfreturn qry_selectUserProductWishListList>
</cffunction>

<cffunction Name="deleteUserProductWishList" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing WishList product(s) for user(s)">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="userProductWishListStatus" Type="numeric" Required="No">
	<cfargument Name="userProductWishListFulfilled" Type="numeric" Required="No">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">

	<cfset var displayAnd = False>

	<cfquery Name="qry_deleteUserProductWishList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avUserProductWishList
		WHERE 
			<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "userProductWishListStatus") and ListFind("0,1", Arguments.userProductWishListStatus)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				userProductWishListStatus = <cfqueryparam Value="#Arguments.userProductWishListStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "userProductWishListFulfilled") and ListFind("0,1", Arguments.userProductWishListFulfilled)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				userProductWishListFulfilled = <cfqueryparam Value="#Arguments.userProductWishListFulfilled#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "invoiceLineItemID") and Application.fn_IsIntegerList(Arguments.invoiceLineItemID)>
				<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
				invoiceLineItemID IN (<cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif displayAnd is False>
				productID < 0
			</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>

