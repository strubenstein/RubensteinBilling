<cfcomponent DisplayName="SubscriptionPayment" Hint="Relates payments to subscriber">

<!--- Subscriber Payment --->
<cffunction Name="insertSubscriberPayment" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new subscriber notification option. Returns True.">
	<cfargument Name="subscriberID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID_cancel" Type="numeric" Required="No" Default="0">
	<cfargument Name="creditCardID" Type="numeric" Required="No" Default="0">
	<cfargument Name="bankID" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberPaymentStatus" Type="numeric" Required="No" Default="1">

	<cfquery Name="qry_insertSubscriberPayment" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avSubscriberPayment
		(
			subscriberID, creditCardID, bankID, userID_author, userID_cancel,
			subscriberPaymentStatus, subscriberPaymentDateCreated, subscriberPaymentDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_cancel#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriberPaymentStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateSubscriberPayment" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing subscriber notification option. Returns True.">
	<cfargument Name="subscriberPaymentID" Type="numeric" Required="Yes">
	<cfargument Name="subscriberPaymentStatus" Type="numeric" Required="No">
	<cfargument Name="userID_cancel" Type="numeric" Required="No">

	<cfquery Name="qry_updateSubscriberPayment" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avSubscriberPayment
		SET
			<cfif StructKeyExists(Arguments, "userID_cancel") and Application.fn_IsIntegerNonNegative(Arguments.userID_cancel)>
				userID_cancel = <cfqueryparam Value="#Arguments.userID_cancel#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriberPaymentStatus") and ListFind("0,1", Arguments.subscriberPaymentStatus)>
				subscriberPaymentStatus = <cfqueryparam Value="#Arguments.subscriberPaymentStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			subscriberPaymentDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE subscriberPaymentID = <cfqueryparam Value="#Arguments.subscriberPaymentID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectSubscriberPaymentList" Access="public" Output="No" ReturnType="query" Hint="Select existing payment option for subscribers">
	<cfargument Name="subscriberID" Type="string" Required="Yes">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="bankID"  Type="string" Required="No">
	<cfargument Name="subscriberPaymentStatus" Type="numeric" Required="No">
	<cfargument Name="selectCreditCardInfo" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectSubscriberPaymentList = QueryNew("blank")>

	<cfquery Name="qry_selectSubscriberPaymentList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avSubscriberPayment.subscriberPaymentID, avSubscriberPayment.subscriberID, avSubscriberPayment.creditCardID, avSubscriberPayment.bankID,
			avSubscriberPayment.userID_author, avSubscriberPayment.userID_cancel, avSubscriberPayment.subscriberPaymentStatus,
			avSubscriberPayment.subscriberPaymentDateCreated, avSubscriberPayment.subscriberPaymentDateUpdated
			<cfif Arguments.selectCreditCardInfo is True>, avCreditCard.creditCardNumber, avCreditCard.creditCardType</cfif>
		FROM avSubscriberPayment
			<cfif Arguments.selectCreditCardInfo is True>LEFT JOIN avCreditCard ON avSubscriberPayment.creditCardID = avCreditCard.creditCardID</cfif>
		WHERE avSubscriberPayment.subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "subscriberPaymentStatus") and ListFind("0,1", Arguments.subscriberPaymentStatus)>
				AND avSubscriberPayment.subscriberPaymentStatus = <cfqueryparam Value="#Arguments.subscriberPaymentStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "creditCardID")>
				<cfif Arguments.creditCardID is 0>
					AND avSubscriberPayment.creditCardID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
				<cfelseif Arguments.creditCardID is -1>
					AND avSubscriberPayment.creditCardID <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
				<cfelseif Application.fn_IsIntegerList(Arguments.creditCardID)>
					AND avSubscriberPayment.creditCardID IN (<cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfif>
			<cfif StructKeyExists(Arguments, "bankID")>
				<cfif Arguments.bankID is 0>
					AND avSubscriberPayment.bankID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
				<cfelseif Arguments.bankID is -1>
					AND avSubscriberPayment.bankID <> <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
				<cfelseif Application.fn_IsIntegerList(Arguments.bankID)>
					AND avSubscriberPayment.bankID IN (<cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfif>
		ORDER BY avSubscriberPayment.subscriberID, avSubscriberPayment.subscriberPaymentStatus
	</cfquery>

	<cfif Arguments.selectCreditCardInfo is True>
		<cfloop Query="qry_selectSubscriberPaymentList">
			<cfif qry_selectSubscriberPaymentList.creditCardNumber is not "">
				<cfset temp = QuerySetCell(qry_selectSubscriberPaymentList, "creditCardNumber", Application.fn_DecryptString(qry_selectSubscriberPaymentList.creditCardNumber), qry_selectSubscriberPaymentList.CurrentRow)>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn qry_selectSubscriberPaymentList>
</cffunction>

</cfcomponent>
