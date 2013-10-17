<cfif Not ListFind(ValueList(qry_selectProductDateList.productDateID), URL.productDateID)>
	<cflocation url="index.cfm?method=product.listProductDates&error_product=invalidDate" AddToken="No">
</cfif>

<cfinclude template="../../../include/function/fn_datetime.cfm">
<cfinclude template="formParam_productDate.cfm">
<cfinclude template="../../../view/v_product/v_productDate/lang_productDate.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProductDate")>
	<cfinclude template="formValidate_productDate.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.ProductDate" Method="updateProductDate" ReturnVariable="isProductDateInserted">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="productDateID" Value="#URL.productDateID#">
			<cfinvokeargument Name="productDateBegin" Value="#Form.productDateBegin#">
			<cfinvokeargument Name="productDateEnd" Value="#Form.productDateEnd#">
			<cfinvokeargument Name="productDateStatus" Value="#Form.productDateStatus#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=product.listProductDates&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "productDate">
<cfset Variables.formAction = "index.cfm?method=product.updateProductDate&productID=#URL.productID#&productDateID=#URL.productDateID#">
<cfset Variables.formSubmitValue = Variables.lang_productDate.formSubmitValue_update>
<cfinclude template="../../../view/v_product/v_productDate/form_productDate.cfm">
