<!--- get custom prices that apply to this product --->
<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="selectPriceListForTarget" ReturnVariable="qry_selectPriceListForTarget">
	<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	<cfelse>
		<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
	</cfif>
	<cfif URL.subscriptionID is not 0 and IsDefined("qry_selectSubscription.priceID") and qry_selectSubscription.priceID is not 0>
		<cfinvokeargument Name="priceID" Value="#qry_selectSubscription.priceID#">
	</cfif>
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfinvokeargument Name="productID_parent" Value="#qry_selectProduct.productID_parent#">
	<cfinvokeargument Name="categoryID" Value="#categoryID_price#">
	<cfinvokeargument Name="categoryID_parent" Value="#categoryID_parentList_price#">
	<cfinvokeargument Name="userID" Value="#qry_selectSubscriber.userID#">
	<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID#">
	<cfinvokeargument Name="returnPriceVolumeDiscountMinimum" Value="False">
</cfinvoke>

<!--- how do we deal with pricing added under now-updated price? --->
<cfif qry_selectPriceListForTarget.RecordCount is not 0>
	<cfset displayCustomPrice = True>
	<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectPriceListForTarget.priceCode))>
		<cfset displayPriceCode = True>
	<cfelse>
		<cfset displayPriceCode = False>
	</cfif>
	<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectPriceListForTarget.priceName))>
		<cfset displayPriceName = True>
	<cfelse>
		<cfset displayPriceName = False>
	</cfif>

	<!--- select volume discount options --->
	<cfif REFindNoCase("[1|y|t]", ValueList(qry_selectPriceListForTarget.priceStageVolumeDiscount))>
		<cfinvoke Component="#Application.billingMapping#data.PriceVolumeDiscount" Method="selectPriceVolumeDiscount" ReturnVariable="qry_selectPriceVolumeDiscount">
			<cfinvokeargument Name="priceStageID" Value="#ValueList(qry_selectPriceListForTarget.priceStageID)#">
		</cfinvoke>

		<cfif qry_selectPriceVolumeDiscount.RecordCount is not 0>
			<cfset displayCustomPriceVolumeDiscount = True>
		</cfif>
	</cfif>

	<!--- if any prices have maximum per company, select current amount per company --->
	<cfif REFind("[1-9]", ValueList(qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer))>
			<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectSumInvoiceLineItemQuantityAtPrice" ReturnVariable="qry_selectQuantityPerCustomer">
			<cfinvokeargument Name="priceID" Value="#ValueList(qry_selectPriceListForTarget.priceID)#">
			<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID#">
			<cfinvokeargument Name="userID" Value="#qry_selectSubscriber.userID#">
		</cfinvoke>

		<cfset quantityMaximumPerCustomer = StructNew()>
		<cfif qry_selectQuantityPerCustomer.RecordCount is not 0>
			<cfset displayPriceQuantityMaximumPerCustomer = True>
			<cfloop Query="qry_selectQuantityPerCustomer">
				<cfif IsNumeric(qry_selectQuantityPerCustomer.sumInvoiceLineItemQuantity)>
					<cfset quantityMaximumPerCustomer["price#qry_selectQuantityPerCustomer.priceID#"] = qry_selectQuantityPerCustomer.sumInvoiceLineItemQuantity>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<!--- if any prices have maximum for all companies, select current amount for all companies --->
	<cfif REFind("[1-9]", ValueList(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers))>
		<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectSumInvoiceLineItemQuantityAtPrice" ReturnVariable="qry_selectQuantityAllCustomers">
			<cfinvokeargument Name="priceID" Value="#ValueList(qry_selectPriceListForTarget.priceID)#">
		</cfinvoke>

		<cfset quantityMaximumAllCustomers = StructNew()>
		<cfif qry_selectQuantityAllCustomers.RecordCount is not 0>
			<cfset displayPriceQuantityMaximumAllCustomers = True>
			<cfloop Query="qry_selectQuantityAllCustomers">
				<cfif IsNumeric(qry_selectQuantityAllCustomers.sumInvoiceLineItemQuantity)>
					<cfset quantityMaximumAllCustomers["price#qry_selectQuantityAllCustomers.priceID#"] = qry_selectQuantityAllCustomers.sumInvoiceLineItemQuantity>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>
