<cfset URL.productDateID = 0>
<cfinclude template="../../../include/function/fn_datetime.cfm">
<cfinclude template="formParam_productDate.cfm">
<cfinclude template="../../../view/v_product/v_productDate/lang_productDate.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProductDate")>
	<cfinclude template="formValidate_productDate.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.ProductDate" Method="insertProductDate" ReturnVariable="isProductDateInserted">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="productDateBegin" Value="#Form.productDateBegin#">
			<cfif IsDate(Form.productDateEnd)>
				<cfinvokeargument Name="productDateEnd" Value="#Form.productDateEnd#">
			</cfif>
			<cfinvokeargument Name="productDateStatus" Value="#Form.productDateStatus#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
		</cfinvoke>

		<cfif qry_selectProduct.productIsDateRestricted is 0>
			<cfinvoke Component="#Application.billingMapping#data.ProductDate" Method="insertProductDate" ReturnVariable="isProductDateInserted">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<cfinvokeargument Name="productIsDateRestricted" Value="1">
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=product.listProductDates&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "productDate">
<cfset Variables.formAction = "index.cfm?method=product.insertProductDate&productID=#URL.productID#">
<cfset Variables.formSubmitValue = Variables.lang_productDate.formSubmitValue_insert>
<cfinclude template="../../../view/v_product/v_productDate/form_productDate.cfm">
