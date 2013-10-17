<cfcomponent DisplayName="ContentCompany" Hint="Manages company-specific content">

<cffunction name="maxlength_ContentCompany" access="public" output="no" returnType="struct">
	<cfset var maxlength_ContentCompany = StructNew()>

	<cfset maxlength_ContentCompany.contentCompanyText = 4000>
	<cfset maxlength_ContentCompany.languageID = 5>

	<cfreturn maxlength_ContentCompany>
</cffunction>

<!--- actual content values for company/language --->
<cffunction Name="insertContentCompany" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new content listing and returns contentID">
	<cfargument Name="contentID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="contentCompanyStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="contentCompanyText" Type="string" Required="Yes">
	<cfargument Name="contentCompanyHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="contentCompanyOrder" Type="numeric" Required="No" Default="0">

	<cfinvoke component="#Application.billingMapping#data.ContentCompany" method="maxlength_ContentCompany" returnVariable="maxlength_ContentCompany" />

	<cfquery Name="qry_insertContentCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContentCompany
		SET contentCompanyStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE contentCompanyStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND contentID = <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">;

		INSERT INTO avContentCompany
		(
			contentID, companyID, languageID, userID, contentCompanyStatus, contentCompanyOrder,
			contentCompanyText, contentCompanyHtml, contentCompanyDateCreated, contentCompanyDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContentCompany.languageID#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.contentCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contentCompanyOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.contentCompanyText#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContentCompany.contentCompanyText#">,
			<cfqueryparam Value="#Arguments.contentCompanyHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateContentCompany" Access="public" Output="No" ReturnType="boolean" Hint="Update existing content listing and returns True">
	<cfargument Name="contentCompanyID" Type="string" Required="Yes">
	<cfargument Name="contentCompanyStatus" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_updateContentCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContentCompany
		SET contentCompanyStatus = <cfqueryparam Value="#Arguments.contentCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			contentCompanyDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE contentCompanyID IN (<cfqueryparam Value="#Arguments.contentCompanyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>
	<cfreturn True>
</cffunction>

<cffunction Name="selectContentCompany" Access="public" Output="No" ReturnType="query" Hint="Select existing content listing">
	<cfargument Name="contentCompanyID" Type="numeric" Required="Yes">

	<cfset var qry_selectContentCompany = QueryNew("blank")>

	<cfquery Name="qry_selectContentCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contentID, companyID, languageID, userID, contentCompanyOrder, contentCompanyStatus,
			contentCompanyText, contentCompanyHtml, contentCompanyDateCreated, contentCompanyDateUpdated
		FROM avContentCompany
		WHERE contentCompanyID = <cfqueryparam Value="#Arguments.contentCompanyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectContentCompany>
</cffunction>

<cffunction Name="selectContentCompanyList" Access="public" Output="No" ReturnType="query" Hint="Select existing content listings">
	<cfargument Name="contentCategoryID" Type="string" Required="No">
	<cfargument Name="contentCode" Type="string" Required="No">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contentID" Type="string" Required="No">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="contentCompanyStatus" Type="numeric" Required="No">
	<cfargument Name="contentCompanyOrder" Type="numeric" Required="No">

	<cfset var qry_selectContentCompanyList = QueryNew("blank")>

	<cfquery Name="qry_selectContentCompanyList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avContent.contentID, <!--- avContent.userID, --->avContent.contentName,
			avContent.contentDescription, avContent.contentCode, avContent.contentCategoryID,
			avContent.contentType, avContent.contentOrder, avContent.contentStatus,
			avContent.contentMaxlength, avContent.contentHtmlOk, avContent.contentRequired,
			avContent.contentFilename, avContent.contentDateCreated, avContent.contentDateUpdated,
			avContentCompany.contentCompanyID, avContentCompany.contentCompanyOrder,
			avContentCompany.companyID, avContentCompany.languageID,
			avContentCompany.userID, avContentCompany.contentCompanyStatus, 
			avContentCompany.contentCompanyText, avContentCompany.contentCompanyHtml,
			avContentCompany.contentCompanyDateCreated, avContentCompany.contentCompanyDateUpdated
		FROM avContent LEFT OUTER JOIN avContentCompany
			ON avContent.contentID = avContentCompany.contentID
				AND avContentCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				<cfif StructKeyExists(Arguments, "languageID")>AND avContentCompany.languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar"></cfif>
				<cfif StructKeyExists(Arguments, "contentID") and Application.fn_IsIntegerList(Arguments.contentID)>AND avContentCompany.contentID IN (<cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
				<cfif StructKeyExists(Arguments, "contentCompanyStatus") and ListFind("0,1", Arguments.contentCompanyStatus)>AND avContentCompany.contentCompanyStatus = <cfqueryparam Value="#Arguments.contentCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
				<cfif StructKeyExists(Arguments, "contentCompanyOrder") and Application.fn_IsIntegerNonNegative(Arguments.contentCompanyOrder)>AND avContentCompany.contentCompanyOrder = <cfqueryparam Value="#Arguments.contentCompanyOrder#" cfsqltype="cf_sql_smallint"></cfif>
		WHERE 
			<cfif StructKeyExists(Arguments, "contentCategoryID") and Application.fn_IsIntegerList(Arguments.contentCategoryID)>
				avContent.contentCategoryID = <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
			<cfelseif StructKeyExists(Arguments, "contentCode") and Trim(Arguments.contentCode) is not "">
				avContent.contentCode IN (<cfqueryparam Value="#Arguments.contentCode#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
			<cfelse>
				avContent.contentCategoryID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			</cfif>
		ORDER BY avContent.contentOrder, avContentCompany.contentCompanyStatus DESC, avContentCompany.contentCompanyDateCreated DESC
	</cfquery>

	<cfreturn qry_selectContentCompanyList>
</cffunction>

<cffunction Name="selectContentCompanyLastUpdated" Access="public" Output="No" ReturnType="query" Hint="Select existing content listings">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contentID" Type="string" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">

	<cfset var qry_selectContentCompanyLastUpdated = QueryNew("blank")>

	<cfquery Name="qry_selectContentCompanyLastUpdated" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avContentCompany.contentID, avContentCompany.contentCompanyOrder, 
			avContentCompany.contentCompanyDateCreated, avContentCompany.userID,
			avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom
		FROM avContentCompany LEFT OUTER JOIN avUser
			ON avContentCompany.userID = avUser.userID
		WHERE avContentCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND avContentCompany.contentCompanyStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avContentCompany.contentID IN (<cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "languageID")>AND avContentCompany.languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar"></cfif>
		ORDER BY avContentCompany.contentCompanyDateCreated DESC
	</cfquery>

	<cfreturn qry_selectContentCompanyLastUpdated>
</cffunction>

<cffunction Name="selectContentCompanyOrderList" Access="public" Output="No" ReturnType="query" Hint="Select all versions of an existing content listing">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contentID" Type="string" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No">

	<cfset var qry_selectContentCompanyOrderList = QueryNew("blank")>

	<cfquery Name="qry_selectContentCompanyOrderList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avContentCompany.contentCompanyOrder, avContentCompany.contentCompanyStatus, 
			avContentCompany.contentCompanyText, avContentCompany.contentCompanyHtml,
			avContentCompany.contentCompanyDateCreated, avContentCompany.contentCompanyDateUpdated,
			avContentCompany.userID, avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avContentCompany LEFT OUTER JOIN avUser
			ON avContentCompany.userID = avUser.userID
		WHERE avContentCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "languageID")>
				AND avContentCompany.languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif StructKeyExists(Arguments, "contentID") and Application.fn_IsIntegerList(Arguments.contentID)>
				AND avContentCompany.contentID IN (<cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
		ORDER BY avContentCompany.contentCompanyOrder DESC
	</cfquery>

	<cfreturn qry_selectContentCompanyOrderList>
</cffunction>

</cfcomponent>
