<cfif IsArray(theShoppingCart) and ArrayLen(theShoppingCart) gt 0>
	<cfset qry_selectProductsInCart = selectProductsInCart()>

	<!--- 
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="checkForShoppingCartInvoice" ReturnVariable="invoiceID">
		<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="userID_author" Value="0">
		<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="invoiceClosed" Value="0">
		<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
		<cfinvokeargument Name="invoiceStatus" Value="1">
	</cfinvoke>

	<cfif qry_checkForShoppingCartInvoice.RecordCount is 0>
	--->

	<cfif Arguments.invoiceID is 0>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="insertInvoice" ReturnVariable="newInvoiceID">
			<cfinvokeargument Name="userID" Value="#Arguments.userID#">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
			<cfinvokeargument Name="userID_author" Value="0">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		</cfinvoke>
		<cfset realInvoiceID = newInvoiceID>
	<cfelse>
		<!--- <cfset invoiceID = qry_checkForShoppingCartInvoice.invoiceID> --->
		<cfset realInvoiceID = Arguments.invoiceID>
		<!--- 
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
			<cfinvokeargument Name="invoiceID" Value="#realInvoiceID#">
		</cfinvoke>
		--->
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="updateInvoiceLineItemStatus" ReturnVariable="qry_selectInvoiceLineItemList">
			<cfinvokeargument Name="invoiceID" Value="#realInvoiceID#">
			<cfinvokeargument Name="invoiceLineItemStatus" Value="0">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="selectInvoicePaymentCreditList" ReturnVariable="qry_selectInvoicePaymentCreditList">
			<cfinvokeargument Name="invoiceID" Value="#realInvoiceID#">
		</cfinvoke>

		<cfif qry_selectInvoicePaymentCreditList.RecordCount is not 0>
			<cfquery Name="qry_deleteInvoicePaymentCredit" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				DELETE FROM avInvoicePaymentCredit WHERE invoicePaymentCreditID IN (<cfqueryparam Value="#ValueList(qry_selectInvoicePaymentCreditList.invoicePaymentCreditID)#" List="Yes" Separator=",">)
			</cfquery>
			<cfquery Name="qry_deletePaymentCredit" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				DELETE FROM avPaymentCredit WHERE paymentCreditID IN (<cfqueryparam Value="#ValueList(qry_selectInvoicePaymentCreditList.paymentCreditID)#" List="Yes" Separator=",">)
			</cfquery>
		</cfif>
	</cfif>

	<cfloop Index="count" From="1" To="#ArrayLen(theShoppingCart)#">
		<cfset invoiceLineItemTotal = theShoppingCart[count].invoiceLineItemQuantity * theShoppingCart[count].invoiceLineItemPriceUnit>

		<cfif qry_selectProductsInCart.productParameters[count] is "">
			<cfset invoiceLineItemName = qry_selectProductsInCart.productLanguageLineItemName[count]>
		<cfelse>
			<cfset invoiceLineItemName = qry_selectProductsInCart.productLanguageLineItemName[count] & "<br>" & qry_selectProductsInCart.productParameters[count]>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="insertInvoiceLineItem" ReturnVariable="invoiceLineItemID">
			<cfinvokeargument Name="invoiceID" Value="#realInvoiceID#">
			<cfinvokeargument Name="userID_author" Value="#Arguments.userID#">
			<cfinvokeargument Name="productID" Value="#theShoppingCart[count].productID#">
			<cfinvokeargument Name="priceID" Value="#theShoppingCart[count].priceID#">
			<cfinvokeargument Name="productParameterExceptionID" Value="#theShoppingCart[count].productParameterExceptionID#">
			<cfinvokeargument Name="invoiceLineItemProductID_custom" Value="#theShoppingCart[count].invoiceLineItemProductID_custom#">
			<cfinvokeargument Name="invoiceLineItemPriceUnit" Value="#theShoppingCart[count].invoiceLineItemPriceUnit#">
			<cfinvokeargument Name="invoiceLineItemQuantity" Value="#theShoppingCart[count].invoiceLineItemQuantity#">
			<!--- 
			<cfinvokeargument Name="invoiceLineItemSubTotal" Value="#invoiceLineItemTotal#">
			<cfinvokeargument Name="invoiceLineItemTotal" Value="#invoiceLineItemTotal#">
			--->
			<cfinvokeargument Name="invoiceLineItemProductInBundle" Value="0">
			<cfinvokeargument Name="invoiceLineItemName" Value="#Variables.invoiceLineItemName#">
			<cfinvokeargument Name="invoiceLineItemDescription" Value="#qry_selectProductsInCart.productLanguageLineItemDescription[count]#">
			<cfinvokeargument Name="invoiceLineItemDescriptionHtml" Value="#qry_selectProductsInCart.productLanguageLineItemDescriptionHtml[count]#">
			<cfinvokeargument Name="invoiceLineItemProductIsBundle" Value="#qry_selectProductsInCart.productIsBundle[count]#">
		</cfinvoke>

		<cfif StructKeyExists(theShoppingCart[count], "productParameterOptionID_list") and theShoppingCart[count].productParameterOptionID_list is not "">
			<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="insertInvoiceLineItemParameter" ReturnVariable="isInvoiceLineItemParameterInserted">
				<cfinvokeargument Name="invoiceLineItemID" Value="#invoiceLineItemID#">
				<cfinvokeargument Name="productParameterOptionID" Value="#theShoppingCart[count].productParameterOptionID_list#">
				<cfinvokeargument Name="deleteExistingLineItemParameter" Value="True">
			</cfinvoke>
		</cfif>
	</cfloop>

	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getInvoiceTotalLineItemInCart" returnVariable="invoiceTotalLineItem" />
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getInvoiceTotalPaymentCreditInCart" returnVariable="invoiceTotalPaymentCredit" />
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getInvoiceTotalTaxInCart" returnVariable="invoiceTotalTax" />
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getInvoiceTotalShippingInCart" returnVariable="invoiceTotalShipping" />
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getInvoiceTotalInCart" returnVariable="invoiceTotal" />

	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
		<cfinvokeargument Name="invoiceID" Value="#realInvoiceID#">
		<cfinvokeargument Name="invoiceTotal" Value="#Variables.invoiceTotal#">
		<cfinvokeargument Name="invoiceTotalLineItem" Value="#Variables.invoiceTotalLineItem#">
		<cfinvokeargument Name="invoiceTotalTax" Value="#Variables.invoiceTotalTax#">
		<cfinvokeargument Name="invoiceTotalShipping" Value="#Variables.invoiceTotalShipping#">
	</cfinvoke>

	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" Method="selectPaymentCreditsInCart" ReturnVariable="qry_selectPaymentCreditsInCart" />

	<cfloop Query="qry_selectPaymentCreditsInCart">
		<cfinvoke Component="#Application.billingMapping#data.PaymentCredit" Method="insertPaymentCredit" ReturnVariable="newPaymentCreditID">
			<cfinvokeargument Name="userID_author" Value="0">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="paymentCreditAmount" Value="#qry_selectPaymentCreditsInCart.paymentCreditAmount#">
			<cfinvokeargument Name="paymentCreditStatus" Value="1">
			<cfinvokeargument Name="paymentCreditName" Value="#qry_selectPaymentCreditsInCart.paymentCreditName#">
			<cfinvokeargument Name="paymentCreditID_custom" Value="#qry_selectPaymentCreditsInCart.paymentCreditID_custom#">
			<cfinvokeargument Name="paymentCreditAppliedMaximum" Value="1">
			<cfinvokeargument Name="paymentCreditAppliedCount" Value="1">
			<cfinvokeargument Name="paymentCategoryID" Value="#qry_selectPaymentCreditsInCart.paymentCategoryID#">
			<cfinvokeargument Name="paymentCreditCompleted" Value="1">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="insertInvoicePaymentCredit" ReturnVariable="isInvoicePaymentCreditInserted">
			<cfinvokeargument Name="paymentCreditID" Value="#newPaymentCreditID#">
			<cfinvokeargument Name="invoiceID" Value="#realInvoiceID#">
			<cfinvokeargument Name="invoicePaymentCreditManual" Value="0">
			<cfinvokeargument Name="invoicePaymentCreditAmount" Value="#qry_selectPaymentCreditsInCart.paymentCreditAmount#">
			<cfinvokeargument Name="invoicePaymentCreditText" Value="#qry_selectPaymentCreditsInCart.paymentCreditName#">
		</cfinvoke>
	</cfloop>
</cfif>
