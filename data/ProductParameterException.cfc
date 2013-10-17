<cfcomponent DisplayName="ProductParameterException" Hint="Manages product parameter options">

<cffunction name="maxlength_ProductParameterException" access="public" output="no" returnType="struct">
	<cfset var maxlength_ProductParameterException = StructNew()>

	<cfset maxlength_ProductParameterException.productParameterExceptionText = 255>
	<cfset maxlength_ProductParameterException.productParameterExceptionDescription = 255>
	<cfset maxlength_ProductParameterException.productParameterExceptionPricePremium = 4>

	<cfreturn maxlength_ProductParameterException>
</cffunction>

<!--- Product Parameter Exception --->
<cffunction Name="insertProductParameterException" Access="public" Output="No" ReturnType="boolean" Hint="Insert product parameter exception and returns True">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterOptionID1" Type="numeric" Required="Yes">
	<cfargument Name="productParameterOptionID2" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterOptionID3" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterOptionID4" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterExceptionExcluded" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterExceptionPricePremium" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterExceptionText" Type="string" Required="No" Default="">
	<cfargument Name="productParameterExceptionDescription" Type="string" Required="No" Default="">
	<cfargument Name="productParameterExceptionStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="userID" Type="numeric" Required="Yes">

	<cfinvoke component="#Application.billingMapping#data.ProductParameterException" method="maxlength_ProductParameterException" returnVariable="maxlength_ProductParameterException" />

	<cfquery Name="qry_insertProductParameterException" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avProductParameterException
		(
			productID, productParameterOptionID1, productParameterOptionID2, productParameterOptionID3, productParameterOptionID4,
			productParameterExceptionExcluded, productParameterExceptionPricePremium, productParameterExceptionText,
			productParameterExceptionDescription, productParameterExceptionStatus, productParameterExceptionID_parent,
			userID, productParameterExceptionDateCreated, productParameterExceptionDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productParameterOptionID1#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productParameterOptionID2#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productParameterOptionID3#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productParameterOptionID4#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productParameterExceptionExcluded#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productParameterExceptionPricePremium#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.productParameterExceptionText#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameterException.productParameterExceptionText#">,
			<cfqueryparam Value="#Arguments.productParameterExceptionDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameterException.productParameterExceptionDescription#">,
			<cfqueryparam Value="#Arguments.productParameterExceptionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productParameterExceptionID_parent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateProductParameterException" Access="public" Output="No" ReturnType="boolean" Hint="Update product parameter exception to update status to 0 and returns True">
	<cfargument Name="productParameterExceptionID" Type="numeric" Required="Yes">

	<cfquery Name="qry_updateProductParameterException" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductParameterException
		SET productParameterExceptionStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			productParameterExceptionDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productParameterExceptionID = <cfqueryparam Value="#Arguments.productParameterExceptionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkProductParameterExceptionIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check that product parameter exception is unique for product">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterOptionID_list" Type="numeric" Required="Yes">
	<cfargument Name="productParameterExceptionID" Type="numeric" Required="No">

	<cfset var qry_checkProductParameterExceptionIsUnique = QueryNew("blank")>

	<!--- 
	not unique if contains an exception where:
	- productParameterOptionID1 is alone as an existing exception
	- productParameterOptionID 1-4 contains same options as existing exception, in any order
	- productParameterOptionID 1-4 contains partial list of existing options
		(e.g., if 3 options form basis of exception, but another exception exists with just 2 of those options)
	--->

	<cfquery Name="qry_checkProductParameterExceptionIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productParameterExceptionID
		FROM avProductParameterException
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productParameterExceptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND productParameterOptionID1 IN (<cfqueryparam Value="#Arguments..productParameterOptionID_list#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND productParameterOptionID2 IN (<cfqueryparam Value="0,#Arguments..productParameterOptionID_list#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND productParameterOptionID3 IN (<cfqueryparam Value="0,#Arguments..productParameterOptionID_list#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND productParameterOptionID4 IN (<cfqueryparam Value="0,#Arguments..productParameterOptionID_list#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "productParameterExceptionID") and Application.fn_IsIntegerPositive(Arguments.productParameterExceptionID)>
				AND productParameterExceptionID <> <cfqueryparam Value="#Arguments.productParameterExceptionID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkProductParameterExceptionIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectProductParameterException" Access="public" Output="No" ReturnType="query" Hint="Select designated product parameter exception">
	<cfargument Name="productParameterExceptionID" Type="string" Required="Yes">

	<cfset var qry_selectProductParameterException = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.productParameterExceptionID)>
		<cfset Arguments.productParameterExceptionID = 0>
	</cfif>

	<cfquery Name="qry_selectProductParameterException" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productParameterExceptionID, productID, productParameterOptionID1, productParameterOptionID2,
			productParameterOptionID3, productParameterOptionID4, productParameterExceptionExcluded,
			productParameterExceptionPricePremium, productParameterExceptionText,
			productParameterExceptionDescription, productParameterExceptionStatus,
			userID, productParameterExceptionID_parent, productParameterExceptionDateCreated,
			productParameterExceptionDateUpdated
		FROM avProductParameterException
		WHERE productParameterExceptionID IN (<cfqueryparam Value="#Arguments.productParameterExceptionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectProductParameterException>
</cffunction>

<cffunction Name="selectProductParameterExceptionList" Access="public" Output="No" ReturnType="query" Hint="Select designated product parameter Exception">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterExceptionStatus" Type="numeric" Required="No">
	<cfargument Name="returnParameterOptions" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectProductParameterExceptionList = QueryNew("blank")>

	<cfquery Name="qry_selectProductParameterExceptionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avProductParameterException.productParameterExceptionID, avProductParameterException.productParameterExceptionID_parent,
			avProductParameterException.productParameterOptionID1, avProductParameterException.productParameterOptionID2,
			avProductParameterException.productParameterOptionID3, avProductParameterException.productParameterOptionID4,
			avProductParameterException.productParameterExceptionExcluded, avProductParameterException.productParameterExceptionPricePremium,
			avProductParameterException.productParameterExceptionText, avProductParameterException.productParameterExceptionDescription,
			avProductParameterException.productParameterExceptionStatus, avProductParameterException.userID,
			avProductParameterException.productParameterExceptionDateCreated, avProductParameterException.productParameterExceptionDateUpdated
			<cfif StructKeyExists(Arguments, "returnParameterOptions") and Arguments.returnParameterOptions is True>
				, ProductParameterOption1.productParameterID AS productParameterID1, ProductParameterOption1.productParameterOptionValue AS productParameterOptionValue1, ProductParameterOption1.productParameterOptionLabel AS productParameterOptionLabel1,
				ProductParameterOption2.productParameterID AS productParameterID2, ProductParameterOption2.productParameterOptionValue AS productParameterOptionValue2, ProductParameterOption2.productParameterOptionLabel AS productParameterOptionLabel2,
				ProductParameterOption3.productParameterID AS productParameterID3, ProductParameterOption3.productParameterOptionValue AS productParameterOptionValue3, ProductParameterOption3.productParameterOptionLabel AS productParameterOptionLabel3,
				ProductParameterOption4.productParameterID AS productParameterID4, ProductParameterOption4.productParameterOptionValue AS productParameterOptionValue4, ProductParameterOption4.productParameterOptionLabel AS productParameterOptionLabel4
			</cfif>
		FROM avProductParameterException
			<cfif StructKeyExists(Arguments, "returnParameterOptions") and Arguments.returnParameterOptions is True>
				LEFT OUTER JOIN avProductParameterOption AS ProductParameterOption1 ON avProductParameterException.productParameterOptionID1 = ProductParameterOption1.productParameterOptionID
				LEFT OUTER JOIN avProductParameterOption AS ProductParameterOption2 ON avProductParameterException.productParameterOptionID2 = ProductParameterOption2.productParameterOptionID
				LEFT OUTER JOIN avProductParameterOption AS ProductParameterOption3 ON avProductParameterException.productParameterOptionID3 = ProductParameterOption3.productParameterOptionID
				LEFT OUTER JOIN avProductParameterOption AS ProductParameterOption4 ON avProductParameterException.productParameterOptionID4 = ProductParameterOption4.productParameterOptionID
			</cfif>
		WHERE avProductParameterException.productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "productParameterExceptionStatus") and ListFind("0,1", Arguments.productParameterExceptionStatus)>
				AND avProductParameterException.productParameterExceptionStatus = <cfqueryparam Value="#Arguments.productParameterExceptionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY avProductParameterException.productParameterExceptionStatus DESC, avProductParameterException.productParameterExceptionDateCreated DESC
	</cfquery>

	<cfreturn qry_selectProductParameterExceptionList>
</cffunction>

</cfcomponent>