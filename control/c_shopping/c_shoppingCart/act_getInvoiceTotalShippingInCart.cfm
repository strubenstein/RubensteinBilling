<!---
Shipping costs
1-2  CD  $7.95
3+ CD's - $9.95
--->

<cfset quantityShipped = 0>
<cfloop Index="count" From="1" To="#ArrayLen(theShoppingCart)#">
	<cfif ListLen(theShoppingCart[count].invoiceLineItemProductID_custom, "-") is 2
			and Left(ListFirst(theShoppingCart[count].invoiceLineItemProductID_custom, "-"), 6) is "course"
			and Application.fn_IsIntegerPositive(Replace(ListFirst(theShoppingCart[count].invoiceLineItemProductID_custom, "-"), "course", "", "ALL"))
			and ListLast(theShoppingCart[count].invoiceLineItemProductID_custom, "-") is "cd">
		<cfset quantityShipped = quantityShipped + theShoppingCart[count].invoiceLineItemQuantity>
	</cfif>
</cfloop>

<cfif quantityShipped lte 0>
	<cfset invoiceTotalShipping = 0>
<cfelseif quantityShipped lte 2><!--- 1-2 --->
	<cfset invoiceTotalShipping = 7.95>
<cfelse><!--- 3+ --->
	<cfset invoiceTotalShipping = 9.95>
</cfif>

