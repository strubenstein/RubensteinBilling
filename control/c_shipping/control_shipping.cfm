<!--- 
functionality:
- sent shipping notice/information to customer
- enable tracking via admin and account status
--->

<cfparam Name="URL.shippingID" Default="0">
<cfparam Name="URL.invoiceID" Default="0">
<cfparam Name="URL.invoiceLineItemID" Default="0">

<cfset Variables.shippingActionList = "index.cfm?method=#URL.control#.listShipping&invoiceID=#URL.invoiceID#">
<cfif URL.invoiceLineItemID is not 0>
	<cfset Variables.shippingActionList = Variables.shippingActionList & "&invoiceLineItemID=#URL.invoiceLineItemID#">
</cfif>

<cfinclude template="security_shipping.cfm">
<cfinclude template="../../view/v_shipping/nav_shipping.cfm">
<cfif IsDefined("URL.confirm_shipping")>
	<cfinclude template="../../view/v_shipping/confirm_shipping.cfm">
</cfif>
<cfif IsDefined("URL.error_shipping")>
	<cfinclude template="../../view/v_shipping/error_shipping.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listShipping">
	<cfinclude template="control_listShipping.cfm">
</cfcase>

<cfcase value="insertShipping,updateShipping">
	<cfinclude template="control_insertUpdateShipping.cfm">

</cfcase>

<cfdefaultcase>
	<cfset URL.error_invoice = "invalidAction">
	<cfinclude template="../../view/v_shipping/error_shipping.cfm">
</cfdefaultcase>
</cfswitch>

