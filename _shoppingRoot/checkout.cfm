<!--- use session variables in ShoppingCart.cfc or pass it in/out? --->
<cfif Not IsDefined("URL.action")>
	<cfif Session.userID is 0><!--- not already logged in --->
		<cfparam Name="URL.action" Default="register">
	<cfelse>
		<cfparam Name="URL.action" Default="shipping">
	</cfif>
</cfif>

<cfif Not StructKeyExists(Session, "shoppingCart") or Not IsArray(Session.shoppingCart) or ArrayLen(Session.shoppingCart) is 0>
	<p class="ErrorMessage">You do not have any items in your cart.</p>
<cfelseif Not ListFind("fax,register,shipping,billing,confirm", URL.action)>
	<p class="ErrorMessage">You did not submit a valid request.</p>
<cfelse>
	<cfinclude template="control/c_shopping/c_shoppingCheckout/control_checkout.cfm">
</cfif>
