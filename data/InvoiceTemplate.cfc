<cfcomponent DisplayName="Invoice" Hint="Manages inserting, updating, deleting and viewing invoice templates">

<cffunction Name="insertInvoiceTemplate" Access="public" Output="No" ReturnType="boolean" Hint="Insert template display of an invoice.">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="templateID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceTemplateStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="invoiceTemplateManual" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceTemplateText" Type="string" Required="No" Default="">
	<cfargument Name="invoiceTemplateHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_insertInvoiceTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avInvoiceTemplate
		(
			invoiceID, templateID, userID, invoiceTemplateManual, invoiceTemplateStatus,
			invoiceTemplateText, invoiceTemplateHtml, invoiceTemplateDateCreated, invoiceTemplateDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceTemplateManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.invoiceTemplateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.invoiceTemplateText#" cfsqltype="cf_sql_longvarchar">,
			<cfqueryparam Value="#Arguments.invoiceTemplateHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		<cfif Arguments.invoiceTemplateStatus is 1>
			UPDATE avInvoiceTemplate
			SET invoiceTemplateStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
				AND templateID <> <cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">;
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateInvoiceTemplate" Access="public" Output="No" ReturnType="boolean" Hint="Update existing invoice display for a given template.">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="templateID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceTemplateStatus" Type="numeric" Required="No">
	<cfargument Name="invoiceTemplateManual" Type="numeric" Required="No">
	<cfargument Name="invoiceTemplateText" Type="string" Required="No">
	<cfargument Name="invoiceTemplateHtml" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfquery Name="qry_updateInvoiceTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avInvoiceTemplate
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceTemplateManual") and ListFind("0,1", Arguments.invoiceTemplateManual)>invoiceTemplateManual = <cfqueryparam Value="#Arguments.invoiceTemplateManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceTemplateStatus") and ListFind("0,1", Arguments.invoiceTemplateStatus)>invoiceTemplateStatus = <cfqueryparam Value="#Arguments.invoiceTemplateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceTemplateText")>invoiceTemplateText = <cfqueryparam Value="#Arguments.invoiceTemplateText#" cfsqltype="cf_sql_longvarchar">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceTemplateHtml") and ListFind("0,1", Arguments.invoiceTemplateHtml)>invoiceTemplateHtml = <cfqueryparam Value="#Arguments.invoiceTemplateHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			invoiceTemplateDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
			AND templateID = <cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">;

		<cfif StructKeyExists(Arguments, "invoiceTemplateStatus") and Arguments.invoiceTemplateStatus is 1>
			UPDATE avInvoiceTemplate
			SET invoiceTemplateStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
				AND templateID <> <cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">;
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectInvoiceTemplate" Access="public" Output="No" ReturnType="query" Hint="Select existing invoice display">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="templateID" Type="numeric" Required="Yes">

	<cfset var qry_selectInvoiceTemplate = QueryNew("blank")>

	<cfquery Name="qry_selectInvoiceTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID, invoiceTemplateManual, invoiceTemplateStatus, invoiceTemplateText,
			invoiceTemplateHtml, invoiceTemplateDateCreated, invoiceTemplateDateUpdated
		FROM avInvoiceTemplate
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
			AND templateID = <cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectInvoiceTemplate>
</cffunction>

<cffunction Name="selectInvoiceTemplateList" Access="public" Output="No" ReturnType="query" Hint="Select existing invoice displays">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="templateID" Type="string" Required="No">
	<cfargument Name="invoiceTemplateStatus" Type="numeric" Required="No">
	<cfargument Name="invoiceTemplateManual" Type="numeric" Required="No">
	<cfargument Name="invoiceTemplateHtml" Type="numeric" Required="No">

	<cfset var qry_selectInvoiceTemplateList = QueryNew("blank")>

	<cfquery Name="qry_selectInvoiceTemplateList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT invoiceID, templateID, userID, invoiceTemplateManual, invoiceTemplateStatus, invoiceTemplateText,
			invoiceTemplateHtml, invoiceTemplateDateCreated, invoiceTemplateDateUpdated
		FROM avInvoiceTemplate
		WHERE invoiceID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerList(Arguments.invoiceID)>AND invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "templateID") and Application.fn_IsIntegerList(Arguments.templateID)>AND templateID IN (<cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfloop Index="field" List="invoiceTemplateManual,invoiceTemplateStatus,invoiceTemplateHtml">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND #field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif>
			</cfloop>
	</cfquery>

	<cfreturn qry_selectInvoiceTemplateList>
</cffunction>

</cfcomponent>
