<cfcomponent DisplayName="StatusHistory" Hint="Manages custom status history for a target">

<cffunction name="maxlength_StatusHistory" access="public" output="no" returnType="struct">
	<cfset var maxlength_StatusHistory = StructNew()>

	<cfset maxlength_StatusHistory.statusHistoryComment = 255>

	<cfreturn maxlength_StatusHistory>
</cffunction>

<cffunction Name="insertStatusHistory" Access="public" Output="No" ReturnType="boolean" Hint="Insert new status value into status history">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="statusID" Type="numeric" Required="Yes">
	<cfargument Name="statusHistoryManual" Type="numeric" Required="No" Default="1">
	<cfargument Name="statusHistoryComment" Type="string" Required="No" Default="">

	<cfinvoke component="#Application.billingMapping#data.StatusHistory" method="maxlength_StatusHistory" returnVariable="maxlength_StatusHistory" />

	<cfquery Name="qry_insertStatusHistory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avStatusHistory
		SET statusHistoryStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			statusHistoryDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			AND statusHistoryStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;

		INSERT INTO avStatusHistory
		(
			userID, primaryTargetID, targetID, statusHistoryStatus, statusID, statusHistoryManual,
			statusHistoryComment, statusHistoryDateCreated, statusHistoryDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.statusID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.statusHistoryManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.statusHistoryComment#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_StatusHistory.statusHistoryComment#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectStatusHistory" Access="public" Output="No" ReturnType="query" Hint="Select status history records for a given target.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="statusHistoryStatus" Type="numeric" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="statusHistoryDateCreated_from" Type="date" Required="No">
	<cfargument Name="statusHistoryDateCreated_to" Type="date" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">

	<cfset var qry_selectStatusHistory = QueryNew("blank")>

	<cfquery Name="qry_selectStatusHistory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avStatusHistory.statusHistoryID, avStatusHistory.primaryTargetID, avStatusHistory.targetID, avStatusHistory.userID,
			avStatusHistory.statusHistoryStatus, avStatusHistory.statusID, avStatusHistory.statusHistoryManual, avStatusHistory.statusHistoryComment,
			avStatusHistory.statusHistoryDateCreated, avStatusHistory.statusHistoryDateUpdated,
			avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom,
			avStatus.statusTitle, avStatus.statusOrder, avStatus.statusID_custom
		FROM avStatusHistory
			LEFT OUTER JOIN avUser ON avStatusHistory.userID = avUser.userID
			LEFT OUTER JOIN avStatus ON avStatusHistory.statusID = avStatus.statusID
		WHERE avStatusHistory.primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerList(Arguments.targetID)>
				AND avStatusHistory.targetID IN <cfif ListLen(Arguments.targetID) lte 2000>(<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" list="yes">)<cfelse>(#Arguments.targetID#)</cfif>
			</cfif>
			<cfloop index="field" list="userID,statusID">
				<cfif StructKeyExists(Arguments, field)> AND avStatusHistory.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif>
			</cfloop>
			<cfloop index="field" list="statusHistoryStatus">
				<cfif StructKeyExists(Arguments, field)> AND avStatusHistory.#field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "statusHistoryDateCreated_from") and StructKeyExists(Arguments, "statusHistoryDateCreated_to")>
				AND avStatusHistory.statusHistoryDateCreated BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments.statusHistoryDateCreated_from)#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments.statusHistoryDateCreated_to)#" cfsqltype="cf_sql_timestamp">
			  <cfelseif StructKeyExists(Arguments, "statusHistoryDateCreated_from")>
			  	AND avStatusHistory.statusHistoryDateCreated >= <cfqueryparam value="#CreateODBCDateTime(Arguments.statusHistoryDateCreated_from)#" cfsqltype="cf_sql_timestamp">
			  <cfelseif StructKeyExists(Arguments, "statusHistoryDateCreated_to")>
			  	AND avStatusHistory.statusHistoryDateCreated <= <cfqueryparam value="#CreateODBCDateTime(Arguments.statusHistoryDateCreated_to)#" cfsqltype="cf_sql_timestamp">
			</cfif>
		ORDER BY avStatusHistory.statusHistoryID DESC
	</cfquery>

	<cfreturn qry_selectStatusHistory>
</cffunction>

<cffunction Name="selectStatusHistoryCount" Access="public" Output="No" ReturnType="numeric" Hint="Returns number of status history records for a given target.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="No">
	<cfargument Name="statusHistoryStatus" Type="numeric" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="statusHistoryDateCreated_from" Type="date" Required="No">
	<cfargument Name="statusHistoryDateCreated_to" Type="date" Required="No">

	<cfset var qry_selectStatusHistoryCount = QueryNew("blank")>

	<cfquery Name="qry_selectStatusHistoryCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(statusHistoryID) AS statusHistoryCount
		FROM avStatusHistory
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerNonNegative(Arguments.targetID)>AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>AND userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
			<cfif StructKeyExists(Arguments, "statusHistoryStatus") and ListFind("0,1", Arguments.statusHistoryStatus)>
				AND statusHistoryStatus = <cfqueryparam Value="#Arguments.statusHistoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "statusHistoryDateCreated_from") and StructKeyExists(Arguments, "statusHistoryDateCreated_to")>
				AND statusHistoryDateCreated BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments.statusHistoryDateCreated_from)#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments.statusHistoryDateCreated_to)#" cfsqltype="cf_sql_timestamp">
			  <cfelseif StructKeyExists(Arguments, "statusHistoryDateCreated_from")>
			  	AND statusHistoryDateCreated >= <cfqueryparam value="#CreateODBCDateTime(Arguments.statusHistoryDateCreated_from)#" cfsqltype="cf_sql_timestamp">
			  <cfelseif StructKeyExists(Arguments, "statusHistoryDateCreated_to")>
			  	AND statusHistoryDateCreated <= <cfqueryparam value="#CreateODBCDateTime(Arguments.statusHistoryDateCreated_to)#" cfsqltype="cf_sql_timestamp">
			</cfif>
	</cfquery>

	<cfreturn qry_selectStatusHistoryCount.statusHistoryCount>
</cffunction>

<cffunction Name="selectStatusHistoryList" Access="public" Output="No" ReturnType="query" Hint="Select status history records for multiple targets.">
	<cfargument Name="primaryTargetArray" Type="array" Required="Yes">
	<cfargument Name="statusHistoryStatus" Type="numeric" Required="No">

	<cfset var isArgumentsOk = True>
	<cfset var qry_selectStatusHistoryList = QueryNew("blank")>

	<cfif ArrayLen(Arguments.primaryTargetArray) is 0>
		<cfset isArgumentsOk = False>
	<cfelse>
		<cfloop Index="count" From="1" To="#ArrayLen(Arguments.primaryTargetArray)#">
			<cfif ListLen(Arguments.primaryTargetArray[count]) is not 2
					or Not Application.fn_IsIntegerPositive(ListFirst(Arguments.primaryTargetArray[count]))
					or Not Application.fn_IsIntegerPositive(ListLast(Arguments.primaryTargetArray[count]))>
				<cfset isArgumentsOk = False>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>

	<cfif isArgumentsOk is False>
		<cfset temp = ArrayClear(Arguments.primaryTargetArray)>
		<cfset Arguments.primaryTargetArray[1] = "0,0">
	</cfif>

	<cfquery Name="qry_selectStatusHistoryList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avStatusHistory.statusHistoryID, avStatusHistory.userID, avStatusHistory.primaryTargetID, avStatusHistory.targetID,
			avStatusHistory.statusHistoryStatus, avStatusHistory.statusID, avStatusHistory.statusHistoryManual, avStatusHistory.statusHistoryComment,
			avStatusHistory.statusHistoryDateCreated, avStatusHistory.statusHistoryDateUpdated,
			avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom,
			avStatus.statusTitle, avStatus.statusOrder
		FROM avStatusHistory
			LEFT OUTER JOIN avUser ON avStatusHistory.userID = avUser.userID
			LEFT OUTER JOIN avStatus ON avStatusHistory.statusID = avStatus.statusID
		WHERE 
			(
			<cfloop Index="count" From="1" To="#ArrayLen(Arguments.primaryTargetArray)#">
				<cfif count gt 1>OR</cfif>
				(avStatusHistory.primaryTargetID = <cfqueryparam Value="#ListFirst(Arguments.primaryTargetArray[count])#" cfsqltype="cf_sql_integer">
				AND avStatusHistory.targetID = <cfqueryparam Value="#ListLast(Arguments.primaryTargetArray[count])#" cfsqltype="cf_sql_integer">)
			</cfloop>
			)
			<cfif StructKeyExists(Arguments, "statusHistoryStatus") and ListFind("0,1", Arguments.statusHistoryStatus)>
				AND avStatusHistory.statusHistoryStatus = <cfqueryparam Value="#Arguments.statusHistoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY avStatusHistory.primaryTargetID, avStatusHistory.targetID, avStatusHistory.statusHistoryDateCreated DESC
	</cfquery>

	<cfreturn qry_selectStatusHistoryList>
</cffunction>

</cfcomponent>
