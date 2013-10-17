<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Product Categories: </span>
<cfif Application.fn_IsUserAuthorized("listCategories")><a href="index.cfm?method=category.listCategories" title="List existing product categories" class="SubNavLink<cfif ListFind("listCategories,listAllCategories,listCategoriesManual", Variables.doAction)>On</cfif>">List Existing Categories</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertCategory")> | <a href="index.cfm?method=category.insertCategory" title="Create new product category or sub-category" class="SubNavLink<cfif Variables.doAction is "insertCategory">On</cfif>">Create New Category</a></cfif>
<cfif URL.categoryID gt 0 and IsDefined("qry_selectCategory")>
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Category Name:</span> <span class="SubNavName">#qry_selectCategory.categoryName#</span><br>
	<cfif Application.fn_IsUserAuthorized("updateCategory")><a href="index.cfm?method=category.updateCategory&categoryID=#URL.categoryID#" title="Update category information" class="SubNavLink<cfif Variables.doAction is "updateCategory">On</cfif>">Update</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listPrices")> | <a href="index.cfm?method=category.listPrices&categoryID=#URL.categoryID#" title="Create and view prices that apply to products in this category (or sub-categories)" class="SubNavLink<cfif Variables.doAction is "listPrices">On</cfif>">Custom Pricing</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listProducts")> | <a href="index.cfm?method=category.listProducts&categoryID=#URL.categoryID#" title="List products that are included in this category and determine manual order" class="SubNavLink<cfif Variables.doAction is "listProducts">On</cfif>">List Products</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listCommissions")> | <a href="index.cfm?method=category.listCommissions&categoryID=#URL.categoryID#" title="Create and list sales commission plans that apply to products listed in this category (or sub-categories)" class="SubNavLink<cfif Variables.doAction is "listCommissions">On</cfif>">Commission Plans</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listSalesCommissions")> | <a href="index.cfm?method=category.listSalesCommissions&categoryID=#URL.categoryID#" title="List calculated sales commissions for products in this category" class="SubNavLink<cfif Find("SalesCommission", Variables.doAction)>On</cfif>">Sales Commissions</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertCategory")> | <a href="index.cfm?method=category.insertCategory&categoryID_sub=#URL.categoryID#" title="Create a new category as a sub-category of this category" class="SubNavLink<cfif Variables.doAction is "insertCategory">On</cfif>">Create Sub-Category</a></cfif>
	<cfif Application.fn_IsUserAuthorized("deleteCategory") and qry_selectCategory.categoryHasChildren is 0 and qry_selectCategory.categoryStatus is 0> || <a href="index.cfm?method=category.deleteCategory&categoryID=#URL.categoryID#" title="Delete this category (if no child categories and category is inactive)" class="SubNavLink<cfif Variables.doAction is "deleteCategory">On</cfif>">Delete</a></cfif>
</cfif>
</div><br>
</cfoutput>
