<!--- 
Determine productID if submitted from a form
If child, get parent to get parameters if necessary
Determine appropriate price
	normal price
	custom price
	volume discount
If parameters:
	Verify that parameters exist
	Validate parameter options are valid
	parent product or child product
	Generate custom productID based on parameters if necessary
	Store parameters in cart
	Store parameters in database
Display cart/add to cart
	parameters
	custom ID
	custom description including parameters
Update cart
	find item with same productID and same parameter options
	parameters
	custom ID
	if volume discount and quantity changed, update price
--->

<cfparam Name="URL.action" Default="viewCart">

<cfif Not StructKeyExists(Session, "shoppingCart")>
	<cflock Scope="Session" Timeout="10">
		<cfset Session.shoppingCart = ArrayNew(1)>
	</cflock>
</cfif>

<cfswitch expression="#URL.action#">
<cfcase value="addToCart">
	<cfinclude template="act_addToCart.cfm">
</cfcase>

<cfcase value="updateCart">
	<cfinclude template="act_updateCart.cfm">
</cfcase>

<cfcase value="removeFromCart">
	<cfif IsDefined("URL.productID") and IsNumeric(URL.productID)>
		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" Method="deleteItemFromCart">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfif IsDefined("URL.productParameterOptionID_list")>
				<cfinvokeargument Name="productParameterOptionID_list" Value="#URL.productParameterOptionID_list#">
			<cfelse>
				<cfinvokeargument Name="productParameterOptionID_list" Value="">
			</cfif>
		</cfinvoke>
	</cfif>

	<cflocation url="index.cfm?method=cart.viewCart" AddToken="No">
</cfcase>

<cfcase value="clearCart">
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" Method="deleteAllItemsFromCart" />
	<cflocation url="index.cfm?method=cart.viewCart" AddToken="No">
</cfcase>

<cfdefaultcase><!--- viewCart --->
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" Method="viewCartItemList" />
</cfdefaultcase>
</cfswitch>
