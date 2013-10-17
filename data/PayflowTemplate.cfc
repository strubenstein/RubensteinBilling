<cfcomponent DisplayName="PayflowTemplate" Hint="Manages templates used to generate invoice for payflow method">

<cffunction name="maxlength_PayflowTemplate" access="public" output="no" returnType="struct">
	<cfset var maxlength_PayflowTemplate = StructNew()>

	<cfset maxlength_PayflowTemplate.payflowTemplateType = 100>
	<cfset maxlength_PayflowTemplate.payflowTemplatePaymentMethod = 100>
	<cfset maxlength_PayflowTemplate.payflowTemplateNotifyMethod = 100>

	<cfreturn maxlength_PayflowTemplate>
</cffunction>

<!--- Payflow Template - display template --->
<cffunction Name="insertPayflowTemplate" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new payflow template. Returns True.">
	<cfargument Name="payflowID" Type="numeric" Required="Yes">
	<cfargument Name="templateID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowTemplateStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="payflowTemplateType" Type="string" Required="No" Default="">
	<cfargument Name="payflowTemplateNotifyMethod" Type="string" Required="No" Default="">
	<cfargument Name="payflowTemplatePaymentMethod" Type="string" Required="No" Default="">

	<cfinvoke component="#Application.billingMapping#data.PayflowTemplate" method="maxlength_PayflowTemplate" returnVariable="maxlength_PayflowTemplate" />

	<cfquery Name="qry_insertPayflowTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPayflowTemplate
		(
			payflowID, templateID, userID, payflowTemplateStatus, payflowTemplateType, payflowTemplateNotifyMethod,
			payflowTemplatePaymentMethod, payflowTemplateDateCreated, payflowTemplateDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.payflowTemplateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.payflowTemplateType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PayflowTemplate.payflowTemplateType#">,
			<cfqueryparam Value="#Arguments.payflowTemplateNotifyMethod#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PayflowTemplate.payflowTemplateNotifyMethod#">,
			<cfqueryparam Value="#Arguments.payflowTemplatePaymentMethod#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PayflowTemplate.payflowTemplatePaymentMethod#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updatePayflowTemplate" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing payflow template. Returns True.">
	<cfargument Name="payflowID" Type="numeric" Required="Yes">
	<cfargument Name="templateID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="payflowTemplateStatus" Type="numeric" Required="No">
	<cfargument Name="payflowTemplateType" Type="string" Required="No">
	<cfargument Name="payflowTemplateNotifyMethod" Type="string" Required="No">
	<cfargument Name="payflowTemplatePaymentMethod" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.PayflowTemplate" method="maxlength_PayflowTemplate" returnVariable="maxlength_PayflowTemplate" />

	<cfquery Name="qry_updatePayflowTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPayflowTemplate
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowTemplateStatus") and ListFind("0,1", Arguments.payflowTemplateStatus)>payflowTemplateStatus = <cfqueryparam Value="#Arguments.payflowTemplateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowTemplateType")>payflowTemplateType = <cfqueryparam Value="#Arguments.payflowTemplateType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PayflowTemplate.payflowTemplateType#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowTemplateNotifyMethod")>payflowTemplateNotifyMethod = <cfqueryparam Value="#Arguments.payflowTemplateNotifyMethod#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PayflowTemplate.payflowTemplateNotifyMethod#">,</cfif>
			<cfif StructKeyExists(Arguments, "payflowTemplatePaymentMethod")>,payflowTemplatePaymentMethod = <cfqueryparam Value="#Arguments.payflowTemplatePaymentMethod#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PayflowTemplate.payflowTemplatePaymentMethod#">,</cfif>
			payflowTemplateDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE payflowTemplateID = <cfqueryparam Value="#Arguments.payflowTemplateID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPayflowTemplate" Access="public" Output="No" ReturnType="query" Hint="Select payflow template.">
	<cfargument Name="payflowID" Type="numeric" Required="Yes">

	<cfset var qry_selectPayflowTemplate = QueryNew("blank")>

	<cfquery Name="qry_selectPayflowTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT payflowID, templateID, userID, payflowTemplateStatus,
			payflowTemplateType, payflowTemplateNotifyMethod, payflowTemplatePaymentMethod,
			payflowTemplateDateCreated, payflowTemplateDateUpdated
		FROM avPayflowTemplate
		WHERE payflowTemplateID = <cfqueryparam Value="#Arguments.payflowTemplateID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectPayflowTemplate>
</cffunction>

<cffunction Name="selectPayflowTemplateList" Access="public" Output="No" ReturnType="query" Hint="Select template for payflow(s).">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="templateID" Type="string" Required="No">
	<cfargument Name="payflowTemplateStatus" Type="numeric" Required="No">

	<cfset var qry_selectPayflowTemplateList = QueryNew("blank")>

	<cfquery Name="qry_selectPayflowTemplateList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avPayflowTemplate.payflowTemplateID, avPayflowTemplate.payflowID, avPayflowTemplate.templateID,
			avPayflowTemplate.payflowTemplateStatus, avPayflowTemplate.userID, avPayflowTemplate.payflowTemplateType,
			avPayflowTemplate.payflowTemplateNotifyMethod, avPayflowTemplate.payflowTemplatePaymentMethod,
			avPayflowTemplate.payflowTemplateDateCreated, avPayflowTemplate.payflowTemplateDateUpdated,
			avTemplate.templateFilename, avTemplate.templateStatus, avTemplate.templateName, avTemplate.templateDescription
		FROM avPayflowTemplate LEFT OUTER JOIN avTemplate ON avPayflowTemplate.templateID = avTemplate.templateID
		WHERE avPayflowTemplate.payflowTemplateID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "payflowTemplateID") and Application.fn_IsIntegerList(Arguments.payflowTemplateID)>AND avPayflowTemplate.payflowTemplateID IN (<cfqueryparam Value="#Arguments.payflowTemplateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "payflowID") and Application.fn_IsIntegerList(Arguments.payflowID)>AND avPayflowTemplate.payflowID IN (<cfqueryparam Value="#Arguments.payflowID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "templateID") and Application.fn_IsIntegerList(Arguments.templateID)>AND avPayflowTemplate.templateID IN (<cfqueryparam Value="#Arguments.templateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "payflowTemplateStatus") and ListFind("0,1", Arguments.payflowTemplateStatus)>AND avPayflowTemplate.payflowTemplateStatus = <cfqueryparam Value="#Arguments.payflowTemplateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "payflowTemplateType") and Trim(Arguments.payflowTemplateType) is not "">
				AND (<cfloop Index="count" From="1" To="#ListLen(Arguments.payflowTemplateType)#"><cfif count is not 1>OR</cfif> avPayflowTemplate.payflowTemplateType LIKE <cfqueryparam Value="%#ListGetAt(Arguments.payflowTemplateType, count)#%" cfsqltype="cf_sql_varchar"></cfloop>)
			</cfif>
			<cfif StructKeyExists(Arguments, "payflowTemplateNotifyMethod") and Trim(Arguments.payflowTemplateNotifyMethod) is not "">
				AND (<cfloop Index="count" From="1" To="#ListLen(Arguments.payflowTemplateNotifyMethod)#"><cfif count is not 1>OR</cfif> avPayflowTemplate.payflowTemplateNotifyMethod LIKE <cfqueryparam Value="%#ListGetAt(Arguments.payflowTemplateNotifyMethod, count)#%" cfsqltype="cf_sql_varchar"></cfloop>)
			</cfif>
			<cfif StructKeyExists(Arguments, "payflowTemplatePaymentMethod") and Trim(Arguments.payflowTemplatePaymentMethod) is not "">
				AND (<cfloop Index="count" From="1" To="#ListLen(Arguments.payflowTemplatePaymentMethod)#"><cfif count is not 1>OR</cfif> avPayflowTemplate.payflowTemplatePaymentMethod LIKE <cfqueryparam Value="%#ListGetAt(Arguments.payflowTemplatePaymentMethod, count)#%" cfsqltype="cf_sql_varchar"></cfloop>)
			</cfif>
		ORDER BY avPayflowTemplate.payflowID
	</cfquery>

	<cfreturn qry_selectPayflowTemplateList>
</cffunction>

</cfcomponent>
