<!--- validate quantity --->
<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="checkCartExists" returnVariable="Variables.theShoppingCart" />
<cfset Variables.cartPosition_list = "">
<cfset Variables.priceID_list = "">

<cfif IsDefined("Form.isFormSubmitted")>
	<cfloop INDEX="nextVar" LIST="#StructKeyList(FORM)#">
		<cfset temp = SetVariable("URL.#nextVar#", Form["#nextVar#"])>
	</cfloop>
</cfif>

<!--- loop thru all items in shopping cart --->
<cfloop Index="count" From="1" To="#ArrayLen(Variables.theShoppingCart)#">
	<!--- if valid quantity field exists and has changed --->
	<cfif IsDefined("URL.quantity#Variables.theShoppingCart[count].productID#_#count#")
			and Application.fn_IsIntegerPositive(URL["quantity#Variables.theShoppingCart[count].productID#_#count#"])
			and URL["quantity#Variables.theShoppingCart[count].productID#_#count#"] is not Variables.theShoppingCart[count].invoiceLineItemQuantity>
		<cfset Variables.newQuantity = URL["quantity#Variables.theShoppingCart[count].productID#_#count#"]>
		<cfif Variables.theShoppingCart[count].priceID is 0><!--- price is not custom price --->
			<cfset Variables.newPrice = Variables.theShoppingCart[count].invoiceLineItemPriceUnit>
		<cfelse><!--- price IS custom price --->
			<!--- get normal product price --->
			<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductPrice" ReturnVariable="qry_selectProductPrice">
				<cfinvokeargument Name="productID" Value="#Variables.theShoppingCart[count].productID#">
			</cfinvoke>

			<!--- get custom price --->
			<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectPrice" ReturnVariable="qry_selectPrice">
				<cfinvokeargument Name="priceID" Value="#Variables.theShoppingCart[count].priceID#">
			</cfinvoke>

			<cfif qry_selectPrice.priceStageVolumeDiscount is 0><!--- if not volume discount --->
				<cfswitch expression="#qry_selectPrice.priceStageDollarOrPercent#_#qry_selectPrice.priceStageNewOrDeduction#">
				<cfcase value="0_0"><cfset Variables.newPrice = qry_selectPrice.priceStageAmount></cfcase>
				<cfcase value="0_1"><cfset Variables.newPrice = qry_selectProductPrice.productPrice - qry_selectPrice.priceStageAmount></cfcase>
				<cfcase value="1_0"><cfset Variables.newPrice = qry_selectProductPrice.productPrice * qry_selectPrice.priceStageAmount></cfcase>
				<cfcase value="1_1"><cfset Variables.newPrice = qry_selectProductPrice.productPrice * (1 - qry_selectPrice.priceStageAmount)></cfcase>
				</cfswitch>
			<cfelse><!--- if volume discount --->
				<!--- get volume discount levels --->
				<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectPriceVolumeDiscount" ReturnVariable="qry_selectPriceVolumeDiscount">
					<cfinvokeargument Name="priceID" Value="#Variables.theShoppingCart[count].priceID#">
				</cfinvoke>

				<!--- determine comparison quantity if based on dollar amount or quantity --->
				<cfif qry_selectPrice.priceStageVolumeDollarOrQuantity is 0>
					<cfset Variables.compareQuantity = Variables.newQuantity * qry_selectProductPrice.productPrice>
				<cfelse>
					<cfset Variables.compareQuantity = Variables.newQuantity>
				</cfif>

				<!--- 
				<cfif qry_selectPrice.priceStageVolumeStep is 0><!--- price based on total volume for all quantity --->
				--->
				<cfloop Query="qry_selectPriceVolumeDiscount"><!--- loop thru volume options --->
					<cfif qry_selectPriceVolumeDiscount.CurrentRow is 1
							and ((qry_selectPrice.priceStageVolumeDollarOrQuantity is 1 and Variables.newQuantity lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum))
								or ((qry_selectPrice.priceStageVolumeDollarOrQuantity is 0 and (Variables.newQuantity * qry_selectProductPrice.productPrice) lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum))>
						<cfset Variables.newPrice = qry_selectProductPrice.productPrice>
						<cfbreak>
					<cfelseif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 1
							or qry_selectPriceVolumeDiscount.CurrentRow is qry_selectPriceVolumeDiscount.RecordCount
							or (qry_selectPrice.priceStageVolumeDollarOrQuantity is 1
									and Variables.newQuantity lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow])
							or (qry_selectPrice.priceStageVolumeDollarOrQuantity is 0
									and (Variables.newQuantity * qry_selectProductPrice.productPrice) lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow])>
						<cfset Variables.volumePriceAmount = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount>
						<cfswitch expression="#qry_selectPrice.priceStageNewOrDeduction#_#qry_selectPrice.priceStageDollarOrPercent#">
						<cfcase value="0_0"><cfset Variables.newPrice = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
						<cfcase value="0_1"><cfset Variables.newPrice = qry_selectProductPrice.productPrice * qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
						<cfcase value="1_0"><cfset Variables.newPrice = qry_selectProductPrice.productPrice - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
						<cfcase value="1_1"><cfset Variables.newPrice = qry_selectProductPrice.productPrice * (1 - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)></cfcase>
						</cfswitch>
						<cfbreak>
					</cfif>
				</cfloop><!--- /loop thru volume options --->

				<!--- 
				<cfelse><!--- price based on quantity at each level --->
					<cfset Variables.newPrice = 0>
					<cfset Variables.quantityRemaining = Variables.compareQuantity>

					<cfloop Query="qry_selectPriceVolumeDiscount">
					</cfloop>
				</cfif>
				--->
			</cfif><!--- if is/not volume discount --->
		</cfif><!--- price is/not custom price --->

		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="updateItemInCart">
			<cfinvokeargument Name="productID" Value="#Variables.theShoppingCart[count].productID#">
			<cfinvokeargument Name="invoiceLineItemPriceUnit" Value="#Variables.newPrice#">
			<cfinvokeargument Name="priceID" Value="#Variables.theShoppingCart[count].priceID#">
			<cfinvokeargument Name="invoiceLineItemQuantity" Value="#Variables.newQuantity#">
		</cfinvoke>
	</cfif><!--- /if valid quantity field exists and has changed --->
</cfloop><!--- /loop thru all items in shopping cart --->

<cflocation url="index.cfm?method=cart.viewCart" AddToken="No">
