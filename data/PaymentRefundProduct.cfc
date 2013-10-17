<cfcomponent DisplayName="PaymentRefundProduct" Hint="Relates refunds to a particular product">

<!--- Payment Refund Product/Subscription/Invoice Line Item --->
<cffunction Name="insertPaymentRefundProduct" Access="public" ReturnType="boolean" Hint="Inserts product as source of payment refund.">
	<cfargument Name="paymentID" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="Yes">

	<cfquery Name="qry_insertPaymentRefundProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPaymentRefundProduct
		(
			paymentID, productID, subscriptionID, invoiceLineItemID
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="deletePaymentRefundProduct" Access="public" ReturnType="boolean" Hint="Deletes product as source of payment refund.">
	<cfargument Name="paymentID" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deletePaymentRefundProduct" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avPaymentRefundProduct
		WHERE paymentID = <cfqueryparam Value="#Arguments.paymentID#" cfsqltype="cf_sql_integer">
			AND productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
			AND invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPaymentRefundProductList" Access="public" ReturnType="query" Hint="Selects products that are sources of payment refunds.">
	<cfargument Name="paymentID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="returnInvoiceLineItemFields" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnSubscriptionFields" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnProductFields" Type="boolean" Required="No" Default="False">
	<cfargument Name="returnPaymentRefundFields" Type="boolean" Required="No" Default="False">

	<cfset var displayAnd = False>
	<cfset var qry_selectPaymentRefundProductList = QueryNew("blank")>

	<cfif (StructKeyExists(Arguments, "paymentID") and Application.fn_IsIntegerList(Arguments.paymentID))
			or (StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID))
			or (StructKeyExists(Arguments, "subscriptionID") and Application.fn_IsIntegerList(Arguments.subscriptionID))
			or (StructKeyExists(Arguments, "invoiceLineItemID") and Application.fn_IsIntegerList(Arguments.invoiceLineItemID))>
		<cfquery Name="qry_selectPaymentRefundProductList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT avPaymentRefundProduct.paymentID, avPaymentRefundProduct.productID,
				avPaymentRefundProduct.subscriptionID, avPaymentRefundProduct.invoiceLineItemID
				<cfif StructKeyExists(Arguments, "returnPaymentRefundFields") and Arguments.returnPaymentRefundFields is True>
					, avPayment.paymentManual, avPayment.creditCardID, avPayment.bankID, avPayment.merchantAccountID,
					avPayment.paymentCheckNumber, avPayment.paymentID_custom, avPayment.paymentStatus, avPayment.paymentApproved,
					avPayment.paymentAmount, avPayment.paymentDescription, avPayment.paymentMessage, avPayment.paymentMethod,
					avPayment.paymentProcessed, avPayment.paymentDateReceived, avPayment.paymentDateScheduled, avPayment.paymentCategoryID
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
			FROM avPaymentRefundProduct
				<cfif StructKeyExists(Arguments, "returnPaymentRefundFields") and Arguments.returnPaymentRefundFields is True>LEFT OUTER JOIN avPayment ON avPaymentRefundProduct.paymentID = avPayment.paymentID</cfif>
				<cfif StructKeyExists(Arguments, "returnProductFields") and Arguments.returnProductFields is True>LEFT OUTER JOIN avProduct ON avPaymentRefundProduct.productID = avProduct.productID</cfif>
				<cfif StructKeyExists(Arguments, "returnSubscriptionFields") and Arguments.returnSubscriptionFields is True>LEFT OUTER JOIN avSubscription ON avPaymentRefundProduct.subscriptionID = avSubscription.subscriptionID</cfif>
				<cfif StructKeyExists(Arguments, "returnInvoiceLineItemFields") and Arguments.returnInvoiceLineItemFields is True>LEFT OUTER JOIN avInvoiceLineItem ON avPaymentRefundProduct.invoiceLineItemID = avInvoiceLineItem.invoiceLineItemID</cfif>
			WHERE 
				<cfloop Index="field" List="paymentID,productID,subscriptionID,invoiceLineItemID">
					<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
						<cfif displayAnd is True> AND <cfelse><cfset displayAnd = True></cfif>
						avPaymentRefundProduct.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					</cfif>
				</cfloop>
		</cfquery>
	<cfelse>
		<cfset qry_selectPaymentRefundProductList = QueryNew("paymentID,productID,subscriptionID,invoiceLineItemID")>
	</cfif>

	<cfreturn qry_selectPaymentRefundProductList>
</cffunction>

</cfcomponent>
