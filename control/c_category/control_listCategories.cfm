<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfif Variables.doAction is "listCategoriesManual">
		<cfinvokeargument Name="categoryOrderByManual" Value="True">
	</cfif>
</cfinvoke>

<cfinclude template="../../view/v_category/lang_listCategories.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateCategory,listPrices,deleteCategory,insertCategory,listProducts,moveCategoryDown,moveCategoryUp")>

<cfset Variables.categoryColumnList = " ^" & Variables.lang_listCategories_title.categoryName
		& "^" & Variables.lang_listCategories_title.categoryCode
		& "^" & Variables.lang_listCategories_title.categoryStatus
		& "^" & Variables.lang_listCategories_title.categoryAcceptListing
		& "^" & Variables.lang_listCategories_title.categoryIsListed
		& "^" & Variables.lang_listCategories_title.categoryDateCreated
		& "^" & Variables.lang_listCategories_title.categoryDateUpdated>

<cfif Not REFind("[1-9]", ValueList(qry_selectCategoryList.categoryViewCount))>
	<cfset Variables.displayCategoryViewCount = False>
<cfelse>
	<cfset Variables.displayCategoryViewCount = True>
	<cfset Variables.categoryColumnList = Variables.categoryColumnList & "^" & Variables.lang_listCategories_title.categoryViewCount>
</cfif>

<cfif Variables.doAction is "listCategoriesManual" and ListFind(Variables.permissionActionList, "moveCategoryDown") and ListFind(Variables.permissionActionList, "moveCategoryUp")>
	<cfset Variables.categoryColumnList = Variables.lang_listCategories_title.categoryOrder & "^" & Variables.categoryColumnList & "^" & Variables.lang_listCategories_title.moveCategory>
</cfif>

<cfset Variables.manageAction = "">
<cfif ListFind(Variables.permissionActionList, "updateCategory")>
	<cfset Variables.manageAction = "updateCategory">
<cfelseif ListFind(Variables.permissionActionList, "listProducts")>
	<cfset Variables.manageAction = "listProducts">
<cfelseif ListFind(Variables.permissionActionList, "listPrices")>
	<cfset Variables.manageAction = "listPrices">
<cfelseif ListFind(Variables.permissionActionList, "insertCategory")>
	<cfset Variables.manageAction = "insertCategory">
<cfelseif ListFind(Variables.permissionActionList, "deleteCategory")>
	<cfset Variables.manageAction = "deleteCategory">
</cfif>
<cfif Variables.manageAction is not "">
	<cfset Variables.categoryColumnList = Variables.categoryColumnList & "^" & Variables.lang_listCategories_title.manageCategory>
</cfif>

<!--- 
<cfif ListFind(Variables.permissionActionList, "updateCategory")>
	<cfset Variables.categoryColumnList = Variables.categoryColumnList & "^" & Variables.lang_listCategories_title.updateCategory>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listPrices")>
	<cfset Variables.categoryColumnList = Variables.categoryColumnList & "^" & Variables.lang_listCategories_title.listPrices>
</cfif>
<cfif ListFind(Variables.permissionActionList, "deleteCategory")>
	<cfset Variables.categoryColumnList = Variables.categoryColumnList & "^" & Variables.lang_listCategories_title.deleteCategory>
</cfif>
<cfif ListFind(Variables.permissionActionList, "insertCategory")>
	<cfset Variables.categoryColumnList = Variables.categoryColumnList & "^" & Variables.lang_listCategories_title.insertCategory>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listProducts")>
	<cfset Variables.categoryColumnList = Variables.categoryColumnList & "^" & Variables.lang_listCategories_title.listProducts>
</cfif>
--->

<cfset Variables.categoryColumnCount = DecrementValue(2 * ListLen(Variables.categoryColumnList, "^"))>

<cfparam Name="URL.categoryID_expand" Default="">
<cfset currentRowCount = 0>

<cfif Variables.doAction is not "listCategories">
	<cfset URL.categoryID_expand = ValueList(qry_selectCategoryList.categoryID)>
</cfif>

<cfset subcatStruct = StructNew()>
<cfloop Query="qry_selectCategoryList">
	<cfset subcatStruct["cat#qry_selectCategoryList.categoryID#"] = qry_selectCategoryList.categoryID>
	<cfset currentCategoryID = qry_selectCategoryList.categoryID>
	<cfloop Index="subCatID" List="#qry_selectCategoryList.categoryID_parentList#">
		<cfset subcatStruct["cat#subCatID#"] = ListAppend(subcatStruct["cat#subCatID#"], currentCategoryID)>
	</cfloop>
</cfloop>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_category/dsp_selectCategoryList.cfm">
