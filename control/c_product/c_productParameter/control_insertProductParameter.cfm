<cfset URL.productParameterID = 0>

<cfinvoke component="#Application.billingMapping#data.ProductParameter" method="maxlength_ProductParameter" returnVariable="maxlength_ProductParameter" />
<cfinvoke component="#Application.billingMapping#data.ProductParameterOption" method="maxlength_ProductParameterOption" returnVariable="maxlength_ProductParameterOption" />
<cfinclude template="formParam_insertUpdateProductParameter.cfm">
<cfinclude template="../../../view/v_product/v_productParameter/lang_insertUpdateProductParameter.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProductParameter")>
	<cfinclude template="../../../include/function/fn_IsValidURL.cfm">
	<cfinclude template="formValidate_insertUpdateProductParameter.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<cfif qry_selectProduct.productHasParameter is 0>
			<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<cfinvokeargument Name="productHasParameter" Value="1">
			</cfinvoke>
		</cfif>

		<cfif Form.productParameterOrder is 0>
			<cfset Variables.productParameterOrder = IncrementValue(qry_selectProductParameterList.RecordCount)>
		<cfelse>
			<cfset Variables.productParameterOrder = Form.productParameterOrder>
		</cfif>

		<cfif Form.productParameterCodeStatus is 0>
			<cfset Variables.productParameterCodeOrder = 0>
		<cfelseif Form.productParameterCodeOrder is not 0>
			<cfset Variables.productParameterCodeOrder = Form.productParameterCodeOrder>
		<cfelseif qry_selectProductParameterList.RecordCount is 0>
			<cfset Variables.productParameterCodeOrder = 1>
		<cfelse>
			<cfset Variables.productParameterCodeOrder = 1 + ListFirst(ListSort(ValueList(qry_selectProductParameterList.productParameterCodeOrder), "numeric", "desc"))>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ProductParameter" Method="insertProductParameter" ReturnVariable="newProductParameterID">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="productParameterName" Value="#Form.productParameterName#">
			<cfinvokeargument Name="productParameterText" Value="#Form.productParameterText#">
			<cfinvokeargument Name="productParameterDescription" Value="#Form.productParameterDescription#">
			<cfinvokeargument Name="productParameterOrder" Value="#Variables.productParameterOrder#">
			<cfinvokeargument Name="productParameterImage" Value="#Form.productParameterImage#">
			<cfinvokeargument Name="productParameterCodeStatus" Value="#Form.productParameterCodeStatus#">
			<cfinvokeargument Name="productParameterCodeOrder" Value="#Variables.productParameterCodeOrder#">
			<cfinvokeargument Name="productParameterStatus" Value="#Form.productParameterStatus#">
			<cfinvokeargument Name="productParameterRequired" Value="#Form.productParameterRequired#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="productParameterExportXml" Value="#Form.productParameterExportXml#">
			<cfinvokeargument Name="productParameterExportTab" Value="#Form.productParameterExportTab#">
			<cfinvokeargument Name="productParameterExportHtml" Value="#Form.productParameterExportHtml#">
		</cfinvoke>

		<cfset Variables.productParameterOptionLabel_array = ArrayNew(1)>
		<cfset Variables.productParameterOptionValue_array = ArrayNew(1)>
		<cfset Variables.productParameterOptionImage_array = ArrayNew(1)>
		<cfset Variables.productParameterOptionCode_array = ArrayNew(1)>

		<cfloop Index="count" From="1" To="#Variables.productParameterOptionCount#">
			<cfset Variables.productParameterOptionLabel_array[count] = Form["productParameterOptionLabel#count#"]>
			<cfset Variables.productParameterOptionValue_array[count] = Form["productParameterOptionValue#count#"]>
			<cfset Variables.productParameterOptionImage_array[count] = Form["productParameterOptionImage#count#"]>
			<cfset Variables.productParameterOptionCode_array[count] = Form["productParameterOptionCode#count#"]>
		</cfloop>

		<cfinvoke Component="#Application.billingMapping#data.ProductParameterOption" Method="insertProductParameterOption" ReturnVariable="isProductParameterOptionInserted">
			<cfinvokeargument Name="productParameterID" Value="#newProductParameterID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="productParameterOptionLabel" Value="#Variables.productParameterOptionLabel_array#">
			<cfinvokeargument Name="productParameterOptionValue" Value="#Variables.productParameterOptionValue_array#">
			<cfinvokeargument Name="productParameterOptionImage" Value="#Variables.productParameterOptionImage_array#">
			<cfinvokeargument Name="productParameterOptionCode" Value="#Variables.productParameterOptionCode_array#">
		</cfinvoke>

		<cflocation url="index.cfm?method=product.listProductParameters&productID=#URL.productID#&confirm_product=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "insertUpdateProductParameter">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateProductParameter.formSubmitValue_insert>

<cfinclude template="../../../view/v_product/v_productParameter/form_insertUpdateProductParameter.cfm">
