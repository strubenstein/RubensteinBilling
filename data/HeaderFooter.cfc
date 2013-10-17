<cfcomponent DisplayName="HeaderFooter" Hint="Manages inserting and viewing category and cobrand headers and footers">

<cffunction Name="insertHeaderFooter" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new value into archive. Returns True.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="headerFooterStatus" Type="numeric" Required="Yes">
	<cfargument Name="headerFooterText" Type="string" Required="Yes">
	<cfargument Name="headerFooterHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="headerFooterIndicator" Type="numeric" Required="Yes">

	<cfset var qry_insertHeaderFooter = QueryNew("blank")>

	<cfquery Name="qry_updateHeaderFooterStatus" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avHeaderFooter
		SET headerFooterStatus = 0,
			headerFooterDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			AND languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">
			AND headerFooterIndicator = <cfqueryparam Value="#Arguments.headerFooterIndicator#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>

	<cfif Trim(Arguments.headerFooterText) is "">
		<cfreturn 0>
	<cfelse>
		<cfquery Name="qry_insertHeaderFooter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			INSERT INTO avHeaderFooter
			(
				primaryTargetID, targetID, userID, languageID, headerFooterStatus, headerFooterText,
				headerFooterHtml, headerFooterIndicator, headerFooterDateCreated, headerFooterDateUpdated
			)
			VALUES
			(
				<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam Value="#Arguments.headerFooterStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.headerFooterText#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam Value="#Arguments.headerFooterHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.headerFooterIndicator#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				#Application.billingSql.sql_nowDateTime#,
				#Application.billingSql.sql_nowDateTime#
			);

			#Replace(Application.billingSql.identityField_select, "primaryKeyField", "headerFooterID", "ALL")#;
		</cfquery>

		<cfreturn qry_insertHeaderFooter.primaryKeyID>
	</cfif>
</cffunction>

<cffunction Name="selectHeaderFooter" Access="public" Output="No" ReturnType="query" Hint="Return existing header(s) and/or footer(s) for particular category or cobrand">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="numeric" Required="No">
	<cfargument Name="headerFooterID" Type="string" Required="No">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="headerFooterStatus" Type="numeric" Required="No">
	<cfargument Name="headerFooterIndicator" Type="numeric" Required="No">

	<cfset var qry_selectHeaderFooter = QueryNew("blank")>

	<cfquery Name="qry_selectHeaderFooter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT headerFooterID, primaryTargetID, targetID, userID, languageID,
			headerFooterStatus, headerFooterText, headerFooterHtml, headerFooterIndicator,
			headerFooterDateCreated, headerFooterDateUpdated
		FROM avHeaderFooter
		WHERE headerFooterID <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerPositive(Arguments.primaryTargetID)>
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerPositive(Arguments.targetID)>
				AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(Arguments, "headerFooterID") and Application.fn_IsIntegerList(Arguments.headerFooterID)>
				AND headerFooterID IN (<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "languageID")>
				AND languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif StructKeyExists(Arguments, "headerFooterStatus") and ListFind("0,1", Arguments.headerFooterStatus)>
				AND headerFooterStatus = <cfqueryparam Value="#Arguments.headerFooterStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "headerFooterIndicator") and ListFind("0,1", Arguments.headerFooterIndicator)>
				AND headerFooterIndicator = <cfqueryparam Value="#Arguments.headerFooterIndicator#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY headerFooterIndicator, headerFooterDateCreated
	</cfquery>

	<cfreturn qry_selectHeaderFooter>
</cffunction>

</cfcomponent>

