<cfcomponent DisplayName="SubscriptionNotify" Hint="Manages which customer users to notify for each subscriber">

<!--- Subscriber Notification --->
<cffunction Name="insertSubscriberNotify" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new subscriber notification option. Returns True.">
	<cfargument Name="subscriberID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID_cancel" Type="numeric" Required="No" Default="0">
	<cfargument Name="addressID" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberNotifyStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="subscriberNotifyEmail" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberNotifyEmailHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberNotifyPdf" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberNotifyDoc" Type="numeric" Required="No" Default="0">
	<cfargument Name="phoneID" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_insertSubscriberNotify" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avSubscriberNotify
		(
			subscriberID, userID, userID_author, userID_cancel, addressID, subscriberNotifyStatus,
			subscriberNotifyEmail, subscriberNotifyEmailHtml, subscriberNotifyPdf, subscriberNotifyDoc,
			phoneID, subscriberNotifyDateCreated, subscriberNotifyDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_cancel#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriberNotifyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriberNotifyEmail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriberNotifyEmailHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriberNotifyPdf#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriberNotifyDoc#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.phoneID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateSubscriberNotify" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing subscriber notification option. Returns True.">
	<cfargument Name="subscriberID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="userID_cancel" Type="numeric" Required="No">
	<cfargument Name="addressID" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmail" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmailHtml" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyPdf" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyDoc" Type="numeric" Required="No">
	<cfargument Name="phoneID" Type="numeric" Required="No">

	<cfquery Name="qry_updateSubscriberNotify" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avSubscriberNotify
		SET
			<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "addressID") and Application.fn_IsIntegerNonNegative(Arguments.addressID)>addressID = <cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberNotifyEmail") and ListFind("0,1", Arguments.subscriberNotifyEmail)>subscriberNotifyEmail = <cfqueryparam Value="#Arguments.subscriberNotifyEmail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberNotifyEmailHtml") and ListFind("0,1", Arguments.subscriberNotifyEmailHtml)>subscriberNotifyEmailHtml = <cfqueryparam Value="#Arguments.subscriberNotifyEmailHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberNotifyPdf") and ListFind("0,1", Arguments.subscriberNotifyPdf)>subscriberNotifyPdf = <cfqueryparam Value="#Arguments.subscriberNotifyPdf#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberNotifyDoc") and ListFind("0,1", Arguments.subscriberNotifyDoc)>subscriberNotifyDoc = <cfqueryparam Value="#Arguments.subscriberNotifyDoc#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "phoneID") and Application.fn_IsIntegerNonNegative(Arguments.phoneID)>phoneID = <cfqueryparam Value="#Arguments.phoneID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "userID_cancel") and Application.fn_IsIntegerNonNegative(Arguments.userID_cancel)>userID_cancel = <cfqueryparam Value="#Arguments.userID_cancel#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberNotifyStatus") and ListFind("0,1", Arguments.subscriberNotifyStatus)>subscriberNotifyStatus = <cfqueryparam Value="#Arguments.subscriberNotifyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			subscriberNotifyDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">
			AND userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectSubscriberNotifyList" Access="public" Output="No" ReturnType="query" Hint="Select existing subscribers to notify">
	<cfargument Name="subscriberID" Type="string" Required="Yes">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="addressID" Type="string" Required="No">
	<cfargument Name="subscriberNotifyStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmail" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmailHtml" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyPdf" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyDoc" Type="numeric" Required="No">
	<cfargument Name="phoneID" Type="numeric" Required="No">

	<cfset var qry_selectSubscriberNotifyList = QueryNew("blank")>

	<cfquery Name="qry_selectSubscriberNotifyList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avSubscriberNotify.subscriberID, avSubscriberNotify.userID, avSubscriberNotify.userID_author,
			avSubscriberNotify.userID_cancel, avSubscriberNotify.addressID, avSubscriberNotify.subscriberNotifyStatus,
			avSubscriberNotify.subscriberNotifyEmail, avSubscriberNotify.subscriberNotifyEmailHtml,
			avSubscriberNotify.subscriberNotifyPdf, avSubscriberNotify.subscriberNotifyDoc, avSubscriberNotify.phoneID,
			avSubscriberNotify.subscriberNotifyDateCreated, avSubscriberNotify.subscriberNotifyDateUpdated,
			avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom, avUser.suffix,
			avUser.salutation, avUser.jobTitle, avUser.jobDepartment, avUser.jobDivision,
			avAddress.addressName, avAddress.addressDescription, avAddress.addressTypeShipping, avAddress.addressTypeBilling,
			avAddress.address, avAddress.address2, avAddress.address3, avAddress.city, avAddress.state, avAddress.zipCode,
			avAddress.zipCodePlus4, avAddress.county, avAddress.country,
			avPhone.phoneAreaCode, avPhone.phoneNumber, avPhone.phoneStatus, avPhone.phoneType, avPhone.phoneDescription
		FROM avSubscriberNotify INNER JOIN avUser ON avSubscriberNotify.userID = avUser.userID
			LEFT OUTER JOIN avAddress ON avSubscriberNotify.addressID = avAddress.addressID
			LEFT OUTER JOIN avPhone ON avSubscriberNotify.phoneID = avPhone.phoneID
		WHERE avSubscriberNotify.subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				AND avSubscriberNotify.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "addressID")>
				<cfif Arguments.addressID is 0>
					AND avSubscriberNotify.addressID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
				<cfelseif Arguments.addressID is -1>
					AND avSubscriberNotify.addressID <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
				<cfelseif Application.fn_IsIntegerList(Arguments.addressID)>
					AND avSubscriberNotify.addressID IN (<cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfif>
			<cfif StructKeyExists(Arguments, "phoneID")>
				<cfif Arguments.phoneID is 0>
					AND avSubscriberNotify.phoneID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
				<cfelseif Arguments.phoneID is -1>
					AND avSubscriberNotify.phoneID <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
				<cfelseif Application.fn_IsIntegerList(Arguments.phoneID)>
					AND avSubscriberNotify.phoneID IN (<cfqueryparam Value="#Arguments.phoneID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfif>
			<cfloop Index="field" List="subscriberNotifyStatus,subscriberNotifyEmail,subscriberNotifyEmailHtml,subscriberNotifyPdf,subscriberNotifyDoc">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND avSubscriberNotify.#field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
		ORDER BY avSubscriberNotify.subscriberID, avSubscriberNotify.subscriberNotifyStatus DESC, avUser.lastName, avUser.firstName
	</cfquery>

	<cfreturn qry_selectSubscriberNotifyList>
</cffunction>

</cfcomponent>
