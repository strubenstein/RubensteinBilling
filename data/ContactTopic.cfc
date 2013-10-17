<cfcomponent DisplayName="ContactTopic" Hint="Manages inserting, updating, deleting and viewing contact management topics">

<cffunction name="maxlength_ContactTopic" access="public" output="no" returnType="struct">
	<cfset var maxlength_ContactTopic = StructNew()>

	<cfset maxlength_ContactTopic.contactTopicName = 100>
	<cfset maxlength_ContactTopic.contactTopicTitle = 100>
	<cfset maxlength_ContactTopic.contactTopicEmail = 255>
	<cfset maxlength_ContactTopic.languageID = 5>

	<cfreturn maxlength_ContactTopic>
</cffunction>

<cffunction Name="insertContactTopic" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new contact management topic. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="contactTopicName" Type="string" Required="Yes">
	<cfargument Name="contactTopicTitle" Type="string" Required="Yes">
	<cfargument Name="contactTopicOrder" Type="numeric" Required="No" Default="1">
	<cfargument Name="contactTopicStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="contactTopicEmail" Type="string" Required="No" Default="">

	<cfinvoke component="#Application.billingMapping#data.ContentTopic" method="maxlength_ContactTopic" returnVariable="maxlength_ContactTopic" />

	<cfquery Name="qry_insertContactTopic" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avContactTopic
		(
			companyID, userID, languageID, contactTopicName, contactTopicTitle, contactTopicOrder,
			contactTopicStatus, contactTopicEmail, contactTopicDateCreated, contactTopicDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTopic.languageID#">,
			<cfqueryparam Value="#Arguments.contactTopicName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTopic.contactTopicName#">,
			<cfqueryparam Value="#Arguments.contactTopicTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTopic.contactTopicTitle#">,
			<cfqueryparam Value="#Arguments.contactTopicOrder#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.contactTopicStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contactTopicEmail#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTopic.contactTopicEmail#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateContactTopic" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing contact management topic. Returns True.">
	<cfargument Name="contactTopicID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="contactTopicName" Type="string" Required="No">
	<cfargument Name="contactTopicTitle" Type="string" Required="No">
	<cfargument Name="contactTopicOrder" Type="numeric" Required="No">
	<cfargument Name="contactTopicStatus" Type="numeric" Required="No">
	<cfargument Name="contactTopicEmail" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.ContentTopic" method="maxlength_ContactTopic" returnVariable="maxlength_ContactTopic" />

	<cfquery Name="qry_updateContactTopic" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContactTopic
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTopicName")>contactTopicName = <cfqueryparam Value="#Arguments.contactTopicName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTopic.contactTopicName#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTopicTitle")>contactTopicTitle = <cfqueryparam Value="#Arguments.contactTopicTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTopic.contactTopicTitle#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTopicOrder") and Application.fn_IsIntegerNonNegative(Arguments.contactTopicOrder)>contactTopicOrder = <cfqueryparam Value="#Arguments.contactTopicOrder#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTopicStatus") and ListFind("0,1", Arguments.contactTopicStatus)>contactTopicStatus = <cfqueryparam Value="#Arguments.contactTopicStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTopicEmail")>contactTopicEmail = <cfqueryparam Value="#Arguments.contactTopicEmail#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTopic.contactTopicEmail#">,</cfif>
			contactTopicDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE contactTopicID = <cfqueryparam Value="#Arguments.contactTopicID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateContactTopicOrder" Access="public" Output="No" ReturnType="boolean" Hint="Increment order of existing contact management topic when inserting new topic. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contactTopicOrder" Type="numeric" Required="Yes">

	<cfquery Name="qry_updateContactTopicOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContactTopic
		SET contactTopicOrder = contactTopicOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND contactTopicOrder >= <cfqueryparam Value="#Arguments.contactTopicOrder#" cfsqltype="cf_sql_tinyint">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectContactTopic" Access="public" Output="No" ReturnType="query" Hint="Select existing contact management topic.">
	<cfargument Name="contactTopicID" Type="numeric" Required="Yes">

	<cfset var qry_selectContactTopic = QueryNew("blank")>

	<cfquery Name="qry_selectContactTopic" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID, userID, languageID, contactTopicName, contactTopicTitle, contactTopicOrder,
			contactTopicStatus, contactTopicEmail, contactTopicDateCreated, contactTopicDateUpdated
		FROM avContactTopic
		WHERE contactTopicID = <cfqueryparam Value="#Arguments.contactTopicID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectContactTopic>
</cffunction>

<cffunction Name="checkContactTopicPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that company has permission for existing contact management topic.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contactTopicID" Type="numeric" Required="Yes">

	<cfset var qry_checkContactTopicPermission = QueryNew("blank")>

	<cfquery Name="qry_checkContactTopicPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID
		FROM avContactTopic
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND contactTopicID = <cfqueryparam Value="#Arguments.contactTopicID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkContactTopicPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="switchContactTopicOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing contact management topics">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contactTopicID" Type="numeric" Required="Yes">
	<cfargument Name="contactTopicOrder_direction" Type="string" Required="Yes">

	<cfquery Name="qry_switchContactTopicOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContactTopic
		SET contactTopicOrder = contactTopicOrder 
			<cfif Arguments.contactTopicOrder_direction is "moveContactTopicDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE contactTopicID = <cfqueryparam Value="#Arguments.contactTopicID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avContactTopic INNER JOIN avContactTopic AS avContactTopic2
			SET avContactTopic.contactTopicOrder = avContactTopic.contactTopicOrder 
				<cfif Arguments.contactTopicOrder_direction is "moveContactTopicDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avContactTopic.contactTopicOrder = avContactTopic2.contactTopicOrder
				AND avContactTopic.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND avContactTopic.contactTopicID <> <cfqueryparam Value="#Arguments.contactTopicID#" cfsqltype="cf_sql_integer">
				AND avContactTopic2.contactTopicID = <cfqueryparam Value="#Arguments.contactTopicID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avContactTopic
			SET contactTopicOrder = contactTopicOrder 
				<cfif Arguments.contactTopicOrder_direction is "moveContactTopicDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND contactTopicID <> <cfqueryparam Value="#Arguments.contactTopicID#" cfsqltype="cf_sql_integer">
				AND contactTopicOrder = 
					(
					SELECT contactTopicOrder
					FROM avContactTopic
					WHERE contactTopicID = <cfqueryparam Value="#Arguments.contactTopicID#" cfsqltype="cf_sql_integer">
					);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectContactTopicList" Access="public" Output="No" ReturnType="query" Hint="Select existing contact management topic.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contactTopicStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="languageID" Type="string" Required="No">

	<cfset var qry_selectContactTopicList = QueryNew("blank")>

	<cfquery Name="qry_selectContactTopicList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contactTopicID, companyID, userID,  languageID,
			contactTopicName, contactTopicTitle,
			contactTopicOrder, contactTopicStatus,
			contactTopicEmail, contactTopicDateCreated,
			contactTopicDateUpdated
		FROM avContactTopic
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "contactTopicStatus") and ListFind("0,1", Arguments.contactTopicStatus)>
				AND contactTopicStatus = <cfqueryparam Value="#Arguments.contactTopicStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "languageID")>
				AND languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">
			</cfif>
		ORDER BY languageID, contactTopicOrder
	</cfquery>

	<cfreturn qry_selectContactTopicList>
</cffunction>

</cfcomponent>

