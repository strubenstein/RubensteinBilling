<cfif Not Application.fn_IsIntegerNonNegative(URL.categoryID)>
	<cfset URL.error_category = "invalidCategory">
	<cfset Variables.doAction = "listCategories">
<cfelseif URL.categoryID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Category" Method="checkCategoryPermission" ReturnVariable="isCategoryPermission">
		<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isCategoryPermission is True>
		<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategory" ReturnVariable="qry_selectCategory">
			<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
		</cfinvoke>
	<cfelse>
		<cfset URL.error_category = "invalidCategory">
		<cfset Variables.doAction = "listCategories">
	</cfif>
<cfelseif Not ListFind("listCategories,listAllCategories,listCategoriesManual,insertCategory", Variables.doAction)>
	<cfset URL.error_category = "invalidCategory">
	<cfset Variables.doAction = "listCategories">
</cfif>
