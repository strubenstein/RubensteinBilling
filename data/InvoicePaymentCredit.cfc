<cfcomponent DisplayName="InvoicePaymentCredit" Hint="Manages the invoice(s) to which a payment credit is applied">

<cffunction name="maxlength_InvoicePaymentCredit" access="public" output="no" returnType="struct">
	<cfset var maxlength_InvoicePaymentCredit = StructNew()>

	<cfset maxlength_InvoicePaymentCredit.invoicePaymentCreditText = 255>
	<cfset maxlength_InvoicePaymentCredit.invoicePaymentCreditAmount = 2>

	<cfreturn maxlength_InvoicePaymentCredit>
</cffunction>

<!--- Invoices the Payment Credit is applied to --->
<cffunction Name="insertInvoicePaymentCredit" Access="public" Output="No" ReturnType="boolean" Hint="Inserts record that payment credit applies to invoice. Returns True.">
	<cfargument Name="paymentCreditID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoicePaymentCreditManual" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoicePaymentCreditAmount" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoicePaymentCreditRolloverPrevious" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoicePaymentCreditRolloverNext" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoicePaymentCreditText" Type="string" Required="No" Default="">

	<cfinvoke component="#Application.billingMapping#data.InvoicePaymentCredit" method="maxlength_InvoicePaymentCredit" returnVariable="maxlength_InvoicePaymentCredit" />

	<cfquery Name="qry_insertInvoicePaymentCredit" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avInvoicePaymentCredit
		(
			invoiceID, paymentCreditID, invoicePaymentCreditManual, userID, invoicePaymentCreditDate, invoicePaymentCreditAmount,
			invoicePaymentCreditRolloverPrevious, invoicePaymentCreditRolloverNext, invoicePaymentCreditText
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoicePaymentCreditManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			<cfqueryparam Value="#Arguments.invoicePaymentCreditAmount#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoicePaymentCreditRolloverPrevious#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.invoicePaymentCreditRolloverNext#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.invoicePaymentCreditText#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_InvoicePaymentCredit.invoicePaymentCreditText#">
		);

		UPDATE avInvoice
		SET invoiceTotalPaymentCredit = 
			(
			SELECT SUM(invoicePaymentCreditAmount)
			FROM avInvoicePaymentCredit
			WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
			)
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">;

		UPDATE avInvoice
		SET invoiceTotal = invoiceTotalTax + invoiceTotalLineItem + invoiceTotalShipping - invoiceTotalPaymentCredit
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">;

		UPDATE avPaymentCredit
		SET paymentCreditAppliedCount = paymentCreditAppliedCount + <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE paymentCreditID = <cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer">;

		UPDATE avPaymentCredit
		SET paymentCreditCompleted = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		WHERE paymentCreditID = <cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer">
			AND (paymentCreditAmount <= <cfqueryparam Value="#Arguments.invoicePaymentCreditAmount#" cfsqltype="cf_sql_money">
				OR paymentCreditAmount >= (SELECT SUM(invoicePaymentCreditAmount) FROM avInvoicePaymentCredit WHERE paymentCreditID = <cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer">)
				OR paymentCreditRollover = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				OR (paymentCreditAppliedMaximum > 0 AND paymentCreditAppliedMaximum <= paymentCreditAppliedCount));
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateInvoicePaymentCredit" Access="public" Output="No" ReturnType="boolean" Hint="Update text of invoice payment credit.">
	<cfargument Name="invoicePaymentCreditID" Type="numeric" Required="Yes">
	<cfargument Name="invoicePaymentCreditText" Type="string" Required="Yes">

	<cfinvoke component="#Application.billingMapping#data.InvoicePaymentCredit" method="maxlength_InvoicePaymentCredit" returnVariable="maxlength_InvoicePaymentCredit" />

	<cfquery Name="qry_updateInvoicePaymentCredit" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avInvoicePaymentCredit
		SET invoicePaymentCreditText = <cfqueryparam Value="#Arguments.invoicePaymentCreditText#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_InvoicePaymentCredit.invoicePaymentCreditText#">
		WHERE invoicePaymentCreditID = <cfqueryparam Value="#Arguments.invoicePaymentCreditID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectInvoicePaymentCredit" Access="public" Output="No" ReturnType="query" Hint="Selects invoice payment credit record.">
	<cfargument Name="invoicePaymentCreditID" Type="numeric" Required="Yes">
	<!--- 
	<cfargument Name="paymentCreditID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	--->

	<cfset var qry_selectInvoicePaymentCredit = QueryNew("blank")>

	<cfquery Name="qry_selectInvoicePaymentCredit" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT invoiceID, paymentCreditID, invoicePaymentCreditManual, userID, invoicePaymentCreditDate,
			invoicePaymentCreditAmount, invoicePaymentCreditRolloverPrevious,
			invoicePaymentCreditRolloverNext, invoicePaymentCreditText
		FROM avInvoicePaymentCredit
		WHERE invoicePaymentCreditID = <cfqueryparam Value="#Arguments.invoicePaymentCreditID#" cfsqltype="cf_sql_integer">
		<!--- 
		invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
		AND paymentCreditID = <cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer">
		--->
	</cfquery>

	<cfreturn qry_selectInvoicePaymentCredit>
</cffunction>

<cffunction Name="selectInvoicePaymentCreditList" Access="public" Output="No" ReturnType="query" Hint="Selects invoice payment credit records for an invoice(s) and/or payment(s).">
	<cfargument Name="paymentCreditID" Type="string" Required="No" Default="0">
	<cfargument Name="invoiceID" Type="string" Required="No" Default="0">
	<cfargument Name="returnInvoiceFields" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnPaymentCreditFields" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectInvoicePaymentCreditList = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.paymentCreditID)>
		<cfset Arguments.paymentCreditID = 0>
	</cfif>

	<cfif Not Application.fn_IsIntegerList(Arguments.invoiceID)>
		<cfset Arguments.invoiceID = 0>
	</cfif>

	<cfquery Name="qry_selectInvoicePaymentCreditList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avInvoicePaymentCredit.invoicePaymentCreditID, avInvoicePaymentCredit.invoiceID, avInvoicePaymentCredit.paymentCreditID,
			avInvoicePaymentCredit.invoicePaymentCreditManual, avInvoicePaymentCredit.invoicePaymentCreditDate,
			avInvoicePaymentCredit.invoicePaymentCreditText, avInvoicePaymentCredit.invoicePaymentCreditAmount,
			avInvoicePaymentCredit.invoicePaymentCreditRolloverPrevious, avInvoicePaymentCredit.invoicePaymentCreditRolloverNext,
			avInvoicePaymentCredit.userID AS invoicePaymentCreditUserID, avUser.firstName, avUser.lastName, avUser.userID_custom
			<cfif Arguments.returnPaymentCreditFields is True>
				, avPaymentCredit.userID AS paymentCreditUserID, avPaymentCredit.companyID AS paymentCreditCompanyID,
				avPaymentCredit.userID_author, avPaymentCredit.companyID_author, avPaymentCredit.paymentCreditAmount,
				avPaymentCredit.paymentCreditStatus, avPaymentCredit.paymentCreditName, avPaymentCredit.paymentCreditID_custom,
				avPaymentCredit.paymentCreditDescription, avPaymentCredit.paymentCreditDateBegin, avPaymentCredit.paymentCreditDateEnd,
				avPaymentCredit.paymentCreditAppliedMaximum, avPaymentCredit.paymentCreditAppliedCount,
				avPaymentCredit.paymentCategoryID, avPaymentCredit.paymentCreditRollover, avPaymentCredit.subscriberID,
				avPaymentCredit.paymentCreditNegativeInvoice, avPaymentCredit.paymentCreditCompleted,
				avPaymentCredit.paymentCreditDateCreated, avPaymentCredit.paymentCreditDateUpdated
			</cfif>
			<cfif Arguments.returnInvoiceFields is True>
				, avInvoice.userID AS invoiceUserID, avInvoice.companyID AS invoiceCompanyID, avInvoice.invoiceDateClosed,
				avInvoice.invoiceTotal, avInvoice.invoiceTotalTax, avInvoice.invoiceTotalLineItem, avInvoice.subscriberID, 
				avInvoice.invoiceTotalPaymentCredit, avInvoice.invoiceTotalShipping, avInvoice.invoiceID_custom,
				avInvoice.invoiceDateCreated, avInvoice.invoiceDateUpdated
			</cfif>
		FROM avInvoicePaymentCredit
			LEFT OUTER JOIN avUser ON avInvoicePaymentCredit.userID = avUser.userID
			<cfif Arguments.returnPaymentCreditFields is True>
				LEFT OUTER JOIN avPaymentCredit ON avInvoicePaymentCredit.paymentCreditID = avPaymentCredit.paymentCreditID
			</cfif>
			<cfif Arguments.returnInvoiceFields is True>
				LEFT OUTER JOIN avInvoice ON avInvoicePaymentCredit.invoiceID = avInvoice.invoiceID
			</cfif>
		WHERE 
		<cfif Arguments.paymentCreditID is not 0 and Arguments.invoiceID is not 0>
			avInvoicePaymentCredit.invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			AND avInvoicePaymentCredit.paymentCreditID IN (<cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			ORDER BY avInvoicePaymentCredit.invoiceID
		<cfelseif Arguments.paymentCreditID is not 0>
			avInvoicePaymentCredit.paymentCreditID IN (<cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			ORDER BY avInvoicePaymentCredit.paymentCreditID
		<cfelseif Arguments.invoiceID is not 0>
			avInvoicePaymentCredit.invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			ORDER BY avInvoicePaymentCredit.invoiceID
		<cfelse>
			avInvoicePaymentCredit.invoiceID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			AND avInvoicePaymentCredit.paymentCreditID = <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
		</cfif>
	</cfquery>

	<cfreturn qry_selectInvoicePaymentCreditList>
</cffunction>

<cffunction Name="deleteInvoicePaymentCredit" Access="public" Output="No" ReturnType="boolean" Hint="Delete record that payment credit applies to invoice. Returns True.">
	<cfargument Name="invoicePaymentCreditID" Type="numeric" Required="Yes">
	<!--- 
	<cfargument Name="paymentCreditID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	--->

	<cfquery Name="qry_updateInvoiceTotalPaymentCredit" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avInvoice
		SET invoiceTotalPaymentCredit = 
			(
			SELECT SUM(invoicePaymentCreditAmount)
			FROM avInvoicePaymentCredit
			WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
				AND invoicePaymentCreditID <> <cfqueryparam Value="#Arguments.invoicePaymentCreditID#" cfsqltype="cf_sql_integer">
			)
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">;

		UPDATE avInvoice
		SET invoiceTotal = invoiceTotalTax + invoiceTotalLineItem + invoiceTotalShipping - invoiceTotalPaymentCredit
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">;

		DELETE FROM avInvoicePaymentCredit
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
			AND invoicePaymentCreditID = <cfqueryparam Value="#Arguments.invoicePaymentCreditID#" cfsqltype="cf_sql_integer">;
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
