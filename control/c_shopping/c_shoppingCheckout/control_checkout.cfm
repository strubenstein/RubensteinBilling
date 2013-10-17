<!--- 
CHECKOUT PROCESS:

1. Account options:
*	- Use fax order form
	- Login to existing account
	- Register for new account
*	- Order without registering
2. Shipping address
	- Select existing shipping address
	- Add new shipping address
3. Billing information
	- Select existing billing information
		- Billing address
		- Credit card
*		- Existing company account
*		- Gift certificate, other credit
	- Add new billing information
4. Confirm order, shipping and billing info
5. Submit order
	- Send email notification to buyer
	- Send email notification to seller

what is logged in and receives custom pricing?
populate cart via saved invoice
update invoice to reflect it is confirmed/submitted
store abandonded carts that were saved in process?
update existing address
select credit card and billing address separately?
--->

<cfif Session.userID is 0><!--- not already logged in --->
	<cfparam Name="URL.action" Default="register">
<cfelse>
	<cfparam Name="URL.action" Default="shipping">
</cfif>

<cfif Not ListFind("register,shipping,billing,fax,confirm", URL.action)>
	<cfset URL.action = "register">
</cfif>
<cfset Variables.doAction = URL.action>

<cfif Not StructKeyExists(Session, "shoppingCart") or Not IsArray(Session.shoppingCart) or ArrayLen(Session.shoppingCart) is 0>
	<cfset Variables.doAction = "error">
	<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/dsp_checkoutCartIsEmpty.cfm">
</cfif>

<cfif Variables.doAction is "fax">
	<cfinclude template="../c_shoppingCart/act_setAllCartInfo.cfm">
	<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/dsp_checkoutFax.cfm">
</cfif>

<cfif Variables.doAction is "register" or Session.userID is 0>
	<cfset Variables.formAction = Application.billingSecureUrl & "/index.cfm?method=checkout.register">
	<cfinclude template="control_checkoutRegister.cfm">
	<!--- insert invoice and line items into database if not there already! --->
</cfif>

<cfif (Not StructKeyExists(Session, "invoiceID") or Session.invoiceID is 0 or Variables.doAction is "shipping") and Session.userID gt 0>
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" Method="saveCartToDatabase" ReturnVariable="invoiceID">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfif StructKeyExists(Session, "invoiceID") and Session.invoiceID is not 0>
			<cfinvokeargument Name="invoiceID" Value="#Session.invoiceID#">
		</cfif>
	</cfinvoke>

	<cfif Not StructKeyExists(Session, "invoiceID") or Session.invoiceID is 0>
		<cflock Scope="Session" Timeout="5">
			<cfset Session.invoiceID = invoiceID>
		</cflock>
	</cfif>
</cfif>

<cfif Variables.doAction is "shipping">
	<cfset Variables.formAction = Application.billingSecureUrl & "/index.cfm?method=checkout.shipping">
	<cfinclude template="control_checkoutShipping.cfm">
</cfif>

<cfif Variables.doAction is "billing">
	<cfset Variables.formAction = Application.billingSecureUrl & "/index.cfm?method=checkout.billing">
	<cfinclude template="control_checkoutBilling.cfm">
</cfif>

<cfif Variables.doAction is "confirm">
	<cfset Variables.formAction = Application.billingSecureUrl & "/index.cfm?method=checkout.confirm">
	<cfinclude template="control_checkoutConfirm.cfm">
</cfif>

