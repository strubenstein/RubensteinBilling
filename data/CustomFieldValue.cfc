<cfcomponent DisplayName="CustomFieldValue" Hint="Manages inserting and selecting custom field values">

<cffunction name="maxlength_CustomFieldDecimal" access="public" output="no" returnType="struct">
	<cfset var maxlength_CustomFieldDecimal = StructNew()>

	<cfset maxlength_CustomFieldDecimal.customFieldDecimalValue = 4>

	<cfreturn maxlength_CustomFieldDecimal>
</cffunction>

<cffunction name="maxlength_CustomFieldVarchar" access="public" output="no" returnType="struct">
	<cfset var maxlength_CustomFieldVarchar = StructNew()>

	<cfset maxlength_CustomFieldVarchar.customFieldVarcharValue = 1000>

	<cfreturn maxlength_CustomFieldVarchar>
</cffunction>

<cffunction Name="insertCustomFieldValue" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new custom field value for a given target and returns True">
	<cfargument Name="customFieldID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="customFieldOptionID" Type="numeric" Required="No" Default="0">
	<cfargument Name="customFieldType" Type="string" Required="Yes">
	<cfargument Name="customFieldValue" Type="string" Required="Yes">
	<cfargument Name="updateCustomFieldStatus" Type="boolean" Required="No" Default="True">

	<cfset var isFieldValueOk = True>

	<cfif Arguments.customFieldType is "">
		<cfset isFieldValueOk = True>
	<cfelse>
		<cfset isFieldValueOk = False>

		<cfswitch expression="#Arguments.customFieldType#">
		<cfcase value="Bit">
			<cfif ListFindNoCase("1,yes,y,t,true", Arguments.customFieldValue)>
				<cfset Arguments.customFieldValue = 1>
				<cfset isFieldValueOk = True>
			<cfelseif ListFindNoCase("0,no,n,f,false", Arguments.customFieldValue)>
				<cfset Arguments.customFieldValue = 0>
				<cfset isFieldValueOk = True>
			<cfelseif Arguments.customFieldValue is "">
				<cfset Arguments.customFieldValue = "">
				<cfset isFieldValueOk = True>
			</cfif>
		</cfcase>
		<cfcase value="Int">
			<cfif Arguments.customFieldValue is "" or Application.fn_IsInteger(Arguments.customFieldValue)>
				<cfset isFieldValueOk = True>
			</cfif>
		</cfcase>
		<cfcase value="Varchar">
			<cfinvoke component="#Application.billingMapping#data.CustomFieldValue" method="maxlength_CustomFieldVarchar" returnVariable="maxlength_CustomFieldVarchar" />
			<cfif Len(Arguments.customFieldValue) lte maxlength_CustomFieldVarchar.customFieldVarcharValue>
				<cfset isFieldValueOk = True>
			</cfif>
		</cfcase>
		<cfcase value="Decimal">
			<cfinvoke component="#Application.billingMapping#data.CustomFieldValue" method="maxlength_CustomFieldDecimal" returnVariable="maxlength_CustomFieldDecimal" />
			<cfif Arguments.customFieldValue is "" or (IsNumeric(Arguments.customFieldValue) and Len(ListGetAt(Arguments.customFieldValue, 2, ".")) lte maxlength_CustomFieldDecimal.customFieldDecimalValue)>
				<cfset isFieldValueOk = True>
			</cfif>
		</cfcase>
		<cfcase value="DateTime">
			<cfif Arguments.customFieldValue is "" or IsDate(Arguments.customFieldValue)>
				<cfset isFieldValueOk = True>
			</cfif>
		</cfcase>
		</cfswitch>
	</cfif>

	<cfif isFieldValueOk is False>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_insertCustomFieldValue" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfif Arguments.updateCustomFieldStatus is True>
				UPDATE avCustomField#Arguments.customFieldType#
				SET customField#Arguments.customFieldType#Status = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					customField#Arguments.customFieldType#DateUpdated = #Application.billingSql.sql_nowDateTime#
				WHERE customFieldID = <cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">
					AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
					AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
					AND customField#Arguments.customFieldType#Status = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;
			</cfif>

			INSERT INTO avCustomField#Arguments.customFieldType#
			(
				customFieldID, userID, primaryTargetID, targetID, customFieldOptionID,
				customField#Arguments.customFieldType#Status, customField#Arguments.customFieldType#Value,
				customField#Arguments.customFieldType#DateCreated, customField#Arguments.customFieldType#DateUpdated
			)
			VALUES
			(
				<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.customFieldOptionID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfswitch expression="#Arguments.customFieldType#">
				  <cfcase value="Bit"><cfif Not ListFind("0,1", Arguments.customFieldValue)>NULL<cfelse><cfqueryparam Value="#Arguments.customFieldValue#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfcase>
				  <cfcase value="Int"><cfif Not Application.fn_IsInteger(Arguments.customFieldValue)>NULL<cfelse><cfqueryparam Value="#Arguments.customFieldValue#" cfsqltype="cf_sql_integer"></cfif>,</cfcase>
				  <cfcase value="Varchar"><cfqueryparam Value="#Arguments.customFieldValue#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CustomFieldVarchar.customFieldVarcharValue#">,</cfcase>
				  <cfcase value="Decimal"><cfif Not IsNumeric(Arguments.customFieldValue)>NULL<cfelse><cfqueryparam Value="#Arguments.customFieldValue#" cfsqltype="cf_sql_decimal" Scale="#maxlength_CustomFieldDecimal.customFieldDecimalValue#"></cfif>,</cfcase>
				  <cfcase value="DateTime"><cfif Not IsDate(Arguments.customFieldValue)>NULL<cfelse><cfqueryparam Value="#Arguments.customFieldValue#" cfsqltype="cf_sql_timestamp"></cfif>,</cfcase>
				</cfswitch>
				#Application.billingSql.sql_nowDateTime#,
				#Application.billingSql.sql_nowDateTime#
			);
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<!--- 
search/filter - get custom fields and options (2 queries, done)
form - get custom fields, options and current value (2 queries?)
display - get custom fields and current value (1 query?)
--->

<cffunction Name="selectCustomFieldValueList" Access="public" Output="No" ReturnType="query" Hint="Selects custom field value(s) for a given target type and defined target">
	<cfargument Name="customFieldID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="Yes">
	<cfargument Name="targetID" Type="string" Required="Yes">
	<cfargument Name="customFieldValueStatus" Type="numeric" Required="No">
	<cfargument Name="customFieldBitValue" Type="numeric" Required="No">
	<cfargument Name="customFieldBitValue_null" Type="boolean" Required="No">
	<cfargument Name="customFieldDateTimeValue" Type="date" Required="No">
	<cfargument Name="customFieldDateTimeValue_null" Type="boolean" Required="No">
	<cfargument Name="customFieldDateTimeValue_min" Type="date" Required="No">
	<cfargument Name="customFieldDateTimeValue_max" Type="date" Required="No">
	<cfargument Name="customFieldIntValue" Type="numeric" Required="No">
	<cfargument Name="customFieldIntValue_null" Type="boolean" Required="No">
	<cfargument Name="customFieldIntValue_min" Type="numeric" Required="No">
	<cfargument Name="customFieldIntValue_max" Type="numeric" Required="No">
	<cfargument Name="customFieldDecimalValue" Type="numeric" Required="No">
	<cfargument Name="customFieldDecimalValue_null" Type="boolean" Required="No">
	<cfargument Name="customFieldDecimalValue_min" Type="numeric" Required="No">
	<cfargument Name="customFieldDecimalValue_max" Type="numeric" Required="No">
	<cfargument Name="customFieldVarcharValue" Type="string" Required="No">
	<cfargument Name="customFieldVarcharValue_null" Type="boolean" Required="No">
	<cfargument Name="customFieldVarcharValue_min" Type="string" Required="No">
	<cfargument Name="customFieldVarcharValue_max" Type="string" Required="No">
	<cfargument Name="customFieldTypeList" Type="string" Required="No" Default="Bit,DateTime,Decimal,Int,Varchar">

	<cfset var displayUnion = False>
	<cfset var qry_selectCustomFieldValueList = QueryNew("blank")>

	<cfquery Name="qry_selectCustomFieldValueList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif ListFind(Arguments.customFieldTypeList, "Bit")>
			<cfif displayUnion is True>UNION</cfif>
			<cfset displayUnion = True>
			SELECT 'Bit' AS customFieldValueType, customFieldID, userID, primaryTargetID, targetID, customFieldOptionID,
				customFieldBitID AS customFieldValueID, customFieldBitStatus AS customFieldValueStatus,
				<cfif Application.billingDatabase is not "MSSQLServer">customFieldBitValue<cfelse>CAST(customFieldBitValue AS VARCHAR(1000))</cfif> AS customFieldValueValue,
				customFieldBitDateCreated AS customFieldValueDateCreated, customFieldBitDateUpdated AS customFieldValueDateUpdated
			FROM avCustomFieldBit
			WHERE customFieldID IN (<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND targetID IN (<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif StructKeyExists(Arguments, "customFieldValueStatus") and ListFind("0,1", Arguments.customFieldValueStatus)>AND customFieldBitStatus = <cfqueryparam Value="#Arguments.customFieldValueStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldBitValue") and ListFind("0,1", Arguments.customFieldBitValue)>AND customFieldBitValue = <cfqueryparam Value="#Arguments.customFieldBitValue#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldBitValue_null")>AND customFieldBitValue IS <cfif Arguments.customFieldBitValue_null is False> NOT </cfif> NULL</cfif>
		</cfif>
		<cfif ListFind(Arguments.customFieldTypeList, "DateTime")>
			<cfif displayUnion is True>UNION</cfif>
			<cfset displayUnion = True>
			SELECT 'DateTime' AS customFieldValueType, customFieldID, userID, primaryTargetID, targetID, customFieldOptionID,
				customFieldDateTimeID AS customFieldValueID, customFieldDateTimeStatus AS customFieldValueStatus, 
				<cfif Application.billingDatabase is not "MSSQLServer">customFieldDateTimeValue<cfelse>CAST(customFieldDateTimeValue AS VARCHAR(1000))</cfif> AS customFieldValueValue,
				customFieldDateTimeDateCreated AS customFieldValueDateCreated, customFieldDateTimeDateUpdated AS customFieldValueDateUpdated
			FROM avCustomFieldDateTime
			WHERE customFieldID IN (<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND targetID IN (<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif StructKeyExists(Arguments, "customFieldValueStatus") and ListFind("0,1", Arguments.customFieldValueStatus)>AND customFieldDateTimeStatus = <cfqueryparam Value="#Arguments.customFieldValueStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldDateTimeValue") and IsDate(Arguments.customFieldDateTimeValue)>AND customFieldDateTimeValue = <cfqueryparam Value="#Arguments.customFieldDateTimeValue#" cfsqltype="cf_sql_timestamp"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldDateTimeValue_null")>AND customFieldDateTimeValue IS <cfif Arguments.customFieldDateTimeValue_null is False> NOT </cfif> NULL</cfif>
				<cfif StructKeyExists(Arguments, "customFieldDateTimeValue_min") and IsDate(Arguments.customFieldDateTimeValue_min)>AND customFieldDateTimeValue >= <cfqueryparam Value="#Arguments.customFieldDateTimeValue_min#" cfsqltype="cf_sql_timestamp"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldDateTimeValue_max") and IsDate(Arguments.customFieldDateTimeValue_max)>AND customFieldDateTimeValue <= <cfqueryparam Value="#Arguments.customFieldDateTimeValue_max#" cfsqltype="cf_sql_timestamp"></cfif>
		</cfif>
		<cfif ListFind(customFieldTypeList, "Decimal")>
			<cfif displayUnion is True>UNION</cfif>
			<cfset displayUnion = True>
			SELECT 'Decimal' AS customFieldValueType, customFieldID, userID, primaryTargetID, targetID, customFieldOptionID,
				customFieldDecimalID AS customFieldValueID, customFieldDecimalStatus AS customFieldValueStatus,
				<cfif Application.billingDatabase is not "MSSQLServer">customFieldDecimalValue<cfelse>CAST(customFieldDecimalValue AS VARCHAR(1000))</cfif> AS customFieldValueValue,
				customFieldDecimalDateCreated AS customFieldValueDateCreated, customFieldDecimalDateUpdated AS customFieldValueDateUpdated
			FROM avCustomFieldDecimal
			WHERE customFieldID IN (<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND targetID IN (<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif StructKeyExists(Arguments, "customFieldValueStatus") and ListFind("0,1", Arguments.customFieldValueStatus)>AND customFieldDecimalStatus = <cfqueryparam Value="#Arguments.customFieldValueStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldDecimalValue") and IsNumeric(Arguments.customFieldDecimalValue)>AND customFieldDecimalValue = <cfqueryparam Value="#Arguments.customFieldDecimalValue#" cfsqltype="cf_sql_decimal"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldDecimalValue_null")>AND customFieldDecimalValue IS <cfif Arguments.customFieldDecimalValue_null is False> NOT </cfif> NULL</cfif>
				<cfif StructKeyExists(Arguments, "customFieldDecimalValue_min") and IsNumeric(Arguments.customFieldDecimalValue_min)>AND customFieldDecimalValue >= <cfqueryparam Value="#Arguments.customFieldDecimalValue_min#" cfsqltype="cf_sql_decimal"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldDecimalValue_max") and IsNumeric(Arguments.customFieldDecimalValue_max)>AND customFieldDecimalValue <= <cfqueryparam Value="#Arguments.customFieldDecimalValue_max#" cfsqltype="cf_sql_decimal"></cfif>
		</cfif>
		<cfif ListFind(customFieldTypeList, "Int")>
			<cfif displayUnion is True>UNION</cfif>
			<cfset displayUnion = True>
			SELECT 'Int' AS customFieldValueType, customFieldID, userID, primaryTargetID, targetID, customFieldOptionID,
				customFieldIntID AS customFieldValueID, customFieldIntStatus AS customFieldValueStatus,
				<cfif Application.billingDatabase is not "MSSQLServer">customFieldIntValue<cfelse>CAST(customFieldIntValue AS VARCHAR(1000))</cfif> AS customFieldValueValue,
				customFieldIntDateCreated AS customFieldValueDateCreated, customFieldIntDateUpdated AS customFieldValueDateUpdated
			FROM avCustomFieldInt
			WHERE customFieldID IN (<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND targetID IN (<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif StructKeyExists(Arguments, "customFieldValueStatus") and ListFind("0,1", Arguments.customFieldValueStatus)>AND customFieldIntStatus = <cfqueryparam Value="#Arguments.customFieldValueStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldIntValue") and Application.fn_IsInteger(Arguments.customFieldIntValue)>AND customFieldIntValue = <cfqueryparam Value="#Arguments.customFieldIntValue#" cfsqltype="cf_sql_integer"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldIntValue_null")>AND customFieldIntValue IS <cfif Arguments.customFieldIntValue_null is False> NOT </cfif> NULL</cfif>
				<cfif StructKeyExists(Arguments, "customFieldIntValue_min") and Application.fn_IsInteger(customFieldIntValue_min)>AND customFieldIntValue >= <cfqueryparam Value="#Arguments.customFieldIntValue_min#" cfsqltype="cf_sql_integer"></cfif>
				<cfif StructKeyExists(Arguments, "customFieldIntValue_max") and Application.fn_IsInteger(Arguments.customFieldIntValue_max)>AND customFieldIntValue <= <cfqueryparam Value="#Arguments.customFieldIntValue_max#" cfsqltype="cf_sql_integer"></cfif>
		</cfif>
		<cfif ListFind(customFieldTypeList, "Varchar")>
			<cfif displayUnion is True>UNION</cfif>
			<cfset displayUnion = True>
			SELECT 'Varchar' AS customFieldValueType, customFieldID, userID, primaryTargetID, targetID, customFieldOptionID,
				customFieldVarcharID AS customFieldValueID, customFieldVarcharStatus AS customFieldValueStatus,
				<cfif Application.billingDatabase is not "MSSQLServer">customFieldVarcharValue<cfelse>CAST(customFieldVarcharValue AS VARCHAR(1000))</cfif> AS customFieldValueValue,
				customFieldVarcharDateCreated AS customFieldValueDateCreated, customFieldVarcharDateUpdated AS customFieldValueDateUpdated
			FROM avCustomFieldVarchar
			WHERE customFieldID IN (<cfqueryparam Value="#Arguments.customFieldID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND targetID IN (<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "customFieldValueStatus") and ListFind("0,1", Arguments.customFieldValueStatus)>AND customFieldVarcharStatus = <cfqueryparam Value="#Arguments.customFieldValueStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "customFieldVarcharValue")>AND customFieldVarcharValue LIKE <cfqueryparam Value="%#Arguments.customFieldVarcharValue#%" cfsqltype="cf_sql_varchar"></cfif>
			<cfif StructKeyExists(Arguments, "customFieldVarcharValue_null")>AND customFieldVarcharValue IS <cfif Arguments.customFieldVarcharValue_null is False> NOT </cfif> NULL</cfif>
			<cfif StructKeyExists(Arguments, "customFieldVarcharValue_min") and Trim(Arguments.customFieldVarcharValue_min) is not "">AND customFieldVarcharValue >= <cfqueryparam Value="#Arguments.customFieldVarcharValue_min#" cfsqltype="cf_sql_varchar"></cfif>
			<cfif StructKeyExists(Arguments, "customFieldVarcharValue_max") and Trim(Arguments.customFieldVarcharValue_max) is not "">AND customFieldVarcharValue <= <cfqueryparam Value="#Arguments.customFieldVarcharValue_max#" cfsqltype="cf_sql_varchar"></cfif>
		</cfif>
		ORDER BY targetID, customFieldValueType, customFieldID, customFieldValueStatus DESC, customFieldValueDateCreated DESC
	</cfquery>

	<cfreturn qry_selectCustomFieldValueList>
</cffunction>

</cfcomponent>
