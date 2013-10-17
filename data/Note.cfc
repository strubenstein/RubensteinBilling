<cfcomponent DisplayName="Note" Hint="Manages creating, viewing and managing notes">

<cffunction Name="insertNote" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new note into database and returns True">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_target" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyID_target" Type="numeric" Required="No" Default="0">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="noteMessage" Type="string" Required="No" Default="">
	<cfargument Name="noteStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="primaryTargetID_partner" Type="numeric" Required="No" Default="0">
	<cfargument Name="targetID_partner" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID_partner" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_insertNote" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avNote
		(
			userID_author, userID_target, companyID_target, primaryTargetID, targetID, noteMessage, noteStatus,
			primaryTargetID_partner, targetID_partner, userID_partner, noteDateCreated, noteDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_target#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_target#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.noteMessage#" cfsqltype="cf_sql_longvarchar">,
			<cfqueryparam Value="#Arguments.noteStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.primaryTargetID_partner#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID_partner#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_partner#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateNote" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing note">
	<cfargument Name="noteID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="noteMessage" Type="string" Required="No">
	<cfargument Name="noteStatus" Type="numeric" Required="No">
	<cfargument Name="primaryTargetID_partner" Type="numeric" Required="No" Default="0">
	<cfargument Name="targetID_partner" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID_partner" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_updateNote" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avNote
		SET 
			<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>userID_author = <cfqueryparam Value="#Arguments.contactHtml#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "noteMessage")>noteMessage = <cfqueryparam Value="#Arguments.noteMessage#" cfsqltype="cf_sql_longvarchar">,</cfif>
			<cfif StructKeyExists(Arguments, "noteStatus") and ListFind("0,1", Arguments.noteStatus)>noteStatus = <cfqueryparam Value="#Arguments.noteStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetID_partner") and Application.fn_IsIntegerNonNegative(Arguments.primaryTargetID_partner)>primaryTargetID_partner = <cfqueryparam Value="#Arguments.primaryTargetID_partner#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "targetID_partner") and Application.fn_IsIntegerNonNegative(Arguments.targetID_partner)>targetID_partner = <cfqueryparam Value="#Arguments.targetID_partner#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "userID_partner") and Application.fn_IsIntegerNonNegative(Arguments.userID_partner)>userID_partner = <cfqueryparam Value="#Arguments.userID_partner#" cfsqltype="cf_sql_integer">,</cfif>
			noteDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE noteID = <cfqueryparam Value="#Arguments.noteID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectNote" Access="public" Output="No" ReturnType="query" Hint="Selects existing note">
	<cfargument Name="noteID" Type="numeric" Required="Yes">

	<cfset var qry_selectNote = QueryNew("blank")>

	<cfquery Name="qry_selectNote" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID_author, primaryTargetID, targetID, noteMessage, noteStatus, userID_target, companyID_target,
			primaryTargetID_partner, targetID_partner, userID_partner, noteDateCreated, noteDateUpdated
		FROM avNote
		WHERE noteID = <cfqueryparam Value="#Arguments.noteID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectNote>
</cffunction>

<cffunction Name="deleteNote" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing note">
	<cfargument Name="noteID" Type="string" Required="Yes">

	<cfquery Name="qry_deleteNote" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avNote
		WHERE noteID IN (<cfqueryparam Value="#Arguments.noteID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkNotePermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for note entry">
	<cfargument Name="noteID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="companyID_target" Type="numeric" Required="No">
	<cfargument Name="userID_target" Type="numeric" Required="No">

	<cfset var qry_checkNotePermission = QueryNew("blank")>

	<cfquery Name="qry_checkNotePermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID_author, userID_target, companyID_target
		FROM avNote
		WHERE noteID = <cfqueryparam Value="#Arguments.noteID#" cfsqltype="cf_sql_integer">
			AND (primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">)
			  OR (primaryTargetID_partner = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND targetID_partner = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">)
	</cfquery>

	<cfif qry_checkNotePermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectNoteList" Access="public" ReturnType="query" Hint="Select list of notes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="userID_target" Type="string" Required="No">
	<cfargument Name="companyID_target" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="noteID" Type="string" Required="No">
	<cfargument Name="noteMessage" Type="string" Required="No">
	<cfargument Name="noteMessage_not" Type="string" Required="No">
	<cfargument Name="noteStatus" Type="numeric" Required="No">
	<cfargument Name="noteDateCreated_from" Type="date" Required="No">
	<cfargument Name="noteDateCreated_to" Type="date" Required="No">
	<cfargument Name="noteDateUpdated_from" Type="date" Required="No">
	<cfargument Name="noteDateUpdated_to" Type="date" Required="No">
	<cfargument Name="queryOrderBy" Type="string" Required="no" default="noteID_d">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">

	<cfset var qry_selectNoteList = QueryNew("blank")>
	<cfset var queryParameters_orderBy = "">
	<cfset var queryParameters_orderBy_noTable = "">

	<cfswitch Expression="#Arguments.queryOrderBy#">
	<cfcase value="noteDateCreated"><cfset queryParameters_orderBy = "avNote.noteID"></cfcase>
	<cfcase value="noteDateCreated_d"><cfset queryParameters_orderBy = "avNote.noteID DESC"></cfcase>
	<cfcase value="noteDateUpdated"><cfset queryParameters_orderBy = "avNote.noteDateUpdated"></cfcase>
	<cfcase value="noteDateUpdated_d"><cfset queryParameters_orderBy = "avNote.noteDateUpdated DESC"></cfcase>
	<cfcase value="lastName"><cfset queryParameters_orderBy = "avUser.lastName, avUser.firstName"></cfcase>
	<cfcase value="lastName_d"><cfset queryParameters_orderBy = "avUser.lastName DESC, avUser.firstName DESC"></cfcase>
	<cfdefaultcase><cfset queryParameters_orderBy = "avNote.noteID DESC"></cfdefaultcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = Replace(Replace(queryParameters_orderBy, "avNote.", "", "all"), "avUser.", "", "all")>

	<cfquery Name="qry_selectNoteList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			<cfif Application.billingDatabase is "MSSQLServer">* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,</cfif>
			avNote.noteID, avNote.userID_author, avNote.primaryTargetID, avNote.targetID, avNote.userID_target, avNote.companyID_target,
			avNote.noteMessage, avNote.noteStatus, avNote.primaryTargetID_partner, avNote.targetID_partner, avNote.userID_partner,
			avNote.noteDateCreated, avNote.noteDateUpdated,
			avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom
		FROM avNote LEFT OUTER JOIN avUser ON avNote.userID_author = avUser.userID
		WHERE <cfinclude template="dataShared/qryWhere_selectNoteList.cfm">
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectNoteList>
</cffunction>

<cffunction Name="selectNoteCount" Access="public" ReturnType="numeric" Hint="Select total number of notes in list">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="userID_target" Type="string" Required="No">
	<cfargument Name="companyID_target" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="noteID" Type="string" Required="No">
	<cfargument Name="noteMessage" Type="string" Required="No">
	<cfargument Name="noteMessage_not" Type="string" Required="No">
	<cfargument Name="noteStatus" Type="numeric" Required="No">
	<cfargument Name="noteDateCreated_from" Type="date" Required="No">
	<cfargument Name="noteDateCreated_to" Type="date" Required="No">
	<cfargument Name="noteDateUpdated_from" Type="date" Required="No">
	<cfargument Name="noteDateUpdated_to" Type="date" Required="No">

	<cfset var qry_selectNoteCount = QueryNew("blank")>

	<cfquery Name="qry_selectNoteCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(noteID) AS totalRecords
		FROM avNote
		WHERE <cfinclude template="dataShared/qryWhere_selectNoteList.cfm">
	</cfquery>

	<cfreturn qry_selectNoteCount.totalRecords>
</cffunction>

</cfcomponent>

