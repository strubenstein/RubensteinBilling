<cfcomponent DisplayName="ExportQueryFieldCompany" Hint="Manages customizing export options">

<!--- Export Query Company --->
<cffunction Name="insertExportQueryFieldCompany" Access="public" Output="No" ReturnType="boolean" Hint="Inserts company query field setting. Returns True.">
	<cfargument Name="exportQueryFieldID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportQueryFieldCompanyXmlStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportQueryFieldCompanyTabStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportQueryFieldCompanyHtmlStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="exportQueryFieldCompanyOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_insertExportQueryFieldCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avExportQueryFieldCompany
		(
			companyID, exportQueryFieldID, exportQueryFieldCompanyXmlStatus, exportQueryFieldCompanyTabStatus,
			exportQueryFieldCompanyHtmlStatus, exportQueryFieldCompanyOrder, userID
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.exportQueryFieldCompanyXmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.exportQueryFieldCompanyTabStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.exportQueryFieldCompanyHtmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.exportQueryFieldCompanyOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateExportQueryFieldCompany" Access="public" Output="No" ReturnType="boolean" Hint="Update existing export company query field settings.">
	<cfargument Name="exportQueryFieldID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportQueryFieldCompanyXmlStatus" Type="numeric" Required="No">
	<cfargument Name="exportQueryFieldCompanyTabStatus" Type="numeric" Required="No">
	<cfargument Name="exportQueryFieldCompanyHtmlStatus" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfset var displayComma = False>

	<cfquery Name="qry_updateExportQueryFieldCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avExportQueryFieldCompany
		SET
			<cfif StructKeyExists(Arguments, "exportQueryFieldCompanyXmlStatus") and ListFind("0,1", Arguments.exportQueryFieldCompanyXmlStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportQueryFieldCompanyXmlStatus = <cfqueryparam Value="#Arguments.exportQueryFieldCompanyXmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "exportQueryFieldCompanyTabStatus") and ListFind("0,1", Arguments.exportQueryFieldCompanyTabStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportQueryFieldCompanyTabStatus = <cfqueryparam Value="#Arguments.exportQueryFieldCompanyTabStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "exportQueryFieldCompanyHtmlStatus") and ListFind("0,1", Arguments.exportQueryFieldCompanyHtmlStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>exportQueryFieldCompanyHtmlStatus = <cfqueryparam Value="#Arguments.exportQueryFieldCompanyHtmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"></cfif>
		WHERE exportQueryFieldID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectExportQueryFieldCompany" Access="public" Output="No" ReturnType="query" Hint="Select existing company custom query field setting.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportQueryFieldID" Type="numeric" Required="Yes">

	<cfset var qry_selectExportQueryFieldCompany = QueryNew("blank")>

	<cfquery Name="qry_selectExportQueryFieldCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT exportQueryFieldCompanyXmlStatus, exportQueryFieldCompanyTabStatus,
			exportQueryFieldCompanyHtmlStatus, exportQueryFieldCompanyOrder, userID
		FROM avExportQueryFieldCompany
		WHERE exportQueryFieldID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectExportQueryFieldCompany>
</cffunction>

<cffunction Name="selectExportQueryFieldCompanyList" Access="public" Output="No" ReturnType="query" Hint="Select all existing company export fields for a query.">
	<cfargument Name="exportQueryID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_selectExportQueryFieldCompanyList = QueryNew("blank")>

	<cfquery Name="qry_selectExportQueryFieldCompanyList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avExportQueryFieldCompany.exportQueryFieldID, avExportQueryFieldCompany.userID,
			avExportQueryFieldCompany.exportQueryFieldCompanyXmlStatus, avExportQueryFieldCompany.exportQueryFieldCompanyTabStatus,
			avExportQueryFieldCompany.exportQueryFieldCompanyHtmlStatus, avExportQueryFieldCompany.exportQueryFieldCompanyOrder,
			avExportQueryField.exportTableFieldID
		FROM avExportQueryFieldCompany, avExportQueryField
		WHERE avExportQueryFieldCompany.exportQueryFieldID = avExportQueryField.exportQueryFieldID
			AND avExportQueryField.exportQueryID = <cfqueryparam Value="#Arguments.exportQueryID#" cfsqltype="cf_sql_integer">
			AND avExportQueryFieldCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectExportQueryFieldCompanyList>
</cffunction>

<cffunction Name="deleteExportQueryFieldCompany" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing company custom query field setting.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportQueryFieldID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteExportQueryFieldCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avExportQueryFieldCompany
		WHERE exportQueryFieldID = <cfqueryparam Value="#Arguments.exportQueryFieldID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectExportQueryForCompany" Access="public" Output="No" ReturnType="query" Hint="Returns modified query for exporting results based on export method and company options">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="exportQueryName" Type="string" Required="Yes">
	<cfargument Name="exportResultsMethod" Type="string" Required="Yes"><!--- excel,tab,xml,html --->

	<cfset var qry_selectExportQueryForCompany = QueryNew("blank")>

	<!--- 
	- Get exportQueryID
	- Get fields used in query
	- Get company custom options for query fields: custom order, status
	- Get fields from table info for query
	- Get ocmpany custom options for table fields
	- Return single query will all fields and custom options in custom-defined order
	--->

	<!--- 
	UNUSED FIELDS:
	avExportQueryField.exportTableFieldID,
	avExportQueryField.exportQueryFieldOrder,
	avExportQueryFieldCompany.exportQueryFieldCompanyOrder, 
	avExportTableField.exportTableID, 
	avExportTableField.exportTableFieldPrimaryKey,
	avExportTableField.exportTableFieldSize,
	avExportTableField.exportTableFieldType,
	avExportTableFieldCompany.exportTableFieldCompanyStatus,
	--->

	<cfquery Name="qry_selectExportQueryForCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avExportTableField.exportTableFieldName, avExportQueryField.exportQueryFieldAs,
			<cfswitch expression="#Arguments.exportResultsMethod#">
			<cfcase value="xml">
				avExportTableField.exportTableFieldXmlName AS exportTableFieldName_default,
				avExportTableFieldCompany.exportTableFieldCompanyXmlName AS exportTableFieldName_custom
			</cfcase>
			<cfcase value="html">
				avExportTableField.exportTableFieldHtmlName AS exportTableFieldName_default,
				avExportTableFieldCompany.exportTableFieldCompanyHtmlName AS exportTableFieldName_custom
			</cfcase>
			<cfdefaultcase><!--- tab,excel --->
				avExportTableField.exportTableFieldTabName AS exportTableFieldName_default,
				avExportTableFieldCompany.exportTableFieldCompanyTabName AS exportTableFieldName_custom
			</cfdefaultcase>
			</cfswitch>
		FROM avExportQueryField
			INNER JOIN avExportTableField ON avExportQueryField.exportTableFieldID = avExportTableField.exportTableFieldID
			LEFT OUTER JOIN avExportQueryFieldCompany ON 
				avExportQueryField.exportQueryFieldID = avExportQueryFieldCompany.exportQueryFieldID
				AND avExportQueryFieldCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			LEFT OUTER JOIN avExportTableFieldCompany ON 
				avExportQueryField.exportTableFieldID = avExportTableFieldCompany.exportTableFieldID
				AND avExportTableFieldCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
		WHERE avExportQueryField.exportQueryID = (SELECT exportQueryID FROM avExportQuery WHERE exportQueryName = <cfqueryparam Value="#Arguments.exportQueryName#" cfsqltype="cf_sql_varchar">)
			AND avExportTableField.exportTableFieldStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			<cfswitch expression="#Arguments.exportResultsMethod#">
			<cfcase value="xml">
				AND avExportTableField.exportTableFieldXmlStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND (avExportQueryFieldCompany.exportQueryFieldCompanyXmlStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					OR avExportQueryFieldCompany.exportQueryFieldCompanyXmlStatus IS NULL)
			</cfcase>
			<cfcase value="html">
				AND avExportTableField.exportTableFieldHtmlStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND (avExportQueryFieldCompany.exportQueryFieldCompanyHtmlStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					OR avExportQueryFieldCompany.exportQueryFieldCompanyHtmlStatus IS NULL)
			</cfcase>
			<cfdefaultcase><!--- tab,excel --->
				AND avExportTableField.exportTableFieldTabStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND (avExportQueryFieldCompany.exportQueryFieldCompanyTabStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					OR avExportQueryFieldCompany.exportQueryFieldCompanyTabStatus IS NULL)
			</cfdefaultcase>
			</cfswitch>
		ORDER BY avExportQueryField.exportQueryFieldOrder
	</cfquery>

	<cfreturn qry_selectExportQueryForCompany>
</cffunction>

</cfcomponent>

