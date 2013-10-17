<cfcomponent DisplayName="ExportQueryField" Hint="Manages customizing export options">

<cffunction name="maxlength_ExportQueryField" access="public" output="no" returnType="struct">
	<cfset var maxlength_ExportQueryField = StructNew()>

	<cfset maxlength_ExportQueryField.exportQueryFieldAs = 100>

	<cfreturn maxlength_ExportQueryField>
</cffunction>

<!--- Export Query Field --->
<cffunction Name="insertExportQueryField" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new field in export query. Returns True.">
	<cfargument Name="exportQueryID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableFieldID" Type="numeric" Required="Yes">
	<cfargument Name="exportQueryFieldOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportQueryFieldAs" Type="string" Required="No" Default="">

	<cfinvoke component="#Application.billingMapping#data.ExportQueryField" method="maxlength_ExportQueryField" returnVariable="maxlength_ExportQueryField" />

	<cfquery Name="qry_insertExportQueryField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avExportQueryField
		(
			exportQueryID, exportTableFieldID, exportQueryFieldOrder, exportQueryFieldAs
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.exportQueryFieldOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.exportQueryFieldAs#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_ExportQueryField.exportQueryFieldAs#">
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateExportQueryField" Access="public" Output="No" ReturnType="boolean" Hint="Updates select as name of field in export query. Returns True.">
	<cfargument Name="exportQueryFieldID" Type="numeric" Required="Yes">
	<cfargument Name="exportQueryFieldAs" Type="string" Required="Yes">

	<cfinvoke component="#Application.billingMapping#data.ExportQueryField" method="maxlength_ExportQueryField" returnVariable="maxlength_ExportQueryField" />

	<cfquery Name="qry_updateExportQueryField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportQueryField
		SET exportQueryFieldAs = <cfqueryparam Value="#Arguments.exportQueryFieldAs#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_ExportQueryField.exportQueryFieldAs#">
		WHERE exportQueryFieldID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectExportQueryField" Access="public" Output="No" ReturnType="query" Hint="Select existing query field for export purposes.">
	<cfargument Name="exportQueryFieldID" Type="numeric" Required="Yes">

	<cfset var qry_selectExportQueryField = QueryNew("blank")>

	<cfquery Name="qry_selectExportQueryField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportQueryID, exportTableFieldID, exportQueryFieldOrder, exportQueryFieldAs
		FROM avExportQueryField
		WHERE exportQueryFieldID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectExportQueryField>
</cffunction>

<cffunction Name="selectExportQueryFieldList" Access="public" Output="No" ReturnType="query" Hint="Select all existing query fields for export purposes.">
	<cfargument Name="exportQueryID" Type="numeric" Required="Yes">

	<cfset var qry_selectExportQueryFieldList = QueryNew("blank")>

	<cfquery Name="qry_selectExportQueryFieldList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avExportQueryField.exportQueryFieldID, avExportQueryField.exportTableFieldID,
			avExportQueryField.exportQueryFieldOrder, avExportQueryField.exportQueryFieldAs,
			avExportTableField.exportTableID, avExportTableField.exportTableFieldName, avExportTableField.exportTableFieldType,
			avExportTableField.exportTableFieldXmlName, avExportTableField.exportTableFieldXmlStatus,
			avExportTableField.exportTableFieldTabName, avExportTableField.exportTableFieldTabStatus,
			avExportTableField.exportTableFieldHtmlName, avExportTableField.exportTableFieldHtmlStatus,
			avExportTable.exportTableName
		FROM avExportTableField
			INNER JOIN avExportQueryField ON avExportTableField.exportTableFieldID = avExportQueryField.exportTableFieldID
			INNER JOIN avExportTable ON avExportTableField.exportTableID = avExportTable.exportTableID
		WHERE avExportQueryField.exportQueryID = <cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">
		ORDER BY avExportQueryField.exportQueryFieldOrder
	</cfquery>

	<cfreturn qry_selectExportQueryFieldList>
</cffunction>

<cffunction Name="switchExportQueryFieldOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing export query field">
	<cfargument Name="exportQueryFieldID" Type="numeric" Required="Yes">
	<cfargument Name="exportQueryFieldOrder_direction" Type="string" Required="Yes">

	<cfset var qry_selectExportQueryFieldOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchExportQueryFieldOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportQueryField
		SET exportQueryFieldOrder = exportQueryFieldOrder 
			<cfif Arguments.exportQueryFieldOrder_direction is "moveExportQueryFieldDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE exportQueryFieldID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avExportQueryField INNER JOIN avExportQueryField AS avExportQueryField2
			SET avExportQueryField.exportQueryFieldOrder = avExportQueryField.exportQueryFieldOrder 
				<cfif Arguments.exportQueryFieldOrder_direction is "moveExportQueryFieldDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avExportQueryField.exportQueryFieldOrder = avExportQueryField2.exportQueryFieldOrder
				AND avExportQueryField.exportQueryID = avExportQueryField2.exportQueryID
				AND avExportQueryField.exportQueryFieldID <> <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">
				AND avExportQueryField2.exportQueryID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avExportQueryField
			SET exportQueryFieldOrder = exportQueryFieldOrder 
				<cfif Arguments.exportQueryFieldOrder_direction is "moveExportQueryFieldDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE exportQueryFieldID <> <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">
				AND exportQueryID = (SELECT exportQueryID FROM avExportQueryField WHERE exportQueryFieldID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">)
				AND exportQueryFieldOrder = (SELECT exportQueryFieldOrder FROM avExportQueryField WHERE exportQueryFieldID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="deleteExportQueryField" Access="public" Output="No" ReturnType="boolean" Hint="Remove field from existing export query">
	<cfargument Name="exportQueryFieldID" Type="numeric" Required="Yes">

	<!--- need to delete from avExportQueryFieldCompany? --->
	<cftransaction>
	<cfquery Name="qry_selectExportQueryFieldOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportQueryFieldOrder, exportQueryID
		FROM avExportQueryField
		WHERE exportQueryFieldID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_selectExportQueryFieldOrder.RecordCount is 1>
		<cfquery Name="qry_deleteExportQueryField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			DELETE FROM avExportQueryField
			WHERE exportQueryFieldID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">;

			UPDATE avExportQueryField
			SET exportQueryFieldOrder = exportQueryFieldOrder - <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE exportQueryID = <cfqueryparam Value="#qry_selectExportQueryFieldOrder.exportQueryID#" cfsqltype="cf_sql_integer">
				AND exportQueryFieldOrder >= <cfqueryparam Value="#qry_selectExportQueryFieldOrder.exportQueryFieldOrder#" cfsqltype="cf_sql_smallint">;
		</cfquery>
	</cfif>
	</cftransaction>

	<cfreturn True>
</cffunction>

</cfcomponent>
