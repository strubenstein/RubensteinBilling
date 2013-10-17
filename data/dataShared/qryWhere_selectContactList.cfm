<cfoutput>
avContact.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
<cfloop Index="field" List="contactID,userID_author,contactTopicID,contactTemplateID,contactID_orig">
	<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avContact.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "companyID_target") and Application.fn_IsIntegerList(Arguments.companyID_target)>
	<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID) and StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerList(Arguments.targetID)>
		<cfswitch Expression="#Application.fn_GetPrimaryTargetKey(Arguments.primaryTargetID)#">
		<cfcase value="affiliateID,cobrandID,vendorID">
			AND (avContact.companyID_target IN (<cfqueryparam value="#Arguments.companyID_target#" cfsqltype="cf_sql_integer" list="yes">)
				OR (avContact.primaryTargetID_partner IN (<cfqueryparam value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" list="yes">)
					AND avContact.targetID_partner IN (<cfqueryparam value="#Arguments.targetID#" cfsqltype="cf_sql_integer" list="yes">)))</cfcase>
		<cfdefaultcase>AND avContact.companyID_target IN (<cfqueryparam value="#Arguments.companyID_target#" cfsqltype="cf_sql_integer" list="yes">)</cfdefaultcase>
		</cfswitch>
	<cfelse>
		AND avContact.companyID_target IN (<cfqueryparam value="#Arguments.companyID_target#" cfsqltype="cf_sql_integer" list="yes">)
	</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "userID_target") and Application.fn_IsIntegerList(Arguments.userID_target)>
	AND (avContact.userID_target IN (#Arguments.userID_target#) OR avContact.userID_partner IN (<cfqueryparam value="#Arguments.userID_target#" cfsqltype="cf_sql_integer" list="yes">))
</cfif>
<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID)	and StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerList(Arguments.targetID)>
	AND ((avContact.primaryTargetID IN (<cfqueryparam value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" list="yes">)
		AND avContact.targetID IN (<cfqueryparam value="#Arguments.targetID#" cfsqltype="cf_sql_integer" list="yes">))
	  OR (avContact.primaryTargetID_partner IN (<cfqueryparam value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" list="yes">)
	  	AND avContact.targetID_partner IN (<cfqueryparam value="#Arguments.targetID#" cfsqltype="cf_sql_integer" list="yes">)))
</cfif>
<cfif StructKeyExists(Arguments, "statusID") and Application.fn_IsIntegerList(Arguments.statusID)>
	AND avContact.contactID <cfif Arguments.statusID is 0>NOT</cfif> IN 
	(SELECT targetID FROM avStatusHistory WHERE statusHistoryStatus = 1
		AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('contactID')#" cfsqltype="cf_sql_integer"> 
		<cfif Arguments.statusID is not 0>AND statusID IN (<cfqueryparam value="#Arguments.statusID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>)
</cfif>
<cfif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>AND avContact.companyID_target IN (SELECT companyID FROM avAffiliate WHERE affiliateID IN (<cfqueryparam value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" list="yes">))</cfif>
<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>AND avContact.companyID_target IN (SELECT companyID FROM avCobrand WHERE cobrandID IN (<cfqueryparam value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" list="yes">))</cfif>
<cfif StructKeyExists(Arguments, "groupID") and Application.fn_IsIntegerList(Arguments.groupID)>
	<cfif Arguments.groupID is 0>
		AND avContact.companyID_target NOT IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer">)
		AND avContact.userID_target NOT IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('userID')#" cfsqltype="cf_sql_integer">)
	<cfelse>
		AND (avContact.companyID_target IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('companyID')#" cfsqltype="cf_sql_integer"> AND groupID IN (<cfqueryparam value="#Arguments.groupID#" cfsqltype="cf_sql_integer" list="yes">))
			OR AND avContact.userID_target IN (SELECT targetID FROM avGroupTarget WHERE groupTargetStatus = 1 AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('userID')#" cfsqltype="cf_sql_integer"> AND groupID IN (<cfqueryparam value="#Arguments.groupID#" cfsqltype="cf_sql_integer" list="yes">)))
	</cfif>
</cfif>
<cfloop Index="field" List="contactHtml,contactFax,contactEmail,contactByCustomer,contactReplied,contactStatus"><cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avContact.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif></cfloop>
<cfloop Index="field" List="contactSubject,contactMessage,contactFromName,contactReplyTo,contactTo,contactCC,contactBCC,contactID_custom"><cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">AND avContact.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar"></cfif></cfloop>
<cfif StructKeyExists(Arguments, "contactToMultiple") and ListFind("0,1", Arguments.contactToMultiple)>AND avContact.contactTo <cfif Arguments.contactToMultiple is 0>NOT</cfif> LIKE <cfqueryparam value="%,%" cfsqltype="cf_sql_varchar"></cfif>
<cfif StructKeyExists(Arguments, "contactHasCC") and ListFind("0,1", Arguments.contactHasCC)>AND avContact.contactCC <cfif Arguments.contactHasCC is 0> = '' <cfelse> <> ''</cfif></cfif>
<cfif StructKeyExists(Arguments, "contactHasBCC") and ListFind("0,1", Arguments.contactHasBCC)>AND avContact.contactBCC <cfif Arguments.contactHasBCC is 0> = '' <cfelse> <> ''</cfif></cfif>
<cfif StructKeyExists(Arguments, "contactHasCustomID") and ListFind("0,1", Arguments.contactHasCustomID)>AND avContact.contactID_custom <cfif Arguments.contactHasCustomID is 1> <> '' <cfelse> = '' </cfif></cfif>
<cfif StructKeyExists(Arguments, "contactIsReply") and ListFind("0,1", Arguments.contactIsReply)>AND avContact.contactID_orig <cfif Arguments.contactID_orig is 0> = 0 <cfelse> <> 0 </cfif></cfif>
<cfif StructKeyExists(Arguments, "contactIsSent") and ListFind("0,1", Arguments.contactIsSent)>AND avContact.contactDateSent IS <cfif Arguments.contactIsSent is 1>NOT</cfif> NULL</cfif>
<cfif StructKeyExists(Arguments, "contactDateSent_from") and IsDate(Arguments.contactDateSent_from)>AND avContact.contactDateSent >= <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateSent_from)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "contactDateSent_to") and IsDate(Arguments.contactDateSent_to)>AND avContact.contactDateSent <= <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateSent_to)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "contactDateCreated_from") and IsDate(Arguments.contactDateCreated_from)>AND avContact.contactDateCreated >= <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateCreated_from)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "contactDateCreated_to") and IsDate(Arguments.contactDateCreated_to)>AND avContact.contactDateCreated <= <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateCreated_to)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "contactDateUpdated_from") and IsDate(Arguments.contactDateUpdated_from)>AND avContact.contactDateUpdated >= <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateUpdated_from)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "contactDateUpdated_to") and IsDate(Arguments.contactDateUpdated_to)>AND avContact.contactDateUpdated <= <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateUpdated_to)#" cfsqltype="cf_sql_timestamp"></cfif>
<cfif StructKeyExists(Arguments, "searchText") and Trim(Arguments.searchText) is not "" and StructKeyExists(Arguments, "searchTextType") and Trim(Arguments.searchTextType) is not "">
	<cfset displayOr = False>
	<cfloop Index="field" List="contactMessage,contactSubject,contactFromName,contactID_custom,contactReplyTo,contactTo,contactCC,contactBCC">
		<cfif ListFind(Arguments.searchTextType, field)><cfif displayOr is True>OR<cfelse>AND (<cfset displayOr = True></cfif> avContact.#field# LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar"> </cfif>
	</cfloop>
	<cfif displayOr is True>)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "searchEmail") and Trim(Arguments.searchEmail) is not "" and StructKeyExists(Arguments, "searchEmailType") and (ListFind("contactReplyTo", Arguments.searchEmailType) or ListFind("contactTo", Arguments.searchEmailType) or ListFind("contactCC", Arguments.searchEmailType) or ListFind("contactBCC", Arguments.searchEmailType))>
	<cfset displayAnd = False>
	AND (
	<cfloop Index="field" List="contactReplyTo,contactTo,contactCC,contactBCC">
		<cfif ListFind(Arguments.searchEmailType, field)><cfif displayAnd is True>OR<cfelse><cfset displayAnd = True></cfif> avContact.#field# LIKE <cfqueryparam value="%#Arguments.searchEmail#%" cfsqltype="cf_sql_varchar"> </cfif>
	</cfloop>
	)
</cfif>
<cfif StructKeyExists(Arguments, "contactDateType") and (ListFind("contactDateCreated", Arguments.contactDateType) or ListFind("contactDateUpdated", Arguments.contactDateType) or ListFind("contactDateSent", Arguments.contactDateType)) and ((StructKeyExists(Arguments, "contactDateFrom") and IsDate(Arguments.contactDateFrom)) or (StructKeyExists(Arguments, "contactDateTo") and IsDate(Arguments.contactDateTo)))>
	<cfset displayAnd = False>
	AND (
	<cfloop Index="field" List="contactDateCreated,contactDateUpdated,contactDateSent">
		<cfif ListFind(Arguments.contactDateType, field)>
			<cfif displayAnd is True>OR<cfelse><cfset displayAnd = True></cfif>
			(avContact.#field# 
			<cfif StructKeyExists(Arguments, "contactDateFrom") and IsDate(Arguments.contactDateFrom) and StructKeyExists(Arguments, "contactDateTo") and IsDate(Arguments.contactDateTo)>
				BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateFrom)#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateTo)#" cfsqltype="cf_sql_timestamp">
			<cfelseif StructKeyExists(Arguments, "contactDateFrom") and IsDate(Arguments.contactDateFrom)>
				>= <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateFrom)#" cfsqltype="cf_sql_timestamp">
			<cfelse><!--- StructKeyExists(Arguments, "contactDateTo") and IsDate(Arguments.contactDateTo) --->
				<= <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateTo)#" cfsqltype="cf_sql_timestamp">
			</cfif>
			)
		</cfif>
	</cfloop>
	)
</cfif>
</cfoutput>
