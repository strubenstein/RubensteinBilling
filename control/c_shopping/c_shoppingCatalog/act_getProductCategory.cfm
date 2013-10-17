<!--- 
Select category path(s) to this product
Select categories of other products displayed (child,bundled,recommended for purposes of pricing
--->

<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductCategoryList" ReturnVariable="qry_selectProductCategoryList">
	<cfinvokeargument Name="productID" Value="#Variables.productID_getCategory#">
</cfinvoke>

<cfset Variables.displayCategoryPath = False>
<cfset Variables.categoryParentList = "">

<cfset Variables.productCategoryIDArray = ArrayNew(2)>
<cfset Variables.productCategoryTitleArray = ArrayNew(2)>
<cfset Variables.productCategoryRowList = "">
<cfset Variables.productCategoryParentList = "">

<cfloop Query="qry_selectProductCategoryList">
	<!--- list of categories for purposes of pricing --->
	<cfset Variables.categoryID_getPrice = ListAppend(Variables.categoryID_getPrice, qry_selectProductCategoryList.categoryID)>
	<cfif qry_selectProductCategoryList.categoryID_parentList is not "">
		<cfset Variables.categoryID_parent_getPrice = ListAppend(Variables.categoryID_parent_getPrice, qry_selectProductCategoryList.categoryID_parentList)>
	</cfif>

	<!--- Select categoryID's for category path(s) to this product --->
	<cfif qry_selectProductCategoryList.productID is URL.productID>
		<cfset Variables.productCategoryRowList = ListAppend(Variables.productCategoryRowList, qry_selectProductCategoryList.CurrentRow)>
		<cfif qry_selectProductCategoryList.categoryID_parentList is not "">
			<cfset Variables.productCategoryParentList = ListAppend(Variables.productCategoryParentList, qry_selectProductCategoryList.categoryID_parentList)>
		</cfif>
	</cfif>
</cfloop>

<!--- select category names of parent categories for purposes of displaying category path(s) to product --->
<cfif Variables.productCategoryParentList is not "">
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectCategoryList" ReturnVariable="qry_selectCategoryPathList">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="categoryID" Value="#Variables.productCategoryParentList#">
	</cfinvoke>
</cfif>

<cfloop Index="mainCatRow" List="#Variables.productCategoryRowList#">
	<cfset Variables.thisArray = ArrayLen(Variables.productCategoryIDArray) + 1>
	<cfif Variables.productCategoryParentList is not "">
		<cfloop Index="parentCatID" List="#qry_selectProductCategoryList.categoryID_parentList[mainCatRow]#">
			<cfset Variables.catParentRow = ListFind(ValueList(qry_selectCategoryPathList.categoryID), parentCatID)>
			<cfif Variables.catParentRow is not 0>
				<cfset temp = ArrayAppend(Variables.productCategoryIDArray[Variables.thisArray], qry_selectCategoryPathList.categoryID[Variables.catParentRow])>
				<cfset temp = ArrayAppend(Variables.productCategoryTitleArray[Variables.thisArray], qry_selectCategoryPathList.categoryTitle[Variables.catParentRow])>
			</cfif>
		</cfloop>
	</cfif>

	<cfset temp = ArrayAppend(Variables.productCategoryIDArray[Variables.thisArray], qry_selectProductCategoryList.categoryID[mainCatRow])>
	<cfset temp = ArrayAppend(Variables.productCategoryTitleArray[Variables.thisArray], qry_selectProductCategoryList.categoryTitle[mainCatRow])>
	<cfset Variables.displayCategoryPath = True>
</cfloop>

<!--- 
<cfset Variables.categoryParentList = ValueList(qry_selectProductCategoryList.categoryID)>
<cfif qry_selectProductCategoryList.RecordCount is not 0 and REFind("[1-9]", ValueList(qry_selectProductCategoryList.categoryID_parentList))>
	<cfloop Query="qry_selectProductCategoryList">
		<cfif qry_selectProductCategoryList.categoryID_parentList is not "">
			<cfset Variables.categoryParentList = ListAppend(Variables.categoryParentList, qry_selectProductCategoryList.categoryID_parentList)>
		</cfif>
	</cfloop>

	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectCategoryList" ReturnVariable="qry_selectCategoryPathList">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="categoryID" Value="#Variables.categoryParentList#">
	</cfinvoke>
	<cfif qry_selectCategoryPathList.RecordCount is not 0>
		<cfset Variables.displayCategoryPath = True>
	</cfif>
</cfif>
--->
