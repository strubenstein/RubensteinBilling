<cfcomponent DisplayName="CustomField" Hint="Manages creating, viewing and managing custom fields">

<cffunction name="maxlength_CustomField" access="public" output="no" returnType="struct">
	<cfset var maxlength_CustomField = StructNew()>

	<cfset maxlength_CustomField.customFieldName = 100>
	<cfset maxlength_CustomField.customFieldTitle = 100>
	<cfset maxlength_CustomField.customFieldDescription = 255>
	<cfset maxlength_CustomField.customFieldType = 50>
	<cfset maxlength_CustomField.customFieldFormType = 20>

	<cfreturn maxlength_CustomField>
</cffunction>

<!--- CUSTOM FIELDS --->
<cffunction Name="insertCustomField" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new custom field and returns customFieldID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="customFieldName" Type="string" Required="Yes">
	<cfargument Name="customFieldTitle" Type="string" Required="Yes">
	<cfargument Name="customFieldDescription" Type="string" Required="No" Default="">
	<cfargument Name="customFieldType" Type="string" Required="Yes">
	<cfargument Name="customFieldFormType" Type="string" Required="No" Default="text">
	<cfargument Name="customFieldStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="customFieldExportXml" Type="numeric" Required="No" Default="0">
	<cfargument Name="customFieldExportTab" Type="numeric" Required="No" Default="0">
	<cfargument Name="customFieldExportHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="customFieldInternal" Type="numeric" Required="No" Default="0">

	<cfset var qry_insertCustomField = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.CustomField" method="maxlength_CustomField" returnVariable="maxlength_CustomField" />

	<cfquery Name="qry_insertCustomField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCustomField
		(
			companyID, userID, customFieldName, customFieldTitle, customFieldDescription, 
			customFieldType, customFieldFormType, customFieldStatus, customFieldExportXml,
			customFieldExportTab, customFieldExportHtml, customFieldInternal,
			customFieldDateCreated, customFieldDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.customFieldName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldName#">,
			<cfqueryparam Value="#Arguments.customFieldTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldTitle#">,
			<cfqueryparam Value="#Arguments.customFieldDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldDescription#">,
			<cfqueryparam Value="#Arguments.customFieldType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldType#">,
			<cfqueryparam Value="#Arguments.customFieldFormType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldFormType#">,
			<cfqueryparam Value="#Arguments.customFieldStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.customFieldExportXml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.customFieldExportTab#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.customFieldExportHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.customFieldInternal#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "customFieldID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertCustomField.primaryKeyID>
</cffunction>

<cffunction Name="updateCustomField" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing custom field and returns True">
	<cfargument Name="customFieldID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="customFieldName" Type="string" Required="No">
	<cfargument Name="customFieldTitle" Type="string" Required="No">
	<cfargument Name="customFieldDescription" Type="string" Required="No">
	<cfargument Name="customFieldType" Type="string" Required="No">
	<cfargument Name="customFieldFormType" Type="string" Required="No">
	<cfargument Name="customFieldStatus" Type="numeric" Required="No">
	<cfargument Name="customFieldExportXml" Type="numeric" Required="No">
	<cfargument Name="customFieldExportTab" Type="numeric" Required="No">
	<cfargument Name="customFieldExportHtml" Type="numeric" Required="No">
	<cfargument Name="customFieldInternal" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.CustomField" method="maxlength_CustomField" returnVariable="maxlength_CustomField" />

	<cfquery Name="qry_updateCustomField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCustomField
		SET 
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldName")>customFieldName = <cfqueryparam Value="#Arguments.customFieldName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldName#">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldTitle")>customFieldTitle = <cfqueryparam Value="#Arguments.customFieldTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldTitle#">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldDescription")>customFieldDescription = <cfqueryparam Value="#Arguments.customFieldDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldType")>customFieldType = <cfqueryparam Value="#Arguments.customFieldType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldType#">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldFormType")>customFieldFormType = <cfqueryparam Value="#Arguments.customFieldFormType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldFormType#">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldStatus") and ListFind("0,1", Arguments.customFieldStatus)>customFieldStatus = <cfqueryparam Value="#Arguments.customFieldStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldExportXml") and ListFind("0,1", Arguments.customFieldExportXml)>customFieldExportXml = <cfqueryparam Value="#Arguments.customFieldExportXml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldExportTab") and ListFind("0,1", Arguments.customFieldExportTab)>customFieldExportTab = <cfqueryparam Value="#Arguments.customFieldExportTab#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldExportHtml") and ListFind("0,1", Arguments.customFieldExportHtml)>customFieldExportHtml = <cfqueryparam Value="#Arguments.customFieldExportHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "customFieldInternal") and ListFind("0,1", Arguments.customFieldExportHtml)>customFieldInternal = <cfqueryparam Value="#Arguments.customFieldInternal#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			customFieldDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectCustomField" Access="public" Output="No" ReturnType="query" Hint="Selects existing custom field">
	<cfargument Name="customFieldID" Type="numeric" Required="Yes">

	<cfset var qry_selectCustomField = QueryNew("blank")>

	<cfquery Name="qry_selectCustomField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT customFieldID, companyID, userID, customFieldName, customFieldTitle, customFieldDescription, customFieldType,
			customFieldFormType, customFieldExportXml, customFieldExportTab, customFieldExportHtml, customFieldStatus,
			customFieldInternal, customFieldDateCreated, customFieldDateUpdated
		FROM avCustomField
		WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectCustomField>
</cffunction>

<cffunction Name="checkCustomFieldNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Validate custom field name is unique">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="customFieldName" Type="string" Required="Yes">
	<cfargument Name="customFieldID" Type="numeric" Required="No">

	<cfset var qry_checkCustomFieldNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkCustomFieldNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT customFieldID
		FROM avCustomField
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND customFieldName = <cfqueryparam Value="#Arguments.customFieldName#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "customFieldID") and Application.fn_IsIntegerNonNegative(Arguments.customFieldID)>
				AND customFieldID <> <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkCustomFieldNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkCustomFieldPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for custom field">
	<cfargument Name="customFieldID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_checkCustomFieldPermission = QueryNew("blank")>

	<cfquery Name="qry_checkCustomFieldPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT customFieldID
		FROM avCustomField
		WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkCustomFieldPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectCustomFieldList" Access="public" ReturnType="query" Hint="Select existing custom fields">
	<cfargument Name="companyID" Type="string" Required="Yes">
	<cfargument Name="customFieldType" Type="string" Required="No">
	<cfargument Name="customFieldStatus" Type="numeric" Required="No">
	<cfargument Name="customFieldID" Type="string" Required="No">
	<cfargument Name="customFieldName" Type="string" Required="No">
	<cfargument Name="customFieldExportXml" Type="numeric" Required="No">
	<cfargument Name="customFieldExportTab" Type="numeric" Required="No">
	<cfargument Name="customFieldExportHtml" Type="numeric" Required="No">
	<cfargument Name="customFieldInternal" Type="numeric" Required="No">

	<cfset var qry_selectCustomFieldList = QueryNew("blank")>

	<cfquery Name="qry_selectCustomFieldList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT customFieldID, companyID, userID, customFieldName, customFieldTitle, customFieldDescription, customFieldType,
			customFieldFormType, customFieldExportXml, customFieldExportTab, customFieldExportHtml, customFieldStatus,
			customFieldInternal, customFieldDateCreated, customFieldDateUpdated
		FROM avCustomField
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "customFieldType") and Arguments.customFieldType is not "">AND customFieldType = <cfqueryparam Value="#Arguments.customFieldType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomField.customFieldType#"></cfif>
			<cfloop Index="field" List="customFieldStatus,customFieldExportXml,customFieldExportTab,customFieldExportHtml,customFieldInternal">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND #field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "customFieldID") and Application.fn_IsIntegerList(Arguments.customFieldID)>AND customFieldID IN (<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "customFieldName") and Trim(Arguments.customFieldName) is not "">AND customFieldName IN (<cfqueryparam Value="#Arguments.customFieldName#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)</cfif>
		ORDER BY customFieldType, customFieldName
	</cfquery>

	<cfreturn qry_selectCustomFieldList>
</cffunction>

<cffunction Name="deleteCustomField" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing custom field">
	<cfargument Name="customFieldID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteCustomField" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avCustomField
		WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
