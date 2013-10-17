<cfcomponent DisplayName="Newsletter" Hint="Manages creating, updating, viewing and managing newsletters">

<cffunction name="maxlength_Newsletter" access="public" output="no" returnType="struct">
	<cfset var maxlength_Newsletter = StructNew()>

	<cfset maxlength_Newsletter.newsletterDescription = 255>

	<cfreturn maxlength_Newsletter>
</cffunction>

<cffunction Name="insertNewsletter" Access="public" Output="No" ReturnType="string" Hint="Inserts newsletter into database and returns ID">
	<cfargument Name="contactID" Type="numeric" Required="Yes">
	<cfargument Name="newsletterRecipientCount" Type="numeric" Required="No" Default="0">
	<cfargument Name="newsletterDescription" Type="string" Required="No" Default="">
	<cfargument Name="newsletterCriteria" Type="string" Required="No" Default="">

	<cfset var qry_insertNewsletter = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Newsletter" method="maxlength_Newsletter" returnVariable="maxlength_Newsletter" />

	<cfquery Name="qry_insertNewsletter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avNewsletter
		(
			contactID, newsletterRecipientCount, newsletterDescription, newsletterCriteria
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.contactID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.newsletterRecipientCount#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Trim(Arguments.newsletterDescription)#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Newsletter.newsletterDescription#">,
			<cfqueryparam Value="#Trim(Arguments.newsletterCriteria)#" cfsqltype="cf_sql_longvarchar">
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "newsletterID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertNewsletter.primaryKeyID>
</cffunction>

<cffunction Name="updateNewsletter" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing newsletter subscriber. Returns True.">
	<cfargument Name="newsletterID" Type="numeric" Required="Yes">
	<cfargument Name="newsletterRecipientCount" Type="numeric" Required="No">
	<cfargument Name="newsletterDescription" Type="string" Required="No">
	<cfargument Name="newsletterCriteria" Type="string" Required="No">

	<cfset var displayComma = False>

	<cfinvoke component="#Application.billingMapping#data.Newsletter" method="maxlength_Newsletter" returnVariable="maxlength_Newsletter" />

	<cfquery Name="qry_updateNewsletter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avNewsletter
		SET 
			<cfif StructKeyExists(Arguments, "contactID") and Application.fn_IsIntegerNonNegative(Arguments.contactID)>
				<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>
				contactID = <cfqueryparam Value="#Arguments.contactID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(Arguments, "newsletterRecipientCount") and Application.fn_IsIntegerNonNegative(Arguments.newsletterRecipientCount)>
				<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>
				newsletterRecipientCount = <cfqueryparam Value="#Arguments.newsletterRecipientCount#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(Arguments, "newsletterDescription")>
				<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>
				newsletterDescription = <cfqueryparam Value="#Trim(Arguments.newsletterDescription)#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Newsletter.newsletterDescription#">
			</cfif>
			<cfif StructKeyExists(Arguments, "newsletterCriteria")>
				<cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>
				newsletterCriteria = <cfqueryparam Value="#Trim(Arguments.newsletterCriteria)#" cfsqltype="cf_sql_longvarchar">
			</cfif>
		WHERE newsletterID = <cfqueryparam Value="#Arguments.newsletterID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkNewsletterPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that company has permission for existing newsletter">
	<cfargument Name="newsletterID" Type="numeric" Required="Yes">
	<!--- <cfargument Name="contactID" Type="numeric" Required="Yes"> --->
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">

	<cfset var qry_checkNewsletterPermission = QueryNew("blank")>

	<cfquery Name="qry_checkNewsletterPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avNewsletter.newsletterID, avNewsletter.contactID
		FROM avNewsletter, avContact
		WHERE avNewsletter.contactID = avContact.contactID
			AND avNewsletter.newsletterID = <cfqueryparam Value="#Arguments.newsletterID#" cfsqltype="cf_sql_integer">
			AND avContact.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkNewsletterPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="deleteNewsletter" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing newsletter">
	<cfargument Name="newsletterID" Type="numeric" Required="Yes">
	<cfargument Name="contactID" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteNewsletter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avNewsletter
		WHERE newsletterID = <cfqueryparam Value="#Arguments.newsletterID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectNewsletter" Access="public" Output="No" ReturnType="query" Hint="Select existing newsletter">
	<cfargument Name="newsletterID" Type="numeric" Required="No">

	<cfset var qry_selectNewsletter = QueryNew("blank")>

	<cfquery Name="qry_selectNewsletter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contactID, newsletterRecipientCount, newsletterDescription, newsletterCriteria
		FROM avNewsletter
		WHERE newsletterID = <cfqueryparam Value="#Arguments.newsletterID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectNewsletter>
</cffunction>

<cffunction Name="selectNewsletterList" Access="public" ReturnType="query" Hint="Selects existing newsletters">
	<cfargument Name="companyID_author" Type="numeric" Required="No">
	<cfargument Name="newsletterID" Type="string" Required="No">
	<cfargument Name="contactID" Type="string" Required="No">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="contactTemplateID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchTextType" Type="string" Required="No">
	<cfargument Name="contactDateType" Type="string" Required="No">
	<cfargument Name="contactSubject" Type="string" Required="No">
	<cfargument Name="contactMessage" Type="string" Required="No">
	<cfargument Name="contactFromName" Type="string" Required="No">
	<cfargument Name="contactID_custom" Type="string" Required="No">
	<cfargument Name="contactDateFrom" Type="date" Required="No">
	<cfargument Name="contactDateTo" Type="date" Required="No">
	<cfargument Name="contactDateCreated_from" Type="date" Required="No">
	<cfargument Name="contactDateCreated_to" Type="date" Required="No">
	<cfargument Name="contactDateUpdated_from" Type="date" Required="No">
	<cfargument Name="contactDateUpdated_to" Type="date" Required="No">
	<cfargument Name="contactDateSent_from" Type="date" Required="No">
	<cfargument Name="contactDateSent_to" Type="date" Required="No">
	<cfargument Name="contactIsSent" Type="numeric" Required="No">
	<cfargument Name="contactHasCustomID" Type="numeric" Required="No">
	<cfargument Name="contactHtml" Type="numeric" Required="No">
	<cfargument Name="contactID_custom_list" Type="string" Required="No">
	<cfargument Name="returnContactMessage" Type="boolean" Required="No" Default="False">
	<cfargument Name="queryOrderBy" Type="string" Required="No" Default="date_d">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">

	<cfset var displayAnd = False>
	<cfset var displayDate = "">
	<cfset var queryParameters_orderBy = "">
	<cfset var queryParameters_orderBy_noTable = "">
	<cfset var qry_selectNewsletterList = QueryNew("blank")>

	<cfswitch Expression="#Arguments.queryOrderBy#">
	<cfcase value="contactID,contactReplyTo,contactFrom,contactSubject,contactID_custom,contactDateUpdated,contactDateSent"><cfset queryParameters_orderBy = "avContact.#Arguments.queryOrderBy#"></cfcase>
	<cfcase value="contactID_d,contactReplyTo_d,contactFrom_d,contactSubject_d,contactID_custom_d,contactDateUpdated_d,contactDateSent_d"><cfset queryParameters_orderBy = "avContact.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	<cfcase value="contactDateCreated"><cfset queryParameters_orderBy = "avContact.contactID"></cfcase>
	<cfcase value="contactDateCreated_d"><cfset queryParameters_orderBy = "avContact.contactID DESC"></cfcase>
	<cfcase value="authorLastName"><cfset queryParameters_orderBy = "AuthorUser.authorLastName, AuthorUser.authorFirstName"></cfcase>
	<cfcase value="authorLastName_d"><cfset queryParameters_orderBy = "AuthorUser.authorLastName DESC, AuthorUser.authorFirstName DESC"></cfcase>
	<cfcase value="newsletterDescription"><cfset queryParameters_orderBy = "avNewsletter.newsletterDescription"></cfcase>
	<cfcase value="newsletterDescription_d"><cfset queryParameters_orderBy = "avNewsletter.newsletterDescription DESC"></cfcase>
	<cfdefaultcase><cfset queryParameters_orderBy = "avContact.contactDateSent DESC"></cfdefaultcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avContact,AuthorUser">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectNewsletterList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avNewsletter.newsletterID, avNewsletter.newsletterRecipientCount, avNewsletter.newsletterDescription, avNewsletter.contactID,
			avContact.userID_author, avContact.contactSubject, avContact.contactHtml, avContact.contactFromName, avContact.contactReplyTo,
			avContact.contactTemplateID, avContact.contactID_custom, avContact.contactDateSent, avContact.contactDateCreated, avContact.contactDateUpdated,
			AuthorUser.firstName AS authorFirstName, AuthorUser.lastName AS authorLastName, AuthorUser.userID_custom AS authorUserID_custom
			<cfif Arguments.returnContactMessage is True>, avContact.contactMessage</cfif>
		FROM avNewsletter
			INNER JOIN avContact ON avNewsletter.contactID = avContact.contactID
			LEFT OUTER JOIN avUser AS AuthorUser ON avContact.userID_author = AuthorUser.userID
		WHERE avNewsletter.newsletterID <> 0
			<cfinclude template="dataShared/qryWhere_selectNewsletterList.cfm">
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectNewsletterList>
</cffunction>

<cffunction Name="selectNewsletterCount" Access="public" ReturnType="numeric" Hint="Select total number of newsletters in list">
	<cfargument Name="companyID_author" Type="numeric" Required="No">
	<cfargument Name="newsletterID" Type="string" Required="No">
	<cfargument Name="contactID" Type="string" Required="No">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="contactTemplateID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchTextType" Type="string" Required="No">
	<cfargument Name="contactDateType" Type="string" Required="No">
	<cfargument Name="contactSubject" Type="string" Required="No">
	<cfargument Name="contactMessage" Type="string" Required="No">
	<cfargument Name="contactFromName" Type="string" Required="No">
	<cfargument Name="contactID_custom" Type="string" Required="No">
	<cfargument Name="contactDateFrom" Type="date" Required="No">
	<cfargument Name="contactDateTo" Type="date" Required="No">
	<cfargument Name="contactDateCreated_from" Type="date" Required="No">
	<cfargument Name="contactDateCreated_to" Type="date" Required="No">
	<cfargument Name="contactDateUpdated_from" Type="date" Required="No">
	<cfargument Name="contactDateUpdated_to" Type="date" Required="No">
	<cfargument Name="contactDateSent_from" Type="date" Required="No">
	<cfargument Name="contactDateSent_to" Type="date" Required="No">
	<cfargument Name="contactIsSent" Type="numeric" Required="No">
	<cfargument Name="contactHasCustomID" Type="numeric" Required="No">
	<cfargument Name="contactHtml" Type="numeric" Required="No">
	<cfargument Name="contactID_custom_list" Type="string" Required="No">

	<cfset var displayAnd = False>
	<cfset var displayDate = "">
	<cfset var qry_selectNewsletterCount = QueryNew("blank")>

	<cfquery Name="qry_selectNewsletterCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(newsletterID) AS totalRecords
		FROM avNewsletter, avContact
		WHERE avNewsletter.contactID = avContact.contactID
			<cfinclude template="dataShared/qryWhere_selectNewsletterList.cfm">
	</cfquery>

	<cfreturn qry_selectNewsletterCount.totalRecords>
</cffunction>

</cfcomponent>

