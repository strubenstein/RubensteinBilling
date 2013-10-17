<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<productID_custom>>", qry_selectProduct.productID_custom, "ALL")>
<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<productName>>", qry_selectProduct.productName, "ALL")>

<cfif qry_selectProduct.productID_parent is 0>
	<cfset Variables.urlProductID = URL.productID>
<cfelse>
	<cfset Variables.urlProductID = qry_selectProduct.productID>
</cfif>

<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<productURL>>", "#Application.billingUrl#/product.cfm?productID=#Variables.urlProductID#", "ALL")>
