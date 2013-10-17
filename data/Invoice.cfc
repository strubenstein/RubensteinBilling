<cfcomponent DisplayName="Invoice" Hint="Manages inserting, updating, deleting and viewing invoices">

<cffunction name="maxlength_Invoice" access="public" output="no" returnType="struct">
	<cfset var maxlength_Invoice = StructNew()>

	<cfset maxlength_Invoice.invoiceTotal = 4>
	<cfset maxlength_Invoice.invoiceTotalTax = 4>
	<cfset maxlength_Invoice.invoiceTotalLineItem = 4>
	<cfset maxlength_Invoice.invoiceTotalShipping = 4>
	<cfset maxlength_Invoice.invoiceTotalPaymentCredit = 4>
	<cfset maxlength_Invoice.invoiceID_custom = 50>
	<cfset maxlength_Invoice.invoiceShippingMethod = 50>
	<cfset maxlength_Invoice.invoiceInstructions = 500>

	<cfreturn maxlength_Invoice>
</cffunction>

<cffunction Name="insertInvoice" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new invoice. Returns invoiceID.">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceClosed" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceDateClosed" Type="string" Required="No">
	<cfargument Name="invoiceSent" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoicePaid" Type="string" Required="No" Default="">
	<cfargument Name="invoiceDatePaid" Type="string" Required="No">
	<cfargument Name="invoiceTotal" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceTotalTax" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceTotalLineItem" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceTotalShipping" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceTotalPaymentCredit" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceShipped" Type="string" Required="No" Default="">
	<cfargument Name="invoiceCompleted" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceDateCompleted" Type="string" Required="No">
	<cfargument Name="invoiceStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="invoiceDateDue" Type="string" Required="No">
	<cfargument Name="invoiceID_custom" Type="string" Required="No" Default="">
	<cfargument Name="invoiceManual" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="regionID" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceShippingMethod" Type="string" Required="No" Default="">
	<cfargument Name="invoiceInstructions" Type="string" Required="No" Default="">
	<cfargument Name="addressID_shipping" Type="numeric" Required="No" Default="0">
	<cfargument Name="addressID_billing" Type="numeric" Required="No" Default="0">
	<cfargument Name="creditCardID" Type="numeric" Required="No" Default="0">
	<cfargument Name="bankID" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberID" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceIsExported" Type="string" Required="No" Default="">
	<cfargument Name="invoiceDateExported" Type="string" Required="No" Default="">

	<cfset var qry_insertInvoice = QueryNew("blank")>
	<cfset var invoiceID = 0>

	<cfinvoke component="#Application.billingMapping#data.Invoice" method="maxlength_Invoice" returnVariable="maxlength_Invoice" />

	<cfquery Name="qry_insertInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avInvoice
		(
			userID, companyID, invoiceClosed, invoiceDateClosed, invoiceSent, invoicePaid, invoiceDatePaid,
			invoiceTotal, invoiceTotalTax, invoiceTotalLineItem, invoiceTotalPaymentCredit, invoiceTotalShipping,
			invoiceShipped, invoiceCompleted, invoiceDateCompleted, invoiceStatus, invoiceDateDue, invoiceID_custom,
			invoiceManual, userID_author, companyID_author, invoiceShippingMethod, invoiceInstructions, addressID_shipping,
			addressID_billing, languageID, regionID, creditCardID, bankID, subscriberID, invoiceIsExported,
			invoiceDateExported, invoiceDateCreated, invoiceDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceClosed#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "invoiceDateClosed") or Not IsDate(Arguments.invoiceDateClosed)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceDateClosed#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.invoiceSent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not ListFind("0,1", Arguments.invoicePaid)>NULL<cfelse><cfqueryparam Value="#Arguments.invoicePaid#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not StructKeyExists(Arguments, "invoiceDatePaid") or Not IsDate(Arguments.invoiceDatePaid)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceDatePaid#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.invoiceTotal#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoiceTotalTax#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoiceTotalLineItem#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoiceTotalPaymentCredit#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoiceTotalShipping#" cfsqltype="cf_sql_money">,
			<cfif Not ListFind("0,1", Arguments.invoiceShipped)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceShipped#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfqueryparam Value="#Arguments.invoiceCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "invoiceDateCompleted") or Not IsDate(Arguments.invoiceDateCompleted)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceDateCompleted#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.invoiceStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "invoiceDateDue") or Not IsDate(Arguments.invoiceDateDue)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceDateDue#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.invoiceID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Invoice.invoiceID_custom#">,
			<cfqueryparam Value="#Arguments.invoiceManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceShippingMethod#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Invoice.invoiceShippingMethod#">,
			<cfqueryparam Value="#Arguments.invoiceInstructions#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Invoice.invoiceInstructions#">,
			<cfqueryparam Value="#Arguments.addressID_shipping#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.addressID_billing#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam Value="#Arguments.regionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">,
			<cfif Not ListFind("0,1", Arguments.invoiceIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.invoiceDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.invoiceDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "invoiceID", "ALL")#;
	</cfquery>

	<cfset invoiceID = qry_insertInvoice.primaryKeyID>

	<!--- if invoice is fully paid, calculate sales commissions --->
	<cfif Arguments.invoicePaid is 1>
		<cfinvoke component="#Application.billingMapping#control.c_salesCommission.SalesCommissionCalculate" Method="calculateSalesCommission" ReturnVariable="isSalesCommissionCalculated">
			<cfinvokeargument Name="invoiceID" Value="#invoiceID#">
		</cfinvoke>
	</cfif>

	<cfreturn invoiceID>
</cffunction><!--- /insertInvoice --->

<cffunction Name="updateInvoice" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing invoice. Returns True.">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="invoiceClosed" Type="numeric" Required="No">
	<cfargument Name="invoiceDateClosed" Type="string" Required="No">
	<cfargument Name="invoiceSent" Type="numeric" Required="No">
	<cfargument Name="invoicePaid" Type="string" Required="No">
	<cfargument Name="invoiceDatePaid" Type="string" Required="No">
	<cfargument Name="invoiceTotal" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalLineItem" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit" Type="numeric" Required="No">
	<cfargument Name="invoiceShipped" Type="string" Required="No">
	<cfargument Name="invoiceCompleted" Type="numeric" Required="No">
	<cfargument Name="invoiceDateCompleted" Type="string" Required="No">
	<cfargument Name="invoiceStatus" Type="numeric" Required="No">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="invoiceDateDue" Type="string" Required="No">
	<cfargument Name="invoiceID_custom" Type="string" Required="No">
	<cfargument Name="invoiceManual" Type="numeric" Required="No">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="regionID" Type="numeric" Required="No">
	<cfargument Name="invoiceShippingMethod" Type="string" Required="No">
	<cfargument Name="invoiceInstructions" Type="string" Required="No">
	<cfargument Name="addressID_shipping" Type="numeric" Required="No">
	<cfargument Name="addressID_billing" Type="numeric" Required="No">
	<cfargument Name="creditCardID" Type="numeric" Required="No">
	<cfargument Name="bankID" Type="numeric" Required="No">
	<cfargument Name="subscriberID" Type="numeric" Required="No">
	<cfargument Name="invoiceIsExported" Type="string" Required="No">
	<cfargument Name="invoiceDateExported" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Invoice" method="maxlength_Invoice" returnVariable="maxlength_Invoice" />

	<cfquery Name="qry_updateInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avInvoice
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceClosed") and ListFind("0,1", Arguments.invoiceClosed)>invoiceClosed = <cfqueryparam Value="#Arguments.invoiceClosed#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceDateClosed")>invoiceDateClosed = <cfif Not IsDate(Arguments.invoiceDateClosed)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceDateClosed#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceSent") and ListFind("0,1", Arguments.invoiceSent)>invoiceSent = <cfqueryparam Value="#Arguments.invoiceSent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "invoicePaid") and (Arguments.invoicePaid is "" or ListFind("0,1", Arguments.invoicePaid))>invoicePaid = <cfif Not ListFind("0,1", Arguments.invoicePaid)>NULL<cfelse><cfqueryparam Value="#Arguments.invoicePaid#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceDatePaid")>invoiceDatePaid = <cfif Not IsDate(Arguments.invoiceDatePaid)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceDatePaid#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceTotal") and IsNumeric(Arguments.invoiceTotal)>invoiceTotal = <cfqueryparam Value="#Arguments.invoiceTotal#" cfsqltype="cf_sql_money">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceTotalTax") and IsNumeric(Arguments.invoiceTotalTax)>invoiceTotalTax = <cfqueryparam Value="#Arguments.invoiceTotalTax#" cfsqltype="cf_sql_money">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceTotalLineItem") and IsNumeric(Arguments.invoiceTotalLineItem)>invoiceTotalLineItem = <cfqueryparam Value="#Arguments.invoiceTotalLineItem#" cfsqltype="cf_sql_money">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceTotalPaymentCredit") and IsNumeric(Arguments.invoiceTotalPaymentCredit)>invoiceTotalPaymentCredit = <cfqueryparam Value="#Arguments.invoiceTotalPaymentCredit#" cfsqltype="cf_sql_money">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceTotalShipping") and IsNumeric(Arguments.invoiceTotalShipping)>invoiceTotalShipping = <cfqueryparam Value="#Arguments.invoiceTotalShipping#" cfsqltype="cf_sql_money">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceShipped") and (Arguments.invoiceShipped is "" or ListFind("0,1", Arguments.invoiceShipped))>invoiceShipped = <cfif Not ListFind("0,1", Arguments.invoiceShipped)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceShipped#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceCompleted") and ListFind("0,1", Arguments.invoiceCompleted)>invoiceCompleted = <cfqueryparam Value="#Arguments.invoiceCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceDateCompleted")>invoiceDateCompleted = <cfif Not IsDate(Arguments.invoiceDateCompleted)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceDateCompleted#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceStatus") and ListFind("0,1", Arguments.invoiceStatus)>invoiceStatus = <cfqueryparam Value="#Arguments.invoiceStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "languageID")>languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceDateDue")>invoiceDateDue = <cfif Not IsDate(Arguments.invoiceDateDue)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceDateDue#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceID_custom")>invoiceID_custom = <cfqueryparam Value="#Arguments.invoiceID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Invoice.invoiceID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceManual") and ListFind("0,1", Arguments.invoiceManual)>invoiceManual = <cfqueryparam Value="#Arguments.invoiceManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "regionID") and Application.fn_IsIntegerNonNegative(Arguments.regionID)>regionID = <cfqueryparam Value="#Arguments.regionID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceShippingMethod")>invoiceShippingMethod = <cfqueryparam Value="#Arguments.invoiceShippingMethod#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Invoice.invoiceShippingMethod#">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceInstructions")>invoiceInstructions = <cfqueryparam Value="#Arguments.invoiceInstructions#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Invoice.invoiceInstructions#">,</cfif>
			<cfif StructKeyExists(Arguments, "addressID_shipping") and Application.fn_IsIntegerNonNegative(Arguments.addressID_shipping)>addressID_shipping = <cfqueryparam Value="#Arguments.addressID_shipping#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "addressID_billing") and Application.fn_IsIntegerNonNegative(Arguments.addressID_billing)>addressID_billing = <cfqueryparam Value="#Arguments.addressID_billing#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "creditCardID") and Application.fn_IsIntegerNonNegative(Arguments.creditCardID)>creditCardID = <cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "bankID") and Application.fn_IsIntegerNonNegative(Arguments.bankID)>bankID = <cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "subscriberID") and Application.fn_IsIntegerNonNegative(Arguments.subscriberID)>subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceIsExported") and (Arguments.invoiceIsExported is "" or ListFind("0,1", Arguments.invoiceIsExported))>invoiceIsExported = <cfif Not ListFind("0,1", Arguments.invoiceIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "invoiceDateExported") and (Arguments.invoiceDateExported is "" or IsDate(Arguments.invoiceDateExported))>invoiceDateExported = <cfif Not IsDate(Arguments.invoiceDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.invoiceDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			invoiceDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<!--- if invoice is updated as fully paid, calculate sales commissions --->
	<cfif StructKeyExists(Arguments, "invoicePaid") and Arguments.invoicePaid is 1>
		<cfinvoke component="#Application.billingMapping#control.c_salesCommission.SalesCommissionCalculate" Method="calculateSalesCommission" ReturnVariable="isSalesCommissionCalculated">
			<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
		</cfinvoke>
	</cfif>

	<cfreturn True>
</cffunction><!--- /updateInvoice --->

<cffunction Name="checkInvoicePermission" Access="public" Output="No" ReturnType="boolean" Hint="Check Company Permission for Existing Invoice">
	<cfargument Name="invoiceID" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="companyID" Type="numeric" Required="No">
	<cfargument Name="invoiceClosed" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">

	<cfset var qry_checkInvoicePermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.invoiceID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkInvoicePermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT avInvoice.userID, avInvoice.companyID, avInvoice.companyID_author, avInvoice.invoiceID, avInvoice.invoiceID_custom, avCompany.affiliateID, avCompany.cobrandID
			FROM avInvoice, avCompany
			WHERE avInvoice.companyID = avCompany.companyID
				AND (avInvoice.invoiceID_custom = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_varchar">
					<cfif Application.fn_IsIntegerList(Arguments.invoiceID)> OR avInvoice.invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>)
				<cfif StructKeyExists(Arguments, "companyID_author") and Application.fn_IsIntegerNonNegative(Arguments.companyID_author)>AND avInvoice.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"></cfif>
				<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>AND avInvoice.userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"></cfif>
				<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerNonNegative(Arguments.companyID)>AND avInvoice.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"></cfif>
				<cfif StructKeyExists(Arguments, "invoiceClosed") and ListFind("0,1", Arguments.invoiceClosed)>AND avInvoice.invoiceClosed = <cfqueryparam Value="#Arguments.invoiceClosed#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
				<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID) and StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>
					AND (avCompany.cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
						OR avCompany.affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
				<cfelseif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>
					AND avCompany.cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfelseif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>
					AND avCompany.affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
		</cfquery>

		<cfif qry_checkInvoicePermission.RecordCount is 0 or qry_checkInvoicePermission.RecordCount is not ListLen(Arguments.invoiceID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction><!--- /checkInvoicePermission --->

<cffunction Name="selectInvoice" Access="public" Output="No" ReturnType="query" Hint="Select Existing Invoice">
	<cfargument Name="invoiceID" Type="string" Required="Yes">

	<cfset var qry_selectInvoice = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.invoiceID)>
		<cfset Arguments.invoiceID = 0>
	</cfif>

	<cfquery Name="qry_selectInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avInvoice.invoiceID, avInvoice.invoiceClosed, avInvoice.invoiceDateClosed, avInvoice.invoiceSent,
			avInvoice.invoicePaid, avInvoice.invoiceDatePaid, avInvoice.invoiceTotal, avInvoice.invoiceTotalTax,
			avInvoice.invoiceTotalLineItem, avInvoice.invoiceTotalPaymentCredit, avInvoice.invoiceTotalShipping,
			avInvoice.invoiceShipped, avInvoice.subscriberID, avInvoice.invoiceCompleted, avInvoice.invoiceDateCompleted,
			avInvoice.invoiceStatus, avInvoice.invoiceID_custom, avInvoice.invoiceShippingMethod, avInvoice.invoiceDateCreated,
			avInvoice.invoiceDateUpdated, avInvoice.companyID, avInvoice.userID, avInvoice.invoiceManual, avInvoice.invoiceDateDue,
			avInvoice.languageID, avInvoice.userID_author, avInvoice.companyID_author, avInvoice.regionID,
			avInvoice.invoiceInstructions, avInvoice.addressID_shipping, avInvoice.addressID_billing, avInvoice.creditCardID,
			avInvoice.bankID, avInvoice.invoiceIsExported, avInvoice.invoiceDateExported,
			avCompany.companyName, avCompany.companyID_custom,
			avUser.firstName, avUser.lastName, avUser.userID_custom,
			avSubscriber.subscriberName, avSubscriber.subscriberID_custom
		FROM avInvoice
			LEFT OUTER JOIN avCompany ON avInvoice.companyID = avCompany.companyID
			LEFT OUTER JOIN avUser ON avInvoice.userID = avUser.userID
			LEFT OUTER JOIN avSubscriber ON avInvoice.subscriberID = avSubscriber.subscriberID
		WHERE avInvoice.invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectInvoice>
</cffunction>

<cffunction Name="selectInvoiceIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects invoiceID of existing invoice via custom ID and returns invoiceID if exists, 0 if not exists, and -1 if multiple companies have the same invoiceID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID_custom" Type="string" Required="Yes">

	<cfset var qry_selectInvoiceIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectInvoiceIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT invoiceID
		FROM avInvoice
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND invoiceID_custom IN (<cfqueryparam Value="#Arguments.invoiceID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectInvoiceIDViaCustomID.RecordCount is 0 or qry_selectInvoiceIDViaCustomID.RecordCount lt ListLen(Arguments.invoiceID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectInvoiceIDViaCustomID.RecordCount gt ListLen(Arguments.invoiceID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectInvoiceIDViaCustomID.invoiceID)>
	</cfif>
</cffunction>


<!--- functions for viewing list of invoices --->
<cffunction Name="selectInvoiceList" Access="public" ReturnType="query" Hint="Select list of invoices">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="invoiceDateFrom" Type="date" Required="No">
	<cfargument Name="invoiceDateTo" Type="date" Required="No">
	<cfargument Name="invoiceDateType" Type="string" Required="No">
	<cfargument Name="invoiceTotal_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotal_max" Type="numeric" Required="No">
	<cfargument Name="invoiceClosed" Type="numeric" Required="No">
	<cfargument Name="invoicePaid" Type="string" Required="No">
	<cfargument Name="invoiceDatePaid" Type="date" Required="No">
	<cfargument Name="invoiceShipped" Type="string" Required="No">
	<cfargument Name="invoiceCompleted" Type="numeric" Required="No">
	<cfargument Name="invoiceStatus" Type="numeric" Required="No">
	<cfargument Name="invoiceSent" Type="numeric" Required="No">
	<cfargument Name="invoiceManual" Type="numeric" Required="No">
	<cfargument Name="invoiceShippingMethod" Type="string" Required="No">
	<cfargument Name="invoiceHasMultipleItems" Type="numeric" Required="No">
	<cfargument Name="invoiceHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="invoiceHasCustomID" Type="numeric" Required="No">
	<cfargument Name="invoiceHasInstructions" Type="numeric" Required="No">
	<cfargument Name="invoiceID_not" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="invoiceHasPaymentCredit" Type="numeric" Required="No">
	<cfargument Name="invoiceDatePaid_from" Type="date" Required="No">
	<cfargument Name="invoiceDatePaid_to" Type="date" Required="No">
	<cfargument Name="invoiceDateClosed_from" Type="date" Required="No">
	<cfargument Name="invoiceDateClosed_to" Type="date" Required="No">
	<cfargument Name="invoiceDateCompleted_from" Type="date" Required="No">
	<cfargument Name="invoiceDateCompleted_to" Type="date" Required="No">
	<cfargument Name="invoiceDateDue_from" Type="date" Required="No">
	<cfargument Name="invoiceDateDue_to" Type="date" Required="No">
	<cfargument Name="invoiceDateCreated_from" Type="date" Required="No">
	<cfargument Name="invoiceDateCreated_to" Type="date" Required="No">
	<cfargument Name="invoiceTotalLineItem_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalLineItem_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax_max" Type="numeric" Required="No">
	<cfargument Name="invoiceIsExported" Type="string" Required="No">
	<cfargument Name="invoiceDateExported_from" Type="string" Required="No">
	<cfargument Name="invoiceDateExported_to" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="No" Default="invoiceDateClosed_d">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">

	<cfset var queryParameters_orderBy = "avInvoice.invoiceDateClosed_d">
	<cfset var queryParameters_orderBy_noTable = "invoiceDateClosed_d">
	<cfset var qry_selectInvoiceList = QueryNew("blank")>

	<cfswitch expression="#Arguments.queryOrderBy#">
	 <cfcase value="invoiceID,invoiceDateClosed,invoiceTotal,invoiceShippingMethod,invoiceDateUpdated,invoiceTotalLineItem,invoiceTotalShipping,invoiceTotalPaymentCredit,invoiceDateDue,invoiceStatus,invoicePaid"><cfset queryParameters_orderBy = "avInvoice.#Arguments.queryOrderBy#"></cfcase>
	 <cfcase value="invoiceID_d,invoiceDateClosed_d,invoiceTotal_d,invoiceShippingMethod_d,invoiceDateUpdated_d,invoiceTotalLineItem_d,invoiceTotalShipping_d,invoiceTotalPaymentCredit_d,invoiceDateDue_d,invoiceStatus_d,invoicePaid_d"><cfset queryParameters_orderBy = "avInvoice.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	 <cfcase value="companyName"><cfset queryParameters_orderBy = "avCompany.companyName, avSubscriber.subscriberName"></cfcase>
	 <cfcase value="companyName_d"><cfset queryParameters_orderBy = "avCompany.companyName DESC, avSubscriber.subscriberName DESC"></cfcase>
	 <cfcase value="lastName"><cfset queryParameters_orderBy = "avUser.lastName, avUser.firstName"></cfcase>
	 <cfcase value="lastName_d"><cfset queryParameters_orderBy = "avUser.lastName DESC, avUser.firstName DESC"></cfcase>
	 <cfcase value="invoiceClosed"><cfset queryParameters_orderBy = "avInvoice.invoiceClosed DESC, avInvoice.invoiceDateClosed"></cfcase>
	 <cfcase value="invoiceClosed_d"><cfset queryParameters_orderBy = "avInvoice.invoiceClosed, avInvoice.invoiceDateClosed DESC"></cfcase>
	 <cfcase value="invoiceCompleted,invoiceDateCompleted"><cfset queryParameters_orderBy = "avInvoice.invoiceCompleted DESC, avInvoice.invoiceDateCompleted"></cfcase>
	 <cfcase value="invoiceCompleted_d,invoiceDateCompleted_d"><cfset queryParameters_orderBy = "avInvoice.invoiceCompleted, avInvoice.invoiceDateCompleted DESC"></cfcase>
	 <cfcase value="invoiceID_custom"><cfset queryParameters_orderBy = "avInvoice.invoiceID_custom"></cfcase>
	 <cfcase value="invoiceID_custom_d"><cfset queryParameters_orderBy = "avInvoice.invoiceID_custom DESC"></cfcase>
	 <cfcase value="invoiceShipped"><cfset queryParameters_orderBy = "avInvoice.invoiceShipped DESC, avInvoice.invoiceDateCompleted"></cfcase>
	 <cfcase value="invoiceShipped_d"><cfset queryParameters_orderBy = "avInvoice.invoiceShipped, avInvoice.invoiceDateCompleted DESC"></cfcase>
	 <cfcase value="invoiceDateCreated"><cfset queryParameters_orderBy = "avInvoice.invoiceID"></cfcase>
	 <cfcase value="invoiceDateCreated_d"><cfset queryParameters_orderBy = "avInvoice.invoiceID DESC"></cfcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avUser,avCompany,avInvoice,avSubscriber">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectInvoiceList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avInvoice.invoiceID, avInvoice.invoiceClosed, avInvoice.invoiceDateClosed, avInvoice.invoiceSent,
			avInvoice.invoicePaid, avInvoice.invoiceDatePaid, avInvoice.invoiceTotal, avInvoice.invoiceTotalTax,
			avInvoice.invoiceTotalLineItem, avInvoice.invoiceTotalPaymentCredit, avInvoice.invoiceTotalShipping,
			avInvoice.invoiceShipped, avInvoice.subscriberID, avInvoice.invoiceCompleted, avInvoice.invoiceDateCompleted,
			avInvoice.invoiceStatus, avInvoice.invoiceID_custom, avInvoice.invoiceShippingMethod, avInvoice.invoiceDateCreated,
			avInvoice.invoiceDateUpdated, avInvoice.companyID, avInvoice.userID, avInvoice.invoiceManual, avInvoice.invoiceDateDue,
			avInvoice.languageID, avInvoice.userID_author, avInvoice.companyID_author, avInvoice.regionID,
			avInvoice.invoiceInstructions, avInvoice.addressID_shipping, avInvoice.addressID_billing, avInvoice.creditCardID,
			avInvoice.bankID, avInvoice.invoiceIsExported, avInvoice.invoiceDateExported,
			avCompany.companyName, avCompany.companyID_custom,
			avUser.firstName, avUser.lastName, avUser.userID_custom,
			avSubscriber.subscriberName, avSubscriber.subscriberID_custom
		FROM avInvoice
			INNER JOIN avCompany ON avInvoice.companyID = avCompany.companyID
			LEFT OUTER JOIN avUser ON avInvoice.userID = avUser.userID
			LEFT OUTER JOIN avSubscriber ON avInvoice.subscriberID = avSubscriber.subscriberID
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectInvoiceList.cfm">
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectInvoiceList>
</cffunction><!--- /selectInvoiceList --->

<cffunction Name="selectInvoiceCount" Access="public" ReturnType="numeric" Hint="Select total number of invoices in list">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="invoiceDateFrom" Type="date" Required="No">
	<cfargument Name="invoiceDateTo" Type="date" Required="No">
	<cfargument Name="invoiceDateType" Type="string" Required="No">
	<cfargument Name="invoiceTotal_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotal_max" Type="numeric" Required="No">
	<cfargument Name="invoiceClosed" Type="numeric" Required="No">
	<cfargument Name="invoicePaid" Type="string" Required="No">
	<cfargument Name="invoiceDatePaid" Type="date" Required="No">
	<cfargument Name="invoiceShipped" Type="string" Required="No">
	<cfargument Name="invoiceCompleted" Type="numeric" Required="No">
	<cfargument Name="invoiceStatus" Type="numeric" Required="No">
	<cfargument Name="invoiceSent" Type="numeric" Required="No">
	<cfargument Name="invoiceManual" Type="numeric" Required="No">
	<cfargument Name="invoiceShippingMethod" Type="string" Required="No">
	<cfargument Name="invoiceHasMultipleItems" Type="numeric" Required="No">
	<cfargument Name="invoiceHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="invoiceHasCustomID" Type="numeric" Required="No">
	<cfargument Name="invoiceHasInstructions" Type="numeric" Required="No">
	<cfargument Name="invoiceID_not" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="invoiceHasPaymentCredit" Type="numeric" Required="No">
	<cfargument Name="invoiceDatePaid_from" Type="date" Required="No">
	<cfargument Name="invoiceDatePaid_to" Type="date" Required="No">
	<cfargument Name="invoiceDateClosed_from" Type="date" Required="No">
	<cfargument Name="invoiceDateClosed_to" Type="date" Required="No">
	<cfargument Name="invoiceDateCompleted_from" Type="date" Required="No">
	<cfargument Name="invoiceDateCompleted_to" Type="date" Required="No">
	<cfargument Name="invoiceDateDue_from" Type="date" Required="No">
	<cfargument Name="invoiceDateDue_to" Type="date" Required="No">
	<cfargument Name="invoiceDateCreated_from" Type="date" Required="No">
	<cfargument Name="invoiceDateCreated_to" Type="date" Required="No">
	<cfargument Name="invoiceTotalLineItem_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalLineItem_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax_max" Type="numeric" Required="No">
	<cfargument Name="invoiceIsExported" Type="string" Required="No">
	<cfargument Name="invoiceDateExported_from" Type="string" Required="No">
	<cfargument Name="invoiceDateExported_to" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">

	<cfset var qry_selectInvoiceCount = QueryNew("blank")>

	<cfquery Name="qry_selectInvoiceCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(avInvoice.invoiceID) AS totalRecords
		FROM avInvoice
			INNER JOIN avCompany ON avInvoice.companyID = avCompany.companyID
			LEFT OUTER JOIN avUser ON avInvoice.userID = avUser.userID
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectInvoiceList.cfm">
	</cfquery>

	<cfreturn qry_selectInvoiceCount.totalRecords>
</cffunction><!--- /selectInvoiceCount --->
<!--- /functions for viewing list of invoices --->

<cffunction Name="updateInvoiceTotal" Access="public" Output="No" ReturnType="numeric" Hint="Update totals specified invoice (when a line item has changed). Returns invoice total.">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">

	<cfset var qry_selectInvoiceTotal_lineItem = QueryNew("blank")>
	<cfset var qry_selectInvoiceTotal_credit = QueryNew("blank")>
	<cfset var qry_selectInvoiceTotal = QueryNew("blank")>

	<cftransaction>
	<cfquery Name="qry_selectInvoiceTotal_lineItem" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT SUM(invoiceLineItemSubTotal - invoiceLineItemDiscount) AS sumInvoiceLineItemSubTotal,
			SUM(invoiceLineItemTotalTax) AS sumInvoiceLineItemTotalTax
		FROM avInvoiceLineItem
		WHERE invoiceLineItemStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery Name="qry_selectInvoiceTotal_credit" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT SUM(invoicePaymentCreditAmount) AS sumInvoicePaymentCreditAmount
		FROM avInvoicePaymentCredit
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery Name="qry_updateInvoiceTotal" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avInvoice
		SET invoiceTotalLineItem = <cfif Not IsNumeric(qry_selectInvoiceTotal_lineItem.sumInvoiceLineItemSubTotal)>0<cfelse><cfqueryparam Value="#qry_selectInvoiceTotal_lineItem.sumInvoiceLineItemSubTotal#" cfsqltype="cf_sql_money"></cfif>,
			invoiceTotalPaymentCredit = <cfif Not IsNumeric(qry_selectInvoiceTotal_credit.sumInvoicePaymentCreditAmount)>0<cfelse><cfqueryparam Value="#qry_selectInvoiceTotal_credit.sumInvoicePaymentCreditAmount#" cfsqltype="cf_sql_money"></cfif>,
			invoiceTotalTax = <cfif Not IsNumeric(qry_selectInvoiceTotal_lineItem.sumInvoiceLineItemTotalTax)>0<cfelse><cfqueryparam Value="#qry_selectInvoiceTotal_lineItem.sumInvoiceLineItemTotalTax#" cfsqltype="cf_sql_money"></cfif>,
			invoiceDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">;

		UPDATE avInvoice
		SET invoiceTotal = invoiceTotalTax + invoiceTotalLineItem + invoiceTotalShipping - invoiceTotalPaymentCredit
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">;
	</cfquery>
	</cftransaction>

	<cfquery Name="qry_selectInvoiceTotal" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT invoiceTotal
		FROM avInvoice
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif Not IsNumeric(qry_selectInvoiceTotal.invoiceTotal)>
		<cfreturn 0>
	<cfelse>
		<cfreturn qry_selectInvoiceTotal.invoiceTotal>
	</cfif>
</cffunction><!--- /updateInvoiceTotal --->

<!--- Update Export Status --->
<cffunction Name="updateInvoiceIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether invoice records have been exported. Returns True.">
	<cfargument Name="invoiceID" Type="string" Required="Yes">
	<cfargument Name="invoiceIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.invoiceID) or (Arguments.invoiceIsExported is not "" and Not ListFind("0,1", Arguments.invoiceIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateInvoiceIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avInvoice
			SET invoiceIsExported = <cfif Not ListFind("0,1", Arguments.invoiceIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				invoiceDateExported = <cfif Not ListFind("0,1", Arguments.invoiceIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<!--- functions for graphing invoices summary --->
<cffunction name="selectInvoiceList_summary" access="public" output="no" returnType="query">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="invoiceDateFrom" Type="date" Required="No">
	<cfargument Name="invoiceDateTo" Type="date" Required="No">
	<cfargument Name="invoiceDateType" Type="string" Required="No">
	<cfargument Name="invoiceTotal_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotal_max" Type="numeric" Required="No">
	<cfargument Name="invoiceClosed" Type="numeric" Required="No">
	<cfargument Name="invoicePaid" Type="string" Required="No">
	<cfargument Name="invoiceDatePaid" Type="date" Required="No">
	<cfargument Name="invoiceShipped" Type="string" Required="No">
	<cfargument Name="invoiceCompleted" Type="numeric" Required="No">
	<cfargument Name="invoiceStatus" Type="numeric" Required="No">
	<cfargument Name="invoiceSent" Type="numeric" Required="No">
	<cfargument Name="invoiceManual" Type="numeric" Required="No">
	<cfargument Name="invoiceShippingMethod" Type="string" Required="No">
	<cfargument Name="invoiceHasMultipleItems" Type="numeric" Required="No">
	<cfargument Name="invoiceHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="invoiceHasCustomID" Type="numeric" Required="No">
	<cfargument Name="invoiceHasInstructions" Type="numeric" Required="No">
	<cfargument Name="invoiceID_not" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="invoiceHasPaymentCredit" Type="numeric" Required="No">
	<cfargument Name="invoiceDatePaid_from" Type="date" Required="No">
	<cfargument Name="invoiceDatePaid_to" Type="date" Required="No">
	<cfargument Name="invoiceDateClosed_from" Type="date" Required="No">
	<cfargument Name="invoiceDateClosed_to" Type="date" Required="No">
	<cfargument Name="invoiceDateCompleted_from" Type="date" Required="No">
	<cfargument Name="invoiceDateCompleted_to" Type="date" Required="No">
	<cfargument Name="invoiceDateDue_from" Type="date" Required="No">
	<cfargument Name="invoiceDateDue_to" Type="date" Required="No">
	<cfargument Name="invoiceDateCreated_from" Type="date" Required="No">
	<cfargument Name="invoiceDateCreated_to" Type="date" Required="No">
	<cfargument Name="invoiceTotalLineItem_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalLineItem_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax_max" Type="numeric" Required="No">
	<cfargument Name="invoiceIsExported" Type="string" Required="No">
	<cfargument Name="invoiceDateExported_from" Type="string" Required="No">
	<cfargument Name="invoiceDateExported_to" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">

	<cfargument name="invoiceField" type="string" required="yes" hint="invoicePaid,invoiceClosed">
	<cfargument name="returnInvoiceField" type="boolean" required="no" default="True">

	<cfset var qry_selectInvoiceList_summary = QueryNew("blank")>

	<cfif Not ListFind("invoicePaid,invoiceClosed", Arguments.invoiceField)>
		<cfset Arguments.invoiceField = "invoicePaid">
	</cfif>

	<cfquery Name="qry_selectInvoiceList_summary" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			<cfif Arguments.returnInvoiceField is True>avInvoice.#Arguments.invoiceField#,</cfif>
			COUNT(avInvoice.invoiceID) AS countInvoice, SUM(avInvoice.invoiceTotal) AS sumInvoiceTotal,
			SUM(avInvoice.invoiceTotalTax) AS sumInvoiceTotalTax, SUM(avInvoice.invoiceTotalLineItem) AS sumInvoiceTotalLineItem,
			SUM(avInvoice.invoiceTotalPaymentCredit) AS sumInvoiceTotalPaymentCredit, SUM(avInvoice.invoiceTotalShipping) AS sumInvoiceTotalShipping
		FROM avInvoice INNER JOIN avCompany ON avInvoice.companyID = avCompany.companyID
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectInvoiceList.cfm">
		<cfif Arguments.returnInvoiceField is True>
			GROUP BY avInvoice.#Arguments.invoiceField#
			ORDER BY avInvoice.#Arguments.invoiceField#
		</cfif>
	</cfquery>

	<cfreturn qry_selectInvoiceList_summary>
</cffunction><!--- /selectInvoiceList_summary --->

<cffunction name="selectInvoiceList_product" access="public" output="no" returnType="query">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="invoiceDateFrom" Type="date" Required="No">
	<cfargument Name="invoiceDateTo" Type="date" Required="No">
	<cfargument Name="invoiceDateType" Type="string" Required="No">
	<cfargument Name="invoiceTotal_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotal_max" Type="numeric" Required="No">
	<cfargument Name="invoiceClosed" Type="numeric" Required="No">
	<cfargument Name="invoicePaid" Type="string" Required="No">
	<cfargument Name="invoiceDatePaid" Type="date" Required="No">
	<cfargument Name="invoiceShipped" Type="string" Required="No">
	<cfargument Name="invoiceCompleted" Type="numeric" Required="No">
	<cfargument Name="invoiceStatus" Type="numeric" Required="No">
	<cfargument Name="invoiceSent" Type="numeric" Required="No">
	<cfargument Name="invoiceManual" Type="numeric" Required="No">
	<cfargument Name="invoiceShippingMethod" Type="string" Required="No">
	<cfargument Name="invoiceHasMultipleItems" Type="numeric" Required="No">
	<cfargument Name="invoiceHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="invoiceHasCustomID" Type="numeric" Required="No">
	<cfargument Name="invoiceHasInstructions" Type="numeric" Required="No">
	<cfargument Name="invoiceID_not" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="invoiceHasPaymentCredit" Type="numeric" Required="No">
	<cfargument Name="invoiceDatePaid_from" Type="date" Required="No">
	<cfargument Name="invoiceDatePaid_to" Type="date" Required="No">
	<cfargument Name="invoiceDateClosed_from" Type="date" Required="No">
	<cfargument Name="invoiceDateClosed_to" Type="date" Required="No">
	<cfargument Name="invoiceDateCompleted_from" Type="date" Required="No">
	<cfargument Name="invoiceDateCompleted_to" Type="date" Required="No">
	<cfargument Name="invoiceDateDue_from" Type="date" Required="No">
	<cfargument Name="invoiceDateDue_to" Type="date" Required="No">
	<cfargument Name="invoiceDateCreated_from" Type="date" Required="No">
	<cfargument Name="invoiceDateCreated_to" Type="date" Required="No">
	<cfargument Name="invoiceTotalLineItem_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalLineItem_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax_max" Type="numeric" Required="No">
	<cfargument Name="invoiceIsExported" Type="string" Required="No">
	<cfargument Name="invoiceDateExported_from" Type="string" Required="No">
	<cfargument Name="invoiceDateExported_to" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">

	<cfargument Name="productID_not" Type="string" Required="No">
	<cfargument name="queryDisplayPerPage" type="numeric" required="no" hint="0">
	<cfargument name="queryOrderBy" type="string" required="no" default="countInvoiceLineItem_d" hint="countInvoiceLineItem_d,sumInvoiceLineItemTotal_d">

	<cfset var qry_selectInvoiceList_product = QueryNew("blank")>

	<cfquery Name="qry_selectInvoiceList_product" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif Application.billingDatabase is "MSSQLServer" and Arguments.queryDisplayPerPage is not 0>TOP #Arguments.queryDisplayPerPage#</cfif>
			<cfif Not StructKeyExists(Arguments, "productID_not")>avInvoiceLineItem.productID,</cfif>
			COUNT(avInvoiceLineItem.productID) AS countInvoiceLineItem,
			SUM(avInvoiceLineItem.invoiceLineItemTotal) AS sumInvoiceLineItemTotal
			<cfif Not StructKeyExists(Arguments, "productID_not")>, avProduct.productName</cfif>
		FROM avInvoiceLineItem 
			<cfif Not StructKeyExists(Arguments, "productID_not")>LEFT OUTER JOIN avProduct ON avInvoiceLineItem.productID = avProduct.productID</cfif>
		WHERE 
			<cfif StructKeyExists(Arguments, "productID_not")>
				avInvoiceLineItem.productID NOT IN (<cfqueryparam value="#Arguments.productID_not#" cfsqltype="cf_sql_integer" list="yes">)
				AND 
			</cfif>
			avInvoiceLineItem.invoiceID IN
				(
				SELECT avInvoice.invoiceID
				FROM avInvoice INNER JOIN avCompany ON avInvoice.companyID = avCompany.companyID
				WHERE 
					<cfinclude template="dataShared/qryWhere_selectInvoiceList.cfm">
				)
		<cfif Not StructKeyExists(Arguments, "productID_not")>
			GROUP BY avInvoiceLineItem.productID, avProduct.productName
			ORDER BY 
				<cfswitch expression="#Arguments.queryOrderBy#">
				 <cfcase value="countInvoiceLineItem_d">countInvoiceLineItem DESC</cfcase>
				 <cfcase value="sumInvoiceLineItemTotal_d">sumInvoiceLineItemTotal DESC</cfcase>
				 <cfdefaultcase>countInvoiceLineItem DESC</cfdefaultcase>
				</cfswitch>
		</cfif>
		<cfif Application.billingDatabase is "MySQL" and Arguments.queryDisplayPerPage is not 0>LIMIT #Arguments.queryDisplayPerPage#</cfif>
	</cfquery>

	<cfreturn qry_selectInvoiceList_product>
</cffunction><!--- /selectInvoiceList_product --->

<cffunction name="selectInvoiceList_address" access="public" output="no" returnType="query">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="invoiceDateFrom" Type="date" Required="No">
	<cfargument Name="invoiceDateTo" Type="date" Required="No">
	<cfargument Name="invoiceDateType" Type="string" Required="No">
	<cfargument Name="invoiceTotal_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotal_max" Type="numeric" Required="No">
	<cfargument Name="invoiceClosed" Type="numeric" Required="No">
	<cfargument Name="invoicePaid" Type="string" Required="No">
	<cfargument Name="invoiceDatePaid" Type="date" Required="No">
	<cfargument Name="invoiceShipped" Type="string" Required="No">
	<cfargument Name="invoiceCompleted" Type="numeric" Required="No">
	<cfargument Name="invoiceStatus" Type="numeric" Required="No">
	<cfargument Name="invoiceSent" Type="numeric" Required="No">
	<cfargument Name="invoiceManual" Type="numeric" Required="No">
	<cfargument Name="invoiceShippingMethod" Type="string" Required="No">
	<cfargument Name="invoiceHasMultipleItems" Type="numeric" Required="No">
	<cfargument Name="invoiceHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="invoiceHasCustomID" Type="numeric" Required="No">
	<cfargument Name="invoiceHasInstructions" Type="numeric" Required="No">
	<cfargument Name="invoiceID_not" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="invoiceHasPaymentCredit" Type="numeric" Required="No">
	<cfargument Name="invoiceDatePaid_from" Type="date" Required="No">
	<cfargument Name="invoiceDatePaid_to" Type="date" Required="No">
	<cfargument Name="invoiceDateClosed_from" Type="date" Required="No">
	<cfargument Name="invoiceDateClosed_to" Type="date" Required="No">
	<cfargument Name="invoiceDateCompleted_from" Type="date" Required="No">
	<cfargument Name="invoiceDateCompleted_to" Type="date" Required="No">
	<cfargument Name="invoiceDateDue_from" Type="date" Required="No">
	<cfargument Name="invoiceDateDue_to" Type="date" Required="No">
	<cfargument Name="invoiceDateCreated_from" Type="date" Required="No">
	<cfargument Name="invoiceDateCreated_to" Type="date" Required="No">
	<cfargument Name="invoiceTotalLineItem_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalLineItem_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalPaymentCredit_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalShipping_max" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax_min" Type="numeric" Required="No">
	<cfargument Name="invoiceTotalTax_max" Type="numeric" Required="No">
	<cfargument Name="invoiceIsExported" Type="string" Required="No">
	<cfargument Name="invoiceDateExported_from" Type="string" Required="No">
	<cfargument Name="invoiceDateExported_to" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">

	<cfargument name="country" Type="string" Required="No">
	<cfargument name="country_isNull" Type="boolean" Required="No">
	<cfargument name="state_not" Type="string" Required="No">
	<cfargument name="country_not" Type="string" Required="No">
	<cfargument name="addressField" Type="string" Required="No" default="state" hint="state,country">
	<cfargument name="returnAddressField" type="boolean" required="no" default="True">
	<cfargument name="queryDisplayPerPage" type="numeric" required="no" default="0">
	<cfargument name="queryOrderBy" Type="string" Required="No" default="countInvoice_d" hint="countInvoice_d,sumInvoiceTotal_d">

	<cfset var qry_selectInvoiceList_address = QueryNew("blank")>

	<cfif Not ListFind("state,country", Arguments.addressField)>
		<cfset Arguments.addressField = "state">
	</cfif>

	<cfquery Name="qry_selectInvoiceList_address" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif Application.billingDatabase is "MSSQLServer" and Arguments.queryDisplayPerPage is not 0>TOP #Arguments.queryDisplayPerPage#</cfif>
			<cfif Arguments.returnAddressField is True>avAddress.#Arguments.addressField#,</cfif>
			COUNT(avInvoice.invoiceID) AS countInvoice, SUM(avInvoice.invoiceTotal) AS sumInvoiceTotal,
			SUM(avInvoice.invoiceTotalTax) AS sumInvoiceTotalTax, SUM(avInvoice.invoiceTotalLineItem) AS sumInvoiceTotalLineItem,
			SUM(avInvoice.invoiceTotalPaymentCredit) AS sumInvoiceTotalPaymentCredit, SUM(avInvoice.invoiceTotalShipping) AS sumInvoiceTotalShipping
		FROM avInvoice INNER JOIN avCompany ON avInvoice.companyID = avCompany.companyID
			LEFT OUTER JOIN avAddress ON avInvoice.companyID = avAddress.companyID
				AND avAddress.addressStatus = 1
				AND avAddress.addressTypeBilling = 1
				<cfif StructKeyExists(Arguments, "country") and Arguments.country is not "">
					AND (
						avAddress.country IN (<cfqueryparam value="#Arguments.country#" cfsqltype="cf_sql_varchar" list="yes">)
						<cfif StructKeyExists(Arguments, "country_isNull") and Arguments.country_isNull is True>OR avAddress.country = ''</cfif>
						)
				</cfif>
				<cfif StructKeyExists(Arguments, "state_not") and Arguments.state_not is not "">
					AND avAddress.state NOT IN (<cfqueryparam value="#Arguments.state_not#" cfsqltype="cf_sql_varchar" list="yes">)
				</cfif>
				<cfif StructKeyExists(Arguments, "country_not") and Arguments.country_not is not "">
					AND avAddress.country NOT IN (<cfqueryparam value="#Arguments.country_not#" cfsqltype="cf_sql_varchar" list="yes">)
				</cfif>
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectInvoiceList.cfm">
		<cfif Arguments.returnAddressField is True>
			GROUP BY avAddress.#Arguments.addressField#
			ORDER BY 
				<cfswitch expression="#Arguments.queryOrderBy#">
				 <cfcase value="countInvoice_d">countInvoice DESC</cfcase>
				 <cfcase value="sumInvoiceTotal_d">sumInvoiceTotal DESC</cfcase>
				 <cfdefaultcase>countInvoice DESC</cfdefaultcase>
				</cfswitch>
		</cfif>
		<cfif Application.billingDatabase is "MySQL" and Arguments.queryDisplayPerPage is not 0>LIMIT #Arguments.queryDisplayPerPage#</cfif>
	</cfquery>

	<cfreturn qry_selectInvoiceList_address>
</cffunction><!--- /selectInvoiceList_address --->

</cfcomponent>
