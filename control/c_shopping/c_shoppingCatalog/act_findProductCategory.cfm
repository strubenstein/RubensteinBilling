<!--- for each product, get category(s) and parent category(s) for determining custom pricing --->
<cfset Variables.productCategoryID = StructNew()>
<cfset Variables.productCategoryID_parent = StructNew()>

<cfloop Query="qry_selectProductCategoryList">
	<cfif Not StructKeyExists(Variables.productCategoryID, "product#qry_selectProductCategoryList.productID#")>
		<cfset Variables.productCategoryID["product#qry_selectProductCategoryList.productID#"] = qry_selectProductCategoryList.categoryID>
	<cfelse>
		<cfset Variables.productCategoryID["product#qry_selectProductCategoryList.productID#"] = ListAppend(Variables.productCategoryID["product#qry_selectProductCategoryList.productID#"], qry_selectProductCategoryList.categoryID)>
	</cfif>
	<cfif qry_selectProductCategoryList.categoryID_parentList is not "">
		<cfif Not StructKeyExists(Variables.productCategoryID_parent, "product#qry_selectProductCategoryList.productID#")>
			<cfset Variables.productCategoryID_parent["product#qry_selectProductCategoryList.productID#"] = qry_selectProductCategoryList.categoryID_parentList>
		<cfelse>
			<cfset Variables.productCategoryID_parent["product#qry_selectProductCategoryList.productID#"] = ListAppend(Variables.productCategoryID_parent["product#qry_selectProductCategoryList.productID#"], qry_selectProductCategoryList.categoryID_parentList)>
		</cfif>
	</cfif>
</cfloop>
