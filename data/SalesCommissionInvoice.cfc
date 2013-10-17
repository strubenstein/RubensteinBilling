<cfcomponent DisplayName="SalesCommissionInvoice" Hint="Relates the invoices included in each sales commission calculation">

<!--- SalesCommissionInvoice --->
<cffunction name="maxlength_SalesCommissionInvoice" access="public" output="no" returnType="struct">
	<cfset var maxlength_SalesCommissionInvoice = StructNew()>

	<cfset maxlength_SalesCommissionInvoice.salesCommissionInvoiceQuantity = 4>
	<cfset maxlength_SalesCommissionInvoice.salesCommissionInvoiceAmount = 4>

	<cfreturn maxlength_SalesCommissionInvoice>
</cffunction>

<cffunction Name="insertSalesCommissionInvoice" Access="public" Output="No" ReturnType="boolean" Hint="Inserts invoice commission. Returns True.">
	<cfargument Name="salesCommissionID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="No" Default="0">
	<cfargument Name="salesCommissionInvoiceAmount" Type="numeric" Required="No" Default="0">
	<cfargument Name="salesCommissionInvoiceQuantity" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionCustomerID" Type="numeric" Required="No" Default="0">

	<cfinvoke component="#Application.billingMapping#data.SalesCommissionInvoice" method="maxlength_SalesCommissionInvoice" returnVariable="maxlength_SalesCommissionInvoice" />

	<cfquery Name="qry_insertSalesCommissionInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avSalesCommissionInvoice
		(
			salesCommissionID, invoiceID, invoiceLineItemID, commissionCustomerID,
			salesCommissionInvoiceAmount, salesCommissionInvoiceQuantity
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.salesCommissionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.commissionCustomerID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.salesCommissionInvoiceAmount#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.salesCommissionInvoiceQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_SalesCommissionInvoice.salesCommissionInvoiceQuantity#">
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectSalesCommissionInvoice" Access="public" Output="No" ReturnType="query" Hint="Selects invoice related to a sales commission or sales commissions related to an invoice.">
	<cfargument Name="salesCommissionID" Type="string" Required="No">
	<cfargument Name="invoiceID" Type="string" Required="No">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="commissionCustomerID" Type="string" Required="No">

	<cfset var qry_selectSalesCommissionInvoice = QueryNew("blank")>
	<cfset var displayAnd = False>

	<cfif (StructKeyExists(Arguments, "salesCommissionID") and Application.fn_IsIntegerList(Arguments.salesCommissionID)) or (StructKeyExists(Arguments, "invoiceID") and Application.fn_IsIntegerList(Arguments.invoiceID)) or (StructKeyExists(Arguments, "invoiceLineItemID") and Application.fn_IsIntegerList(Arguments.invoiceLineItemID)) or (StructKeyExists(Arguments, "commissionCustomerID") and Application.fn_IsIntegerList(Arguments.commissionCustomerID))>
		<cfquery Name="qry_selectSalesCommissionInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT salesCommissionID, invoiceID, invoiceLineItemID, commissionCustomerID,
				salesCommissionInvoiceAmount, salesCommissionInvoiceQuantity
			FROM avSalesCommissionInvoice
			WHERE
				<cfloop Index="field" List="salesCommissionID,invoiceID,invoiceLineItemID,commissionCustomerID">
					<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
						<cfif displayAnd is True>AND<cfelse><cfset displayAnd = True></cfif>
						#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					</cfif>
				</cfloop>
			ORDER BY salesCommissionID, invoiceID, invoiceLineItemID
		</cfquery>

		<cfreturn qry_selectSalesCommissionInvoice>
	<cfelse>
		<cfreturn QueryNew("blank")>
	</cfif>
</cffunction>

</cfcomponent>