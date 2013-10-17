<cfoutput>
avNote.noteID > 0
<cfloop index="field" list="noteID,userID_author"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avNote.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif></cfloop>
<cfif StructKeyExists(Arguments, "noteStatus") and ListFind("0,1", Arguments.noteStatus)>AND avNote.noteStatus = <cfqueryparam value="#Arguments.noteStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
<cfif StructKeyExists(Arguments, "noteMessage") and Trim(Arguments.noteMessage) is not "">AND avNote.noteMessage LIKE <cfqueryparam value="%#Arguments.noteMessage#%" cfsqltype="cf_sql_varchar"></cfif>
<cfif StructKeyExists(Arguments, "noteMessage_not") and Trim(Arguments.noteMessage_not) is not "">AND avNote.noteMessage NOT LIKE <cfqueryparam value="%#Arguments.noteMessage_not#%" cfsqltype="cf_sql_varchar"></cfif>
<cfif StructKeyExists(Arguments, "userID_target") and Application.fn_IsIntegerList(Arguments.userID_target)>AND (avNote.userID_target IN (<cfqueryparam value="#Arguments.userID_target#" cfsqltype="cf_sql_integer" list="yes">) OR avNote.userID_partner IN (<cfqueryparam value="#Arguments.userID_target#" cfsqltype="cf_sql_integer" list="yes">))</cfif>
<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID) and StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerList(Arguments.targetID)>
	AND ((avNote.primaryTargetID IN (<cfqueryparam value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" list="yes">)
			AND avNote.targetID IN <cfif ListLen(Arguments.targetID) gt 2000>(#Arguments.targetID#)<cfelse>(<cfqueryparam value="#Arguments.targetID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>)
		OR (avNote.primaryTargetID_partner IN (<cfqueryparam value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" list="yes">)
			AND avNote.targetID_partner IN <cfif ListLen(Arguments.targetID) gt 2000>(#Arguments.targetID#)<cfelse>(<cfqueryparam value="#Arguments.targetID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>))
</cfif>
<cfloop index="field" list="noteDateCreated,noteDateUpdated">
	<cfif StructKeyExists(Arguments, "#field#_from") and StructKeyExists(Arguments, "#field#_to")>
		AND avNote.#field# BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp">
	<cfelseif StructKeyExists(Arguments, "#field#_from")>
		AND avNote.#field# >= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp">
	<cfelseif StructKeyExists(Arguments, "#field#_to")>
		AND avNote.#field# <= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp">
	</cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "companyID_target") and Application.fn_IsIntegerList(Arguments.companyID_target)>
	<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID) and StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerList(Arguments.targetID)>
		<cfswitch Expression="#Application.fn_GetPrimaryTargetKey(Arguments.primaryTargetID)#">
		<cfcase value="affiliateID,cobrandID,vendorID">
			AND (avNote.companyID_target IN (<cfqueryparam value="#Arguments.companyID_target#" cfsqltype="cf_sql_integer" list="yes">)
				OR (avNote.primaryTargetID_partner IN (<cfqueryparam value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" list="yes">) AND avNote.targetID_partner IN (<cfqueryparam value="#Arguments.targetID#" cfsqltype="cf_sql_integer" list="yes">)))
		</cfcase>
		<cfdefaultcase>
			AND avNote.companyID_target IN (<cfqueryparam value="#Arguments.companyID_target#" cfsqltype="cf_sql_integer" list="yes">)
		</cfdefaultcase>
		</cfswitch>
	<cfelse>
		AND avNote.companyID_target IN (<cfqueryparam value="#Arguments.companyID_target#" cfsqltype="cf_sql_integer" list="yes">)
	</cfif>
</cfif>
</cfoutput>
