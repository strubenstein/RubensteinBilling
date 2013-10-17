<cfoutput>
<div class="SubNav">
<cfif Variables.isViewPermission is True>
	<form method="get" action="index.cfm">
	<input type="hidden" name="method" value="product.viewProduct">
	<input type="hidden" name="submitView" value="True">
</cfif>
<cfif Application.fn_IsUserAuthorized("listProducts")><a href="index.cfm?method=product.listProducts" title="List existing products based on filtering criteria" class="SubNavLink<cfif Variables.doAction is "listProducts">On</cfif>">List Existing Products</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertProduct")> | <a href="index.cfm?method=product.insertProduct" title="Create a new product" class="SubNavLink<cfif Variables.doAction is "insertProduct" and Not IsDefined("URL.productID_parent")>On</cfif>">Create New Product</a></cfif>
<cfif Variables.isViewPermission is True> || View Product ##: <input type="text" name="productID" size="8" class="SmallText" title="Enter ID or custom ID of product"> <input type="submit" value="Go" class="SmallText" style="color=white;background=784397;bordercolor=white"></cfif>
<cfif URL.productID is not 0 and Variables.doAction is not "listProducts">
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Product:</span> <span class="SubNavName"><cfif qry_selectProduct.productID_custom is not "">#qry_selectProduct.productID_custom#. </cfif>#qry_selectProduct.productName#</span><br>
	<cfif Application.fn_IsUserAuthorized("viewProduct")><a href="index.cfm?method=product.viewProduct&productID=#URL.productID#" title="View summary of product" class="SubNavLink<cfif Variables.doAction is "viewProduct">On</cfif>">Summary</a> | </cfif>
	<!--- <cfif Application.fn_IsUserAuthorized("previewProduct")><a href="index.cfm?method=product.previewProduct&productID=#URL.productID#" title="Preview product via designated display template" class="SubNavLink<cfif Variables.doAction is "previewProduct">On</cfif>">Preview</a> | </cfif> --->
	<cfif Application.fn_IsUserAuthorized("updateProduct")><a href="index.cfm?method=product.updateProduct&productID=#URL.productID#" title="Update main product information" class="SubNavLink<cfif Variables.doAction is "updateProduct">On</cfif>">Update</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertProductCategory")><a href="index.cfm?method=product.insertProductCategory&productID=#URL.productID#" title="Determine categories product is listed in" class="SubNavLink<cfif Find("ProductCategory", Variables.doAction)>On</cfif>">Category</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("viewProductCategory")><a href="index.cfm?method=product.viewProductCategory&productID=#URL.productID#" title="View categories product is listed in" class="SubNavLink<cfif Find("ProductCategory", Variables.doAction)>On</cfif>">Category</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertProductLanguage")><a href="index.cfm?method=product.insertProductLanguage&productID=#URL.productID#" title="Update name and descriptions as displayed to customers" class="SubNavLink<cfif Variables.doAction is "insertProductLanguage">On</cfif>">Language</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listProductParameters")><a href="index.cfm?method=product.listProductParameters&productID=#URL.productID#" title="View/add product parameters" class="SubNavLink<cfif Find("Parameter", Variables.doAction)>On</cfif>">Parameters</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertProductSpec")><a href="index.cfm?method=product.insertProductSpec&productID=#URL.productID#" title="Update custom product specifications" class="SubNavLink<cfif Find("Spec", Variables.doAction)>On</cfif>">Specs</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listImages")><a href="index.cfm?method=product.listImages&productID=#URL.productID#" title="Add/edit product images" class="SubNavLink<cfif Find("Image", Variables.doAction)>On</cfif>">Images</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listProductDates")><a href="index.cfm?method=product.listProductDates&productID=#URL.productID#" title="Determine dates product is available" class="SubNavLink<cfif Find("Date", Variables.doAction)>On</cfif>">Date Availability</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listSubscribers")><a href="index.cfm?method=product.listSubscribers&productID=#URL.productID#" title="View subscribers with active subscriptions to this product" class="SubNavLink<cfif Find("Subscri", Variables.doAction)>On</cfif>">Existing Subscribers</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listInvoices")><a href="index.cfm?method=product.listInvoices&productID=#URL.productID#" title="View customers who have purchased this product" class="SubNavLink<cfif Find("Invoice", Variables.doAction)>On</cfif>">Existing Invoices</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("viewProduct")><a href="index.cfm?method=product.viewProduct&productID=#URL.productID#&viewFieldArchives=True" title="View previous values of product information" class="SubNavLink<cfif Variables.doAction is "viewProduct" and IsDefined("URL.viewFieldArchives") and URL.viewFieldArchives is True>On</cfif>">Archived Values</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listPrices")><a href="index.cfm?method=product.listPrices&productID=#URL.productID#" title="View/add custom pricing options" class="SubNavLink<cfif Find("Price", Variables.doAction)>On</cfif>">Custom Pricing</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listProductRecommends")><a href="index.cfm?method=product.listProductRecommends&productID=#URL.productID#" title="Add recommendations and list products that recommend this product" class="SubNavLink<cfif Find("Recommend", Variables.doAction)>On</cfif>">Recommend</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listProductBundles")><a href="index.cfm?method=product.listProductBundles&productID=#URL.productID#" title="Add products to bundle OR list bundles that include this product" class="SubNavLink<cfif Find("Bundle", Variables.doAction)>On</cfif>">Bundle</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listChildProducts")><a href="index.cfm?method=product.listChildProducts&productID=#URL.productID#" title="List child products or parent product" class="SubNavLink<cfif Find("Child", Variables.doAction)>On</cfif>">Existing Child Products</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertProduct") and ((URL.productID is not 0 and Variables.doAction is not "listProducts") or (Variables.doAction is "insertProduct" and IsDefined("URL.productID_parent")))>
		<a href="index.cfm?method=product.insertProduct&productID_parent=<cfif IsDefined("URL.productID_parent")>#URL.productID_parent#<cfelse>#URL.productID#</cfif>" title="Create a product that is a child of current product" class="SubNavLink<cfif Variables.doAction is "insertProduct" and IsDefined("URL.productID_parent")>On</cfif>">Create New Child Product</a> | 
	</cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")><a href="index.cfm?method=product.insertNote&productID=#URL.productID#" title="Add/view notes about this product" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a>
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")><a href="index.cfm?method=product.listNotes&productID=#URL.productID#" title="View notes about this product" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listCommissions")> | <a href="index.cfm?method=product.listCommissions&productID=#URL.productID#" class="SubNavLink<cfif Variables.doAction is "listCommissions">On</cfif>">Commission Plans</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listSalesCommissions")> | <a href="index.cfm?method=product.listSalesCommissions&productID=#URL.productID#" class="SubNavLink<cfif Find("SalesCommission", Variables.doAction)>On</cfif>">Sales Commissions</a></cfif>
</cfif>
</div><br>
<cfif Variables.isViewPermission is True></form></cfif>
</cfoutput>

