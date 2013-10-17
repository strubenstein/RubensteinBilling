<!--- 
PRODUCTS:
parent product with no children: price and/or call for quote
parent product with children: parent cannot be bought
Assumption: child products do not have volume pricing, only parent products (at least for display purposes)

PRODUCT PAGE ELEMENTS:
category path(s)
product name
vendor name
product price
summary
description
images

add to cart
product specs
product parameters
child products
	variations
	upgrades

products in bundle
bundled products
recommended products

Pricing:
- Display all pricing for main product
- Display "starting at" for bundle and recommended
- Display price for child. 
	If volume discount:
		If parent discount applies to children, display once.
		Else display volume for each child individually
		(Not currently possible to have one price that applies to multiple products except via category or parent product.)

PRICE LOGIC:
- Check for custom price
	Display normal price too
	Date availablity
	Custom price
		$ price/$ discount/% discount/% of original price
	Volume discount
		Price: $ price/$ discount/% discount/% of original price
		Quantity: 
- Call for quote
- Display normal price

SPECS/PARAMETERS/PRICING DISPLAY COMBINATIONS:
- Product can be purchased. No children
	- Pricing is listed separately
	- Add to cart with quantity and parameters if necessary
	- Specs are listed in a simple table
- Product call for quote. No children.
	- No add to cart
	- Specs are listed in a simple table
x Product call for quote. With children.
- Product with children. (Product cannot be purchased.)
- Product cannot be purchased. With children.

PRODUCT WITHOUT CHILDREN:
	- Pricing
	- Parameters
PRODUCT WITH CHILDREN:
	- One list of parameters
	- If volume discount pricing, show separately.
	- Without Specs, list product name/part/price in table
	- With Specs, include specs in table
ADD QUANTITY FIELD FOR VOLUME DISCOUNT!!!
--->


<!--- display category path --->
<cfif Variables.displayCategoryPath is True>
	<cfinclude template="dsp_productCategoryPath.cfm">
</cfif>

<cfoutput>
<!--- display product name --->
<p>
<div class="SubTitle">#qry_selectProduct.productLanguageName#</div>
<cfif qry_selectProduct.productID_custom is not ""><div class="MainText">Code: #qry_selectProduct.productID_custom#</div></cfif>
<cfif qry_selectProduct.vendorName is not ""><div class="MainText">#qry_selectProduct.vendorName# (<a href="search.cfm?isFormSubmitted=True&searchText=#qry_selectProduct.vendorID#&searchType=vendorID">View other products by this company</a>)</div></cfif>
</p>
</cfoutput>

<!--- display product price --->
<cfif qry_selectProduct.productCanBePurchased is 1>
	<cfinclude template="dsp_productPrice.cfm">
</cfif>
<!--- /display product price --->

<cfoutput>
<form method="get" action="/index.cfm">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="method" value="cart.addToCart">
<input type="hidden" name="returnID" value="#URL.productID#">
</cfoutput>


<!--- if product can be purchased, display buttons to add to cart and wish list --->
<cfif qry_selectProduct.productCanBePurchased is 1>
	<cfif Variables.displayProductParameter is True and Variables.displayChildProduct_variation is 0>
		<cfinclude template="dsp_productParameters.cfm">
	</cfif>

	<cfoutput>
	<p>
	<input type="text" name="quantity#qry_selectProduct.productID#" size="2" value="1">
	<input type="image" name="product#qry_selectProduct.productID#" src="/images/img_store/addtocart.gif" width="87" height="20" alt="Add to Cart" border="0">
	<!--- <a href="index.cfm?method=cart.addToCart&productID=#URL.productID#&returnID=#URL.productID#"></a> --->
	<!--- <cfif Session.userID gt 0><div class="TableText"><a href="wishList.cfm?action=insertWishList&productID=#URL.productID#&returnID=#URL.productID#">Add to Wish List</a></div></cfif> --->
	</p>
	</cfoutput>
</cfif>

<!--- display product summary --->
<cfif qry_selectProduct.productLanguageSummary is not "">
	<cfinclude template="dsp_productSummary.cfm">
</cfif>

<!--- display product description --->
<cfif qry_selectProduct.productLanguageDescription is not "">
	<cfinclude template="dsp_productDescription.cfm">
</cfif>

<!--- display product image(s) --->
<cfif Variables.displayProductImage is True>
	<cfinclude template="dsp_productImage.cfm">
</cfif>

<!--- display product specs: parent only --->
<cfif Variables.displayProductSpec is True and Variables.displayProductSpec_child is False>
	<cfinclude template="dsp_productSpecs_parentOnly.cfm">
</cfif>

<!--- display child products: variation (size, model, color, etc.) --->
<cfif Variables.displayChildProduct_variation is not 0><!--- and (Variables.displayProductSpec is False or Variables.displayProductSpec_child is False) --->
	<cfif Variables.displayProductParameter is True>
		<cfinclude template="dsp_productParameters.cfm">
	</cfif>

	<cfinclude template="dsp_productChildren_variation.cfm">
</cfif>

<!--- display child products: upgrades for this product --->
<cfif Variables.displayChildProduct_upgrade is not 0>
	<cfinclude template="dsp_productChildren_upgrade.cfm">
</cfif>

<cfoutput>
</form>
</cfoutput>

<!--- if product is bundle, display products in this bundle --->
<cfif Variables.displayProductsInThisBundle is True>
	<cfinclude template="dsp_productsInThisBundle.cfm">
</cfif>

<!--- if product is included in other bundles, list those bundles --->
<cfif Variables.displayProductBundleWithThisProduct is True>
	<cfinclude template="dsp_productBundlesWithThisProduct.cfm">
</cfif>

<!--- display products recommended by this product --->
<cfif Variables.displayProductRecommend is True>
	<cfinclude template="dsp_productsRecommendedByThisProduct.cfm">
</cfif>

