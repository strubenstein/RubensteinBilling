<cfcomponent DisplayName="CommissionCustomer" Hint="Manages commissions that apply to salesperson/customers">

<cffunction name="maxlength_CommissionCustomer" access="public" output="no" returnType="struct">
	<cfset var maxlength_CommissionCustomer = StructNew()>

	<cfset maxlength_CommissionCustomer.commissionCustomerPercent = 4>
	<cfset maxlength_CommissionCustomer.commissionCustomerDescription = 255>

	<cfreturn maxlength_CommissionCustomer>
</cffunction>

<!--- CommissionCustomer for matching salesperson/customer relations --->
<cffunction Name="insertCommissionCustomer" Access="public" Output="no" ReturnType="boolean" Hint="Inserts new relation where salespersons receive commission for customer. Returns True.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="string" Required="No" Default="">
	<cfargument Name="subscriberID" Type="string" Required="No" Default="">
	<cfargument Name="commissionCustomerPercent" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionCustomerDateBegin" Type="string" Required="No" Default="">
	<cfargument Name="commissionCustomerDateEnd" Type="string" Required="No" Default="">
	<cfargument Name="commissionCustomerStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="commissionCustomerPrimary" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionCustomerDescription" Type="string" Required="No" Default="">

	<cfset var qry_insertCommissionCustomer = QueryNew("blank")>

	<cfif Not IsDate(Arguments.commissionCustomerDateBegin)>
		<cfset Arguments.commissionCustomerDateBegin = Now()>
	</cfif>

	<cfif ListFind(Arguments.userID, 0) or Not Application.fn_IsIntegerList(Arguments.userID)>
		<cfset Arguments.commissionCustomerAllUsers = 1>
	<cfelse>
		<cfset Arguments.commissionCustomerAllUsers = 0>
	</cfif>

	<cfif ListFind(Arguments.subscriberID, 0) or Not Application.fn_IsIntegerList(Arguments.subscriberID)>
		<cfset Arguments.commissionCustomerAllSubscribers = 1>
	<cfelse>
		<cfset Arguments.commissionCustomerAllSubscribers = 0>
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.CommissionCustomer" method="maxlength_CommissionCustomer" returnVariable="maxlength_CommissionCustomer" />

	<cftransaction>
	<cfquery Name="qry_insertCommissionCustomer" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCommissionCustomer
		(
			companyID_author, userID_author, primaryTargetID, targetID, companyID, commissionCustomerAllUsers, commissionCustomerAllSubscribers,
			commissionCustomerPercent, commissionCustomerDateBegin, commissionCustomerDateEnd, commissionCustomerStatus,
			commissionCustomerPrimary, commissionCustomerDescription, commissionCustomerDateCreated, commissionCustomerDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.commissionCustomerAllUsers#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionCustomerAllSubscribers#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionCustomerPercent#" cfsqltype="cf_sql_decimal" Scale="#maxlength_CommissionCustomer.commissionCustomerPercent#">,
			<cfqueryparam Value="#CreateODBCDateTime(CreateDateTime(Year(Arguments.commissionCustomerDateBegin), Month(Arguments.commissionCustomerDateBegin), Day(Arguments.commissionCustomerDateBegin), 00, 00, 00))#" cfsqltype="cf_sql_timestamp">,
			<cfif Not IsDate(Arguments.commissionCustomerDateEnd)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(CreateDateTime(Year(Arguments.commissionCustomerDateEnd), Month(Arguments.commissionCustomerDateEnd), Day(Form.commissionCustomerDateEnd), 23, 59, 00))#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.commissionCustomerStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionCustomerPrimary#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionCustomerDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CommissionCustomer.commissionCustomerDescription#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "commissionCustomerID", "ALL")#;
	</cfquery>

	<cfif Arguments.commissionCustomerAllUsers is 0>
		<cfquery Name="qry_insertCommissionCustomerUser" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfloop Index="theUserID" List="#Arguments.userID#">
				INSERT INTO avCommissionCustomerUser (commissionCustomerID, userID)
				VALUES
				(
					<cfqueryparam Value="#qry_insertCommissionCustomer.primaryKeyID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#theUserID#" cfsqltype="cf_sql_integer">
				);
			</cfloop>
		</cfquery>
	</cfif>

	<cfif Arguments.commissionCustomerAllSubscribers is 0>
		<cfquery Name="qry_insertCommissionCustomerSubscriber" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfloop Index="theSubscriberID" List="#Arguments.subscriberID#">
				INSERT INTO avCommissionCustomerSubscriber (commissionCustomerID, subscriberID)
				VALUES
				(
					<cfqueryparam Value="#qry_insertCommissionCustomer.primaryKeyID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#theSubscriberID#" cfsqltype="cf_sql_integer">
				);
			</cfloop>
		</cfquery>
	</cfif>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="updateCommissionCustomer" Access="public" Output="no" ReturnType="boolean" Hint="Updates existing relation where salesperson receives commission for customer. Returns True.">
	<cfargument Name="commissionCustomerID" Type="string" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="commissionCustomerPercent" Type="numeric" Required="No">
	<cfargument Name="commissionCustomerDateBegin" Type="string" Required="No">
	<cfargument Name="commissionCustomerDateEnd" Type="string" Required="No">
	<cfargument Name="commissionCustomerStatus" Type="numeric" Required="No">
	<cfargument Name="commissionCustomerPrimary" Type="numeric" Required="No">
	<cfargument Name="commissionCustomerDescription" Type="string" Required="No">

	<cfif Not Application.fn_IsIntegerList(Arguments.commissionCustomerID)>
		<cfreturn False>
	<cfelse>
		<cfinvoke component="#Application.billingMapping#data.CommissionCustomer" method="maxlength_CommissionCustomer" returnVariable="maxlength_CommissionCustomer" />

		<cfquery Name="qry_updateCommissionCustomer" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avCommissionCustomer
			SET
				<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,</cfif>
				<cfif StructKeyExists(Arguments, "commissionCustomerPercent") and IsNumeric(Arguments.commissionCustomerPercent)>commissionCustomerPercent = <cfqueryparam Value="#Arguments.commissionCustomerPercent#" cfsqltype="cf_sql_decimal" Scale="#maxlength_CommissionCustomer.commissionCustomerPercent#">,</cfif>
				<cfif StructKeyExists(Arguments, "commissionCustomerPrimary") and ListFind("0,1", Arguments.commissionCustomerPrimary)>commissionCustomerPrimary = <cfqueryparam Value="#Arguments.commissionCustomerPrimary#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
				<cfif StructKeyExists(Arguments, "commissionCustomerStatus") and ListFind("0,1", Arguments.commissionCustomerStatus)>commissionCustomerStatus = <cfqueryparam Value="#Arguments.commissionCustomerStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
				<cfif StructKeyExists(Arguments, "commissionCustomerDateBegin") and IsDate(Arguments.commissionCustomerDateBegin)>commissionCustomerDateBegin = <cfqueryparam Value="#CreateODBCDateTime(Arguments.commissionCustomerDateBegin)#" cfsqltype="cf_sql_timestamp">,</cfif>
				<cfif StructKeyExists(Arguments, "commissionCustomerDateEnd") and Arguments.commissionCustomerDateEnd is "">commissionCustomerDateEnd = NULL,<cfelseif StructKeyExists(Arguments, "commissionCustomerDateEnd") and IsDate(Arguments.commissionCustomerDateEnd)>commissionCustomerDateEnd = <cfqueryparam Value="#CreateODBCDateTime(Arguments.commissionCustomerDateEnd)#" cfsqltype="cf_sql_timestamp">,</cfif>
				<cfif StructKeyExists(Arguments, "commissionCustomerDescription")>commissionCustomerDescription = <cfqueryparam Value="#Arguments.commissionCustomerDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CommissionCustomer.commissionCustomerDescription#">,</cfif>
				commissionCustomerDateUpdated = #Application.billingSql.sql_nowDateTime#
			WHERE commissionCustomerID IN (<cfqueryparam Value="#Arguments.commissionCustomerID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectCommissionCustomer" Access="public" Output="no" ReturnType="query" Hint="Selects existing salesperson/customer commission relation.">
	<cfargument Name="commissionCustomerID" Type="string" Required="Yes">

	<cfset var qry_selectCommissionCustomer = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.commissionCustomerID)>
		<cfset Arguments.commissionCustomerID = 0>
	</cfif>

	<cfquery Name="qry_selectCommissionCustomer" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT commissionCustomerID, companyID_author, userID_author, primaryTargetID, targetID, companyID,
			commissionCustomerAllUsers, commissionCustomerAllSubscribers, commissionCustomerPercent,
			commissionCustomerDateBegin, commissionCustomerDateEnd, commissionCustomerStatus,
			commissionCustomerPrimary, commissionCustomerDescription, commissionCustomerDateCreated,
			commissionCustomerDateUpdated
		FROM avCommissionCustomer
		WHERE commissionCustomerID IN (<cfqueryparam Value="#Arguments.commissionCustomerID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectCommissionCustomer>
</cffunction>

<cffunction Name="selectCommissionCustomerUser" Access="public" Output="no" ReturnType="query" Hint="Selects users for existing salesperson/customer commission relation.">
	<cfargument Name="commissionCustomerID" Type="string" Required="Yes">

	<cfset var qry_selectCommissionCustomerUser = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.commissionCustomerID)>
		<cfset Arguments.commissionCustomerID = 0>
	</cfif>

	<cfquery Name="qry_selectCommissionCustomerUser" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avCommissionCustomerUser.commissionCustomerID, avCommissionCustomerUser.userID,
			avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avCommissionCustomerUser, avUser
		WHERE avCommissionCustomerUser.userID = avUser.userID
			AND avCommissionCustomerUser.commissionCustomerID IN (<cfqueryparam Value="#Arguments.commissionCustomerID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		ORDER BY avCommissionCustomerUser.commissionCustomerID, avUser.lastName, avUser.firstName
	</cfquery>

	<cfreturn qry_selectCommissionCustomerUser>
</cffunction>

<cffunction Name="selectCommissionCustomerSubscriber" Access="public" Output="no" ReturnType="query" Hint="Selects subscribers for existing salesperson/customer commission relation.">
	<cfargument Name="commissionCustomerID" Type="string" Required="Yes">

	<cfset var qry_selectCommissionCustomerSubscriber = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.commissionCustomerID)>
		<cfset Arguments.commissionCustomerID = 0>
	</cfif>

	<cfquery Name="qry_selectCommissionCustomerSubscriber" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avCommissionCustomerSubscriber.commissionCustomerID, avCommissionCustomerSubscriber.subscriberID,
			avSubscriber.subscriberName, avSubscriber.subscriberID_custom
		FROM avCommissionCustomerSubscriber, avSubscriber
		WHERE avCommissionCustomerSubscriber.subscriberID = avSubscriber.subscriberID
			AND avCommissionCustomerSubscriber.commissionCustomerID IN (<cfqueryparam Value="#Arguments.commissionCustomerID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		ORDER BY avCommissionCustomerSubscriber.commissionCustomerID, avSubscriber.subscriberName
	</cfquery>

	<cfreturn qry_selectCommissionCustomerSubscriber>
</cffunction>

<cffunction Name="selectCommissionCustomerList" Access="public" Output="no" ReturnType="query" Hint="Selects existing salesperson/customer commission relations.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="commissionCustomerID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="commissionCustomerStatus" Type="numeric" Required="No">
	<cfargument Name="commissionCustomerPrimary" Type="numeric" Required="No">
	<cfargument Name="commissionCustomerPercent" Type="numeric" Required="No">
	<cfargument Name="commissionCustomerPercent_min" Type="numeric" Required="No">
	<cfargument Name="commissionCustomerPercent_max" Type="numeric" Required="No">
	<cfargument Name="commissionCustomerDescription" Type="string" Required="No">
	<cfargument Name="commissionCustomerDateBegin_from" Type="date" Required="No">
	<cfargument Name="commissionCustomerDateBegin_to" Type="date" Required="No">
	<cfargument Name="commissionCustomerDateEnd_from" Type="date" Required="No">
	<cfargument Name="commissionCustomerDateEnd_to" Type="date" Required="No">
	<cfargument Name="commissionCustomerDateEndIsNull" Type="numeric" Required="No">
	<cfargument Name="commissionCustomerDate" Type="date" Required="No">

	<cfset var qry_selectCommissionCustomerList = QueryNew("blank")>

	<cfquery Name="qry_selectCommissionCustomerList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avCommissionCustomer.commissionCustomerID, avCommissionCustomer.companyID_author, avCommissionCustomer.userID_author,
			avCommissionCustomer.primaryTargetID, avCommissionCustomer.targetID, avCommissionCustomer.companyID,
			avCommissionCustomer.commissionCustomerAllUsers, avCommissionCustomer.commissionCustomerAllSubscribers,
			avCommissionCustomer.commissionCustomerPercent, avCommissionCustomer.commissionCustomerDateBegin,
			avCommissionCustomer.commissionCustomerDateEnd, avCommissionCustomer.commissionCustomerStatus,
			avCommissionCustomer.commissionCustomerPrimary, avCommissionCustomer.commissionCustomerDescription,
			avCommissionCustomer.commissionCustomerDateCreated, avCommissionCustomer.commissionCustomerDateUpdated,
			avUser.firstName, avUser.lastName, avUser.userID_custom, avUser.userDateCreated,
			avCompany.companyName, avCompany.companyDBA, avCompany.companyID_custom
		FROM avCommissionCustomer
			LEFT OUTER JOIN avUser ON avCommissionCustomer.targetID = avUser.userID
			LEFT OUTER JOIN avCompany ON avCommissionCustomer.companyID = avCompany.companyID
		WHERE avCommissionCustomer.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="commissionCustomerID,userID_author,companyID,targetID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avCommissionCustomer.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">) </cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				AND (avCommissionCustomer.commissionCustomerAllUsers = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					OR avCommissionCustomer.commissionCustomerID IN (SELECT commissionCustomerID FROM avCommissionCustomerUser WHERE userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)))
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriberID") and Application.fn_IsIntegerList(Arguments.subscriberID)>
				AND (avCommissionCustomer.commissionCustomerAllSubscribers = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					OR avCommissionCustomer.commissionCustomerID IN (SELECT commissionCustomerID FROM avCommissionCustomerSubscriber WHERE subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)))
			</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID)>AND avCommissionCustomer.primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer"></cfif>
			<cfloop Index="field" List="commissionCustomerStatus,commissionCustomerPrimary">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avCommissionCustomer.#field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "commissionCustomerPercent") and IsNumeric(Arguments.commissionCustomerPercent)>AND avCommissionCustomer.commissionCustomerPercent = <cfqueryparam Value="#Arguments.commissionCustomerPercent#" cfsqltype="cf_sql_decimal"></cfif>
			<cfif StructKeyExists(Arguments, "commissionCustomerPercent_min") and IsNumeric(Arguments.commissionCustomerPercent_min)>AND avCommissionCustomer.commissionCustomerPercent >= <cfqueryparam Value="#Arguments.commissionCustomerPercent_min#" cfsqltype="cf_sql_decimal"></cfif>
			<cfif StructKeyExists(Arguments, "commissionCustomerPercent_max") and IsNumeric(Arguments.commissionCustomerPercent_max)>AND avCommissionCustomer.commissionCustomerPercent <= <cfqueryparam Value="#Arguments.commissionCustomerPercent_max#" cfsqltype="cf_sql_decimal"></cfif>
			<cfif StructKeyExists(Arguments, "commissionCustomerDateBegin_from") and IsDate(Arguments.commissionCustomerDateBegin_from)>AND avCommissionCustomer.commissionCustomerDateBegin >= <cfqueryparam Value="#CreateODBCDateTime(Arguments.commissionCustomerDateBegin_from)#" CFSQLType="cf_sql_timestamp"></cfif>
			<cfif StructKeyExists(Arguments, "commissionCustomerDateBegin_to") and IsDate(Arguments.commissionCustomerDateBegin_to)>AND avCommissionCustomer.commissionCustomerDateBegin <= <cfqueryparam Value="#CreateODBCDateTime(Arguments.commissionCustomerDateBegin_to)#" CFSQLType="cf_sql_timestamp"></cfif>
			<cfif StructKeyExists(Arguments, "commissionCustomerDateEnd_from") and IsDate(Arguments.commissionCustomerDateEnd_from)>AND avCommissionCustomer.commissionCustomerDateEnd >= <cfqueryparam Value="#CreateODBCDateTime(Arguments.commissionCustomerDateEnd_from)#" CFSQLType="cf_sql_timestamp"></cfif>
			<cfif StructKeyExists(Arguments, "commissionCustomerDateEnd_to") and IsDate(Arguments.commissionCustomerDateEnd_to)>AND avCommissionCustomer.commissionCustomerDateEnd <= <cfqueryparam Value="#CreateODBCDateTime(Arguments.commissionCustomerDateEnd_to)#" CFSQLType="cf_sql_timestamp"></cfif>
			<cfif StructKeyExists(Arguments, "commissionCustomerDateEndIsNull") and ListFind("0,1", Arguments.commissionCustomerDateEndIsNull)>AND avCommissionCustomer.commissionCustomerDateEnd <cfif Arguments.commissionCustomerDateEndIsNull is 1> IS NULL <cfelse> IS NOT NULL </cfif></cfif>
			<cfif StructKeyExists(Arguments, "commissionCustomerDate") and IsDate(Arguments.commissionCustomerDate)>
				AND avCommissionCustomer.commissionCustomerDateBegin <= <cfqueryparam Value="#CreateODBCDateTime(Arguments.commissionCustomerDate)#" CFSQLType="cf_sql_timestamp">
				AND (avCommissionCustomer.commissionCustomerDateEnd IS NULL OR avCommissionCustomer.commissionCustomerDateEnd <= <cfqueryparam Value="#CreateODBCDateTime(Arguments.commissionCustomerDate)#" CFSQLType="cf_sql_timestamp">)
			</cfif>
		ORDER BY avCommissionCustomer.commissionCustomerStatus DESC, 
			avCompany.companyName, avUser.lastName, avUser.firstName,
			avCommissionCustomer.commissionCustomerPercent DESC
	</cfquery>

	<cfreturn qry_selectCommissionCustomerList>
</cffunction>

</cfcomponent>
