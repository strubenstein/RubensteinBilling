<cfoutput>
<cfif StructKeyExists(Arguments, "newsletterID") and Application.fn_IsIntegerList(Arguments.newsletterID)>
	AND avNewsletter.newsletterID IN (<cfqueryparam value="#Arguments.newsletterID#" cfsqltype="cf_sql_integer" list="yes">)
</cfif>
<cfloop index="field" list="companyID_author,userID_author,contactTemplateID">
	<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
		AND avContact.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">)
	</cfif>
</cfloop>
<cfloop index="field" list="contactSubject,contactMessage,contactFromName,contactID_custom">
	<cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">
		AND avContact.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar">
	</cfif>
	<cfif StructKeyExists(Arguments, "#field#_match") and Trim(Arguments["#field#_match"]) is not "">
		AND avContact.#field# = <cfqueryparam value="#Arguments['#field#_match']#" cfsqltype="cf_sql_varchar">
	</cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "contactHtml") and ListFind("0,1", Arguments.contactHtml)>
	AND avContact.contactHtml = <cfqueryparam value="#Arguments.contactHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
</cfif>
<cfif StructKeyExists(Arguments, "contactHasCustomID") and ListFind("0,1", Arguments.contactHasCustomID)>
	AND avContact.contactID_custom <cfif Arguments.contactHasCustomID is 0> <> '' <cfelse> = '' </cfif>
</cfif>
<cfif StructKeyExists(Arguments, "contactIsSent") and ListFind("0,1", Arguments.contactIsSent)>
	AND avContact.contactDateSent IS <cfif Arguments.contactIsSent is 0>NOT</cfif> NULL
</cfif>

<cfloop index="field" list="contactDateSent,contactDateCreated,contactDateUpdated">
	<cfif StructKeyExists(Arguments, "#field#_from") and StructKeyExists(Arguments, "#field#_to")>
		AND avContact.#field# BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp">
	 <cfelseif StructKeyExists(Arguments, "#field#_from")>
	 	AND avContact.#field# >= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp">
	 <cfelseif StructKeyExists(Arguments, "#field#_to")>
	 	AND avContact.#field# <= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp">
	</cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "searchText") and Trim(Arguments.searchText) is not "" and StructKeyExists(Arguments, "searchTextType")
		and (ListFind("contactMessage", Arguments.searchTextType) or ListFind("contactSubject", Arguments.searchTextType) or ListFind("contactFromName", Arguments.searchTextType) or ListFind("contactID_custom", Arguments.searchTextType))>
	<cfset displayAnd = False>
	AND (
		<cfloop Index="field" List="contactMessage,contactSubject,contactFromName,contactID_custom">
			<cfif ListFind(Arguments.searchTextType, field)>
				<cfif displayAnd is True>OR<cfelse><cfset displayAnd = True></cfif>
				avContact.#field# LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfloop>
		)
</cfif>
<cfif StructKeyExists(Arguments, "contactDateType") 
		and (ListFind("contactDateCreated", Arguments.contactDateType) or ListFind("contactDateUpdated", Arguments.contactDateType) or ListFind("contactDateSent", Arguments.contactDateType))
		and (StructKeyExists(Arguments, "contactDateFrom") or StructKeyExists(Arguments, "contactDateTo"))>
	<cfset displayAnd = False>
	AND (
		<cfloop Index="field" List="contactDateCreated,contactDateUpdated,contactDateSent">
			<cfif ListFind(Arguments.contactDateType, field)>
				<cfif displayAnd is True>OR<cfelse><cfset displayAnd = True></cfif>
				<cfif StructKeyExists(Arguments, "contactDateFrom") and StructKeyExists(Arguments, "contactDateTo")>
					AND avContact.#field# BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateFrom)#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateTo)#" cfsqltype="cf_sql_timestamp">
				 <cfelseif StructKeyExists(Arguments, "contactDateFrom")>
				 	AND avContact.#field# >= <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateFrom)#" cfsqltype="cf_sql_timestamp">
				 <cfelseif StructKeyExists(Arguments, "#field#_to")>
				 	AND avContact.#field# <= <cfqueryparam value="#CreateODBCDateTime(Arguments.contactDateTo)#" cfsqltype="cf_sql_timestamp">
				</cfif>
			</cfif>
		</cfloop>
		)
</cfif>
</cfoutput>