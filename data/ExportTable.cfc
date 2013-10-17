<cfcomponent DisplayName="ExportTable" Hint="Manages customizing export table options">

<cffunction name="maxlength_ExportTable" access="public" output="no" returnType="struct">
	<cfset var maxlength_ExportTable = StructNew()>

	<cfset maxlength_ExportTable.exportTableName = 50>
	<cfset maxlength_ExportTable.exportTableDescription = 255>

	<cfreturn maxlength_ExportTable>
</cffunction>

<!--- Export Table --->
<cffunction Name="insertExportTable" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new table for export purposes. Returns exportTableID.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableName" Type="string" Required="Yes">
	<cfargument Name="exportTableDescription" Type="string" Required="No" Default="">
	<cfargument Name="exportTableOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportTableStatus" Type="numeric" Required="No" Default="1">

	<cfset var qry_insertExportTable = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.ExportTable" method="maxlength_exportTable" returnVariable="maxlength_exportTable" />

	<cfquery Name="qry_insertExportTable" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportTable
		SET exportTableOrder = exportTableOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE exportTableOrder >= <cfqueryparam Value="#Arguments.exportTableOrder#" cfsqltype="cf_sql_smallint">;

		INSERT INTO avExportTable
		(
			primaryTargetID, exportTableName, exportTableDescription, exportTableOrder, exportTableStatus
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.exportTableName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportTable.exportTableName#">,
			<cfqueryparam Value="#Arguments.exportTableDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportTable.exportTableDescription#">,
			<cfqueryparam Value="#Arguments.exportTableOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.exportTableStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "exportTableID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertExportTable.primaryKeyID>
</cffunction>

<cffunction Name="checkExportTableNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that table name is unique">
	<cfargument Name="exportTableName" Type="string" Required="Yes">
	<cfargument Name="exportTableID" Type="numeric" Required="No">

	<cfset var qry_checkExportTableNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkExportTableNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportTableID
		FROM avExportTable
		WHERE exportTableName = <cfqueryparam Value="#Arguments.exportTableName#" cfsqltype="cf_sql_varchar">
		<cfif StructKeyExists(Arguments, "exportTableID") and Application.fn_IsIntegerNonNegative(Arguments.exportTableID)>
			AND exportTableID <> <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
		</cfif>
	</cfquery>

	<cfif qry_checkExportTableNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="updateExportTable" Access="public" Output="No" ReturnType="boolean" Hint="Update existing table for export purposes.">
	<cfargument Name="exportTableID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableName" Type="string" Required="No">
	<cfargument Name="exportTableDescription" Type="string" Required="No">
	<cfargument Name="exportTableStatus" Type="numeric" Required="No">

	<cfset var displayComma = False>

	<cfif Not StructKeyExists(Arguments, "exportTableName") and Not StructKeyExists(Arguments, "exportTableDescription") and Not StructKeyExists(Arguments, "exportTableStatus")>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateExportTable" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avExportTable
			SET
				<cfif StructKeyExists(Arguments, "exportTableName")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableName = <cfqueryparam Value="#Arguments.exportTableName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportTable.exportTableName#"></cfif>
				<cfif StructKeyExists(Arguments, "exportTableDescription")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableDescription = <cfqueryparam Value="#Arguments.exportTableDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportTable.exportTableDescription#"></cfif>
				<cfif StructKeyExists(Arguments, "exportTableStatus") and ListFind("0,1", Arguments.exportTableStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableStatus = <cfqueryparam Value="#Arguments.exportTableStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			WHERE exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectExportTable" Access="public" Output="No" ReturnType="query" Hint="Select existing table for export purposes.">
	<cfargument Name="exportTableID" Type="numeric" Required="Yes">

	<cfset var qry_selectExportTable = QueryNew("blank")>

	<cfquery Name="qry_selectExportTable" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT primaryTargetID, exportTableName, exportTableDescription, exportTableOrder, exportTableStatus
		FROM avExportTable
		WHERE exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectExportTable>
</cffunction>

<cffunction Name="selectExportTableList" Access="public" Output="No" ReturnType="query" Hint="Select all existing tables for export purposes.">
	<cfargument Name="exportTableStatus" Type="numeric" Required="No">

	<cfset var qry_selectExportTableList = QueryNew("blank")>

	<cfquery Name="qry_selectExportTableList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportTableID, primaryTargetID, exportTableName, exportTableDescription, exportTableOrder, exportTableStatus
		FROM avExportTable
		<cfif StructKeyExists(Arguments, "exportTableStatus") and ListFind("0,1", Arguments.exportTableStatus)>
			WHERE exportTableStatus = <cfqueryparam Value="#Arguments.exportTableStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		</cfif>
		ORDER BY exportTableOrder
	</cfquery>

	<cfreturn qry_selectExportTableList>
</cffunction>

<cffunction Name="switchExportTableOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing export tables">
	<cfargument Name="exportTableID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableOrder_direction" Type="string" Required="Yes">

	<cfset var qry_selectExportTableOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchExportTableOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportTable
		SET exportTableOrder = exportTableOrder 
			<cfif Arguments.exportTableOrder_direction is "moveExportTableDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avExportTable INNER JOIN avExportTable AS avExportTable2
			SET avExportTable.exportTableOrder = avExportTable.exportTableOrder 
				<cfif Arguments.exportTableOrder_direction is "moveExportTableDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avExportTable.exportTableOrder = avExportTable2.exportTableOrder
				AND avExportTable.exportTableID <> <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
				AND avExportTable2.exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avExportTable
			SET exportTableOrder = exportTableOrder 
				<cfif Arguments.exportTableOrder_direction is "moveExportTableDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE exportTableID <> <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
				AND exportTableOrder = (SELECT exportTableOrder FROM avExportTable WHERE exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
