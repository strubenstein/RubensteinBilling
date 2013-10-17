<cfinclude template="formParam_insertProductSpec.cfm">
<cfinvoke component="#Application.billingMapping#data.ProductSpec" method="maxlength_ProductSpec" returnVariable="maxlength_ProductSpec" />

<!--- 
validate select and text are not both filled in
switch order?
--->

<cfif IsDefined("Form.isFormSubmitted") and (IsDefined("Form.submitProductSpecCount") or IsDefined("Form.submitProductSpec"))>
	<cfinclude template="../../../view/v_product/v_productSpec/lang_insertProductSpec.cfm">
	<cfinclude template="formValidate_insertProductSpec.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelseif IsDefined("Form.submitProductSpec")>
		<cfinvoke Component="#Application.billingMapping#data.ProductSpec" Method="updateProductSpec" ReturnVariable="isProductSpecUpdated">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
		</cfinvoke>

		<cfset Variables.productSpecList = ArrayNew(1)>
		<cfloop Index="count" From="1" To="#Form.productSpecCount#">
			<cfif Form["productSpecName#count#"] is "">
				<cfbreak>
			<cfelse>
				<cfset Variables.productSpecList[count] = StructNew()>
				<cfset Variables.productSpecList[count].productSpecHasImage = Form["productSpecHasImage#count#"]>
				<cfset Variables.productSpecList[count].productSpecValue = Form["productSpecValue#count#"]>
				<cfset Variables.productSpecList[count].productSpecName = Form["productSpecName#count#"]>
			</cfif>
		</cfloop>

		<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfif ArrayLen(Variables.productSpecList) is 0>
				<cfinvokeargument Name="productHasSpec" Value="0">
			<cfelse>
				<cfinvokeargument Name="productHasSpec" Value="1">
			</cfif>
		</cfinvoke>

		<cfif ArrayLen(Variables.productSpecList) is 0>
			<cflocation url="index.cfm?method=product.#Variables.doAction#&productID=#URL.productID#&confirm_product=blankProductSpec" AddToken="No">
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.ProductSpec" Method="insertProductSpec" ReturnVariable="isProductSpecInserted">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="productSpecList" Value="#Variables.productSpecList#">
			</cfinvoke>

			<cflocation url="index.cfm?method=product.#Variables.doAction#&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.ProductSpec" Method="selectProductSpecNameList" ReturnVariable="qry_selectProductSpecNameList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfif qry_selectProduct.productID_parent is not 0>
		<cfinvokeargument Name="productID_parent" Value="#qry_selectProduct.productID_parent#">
	</cfif>
	<cfif qry_selectProduct.vendorID is not 0>
		<cfinvokeargument Name="vendorID" Value="#qry_selectProduct.vendorID#">
	</cfif>
</cfinvoke>

<cfset Variables.formAction = "index.cfm?method=product.#Variables.doAction#&productID=#URL.productID#">
<cfinclude template="../../../view/v_product/v_productSpec/form_insertProductSpec.cfm">
