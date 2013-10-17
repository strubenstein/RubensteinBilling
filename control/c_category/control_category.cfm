<cfparam Name="URL.categoryID" Default="0">

<cfinclude template="security_category.cfm">
<cfinclude template="../../view/v_category/nav_category.cfm">
<cfif IsDefined("URL.confirm_category")>
	<cfinclude template="../../view/v_category/confirm_category.cfm">
</cfif>
<cfif IsDefined("URL.error_category")>
	<cfinclude template="../../view/v_category/error_category.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listCategories,listAllCategories,listCategoriesManual">
	<cfinclude template="control_listCategories.cfm">
</cfcase>

<cfcase value="insertCategory">
	<cfinclude template="control_insertCategory.cfm">
</cfcase>

<cfcase value="updateCategory">
	<cfinclude template="control_updateCategory.cfm">
</cfcase>

<cfcase value="listProducts,moveProductCategoryUp,moveProductCategoryDown">
	<cfset Variables.doControl = "product">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listPrices,viewPrice,insertPrice,updatePrice,listPriceTargets,updatePriceTargetStatus0,updatePriceTargetStatus1,insertPriceTargetUser,insertPriceTargetGroup,insertPriceTargetCompany">
	<cfset Variables.urlParameters = "&categoryID=#URL.categoryID#">
	<cfset Variables.doControl = "price">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="moveCategoryUp,moveCategoryDown">
	<cfinvoke Component="#Application.billingMapping#data.Category" Method="switchCategoryOrder" ReturnVariable="isCategoryOrderSwitched">
		<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
		<cfinvokeargument Name="categoryOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=category.listCategoriesManual&confirm_category=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="deleteCategory">
	<cfinclude template="control_deleteCategory.cfm">
</cfcase>

<cfcase value="listCommissions">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("categoryID")>
	<cfset Variables.targetID = URL.categoryID>
	<cfset Variables.urlParameters = "&categoryID=#URL.categoryID#">

	<cfset Variables.doControl = "commission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listSalesCommissions">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("categoryID")>
	<cfset Variables.targetID = URL.categoryID>
	<cfset Variables.urlParameters = "&categoryID=#URL.categoryID#">

	<cfset Variables.doControl = "salesCommission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_category = "invalidAction">
	<cfinclude template="../../view/v_category/error_category.cfm">
</cfdefaultcase>
</cfswitch>
