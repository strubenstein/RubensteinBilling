<cfcomponent DisplayName="Status" Hint="Manages custom status settings">

<cffunction name="maxlength_Status" access="public" output="no" returnType="struct">
	<cfset var maxlength_Status = StructNew()>

	<cfset maxlength_Status.statusName = 100>
	<cfset maxlength_Status.statusTitle = 100>
	<cfset maxlength_Status.statusDescription = 255>
	<cfset maxlength_Status.statusID_custom = 50>

	<cfreturn maxlength_Status>
</cffunction>

<cffunction Name="insertStatus" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new status option. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="statusName" Type="string" Required="Yes">
	<cfargument Name="statusTitle" Type="string" Required="Yes">
	<cfargument Name="statusDisplayToCustomer" Type="numeric" Required="No" Default="0">
	<cfargument Name="statusDescription" Type="string" Required="No" Default="">
	<cfargument Name="statusOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="incrementStatusOrder" Type="boolean" Required="No" Default="True">
	<cfargument Name="statusStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="statusID_custom" Type="string" Required="No" Default="">

	<cfinvoke component="#Application.billingMapping#data.Status" method="maxlength_Status" returnVariable="maxlength_Status" />

	<cfquery Name="qry_insertStatus" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif Arguments.incrementStatusOrder is True>
			UPDATE avStatus
			SET statusOrder = statusOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND statusOrder >= <cfqueryparam Value="#Arguments.statusOrder#" cfsqltype="cf_sql_tinyint">;
		</cfif>

		INSERT INTO avStatus
		(
			companyID, userID, primaryTargetID, statusName, statusTitle, statusDisplayToCustomer, statusDescription,
			statusOrder, statusStatus, statusID_custom, statusDateCreated, statusDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.statusName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Status.statusName#">,
			<cfqueryparam Value="#Arguments.statusTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Status.statusTitle#">,
			<cfqueryparam Value="#Arguments.statusDisplayToCustomer#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.statusDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Status.statusDescription#">,
			<cfqueryparam Value="#Arguments.statusOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.statusStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.statusID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Status.statusID_custom#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateStatus" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing status option. Returns True.">
	<cfargument Name="statusName" Type="string" Required="No">
	<cfargument Name="statusTitle" Type="string" Required="No">
	<cfargument Name="statusDisplayToCustomer" Type="numeric" Required="No">
	<cfargument Name="statusDescription" Type="string" Required="No">
	<cfargument Name="statusOrder" Type="numeric" Required="No">
	<cfargument Name="statusStatus" Type="numeric" Required="No">
	<cfargument Name="statusID_custom" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Status" method="maxlength_Status" returnVariable="maxlength_Status" />

	<cfquery Name="qry_updateStatus" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avStatus
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "statusName")>statusName = <cfqueryparam Value="#Arguments.statusName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Status.statusName#">,</cfif>
			<cfif StructKeyExists(Arguments, "statusTitle")>statusTitle = <cfqueryparam Value="#Arguments.statusTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Status.statusTitle#">,</cfif>
			<cfif StructKeyExists(Arguments, "statusDisplayToCustomer") and ListFind("0,1", Arguments.statusDisplayToCustomer)>statusDisplayToCustomer = <cfqueryparam Value="#Arguments.statusDisplayToCustomer#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "statusDescription")>statusDescription = <cfqueryparam Value="#Arguments.statusDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Status.statusDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "statusOrder") and Application.fn_IsIntegerNonNegative(Arguments.statusOrder)>statusOrder = <cfqueryparam Value="#Arguments.statusOrder#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "statusStatus") and ListFind("0,1", Arguments.statusStatus)>statusStatus = <cfqueryparam Value="#Arguments.statusStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "statusID_custom")>statusID_custom = <cfqueryparam Value="#Arguments.statusID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Status.statusID_custom#">,</cfif>
			statusDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE statusID = <cfqueryparam Value="#Arguments.statusID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="switchStatusOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing status options">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="statusID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="statusOrder_direction" Type="string" Required="Yes">

	<cfset var qry_selectStatusOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchStatusOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avStatus
		SET statusOrder = statusOrder 
			<cfif Arguments.statusOrder_direction is "moveStatusDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		WHERE statusID = <cfqueryparam Value="#Arguments.statusID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avStatus INNER JOIN avStatus AS avStatus2
			SET avStatus.statusOrder = avStatus.statusOrder 
				<cfif Arguments.statusOrder_direction is "moveStatusDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE avStatus.statusOrder = avStatus2.statusOrder
				AND avStatus.primaryTargetID = avStatus2.primaryTargetID
				AND avStatus.companyID = avStatus2.companyID
				AND avStatus.statusID <> <cfqueryparam Value="#Arguments.statusID#" cfsqltype="cf_sql_integer">
				AND avStatus2.statusID = <cfqueryparam Value="#Arguments.statusID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avStatus
			SET statusOrder = statusOrder 
				<cfif Arguments.statusOrder_direction is "moveStatusDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND statusID <> <cfqueryparam Value="#Arguments.statusID#" cfsqltype="cf_sql_integer">
				AND statusOrder = (SELECT statusOrder FROM avStatus WHERE statusID = <cfqueryparam Value="#Arguments.statusID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectStatus" Access="public" Output="No" ReturnType="query" Hint="Select existing status option.">
	<cfargument Name="statusID" Type="numeric" Required="Yes">

	<cfset var qry_selectStatus = QueryNew("blank")>

	<cfquery Name="qry_selectStatus" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID, userID, primaryTargetID, statusName,
			statusTitle, statusDisplayToCustomer, statusDescription,
			statusOrder, statusStatus, statusID_custom,
			statusDateCreated, statusDateUpdated
		FROM avStatus
		WHERE statusID = <cfqueryparam Value="#Arguments.statusID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectStatus>
</cffunction>

<cffunction Name="selectStatusIDViaCustomID" Access="public" Output="No" ReturnType="numeric" Hint="Selects statusID of existing status via custom ID and returns statusID if exists, 0 if not exists, and -1 if multiple statuses have the same statusID_custom.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="statusID_custom" Type="string" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">

	<cfset var qry_selectStatusIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectStatusIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT statusID
		FROM avStatus
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND statusID_custom IN (<cfqueryparam Value="#Arguments.statusID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerPositive(Arguments.primaryTargetID)>
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_selectStatusIDViaCustomID.RecordCount is 0 or qry_selectStatusIDViaCustomID.RecordCount lt ListLen(Arguments.statusID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectStatusIDViaCustomID.RecordCount gt ListLen(Arguments.statusID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectStatusIDViaCustomID.statusID)>
	</cfif>
</cffunction>

<cffunction Name="checkStatusPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that company has permission for existing status option(s).">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="statusID" Type="string" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">

	<cfset var qry_checkStatusPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.statusID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkStatusPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT companyID, statusID
			FROM avStatus
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND statusID IN (<cfqueryparam Value="#Arguments.statusID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerPositive(Arguments.primaryTargetID)>
					AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				</cfif>
		</cfquery>

		<cfif qry_checkStatusPermission.RecordCount is 0 or qry_checkStatusPermission.RecordCount is not ListLen(Arguments.statusID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectStatusList" Access="public" Output="No" ReturnType="query" Hint="Select existing status options.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="statusStatus" Type="numeric" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="statusOrder" Type="string" Required="No">
	<cfargument Name="statusID_custom" Type="string" Required="No">

	<cfset var qry_selectStatusList = QueryNew("blank")>

	<cfquery Name="qry_selectStatusList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT statusID, companyID, userID, primaryTargetID, statusName,
			statusTitle, statusDisplayToCustomer, statusDescription,
			statusOrder, statusStatus, statusID_custom,
			statusDateCreated, statusDateUpdated
		FROM avStatus
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfloop index="field" list="statusID,primaryTargetID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND #field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "statusOrder") and Application.fn_IsIntegerList(Arguments.statusOrder)>
				AND statusOrder IN (<cfqueryparam value="#Arguments.statusOrder#" cfsqltype="cf_sql_smallint" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "statusStatus") and ListFind("0,1", Arguments.statusStatus)>
				AND statusStatus = <cfqueryparam value="#Arguments.statusStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "statusID_custom") and Arguments.statusID_custom is not "">
				AND statusID_custom IN (<cfqueryparam value="#Arguments.statusID_custom#" cfsqltype="cf_sql_varchar" list="yes">)
			</cfif>
		ORDER BY primaryTargetID, statusOrder, statusName
	</cfquery>

	<cfreturn qry_selectStatusList>
</cffunction>

<cffunction Name="deleteStatus" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing status option">
	<cfargument Name="statusID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteStatus" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avStatus
		WHERE statusID = <cfqueryparam Value="#Arguments.statusID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>

