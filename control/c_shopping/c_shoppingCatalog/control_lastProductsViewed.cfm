<cfset Variables.lastProductsViewedMaximum = 5>

<cfset Variables.lastProductsViewed_new = Session.lastProductsViewed>

<!--- if product is already in last viewed list, remove it --->
<cfloop Index="count" From="1" To="#ArrayLen(Variables.lastProductsViewed_new)#">
	<cfif Variables.lastProductsViewed_new[count].productID is URL.productID>
		<cfset temp = ArrayDeleteAt(Variables.lastProductsViewed_new, count)>
		<cfbreak>
	</cfif>
</cfloop>

<!--- add to end of list --->
<cfset Variables.newProductViewed = StructNew()>
<cfset Variables.newProductViewed.productID = URL.productID>
<cfset Variables.newProductViewed.productID_custom = qry_selectProduct.productID_custom>
<cfset Variables.newProductViewed.productLanguageName = qry_selectProduct.productLanguageName>

<cfset temp = ArrayAppend(Variables.lastProductsViewed_new, Variables.newProductViewed)>

<!--- if list is at maximum, remove oldest product from list --->
<cfif ArrayLen(Variables.lastProductsViewed_new) gt Variables.lastProductsViewedMaximum>
	<cfset temp = ArrayDeleteAt(Variables.lastProductsViewed_new, 1)>
</cfif>

<!--- 
session variable is updated at end of request so the current 
product is not displayed on its own product page at top of list
--->