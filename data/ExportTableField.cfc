<cfcomponent DisplayName="ExportTableField" Hint="Manages customizing export options">

<cffunction name="maxlength_ExportTableField" access="public" output="no" returnType="struct">
	<cfset var maxlength_exportTableField = StructNew()>

	<cfset maxlength_exportTableField.exportTableFieldName = 100>
	<cfset maxlength_exportTableField.exportTableFieldType = 50>
	<cfset maxlength_exportTableField.exportTableFieldDescription = 255>
	<cfset maxlength_exportTableField.exportTableFieldXmlName = 100>
	<cfset maxlength_exportTableField.exportTableFieldTabName = 100>
	<cfset maxlength_exportTableField.exportTableFieldHtmlName = 100>

	<cfreturn maxlength_ExportTableField>
</cffunction>

<!--- Export Field --->
<cffunction Name="insertExportTableField" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new field in export table. Returns exportTableFieldID.">
	<cfargument Name="exportTableID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableFieldName" Type="string" Required="Yes">
	<cfargument Name="exportTableFieldType" Type="string" Required="No" Default="">
	<cfargument Name="exportTableFieldPrimaryKey" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportTableFieldSize" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportTableFieldDescription" Type="string" Required="No" Default="">
	<cfargument Name="exportTableFieldOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportTableFieldXmlName" Type="string" Required="No" Default="">
	<cfargument Name="exportTableFieldXmlStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportTableFieldTabName" Type="string" Required="No" Default="">
	<cfargument Name="exportTableFieldTabStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportTableFieldHtmlName" Type="string" Required="No" Default="">
	<cfargument Name="exportTableFieldHtmlStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportTableFieldStatus" Type="numeric" Required="No" Default="1">

	<cfset var qry_insertExportTableField = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.ExportTableField" method="maxlength_exportTableField" returnVariable="maxlength_exportTableField" />

	<cfquery Name="qry_insertExportTableField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportTableField
		SET exportTableFieldOrder = exportTableFieldOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
			AND exportTableFieldOrder >= <cfqueryparam Value="#Arguments.exportTableFieldOrder#" cfsqltype="cf_sql_smallint">;

		INSERT INTO avExportTableField
		(
			exportTableID, exportTableFieldName, exportTableFieldType, exportTableFieldPrimaryKey,
			exportTableFieldSize, exportTableFieldDescription, exportTableFieldOrder, exportTableFieldXmlName,
			exportTableFieldXmlStatus,exportTableFieldTabName, exportTableFieldTabStatus,
			exportTableFieldHtmlName, exportTableFieldHtmlStatus, exportTableFieldStatus
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.exportTableFieldName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldName#">,
			<cfqueryparam Value="#Arguments.exportTableFieldType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldType#">,
			<cfqueryparam Value="#Arguments.exportTableFieldPrimaryKey#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.exportTableFieldSize#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.exportTableFieldDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldDescription#">,
			<cfqueryparam Value="#Arguments.exportTableFieldOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.exportTableFieldXmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldXmlName#">,
			<cfqueryparam Value="#Arguments.exportTableFieldXmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.exportTableFieldTabName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldTabName#">,
			<cfqueryparam Value="#Arguments.exportTableFieldTabStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.exportTableFieldHtmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldHtmlName#">,
			<cfqueryparam Value="#Arguments.exportTableFieldHtmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.exportTableFieldStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "exportTableFieldID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertExportTableField.primaryKeyID>
</cffunction>

<cffunction Name="checkExportTableFieldNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check whether export field name is unique for export table.">
	<cfargument Name="exportTableID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableFieldName" Type="string" Required="Yes">
	<cfargument Name="exportTableFieldID" Type="numeric" Required="No">

	<cfset var qry_checkExportTableFieldNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkExportTableFieldNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportTableFieldID
		FROM avExportTableField
		WHERE exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
			AND exportTableFieldName = <cfqueryparam Value="#Arguments.exportTableFieldName#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "exportTableFieldID") and Application.fn_IsIntegerNonNegative(Arguments.exportTableFieldID)>
				AND exportTableFieldID <> <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkExportTableFieldNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectMaxExportTableFieldOrder" Access="public" Output="No" ReturnType="numeric" Hint="Select maximum order of export field within a table.">
	<cfargument Name="exportTableID" Type="numeric" Required="Yes">

	<cfset var qry_selectMaxExportTableFieldOrder = QueryNew("blank")>

	<cfquery Name="qry_selectMaxExportTableFieldOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Max(exportTableFieldOrder) AS maxExportTableFieldOrder
		FROM avExportTableField
		WHERE exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_selectMaxExportTableFieldOrder.RecordCount is 0 or Not IsNumeric(qry_selectMaxExportTableFieldOrder.maxExportTableFieldOrder)>
		<cfreturn 0>
	<cfelse>
		<cfreturn qry_selectMaxExportTableFieldOrder.maxExportTableFieldOrder>
	</cfif>
</cffunction>

<cffunction Name="updateExportTableField" Access="public" Output="No" ReturnType="boolean" Hint="Update existing export field.">
	<cfargument Name="exportTableFieldID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableFieldName" Type="string" Required="No">
	<cfargument Name="exportTableFieldType" Type="string" Required="No">
	<cfargument Name="exportTableFieldPrimaryKey" Type="numeric" Required="No">
	<cfargument Name="exportTableFieldSize" Type="numeric" Required="No">
	<cfargument Name="exportTableFieldDescription" Type="string" Required="No">
	<cfargument Name="exportTableFieldXmlName" Type="string" Required="No">
	<cfargument Name="exportTableFieldXmlStatus" Type="numeric" Required="No">
	<cfargument Name="exportTableFieldTabName" Type="string" Required="No">
	<cfargument Name="exportTableFieldTabStatus" Type="numeric" Required="No">
	<cfargument Name="exportTableFieldHtmlName" Type="string" Required="No">
	<cfargument Name="exportTableFieldHtmlStatus" Type="numeric" Required="No">
	<cfargument Name="exportTableFieldStatus" Type="numeric" Required="No">

	<cfset var displayComma = False>

	<cfinvoke component="#Application.billingMapping#data.ExportTableField" method="maxlength_exportTableField" returnVariable="maxlength_exportTableField" />

	<cfquery Name="qry_updateExportTableField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportTableField
		SET
			<cfif StructKeyExists(Arguments, "exportTableFieldName")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldName = <cfqueryparam Value="#Arguments.exportTableFieldName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldName#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldType")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldType = <cfqueryparam Value="#Arguments.exportTableFieldType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldType#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldPrimaryKey") and ListFind("0,1", Arguments.exportTableFieldPrimaryKey)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldPrimaryKey = <cfqueryparam Value="#Arguments.exportTableFieldPrimaryKey#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldSize") and Application.fn_IsIntegerNonNegative(Arguments.exportTableFieldSize)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldSize = <cfqueryparam Value="#Arguments.exportTableFieldSize#" cfsqltype="cf_sql_smallint"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldDescription")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldDescription = <cfqueryparam Value="#Arguments.exportTableFieldDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldDescription#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldXmlName")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldXmlName = <cfqueryparam Value="#Arguments.exportTableFieldXmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldXmlName#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldXmlStatus") and ListFind("0,1", Arguments.exportTableFieldXmlStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldXmlStatus = <cfqueryparam Value="#Arguments.exportTableFieldXmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldTabName")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldTabName = <cfqueryparam Value="#Arguments.exportTableFieldTabName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldTabName#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldTabStatus") and ListFind("0,1", Arguments.exportTableFieldTabStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldTabStatus = <cfqueryparam Value="#Arguments.exportTableFieldTabStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldHtmlName")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldHtmlName = <cfqueryparam Value="#Arguments.exportTableFieldHtmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_exportTableField.exportTableFieldHtmlName#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldHtmlStatus") and ListFind("0,1", Arguments.exportTableFieldHtmlStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldHtmlStatus = <cfqueryparam Value="#Arguments.exportTableFieldHtmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldStatus") and ListFind("0,1", Arguments.exportTableFieldStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldStatus = <cfqueryparam Value="#Arguments.exportTableFieldStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		WHERE exportTableFieldID = <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectExportTableField" Access="public" Output="No" ReturnType="query" Hint="Select existing field.">
	<cfargument Name="exportTableFieldID" Type="numeric" Required="Yes">

	<cfset var qry_selectExportTableField = QueryNew("blank")>

	<cfquery Name="qry_selectExportTableField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportTableID, exportTableFieldName, exportTableFieldType, exportTableFieldSize, exportTableFieldDescription, exportTableFieldOrder,
			exportTableFieldXmlName, exportTableFieldXmlStatus, exportTableFieldTabName, exportTableFieldTabStatus,
			exportTableFieldHtmlName, exportTableFieldHtmlStatus, exportTableFieldStatus, exportTableFieldPrimaryKey
		FROM avExportTableField
		WHERE exportTableFieldID = <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectExportTableField>
</cffunction>

<cffunction Name="selectExportTableFieldList" Access="public" Output="No" ReturnType="query" Hint="Select all existing export fields for a table for a particular export method.">
	<cfargument Name="exportTableID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableFieldStatus" Type="numeric" Required="No">
	<cfargument Name="exportMethod" Type="string" Required="No" Default="">
	<cfargument Name="exportMethodStatus" Type="numeric" Required="No">

	<cfset var exportMethodStatus_field = "">
	<cfset var exportMethodStatus_orderBy = "">
	<cfset var qry_selectExportTableFieldList = QueryNew("blank")>

	<cfswitch expression="#Arguments.exportMethod#">
	<cfcase value="xml">
		<cfset exportMethodStatus_field = "exportTableFieldXmlStatus">
		<cfset exportMethodStatus_orderBy = "exportTableFieldXmlOrder">
	</cfcase>
	<cfcase value="tab">
		<cfset exportMethodStatus_field = "exportTableFieldTabStatus">
		<cfset exportMethodStatus_orderBy = "exportTableFieldTabOrder">
	</cfcase>
	<cfcase value="html">
		<cfset exportMethodStatus_field = "exportTableFieldHtmlStatus">
		<cfset exportMethodStatus_orderBy = "exportTableFieldHtmlOrder">
	</cfcase>
	<cfdefaultcase>
		<cfset exportMethodStatus_field = "exportTableFieldHtmlStatus">
		<cfset exportMethodStatus_orderBy = "exportTableFieldHtmlOrder">
	</cfdefaultcase>
	</cfswitch>

	<cfquery Name="qry_selectExportTableFieldList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportTableFieldID, exportTableID, exportTableFieldName, exportTableFieldType, exportTableFieldSize,
			exportTableFieldDescription, exportTableFieldOrder, exportTableFieldXmlName, exportTableFieldXmlStatus,
			exportTableFieldTabName, exportTableFieldTabStatus, exportTableFieldHtmlName, exportTableFieldHtmlStatus,
			exportTableFieldStatus, exportTableFieldPrimaryKey
		FROM avExportTableField
		WHERE exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "exportTableFieldStatus") and ListFind("0,1", Arguments.exportTableFieldStatus)>
				AND exportTableFieldStatus = <cfqueryparam Value="#Arguments.exportTableFieldStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "exportMethodStatus") and ListFind("0,1", Arguments.exportMethodStatus)>
				AND #exportMethodStatus_field# = <cfqueryparam Value="#Arguments.exportMethodStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY exportTableFieldOrder
	</cfquery>

	<cfreturn qry_selectExportTableFieldList>
</cffunction>

<cffunction Name="switchExportTableFieldOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing export fields within a table">
	<cfargument Name="exportTableFieldID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableFieldOrder_direction" Type="string" Required="Yes">

	<cfset var qry_selectExportTableFieldOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchExportTableFieldOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportTableField
		SET exportTableFieldOrder = exportTableFieldOrder 
			<cfif Arguments.exportTableFieldOrder_direction is "moveExportTableFieldDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE exportTableFieldID = <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avExportTableField INNER JOIN avExportTableField AS avExportTableField2
			SET avExportTableField.exportTableFieldOrder = avExportTableField.exportTableFieldOrder 
				<cfif Arguments.exportTableFieldOrder_direction is "moveExportTableFieldDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avExportTableField.exportTableFieldOrder = avExportTableField2.exportTableFieldOrder
				AND avExportTableField.exportTableID = avExportTableField2.exportTableID
				AND avExportTableField.exportTableFieldID <> <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">
				AND avExportTableField.exportTableFieldID = <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avExportTableField
			SET exportTableFieldOrder = exportTableFieldOrder 
				<cfif Arguments.exportTableFieldOrder_direction is "moveExportTableFieldDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE exportTableFieldID <> <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">
				AND exportTableID = (SELECT exportTableID FROM avExportTableField WHERE exportTableFieldID = <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">)
				AND exportTableFieldOrder = (SELECT exportTableFieldOrder FROM avExportTableField WHERE exportTableFieldID = <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
