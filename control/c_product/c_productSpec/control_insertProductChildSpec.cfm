<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductList" ReturnVariable="qry_selectProductChildList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="productID_parent" Value="#URL.productID#">
	<cfinvokeargument Name="queryOrderBy" Value="productChildOrder">
</cfinvoke>

<cfif qry_selectProductChildList.RecordCount is 0>
	<cflocation url="index.cfm?method=product.insertProductSpec&productID=#URL.productID#" AddToken="No">
</cfif>

<cfset Variables.productID_list = URL.productID & "," & ValueList(qry_selectProductChildList.productID)>

<cfinvoke Component="#Application.billingMapping#data.ProductSpec" Method="selectProductSpecList" ReturnVariable="qry_selectProductChildSpecList">
	<cfinvokeargument Name="productID" Value="#ValueList(qry_selectProductChildList.productID)#">
	<cfinvokeargument Name="productSpecStatus" Value="1">
</cfinvoke>

<cfinclude template="formParam_insertProductChildSpec.cfm">
<cfinvoke component="#Application.billingMapping#data.ProductSpec" method="maxlength_ProductSpec" returnVariable="maxlength_ProductSpec" />

<!--- 
validate select and text are not both filled in
switch order?
--->

<cfif IsDefined("Form.isFormSubmitted") and (IsDefined("Form.submitProductSpecCount") or IsDefined("Form.submitProductSpec"))>
	<cfinclude template="../../../view/v_product/v_productSpec/lang_insertProductSpec.cfm">
	<cfinclude template="formValidate_insertProductChildSpec.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelseif IsDefined("Form.submitProductSpec")>
		<cfset Variables.productSpecList = ArrayNew(1)>
		<cfloop Index="pID" List="#Variables.productID_list#">
			<cfset Variables.thisProductID = pID>
			<cfinvoke Component="#Application.billingMapping#data.ProductSpec" Method="updateProductSpec" ReturnVariable="isProductSpecUpdated">
				<cfinvokeargument Name="productID" Value="#Variables.thisProductID#">
			</cfinvoke>

			<cfset temp = ArrayClear(Variables.productSpecList)>
			<cfloop Index="count" From="1" To="#Form.productSpecCount#">
				<cfif Form["productSpecName#count#"] is "">
					<cfbreak>
				<cfelse>
					<cfset Variables.productSpecList[count] = StructNew()>
					<cfset Variables.productSpecList[count].productSpecHasImage = Form["productSpecHasImage#count#_#Variables.thisProductID#"]>
					<cfset Variables.productSpecList[count].productSpecValue = Form["productSpecValue#count#_#Variables.thisProductID#"]>
					<cfset Variables.productSpecList[count].productSpecName = Form["productSpecName#count#"]>
				</cfif>
			</cfloop>

			<cfset Variables.thisProductHasSpecs = False>
			<cfif ArrayLen(Variables.productSpecList) is not 0>
				<cfloop Index="count" From="1" To="#ArrayLen(Variables.productSpecList)#">
					<cfif Variables.productSpecList[count].productSpecValue is not "">
						<cfset Variables.thisProductHasSpecs = True>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
				<cfinvokeargument Name="productID" Value="#Variables.thisProductID#">
				<cfif Variables.thisProductHasSpecs is True>
					<cfinvokeargument Name="productHasSpec" Value="1">
				<cfelse>
					<cfinvokeargument Name="productHasSpec" Value="0">
				</cfif>
			</cfinvoke>

			<cfif Variables.thisProductHasSpecs is True>
				<cfinvoke Component="#Application.billingMapping#data.ProductSpec" Method="insertProductSpec" ReturnVariable="isProductSpecInserted">
					<cfinvokeargument Name="productID" Value="#Variables.thisProductID#">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="productSpecList" Value="#Variables.productSpecList#">
				</cfinvoke>
			</cfif>
		</cfloop>

		<cflocation url="index.cfm?method=product.#Variables.doAction#&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
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
<cfinclude template="../../../view/v_product/v_productSpec/form_insertProductChildSpec.cfm">

