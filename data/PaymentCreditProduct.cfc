<cfcomponent DisplayName="PaymentCreditProduct" Hint="Relates credits to a particular product">

<!--- Payment Credit Product/Subscription/Invoice Line Item --->
<cffunction Name="insertPaymentCreditProduct" Access="public" ReturnType="boolean" Hint="Inserts product as source of payment credit.">
	<cfargument Name="paymentCreditID" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="Yes">

	<cfquery Name="qry_insertPaymentCreditProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPaymentCreditProduct
		(
			paymentCreditID, productID, subscriptionID, invoiceLineItemID
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="deletePaymentCreditProduct" Access="public" ReturnType="boolean" Hint="Deletes product as source of payment credit.">
	<cfargument Name="paymentCreditID" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deletePaymentCreditProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avPaymentCreditProduct
		WHERE paymentCreditID = <cfqueryparam Value="#Arguments.paymentCreditID#" cfsqltype="cf_sql_integer">
			AND productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
			AND invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPaymentCreditProductList" Access="public" ReturnType="query" Hint="Selects products that are sources of payment credits.">
	<cfargument Name="paymentCreditID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="returnInvoiceLineItemFields" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnSubscriptionFields" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnProductFields" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnPaymentCreditFields" Type="boolean" Required="No" Default="False">

	<cfset var displayAnd = False>
	<cfset var qry_selectPaymentCreditProductList = QueryNew("blank")>

	<cfif (StructKeyExists(Arguments, "paymentCreditID") and Application.fn_IsIntegerList(Arguments.paymentCreditID))
			or (StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID))
			or (StructKeyExists(Arguments, "subscriptionID") and Application.fn_IsIntegerList(Arguments.subscriptionID))
			or (StructKeyExists(Arguments, "invoiceLineItemID") and Application.fn_IsIntegerList(Arguments.invoiceLineItemID))>
		<cfquery Name="qry_selectPaymentCreditProductList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT avPaymentCreditProduct.paymentCreditID, avPaymentCreditProduct.productID,
				avPaymentCreditProduct.subscriptionID, avPaymentCreditProduct.invoiceLineItemID
				<cfif StructKeyExists(Arguments, "returnPaymentCreditFields") and Arguments.returnPaymentCreditFields is True>
					, avPaymentCredit.paymentCreditAmount, avPaymentCredit.paymentCreditStatus, avPaymentCredit.paymentCreditName,
					avPaymentCredit.paymentCreditID_custom, avPaymentCredit.paymentCreditDescription, avPaymentCredit.paymentCreditDateBegin,
					avPaymentCredit.paymentCreditDateEnd, avPaymentCredit.paymentCreditAppliedMaximum, avPaymentCredit.paymentCreditAppliedCount,
					avPaymentCredit.paymentCategoryID, avPaymentCredit.paymentCreditRollover, avPaymentCredit.paymentCreditCompleted,
					avPaymentCredit.paymentCreditNegativeInvoice
				</cfif>
				<cfif StructKeyExists(Arguments, "returnProductFields") and Arguments.returnProductFields is True>
					, avProduct.productName, avProduct.productPrice, avProduct.productID_custom
				</cfif>
				<cfif StructKeyExists(Arguments, "returnSubscriptionFields") and Arguments.returnSubscriptionFields is True>
					, avSubscription.subscriptionStatus, avSubscription.subscriptionCompleted, avSubscription.subscriptionDateBegin,
					avSubscription.subscriptionDateEnd, avSubscription.subscriptionQuantity, avSubscription.subscriptionQuantityVaries,
					avSubscription.subscriptionName, avSubscription.subscriptionID_custom, avSubscription.subscriptionPriceNormal,
					avSubscription.subscriptionPriceUnit, avSubscription.subscriptionDiscount, avSubscription.subscriberID
				</cfif>
				<cfif StructKeyExists(Arguments, "returnInvoiceLineItemFields") and Arguments.returnInvoiceLineItemFields is True>
					, avInvoiceLineItem.invoiceLineItemName, avInvoiceLineItem.invoiceLineItemDescription, avInvoiceLineItem.invoiceLineItemDescriptionHtml,
					avInvoiceLineItem.invoiceLineItemQuantity, avInvoiceLineItem.invoiceLineItemPriceUnit, avInvoiceLineItem.invoiceLineItemPriceNormal,
					avInvoiceLineItem.invoiceLineItemSubTotal, avInvoiceLineItem.invoiceLineItemDiscount, avInvoiceLineItem.invoiceLineItemTotal,
					avInvoiceLineItem.invoiceLineItemTotalTax, avInvoiceLineItem.invoiceLineItemStatus, avInvoiceLineItem.invoiceLineItemManual,
					avInvoiceLineItem.invoiceLineItemProductID_custom, avInvoiceLineItem.invoiceLineItemID_parent, avInvoiceLineItem.invoiceLineItemID_trend,
					avInvoiceLineItem.invoiceID, avInvoiceLineItem.invoiceLineItemDateBegin, avInvoiceLineItem.invoiceLineItemDateEnd
				</cfif>
			FROM avPaymentCreditProduct
				<cfif StructKeyExists(Arguments, "returnPaymentCreditFields") and Arguments.returnPaymentCreditFields is True>
					LEFT OUTER JOIN avPaymentCredit ON avPaymentCreditProduct.paymentCreditID = avPaymentCredit.paymentCreditID
				</cfif>
				<cfif StructKeyExists(Arguments, "returnProductFields") and Arguments.returnProductFields is True>
					LEFT OUTER JOIN avProduct ON avPaymentCreditProduct.productID = avProduct.productID
				</cfif>
				<cfif StructKeyExists(Arguments, "returnSubscriptionFields") and Arguments.returnSubscriptionFields is True>
					LEFT OUTER JOIN avSubscription ON avPaymentCreditProduct.subscriptionID = avSubscription.subscriptionID
				</cfif>
				<cfif StructKeyExists(Arguments, "returnInvoiceLineItemFields") and Arguments.returnInvoiceLineItemFields is True>
					LEFT OUTER JOIN avInvoiceLineItem ON avPaymentCreditProduct.invoiceLineItemID = avInvoiceLineItem.invoiceLineItemID
				</cfif>
			WHERE 
				<cfloop Index="field" List="paymentCreditID,productID,subscriptionID,invoiceLineItemID">
					<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
						<cfif displayAnd is True> AND <cfelse><cfset displayAnd = True></cfif>
						avPaymentCreditProduct.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					</cfif>
				</cfloop>
		</cfquery>
	<cfelse>
		<cfset qry_selectPaymentCreditProductList = QueryNew("paymentCreditID,productID,subscriptionID,invoiceLineItemID")>
	</cfif>

	<cfreturn qry_selectPaymentCreditProductList>
</cffunction>

</cfcomponent>
