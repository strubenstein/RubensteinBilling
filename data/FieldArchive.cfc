<cfcomponent DisplayName="FieldArchive" Hint="Manages archiving and viewing previous field values">

<cffunction name="maxlength_FieldArchive" access="public" output="no" returnType="struct">
	<cfset var maxlength_FieldArchive = StructNew()>

	<cfset maxlength_FieldArchive.fieldArchiveTableName = 50>
	<cfset maxlength_FieldArchive.fieldArchiveFieldName = 50>
	<cfset maxlength_FieldArchive.fieldArchiveValue = 255>

	<cfreturn maxlength_FieldArchive>
</cffunction>

<cffunction Name="insertFieldArchive" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new value into archive. Returns True.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="fieldArchiveTableName" Type="string" Required="Yes">
	<cfargument Name="fieldArchiveFieldName" Type="string" Required="Yes">
	<cfargument Name="fieldArchiveValue" Type="string" Required="Yes">

	<cfset var realFieldArchiveTableName = Arguments.fieldArchiveTableName>
	<cfset var realFieldArchiveFieldName = Arguments.fieldArchiveFieldName>
	<cfset var realFieldArchiveValue = Arguments.fieldArchiveValue>

	<cfinvoke component="#Application.billingMapping#data.FieldArchive" method="maxlength_FieldArchive" returnVariable="maxlength_FieldArchive" />

	<cfquery Name="qry_insertFieldArchive" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avFieldArchive
		(
			fieldArchiveTableName, fieldArchiveFieldName, fieldArchiveValue,
			primaryTargetID, targetID, userID, fieldArchiveDate
		)
		VALUES
		(
			<cfqueryparam Value="#realFieldArchiveTableName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_FieldArchive.fieldArchiveTableName#">,
			<cfqueryparam Value="#realFieldArchiveFieldName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_FieldArchive.fieldArchiveFieldName#">,
			<cfqueryparam Value="#realFieldArchiveValue#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_FieldArchive.fieldArchiveValue#">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="insertFieldArchive_multiple" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new value into archive. Returns True.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="fieldArchiveArray" Type="array" Required="Yes">

	<cfset var realFieldArchiveTableName = "">
	<cfset var realFieldArchiveFieldName = "">
	<cfset var realFieldArchiveValue = "">

	<cfinvoke component="#Application.billingMapping#data.FieldArchive" method="maxlength_FieldArchive" returnVariable="maxlength_FieldArchive" />

	<cfloop Index="count" From="1" To="#ArrayLen(Arguments.fieldArchiveArray)#">
		<cfset realFieldArchiveTableName = Arguments.fieldArchiveArray[count].fieldArchiveTableName>
		<cfset realFieldArchiveFieldName = Arguments.fieldArchiveArray[count].fieldArchiveFieldName>
		<cfset realFieldArchiveValue = Arguments.fieldArchiveArray[count].fieldArchiveValue>

		<cfquery Name="qry_insertFieldArchive" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			INSERT INTO avFieldArchive
			(
				fieldArchiveTableName, fieldArchiveFieldName, fieldArchiveValue,
				primaryTargetID, targetID, userID, fieldArchiveDate
			)
			VALUES
			(
				<cfqueryparam Value="#realFieldArchiveTableName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_FieldArchive.fieldArchiveTableName#">,
				<cfqueryparam Value="#realFieldArchiveFieldName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_FieldArchive.fieldArchiveFieldName#">,
				<cfqueryparam Value="#realFieldArchiveValue#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_FieldArchive.fieldArchiveValue#">,
				<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
				#Application.billingSql.sql_nowDateTime#
			)
		</cfquery>
	</cfloop>

	<cfreturn True>
</cffunction>

<cffunction Name="selectFieldArchiveList" Access="public" Output="No" ReturnType="query" Hint="Return all previous field values for a particular user">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="fieldArchiveTableName" Type="string" Required="No">
	<cfargument Name="fieldArchiveFieldName" Type="string" Required="No">

	<cfset var qry_selectFieldArchiveList = QueryNew("blank")>

	<cfquery Name="qry_selectFieldArchiveList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avFieldArchive.fieldArchiveID, avFieldArchive.fieldArchiveTableName, avFieldArchive.fieldArchiveFieldName,
			avFieldArchive.fieldArchiveValue, avFieldArchive.fieldArchiveDate, avFieldArchive.userID,
			avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avFieldArchive LEFT OUTER JOIN avUser ON avFieldArchive.userID = avUser.userID
		WHERE avFieldArchive.primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND avFieldArchive.targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
		<cfif StructKeyExists(Arguments, "fieldArchiveTableName") and Find("av", Arguments.fieldArchiveTableName)>
			AND avFieldArchive.fieldArchiveTableName IN (<cfqueryparam Value="#Arguments.fieldArchiveTableName#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
		</cfif>
		<cfif StructKeyExists(Arguments, "fieldArchiveFieldName") and Find("av", Arguments.fieldArchiveFieldName)>
			AND avFieldArchive.fieldArchiveFieldName IN (<cfqueryparam Value="#Arguments.fieldArchiveFieldName#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
		</cfif>
		ORDER BY avFieldArchive.fieldArchiveTableName, avFieldArchive.fieldArchiveFieldName, avFieldArchive.fieldArchiveDate DESC
	</cfquery>

	<cfreturn qry_selectFieldArchiveList>
</cffunction>

</cfcomponent>

