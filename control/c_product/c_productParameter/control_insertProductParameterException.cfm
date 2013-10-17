<cfinclude template="security_productParameterException.cfm">

<cfinvoke Component="#Application.billingMapping#data.ProductParameterOption" Method="selectProductParameterOptionList" ReturnVariable="qry_selectProductParameterOptionList">
	<cfinvokeargument Name="productParameterID" Value="#ValueList(qry_selectProductParameterList.productParameterID)#">
	<cfinvokeargument Name="productParameterOptionStatus" Value="1">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.ProductParameterException" method="maxlength_ProductParameterException" returnVariable="maxlength_ProductParameterException" />
<cfinclude template="formParam_insertProductParameterException.cfm">
<cfinclude template="../../../view/v_product/v_productParameter/lang_insertProductParameterException.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProductParameterException")>
	<cfinclude template="formValidate_insertProductParameterException.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<cfif qry_selectProduct.productHasParameterException is 0>
			<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<cfinvokeargument Name="productHasParameterException" Value="1">
			</cfinvoke>
		</cfif>

		<cfif URL.productParameterExceptionID is not 0>
			<cfinvoke Component="#Application.billingMapping#data.ProductParameterException" Method="updateProductParameterException" ReturnVariable="isProductParameterExceptionUpdated">
				<cfinvokeargument Name="productParameterExceptionID" Value="#URL.productParameterExceptionID#">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ProductParameterException" Method="insertProductParameterException" ReturnVariable="isProductParameterExceptionInserted">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfloop Index="count" From="1" To="#ListLen(Variables.productParameterOptionID)#">
				<cfinvokeargument Name="productParameterOptionID#count#" Value="#ListGetAt(Variables.productParameterOptionID, count)#">
			</cfloop>
			<cfinvokeargument Name="productParameterExceptionExcluded" Value="#Form.productParameterExceptionExcluded#">
			<cfif Form.productParameterExceptionPricePremium is not "">
				<cfinvokeargument Name="productParameterExceptionPricePremium" Value="#Form.productParameterExceptionPricePremium#">
			</cfif>
			<cfinvokeargument Name="productParameterExceptionText" Value="#Form.productParameterExceptionText#">
			<cfinvokeargument Name="productParameterExceptionDescription" Value="#Form.productParameterExceptionDescription#">
			<cfinvokeargument Name="productParameterExceptionID_parent" Value="#URL.productParameterExceptionID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=product.listProductParameterExceptions&productID=#URL.productID#&confirm_product=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfif URL.productParameterExceptionID is 0>
	<cfset Variables.formSubmitValue = Variables.lang_insertProductParameterException.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertProductParameterException.formSubmitValue_update>
	<cfset Variables.formAction = Variables.formAction & "&productParameterExceptionID=" & URL.productParameterExceptionID>
</cfif>

<cfinclude template="../../../view/v_product/v_productParameter/form_insertProductParameterException.cfm">

