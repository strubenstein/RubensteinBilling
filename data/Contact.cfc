<cfcomponent DisplayName="Contact" Hint="Manages creating, viewing and managing contact management">

<cffunction name="maxlength_Contact" access="public" output="no" returnType="struct">
	<cfset var maxlength_Contact = StructNew()>

	<cfset maxlength_Contact.contactSubject = 100>
	<cfset maxlength_Contact.contactFromName = 100>
	<cfset maxlength_Contact.contactReplyTo = 100>
	<cfset maxlength_Contact.contactTo = 255>
	<cfset maxlength_Contact.contactCC = 255>
	<cfset maxlength_Contact.contactBCC = 255>
	<cfset maxlength_Contact.contactID_custom = 50>

	<cfreturn maxlength_Contact>
</cffunction>

<cffunction Name="insertContact" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new contact management into database. Returns contactID">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="companyID_target" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID_target" Type="numeric" Required="No" Default="0">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="contactSubject" Type="string" Required="No" Default="">
	<cfargument Name="contactMessage" Type="string" Required="No" Default="">
	<cfargument Name="contactHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="contactFax" Type="numeric" Required="No" Default="0">
	<cfargument Name="contactEmail" Type="numeric" Required="No" Default="0">
	<cfargument Name="contactByCustomer" Type="numeric" Required="No" Default="0">
	<cfargument Name="contactFromName" Type="string" Required="No" Default="">
	<cfargument Name="contactReplyTo" Type="string" Required="No" Default="">
	<cfargument Name="contactTo" Type="string" Required="No" Default="">
	<cfargument Name="contactCC" Type="string" Required="No" Default="">
	<cfargument Name="contactBCC" Type="string" Required="No" Default="">
	<cfargument Name="contactTopicID" Type="numeric" Required="No" Default="0">
	<cfargument Name="contactTemplateID" Type="numeric" Required="No" Default="0">
	<cfargument Name="contactID_custom" Type="string" Required="No" Default="">
	<cfargument Name="contactID_orig" Type="numeric" Required="No" Default="0">
	<cfargument Name="contactReplied" Type="numeric" Required="No" Default="0">
	<cfargument Name="contactStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="contactDateSent" Type="string" Required="No" Default="">
	<cfargument Name="primaryTargetID_partner" Type="numeric" Required="No" Default="0">
	<cfargument Name="targetID_partner" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID_partner" Type="numeric" Required="No" Default="0">

	<cfset var qry_insertContact = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Contact" method="maxlength_Contact" returnVariable="maxlength_Contact" />

	<cfquery Name="qry_insertContact" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avContact
		(
			companyID_author, userID_author, companyID_target, userID_target, primaryTargetID, targetID,
			contactSubject, contactMessage, contactHtml, contactFax, contactEmail, contactByCustomer,
			contactFromName, contactReplyTo, contactTo, contactCC, contactBCC, contactTopicID,
			contactTemplateID, contactID_custom, contactID_orig, contactReplied, contactStatus, contactDateSent,
			primaryTargetID_partner, targetID_partner, userID_partner, contactDateCreated, contactDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_target#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_target#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.contactSubject#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactSubject#">,
			<cfqueryparam Value="#Arguments.contactMessage#" cfsqltype="cf_sql_longvarchar">,
			<cfqueryparam Value="#Arguments.contactHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contactFax#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contactEmail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contactByCustomer#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contactFromName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactFromName#">,
			<cfqueryparam Value="#Arguments.contactReplyTo#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactReplyTo#">,
			<cfqueryparam Value="#Arguments.contactTo#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactTo#">,
			<cfqueryparam Value="#Arguments.contactCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactCC#">,
			<cfqueryparam Value="#Arguments.contactBCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactBCC#">,
			<cfqueryparam Value="#Arguments.contactTopicID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.contactID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactID_custom#">,
			<cfqueryparam Value="#Arguments.contactID_orig#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.contactReplied#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contactStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "contactDateSent") or Not IsDate(Arguments.contactDateSent)>NULL<cfelse><cfqueryparam Value="#Arguments.contactDateSent#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.primaryTargetID_partner#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID_partner#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_partner#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "contactID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertContact.primaryKeyID>
</cffunction>

<cffunction Name="updateContact" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing contact management into database and returns True">
	<cfargument Name="contactID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="contactSubject" Type="string" Required="No">
	<cfargument Name="contactMessage" Type="string" Required="No">
	<cfargument Name="contactHtml" Type="numeric" Required="No">
	<cfargument Name="contactFax" Type="numeric" Required="No">
	<cfargument Name="contactEmail" Type="numeric" Required="No">
	<cfargument Name="contactFromName" Type="string" Required="No">
	<cfargument Name="contactReplyTo" Type="string" Required="No">
	<cfargument Name="contactTo" Type="string" Required="No">
	<cfargument Name="contactCC" Type="string" Required="No">
	<cfargument Name="contactBCC" Type="string" Required="No">
	<cfargument Name="contactTopicID" Type="numeric" Required="No">
	<cfargument Name="contactTemplateID" Type="numeric" Required="No">
	<cfargument Name="contactID_custom" Type="string" Required="No">
	<cfargument Name="contactReplied" Type="numeric" Required="No">
	<cfargument Name="contactStatus" Type="numeric" Required="No">
	<cfargument Name="contactDateSent" Type="string" Required="No">
	<cfargument Name="primaryTargetID_partner" Type="numeric" Required="No">
	<cfargument Name="targetID_partner" Type="numeric" Required="No">
	<cfargument Name="userID_partner" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Contact" method="maxlength_Contact" returnVariable="maxlength_Contact" />

	<cfquery Name="qry_updateContact" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContact
		SET
			<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>userID_author = <cfqueryparam Value="#Arguments.contactHtml#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "contactSubject")>contactSubject = <cfqueryparam Value="#Arguments.contactSubject#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactSubject#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactMessage")>contactMessage = <cfqueryparam Value="#Arguments.contactMessage#" cfsqltype="cf_sql_longvarchar">,</cfif>
			<cfif StructKeyExists(Arguments, "contactHtml") and ListFind("0,1", Arguments.contactHtml)>contactHtml = <cfqueryparam Value="#Arguments.contactHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactFax") and ListFind("0,1", Arguments.contactFax)>contactFax = <cfqueryparam Value="#Arguments.contactFax#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactEmail") and ListFind("0,1", Arguments.contactEmail)>contactEmail = <cfqueryparam Value="#Arguments.contactEmail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactFromName")>contactFromName = <cfqueryparam Value="#Arguments.contactFromName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactFromName#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactReplyTo")>contactReplyTo = <cfqueryparam Value="#Arguments.contactReplyTo#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactReplyTo#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTo")>contactTo = <cfqueryparam Value="#Arguments.contactTo#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactTo#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactCC")>contactCC = <cfqueryparam Value="#Arguments.contactCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactCC#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactBCC")>contactBCC = <cfqueryparam Value="#Arguments.contactBCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactBCC#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTopicID") and Application.fn_IsIntegerNonNegative(Arguments.contactTopicID)>contactTopicID = <cfqueryparam Value="#Arguments.contactTopicID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateID") and Application.fn_IsIntegerNonNegative(Arguments.contactTemplateID)>contactTemplateID = <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "contactID_custom")>contactID_custom = <cfqueryparam Value="#Arguments.contactID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Contact.contactID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactReplied") and ListFind("0,1", Arguments.contactReplied)>contactReplied = <cfqueryparam Value="#Arguments.contactReplied#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactStatus") and ListFind("0,1", Arguments.contactStatus)>contactStatus = <cfqueryparam Value="#Arguments.contactStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactDateSent")>contactDateSent = <cfif Not IsDate(Arguments.contactDateSent)>NULL<cfelse><cfqueryparam Value="#Arguments.contactDateSent#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetID_partner") and Application.fn_IsIntegerNonNegative(Arguments.primaryTargetID_partner)>primaryTargetID_partner = <cfqueryparam Value="#Arguments.primaryTargetID_partner#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "targetID_partner") and Application.fn_IsIntegerNonNegative(Arguments.targetID_partner)>targetID_partner = <cfqueryparam Value="#Arguments.targetID_partner#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "userID_partner") and Application.fn_IsIntegerNonNegative(Arguments.userID_partner)>userID_partner = <cfqueryparam Value="#Arguments.userID_partner#" cfsqltype="cf_sql_integer">,</cfif>
			contactDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE contactID = <cfqueryparam Value="#Arguments.contactID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectContact" Access="public" Output="No" ReturnType="query" Hint="Selects existing contact management entry">
	<cfargument Name="contactID" Type="numeric" Required="Yes">

	<cfset var qry_selectContact = QueryNew("blank")>

	<cfquery Name="qry_selectContact" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID_author, userID_author, companyID_target, userID_target,
			primaryTargetID, targetID, contactSubject, contactMessage, contactHtml,
			contactFax, contactEmail, contactByCustomer, contactFromName,
			contactReplyTo, contactTo, contactCC, contactBCC, contactTopicID,
			contactTemplateID, contactID_custom, contactID_orig, contactReplied,
			contactStatus, contactDateSent, primaryTargetID_partner, targetID_partner,
			userID_partner, contactDateCreated, contactDateUpdated
		FROM avContact
		WHERE contactID = <cfqueryparam Value="#Arguments.contactID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectContact>
</cffunction>

<cffunction Name="deleteContact" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing contact management entry">
	<cfargument Name="contactID" Type="string" Required="Yes">

	<cfquery Name="qry_deleteContact" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avContact
		WHERE contactID IN (<cfqueryparam Value="#Arguments.contactID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>
	<cfreturn True>
</cffunction>

<cffunction Name="checkContactPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for contact management entry">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="contactID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="numeric" Required="No">
	<cfargument Name="userID_target" Type="numeric" Required="No">
	<cfargument Name="companyID_target" Type="numeric" Required="No">

	<cfset var qry_checkContactPermission = QueryNew("blank")>

	<cfquery Name="qry_checkContactPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID_author
		FROM avContact
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND contactID = <cfqueryparam Value="#Arguments.contactID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "companyID_target") and Application.fn_IsIntegerList(Arguments.companyID_target)>
				<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID) and StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerList(Arguments.targetID)>
					<cfset primaryTargetKey = Application.fn_GetPrimaryTargetKey(Arguments.primaryTargetID)>
					<cfswitch expression="#primaryTargetKey#">
					<cfcase value="affiliateID,cobrandID,vendorID">
						AND (avContact.companyID_target IN (#Arguments.companyID_target#) OR 
							(avContact.primaryTargetID_partner IN (#Arguments.primaryTargetID#) AND avContact.targetID_partner IN (#Arguments.targetID#)))
					</cfcase>
					<cfdefaultcase>
						AND avContact.companyID_target IN (#Arguments.companyID_target#)
					</cfdefaultcase>
					</cfswitch>
				<cfelse>
					AND avContact.companyID_target IN (#Arguments.companyID_target#)
				</cfif>
			</cfif>
			<cfif StructKeyExists(Arguments, "userID_target") and Application.fn_IsIntegerList(Arguments.userID_target)>
				AND (avContact.userID_target IN (#Arguments.userID_target#) OR avContact.userID_partner IN (#Arguments.userID_target#))
			</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID)
					and StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerList(Arguments.targetID)>
				AND ((avContact.primaryTargetID IN (#Arguments.primaryTargetID#) AND avContact.targetID IN (#Arguments.targetID#))
					OR (avContact.primaryTargetID_partner IN (#Arguments.primaryTargetID#) AND avContact.targetID_partner IN (#Arguments.targetID#)))
			</cfif>
	 </cfquery>

	<cfif qry_checkContactPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectMaxContactID_custom" Access="public" Output="No" ReturnType="string" Hint="Select maximum contactID_custom for a particular day for incrementing contactID_custom">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="contactDateSent" Type="date" Required="No" Default="#Now()#">

	<cfset var qry_selectMaxContactID_custom = QueryNew("blank")>

	<cfquery Name="qry_selectMaxContactID_custom" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT MAX(contactID_custom) AS maxContactID_custom
		FROM avContact
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND Year(contactDateSent) = #Year(Arguments.contactDateSent)#
			AND Month(contactDateSent) = #Month(Arguments.contactDateSent)#
			AND Day(contactDateSent) = #Day(Arguments.contactDateSent)#
	</cfquery>

	<cfreturn qry_selectMaxContactID_custom.maxContactID_custom>
</cffunction>

<cffunction Name="generateContactTicket" Access="public" Output="No" ReturnType="string" Hint="Generate next ticket number">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="contactDateSent" Type="date" Required="No" Default="#Now()#">

	<cfset var qry_selectMaxContactID_custom = QueryNew("blank")>
	<cfset var maxContactID_custom = selectMaxContactID_custom(Arguments.companyID_author, Arguments.contactDateSent)>
	<cfset var nextID = 0>
	<cfset var contactID_custom = "">

	<cfif maxContactID_custom is "">
		<cfset nextID = 1>
	<cfelse>
		<cfset nextID = 1 + ListLast(maxContactID_custom, "-")>
	</cfif>
	<cfset contactID_custom = DateFormat(Now(), "yyyymmdd") & "-" & NumberFormat(nextID, "00000")>

	<cfreturn contactID_custom>
</cffunction>

<cffunction Name="selectContactList" Access="public" ReturnType="query" Hint="Select existing contact messages">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="contactID" Type="string" Required="No">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="companyID_target" Type="string" Required="No">
	<cfargument Name="userID_target" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="contactTemplateID" Type="string" Required="No">
	<cfargument Name="contactTopicID" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchTextType" Type="string" Required="No">
	<cfargument Name="searchEmail" Type="string" Required="No">
	<cfargument Name="searchEmailType" Type="string" Required="No">
	<cfargument Name="contactDateType" Type="string" Required="No">
	<cfargument Name="contactSubject" Type="string" Required="No">
	<cfargument Name="contactMessage" Type="string" Required="No">
	<cfargument Name="contactFromName" Type="string" Required="No">
	<cfargument Name="contactReplyTo" Type="string" Required="No">
	<cfargument Name="contactTo" Type="string" Required="No">
	<cfargument Name="contactCC" Type="string" Required="No">
	<cfargument Name="contactBCC" Type="string" Required="No">
	<cfargument Name="contactID_custom" Type="string" Required="No">
	<cfargument Name="contactID_orig" Type="string" Required="No">
	<cfargument Name="contactDateFrom" Type="date" Required="No">
	<cfargument Name="contactDateTo" Type="date" Required="No">
	<cfargument Name="contactDateCreated_from" Type="date" Required="No">
	<cfargument Name="contactDateCreated_to" Type="date" Required="No">
	<cfargument Name="contactDateUpdated_from" Type="date" Required="No">
	<cfargument Name="contactDateUpdated_to" Type="date" Required="No">
	<cfargument Name="contactDateSent_from" Type="date" Required="No">
	<cfargument Name="contactDateSent_to" Type="date" Required="No">
	<cfargument Name="contactByCustomer" Type="numeric" Required="No">
	<cfargument Name="contactIsSent" Type="numeric" Required="No">
	<cfargument Name="contactHasCustomID" Type="numeric" Required="No">
	<cfargument Name="contactIsReply" Type="numeric" Required="No">
	<cfargument Name="contactReplied" Type="numeric" Required="No">
	<cfargument Name="contactStatus" Type="numeric" Required="No">
	<cfargument Name="contactHtml" Type="numeric" Required="No">
	<cfargument Name="contactToMultiple" Type="numeric" Required="No">
	<cfargument Name="contactHasCC" Type="numeric" Required="No">
	<cfargument Name="contactHasBCC" Type="numeric" Required="No">
	<cfargument Name="contactEmail" Type="numeric" Required="No">
	<cfargument Name="contactFax" Type="numeric" Required="No">
	<cfargument Name="returnContactInfo" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnContactMessage" Type="boolean" Required="No" Default="False">
	<cfargument Name="queryOrderBy" Type="string" Required="No" Default="contactDateSent_d">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">

	<cfset var qry_selectContactList = QueryNew("blank")>
	<cfset var displayOr = False>
	<cfset var displayAnd = False>
	<cfset var queryParameters_orderBy = "">
	<cfset var queryParameters_orderBy_noTable = "">

	<cfswitch expression="#Arguments.queryOrderBy#">
	<cfcase value="contactID,contactReplyTo,contactFrom,contactTo,contactSubject,contactDateUpdated,contactDateSent"><cfset queryParameters_orderBy = "avContact.#Arguments.queryOrderBy#"></cfcase>
	<cfcase value="contactID_d,contactReplyTo_d,contactFrom_d,contactTo_d,contactSubject_d,contactDateUpdated_d,contactDateSent_d"><cfset queryParameters_orderBy = "avContact.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	<cfcase value="contactDateCreated"><cfset queryParameters_orderBy = "avContact.contactID"></cfcase>
	<cfcase value="contactDateCreated_d"><cfset queryParameters_orderBy = "avContact.contactID DESC"></cfcase>
	<cfcase value="contactID_custom"><cfset queryParameters_orderBy = "avContact.contactID_custom"></cfcase>
	<cfcase value="contactID_custom_d"><cfset queryParameters_orderBy = "avContact.contactID_custom DESC"></cfcase>
	<cfdefaultcase>
		<cfif Arguments.returnContactInfo is False>
			<cfset queryParameters_orderBy = "avContact.contactDateSent DESC">
		<cfelse>
			<cfswitch expression="#Arguments.queryOrderBy#">
			<cfcase value="authorLastName"><cfset queryParameters_orderBy = "AuthorUser.lastName, AuthorUser.firstName"><cfset queryParameters_orderBy_noTable = "AuthorUser.authorLastName, AuthorUser.authorFirstName"></cfcase>
			<cfcase value="authorLastName_d"><cfset queryParameters_orderBy = "AuthorUser.lastName DESC, AuthorUser.firstName DESC"><cfset queryParameters_orderBy_noTable = "AuthorUser.authorLastName DESC, AuthorUser.authorFirstName DESC"></cfcase>
			<cfcase value="authorCompanyName"><cfset queryParameters_orderBy = "AuthorCompany.companyName"><cfset queryParameters_orderBy_noTable = "AuthorCompany.authorCompanyName"></cfcase>
			<cfcase value="authorCompanyName_d"><cfset queryParameters_orderBy = "AuthorCompany.companyName DESC"><cfset queryParameters_orderBy_noTable = "AuthorCompany.authorCompanyName DESC"></cfcase>
			<cfcase value="targetLastName"><cfset queryParameters_orderBy = "TargetUser.lastName, TargetUser.firstName"><cfset queryParameters_orderBy_noTable = "TargetUser.targetLastName, TargetUser.targetFirstName"></cfcase>
			<cfcase value="targetLastName_d"><cfset queryParameters_orderBy = "TargetUser.lastName DESC, TargetUser.firstName DESC"><cfset queryParameters_orderBy_noTable = "TargetUser.targetLastName DESC, TargetUser.targetFirstName DESC"></cfcase>
			<cfcase value="targetCompanyName"><cfset queryParameters_orderBy = "TargetCompany.companyName"><cfset queryParameters_orderBy_noTable = "TargetCompany.targetCompanyName"></cfcase>
			<cfcase value="targetCompanyName_d"><cfset queryParameters_orderBy = "TargetCompany.companyName DESC"><cfset queryParameters_orderBy_noTable = "TargetCompany.targetCompanyName DESC"></cfcase>
			<cfdefaultcase><cfset queryParameters_orderBy = "avContact.contactDateSent DESC"></cfdefaultcase>
			</cfswitch>
		</cfif>
	</cfdefaultcase>
	</cfswitch>

	<cfif queryParameters_orderBy_noTable is "">
		<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	</cfif>
	<cfloop index="table" list="avContact,AuthorUser,AuthorCompany,TargetUser,TargetCompany">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectContactList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avContact.contactID
			<cfif Arguments.returnContactInfo is True>
				, avContact.companyID_author, avContact.userID_author, avContact.companyID_target, avContact.userID_target, avContact.primaryTargetID,
				avContact.targetID, avContact.contactSubject, avContact.contactHtml, avContact.contactFax, avContact.contactEmail,
				avContact.contactByCustomer, avContact.contactFromName, avContact.contactReplyTo, avContact.contactTo, avContact.contactCC,
				avContact.contactBCC, avContact.contactTopicID, avContact.contactTemplateID, avContact.contactID_custom, avContact.contactID_orig,
				avContact.contactReplied, avContact.contactStatus, avContact.contactDateSent, avContact.contactDateCreated, avContact.contactDateUpdated,
				avContact.primaryTargetID_partner, avContact.targetID_partner, avContact.userID_partner,
				AuthorUser.firstName AS authorFirstName, AuthorUser.lastName AS authorLastName, AuthorUser.userID_custom AS authorUserID_custom,
				AuthorCompany.companyName AS authorCompanyName, AuthorCompany.companyID_custom AS authorCompanyID_custom,
				TargetUser.firstName AS targetFirstName, TargetUser.lastName AS targetLastName, TargetUser.userID_custom AS targetUserID_custom,
				TargetCompany.companyName AS targetCompanyName, TargetCompany.companyID_custom AS targetCompanyID_custom,
				CASE avContact.primaryTargetID
				WHEN #Application.fn_GetPrimaryTargetID("productID")#
					THEN (SELECT productName FROM avProduct WHERE avProduct.productID = avContact.targetID)
				ELSE
					NULL
				END
				AS productName
			</cfif>
			<cfif Arguments.returnContactMessage is True>, avContact.contactMessage, avContact.contactHeader</cfif>
		FROM avContact
			<cfif Arguments.returnContactInfo is True>
				LEFT OUTER JOIN avUser AS AuthorUser ON avContact.userID_author = AuthorUser.userID
				LEFT OUTER JOIN avUser AS TargetUser ON avContact.userID_target = TargetUser.userID
				LEFT OUTER JOIN avCompany AS AuthorCompany ON avContact.companyID_author = AuthorCompany.companyID
				LEFT OUTER JOIN avCompany AS TargetCompany ON avContact.companyID_target = TargetCompany.companyID
			</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectContactList.cfm">
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectContactList>
</cffunction>

<cffunction Name="selectContactCount" Access="public" ReturnType="numeric" Hint="Select total number of contact management entries in list">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="contactID" Type="string" Required="No">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="companyID_target" Type="string" Required="No">
	<cfargument Name="userID_target" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="contactTemplateID" Type="string" Required="No">
	<cfargument Name="contactTopicID" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchTextType" Type="string" Required="No">
	<cfargument Name="searchEmail" Type="string" Required="No">
	<cfargument Name="searchEmailType" Type="string" Required="No">
	<cfargument Name="contactDateType" Type="string" Required="No">
	<cfargument Name="contactSubject" Type="string" Required="No">
	<cfargument Name="contactMessage" Type="string" Required="No">
	<cfargument Name="contactFromName" Type="string" Required="No">
	<cfargument Name="contactReplyTo" Type="string" Required="No">
	<cfargument Name="contactTo" Type="string" Required="No">
	<cfargument Name="contactCC" Type="string" Required="No">
	<cfargument Name="contactBCC" Type="string" Required="No">
	<cfargument Name="contactID_custom" Type="string" Required="No">
	<cfargument Name="contactID_orig" Type="string" Required="No">
	<cfargument Name="contactDateFrom" Type="date" Required="No">
	<cfargument Name="contactDateTo" Type="date" Required="No">
	<cfargument Name="contactDateCreated_from" Type="date" Required="No">
	<cfargument Name="contactDateCreated_to" Type="date" Required="No">
	<cfargument Name="contactDateUpdated_from" Type="date" Required="No">
	<cfargument Name="contactDateUpdated_to" Type="date" Required="No">
	<cfargument Name="contactDateSent_from" Type="date" Required="No">
	<cfargument Name="contactDateSent_to" Type="date" Required="No">
	<cfargument Name="contactByCustomer" Type="numeric" Required="No">
	<cfargument Name="contactIsSent" Type="numeric" Required="No">
	<cfargument Name="contactHasCustomID" Type="numeric" Required="No">
	<cfargument Name="contactIsReply" Type="numeric" Required="No">
	<cfargument Name="contactReplied" Type="numeric" Required="No">
	<cfargument Name="contactStatus" Type="numeric" Required="No">
	<cfargument Name="contactHtml" Type="numeric" Required="No">
	<cfargument Name="contactToMultiple" Type="numeric" Required="No">
	<cfargument Name="contactHasCC" Type="numeric" Required="No">
	<cfargument Name="contactHasBCC" Type="numeric" Required="No">
	<cfargument Name="contactEmail" Type="numeric" Required="No">
	<cfargument Name="contactFax" Type="numeric" Required="No">

	<cfset var qry_selectContactCount = QueryNew("blank")>
	<cfset var displayOr = False>
	<cfset var displayAnd = False>

	<cfquery Name="qry_selectContactCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(avContact.contactID) AS totalRecords
		FROM avContact
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectContactList.cfm">
	</cfquery>

	<cfreturn qry_selectContactCount.totalRecords>
</cffunction>

</cfcomponent>

