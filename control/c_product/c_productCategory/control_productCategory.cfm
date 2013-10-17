<cfinvoke Component="#Application.billingMapping#data.ProductCategory" Method="selectProductCategory" ReturnVariable="qry_selectProductCategory">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
</cfinvoke>

<cfset Variables.productCategoryOrder_categoryID = StructNew()>
<cfloop Query="qry_selectProductCategory">
	<cfset Variables.productCategoryOrder_categoryID["cat#qry_selectProductCategory.categoryID#"] = qry_selectProductCategory.productCategoryOrder>
</cfloop>

<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinclude template="../../../include/function/fn_datetime.cfm">
<cfinclude template="formParam_productCategory.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProductCategory")>
	<cfinclude template="../../../view/v_product/v_productCategory/lang_productCategory.cfm">
	<cfinclude template="formValidate_productCategory.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<!--- include in separate file so can be called from extended product form --->
		<cfinclude template="act_insertProductCategory.cfm">

		<cflocation url="index.cfm?method=product.#Variables.doAction#&productID=#URL.productID#&confirm_product=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("moveProductCategoryUp,moveProductCategoryDown,listProducts")>

<cfif ListLen(Variables.permissionActionList) is 3>
	<cfset Variables.switchProductCategoryOrder = True>
<cfelse>
	<cfset Variables.switchProductCategoryOrder = False>
</cfif>

<cfset Variables.formName = "productCategory">
<cfif Variables.doAction is "viewProductCategory">
	<cfset Variables.formAction = "">
</cfif>

<cfinclude template="../../../view/v_product/v_productCategory/form_productCategory.cfm">
