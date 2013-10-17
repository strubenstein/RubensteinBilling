<cfcomponent DisplayName="ExportTableFieldCompany" Hint="Manages customizing export options">

<cffunction name="maxlength_ExportTableFieldCompany" access="public" output="no" returnType="struct">
	<cfset var maxlength_ExportTableFieldCompany = StructNew()>

	<cfset maxlength_ExportTableFieldCompany.exportTableFieldCompanyXmlName = 100>
	<cfset maxlength_ExportTableFieldCompany.exportTableFieldCompanyTabName = 100>
	<cfset maxlength_ExportTableFieldCompany.exportTableFieldCompanyHtmlName = 100>

	<cfreturn maxlength_ExportTableFieldCompany>
</cffunction>

<!--- Export Table Field Company --->
<cffunction Name="insertExportTableFieldCompanyAll" Access="public" Output="No" ReturnType="boolean" Hint="Inserts default options for all fields in export table. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableID" Type="numeric" Required="Yes">

	<cfquery Name="qry_insertExportTableFieldCompanyAll" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avExportTableFieldCompany
		(
			companyID, exportTableFieldID, exportTableFieldCompanyXmlName, exportTableFieldCompanyTabName,
			exportTableFieldCompanyHtmlName, exportTableFieldCompanyStatus, userID
		)
		SELECT
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			exportTableFieldID,
			exportTableFieldXmlName,
			exportTableFieldTabName,
			exportTableFieldHtmlName,
			exportTableFieldStatus,
			0
		FROM avExportTableField
		WHERE exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
			AND exportTableFieldStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="insertExportTableFieldCompany" Access="public" Output="No" ReturnType="boolean" Hint="Inserts company field setting. Returns True.">
	<cfargument Name="exportTableFieldID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableFieldCompanyXmlName" Type="string" Required="No" Default="">
	<cfargument Name="exportTableFieldCompanyTabName" Type="string" Required="No" Default="">
	<cfargument Name="exportTableFieldCompanyHtmlName" Type="string" Required="No" Default="">
	<cfargument Name="exportTableFieldCompanyStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">

	<cfinvoke component="#Application.billingMapping#data.ExportTableFieldCompany" method="maxlength_exportTableFieldCompany" returnVariable="maxlength_exportTableFieldCompany" />

	<cfquery Name="qry_insertExportTableFieldCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avExportTableFieldCompany
		(
			companyID, exportTableFieldID, exportTableFieldCompanyXmlName, exportTableFieldCompanyTabName,
			exportTableFieldCompanyHtmlName, exportTableFieldCompanyStatus, userID
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.exportTableFieldCompanyXmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportTableFieldCompany.exportTableFieldCompanyXmlName#">,
			<cfqueryparam Value="#Arguments.exportTableFieldCompanyTabName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportTableFieldCompany.exportTableFieldCompanyTabName#">,
			<cfqueryparam Value="#Arguments.exportTableFieldCompanyHtmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportTableFieldCompany.exportTableFieldCompanyHtmlName#">,
			<cfqueryparam Value="#Arguments.exportTableFieldCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateExportTableFieldCompany" Access="public" Output="No" ReturnType="boolean" Hint="Update existing export company field.">
	<cfargument Name="exportTableFieldID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableFieldCompanyXmlName" Type="string" Required="No">
	<cfargument Name="exportTableFieldCompanyTabName" Type="string" Required="No">
	<cfargument Name="exportTableFieldCompanyHtmlName" Type="string" Required="No">
	<cfargument Name="exportTableFieldCompanyStatus" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfset var displayComma = False>

	<cfinvoke component="#Application.billingMapping#data.ExportTableFieldCompany" method="maxlength_exportTableFieldCompany" returnVariable="maxlength_exportTableFieldCompany" />

	<cfquery Name="qry_updateExportTableFieldCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportTableFieldCompany
		SET
			<cfif StructKeyExists(Arguments, "exportTableFieldCompanyXmlName")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldCompanyXmlName = <cfqueryparam Value="#Arguments.exportTableFieldCompanyXmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportTableFieldCompany.exportTableFieldCompanyXmlName#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldCompanyTabName")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldCompanyTabName = <cfqueryparam Value="#Arguments.exportTableFieldCompanyTabName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportTableFieldCompany.exportTableFieldCompanyTabName#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldCompanyHtmlName")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldCompanyHtmlName = <cfqueryparam Value="#Arguments.exportTableFieldCompanyHtmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ExportTableFieldCompany.exportTableFieldCompanyHtmlName#"></cfif>
			<cfif StructKeyExists(Arguments, "exportTableFieldCompanyStatus") and ListFind("0,1", Arguments.exportTableFieldCompanyStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportTableFieldCompanyStatus = <cfqueryparam Value="#Arguments.exportTableFieldCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"></cfif>
		WHERE exportTableFieldID = <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectExportTableFieldCompany" Access="public" Output="No" ReturnType="query" Hint="Select existing company custom field setting.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableFieldID" Type="numeric" Required="Yes">

	<cfset var qry_selectExportTableFieldCompany = QueryNew("blank")>

	<cfquery Name="qry_selectExportTableFieldCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportTableFieldCompanyStatus, userID, exportTableFieldCompanyXmlName,
			exportTableFieldCompanyTabName, exportTableFieldCompanyHtmlName
		FROM avExportTableFieldCompany
		WHERE exportTableFieldID = <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectExportTableFieldCompany>
</cffunction>

<cffunction Name="selectExportTableFieldCompanyList" Access="public" Output="No" ReturnType="query" Hint="Select all existing company export fields for a table for a particular export method.">
	<cfargument Name="exportTableID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportFieldStatus" Type="numeric" Required="No">
	<cfargument Name="exportTableFieldCompanyStatus" Type="numeric" Required="No">

	<cfset var qry_selectExportTableFieldCompanyList = QueryNew("blank")>

	<cfquery Name="qry_selectExportTableFieldCompanyList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avExportTableField.exportTableFieldID, avExportTableField.exportTableID, avExportTableField.exportTableFieldName,
			avExportTableField.exportTableFieldType, avExportTableField.exportTableFieldSize, avExportTableField.exportTableFieldDescription,
			avExportTableField.exportTableFieldOrder, avExportTableField.exportTableFieldStatus, avExportTableField.exportTableFieldPrimaryKey,
			avExportTableField.exportTableFieldXmlName, avExportTableField.exportTableFieldXmlStatus,
			avExportTableField.exportTableFieldTabName, avExportTableField.exportTableFieldTabStatus,
			avExportTableField.exportTableFieldHtmlName, avExportTableField.exportTableFieldHtmlStatus,
			avExportTableFieldCompany.exportTableFieldCompanyStatus, avExportTableFieldCompany.exportTableFieldCompanyXmlName,
			avExportTableFieldCompany.exportTableFieldCompanyTabName, avExportTableFieldCompany.exportTableFieldCompanyHtmlName
		FROM avExportTableField LEFT OUTER JOIN avExportTableFieldCompany
			ON avExportTableField.exportTableFieldID = avExportTableFieldCompany.exportTableFieldID
				AND avExportTableFieldCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				<cfif StructKeyExists(Arguments, "exportTableFieldCompanyStatus") and ListFind("0,1", Arguments.exportTableFieldCompanyStatus)>
					AND avExportTableFieldCompany.exportTableFieldCompanyStatus = <cfqueryparam Value="#Arguments.exportTableFieldCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
		WHERE avExportTableField.exportTableID = <cfqueryparam Value="#Arguments.exportTableID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "exportTableFieldStatus") and ListFind("0,1", Arguments.exportTableFieldStatus)>
				AND avExportTableField.exportTableFieldStatus = <cfqueryparam Value="#Arguments.exportTableFieldStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY avExportTableField.exportTableFieldOrder
	</cfquery>

	<cfreturn qry_selectExportTableFieldCompanyList>
</cffunction>

<cffunction Name="deleteExportTableFieldCompany" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing company custom field setting.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportTableFieldID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteExportTableFieldCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avExportTableFieldCompany
		WHERE exportTableFieldID = <cfqueryparam Value="#Arguments.exportTableFieldID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
