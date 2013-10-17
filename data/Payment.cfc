<cfcomponent DisplayName="Payment" Hint="Manages creating, viewing and managing payments">

<cffunction name="maxlength_Payment" access="public" output="no" returnType="struct">
	<cfset var maxlength_Payment = StructNew()>

	<cfset maxlength_Payment.paymentID_custom = 50>
	<cfset maxlength_Payment.paymentDescription = 255>
	<cfset maxlength_Payment.paymentMessage = 255>
	<cfset maxlength_Payment.paymentMethod = 25>
	<cfset maxlength_Payment.paymentAmount = 2>
	<cfset maxlength_Payment.paymentCreditCardType = 50>
	<cfset maxlength_Payment.paymentCreditCardLast4 = 20>
	<cfset maxlength_Payment.paymentCreditCardLast4_decrypted = 4>

	<cfreturn maxlength_Payment>
</cffunction>

<cffunction Name="insertPayment" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new payment and returns paymentID">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="paymentManual" Type="numeric" Required="No" Default="0">
	<cfargument Name="creditCardID" Type="numeric" Required="No" Default="0">
	<cfargument Name="bankID" Type="numeric" Required="No" Default="0">
	<cfargument Name="merchantAccountID" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentCheckNumber" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentID_custom" Type="string" Required="No" Default="">
	<cfargument Name="paymentStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentApproved" Type="string" Required="No" Default="">
	<cfargument Name="paymentAmount" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentDescription" Type="string" Required="No" Default="">
	<cfargument Name="paymentMessage" Type="string" Required="No" Default="">
	<cfargument Name="paymentMethod" Type="string" Required="No" Default="">
	<cfargument Name="paymentProcessed" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentDateReceived" Type="date" Required="No" Default="#CreateODBCDateTime(Now())#">
	<cfargument Name="paymentDateScheduled" Type="string" Required="No" Default="">
	<cfargument Name="paymentCategoryID" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberID" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentIsRefund" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentID_refund" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="No" Default="0">
	<cfargument Name="paymentIsExported" Type="string" Required="No" Default="">
	<cfargument Name="paymentDateExported" Type="string" Required="No" Default="">
	<cfargument Name="paymentCreditCardType" Type="string" Required="No" Default="">
	<cfargument Name="paymentCreditCardLast4" Type="string" Required="No" Default="">

	<cfset var qry_insertPayment = QueryNew("blank")>

	<cfif Len(Arguments.paymentCreditCardLast4) is 4 and Application.fn_IsInteger(Arguments.paymentCreditCardLast4)>
		<cfset Arguments.paymentCreditCardLast4 = Application.fn_EncryptString(Arguments.paymentCreditCardLast4)>
	<cfelse>
		<cfset Arguments.paymentCreditCardLast4 = "">
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.Payment" method="maxlength_Payment" returnVariable="maxlength_Payment" />

	<cfquery Name="qry_insertPayment" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPayment
		(
			userID, companyID, userID_author, companyID_author, paymentManual, creditCardID, bankID,
			merchantAccountID, paymentCheckNumber, paymentID_custom, paymentStatus, paymentApproved,
			paymentAmount, paymentDescription, paymentMessage, paymentMethod, paymentProcessed,
			paymentDateReceived, paymentDateScheduled, paymentCategoryID, subscriberID, paymentIsRefund,
			paymentID_refund, subscriberProcessID, paymentIsExported, paymentDateExported, paymentCreditCardType,
			paymentCreditCardLast4, paymentDateCreated, paymentDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.paymentManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.merchantAccountID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.paymentCheckNumber#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.paymentID_custom#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentID_custom#">,
			<cfqueryparam Value="#Arguments.paymentStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not ListFind("0,1", Arguments.paymentApproved)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentApproved#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfqueryparam Value="#Arguments.paymentAmount#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.paymentDescription#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentDescription#">,
			<cfqueryparam Value="#Left(Arguments.paymentMessage, maxlength_Payment.paymentMessage)#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentMessage#">,
			<cfqueryparam Value="#Arguments.paymentMethod#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentMethod#">,
			<cfqueryparam Value="#Arguments.paymentProcessed#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.paymentDateReceived#" cfsqltype="cf_sql_timestamp">,
			<cfif Not IsDate(Arguments.paymentDateScheduled)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentDateScheduled#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.paymentIsRefund#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.paymentID_refund#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriberProcessID#" cfsqltype="cf_sql_integer">,
			<cfif Not ListFind("0,1", Arguments.paymentIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.paymentDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.paymentDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.paymentCreditCardType#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentCreditCardType#">,
			<cfqueryparam Value="#Arguments.paymentCreditCardLast4#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentCreditCardLast4#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "paymentID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertPayment.primaryKeyID>
</cffunction>

<cffunction Name="updatePayment" Access="public" Output="No" ReturnType="boolean" Hint="Update existing payment and returns True">
	<cfargument Name="paymentID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="paymentManual" Type="numeric" Required="No">
	<cfargument Name="creditCardID" Type="numeric" Required="No">
	<cfargument Name="bankID" Type="numeric" Required="No">
	<cfargument Name="merchantAccountID" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber" Type="numeric" Required="No">
	<cfargument Name="paymentID_custom" Type="string" Required="No">
	<cfargument Name="paymentStatus" Type="numeric" Required="No">
	<cfargument Name="paymentApproved" Type="string" Required="No">
	<cfargument Name="paymentAmount" Type="numeric" Required="No">
	<cfargument Name="paymentDescription" Type="string" Required="No">
	<cfargument Name="paymentMessage" Type="string" Required="No">
	<cfargument Name="paymentMethod" Type="string" Required="No">
	<cfargument Name="paymentProcessed" Type="numeric" Required="No">
	<cfargument Name="paymentDateReceived" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled" Type="string" Required="No">
	<cfargument Name="paymentCategoryID" Type="numeric" Required="No">
	<cfargument Name="subscriberID" Type="numeric" Required="No">
	<cfargument Name="paymentIsRefund" Type="numeric" Required="No">
	<cfargument Name="paymentID_refund" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="No">
	<cfargument Name="paymentIsExported" Type="string" Required="No">
	<cfargument Name="paymentDateExported" Type="string" Required="No">
	<cfargument Name="paymentCreditCardType" Type="string" Required="No">
	<cfargument Name="paymentCreditCardLast4" Type="string" Required="No">

	<cfif StructKeyExists(Arguments, "paymentCreditCardLast4")>
		<cfif Len(Arguments.paymentCreditCardLast4) is 4 and Application.fn_IsInteger(Form.paymentCreditCardLast4)>
			<cfset Arguments.paymentCreditCardLast4 = Application.fn_EncryptString(Arguments.paymentCreditCardLast4)>
		<cfelse>
			<cfset Arguments.paymentCreditCardLast4 = "">
		</cfif>
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.Payment" method="maxlength_Payment" returnVariable="maxlength_Payment" />

	<cfquery Name="qry_updatePayment" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPayment
		SET 
			<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentManual") and ListFind("0,1", Arguments.paymentManual)>paymentManual = <cfqueryparam Value="#Arguments.paymentManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "creditCardID") and Application.fn_IsIntegerNonNegative(Arguments.creditCardID)>creditCardID = <cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "bankID") and Application.fn_IsIntegerNonNegative(Arguments.bankID)>bankID = <cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantAccountID") and Application.fn_IsIntegerNonNegative(Arguments.merchantAccountID)>merchantAccountID = <cfqueryparam Value="#Arguments.merchantAccountID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCheckNumber") and Application.fn_IsIntegerNonNegative(Arguments.paymentCheckNumber)>paymentCheckNumber = <cfqueryparam Value="#Arguments.paymentCheckNumber#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentID_custom")>paymentID_custom = <cfqueryparam Value="#Arguments.paymentID_custom#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentStatus") and ListFind("0,1", Arguments.paymentStatus)>paymentStatus = <cfqueryparam Value="#Arguments.paymentStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentApproved") and (Arguments.paymentApproved is "" or ListFind("0,1", Arguments.paymentApproved))>paymentApproved = <cfif Arguments.paymentApproved is "">NULL<cfelse><cfqueryparam Value="#Arguments.paymentApproved#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "paymentAmount") and IsNumeric(Arguments.paymentAmount)>paymentAmount = <cfqueryparam Value="#Arguments.paymentAmount#" cfsqltype="cf_sql_money">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentDescription")>paymentDescription = <cfqueryparam Value="#Arguments.paymentDescription#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentMessage")>paymentMessage = <cfqueryparam Value="#Left(Arguments.paymentMessage, maxlength_Payment.paymentMessage)#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentMessage#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentMethod")>paymentMethod = <cfqueryparam Value="#Arguments.paymentMethod#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentMethod#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentProcessed") and ListFind("0,1", Arguments.paymentProcessed)>paymentProcessed = <cfqueryparam Value="#Arguments.paymentProcessed#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentDateReceived") and IsDate(Arguments.paymentDateReceived)>paymentDateReceived = <cfqueryparam Value="#Arguments.paymentDateReceived#" cfsqltype="cf_sql_timestamp">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentDateScheduled")>paymentDateScheduled = <cfif Not IsDate(Arguments.paymentDateScheduled)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentDateScheduled#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryID") and Application.fn_IsIntegerNonNegative(Arguments.paymentCategoryID)>paymentCategoryID = <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberID") and Application.fn_IsIntegerNonNegative(Arguments.subscriberID)>subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentIsRefund") and ListFind("0,1", Arguments.paymentIsRefund)>paymentIsRefund = <cfqueryparam Value="#Arguments.paymentIsRefund#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentID_refund") and Application.fn_IsIntegerNonNegative(Arguments.paymentID_refund)>paymentID_refund = <cfqueryparam Value="#Arguments.paymentID_refund#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberProcessID") and Application.fn_IsIntegerNonNegative(Arguments.subscriberProcessID)>subscriberProcessID = <cfqueryparam Value="#Arguments.subscriberProcessID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentIsExported") and (Arguments.paymentIsExported is "" or ListFind("0,1", Arguments.paymentIsExported))>paymentIsExported = <cfif Not ListFind("0,1", Arguments.paymentIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "paymentDateExported") and (Arguments.paymentDateExported is "" or IsDate(Arguments.paymentDateExported))>paymentDateExported = <cfif Not IsDate(Arguments.paymentDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.paymentDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditCardType")>paymentCreditCardType = <cfqueryparam Value="#Arguments.paymentCreditCardType#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentCreditCardType#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCreditCardLast4")>paymentCreditCardLast4 = <cfqueryparam Value="#Arguments.paymentCreditCardLast4#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_Payment.paymentCreditCardLast4#">,</cfif>
			paymentDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE paymentID = <cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPayment" Access="public" Output="No" ReturnType="query" Hint="Selects existing payment">
	<cfargument Name="paymentID" Type="string" Required="Yes">

	<cfset var qry_selectPayment = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.paymentID)>
		<cfset Arguments.paymentID = 0>
	</cfif>

	<cfquery Name="qry_selectPayment" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avPayment.paymentID, avPayment.userID, avPayment.companyID, avPayment.userID_author, avPayment.companyID_author,
			avPayment.paymentManual, avPayment.creditCardID, avPayment.bankID, avPayment.merchantAccountID,
			avPayment.paymentCheckNumber, avPayment.paymentID_custom, avPayment.paymentStatus,
			avPayment.paymentAmount, avPayment.paymentApproved, avPayment.paymentDescription,
			avPayment.paymentMessage, avPayment.paymentMethod, avPayment.paymentProcessed,
			avPayment.paymentDateReceived, avPayment.paymentDateScheduled, avPayment.paymentCategoryID,
			avPayment.subscriberID, avPayment.subscriberProcessID, avPayment.paymentIsRefund,
			avPayment.paymentID_refund, avPayment.paymentDateCreated, avPayment.paymentDateUpdated,
			avPayment.paymentIsExported, avPayment.paymentDateExported,
			avPayment.paymentCreditCardType, avPayment.paymentCreditCardLast4,
			AuthorUser.firstName AS authorFirstName, AuthorUser.lastName AS authorLastName, AuthorUser.userID_custom AS authorUserID_custom,
			TargetUser.firstName AS targetFirstName, TargetUser.lastName AS targetLastName, TargetUser.userID_custom AS targetUserID_custom,
			TargetCompany.companyName AS targetCompanyName, TargetCompany.companyID_custom AS targetCompanyID_custom,
			avSubscriber.subscriberName, avSubscriber.subscriberID_custom
		FROM avPayment
			LEFT OUTER JOIN avUser AS AuthorUser ON avPayment.userID_author = AuthorUser.userID
			LEFT OUTER JOIN avUser AS TargetUser ON avPayment.userID = TargetUser.userID
			LEFT OUTER JOIN avCompany AS TargetCompany ON avPayment.companyID = TargetCompany.companyID
			LEFT OUTER JOIN avSubscriber ON avPayment.subscriberID = avSubscriber.subscriberID
		WHERE avPayment.paymentID IN (<cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfloop Query="qry_selectPayment">
		<cfif qry_selectPayment.paymentCreditCardLast4 is not "">
			<cfset temp = QuerySetCell(qry_selectPayment, "paymentCreditCardLast4", Application.fn_DecryptString(qry_selectPayment.paymentCreditCardLast4), qry_selectPayment.CurrentRow)>
		</cfif>
	</cfloop>

	<cfreturn qry_selectPayment>
</cffunction>

<cffunction Name="checkPaymentPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for payment entry(s)">
	<cfargument Name="paymentID" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">

	<cfset var qry_checkPaymentPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.paymentID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkPaymentPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT paymentID, userID_author, userID, companyID
			FROM avPayment
			WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
				AND paymentID IN (<cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer" List="Yes" Separator="No">)
		</cfquery>

		<cfif qry_checkPaymentPermission.RecordCount is 0 or qry_checkPaymentPermission.RecordCount is not ListLen(Arguments.paymentID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectPaymentIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects paymentID of existing payment via custom ID and returns paymentID(s) if exists, 0 if not exists, and -1 if multiple payments have the same paymentID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="paymentID_custom" Type="string" Required="Yes">

	<cfset var qry_selectPaymentIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectPaymentIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT paymentID
		FROM avPayment
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND paymentID_custom IN (<cfqueryparam Value="#Arguments.paymentID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectPaymentIDViaCustomID.RecordCount is 0 or qry_selectPaymentIDViaCustomID.RecordCount lt ListLen(Arguments.paymentID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectPaymentIDViaCustomID.RecordCount gt ListLen(Arguments.paymentID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectPaymentIDViaCustomID.paymentID)>
	</cfif>
</cffunction>

<cffunction Name="selectPaymentList" Access="public" ReturnType="query" Hint="Select list of payments">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="paymentID" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="paymentAppliedToInvoice" Type="string" Required="No">
	<cfargument Name="paymentAppliedToMultipleInvoices" Type="string" Required="No">
	<cfargument Name="paymentManual" Type="numeric" Required="No">
	<cfargument Name="paymentStatus" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber" Type="string" Required="No">
	<cfargument Name="paymentCheckNumber_min" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber_max" Type="numeric" Required="No">
	<cfargument Name="paymentApproved" Type="string" Required="No">
	<cfargument Name="paymentID_custom" Type="string" Required="No">
	<cfargument Name="paymentHasCustomID" Type="numeric" Required="No">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="bankID" Type="string" Required="No">
	<cfargument Name="paymentHasCreditCardID" Type="numeric" Required="No">
	<cfargument Name="paymentHasBankID" Type="numeric" Required="No">
	<cfargument Name="paymentHasCheckNumber" Type="numeric" Required="No">
	<cfargument Name="paymentIsScheduled" Type="numeric" Required="No">
	<cfargument Name="paymentMethod" Type="string" Required="No">
	<cfargument Name="paymentProcessed" Type="numeric" Required="No">
	<cfargument Name="merchantAccountID" Type="string" Required="No">
	<cfargument Name="paymentHasDescription" Type="numeric" Required="No">
	<cfargument Name="paymentHasMessage" Type="numeric" Required="No">
	<cfargument Name="paymentDescription" Type="string" Required="No">
	<cfargument Name="paymentMessage" Type="string" Required="No">
	<cfargument Name="paymentAmount" Type="numeric" Required="No">
	<cfargument Name="paymentAmount_min" Type="numeric" Required="No">
	<cfargument Name="paymentAmount_max" Type="numeric" Required="No">
	<cfargument Name="paymentDateReceived_from" Type="date" Required="No">
	<cfargument Name="paymentDateReceived_to" Type="date" Required="No">
	<cfargument Name="paymentDateCreated_from" Type="date" Required="No">
	<cfargument Name="paymentDateCreated_to" Type="date" Required="No">
	<cfargument Name="paymentDateUpdated_from" Type="date" Required="No">
	<cfargument Name="paymentDateUpdated_to" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled_from" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled_to" Type="date" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="paymentDateType" Type="string" Required="No">
	<cfargument Name="paymentDateFrom" Type="date" Required="No">
	<cfargument Name="paymentDateTo" Type="date" Required="No">
	<cfargument Name="paymentID_not" Type="string" Required="No">
	<cfargument Name="paymentCategoryID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="paymentIsRefund" Type="numeric" Required="No">
	<cfargument Name="paymentID_refund" Type="string" Required="No">
	<cfargument Name="paymentHasBeenRefunded" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="No">
	<cfargument Name="paymentIsFullyApplied" Type="numeric" Required="No">
	<!--- creditCardType,group,company status,subscriber status --->
	<cfargument Name="paymentIsExported" Type="string" Required="No">
	<cfargument Name="paymentDateExported_from" Type="string" Required="No">
	<cfargument Name="paymentDateExported_to" Type="string" Required="No">
	<cfargument Name="queryOrderBy" Type="string" Required="no" default="paymentID_d">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">

	<cfset var displayOr = False>
	<cfset var paymentDateClause = "">
	<cfset var queryParameters_orderBy = "avAffiliate.affiliateName">
	<cfset var queryParameters_orderBy_noTable = "affiliateName">
	<cfset var qry_selectPaymentList = QueryNew("blank")>

	<cfswitch expression="#Arguments.queryOrderBy#">
	 <cfcase value="paymentID,creditCardID,bankID,merchantAccountID,paymentCheckNumber,paymentAmount,paymentDateReceived,paymentDateScheduled,paymentDateUpdated,userID,companyID,paymentManual,paymentStatus,paymentApproved,paymentDescription,paymentMessage,paymentCategoryID,subscriberID,paymentIsRefund">
		<cfset queryParameters_orderBy = "avPayment.paymentID">
	 </cfcase>
	 <cfcase value="paymentID_d,creditCardID_d,bankID_d,merchantAccountID_d,paymentCheckNumber_d,paymentAmount_d,paymentDateReceived_d,paymentDateScheduled_d,paymentDateUpdated_d,userID_d,companyID_d,paymentManual_d,paymentStatus_d,paymentApproved_d,paymentDescription_d,paymentMessage_d,paymentCategoryID_d,subscriberID_d,paymentIsRefund_d">
		<cfset queryParameters_orderBy = "avPayment.paymentID DESC">
	 </cfcase>
	 <cfcase value="paymentID_custom"><cfset queryParameters_orderBy = "avPayment.paymentID_custom"></cfcase>
	 <cfcase value="paymentID_custom_d"><cfset queryParameters_orderBy = "avPayment.paymentID_custom DESC"></cfcase>
	 <cfcase value="userID_author"><cfset queryParameters_orderBy = "avPayment.userID_author"></cfcase>
	 <cfcase value="userID_author_d"><cfset queryParameters_orderBy = "avPayment.userID_author DESC"></cfcase>
	 <cfcase value="paymentDateCreated"><cfset queryParameters_orderBy = "avPayment.paymentID"></cfcase>
	 <cfcase value="paymentDateCreated_d"><cfset queryParameters_orderBy = "avPayment.paymentID DESC"></cfcase>
	 <cfcase value="subscriberProcessID"><cfset queryParameters_orderBy = "avPayment.subscriberID, avPayment.subscriberProcessID"></cfcase>
	 <cfcase value="subscriberProcessID_d"><cfset queryParameters_orderBy = "avPayment.subscriberID DESC, avPayment.subscriberProcessID DESC"></cfcase>
	 <cfcase value="authorLastName"><cfset queryParameters_orderBy = "AuthorUser.authorLastName, AuthorUser.authorFirstName"></cfcase>
	 <cfcase value="authorLastName_d"><cfset queryParameters_orderBy = "AuthorUser.authorLastName DESC, AuthorUser.authorFirstName DESC"></cfcase>
	 <cfcase value="targetLastName"><cfset queryParameters_orderBy = "TargetUser.targetLastName, TargetUser.targetFirstName"></cfcase>
	 <cfcase value="targetLastName_d"><cfset queryParameters_orderBy = "TargetUser.targetLastName DESC, TargetUser.targetFirstName DESC"></cfcase>
	 <cfcase value="targetCompanyName"><cfset queryParameters_orderBy = "TargetCompany.targetCompanyName"></cfcase>
	 <cfcase value="targetCompanyName_d"><cfset queryParameters_orderBy = "TargetCompany.targetCompanyName DESC"></cfcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="AuthorUser,TargetUser,TargetCompany,avPayment">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectPaymentList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avPayment.paymentID, avPayment.userID, avPayment.companyID, avPayment.userID_author, avPayment.companyID_author,
			avPayment.paymentManual, avPayment.creditCardID, avPayment.bankID, avPayment.merchantAccountID,
			avPayment.paymentCheckNumber, avPayment.paymentID_custom, avPayment.paymentStatus, avPayment.paymentAmount,
			avPayment.paymentApproved, avPayment.paymentDescription, avPayment.paymentMessage, avPayment.paymentMethod,
			avPayment.paymentProcessed, avPayment.paymentDateReceived, avPayment.paymentDateScheduled,
			avPayment.paymentCategoryID, avPayment.subscriberID, avPayment.subscriberProcessID, avPayment.paymentIsRefund,
			avPayment.paymentID_refund, avPayment.paymentDateCreated, avPayment.paymentDateUpdated,
			avPayment.paymentIsExported, avPayment.paymentDateExported,
			avPayment.paymentCreditCardType, avPayment.paymentCreditCardLast4,
			AuthorUser.firstName AS authorFirstName, AuthorUser.lastName AS authorLastName, AuthorUser.userID_custom AS authorUserID_custom,
			TargetUser.firstName AS targetFirstName, TargetUser.lastName AS targetLastName, TargetUser.userID_custom AS targetUserID_custom,
			TargetCompany.companyName AS targetCompanyName, TargetCompany.companyID_custom AS targetCompanyID_custom,
			avSubscriber.subscriberName, avSubscriber.subscriberID_custom
			<!--- , avPaymentCategory.paymentCategoryName --->
		FROM avPayment
			LEFT OUTER JOIN avUser AS AuthorUser ON avPayment.userID_author = AuthorUser.userID
			LEFT OUTER JOIN avUser AS TargetUser ON avPayment.userID = TargetUser.userID
			LEFT OUTER JOIN avCompany AS TargetCompany ON avPayment.companyID = TargetCompany.companyID
			LEFT OUTER JOIN avSubscriber ON avPayment.subscriberID = avSubscriber.subscriberID
			<!--- LEFT OUTER JOIN avPaymentCategory ON avPayment.paymentCategoryID = avPaymentCategory.paymentCategoryID --->
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectPaymentList.cfm">
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfloop Query="qry_selectPaymentList">
		<cfif qry_selectPaymentList.paymentCreditCardLast4 is not "">
			<cfset temp = QuerySetCell(qry_selectPaymentList, "paymentCreditCardLast4", Application.fn_DecryptString(qry_selectPaymentList.paymentCreditCardLast4), qry_selectPaymentList.CurrentRow)>
		</cfif>
	</cfloop>

	<cfreturn qry_selectPaymentList>
</cffunction>

<cffunction Name="selectPaymentCount" Access="public" ReturnType="numeric" Hint="Select total number of payments in list">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="paymentID" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="paymentAppliedToInvoice" Type="string" Required="No">
	<cfargument Name="paymentAppliedToMultipleInvoices" Type="string" Required="No">
	<cfargument Name="paymentManual" Type="numeric" Required="No">
	<cfargument Name="paymentStatus" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber" Type="string" Required="No">
	<cfargument Name="paymentCheckNumber_min" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber_max" Type="numeric" Required="No">
	<cfargument Name="paymentApproved" Type="string" Required="No">
	<cfargument Name="paymentID_custom" Type="string" Required="No">
	<cfargument Name="paymentHasCustomID" Type="numeric" Required="No">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="bankID" Type="string" Required="No">
	<cfargument Name="paymentHasCreditCardID" Type="numeric" Required="No">
	<cfargument Name="paymentHasBankID" Type="numeric" Required="No">
	<cfargument Name="paymentHasCheckNumber" Type="numeric" Required="No">
	<cfargument Name="paymentIsScheduled" Type="numeric" Required="No">
	<cfargument Name="paymentMethod" Type="string" Required="No">
	<cfargument Name="paymentProcessed" Type="numeric" Required="No">
	<cfargument Name="merchantAccountID" Type="string" Required="No">
	<cfargument Name="paymentHasDescription" Type="numeric" Required="No">
	<cfargument Name="paymentHasMessage" Type="numeric" Required="No">
	<cfargument Name="paymentDescription" Type="string" Required="No">
	<cfargument Name="paymentMessage" Type="string" Required="No">
	<cfargument Name="paymentAmount" Type="numeric" Required="No">
	<cfargument Name="paymentAmount_min" Type="numeric" Required="No">
	<cfargument Name="paymentAmount_max" Type="numeric" Required="No">
	<cfargument Name="paymentDateReceived_from" Type="date" Required="No">
	<cfargument Name="paymentDateReceived_to" Type="date" Required="No">
	<cfargument Name="paymentDateCreated_from" Type="date" Required="No">
	<cfargument Name="paymentDateCreated_to" Type="date" Required="No">
	<cfargument Name="paymentDateUpdated_from" Type="date" Required="No">
	<cfargument Name="paymentDateUpdated_to" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled_from" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled_to" Type="date" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="paymentDateType" Type="string" Required="No">
	<cfargument Name="paymentDateFrom" Type="date" Required="No">
	<cfargument Name="paymentDateTo" Type="date" Required="No">
	<cfargument Name="paymentID_not" Type="string" Required="No">
	<cfargument Name="paymentCategoryID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="paymentIsRefund" Type="numeric" Required="No">
	<cfargument Name="paymentID_refund" Type="string" Required="No">
	<cfargument Name="paymentHasBeenRefunded" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="No">
	<cfargument Name="paymentIsFullyApplied" Type="numeric" Required="No">
	<!--- creditCardType,group,company status,subscriber status --->
	<cfargument Name="paymentIsExported" Type="string" Required="No">
	<cfargument Name="paymentDateExported_from" Type="string" Required="No">
	<cfargument Name="paymentDateExported_to" Type="string" Required="No">

	<cfset var displayOr = False>
	<cfset var paymentDateClause = "">
	<cfset var qry_selectPaymentCount = QueryNew("blank")>

	<cfquery Name="qry_selectPaymentCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(paymentID) AS totalRecords
		FROM avPayment
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectPaymentList.cfm">
	</cfquery>

	<cfreturn qry_selectPaymentCount.totalRecords>
</cffunction>

<!--- Update Export Status --->
<cffunction Name="updatePaymentIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether payment records have been exported. Returns True.">
	<cfargument Name="paymentID" Type="string" Required="Yes">
	<cfargument Name="paymentIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.paymentID) or (Arguments.paymentIsExported is not "" and Not ListFind("0,1", Arguments.paymentIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updatePaymentIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avPayment
			SET paymentIsExported = <cfif Not ListFind("0,1", Arguments.paymentIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.paymentIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				paymentDateExported = <cfif Not ListFind("0,1", Arguments.paymentIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE paymentID IN (<cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectPaymentList_summary" Access="public" ReturnType="query" Hint="Select summary of payments">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="paymentID" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="paymentAppliedToInvoice" Type="string" Required="No">
	<cfargument Name="paymentAppliedToMultipleInvoices" Type="string" Required="No">
	<cfargument Name="paymentManual" Type="numeric" Required="No">
	<cfargument Name="paymentStatus" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber" Type="string" Required="No">
	<cfargument Name="paymentCheckNumber_min" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber_max" Type="numeric" Required="No">
	<cfargument Name="paymentApproved" Type="string" Required="No">
	<cfargument Name="paymentID_custom" Type="string" Required="No">
	<cfargument Name="paymentHasCustomID" Type="numeric" Required="No">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="bankID" Type="string" Required="No">
	<cfargument Name="paymentHasCreditCardID" Type="numeric" Required="No">
	<cfargument Name="paymentHasBankID" Type="numeric" Required="No">
	<cfargument Name="paymentHasCheckNumber" Type="numeric" Required="No">
	<cfargument Name="paymentIsScheduled" Type="numeric" Required="No">
	<cfargument Name="paymentMethod" Type="string" Required="No">
	<cfargument Name="paymentProcessed" Type="numeric" Required="No">
	<cfargument Name="merchantAccountID" Type="string" Required="No">
	<cfargument Name="paymentHasDescription" Type="numeric" Required="No">
	<cfargument Name="paymentHasMessage" Type="numeric" Required="No">
	<cfargument Name="paymentDescription" Type="string" Required="No">
	<cfargument Name="paymentMessage" Type="string" Required="No">
	<cfargument Name="paymentAmount" Type="numeric" Required="No">
	<cfargument Name="paymentAmount_min" Type="numeric" Required="No">
	<cfargument Name="paymentAmount_max" Type="numeric" Required="No">
	<cfargument Name="paymentDateReceived_from" Type="date" Required="No">
	<cfargument Name="paymentDateReceived_to" Type="date" Required="No">
	<cfargument Name="paymentDateCreated_from" Type="date" Required="No">
	<cfargument Name="paymentDateCreated_to" Type="date" Required="No">
	<cfargument Name="paymentDateUpdated_from" Type="date" Required="No">
	<cfargument Name="paymentDateUpdated_to" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled_from" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled_to" Type="date" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="paymentDateType" Type="string" Required="No">
	<cfargument Name="paymentDateFrom" Type="date" Required="No">
	<cfargument Name="paymentDateTo" Type="date" Required="No">
	<cfargument Name="paymentID_not" Type="string" Required="No">
	<cfargument Name="paymentCategoryID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="paymentIsRefund" Type="numeric" Required="No">
	<cfargument Name="paymentID_refund" Type="string" Required="No">
	<cfargument Name="paymentHasBeenRefunded" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="No">
	<cfargument Name="paymentIsFullyApplied" Type="numeric" Required="No">
	<!--- creditCardType,group,company status,subscriber status --->
	<cfargument Name="paymentIsExported" Type="string" Required="No">
	<cfargument Name="paymentDateExported_from" Type="string" Required="No">
	<cfargument Name="paymentDateExported_to" Type="string" Required="No">

	<cfargument name="paymentField" type="string" required="yes" hint="paymentApproved,paymentMethod,paymentManual,paymentMessage,paymentCreditCardType">
	<cfargument name="paymentHasCreditCardType" type="numeric" required="no">

	<cfset var qry_selectPaymentList_summary = QueryNew("blank")>

	<cfif Not ListFind("paymentApproved,paymentMethod,paymentManual,paymentMessage,paymentCreditCardType", Arguments.paymentField)>
		<cfset Arguments.paymentField = "paymentApproved">
	</cfif>

	<cfquery Name="qry_selectPaymentList_summary" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avPayment.#Arguments.paymentField#,
			COUNT(avPayment.paymentID) AS countPayment, SUM(avPayment.paymentAmount) AS sumPaymentAmount
		FROM avPayment
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectPaymentList.cfm">
		GROUP BY avPayment.#Arguments.paymentField#
		ORDER BY avPayment.#Arguments.paymentField#
	</cfquery>

	<cfreturn qry_selectPaymentList_summary>
</cffunction>

<cffunction Name="selectPaymentList_refund" Access="public" ReturnType="query" Hint="Select summary of payment refunds">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="paymentID" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="paymentAppliedToInvoice" Type="string" Required="No">
	<cfargument Name="paymentAppliedToMultipleInvoices" Type="string" Required="No">
	<cfargument Name="paymentManual" Type="numeric" Required="No">
	<cfargument Name="paymentStatus" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber" Type="string" Required="No">
	<cfargument Name="paymentCheckNumber_min" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber_max" Type="numeric" Required="No">
	<cfargument Name="paymentApproved" Type="string" Required="No">
	<cfargument Name="paymentID_custom" Type="string" Required="No">
	<cfargument Name="paymentHasCustomID" Type="numeric" Required="No">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="bankID" Type="string" Required="No">
	<cfargument Name="paymentHasCreditCardID" Type="numeric" Required="No">
	<cfargument Name="paymentHasBankID" Type="numeric" Required="No">
	<cfargument Name="paymentHasCheckNumber" Type="numeric" Required="No">
	<cfargument Name="paymentIsScheduled" Type="numeric" Required="No">
	<cfargument Name="paymentMethod" Type="string" Required="No">
	<cfargument Name="paymentProcessed" Type="numeric" Required="No">
	<cfargument Name="merchantAccountID" Type="string" Required="No">
	<cfargument Name="paymentHasDescription" Type="numeric" Required="No">
	<cfargument Name="paymentHasMessage" Type="numeric" Required="No">
	<cfargument Name="paymentDescription" Type="string" Required="No">
	<cfargument Name="paymentMessage" Type="string" Required="No">
	<cfargument Name="paymentAmount" Type="numeric" Required="No">
	<cfargument Name="paymentAmount_min" Type="numeric" Required="No">
	<cfargument Name="paymentAmount_max" Type="numeric" Required="No">
	<cfargument Name="paymentDateReceived_from" Type="date" Required="No">
	<cfargument Name="paymentDateReceived_to" Type="date" Required="No">
	<cfargument Name="paymentDateCreated_from" Type="date" Required="No">
	<cfargument Name="paymentDateCreated_to" Type="date" Required="No">
	<cfargument Name="paymentDateUpdated_from" Type="date" Required="No">
	<cfargument Name="paymentDateUpdated_to" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled_from" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled_to" Type="date" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="paymentDateType" Type="string" Required="No">
	<cfargument Name="paymentDateFrom" Type="date" Required="No">
	<cfargument Name="paymentDateTo" Type="date" Required="No">
	<cfargument Name="paymentID_not" Type="string" Required="No">
	<cfargument Name="paymentCategoryID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="paymentIsRefund" Type="numeric" Required="No">
	<cfargument Name="paymentID_refund" Type="string" Required="No">
	<cfargument Name="paymentHasBeenRefunded" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="No">
	<cfargument Name="paymentIsFullyApplied" Type="numeric" Required="No">
	<!--- creditCardType,group,company status,subscriber status --->
	<cfargument Name="paymentIsExported" Type="string" Required="No">
	<cfargument Name="paymentDateExported_from" Type="string" Required="No">
	<cfargument Name="paymentDateExported_to" Type="string" Required="No">

	<cfargument name="queryDisplayPerPage" type="numeric" required="no" default="0">
	<cfargument name="queryOrderBy" type="string" required="no" default="countPayment_d" hint="countPayment_d,sumPaymentAmount_d">

	<cfset var selectPaymentList_refund = QueryNew("blank")>

	<cfquery Name="selectPaymentList_refund" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			<cfif Application.billingDatabase is "MSSQLServer" and Arguments.queryDisplayPerPage is not 0>TOP 10</cfif>
			avPaymentRefundProduct.productID, avProduct.productName,
			COUNT(avPayment.paymentID) AS countPayment, SUM(avPayment.paymentAmount) AS sumPaymentAmount
		FROM avPayment
			LEFT OUTER JOIN avPaymentRefundProduct ON avPayment.paymentID = avPaymentRefundProduct.paymentID
			LEFT OUTER JOIN avProduct ON avPaymentRefundProduct.productID = avProduct.productID
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectPaymentList.cfm">
		GROUP BY avPaymentRefundProduct.productID, avProduct.productName
		ORDER BY 
			<cfswitch expression="#Arguments.queryOrderBy#">
			 <cfcase value="countPayment_d">countPayment DESC</cfcase>
			 <cfcase value="sumPaymentAmount_d">sumPaymentAmount DESC</cfcase>
			 <cfdefaultcase>countPayment DESC</cfdefaultcase>
			</cfswitch>
		<cfif Application.billingDatabase is "MySQL" and Arguments.queryDisplayPerPage is not 0>LIMIT 10</cfif>
	</cfquery>

	<cfreturn selectPaymentList_refund>
</cffunction>

<cffunction Name="selectPaymentList_category" Access="public" ReturnType="query" Hint="Select summary of payments by category">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="paymentID" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="paymentAppliedToInvoice" Type="string" Required="No">
	<cfargument Name="paymentAppliedToMultipleInvoices" Type="string" Required="No">
	<cfargument Name="paymentManual" Type="numeric" Required="No">
	<cfargument Name="paymentStatus" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber" Type="string" Required="No">
	<cfargument Name="paymentCheckNumber_min" Type="numeric" Required="No">
	<cfargument Name="paymentCheckNumber_max" Type="numeric" Required="No">
	<cfargument Name="paymentApproved" Type="string" Required="No">
	<cfargument Name="paymentID_custom" Type="string" Required="No">
	<cfargument Name="paymentHasCustomID" Type="numeric" Required="No">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="bankID" Type="string" Required="No">
	<cfargument Name="paymentHasCreditCardID" Type="numeric" Required="No">
	<cfargument Name="paymentHasBankID" Type="numeric" Required="No">
	<cfargument Name="paymentHasCheckNumber" Type="numeric" Required="No">
	<cfargument Name="paymentIsScheduled" Type="numeric" Required="No">
	<cfargument Name="paymentMethod" Type="string" Required="No">
	<cfargument Name="paymentProcessed" Type="numeric" Required="No">
	<cfargument Name="merchantAccountID" Type="string" Required="No">
	<cfargument Name="paymentHasDescription" Type="numeric" Required="No">
	<cfargument Name="paymentHasMessage" Type="numeric" Required="No">
	<cfargument Name="paymentDescription" Type="string" Required="No">
	<cfargument Name="paymentMessage" Type="string" Required="No">
	<cfargument Name="paymentAmount" Type="numeric" Required="No">
	<cfargument Name="paymentAmount_min" Type="numeric" Required="No">
	<cfargument Name="paymentAmount_max" Type="numeric" Required="No">
	<cfargument Name="paymentDateReceived_from" Type="date" Required="No">
	<cfargument Name="paymentDateReceived_to" Type="date" Required="No">
	<cfargument Name="paymentDateCreated_from" Type="date" Required="No">
	<cfargument Name="paymentDateCreated_to" Type="date" Required="No">
	<cfargument Name="paymentDateUpdated_from" Type="date" Required="No">
	<cfargument Name="paymentDateUpdated_to" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled_from" Type="date" Required="No">
	<cfargument Name="paymentDateScheduled_to" Type="date" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="paymentDateType" Type="string" Required="No">
	<cfargument Name="paymentDateFrom" Type="date" Required="No">
	<cfargument Name="paymentDateTo" Type="date" Required="No">
	<cfargument Name="paymentID_not" Type="string" Required="No">
	<cfargument Name="paymentCategoryID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="paymentIsRefund" Type="numeric" Required="No">
	<cfargument Name="paymentID_refund" Type="string" Required="No">
	<cfargument Name="paymentHasBeenRefunded" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessID" Type="numeric" Required="No">
	<cfargument Name="paymentIsFullyApplied" Type="numeric" Required="No">
	<!--- creditCardType,group,company status,subscriber status --->
	<cfargument Name="paymentIsExported" Type="string" Required="No">
	<cfargument Name="paymentDateExported_from" Type="string" Required="No">
	<cfargument Name="paymentDateExported_to" Type="string" Required="No">

	<cfset var qry_selectPaymentList_category = QueryNew("blank")>

	<cfquery Name="qry_selectPaymentList_category" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avPayment.paymentCategoryID, avPaymentCategory.paymentCategoryName,
			COUNT(avPayment.paymentID) AS countPayment, SUM(avPayment.paymentAmount) AS sumPaymentAmount
		FROM avPayment LEFT OUTER JOIN avPaymentCategory ON avPayment.paymentCategoryID = avPaymentCategory.paymentCategoryID
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectPaymentList.cfm">
		GROUP BY avPayment.paymentCategoryID, avPaymentCategory.paymentCategoryName
		ORDER BY avPaymentCategory.paymentCategoryName
	</cfquery>

	<cfreturn qry_selectPaymentList_category>
</cffunction>

</cfcomponent>

