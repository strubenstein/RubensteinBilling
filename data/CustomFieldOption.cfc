<cfcomponent DisplayName="CustomFieldOption" Hint="Manages custom field options">

<cffunction name="maxlength_CustomFieldOption" access="public" output="no" returnType="struct">
	<cfset var maxlength_CustomFieldOption = StructNew()>

	<cfset maxlength_CustomFieldOption.customFieldOptionLabel = 100>
	<cfset maxlength_CustomFieldOption.customFieldOptionValue = 100>

	<cfreturn maxlength_CustomFieldOption>
</cffunction>

<!--- CUSTOM FIELD OPTIONS --->
<cffunction Name="insertCustomFieldOption" Access="public" Output="No" ReturnType="boolean" Hint="Insert cusotm fields options and returns True">
	<cfargument Name="customFieldID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="customFieldOptionLabel" Type="array" Required="Yes">
	<cfargument Name="customFieldOptionValue" Type="array" Required="Yes">

	<cfset var qry_insertCustomFieldOption_updateVersion_select = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.CustomFieldOption" method="maxlength_CustomFieldOption" returnVariable="maxlength_CustomFieldOption" />

	<cftransaction>
	<cfquery Name="qry_insertCustomFieldOption" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCustomFieldOption
		SET customFieldOptionStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			customFieldOptionDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
			AND customFieldOptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;

		<cfloop Index="count" From="1" To="#ArrayLen(Arguments.customFieldOptionLabel)#">
			INSERT INTO avCustomFieldOption
			(
				customFieldID, customFieldOptionLabel, customFieldOptionValue,  customFieldOptionOrder, customFieldOptionStatus,
				customFieldOptionVersion, userID, customFieldOptionDateCreated, customFieldOptionDateUpdated
			)
			VALUES
			(
				<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.customFieldOptionLabel[count]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomFieldOption.customFieldOptionLabel#">,
				<cfqueryparam Value="#Arguments.customFieldOptionValue[count]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomFieldOption.customFieldOptionValue#">,
				<cfqueryparam Value="#count#" cfsqltype="cf_sql_smallint">,
				<cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="0" cfsqltype="cf_sql_smallint">,
				<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
				#Application.billingSql.sql_nowDateTime#,
				#Application.billingSql.sql_nowDateTime#
			)
		</cfloop>
	</cfquery>

	<cfquery Name="qry_insertCustomFieldOption_updateVersion_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT MAX(customFieldOptionVersion) AS maxCustomFieldOptionVersion
		FROM avCustomFieldOption
		WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery Name="qry_insertCustomFieldOption_updateVersion" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCustomFieldOption
		SET customFieldOptionVersion = <cfqueryparam Value="1" cfsqltype="cf_sql_smallint"> + 
			<cfif Not IsNumeric(qry_insertCustomFieldOption_updateVersion_select.maxCustomFieldOptionVersion)>
				<cfqueryparam Value="0" cfsqltype="cf_sql_smallint">
			<cfelse>
				<cfqueryparam Value="#qry_insertCustomFieldOption_updateVersion_select.maxCustomFieldOptionVersion#" cfsqltype="cf_sql_smallint">
			</cfif>
		WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
			AND customFieldOptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="selectCustomFieldOption" Access="public" Output="No" ReturnType="query" Hint="Select designated custom field option">
	<cfargument Name="customFieldOptionID" Type="numeric" Required="Yes">

	<cfset var qry_selectCustomFieldOption = QueryNew("blank")>

	<cfquery Name="qry_selectCustomFieldOption" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT customFieldID, customFieldOptionLabel, customFieldOptionValue, customFieldOptionOrder, customFieldOptionStatus,
			customFieldOptionVersion, userID, customFieldOptionDateCreated, customFieldOptionDateUpdated
		FROM avCustomFieldOption
		WHERE customFieldOptionID = <cfqueryparam Value="#Arguments.customFieldOptionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectCustomFieldOption>
</cffunction>

<cffunction Name="selectCustomFieldOptionList" Access="public" Output="No" ReturnType="query" Hint="Select designated custom field options">
	<cfargument Name="customFieldID" Type="string" Required="Yes">
	<cfargument Name="customFieldOptionStatus" Type="numeric" Required="No">
	<cfargument Name="customFieldOptionVersion" Type="string" Required="No">

	<cfset var qry_selectCustomFieldOptionList = QueryNew("blank")>

	<cfquery Name="qry_selectCustomFieldOptionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT customFieldOptionID, customFieldID, customFieldOptionLabel, customFieldOptionValue, customFieldOptionOrder,
			customFieldOptionStatus, customFieldOptionVersion, userID, customFieldOptionDateCreated, customFieldOptionDateUpdated
		FROM avCustomFieldOption
		WHERE customFieldID IN (<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "customFieldOptionStatus") and ListFind("0,1", Arguments.customFieldOptionStatus)>AND customFieldOptionStatus = <cfqueryparam Value="#Arguments.customFieldOptionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "customFieldOptionVersion") and Application.fn_IsIntegerList(Arguments.customFieldOptionVersion)>AND customFieldOptionVersion IN (<cfqueryparam Value="#Arguments.customFieldOptionVersion#" cfsqltype="cf_sql_smallint" List="Yes" Separator=",">)</cfif>
		ORDER BY customFieldID, customFieldOptionVersion DESC, customFieldOptionOrder
	</cfquery>

	<cfreturn qry_selectCustomFieldOptionList>
</cffunction>

</cfcomponent>
