<cfcomponent DisplayName="ContactTemplate" Hint="Manages inserting, updating, deleting and viewing contact management templates">

<cffunction name="maxlength_ContactTemplate" access="public" output="no" returnType="struct">
	<cfset var maxlength_ContactTemplate = StructNew()>

	<cfset maxlength_ContactTemplate.contactTemplateName = 100>
	<cfset maxlength_ContactTemplate.contactTemplateFromName = 100>
	<cfset maxlength_ContactTemplate.contactTemplateReplyTo = 100>
	<cfset maxlength_ContactTemplate.contactTemplateCC = 255>
	<cfset maxlength_ContactTemplate.contactTemplateBCC = 255>
	<cfset maxlength_ContactTemplate.contactTemplateSubject = 100>

	<cfreturn maxlength_ContactTemplate>
</cffunction>

<cffunction Name="insertContactTemplate" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new contact management template. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="contactTemplateName" Type="string" Required="Yes">
	<cfargument Name="contactTemplateHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="contactTemplateFromName" Type="string" Required="Yes">
	<cfargument Name="contactTemplateReplyTo" Type="string" Required="Yes">
	<cfargument Name="contactTemplateCC" Type="string" Required="No" Default="">
	<cfargument Name="contactTemplateBCC" Type="string" Required="No" Default="">
	<cfargument Name="contactTemplateSubject" Type="string" Required="Yes">
	<cfargument Name="contactTemplateMessage" Type="string" Required="Yes">
	<cfargument Name="contactTemplateStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="contactTemplateOrder" Type="numeric" Required="No" Default="0">

	<cfinvoke component="#Application.billingMapping#data.ContactTemplate" method="maxlength_ContactTemplate" returnVariable="maxlength_ContactTemplate" />

	<cfquery Name="qry_insertContactTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avContactTemplate
		(
			companyID, userID, primaryTargetID, contactTemplateName, contactTemplateHtml, contactTemplateFromName,
			contactTemplateReplyTo, contactTemplateCC, contactTemplateBCC, contactTemplateSubject, contactTemplateMessage,
			 contactTemplateStatus, contactTemplateOrder, contactTemplateDateCreated, contactTemplateDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.contactTemplateName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateName#">,
			<cfqueryparam Value="#Arguments.contactTemplateHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contactTemplateFromName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateFromName#">,
			<cfqueryparam Value="#Arguments.contactTemplateReplyTo#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateReplyTo#">,
			<cfqueryparam Value="#Arguments.contactTemplateCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateCC#">,
			<cfqueryparam Value="#Arguments.contactTemplateBCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateBCC#">,
			<cfqueryparam Value="#Arguments.contactTemplateSubject#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateSubject#">,
			<cfqueryparam Value="#Arguments.contactTemplateMessage#" cfsqltype="cf_sql_longvarchar">,
			<cfqueryparam Value="#Arguments.contactTemplateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contactTemplateOrder#" cfsqltype="cf_sql_smallint">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateContactTemplate" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing contact management template. Returns True.">
	<cfargument Name="contactTemplateID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="contactTemplateName" Type="string" Required="No">
	<cfargument Name="contactTemplateHtml" Type="numeric" Required="No">
	<cfargument Name="contactTemplateFromName" Type="string" Required="No">
	<cfargument Name="contactTemplateReplyTo" Type="string" Required="No">
	<cfargument Name="contactTemplateCC" Type="string" Required="No">
	<cfargument Name="contactTemplateBCC" Type="string" Required="No">
	<cfargument Name="contactTemplateSubject" Type="string" Required="No">
	<cfargument Name="contactTemplateMessage" Type="string" Required="No">
	<cfargument Name="contactTemplateStatus" Type="numeric" Required="No">
	<cfargument Name="contactTemplateOrder" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.ContactTemplate" method="maxlength_ContactTemplate" returnVariable="maxlength_ContactTemplate" />

	<cfquery Name="qry_updateContactTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContactTemplate
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerNonNegative(Arguments.primaryTargetID)>primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateName")>contactTemplateName = <cfqueryparam Value="#Arguments.contactTemplateName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateName#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateHtml") and ListFind("0,1", Arguments.contactTemplateHtml)>contactTemplateHtml = <cfqueryparam Value="#Arguments.contactTemplateHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateFromName")>contactTemplateFromName = <cfqueryparam Value="#Arguments.contactTemplateFromName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateFromName#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateReplyTo")>contactTemplateReplyTo = <cfqueryparam Value="#Arguments.contactTemplateReplyTo#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateReplyTo#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateCC")>contactTemplateCC = <cfqueryparam Value="#Arguments.contactTemplateCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateCC#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateBCC")>contactTemplateBCC = <cfqueryparam Value="#Arguments.contactTemplateBCC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateBCC#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateSubject")>contactTemplateSubject = <cfqueryparam Value="#Arguments.contactTemplateSubject#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContactTemplate.contactTemplateSubject#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateMessage")>contactTemplateMessage = <cfqueryparam Value="#Arguments.contactTemplateMessage#" cfsqltype="cf_sql_longvarchar">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateStatus") and ListFind("0,1", Arguments.contactTemplateStatus)>contactTemplateStatus = <cfqueryparam Value="#Arguments.contactTemplateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateOrder") and Application.fn_IsIntegerNonNegative(Arguments.contactTemplateOrder)>contactTemplateOrder = <cfqueryparam Value="#Arguments.contactTemplateOrder#" cfsqltype="cf_sql_smallint">,</cfif>
			contactTemplateDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE contactTemplateID = <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkContactTemplateNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check whether contact management template name is unique for that target type.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contactTemplateName" Type="string" Required="Yes">
	<cfargument Name="contactTemplateID" Type="numeric" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">

	<cfset var qry_checkContactTemplateNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkContactTemplateNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contactTemplateID
		FROM avContactTemplate
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND contactTemplateName = <cfqueryparam Value="#Arguments.contactTemplateName#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerNonNegative(Arguments.primaryTargetID)>
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateID") and Application.fn_IsIntegerNonNegative(Arguments.contactTemplateID)>
				AND contactTemplateID <> <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkContactTemplateNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectMaxContactTemplateOrder" Access="public" Output="No" ReturnType="numeric" Hint="Select maximum order of contact management template.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">

	<cfset var qry_selectMaxContactTemplateOrder = QueryNew("blank")>

	<cfquery Name="qry_selectMaxContactTemplateOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Max(contactTemplateOrder) AS maxContactTemplateOrder
		FROM avContactTemplate
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerNonNegative(Arguments.primaryTargetID)>
				AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_selectMaxContactTemplateOrder.RecordCount is 0 or Not IsNumeric(qry_selectMaxContactTemplateOrder.maxContactTemplateOrder)>
		<cfreturn 0>
	<cfelse>
		<cfreturn qry_selectMaxContactTemplateOrder.maxContactTemplateOrder>
	</cfif>
</cffunction>

<cffunction Name="selectContactTemplate" Access="public" Output="No" ReturnType="query" Hint="Select existing contact management template.">
	<cfargument Name="contactTemplateID" Type="numeric" Required="Yes">

	<cfset var qry_selectContactTemplate = QueryNew("blank")>

	<cfquery Name="qry_selectContactTemplate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID, userID, primaryTargetID, contactTemplateName, contactTemplateHtml, contactTemplateSubject, contactTemplateFromName,
			contactTemplateReplyTo, contactTemplateCC, contactTemplateBCC, contactTemplateMessage, contactTemplateStatus, contactTemplateOrder,
			contactTemplateDateCreated, contactTemplateDateUpdated
		FROM avContactTemplate
		WHERE contactTemplateID = <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectContactTemplate>
</cffunction>

<cffunction Name="checkContactTemplatePermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that company has permission for existing contact management template.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contactTemplateID" Type="numeric" Required="Yes">

	<cfset var qry_checkContactTemplatePermission = QueryNew("blank")>

	<cfquery Name="qry_checkContactTemplatePermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID
		FROM avContactTemplate
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND contactTemplateID = <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkContactTemplatePermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectContactTemplateList" Access="public" Output="No" ReturnType="query" Hint="Select existing contact management templates.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contactTemplateStatus" Type="numeric" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="returnContactTemplateMessage" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectContactTemplateList = QueryNew("blank")>

	<cfquery Name="qry_selectContactTemplateList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contactTemplateID, companyID, userID, primaryTargetID, contactTemplateName, contactTemplateHtml, contactTemplateFromName,
			contactTemplateReplyTo, contactTemplateCC, contactTemplateBCC, contactTemplateSubject, contactTemplateStatus, contactTemplateOrder,
			contactTemplateDateCreated, contactTemplateDateUpdated
			<cfif Arguments.returnContactTemplateMessage is True>, contactTemplateMessage</cfif>
		FROM avContactTemplate
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID)>
				AND primaryTargetID IN (<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "contactTemplateStatus") and ListFind("0,1", Arguments.contactTemplateStatus)>
				AND contactTemplateStatus = <cfqueryparam Value="#Arguments.contactTemplateStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY primaryTargetID, contactTemplateOrder, contactTemplateName
	</cfquery>

	<cfreturn qry_selectContactTemplateList>
</cffunction>

<cffunction Name="updateContactTemplateOrder" Access="public" Output="No" ReturnType="boolean" Hint="Increment or decrement order of existing contact management templates. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="contactTemplateID" Type="numeric" Required="No">
	<cfargument Name="contactTemplateOrder" Type="numeric" Required="Yes">
	<cfargument Name="contactTemplateOrder_direction" Type="string" Required="No" Default="down">

	<cfquery Name="qry_updateContactTemplateOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContactTemplate
		SET contactTemplateOrder = contactTemplateOrder
			<cfif Arguments.contactTemplateOrder_direction is "up"> - <cfelse> + </cfif>
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "contactTemplateID") and Application.fn_IsIntegerNonNegative(Arguments.contactTemplateID)>
				AND contactTemplateID <> <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">
			</cfif>
			AND contactTemplateOrder >= <cfqueryparam Value="#Arguments.contactTemplateOrder#" cfsqltype="cf_sql_smallint">
	</cfquery>
	<cfreturn True>
</cffunction>

<cffunction Name="switchContactTemplateOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing contact management templates">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="contactTemplateID" Type="numeric" Required="Yes">
	<cfargument Name="contactTemplateOrder_direction" Type="string" Required="Yes">

	<cfquery Name="qry_switchContactTemplateOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContactTemplate
		SET contactTemplateOrder = contactTemplateOrder 
			<cfif Arguments.contactTemplateOrder_direction is "moveContactTemplateDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE contactTemplateID = <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avContactTemplate INNER JOIN avContactTemplate AS avContactTemplate2
			SET avContactTemplate.contactTemplateOrder = avContactTemplate.contactTemplateOrder 
				<cfif Arguments.contactTemplateOrder_direction is "moveContactTemplateDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avContactTemplate.contactTemplateOrder = avContactTemplate2.contactTemplateOrder
				AND avContactTemplate.primaryTargetID = avContactTemplate2.primaryTargetID
				AND avContactTemplate.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND avContactTemplate.contactTemplateID <> <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">
				AND avContactTemplate2.contactTemplateID = <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avContactTemplate
			SET contactTemplateOrder = contactTemplateOrder 
				<cfif Arguments.contactTemplateOrder_direction is "moveContactTemplateDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND contactTemplateID <> <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">
				AND primaryTargetID = 
					(
					SELECT primaryTargetID
					FROM avContactTemplate
					WHERE contactTemplateID = <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">
					)
				AND contactTemplateOrder = 
					(
					SELECT contactTemplateOrder
					FROM avContactTemplate
					WHERE contactTemplateID = <cfqueryparam Value="#Arguments.contactTemplateID#" cfsqltype="cf_sql_integer">
					);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>

