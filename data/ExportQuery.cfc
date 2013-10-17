<cfcomponent DisplayName="ExportQuery" Hint="Manages customizing export options">

<cffunction name="maxlength_ExportQuery" access="public" output="no" returnType="struct">
	<cfset var maxlength_ExportQuery = StructNew()>

	<cfset maxlength_ExportQuery.exportQueryName = 100>
	<cfset maxlength_ExportQuery.exportQueryTitle = 100>
	<cfset maxlength_ExportQuery.exportQueryDescription = 255>

	<cfreturn maxlength_ExportQuery>
</cffunction>

<!--- Export Query --->
<cffunction Name="insertExportQuery" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new query for export purposes. Returns exportQueryID.">
	<cfargument Name="exportQueryName" Type="string" Required="Yes">
	<cfargument Name="exportQueryTitle" Type="string" Required="Yes">
	<cfargument Name="exportQueryDescription" Type="string" Required="No" Default="">
	<cfargument Name="exportQueryOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportQueryStatus" Type="numeric" Required="No" Default="1">

	<cfset var qry_insertExportQuery = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.ExportQuery" method="maxlength_ExportQuery" returnVariable="maxlength_ExportQuery" />

	<cfquery Name="qry_insertExportQuery" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportQuery
		SET exportQueryOrder = exportQueryOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE exportQueryOrder >= <cfqueryparam Value="#Arguments.exportQueryOrder#" cfsqltype="cf_sql_smallint">;

		INSERT INTO avExportQuery
		(
			exportQueryName, exportQueryTitle, exportQueryDescription, exportQueryOrder, exportQueryStatus
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.exportQueryName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportQuery.exportQueryName#">,
			<cfqueryparam Value="#Arguments.exportQueryTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportQuery.exportQueryTitle#">,
			<cfqueryparam Value="#Arguments.exportQueryDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportQuery.exportQueryDescription#">,
			<cfqueryparam Value="#Arguments.exportQueryOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.exportQueryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "exportQueryID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertExportQuery.primaryKeyID>
</cffunction>

<cffunction Name="checkExportQueryNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that query name is unique">
	<cfargument Name="exportQueryName" Type="string" Required="Yes">
	<cfargument Name="exportQueryID" Type="numeric" Required="No">

	<cfset var qry_checkExportQueryNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkExportQueryNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportQueryID
		FROM avExportQuery
		WHERE exportQueryName = <cfqueryparam Value="#Arguments.exportQueryName#" cfsqltype="cf_sql_varchar">
		<cfif StructKeyExists(Arguments, "exportQueryID") and Application.fn_IsIntegerNonNegative(Arguments.exportQueryID)>
			AND exportQueryID <> <cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">
		</cfif>
	</cfquery>

	<cfif qry_checkExportQueryNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="updateExportQuery" Access="public" Output="No" ReturnType="boolean" Hint="Update existing query for export purposes.">
	<cfargument Name="exportQueryID" Type="numeric" Required="Yes">
	<cfargument Name="exportQueryName" Type="string" Required="No">
	<cfargument Name="exportQueryTitle" Type="string" Required="No">
	<cfargument Name="exportQueryDescription" Type="string" Required="No">
	<cfargument Name="exportQueryStatus" Type="numeric" Required="No">

	<cfset var displayComma = False>

	<cfif Not StructKeyExists(Arguments, "exportQueryName") and Not StructKeyExists(Arguments, "exportQueryTitle") and Not StructKeyExists(Arguments, "exportQueryDescription") and Not StructKeyExists(Arguments, "exportQueryStatus")>
		<cfreturn False>
	<cfelse>
		<cfinvoke component="#Application.billingMapping#data.ExportQuery" method="maxlength_ExportQuery" returnVariable="maxlength_ExportQuery" />

		<cfquery Name="qry_updateExportQuery" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avExportQuery
			SET
				<cfif StructKeyExists(Arguments, "exportQueryName")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportQueryName = <cfqueryparam Value="#Arguments.exportQueryName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportQuery.exportQueryName#"></cfif>
				<cfif StructKeyExists(Arguments, "exportQueryTitle")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportQueryTitle = <cfqueryparam Value="#Arguments.exportQueryTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportQuery.exportQueryTitle#"></cfif>
				<cfif StructKeyExists(Arguments, "exportQueryDescription")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportQueryDescription = <cfqueryparam Value="#Arguments.exportQueryDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportQuery.exportQueryDescription#"></cfif>
				<cfif StructKeyExists(Arguments, "exportQueryStatus") and ListFind("0,1", Arguments.exportQueryStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportQueryStatus = <cfqueryparam Value="#Arguments.exportQueryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			WHERE exportQueryID = <cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectExportQuery" Access="public" Output="No" ReturnType="query" Hint="Select existing query for export purposes.">
	<cfargument Name="exportQueryID" Type="numeric" Required="Yes">

	<cfset var qry_selectExportQuery = QueryNew("blank")>

	<cfquery Name="qry_selectExportQuery" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportQueryName, exportQueryTitle, exportQueryDescription, exportQueryOrder, exportQueryStatus
		FROM avExportQuery
		WHERE exportQueryID = <cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectExportQuery>
</cffunction>

<cffunction Name="selectExportQueryList" Access="public" Output="No" ReturnType="query" Hint="Select all existing queries for export purposes.">
	<cfargument Name="exportQueryStatus" Type="numeric" Required="No">
	<cfargument Name="exportQueryName" Type="string" Required="No">

	<cfset var qry_selectExportQueryList = QueryNew("blank")>

	<cfquery Name="qry_selectExportQueryList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportQueryID, exportQueryName, exportQueryTitle, exportQueryDescription, exportQueryOrder, exportQueryStatus
		FROM avExportQuery
		WHERE exportQueryID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "exportQueryName") and Trim(Arguments.exportQueryName) is not "">AND exportQueryName = <cfqueryparam Value="#Arguments.exportQueryName#" CFSQLType="cf_sql_varchar"></cfif>
			<cfif StructKeyExists(Arguments, "exportQueryStatus") and ListFind("0,1", Arguments.exportQueryStatus)>AND exportQueryStatus = <cfqueryparam Value="#Arguments.exportQueryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		ORDER BY exportQueryOrder
	</cfquery>

	<cfreturn qry_selectExportQueryList>
</cffunction>

<cffunction Name="switchExportQueryOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing export queries">
	<cfargument Name="exportQueryID" Type="numeric" Required="Yes">
	<cfargument Name="exportQueryOrder_direction" Type="string" Required="Yes">

	<cfset var qry_selectExportQueryOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchExportQueryOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportQuery
		SET exportQueryOrder = exportQueryOrder 
			<cfif Arguments.exportQueryOrder_direction is "moveExportQueryDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE exportQueryID = <cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avExportQuery INNER JOIN avExportQuery AS avExportQuery2
			SET avExportQuery.exportQueryOrder = avExportQuery.exportQueryOrder 
				<cfif Arguments.exportQueryOrder_direction is "moveExportQueryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avExportQuery.exportQueryOrder = avExportQuery2.exportQueryOrder
				AND avExportQuery.exportQueryID <> <cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">
				AND avExportQuery2.exportQueryID = <cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avExportQuery
			SET exportQueryOrder = exportQueryOrder 
				<cfif Arguments.exportQueryOrder_direction is "moveExportQueryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE exportQueryID <> <cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">
				AND exportQueryOrder = (SELECT exportQueryOrder FROM avExportQuery WHERE exportQueryID = <cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>