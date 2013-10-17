<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryProductCount" ReturnVariable="categoryProductCount">
	<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
	<cfinvokeargument Name="productCategoryStatus" Value="1">
</cfinvoke>

<cfinclude template="../../view/v_category/lang_deleteCategory.cfm">
<cfinclude template="formValidate_deleteCategory.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelseif Not IsDefined("Form.isFormSubmitted") or Not IsDefined("Form.okDelete") or Not IsDefined("Form.submitDeleteCategory")>
	<cfinclude template="../../view/v_category/form_deleteCategory.cfm">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Category" Method="deleteCategory" ReturnVariable="isCategoryDeleted">
		<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="categoryID_parent" Value="#qry_selectCategory.categoryID_parent#">
	</cfinvoke>

	<cflocation url="index.cfm?method=category.listCategories&confirm_category=#Variables.doAction#" AddToken="No">
</cfif>
