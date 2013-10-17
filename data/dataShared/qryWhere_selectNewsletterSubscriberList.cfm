<cfoutput>
avNewsletterSubscriber.companyID_author = <cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
<cfloop index="field" list="cobrandID,affiliateID,newsletterSubscriberID">
	<cfif StructKeyExists(Arguments, field)> AND avNewsletterSubscriber.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif>
</cfloop>
<cfloop index="field" list="newsletterSubscriberStatus,newsletterSubscriberHtml">
	<cfif StructKeyExists(Arguments, field)> AND avNewsletterSubscriber.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "newsletterSubscriberEmail_list")>AND avNewsletterSubscriber.newsletterSubscriberEmail = <cfqueryparam value="#Arguments.newsletterSubscriberEmail_list#" cfsqltype="cf_sql_varchar"></cfif>
<cfloop index="field" list="newsletterSubscriberEmail">
	<cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">AND avNewsletterSubscriber.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar"></cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "newsletterSubscriberRegistered")>AND avNewsletterSubscriber.userID <cfif Arguments.newsletterSubscriberRegistered is 0> = 0 <cfelse> <> 0 </cfif></cfif>
<cfif StructKeyExists(Arguments, "newsletterSubscriberIsExported")>AND avNewsletterSubscriber.newsletterSubscriberIsExported <cfif Not ListFind("0,1", Arguments.newsletterSubscriberIsExported)>IS NULL<cfelse>= <cfqueryparam value="#Arguments.newsletterSubscriberIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
<cfloop index="field" list="newsletterSubscriberDateCreated,newsletterSubscriberDateUpdated,newsletterSubscriberDateExported">
	<cfif StructKeyExists(Arguments, "#field#_from") and StructKeyExists(Arguments, "#field#_to")>
		AND avNewsletterSubscriber.#field# BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp">
	<cfelseif StructKeyExists(Arguments, "#field#_from")>
		AND avNewsletterSubscriber.#field# >= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_from'])#" cfsqltype="cf_sql_timestamp">
	<cfelseif StructKeyExists(Arguments, "#field#_to")>
		AND avNewsletterSubscriber.#field# <= <cfqueryparam value="#CreateODBCDateTime(Arguments['#field#_to'])#" cfsqltype="cf_sql_timestamp">
	</cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "newsletterSubscriberDateType") and Trim(Arguments.newsletterSubscriberDateType) is not ""
		and (StructKeyExists(Arguments, "newsletterSubscriberDateFrom") or StructKeyExists(Arguments, "newsletterSubscriberDateTo"))>
	<cfset isFirstDate = True>
	<cfloop index="dateField" list="#Arguments.newsletterSubscriberDateType#">
		<cfif ListFind("newsletterSubscriberDateCreated,newsletterSubscriberDateUpdated,newsletterSubscriberDateExported", dateField)>
			<cfif isFirstDate is True>AND (<cfelse>OR<cfset isFirstDate = False></cfif>
			<cfif StructKeyExists(Arguments, "newsletterSubscriberDateFrom") and StructKeyExists(Arguments, "newsletterSubscriberDateTo")>
				avNewsletterSubscriber.#field# BETWEEN <cfqueryparam value="#CreateODBCDateTime(Arguments.newsletterSubscriberDateFrom)#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#CreateODBCDateTime(Arguments.newsletterSubscriberDateTo)#" cfsqltype="cf_sql_timestamp">
			<cfelseif StructKeyExists(Arguments, "newsletterSubscriberDateFrom")>
				avNewsletterSubscriber.#field# >= <cfqueryparam value="#CreateODBCDateTime(Arguments.newsletterSubscriberDateFrom)#" cfsqltype="cf_sql_timestamp">
			<cfelse>
				avNewsletterSubscriber.#field# <= <cfqueryparam value="#CreateODBCDateTime(Arguments.newsletterSubscriberDateTo)#" cfsqltype="cf_sql_timestamp">
			</cfif>
		</cfif><!--- /valid date type --->
	</cfloop><!--- /loop thru date types --->
	<cfif isFirstDate is False>)</cfif>
</cfif><!--- /dateType --->
</cfoutput>
