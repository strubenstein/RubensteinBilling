<cfcomponent DisplayName="Group" Hint="Manages creating, updating, managing and viewing groups">

<cffunction name="maxlength_Group" access="public" output="no" returnType="struct">
	<cfset var maxlength_Group = StructNew()>

	<cfset maxlength_Group.groupName = 100>
	<cfset maxlength_Group.groupCategory = 50>
	<cfset maxlength_Group.groupDescription = 255>
	<cfset maxlength_Group.groupID_custom = 50>

	<cfreturn maxlength_Group>
</cffunction>

<cffunction Name="insertGroup" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new group into database and returns groupID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="groupName" Type="string" Required="Yes">
	<cfargument Name="groupCategory" Type="string" Required="No" Default="">
	<cfargument Name="groupDescription" Type="string" Required="No" Default="">
	<cfargument Name="groupStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="groupID_custom" Type="string" Required="No" Default="">

	<cfset var qry_insertGroup = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Group" method="maxlength_Group" returnVariable="maxlength_Group" />

	<cfquery Name="qry_insertGroup" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avGroup
		(
			companyID, userID, groupName, groupCategory, groupDescription,
			groupStatus, groupID_custom, groupDateCreated, groupDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.groupName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Group.groupName#">,
			<cfqueryparam Value="#Arguments.groupCategory#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Group.groupCategory#">,
			<cfqueryparam Value="#Arguments.groupDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Group.groupDescription#">,
			<cfqueryparam Value="#Arguments.groupStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.groupID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Group.groupID_custom#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "groupID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertGroup.primaryKeyID>
</cffunction>

<cffunction Name="updateGroup" Access="public" Output="No" ReturnType="boolean" Hint="Update existing group">
	<cfargument Name="groupID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="groupName" Type="string" Required="No">
	<cfargument Name="groupCategory" Type="string" Required="No">
	<cfargument Name="groupDescription" Type="string" Required="No">
	<cfargument Name="groupStatus" Type="numeric" Required="No">
	<cfargument Name="groupID_custom" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Group" method="maxlength_Group" returnVariable="maxlength_Group" />

	<cfquery Name="qry_updateGroup" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avGroup
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "groupName")>groupName = <cfqueryparam Value="#Arguments.groupName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Group.groupName#">,</cfif>
			<cfif StructKeyExists(Arguments, "groupCategory")>groupCategory = <cfqueryparam Value="#Arguments.groupCategory#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Group.groupCategory#">,</cfif>
			<cfif StructKeyExists(Arguments, "groupDescription")>groupDescription = <cfqueryparam Value="#Arguments.groupDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Group.groupDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "groupStatus") and ListFind("0,1", Arguments.groupStatus)>groupStatus = <cfqueryparam Value="#Arguments.groupStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "groupID_custom")>groupID_custom = <cfqueryparam Value="#Arguments.groupID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Group.groupID_custom#">,</cfif>
			groupDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE groupID = <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectGroup" Access="public" Output="No" ReturnType="query" Hint="Selects existing group">
	<cfargument Name="groupID" Type="numeric" Required="Yes">

	<cfset var qry_selectGroup = QueryNew("blank")>

	<cfquery Name="qry_selectGroup" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID, userID, groupName, groupCategory, groupDescription,
			groupStatus, groupID_custom, groupDateCreated, groupDateUpdated
		FROM avGroup
		WHERE groupID = <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectGroup>
</cffunction>

<cffunction Name="selectGroupSummary" Access="public" Output="No" ReturnType="query" Hint="Selects existing group summary">
	<cfargument Name="groupID" Type="numeric" Required="Yes">

	<cfset var qry_selectGroupSummary = QueryNew("blank")>

	<cfquery Name="qry_selectGroupSummary" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			(
			SELECT COUNT(groupID)
			FROM avGroupTarget
			WHERE groupID = <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
				AND groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("userID")#" cfsqltype="cf_sql_integer">
			)
			AS groupUserCount,
	
			(
			SELECT COUNT(groupID)
			FROM avGroupTarget
			WHERE groupID = <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
				AND groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("companyID")#" cfsqltype="cf_sql_integer">
			)
			AS groupCompanyCount,
	
			(
			SELECT COUNT(groupID)
			FROM avGroupTarget
			WHERE groupID = <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
				AND groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("affiliateID")#" cfsqltype="cf_sql_integer">
			)
			AS groupAffiliateCount,
	
			(
			SELECT COUNT(groupID)
			FROM avGroupTarget
			WHERE groupID = <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
				AND groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("cobrandID")#" cfsqltype="cf_sql_integer">
			)
			AS groupCobrandCount,
	
			(
			SELECT COUNT(groupID)
			FROM avGroupTarget
			WHERE groupID = <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
				AND groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("vendorID")#" cfsqltype="cf_sql_integer">
			)
			AS groupVendorCount,
	
			(
			SELECT COUNT(avPriceTarget.targetID)
			FROM avPrice, avPriceTarget
			WHERE avPrice.priceID = avPriceTarget.priceID
				AND avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("groupID")#" cfsqltype="cf_sql_integer">
				AND avPriceTarget.targetID = <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
				AND avPrice.priceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			)
			AS groupPriceCount
	</cfquery>

	<cfreturn qry_selectGroupSummary>
</cffunction>

<cffunction Name="selectGroupIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects groupID of existing group via custom ID and returns groupID(s) if exists, 0 if not exists, and -1 if multiple groups have the same groupID_custom.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="groupID_custom" Type="string" Required="Yes">

	<cfset var qry_selectGroupIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectGroupIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT groupID
		FROM avGroup
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND groupID_custom IN (<cfqueryparam Value="#Arguments.groupID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectGroupIDViaCustomID.RecordCount is 0 or qry_selectGroupIDViaCustomID.RecordCount lt ListLen(Arguments.groupID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectGroupIDViaCustomID.RecordCount gt ListLen(Arguments.groupID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectGroupIDViaCustomID.groupID)>
	</cfif>
</cffunction>

<cffunction Name="selectGroupList" Access="public" Output="No" ReturnType="query" Hint="Selects all existing groups for a given company">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="returnGroupCounts" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectGroupList = QueryNew("blank")>

	<cfquery Name="qry_selectGroupList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT groupID, companyID, userID, groupName, groupCategory, groupDescription,
			groupStatus, groupID_custom, groupDateCreated, groupDateUpdated
			<cfif StructKeyExists(Arguments, "returnGroupCounts") and Arguments.returnGroupCounts is True>
				,
				(
				SELECT COUNT(avGroupTarget.groupID)
				FROM avGroupTarget
				WHERE avGroupTarget.groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND avGroupTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("userID")#" cfsqltype="cf_sql_integer">
					AND avGroupTarget.groupID = avGroup.groupID
				)
				AS groupUserCount,

				(
				SELECT COUNT(avGroupTarget.groupID)
				FROM avGroupTarget
				WHERE avGroupTarget.groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND avGroupTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("companyID")#" cfsqltype="cf_sql_integer">
					AND avGroupTarget.groupID = avGroup.groupID
				)
				AS groupCompanyCount,

				(
				SELECT COUNT(avGroupTarget.groupID)
				FROM avGroupTarget
				WHERE avGroupTarget.groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND avGroupTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("affiliateID")#" cfsqltype="cf_sql_integer">
					AND avGroupTarget.groupID = avGroup.groupID
				)
				AS groupAffiliateCount,

				(
				SELECT COUNT(avGroupTarget.groupID)
				FROM avGroupTarget
				WHERE avGroupTarget.groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND avGroupTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("cobrandID")#" cfsqltype="cf_sql_integer">
					AND avGroupTarget.groupID = avGroup.groupID
				)
				AS groupCobrandCount,

				(
				SELECT COUNT(avGroupTarget.groupID)
				FROM avGroupTarget
				WHERE avGroupTarget.groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND avGroupTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("vendorID")#" cfsqltype="cf_sql_integer">
					AND avGroupTarget.groupID = avGroup.groupID
				)
				AS groupVendorCount,

				(
				SELECT COUNT(targetID)
				FROM avPriceTarget
				WHERE avPriceTarget.priceTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND primaryTargetID = #Application.fn_GetPrimaryTargetID("groupID")#
					AND avPriceTarget.targetID = avGroup.groupID
				)
				AS groupPriceCount
			</cfif>
		FROM avGroup
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
		ORDER BY groupCategory, groupName
	</cfquery>

	<cfreturn qry_selectGroupList>
</cffunction>

<cffunction Name="selectGroupCategoryList" Access="public" Output="No" ReturnType="query" Hint="Selects existing groups categories">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_selectGroupCategoryList = QueryNew("blank")>

	<cfquery Name="qry_selectGroupCategoryList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT DISTINCT(groupCategory)
		FROM avGroup
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND groupCategory <> ''
		ORDER BY groupCategory
	</cfquery>

	<cfreturn qry_selectGroupCategoryList>
</cffunction>

<cffunction Name="checkGroupPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for group(s)">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="groupID" Type="string" Required="Yes">

	<cfset var qry_checkGroupPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.groupID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkGroupPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT groupID
			FROM avGroup
			WHERE groupID IN (<cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfif qry_checkGroupPermission.RecordCount is 0 or qry_checkGroupPermission.RecordCount is not ListLen(Arguments.groupID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="checkGroupNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Validate group name is unique">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="groupName" Type="string" Required="Yes">
	<cfargument Name="groupID" Type="numeric" Required="No">

	<cfset var qry_checkGroupNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkGroupNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT groupID
		FROM avGroup
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND groupName = <cfqueryparam Value="#Arguments.groupName#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "groupID") and Application.fn_IsIntegerNonNegative(Arguments.groupID)>
				AND groupID <> <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkGroupNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkGroupID_customIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Validate group name is unique">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="groupID_custom" Type="string" Required="Yes">
	<cfargument Name="groupID" Type="numeric" Required="No">

	<cfset var qry_checkGroupID_customIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkGroupID_customIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT groupID
		FROM avGroup
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND groupID_custom = <cfqueryparam Value="#Arguments.groupID_custom#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "groupID") and Application.fn_IsIntegerNonNegative(Arguments.groupID)>
				AND groupID <> <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkGroupID_customIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="insertGroupTarget" Access="public" Output="No" ReturnType="boolean" Hint="Add target to group">
	<cfargument Name="groupID" Type="string" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="groupTargetStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="isSubmitttedFromGroupControl" Type="boolean" Required="No" Default="True">

	<cfset var tableName = "">
	<cfset var fieldName = "">

	<cfif (ListLen(Arguments.groupID) gt 1 and ListLen(Arguments.targetID) gt 1)
			or Not Application.fn_IsIntegerList(Arguments.groupID) or Not Application.fn_IsIntegerList(Arguments.targetID)>
		<cfreturn False>
	<cfelse>
		<cfswitch expression="#Application.fn_GetPrimaryTargetKey(Arguments.primaryTargetID)#">
		<cfcase value="affiliateID">
			<cfset tableName = "avAffiliate">
			<cfset fieldName = "affiliateID">
		</cfcase>
		<cfcase value="cobrandID">
			<cfset tableName = "avCobrand">
			<cfset fieldName = "cobrandID">
		</cfcase>
		<cfcase value="companyID">
			<cfset tableName = "avCompany">
			<cfset fieldName = "companyID">
		</cfcase>
		<cfcase value="userID">
			<cfset tableName = "avUser">
			<cfset fieldName = "userID">
		</cfcase>
		<cfcase value="vendorID">
			<cfset tableName = "avVendor">
			<cfset fieldName = "vendorID">
		</cfcase>
		<cfdefaultcase>
			<cfset tableName = "">
			<cfset fieldName = "">
		</cfdefaultcase>
		</cfswitch>

		<cfif tableName is "" or fieldName is "">
			<cfreturn False>
		<cfelse>
			<cfquery Name="qry_insertGroupTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				INSERT INTO avGroupTarget
				(
					groupID,
					primaryTargetID,
					targetID,
					userID,
					groupTargetStatus,
					groupTargetDateCreated,
					groupTargetDateUpdated
				)
				<cfif Arguments.isSubmitttedFromGroupControl is True><!--- insert multiple targets into a group --->
					SELECT 
						<cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
						#tableName#.#fieldName#,
						<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam Value="#Arguments.groupTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
						#Application.billingSql.sql_nowDateTime#,
						#Application.billingSql.sql_nowDateTime#
					FROM #tableName#
						<cfif tableName is "avUser">INNER JOIN avCompany ON avUser.companyID = avCompany.companyID</cfif>
						LEFT OUTER JOIN avGroupTarget
							ON #tableName#.#fieldName# = avGroupTarget.targetID
							AND avGroupTarget.primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
							AND avGroupTarget.groupID = <cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer">
							AND avGroupTarget.groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					WHERE #tableName#.#fieldName# IN (<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
						<cfif tableName is "avUser">
							AND avCompany.companyID_author
						<cfelse>
							AND #tableName#.companyID_author 
						</cfif>
						 = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
						AND avGroupTarget.targetID IS NULL
				<cfelse><!--- isSubmitttedFromGroupControl is False; insert a target into multiple groups --->
					SELECT 
						avGroup.groupID,
						<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam Value="#Arguments.groupTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
						#Application.billingSql.sql_nowDateTime#,
						#Application.billingSql.sql_nowDateTime#
					FROM avGroup LEFT OUTER JOIN avGroupTarget
						ON avGroup.groupID = avGroupTarget.groupID
							AND avGroupTarget.primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
							AND avGroupTarget.targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
							AND avGroupTarget.groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					WHERE avGroup.groupID IN (<cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
						AND avGroup.companyID = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
						AND avGroupTarget.groupID IS NULL
				</cfif>
			</cfquery>

			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="updateGroupTarget" Access="public" Output="No" ReturnType="boolean" Hint="Update target status in group to inactive">
	<cfargument Name="groupTargetID" Type="string" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">

	<cfif (StructKeyExists(Arguments, "groupTargetID") and Application.fn_IsIntegerList(Arguments.groupTargetID))
			or (StructKeyExists(Arguments, "groupID") and StructKeyExists(Arguments, "primaryTargetID") and StructKeyExists(Arguments, "targetID")
				and Application.fn_IsIntegerList(Arguments.groupID) and Application.fn_IsIntegerPositive(Arguments.primaryTargetID) and Application.fn_IsIntegerList(Arguments.targetID))>
		<cfquery Name="qry_updateGroupTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avGroupTarget
			SET groupTargetStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>
					userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
				</cfif>
				groupTargetDateUpdated = #Application.billingSql.sql_nowDateTime#
			WHERE 
				<cfif StructKeyExists(Arguments, "groupTargetID") and Application.fn_IsIntegerList(Arguments.groupTargetID)>
					groupTargetID IN (<cfqueryparam Value="#Arguments.groupTargetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfelse>
					groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND groupID IN (<cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
					AND targetID IN (<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
		</cfquery>

		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectGroupTargetList" Access="public" Output="No" ReturnType="query" Hint="Selects companies in a group or groups a company is in">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="groupTargetStatus" Type="numeric" Required="No">

	<cfset var qry_selectGroupTargetList = QueryNew("blank")>

	<cfif (Not StructKeyExists(Arguments, "groupID") and Not StructKeyExists(Arguments, "targetID"))
			or (StructKeyExists(Arguments, "groupID") and Not Application.fn_IsIntegerList(Arguments.groupID))
			or (StructKeyExists(Arguments, "targetID") and Not Application.fn_IsIntegerList(Arguments.targetID))>
		<cfset Arguments.groupID = 0>
	</cfif>

	<cfquery Name="qry_selectGroupTargetList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT groupTargetID, groupID, primaryTargetID, targetID, userID,
			groupTargetStatus, groupTargetDateCreated, groupTargetDateUpdated
		FROM avGroupTarget
		WHERE groupID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "groupID") and Application.fn_IsIntegerList(Arguments.groupID)>
				AND groupID IN (<cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID)
					and StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerList(Arguments.targetID)>
				AND primaryTargetID IN (<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND targetID IN (<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "groupTargetStatus") and ListFind("0,1", Arguments.groupTargetStatus)>
				AND groupTargetStatus = <cfqueryparam Value="#Arguments.groupTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
	</cfquery>

	<cfreturn qry_selectGroupTargetList>
</cffunction>

</cfcomponent>
