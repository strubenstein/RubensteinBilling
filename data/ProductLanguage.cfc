<cfcomponent DisplayName="Product" Hint="Manages product language">

<cffunction name="maxlength_ProductLanguage" access="public" output="no" returnType="struct">
	<cfset var maxlength_ProductLanguage = StructNew()>

	<cfset maxlength_ProductLanguage.productLanguageName = 255>
	<cfset maxlength_ProductLanguage.productLanguageLineItemName = 255>
	<cfset maxlength_ProductLanguage.productLanguageLineItemDescription = 1000>
	<cfset maxlength_ProductLanguage.productLanguageSummary = 1000>
	<cfset maxlength_ProductLanguage.productLanguageDescription = 0>

	<cfreturn maxlength_ProductLanguage>
</cffunction>

<cffunction Name="insertProductLanguage" Access="public" Output="No" ReturnType="boolean" Hint="Insert product language used on invoices">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="productLanguageName" Type="string" Required="Yes">
	<cfargument Name="productLanguageLineItemName" Type="string" Required="Yes">
	<cfargument Name="productLanguageLineItemDescription" Type="string" Required="Yes">
	<cfargument Name="productLanguageLineItemDescriptionHtml" Type="numeric" Required="Yes">
	<cfargument Name="productLanguageSummaryHtml" Type="numeric" Required="Yes">
	<cfargument Name="productLanguageSummary" Type="string" Required="Yes">
	<cfargument Name="productLanguageDescription" Type="string" Required="Yes">
	<cfargument Name="productLanguageDescriptionHtml" Type="numeric" Required="Yes">

	<cfinvoke component="#Application.billingMapping#data.ProductLanguage" method="maxlength_ProductLanguage" returnVariable="maxlength_ProductLanguage" />

	<cfquery Name="qry_insertProductLanguage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductLanguage
		SET productLanguageStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			productLanguageDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">
			AND productLanguageStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;

		INSERT INTO avProductLanguage
		(
			productID, languageID, productLanguageStatus, userID, productLanguageName, productLanguageLineItemName,
			productLanguageLineItemDescription, productLanguageLineItemDescriptionHtml, productLanguageSummary,
			productLanguageSummaryHtml, productLanguageDescription, productLanguageDescriptionHtml,
			productLanguageDateCreated, productLanguageDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productLanguageName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductLanguage.productLanguageName#">,
			<cfqueryparam Value="#Arguments.productLanguageLineItemName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductLanguage.productLanguageLineItemName#">,
			<cfqueryparam Value="#Arguments.productLanguageLineItemDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductLanguage.productLanguageLineItemDescription#">,
			<cfqueryparam Value="#Arguments.productLanguageLineItemDescriptionHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productLanguageSummary#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductLanguage.productLanguageSummary#">,
			<cfqueryparam Value="#Arguments.productLanguageSummaryHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productLanguageDescription#" cfsqltype="cf_sql_longvarchar">,
			<cfqueryparam Value="#Arguments.productLanguageDescriptionHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectProductLanguage" Access="public" Output="No" ReturnType="query" Hint="Select Existing Product Invoice Language">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="productLanguageStatus" Type="numeric" Required="No">

	<cfset var qry_selectProductLanguage = QueryNew("blank")>

	<cfquery Name="qry_selectProductLanguage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productLanguageID, languageID, productLanguageStatus, userID,
			productLanguageName, productLanguageLineItemName,
			productLanguageLineItemDescription, productLanguageLineItemDescriptionHtml,
			productLanguageSummary, productLanguageSummaryHtml, 
			productLanguageDescription, productLanguageDescriptionHtml,
			productLanguageDateCreated, productLanguageDateUpdated
		FROM avProductLanguage
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "languageID")>
				AND languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif StructKeyExists(Arguments, "productLanguageStatus") and ListFind("0,1", Arguments.productLanguageStatus)>
				AND productLanguageStatus = <cfqueryparam Value="#Arguments.productLanguageStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY languageID, productLanguageStatus DESC, productLanguageDateCreated DESC
	</cfquery>

	<cfreturn qry_selectProductLanguage>
</cffunction>

</cfcomponent>