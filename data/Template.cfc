<cfcomponent DisplayName="Template" Hint="Manages creating and updating templates for category and product pages">

<cffunction name="maxlength_Template" access="public" output="no" returnType="struct">
	<cfset var maxlength_Template = StructNew()>

	<cfset maxlength_Template.templateName = 100>
	<cfset maxlength_Template.templateFilename = 50>
	<cfset maxlength_Template.templateType = 50>
	<cfset maxlength_Template.templateDescription = 255>

	<cfreturn maxlength_Template>
</cffunction>

<cffunction Name="insertTemplate" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new template. Returns templateID.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="templateName" Type="string" Required="Yes">
	<cfargument Name="templateFilename" Type="string" Required="Yes">
	<cfargument Name="templateType" Type="string" Required="Yes">
	<cfargument Name="templateDescription" Type="string" Required="No" Default="">
	<cfargument Name="templateStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="templateDefault" Type="numeric" Required="No" Default="0">
	<cfargument Name="templateXml" Type="string" Required="No" Default="">

	<cfset var qry_insertTemplate = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Template" method="maxlength_Template" returnVariable="maxlength_Template" />

	<cfquery Name="qry_insertTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avTemplate
		(
			companyID, userID, templateName, templateFilename, templateType, templateDescription,
			templateStatus, templateDefault, templateXml, templateDateCreated, templateDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.templateName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Template.templateName#">,
			<cfqueryparam Value="#Arguments.templateFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Template.templateFilename#">,
			<cfqueryparam Value="#Arguments.templateType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Template.templateType#">,
			<cfqueryparam Value="#Arguments.templateDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Template.templateDescription#">,
			<cfqueryparam Value="#Arguments.templateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.templateDefault#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.templateXml#" cfsqltype="cf_sql_longvarchar">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "templateID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertTemplate.primaryKeyID>
</cffunction>

<cffunction Name="checkTemplateNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify template name is unique for company and type.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="templateName" Type="string" Required="Yes">
	<cfargument Name="templateType" Type="string" Required="Yes">
	<cfargument Name="templateID" Type="numeric" Required="No">

	<cfset var qry_checkTemplateNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkTemplateNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT templateID
		FROM avTemplate
		WHERE companyID IN (<cfqueryparam Value="0,#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND templateType = <cfqueryparam Value="#Arguments.templateType#" cfsqltype="cf_sql_varchar">
			AND templateName = <cfqueryparam Value="#Arguments.templateName#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "templateID") and Application.fn_IsIntegerNonNegative(Arguments.templateID)>
				AND templateID <> <cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkTemplateNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkTemplateFilenameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify template filename is unique for company.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="templateFilename" Type="string" Required="Yes">
	<cfargument Name="templateID" Type="numeric" Required="No">

	<cfset var qry_checkTemplateFilenameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkTemplateFilenameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT templateID
		FROM avTemplate
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND templateFilename = <cfqueryparam Value="#Arguments.templateFilename#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "templateID") and Application.fn_IsIntegerNonNegative(Arguments.templateID)>
				AND templateID <> <cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkTemplateFilenameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkTemplatePermission" Access="public" Output="No" ReturnType="boolean" Hint="Verify company has permission for template.">
	<cfargument Name="templateID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="string" Required="Yes">

	<cfset var qry_checkTemplatePermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.companyID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkTemplatePermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT templateID, companyID
			FROM avTemplate
			WHERE companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND templateID = <cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfif qry_checkTemplatePermission.RecordCount is 1>
			<cfreturn True>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="updateTemplate" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing template. Returns True.">
	<cfargument Name="templateID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="templateName" Type="string" Required="No">
	<cfargument Name="templateFilename" Type="string" Required="No">
	<cfargument Name="templateType" Type="string" Required="No">
	<cfargument Name="templateDescription" Type="string" Required="No">
	<cfargument Name="templateStatus" Type="numeric" Required="No">
	<cfargument Name="templateDefault" Type="numeric" Required="No">
	<cfargument Name="templateXml" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Template" method="maxlength_Template" returnVariable="maxlength_Template" />

	<cfquery Name="qry_updateTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avTemplate
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "templateName")>templateName = <cfqueryparam Value="#Arguments.templateName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Template.templateName#">,</cfif>
			<cfif StructKeyExists(Arguments, "templateFilename")>templateFilename = <cfqueryparam Value="#Arguments.templateFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Template.templateFilename#">,</cfif>
			<cfif StructKeyExists(Arguments, "templateType")>templateType = <cfqueryparam Value="#Arguments.templateType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Template.templateType#">,</cfif>
			<cfif StructKeyExists(Arguments, "templateDescription")>templateDescription = <cfqueryparam Value="#Arguments.templateDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Template.templateDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "templateStatus") and ListFind("0,1", Arguments.templateStatus)>templateStatus = <cfqueryparam Value="#Arguments.templateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "templateDefault") and ListFind("0,1", Arguments.templateDefault)>templateDefault = <cfqueryparam Value="#Arguments.templateDefault#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "templateXml")>templateXml = <cfqueryparam Value="#Arguments.templateXml#" cfsqltype="cf_sql_longvarchar">,</cfif>
			templateDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE templateID = <cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateTemplateFilename" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing template filename for products or categories if filename changed. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="templateType" Type="string" Required="Yes">
	<cfargument Name="templateFilename_old" Type="string" Required="Yes">
	<cfargument Name="templateFilename_new" Type="string" Required="Yes">

	<cfinvoke component="#Application.billingMapping#data.Template" method="maxlength_Template" returnVariable="maxlength_Template" />

	<cfquery Name="qry_updateTemplateFilename" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE 
		<cfswitch expression="#Arguments.templateType#">
		<cfcase value="Category">avCategory</cfcase>
		<cfcase value="Product">avProduct</cfcase>
		<cfdefaultcase>avTemplate</cfdefaultcase>
		</cfswitch>
		SET templateFilename = <cfqueryparam Value="#Arguments.templateFilename_new#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Template.templateName#">
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND templateFilename = <cfqueryparam Value="#Arguments.templateFilename_old#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Template.templateName#">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectTemplate" Access="public" Output="No" ReturnType="query" Hint="Select a particular templates">
	<cfargument Name="templateID" Type="numeric" Required="No">
	<cfargument Name="templateFilename" Type="string" Required="No">
	<cfargument Name="returnTemplateXML" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectTemplate = QueryNew("blank")>

	<cfquery Name="qry_selectTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT templateID, companyID, userID, templateName, templateFilename,
			templateType, templateDescription, templateStatus, templateDefault,
			templateDateCreated, templateDateUpdated
			<cfif StructKeyExists(Arguments, "returnTemplateXML") and Arguments.returnTemplateXML is True>, templateXml</cfif>
		FROM avTemplate
		WHERE 
			<cfif StructKeyExists(Arguments, "templateID") and Application.fn_IsIntegerNonNegative(Arguments.templateID)>
				templateID = <cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">
			<cfelseif StructKeyExists(Arguments, "templateFilename") and Trim(Arguments.templateFilename) is not "">
				templateFilename = <cfqueryparam Value="#Arguments.templateFilename#" cfsqltype="cf_sql_varchar">
			<cfelse>
				templateID = 0
			</cfif>
	</cfquery>

	<cfreturn qry_selectTemplate>
</cffunction>

<cffunction Name="selectTemplateList" Access="public" Output="No" ReturnType="query" Hint="Return all templates for a particular company">
	<cfargument Name="companyID" Type="string" Required="Yes">
	<cfargument Name="templateStatus" Type="numeric" Required="No">
	<cfargument Name="templateDefault" Type="numeric" Required="No">
	<cfargument Name="templateType" Type="string" Required="No">
	<cfargument Name="returnTemplateXML" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnTemplateUseCount" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectTemplateList = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.companyID)>
		<cfset Arguments.companyID = 0>
	</cfif>

	<cfquery Name="qry_selectTemplateList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT templateID, companyID, userID, templateName, templateFilename, templateType, templateDescription,
			templateStatus, templateDefault, templateDateCreated, templateDateUpdated
			<cfif StructKeyExists(Arguments, "returnTemplateXML") and Arguments.returnTemplateXML is True>, templateXml</cfif>
			<cfif StructKeyExists(Arguments, "returnTemplateUseCount") and Arguments.returnTemplateUseCount is True>
				,
				CASE templateType
				WHEN 'Category' THEN (SELECT COUNT(templateFilename) FROM avCategory WHERE avCategory.templateFilename = avTemplate.templateFilename)
				WHEN 'Product' THEN (SELECT COUNT(templateFilename) FROM avProduct WHERE avProduct.templateFilename = avTemplate.templateFilename)
				WHEN 'Invoice' THEN (SELECT COUNT(templateID) FROM avInvoiceTemplate WHERE avInvoiceTemplate.templateID = avTemplate.templateID)
				ELSE 0
				END
				AS templateUseCount
			</cfif>
		FROM avTemplate
		WHERE companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "templateType") and Arguments.templateType is not "">AND templateType IN (<cfqueryparam Value="#Arguments.templateType#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "templateStatus") and Arguments.templateStatus is not "">AND templateStatus = <cfqueryparam Value="#Arguments.templateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "templateDefault") and Arguments.templateDefault is not "">AND templateDefault = <cfqueryparam Value="#Arguments.templateDefault#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		ORDER BY templateType, companyID DESC, templateName
	</cfquery>

	<cfreturn qry_selectTemplateList>
</cffunction>

</cfcomponent>

